"""Edge TTS wrapper for text-to-speech synthesis."""
from __future__ import annotations

import asyncio
import io
import tempfile
from pathlib import Path

import edge_tts

from ..config import get_settings
from ..utils.text_utils import clean_for_tts, split_into_sentences


class TTSService:
    def __init__(self) -> None:
        settings = get_settings()
        self._voice = settings.tts_voice
        self._rate = settings.tts_rate
        self._pitch = settings.tts_pitch

    async def tts_sentence(self, text: str) -> bytes:
        """Synthesize a single sentence/chunk into MP3 bytes."""
        text = clean_for_tts(text)
        if not text:
            return b""

        communicate = edge_tts.Communicate(
            text=text,
            voice=self._voice,
            rate=self._rate,
            pitch=self._pitch,
        )

        audio_chunks = []
        async for chunk in communicate.stream():
            if chunk["type"] == "audio":
                audio_chunks.append(chunk["data"])

        return b"".join(audio_chunks)

    async def synthesize(self, text: str) -> bytes:
        """Synthesize full text, splitting into sentences for reliability."""
        sentences = split_into_sentences(text)
        if not sentences:
            return await self.tts_sentence(text)

        tasks = [self.tts_sentence(s) for s in sentences]
        results = await asyncio.gather(*tasks)
        return b"".join(results)

    async def synthesize_streaming(self, text: str):
        """Async generator yielding MP3 audio chunks as each sentence finishes."""
        sentences = split_into_sentences(text)
        if not sentences:
            chunk = await self.tts_sentence(text)
            if chunk:
                yield chunk
            return

        for sentence in sentences:
            chunk = await self.tts_sentence(sentence)
            if chunk:
                yield chunk

    async def list_voices(self) -> list[dict]:
        """Return available Edge TTS voices."""
        voices = await edge_tts.list_voices()
        return [
            {
                "name": v["Name"],
                "short_name": v["ShortName"],
                "locale": v["Locale"],
                "gender": v["Gender"],
            }
            for v in voices
        ]


_tts_service: TTSService | None = None


def get_tts_service() -> TTSService:
    global _tts_service
    if _tts_service is None:
        _tts_service = TTSService()
    return _tts_service
