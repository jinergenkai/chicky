#!/usr/bin/env python3
"""Fill definitions and example_sentences using NLTK WordNet.

Usage:
  python scripts/fill_definitions.py
"""
from __future__ import annotations

import asyncio
import json
import os
import sys

import asyncpg
import nltk
from dotenv import load_dotenv
from nltk.corpus import wordnet as wn

load_dotenv()

# Download WordNet data if not present
for resource in ["wordnet", "omw-1.4"]:
    try:
        nltk.data.find(f"corpora/{resource}")
    except LookupError:
        print(f"Downloading NLTK resource: {resource}")
        nltk.download(resource, quiet=True)


def get_definitions(word: str) -> tuple[list[dict], list[str]]:
    """Return (definitions, examples) from WordNet for a word."""
    synsets = wn.synsets(word)
    if not synsets:
        return [], []

    pos_map = {
        "n": "noun",
        "v": "verb",
        "a": "adjective",
        "s": "adjective",
        "r": "adverb",
    }

    # Group by POS
    by_pos: dict[str, list[str]] = {}
    examples: list[str] = []

    for synset in synsets[:6]:
        pos = pos_map.get(synset.pos(), synset.pos())
        defn = synset.definition()
        if defn:
            by_pos.setdefault(pos, []).append(defn)
        for ex in synset.examples()[:2]:
            if ex not in examples:
                examples.append(ex)

    definitions = [
        {"pos": pos, "definitions": defs[:3]}
        for pos, defs in by_pos.items()
    ]

    return definitions, examples[:5]


async def fill_definitions() -> None:
    dsn = os.getenv("DATABASE_URL")
    if not dsn:
        print("ERROR: DATABASE_URL not set")
        sys.exit(1)

    conn = await asyncpg.connect(dsn)

    rows = await conn.fetch(
        "SELECT id, word FROM words WHERE definitions = '[]'::jsonb OR definitions IS NULL"
    )
    print(f"Processing {len(rows):,} words...")

    updated = 0
    no_data = 0

    for i, row in enumerate(rows):
        definitions, examples = get_definitions(row["word"])

        if definitions:
            await conn.execute(
                """
                UPDATE words
                SET definitions = $1::jsonb,
                    example_sentences = $2
                WHERE id = $3
                """,
                json.dumps(definitions),
                examples,
                row["id"],
            )
            updated += 1
        else:
            no_data += 1

        if (i + 1) % 500 == 0:
            print(f"  Progress: {i + 1:,}/{len(rows):,}  (updated={updated}, no_data={no_data})", end="\r")

    await conn.close()
    print(f"\nDone. Updated: {updated:,}  No WordNet data: {no_data:,}")


if __name__ == "__main__":
    asyncio.run(fill_definitions())
