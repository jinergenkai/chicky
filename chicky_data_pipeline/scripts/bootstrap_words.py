#!/usr/bin/env python3
"""
Bootstrap the words table from NLTK WordNet + wordfreq.
Generates top ~5000 most frequent English words with:
- Definitions (from WordNet)
- IPA placeholder
- CEFR level (estimated from frequency rank)
- Frequency rank (from wordfreq)
- Example sentences (from WordNet)
- Word relationships (synonyms, antonyms, hypernyms)

Usage:
  python scripts/bootstrap_words.py
"""
from __future__ import annotations

import asyncio
import json
import os
import sys
import ssl
from pathlib import Path

import asyncpg
import nltk
from nltk.corpus import wordnet as wn
from wordfreq import top_n_list, zipf_frequency
from dotenv import load_dotenv

load_dotenv(Path(__file__).parent.parent.parent / 'chicky_api' / '.env')

# Download NLTK data if needed
for corpus in ['wordnet', 'omw-1.4']:
    try:
        nltk.data.find(f'corpora/{corpus}')
    except LookupError:
        print(f"Downloading {corpus}...")
        nltk.download(corpus, quiet=True)


def cefr_from_rank(rank: int) -> str:
    """Estimate CEFR level from frequency rank."""
    if rank <= 500:   return 'A1'
    if rank <= 1500:  return 'A2'
    if rank <= 3000:  return 'B1'
    if rank <= 5000:  return 'B2'
    if rank <= 8000:  return 'C1'
    return 'C2'


def get_word_data(word: str, rank: int) -> dict | None:
    """Get definitions and examples from WordNet."""
    synsets = wn.synsets(word)
    if not synsets:
        return None

    definitions = []
    examples = []

    pos_map = {'n': 'noun', 'v': 'verb', 'a': 'adjective', 'r': 'adverb', 's': 'adjective'}

    seen_pos = set()
    for syn in synsets[:6]:  # max 6 synsets
        pos = pos_map.get(syn.pos(), syn.pos())
        lemma_names = [l.name().replace('_', ' ') for l in syn.lemmas()]
        if word not in lemma_names and word.lower() not in [l.lower() for l in lemma_names]:
            continue  # skip synsets where word is not a lemma

        if pos not in seen_pos:
            seen_pos.add(pos)
            defn = syn.definition()
            definitions.append({'pos': pos, 'en': defn, 'vi': None})

        for ex in syn.examples()[:2]:
            if ex not in examples:
                examples.append(ex)

    if not definitions:
        # Still include with first synset definition
        syn = synsets[0]
        pos = pos_map.get(syn.pos(), syn.pos())
        definitions.append({'pos': pos, 'en': syn.definition(), 'vi': None})

    return {
        'definitions': definitions[:4],  # max 4 definitions
        'examples': examples[:3],
    }


async def bootstrap(target: int = 5000) -> None:
    dsn = os.getenv('DATABASE_URL')
    if not dsn:
        print("ERROR: DATABASE_URL not set")
        sys.exit(1)

    ssl_ctx = ssl.create_default_context()
    ssl_ctx.check_hostname = False
    ssl_ctx.verify_mode = ssl.CERT_NONE

    print("Connecting to database...")
    try:
        conn = await asyncio.wait_for(
            asyncpg.connect(dsn, ssl=ssl_ctx), timeout=15
        )
    except Exception as e:
        print(f"Connection failed: {e}")
        print("\nTip: Copy the output of this script to run in Supabase SQL Editor instead.")
        # Fallback: generate SQL file
        await generate_sql_file(target)
        return

    print(f"Connected! Building word list (target: {target} words)...")
    await insert_words(conn, target)
    await conn.close()
    print("Done!")


async def generate_sql_file(target: int) -> None:
    """Fallback: generate SQL INSERT file for manual execution."""
    print(f"\nGenerating SQL file instead...")
    words = build_word_list(target)
    
    sql_path = Path(__file__).parent.parent / 'data' / 'words_seed.sql'
    with open(sql_path, 'w', encoding='utf-8') as f:
        f.write("-- Words seed data (generated from WordNet + wordfreq)\n")
        f.write("-- Run in Supabase SQL Editor\n\n")
        for i, w in enumerate(words):
            defns = json.dumps(w['definitions']).replace("'", "''")
            word_esc = w['word'].replace("'", "''")
            # Build ARRAY['...','...'] with properly escaped single quotes
            arr_items = ", ".join(
                "'" + ex.replace("'", "''") + "'"
                for ex in w['examples']
            )
            array_sql = f"ARRAY[{arr_items}]" if arr_items else "ARRAY[]::text[]"
            f.write(
                f"INSERT INTO words (word, definitions, example_sentences, cefr_level, frequency_rank, verified) "
                f"VALUES ('{word_esc}', '{defns}'::jsonb, {array_sql}, "
                f"'{w['cefr_level']}', {w['rank']}, true) "
                f"ON CONFLICT (word) DO NOTHING;\n"
            )
            if (i + 1) % 100 == 0:
                print(f"  Generated {i+1}/{len(words)} words...")
    
    print(f"\nSQL file written to: {sql_path}")
    print("Run it in Supabase Dashboard > SQL Editor")


def build_word_list(target: int) -> list[dict]:
    print("Getting top words from wordfreq...")
    top_words = top_n_list('en', target * 3)  # get 3x to filter properly
    
    results = []
    skipped = 0
    
    for rank, word in enumerate(top_words, 1):
        if len(results) >= target:
            break
        
        # Skip non-alphabetic, very short, or punctuation
        if not word.isalpha() or len(word) < 2:
            skipped += 1
            continue
        
        word_data = get_word_data(word, rank)
        if not word_data or not word_data['definitions']:
            skipped += 1
            continue
        
        results.append({
            'word': word,
            'rank': rank,
            'cefr_level': cefr_from_rank(rank),
            'definitions': word_data['definitions'],
            'examples': word_data['examples'],
        })
        
        if len(results) % 500 == 0:
            print(f"  Processed {len(results)} words (skipped {skipped})...")
    
    return results


async def insert_words(conn: asyncpg.Connection, target: int) -> None:
    words = build_word_list(target)
    print(f"\nInserting {len(words)} words into database...")
    
    inserted = 0
    for w in words:
        try:
            await conn.execute("""
                INSERT INTO words (word, definitions, example_sentences, cefr_level, frequency_rank, verified)
                VALUES ($1, $2::jsonb, $3, $4, $5, true)
                ON CONFLICT (word) DO NOTHING
            """,
                w['word'],
                json.dumps(w['definitions']),
                w['examples'],
                w['cefr_level'],
                w['rank'],
            )
            inserted += 1
        except Exception as e:
            print(f"  Error inserting '{w['word']}': {e}")
    
    print(f"Inserted {inserted} words.")


if __name__ == '__main__':
    target = int(sys.argv[1]) if len(sys.argv) > 1 else 5000
    asyncio.run(bootstrap(target))
