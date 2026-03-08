"""LLM abstraction supporting OpenAI and Anthropic providers with streaming."""
from __future__ import annotations

import json
from typing import AsyncIterator

import anthropic
import openai

from ..config import get_settings


class LLMService:
    def __init__(self) -> None:
        settings = get_settings()
        self._provider = settings.llm_provider
        self._openai_model = settings.openai_model
        self._anthropic_model = settings.anthropic_model

        if self._provider == "openai":
            self._openai_client = openai.AsyncOpenAI(
                api_key=settings.openai_api_key
            )
        else:
            self._anthropic_client = anthropic.AsyncAnthropic(
                api_key=settings.anthropic_api_key
            )

    async def chat_stream(
        self,
        messages: list[dict],
        temperature: float = 0.8,
        max_tokens: int = 1024,
    ) -> AsyncIterator[str]:
        """Yield text chunks from the LLM as they arrive."""
        if self._provider == "openai":
            async for chunk in self._openai_stream(messages, temperature, max_tokens):
                yield chunk
        else:
            async for chunk in self._anthropic_stream(messages, temperature, max_tokens):
                yield chunk

    async def chat_complete(
        self,
        messages: list[dict],
        temperature: float = 0.8,
        max_tokens: int = 1024,
    ) -> str:
        """Return the full response as a string (non-streaming)."""
        result = []
        async for chunk in self.chat_stream(messages, temperature, max_tokens):
            result.append(chunk)
        return "".join(result)

    # ── OpenAI ────────────────────────────────────────────────────────────────

    async def _openai_stream(
        self,
        messages: list[dict],
        temperature: float,
        max_tokens: int,
    ) -> AsyncIterator[str]:
        stream = await self._openai_client.chat.completions.create(
            model=self._openai_model,
            messages=messages,  # type: ignore[arg-type]
            temperature=temperature,
            max_tokens=max_tokens,
            stream=True,
        )
        async for event in stream:
            delta = event.choices[0].delta
            if delta.content:
                yield delta.content

    # ── Anthropic ─────────────────────────────────────────────────────────────

    async def _anthropic_stream(
        self,
        messages: list[dict],
        temperature: float,
        max_tokens: int,
    ) -> AsyncIterator[str]:
        # Anthropic uses a separate system parameter
        system_content = ""
        filtered_messages = []
        for msg in messages:
            if msg["role"] == "system":
                system_content = msg["content"]
            else:
                filtered_messages.append(msg)

        kwargs: dict = {
            "model": self._anthropic_model,
            "messages": filtered_messages,
            "temperature": temperature,
            "max_tokens": max_tokens,
        }
        if system_content:
            kwargs["system"] = system_content

        async with self._anthropic_client.messages.stream(**kwargs) as stream:
            async for text in stream.text_stream:
                yield text


# Singleton
_llm_service: LLMService | None = None


def get_llm_service() -> LLMService:
    global _llm_service
    if _llm_service is None:
        _llm_service = LLMService()
    return _llm_service
