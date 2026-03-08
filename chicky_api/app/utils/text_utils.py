from __future__ import annotations

import re


# Sentence boundary pattern — handles abbreviations poorly but works for TTS chunking
_SENTENCE_END = re.compile(r'(?<=[.!?])\s+')
_CLAUSE_BOUNDARY = re.compile(r'(?<=[,;:])\s+')


def split_into_sentences(text: str, min_length: int = 20) -> list[str]:
    """Split text into sentence chunks suitable for TTS streaming.

    Sentences shorter than `min_length` chars are merged with the next one
    to avoid excessive TTS requests for very short fragments.
    """
    if not text.strip():
        return []

    # Split on sentence boundaries first
    raw = _SENTENCE_END.split(text.strip())

    # Merge short fragments
    merged: list[str] = []
    buffer = ""

    for part in raw:
        part = part.strip()
        if not part:
            continue
        if buffer:
            combined = f"{buffer} {part}"
            if len(buffer) < min_length:
                buffer = combined
                continue
            merged.append(buffer)
            buffer = part
        else:
            buffer = part

    if buffer:
        merged.append(buffer)

    return merged


def clean_for_tts(text: str) -> str:
    """Strip markdown and special characters unsuitable for TTS."""
    # Remove markdown bold/italic
    text = re.sub(r'\*{1,3}(.*?)\*{1,3}', r'\1', text)
    text = re.sub(r'_{1,3}(.*?)_{1,3}', r'\1', text)
    # Remove inline code
    text = re.sub(r'`{1,3}[^`]*`{1,3}', '', text)
    # Remove URLs
    text = re.sub(r'https?://\S+', '', text)
    # Remove excessive whitespace
    text = re.sub(r'\s+', ' ', text)
    return text.strip()


def extract_correction_json(text: str) -> list[dict]:
    """Try to parse a JSON corrections block embedded in LLM response.

    The LLM is instructed to embed corrections as:
    <corrections>[{"type": "grammar", "original": "...", "corrected": "...", "explanation": "..."}]</corrections>
    """
    match = re.search(r'<corrections>(.*?)</corrections>', text, re.DOTALL)
    if not match:
        return []
    import json
    try:
        return json.loads(match.group(1).strip())
    except (json.JSONDecodeError, ValueError):
        return []
