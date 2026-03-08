"""OpenAI Whisper transcription service."""
from __future__ import annotations

import io

import openai

from ..config import get_settings


class WhisperService:
    def __init__(self) -> None:
        settings = get_settings()
        self._client = openai.AsyncOpenAI(api_key=settings.openai_api_key)
        self._model = settings.whisper_model

    async def transcribe(
        self,
        audio_bytes: bytes,
        filename: str = "audio.wav",
        language: str | None = None,
        prompt: str | None = None,
    ) -> str:
        """Transcribe audio bytes using OpenAI Whisper.

        Args:
            audio_bytes: Raw audio data (WAV, MP3, WebM, etc.)
            filename: Filename hint so the API knows the format.
            language: ISO 639-1 language code (e.g. 'en'). None = auto-detect.
            prompt: Optional context prompt to improve accuracy.

        Returns:
            Transcribed text string.
        """
        audio_file = io.BytesIO(audio_bytes)
        audio_file.name = filename

        kwargs: dict = {
            "model": self._model,
            "file": audio_file,
            "response_format": "text",
        }
        if language:
            kwargs["language"] = language
        if prompt:
            kwargs["prompt"] = prompt

        response = await self._client.audio.transcriptions.create(**kwargs)
        # response is a plain string when response_format="text"
        return str(response).strip()


_whisper_service: WhisperService | None = None


def get_whisper_service() -> WhisperService:
    global _whisper_service
    if _whisper_service is None:
        _whisper_service = WhisperService()
    return _whisper_service
