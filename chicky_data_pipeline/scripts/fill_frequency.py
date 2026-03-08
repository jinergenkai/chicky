#!/usr/bin/env python3
"""Fill frequency_rank for all words using the wordfreq library.

Usage:
  python scripts/fill_frequency.py
"""
from __future__ import annotations

import asyncio
import os
import sys

import asyncpg
from dotenv import load_dotenv
from wordfreq import word_frequency, zipf_frequency

load_dotenv()


async def fill_frequency() -> None:
    dsn = os.getenv("DATABASE_URL")
    if not dsn:
        print("ERROR: DATABASE_URL not set")
        sys.exit(1)

    conn = await asyncpg.connect(dsn)

    # Fetch all words
    rows = await conn.fetch("SELECT id, word FROM words WHERE frequency_rank IS NULL")
    print(f"Found {len(rows):,} words without frequency data")

    updates = []
    for row in rows:
        word = row["word"]
        # zipf_frequency returns a score 0-8 (higher = more common)
        # Convert to a rank: lower rank = more common
        zipf = zipf_frequency(word, "en")
        if zipf > 0:
            # Map zipf score to rank: zipf 8 -> rank 1, zipf 1 -> rank ~10_000_000
            rank = int(10 ** (8 - zipf))
        else:
            rank = 9_999_999

        updates.append((rank, row["id"]))

    print(f"Updating {len(updates):,} frequency ranks...")

    batch_size = 1000
    for i in range(0, len(updates), batch_size):
        batch = updates[i : i + batch_size]
        await conn.executemany(
            "UPDATE words SET frequency_rank = $1 WHERE id = $2",
            batch,
        )
        print(f"  Progress: {min(i + batch_size, len(updates)):,}/{len(updates):,}", end="\r")

    await conn.close()
    print(f"\nDone. Updated {len(updates):,} words with frequency data.")


if __name__ == "__main__":
    asyncio.run(fill_frequency())
