from __future__ import annotations

from typing import Any, Literal

from pydantic import BaseModel, Field


class HistoryMessage(BaseModel):
    role: Literal["user", "assistant"]
    content: str


class TextChatRequest(BaseModel):
    session_id: str
    message: str = Field(..., min_length=1, max_length=4000)
    mode: Literal["buddy", "roleplay", "vocabulary"] = "buddy"
    scenario_id: str | None = None
    history: list[HistoryMessage] = Field(default_factory=list)
    learning_words: list[str] = Field(default_factory=list)


class TextChatResponse(BaseModel):
    session_id: str
    content: str
    corrections: list[dict[str, Any]] = Field(default_factory=list)
    message_id: str | None = None


class VoiceChatMessage(BaseModel):
    """WebSocket message format for voice chat."""
    type: Literal["transcript", "response", "error", "done"]
    content: str = ""
    corrections: list[dict[str, Any]] = Field(default_factory=list)


class ScenarioInfo(BaseModel):
    id: str
    title: str
    description: str
    system_prompt: str
    difficulty: str = "intermediate"
