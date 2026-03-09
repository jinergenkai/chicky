# Data Pipeline — Bootstrap Base Vocabulary

Scripts to populate the `words`, `word_relationships`, `domains`, and `domain_words` tables.

---

## Bootstrap Steps

```
Step 1: Import Oxford 5000 word list
        Source: CSV (freely available)
        → INSERT into words table
        → cefr_level included in source data

Step 2: Fill frequency_rank
        Tool: Python wordfreq library
        → Batch update all 5000 words
        → Script: python scripts/fill_frequency.py

Step 3: Fill definitions + examples
        Source: WordNet (via nltk)
        → definitions (English only, vi=null)
        → example_sentences from WordNet
        → Script: python scripts/fill_definitions.py

Step 4: Generate word_relationships
        Source: WordNet (synonym, antonym, word_form)
        → ~20,000+ relationships from 5000 words
        → Script: python scripts/fill_relationships.py

Step 5: Domain tagging
        Tool: Claude/OpenAI API batch
        → Categorize 5000 words into domains
        → INSERT into domains + domain_words
        → Script: python scripts/fill_domains.py
        → Cost: ~$2-5 one-time

Step 6 (deferred): Vietnamese definitions
        Tool: OpenAI/Claude API batch translate
        → UPDATE words SET definitions (add vi field)
        → Admin review
        → Script: python scripts/fill_vietnamese.py
```

---

## Pipeline Scripts Location

```
chicky_data_pipeline/
├── scripts/
│   ├── fill_frequency.py      # Wordfreq → frequency_rank
│   ├── fill_definitions.py    # WordNet → definitions + examples
│   ├── fill_relationships.py  # WordNet → word_relationships
│   ├── fill_domains.py        # AI API → domain tagging
│   ├── fill_vietnamese.py     # AI API → Vietnamese translations
│   └── import_oxford5000.py   # CSV → words table
├── data/
│   ├── oxford_5000.csv        # Source word list
│   └── domains_seed.json      # Initial domain hierarchy
├── requirements.txt
└── README.md
```

---

## Data Quality Rules

- All base words must have: word, at least 1 definition (en), cefr_level
- `frequency_rank` is required for card selection algorithm
- Relationships must be bidirectional where applicable (synonym A↔B)
- Auto-scanned words (`verified=false`) are excluded from card selection until reviewed
- Vietnamese definitions (`vi` field) are optional — app works without them
