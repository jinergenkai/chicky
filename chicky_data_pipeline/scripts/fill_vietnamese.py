#!/usr/bin/env python3
"""Add Vietnamese translations to words using AI API.

Usage:
  python scripts/fill_vietnamese.py [--limit 500] [--batch 30]
"""
from __future__ import annotations

import argparse
import asyncio
import json
import os
import sys

import asyncpg
from anthropic import AsyncAnthropic
from dotenv import load_dotenv

load_dotenv()


async def translate_batch(
    client: AsyncAnthropic,
    words: list[str],
) -> dict[str, str]:
    """Returns {word: vietnamese_translation} for a batch."""

    prompt = f"""Translate these English words/phrases to Vietnamese (provide the most common/natural Vietnamese equivalent).
For each word, give only the primary Vietnamese translation — no explanations, no romanization, just the Vietnamese text.

Words: {json.dumps(words)}

Respond with valid JSON only: {{"english_word": "vietnamese_translation", ...}}
JSON:"""

    response = await client.messages.create(
        model=os.getenv("ANTHROPIC_MODEL", "claude-3-5-haiku-20241022"),
        max_tokens=2048,
        messages=[{"role": "user", "content": prompt}],
    )

    text = response.content[0].text.strip()
    if text.startswith("```"):
        text = text.split("\n", 1)[-1].rsplit("```", 1)[0].strip()

    try:
        return json.loads(text)
    except json.JSONDecodeError:
        return {}


async def fill_vietnamese(limit: int | None, batch_size: int) -> None:
    dsn = os.getenv("DATABASE_URL")
    if not dsn:
        print("ERROR: DATABASE_URL not set")
        sys.exit(1)

    anthropic_key = os.getenv("ANTHROPIC_API_KEY")
    if not anthropic_key:
        print("ERROR: ANTHROPIC_API_KEY not set")
        sys.exit(1)

    client = AsyncAnthropic(api_key=anthropic_key)
    conn = await asyncpg.connect(dsn)

    query = "SELECT id, word FROM words WHERE vi_translation IS NULL ORDER BY frequency_rank NULLS LAST"
    if limit:
        query += f" LIMIT {limit}"

    rows = await conn.fetch(query)
    words = [{"id": str(r["id"]), "word": r["word"]} for r in rows]
    print(f"Translating {len(words):,} words to Vietnamese...")

    updated = 0

    for i in range(0, len(words), batch_size):
        batch = words[i : i + batch_size]
        word_texts = [w["word"] for w in batch]
        word_id_map = {w["word"]: w["id"] for w in batch}

        try:
            translations = await translate_batch(client, word_texts)

            for word_text, vi_text in translations.items():
                word_id = word_id_map.get(word_text)
                if word_id and vi_text:
                    await conn.execute(
                        "UPDATE words SET vi_translation = $1 WHERE id = $2",
                        vi_text,
                        word_id,
                    )
                    updated += 1
        except Exception as exc:
            print(f"\nError at batch {i // batch_size}: {exc}")

        print(
            f"  Progress: {min(i + batch_size, len(words)):,}/{len(words):,}  translated: {updated:,}",
            end="\r",
        )
        await asyncio.sleep(0.3)

    await conn.close()
    print(f"\nDone. Translated {updated:,} words.")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--limit", type=int, default=None)
    parser.add_argument("--batch", type=int, default=30)
    args = parser.parse_args()
    asyncio.run(fill_vietnamese(args.limit, args.batch))


if __name__ == "__main__":
    main()
