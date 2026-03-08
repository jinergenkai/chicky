from __future__ import annotations

from typing import Any

from pydantic import BaseModel, Field


class WordLookupRequest(BaseModel):
    word: str = Field(..., min_length=1, max_length=100)


class DefinitionEntry(BaseModel):
    pos: str
    definitions: list[str]
    examples: list[str] = Field(default_factory=list)


class WordLookupResponse(BaseModel):
    id: str | None = None
    word: str
    ipa: str | None = None
    definitions: list[dict[str, Any]] = Field(default_factory=list)
    cefr_level: str | None = None
    frequency_rank: int | None = None
    example_sentences: list[str] = Field(default_factory=list)
    verified: bool = False
    source: str = "dictionary_api"
