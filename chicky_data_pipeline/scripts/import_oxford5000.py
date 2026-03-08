#!/usr/bin/env python3
"""Import Oxford 5000 CSV into the words table.

Expected CSV columns:
  word, cefr_level, pos (part of speech)

Usage:
  python scripts/import_oxford5000.py --file data/oxford5000.csv
"""
from __future__ import annotations

import argparse
import asyncio
import csv
import sys
import uuid
from pathlib import Path

import asyncpg
from dotenv import load_dotenv
import os

load_dotenv()


async def import_words(csv_path: Path, batch_size: int = 500) -> None:
    dsn = os.getenv("DATABASE_URL")
    if not dsn:
        print("ERROR: DATABASE_URL not set in .env")
        sys.exit(1)

    conn = await asyncpg.connect(dsn)

    words = []
    with open(csv_path, newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            word = row.get("word", "").strip().lower()
            cefr = row.get("cefr_level", row.get("cefr", "")).strip().upper()
            if not word:
                continue
            words.append({
                "id": str(uuid.uuid4()),
                "word": word,
                "cefr_level": cefr or None,
                "verified": True,
            })

    print(f"Importing {len(words):,} words...")

    inserted = 0
    skipped = 0

    for i in range(0, len(words), batch_size):
        batch = words[i : i + batch_size]
        try:
            await conn.executemany(
                """
                INSERT INTO words (id, word, cefr_level, verified)
                VALUES ($1, $2, $3, $4)
                ON CONFLICT (word) DO UPDATE
                    SET cefr_level = EXCLUDED.cefr_level,
                        verified   = EXCLUDED.verified
                """,
                [(w["id"], w["word"], w["cefr_level"], w["verified"]) for w in batch],
            )
            inserted += len(batch)
            print(f"  Progress: {inserted:,}/{len(words):,}", end="\r")
        except Exception as exc:
            print(f"\nBatch error at offset {i}: {exc}")
            skipped += len(batch)

    await conn.close()
    print(f"\nDone. Inserted/updated: {inserted:,}  Skipped: {skipped:,}")


def main() -> None:
    parser = argparse.ArgumentParser(description="Import Oxford 5000 words from CSV")
    parser.add_argument(
        "--file",
        required=True,
        type=Path,
        help="Path to the Oxford 5000 CSV file",
    )
    parser.add_argument(
        "--batch-size",
        type=int,
        default=500,
        help="Number of rows per DB batch (default: 500)",
    )
    args = parser.parse_args()

    if not args.file.exists():
        print(f"ERROR: File not found: {args.file}")
        sys.exit(1)

    asyncio.run(import_words(args.file, args.batch_size))


if __name__ == "__main__":
    main()
