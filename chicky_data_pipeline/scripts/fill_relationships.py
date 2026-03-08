#!/usr/bin/env python3
"""Fill word_relationships using WordNet (synonyms, antonyms, hypernyms).

Usage:
  python scripts/fill_relationships.py
"""
from __future__ import annotations

import asyncio
import os
import sys
import uuid

import asyncpg
import nltk
from dotenv import load_dotenv
from nltk.corpus import wordnet as wn

load_dotenv()

for resource in ["wordnet"]:
    try:
        nltk.data.find(f"corpora/{resource}")
    except LookupError:
        nltk.download(resource, quiet=True)


def get_related_words(word: str) -> list[tuple[str, str]]:
    """Return list of (related_word, rel_type) tuples for a word."""
    synsets = wn.synsets(word)
    relations: dict[tuple[str, str], None] = {}

    for synset in synsets[:3]:
        # Synonyms (lemmas in same synset)
        for lemma in synset.lemmas():
            related = lemma.name().replace("_", " ").lower()
            if related != word:
                relations[(related, "synonym")] = None

            # Antonyms
            for antonym in lemma.antonyms():
                ant_word = antonym.name().replace("_", " ").lower()
                relations[(ant_word, "antonym")] = None

        # Hypernyms (more general)
        for hyper in synset.hypernyms()[:2]:
            for lemma in hyper.lemmas()[:2]:
                related = lemma.name().replace("_", " ").lower()
                if related != word:
                    relations[(related, "hypernym")] = None

        # Hyponyms (more specific)
        for hypo in synset.hyponyms()[:3]:
            for lemma in hypo.lemmas()[:1]:
                related = lemma.name().replace("_", " ").lower()
                if related != word:
                    relations[(related, "hyponym")] = None

    return list(relations.keys())[:20]  # Cap at 20 relations per word


async def fill_relationships() -> None:
    dsn = os.getenv("DATABASE_URL")
    if not dsn:
        print("ERROR: DATABASE_URL not set")
        sys.exit(1)

    conn = await asyncpg.connect(dsn)

    # Build a word -> id lookup
    all_words = await conn.fetch("SELECT id, word FROM words")
    word_to_id: dict[str, str] = {row["word"]: str(row["id"]) for row in all_words}

    print(f"Processing relationships for {len(all_words):,} words...")

    inserted = 0
    batch: list[tuple] = []

    for i, row in enumerate(all_words):
        word = row["word"]
        word_id = str(row["id"])
        relations = get_related_words(word)

        for related_word, rel_type in relations:
            related_id = word_to_id.get(related_word)
            if not related_id:
                continue
            batch.append((
                str(uuid.uuid4()),
                word_id,
                related_id,
                rel_type,
                0.8,  # default weight
            ))

        if len(batch) >= 500:
            await conn.executemany(
                """
                INSERT INTO word_relationships (id, word_id_a, word_id_b, rel_type, weight)
                VALUES ($1, $2, $3, $4, $5)
                ON CONFLICT DO NOTHING
                """,
                batch,
            )
            inserted += len(batch)
            batch = []

        if (i + 1) % 1000 == 0:
            print(f"  Progress: {i + 1:,}/{len(all_words):,}  relationships: {inserted:,}", end="\r")

    # Flush remaining
    if batch:
        await conn.executemany(
            """
            INSERT INTO word_relationships (id, word_id_a, word_id_b, rel_type, weight)
            VALUES ($1, $2, $3, $4, $5)
            ON CONFLICT DO NOTHING
            """,
            batch,
        )
        inserted += len(batch)

    await conn.close()
    print(f"\nDone. Inserted {inserted:,} relationships.")


if __name__ == "__main__":
    asyncio.run(fill_relationships())
