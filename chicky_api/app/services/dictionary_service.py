"""Free Dictionary API integration for word lookups."""
from __future__ import annotations

import httpx

from ..models.scan_models import WordLookupResponse

FREE_DICT_API = "https://api.dictionaryapi.dev/api/v2/entries/en"


async def lookup_unknown_word(word: str) -> WordLookupResponse | None:
    """Look up a word using the Free Dictionary API.

    Returns a WordLookupResponse or None if the word is not found.
    """
    async with httpx.AsyncClient(timeout=10.0) as client:
        try:
            response = await client.get(f"{FREE_DICT_API}/{word.lower()}")
            if response.status_code != 200:
                return None

            data = response.json()
            if not data or not isinstance(data, list):
                return None

            entry = data[0]
            word_text = entry.get("word", word)
            phonetic = _extract_ipa(entry)
            definitions = _extract_definitions(entry)
            examples = _extract_examples(entry)

            return WordLookupResponse(
                word=word_text,
                ipa=phonetic,
                definitions=definitions,
                example_sentences=examples[:3],
                source="dictionary_api",
            )

        except (httpx.RequestError, ValueError, KeyError):
            return None


def _extract_ipa(entry: dict) -> str | None:
    """Extract IPA phonetic from entry."""
    # Try top-level phonetic field
    if phonetic := entry.get("phonetic"):
        return phonetic.lstrip("/").rstrip("/")

    # Try phonetics array
    phonetics = entry.get("phonetics", [])
    for p in phonetics:
        if text := p.get("text"):
            return text.lstrip("/").rstrip("/")

    return None


def _extract_definitions(entry: dict) -> list[dict]:
    """Extract definitions grouped by part of speech."""
    meanings = entry.get("meanings", [])
    result = []

    for meaning in meanings:
        pos = meaning.get("partOfSpeech", "")
        defs = [
            d.get("definition", "")
            for d in meaning.get("definitions", [])[:3]
            if d.get("definition")
        ]
        if defs:
            result.append({"pos": pos, "definitions": defs})

    return result


def _extract_examples(entry: dict) -> list[str]:
    """Extract example sentences from all meanings."""
    examples = []
    for meaning in entry.get("meanings", []):
        for defn in meaning.get("definitions", []):
            if ex := defn.get("example"):
                examples.append(ex)
    return examples


class DictionaryService:
    """Async dictionary service wrapping the Free Dictionary API."""

    async def lookup(self, word: str) -> WordLookupResponse | None:
        return await lookup_unknown_word(word)

    async def lookup_batch(self, words: list[str]) -> dict[str, WordLookupResponse | None]:
        """Look up multiple words concurrently."""
        import asyncio
        results = await asyncio.gather(
            *[self.lookup(w) for w in words],
            return_exceptions=False,
        )
        return dict(zip(words, results))


_dict_service: DictionaryService | None = None


def get_dictionary_service() -> DictionaryService:
    global _dict_service
    if _dict_service is None:
        _dict_service = DictionaryService()
    return _dict_service
