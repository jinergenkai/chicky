#!/usr/bin/env python3
"""Tag words with domains using AI API.

Sends batches of words to an LLM and asks it to classify each word
into one or more domains from the seed hierarchy.

Usage:
  python scripts/fill_domains.py [--limit 1000] [--batch 20]
"""
from __future__ import annotations

import argparse
import asyncio
import json
import os
import sys
import uuid
from pathlib import Path

import asyncpg
from anthropic import AsyncAnthropic
from dotenv import load_dotenv

load_dotenv()

DOMAINS_SEED = Path(__file__).parent.parent / "data" / "domains_seed.json"


async def classify_batch(
    client: AsyncAnthropic,
    words: list[str],
    domain_names: list[str],
) -> dict[str, list[str]]:
    """Returns {word: [domain_name, ...]} for a batch of words."""

    prompt = f"""You are a lexicographer. For each English word below, identify which domains from the list it belongs to.
A word can belong to multiple domains or none.

DOMAINS: {", ".join(domain_names)}

WORDS: {json.dumps(words)}

Respond with valid JSON only — a dict mapping each word to a list of matching domain names.
Example: {{"coffee": ["Food & Drink", "Daily Life"], "algorithm": ["Technology", "Science"]}}

If a word doesn't clearly belong to any domain, map it to an empty list.
JSON response:"""

    response = await client.messages.create(
        model=os.getenv("ANTHROPIC_MODEL", "claude-3-5-haiku-20241022"),
        max_tokens=2048,
        messages=[{"role": "user", "content": prompt}],
    )

    text = response.content[0].text.strip()
    # Strip markdown code blocks if present
    if text.startswith("```"):
        text = text.split("\n", 1)[-1].rsplit("```", 1)[0].strip()

    try:
        return json.loads(text)
    except json.JSONDecodeError:
        return {}


async def fill_domains(limit: int | None, batch_size: int) -> None:
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

    # Load domain hierarchy
    with open(DOMAINS_SEED) as f:
        seed = json.load(f)
    domain_names = [d["name"] for d in seed["domains"]]

    # Build domain name -> id map
    domain_rows = await conn.fetch("SELECT id, name FROM domains")
    domain_id_map = {row["name"]: str(row["id"]) for row in domain_rows}

    # Fetch words not yet tagged
    query = """
        SELECT w.id, w.word FROM words w
        WHERE NOT EXISTS (
            SELECT 1 FROM domain_words dw WHERE dw.word_id = w.id
        )
        ORDER BY w.frequency_rank NULLS LAST
    """
    if limit:
        query += f" LIMIT {limit}"

    rows = await conn.fetch(query)
    words = [{"id": str(r["id"]), "word": r["word"]} for r in rows]
    print(f"Tagging {len(words):,} words with domains...")

    total_tagged = 0

    for i in range(0, len(words), batch_size):
        batch = words[i : i + batch_size]
        word_texts = [w["word"] for w in batch]
        word_id_map = {w["word"]: w["id"] for w in batch}

        try:
            classifications = await classify_batch(client, word_texts, domain_names)

            inserts: list[tuple] = []
            for word_text, domains in classifications.items():
                word_id = word_id_map.get(word_text)
                if not word_id:
                    continue
                for domain_name in domains:
                    domain_id = domain_id_map.get(domain_name)
                    if domain_id:
                        inserts.append((str(uuid.uuid4()), word_id, domain_id))

            if inserts:
                await conn.executemany(
                    "INSERT INTO domain_words (id, word_id, domain_id) VALUES ($1, $2, $3) ON CONFLICT DO NOTHING",
                    inserts,
                )
                total_tagged += len(inserts)

        except Exception as exc:
            print(f"\nError at batch {i // batch_size}: {exc}")

        print(
            f"  Progress: {min(i + batch_size, len(words)):,}/{len(words):,}  tagged: {total_tagged:,}",
            end="\r",
        )

        # Rate limit pause
        await asyncio.sleep(0.5)

    await conn.close()
    print(f"\nDone. Tagged {total_tagged:,} word-domain pairs.")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--limit", type=int, default=None)
    parser.add_argument("--batch", type=int, default=20)
    args = parser.parse_args()
    asyncio.run(fill_domains(args.limit, args.batch))


if __name__ == "__main__":
    main()
