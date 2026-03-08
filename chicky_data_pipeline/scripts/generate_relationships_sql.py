#!/usr/bin/env python3
"""Generate word_relationships SQL from WordNet (synonyms, antonyms, word_form/hypernym).
Reads words already in words_seed.sql, outputs relationships_seed.sql."""
from __future__ import annotations
import json, re
from pathlib import Path
import nltk
from nltk.corpus import wordnet as wn

for c in ['wordnet', 'omw-1.4']:
    try: nltk.data.find(f'corpora/{c}')
    except LookupError: nltk.download(c, quiet=True)

DATA = Path(__file__).parent.parent / 'data'

# Load words from words_seed.sql
print("Loading words from words_seed.sql...")
words_file = DATA / 'words_seed.sql'
words = set()
for line in words_file.read_text(encoding='utf-8').splitlines():
    m = re.match(r"INSERT INTO words \(word,.*?\) VALUES \('([^']+)'", line)
    if m:
        words.add(m.group(1))
print(f"  Found {len(words)} words")

pos_map = {'n': 'noun', 'v': 'verb', 'a': 'adjective', 'r': 'adverb', 's': 'adjective'}

# Collect relationships
rels = []  # (word1, word2, rel_type, strength)
seen = set()

def add(w1, w2, rel, strength):
    if w1 == w2: return
    key = (min(w1,w2), max(w1,w2), rel)
    if key in seen: return
    seen.add(key)
    rels.append((w1, w2, rel, strength))

print("Building relationships from WordNet...")
for word in words:
    synsets = wn.synsets(word)
    for syn in synsets[:3]:
        # Synonyms (other lemmas in same synset)
        for lemma in syn.lemmas():
            target = lemma.name().replace('_', ' ')
            if target != word and target in words:
                add(word, target, 'synonym', 0.9)
            # Antonyms
            for ant in lemma.antonyms():
                ant_word = ant.name().replace('_', ' ')
                if ant_word in words:
                    add(word, ant_word, 'antonym', 0.9)

        # Hypernyms (word_form / related)
        for hyper in syn.hypernyms()[:2]:
            for lemma in hyper.lemmas():
                target = lemma.name().replace('_', ' ')
                if target != word and target in words:
                    add(word, target, 'domain_related', 0.5)

        # Hyponyms (more specific)
        for hypo in syn.hyponyms()[:2]:
            for lemma in hypo.lemmas():
                target = lemma.name().replace('_', ' ')
                if target != word and target in words:
                    add(word, target, 'domain_related', 0.4)

print(f"  Found {len(rels)} relationships")

# Write SQL
out = DATA / 'relationships_seed.sql'
with open(out, 'w', encoding='utf-8') as f:
    f.write("-- Word relationships seed (synonyms, antonyms, domain_related)\n")
    f.write("-- Run AFTER all_migrations.sql and words_seed.sql\n\n")
    for w1, w2, rel, strength in rels:
        w1e = w1.replace("'","''")
        w2e = w2.replace("'","''")
        f.write(
            f"INSERT INTO word_relationships (source_word_id, target_word_id, rel_type, strength, verified)\n"
            f"SELECT s.id, t.id, '{rel}', {strength}, true\n"
            f"FROM words s, words t\n"
            f"WHERE s.word = '{w1e}' AND t.word = '{w2e}'\n"
            f"ON CONFLICT DO NOTHING;\n"
        )
        # Bidirectional for synonym/antonym
        if rel in ('synonym', 'antonym'):
            f.write(
                f"INSERT INTO word_relationships (source_word_id, target_word_id, rel_type, strength, verified)\n"
                f"SELECT s.id, t.id, '{rel}', {strength}, true\n"
                f"FROM words s, words t\n"
                f"WHERE s.word = '{w2e}' AND t.word = '{w1e}'\n"
                f"ON CONFLICT DO NOTHING;\n"
            )

print(f"Written: {out}")
