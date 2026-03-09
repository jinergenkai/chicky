"""Chat router — text endpoint + voice WebSocket."""
from __future__ import annotations

import json
from typing import Any

from fastapi import APIRouter, Depends, HTTPException, WebSocket, WebSocketDisconnect
from fastapi.responses import StreamingResponse

from ..database import fetch_all
from ..models.chat_models import TextChatRequest
from ..services.llm_service import get_llm_service
from ..services.prompt_builder import (
    build_buddy_prompt,
    build_roleplay_prompt,
    get_scenario_prompt,
)
from ..services.tts_service import get_tts_service
from ..services.whisper_service import get_whisper_service
from ..utils.auth import get_current_user, verify_supabase_jwt
from ..utils.text_utils import extract_correction_json

router = APIRouter()


# ── POST /chat/text ───────────────────────────────────────────────────────────

@router.post("/text")
async def chat_text(
    request: TextChatRequest,
    user: dict[str, Any] = Depends(get_current_user),
):
    """Stream LLM response for a text chat message.

    Returns an SSE stream: each event is JSON {"content": "..."}
    Final event is "data: [DONE]\\n\\n"
    """
    llm = get_llm_service()

    # Build history in the format the LLM expects
    history = [{"role": m.role, "content": m.content} for m in request.history]
    history.append({"role": "user", "content": request.message})

    if request.mode == "buddy":
        messages = build_buddy_prompt(history)
    else:
        scenario_prompt = get_scenario_prompt(request.scenario_id or "coffee_shop")
        messages = build_roleplay_prompt(scenario_prompt, history)

    async def event_stream():
        try:
            async for chunk in llm.chat_stream(messages):
                data = json.dumps({"content": chunk})
                yield f"data: {data}\n\n"
            yield "data: [DONE]\n\n"
        except Exception as exc:
            error_data = json.dumps({"error": str(exc)})
            yield f"data: {error_data}\n\n"
            yield "data: [DONE]\n\n"

    return StreamingResponse(
        event_stream(),
        media_type="text/event-stream",
        headers={
            "Cache-Control": "no-cache",
            "X-Accel-Buffering": "no",
        },
    )


# ── WS /chat/voice ────────────────────────────────────────────────────────────

@router.websocket("/voice")
async def chat_voice(
    websocket: WebSocket,
    session_id: str,
    token: str,
):
    """Voice chat WebSocket.

    Protocol:
    1. Client sends raw audio bytes (WAV, 16kHz, mono)
    2. Server transcribes via Whisper
    3. Server streams LLM response back as text chunks
    4. Server synthesizes each sentence to audio and sends bytes
    5. Server sends JSON {"type": "done"} to signal completion

    Auth: JWT token passed as query param.
    """
    # Verify token before accepting
    try:
        user = await verify_supabase_jwt(token)
    except Exception:
        await websocket.close(code=4001, reason="Unauthorized")
        return

    await websocket.accept()
    llm = get_llm_service()
    whisper = get_whisper_service()
    tts = get_tts_service()

    try:
        while True:
            # Receive audio bytes from client
            audio_data = await websocket.receive_bytes()
            if not audio_data:
                continue

            # Step 1: Transcribe
            try:
                transcript = await whisper.transcribe(audio_data, language="en")
            except Exception as exc:
                await websocket.send_text(
                    json.dumps({"type": "error", "content": str(exc)})
                )
                continue

            # Send transcript back to client
            await websocket.send_text(
                json.dumps({"type": "transcript", "content": transcript})
            )

            # Step 2: Fetch session history from DB for context
            history_rows = await fetch_all(
                """
                SELECT role, content FROM chat_messages
                WHERE session_id = $1
                ORDER BY created_at DESC
                LIMIT 20
                """,
                session_id,
            )
            # Rows come back newest-first; reverse for chronological order
            history = [
                {"role": r["role"], "content": r["content"]}
                for r in reversed(history_rows)
            ]
            history.append({"role": "user", "content": transcript})

            # Step 3: LLM response (buddy mode for voice)
            messages = build_buddy_prompt(history)

            full_response = []
            sentence_buffer = ""

            async for chunk in llm.chat_stream(messages):
                full_response.append(chunk)
                sentence_buffer += chunk

                # Send audio when we have a complete sentence
                if any(c in sentence_buffer for c in ".!?") and len(sentence_buffer) > 20:
                    audio_chunk = await tts.tts_sentence(sentence_buffer.strip())
                    if audio_chunk:
                        await websocket.send_bytes(audio_chunk)
                    sentence_buffer = ""

            # Flush remaining buffer
            if sentence_buffer.strip():
                audio_chunk = await tts.tts_sentence(sentence_buffer.strip())
                if audio_chunk:
                    await websocket.send_bytes(audio_chunk)

            # Signal completion
            response_text = "".join(full_response)
            corrections = extract_correction_json(response_text)
            await websocket.send_text(
                json.dumps({
                    "type": "done",
                    "content": response_text,
                    "corrections": corrections,
                })
            )

    except WebSocketDisconnect:
        pass
    except Exception as exc:
        try:
            await websocket.send_text(
                json.dumps({"type": "error", "content": str(exc)})
            )
        except Exception:
            pass
