"""TTS router — synthesize speech from text."""
from __future__ import annotations

from typing import Any

from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.responses import Response, StreamingResponse
from pydantic import BaseModel, Field

from ..services.tts_service import get_tts_service
from ..utils.auth import get_current_user

router = APIRouter()


class TTSRequest(BaseModel):
    text: str = Field(..., min_length=1, max_length=2000)
    voice: str | None = None
    stream: bool = False


@router.post("")
async def synthesize_speech(
    request: TTSRequest,
    user: dict[str, Any] = Depends(get_current_user),
):
    """Synthesize text to speech using Edge TTS.

    Returns MP3 audio bytes. If stream=True, streams sentence-by-sentence.
    """
    tts = get_tts_service()

    if not request.text.strip():
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Text cannot be empty",
        )

    if request.stream:
        async def audio_stream():
            async for chunk in tts.synthesize_streaming(request.text):
                yield chunk

        return StreamingResponse(
            audio_stream(),
            media_type="audio/mpeg",
            headers={"Content-Disposition": "inline"},
        )

    # Non-streaming: synthesize full audio and return
    audio_bytes = await tts.synthesize(request.text)

    if not audio_bytes:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="TTS synthesis failed",
        )

    return Response(
        content=audio_bytes,
        media_type="audio/mpeg",
        headers={"Content-Disposition": "inline"},
    )
