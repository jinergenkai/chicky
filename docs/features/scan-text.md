# Feature: Scan Text

User pastes English text → app tokenizes → checks against known vocabulary → highlights unknown words → user taps to learn and add to vault.

---

## User Flow

```
User pastes text (or types)
    ↓
Flutter client: tokenize + lowercase + suffix strip
    ↓
Batch query words table by headwords
    ↓
Cross-reference with user_vocabulary
    ↓
Display text with color coding:
├── Green: known/mastered words
├── Yellow: currently learning words
├── Red: unknown words (not in vault)
└── Gray: words not in base (stop words, names, etc.)
    ↓
User taps red/yellow word:
├── Show definition + IPA + example
├── Show related words (from word_relationships)
├── "Add to Vault" → insert user_vocabulary (source='scan')
└── "Skip" → dismiss
    ↓
If word NOT in base words table:
├── Call Free Dictionary API (dictionaryapi.dev)
├── Get definition, IPA, POS, example
├── Auto-insert into words table (verified=false, created_by='auto_scan')
├── Calculate frequency_rank via Wordfreq
└── Show to user normally
```

---

## Lemmatization Strategy (MVP — Simple)

For MVP, use simple suffix stripping on Flutter client. No heavy NLP library needed.

```dart
/// Simple lemmatizer for MVP
/// Handles ~80% of common English inflections
String simpleLemmatize(String word) {
  final w = word.toLowerCase().trim();

  // Common irregular verbs (expand this map over time)
  const irregulars = {
    'went': 'go', 'gone': 'go', 'going': 'go',
    'was': 'be', 'were': 'be', 'been': 'be', 'being': 'be',
    'had': 'have', 'has': 'have', 'having': 'have',
    'did': 'do', 'does': 'do', 'doing': 'do', 'done': 'do',
    'said': 'say', 'says': 'say',
    'made': 'make', 'makes': 'make', 'making': 'make',
    'took': 'take', 'taken': 'take', 'takes': 'take',
    'came': 'come', 'comes': 'come', 'coming': 'come',
    'gave': 'give', 'given': 'give', 'gives': 'give',
    'found': 'find', 'finds': 'find', 'finding': 'find',
    'thought': 'think', 'thinks': 'think', 'thinking': 'think',
    'told': 'tell', 'tells': 'tell', 'telling': 'tell',
    'became': 'become', 'becomes': 'become',
    'left': 'leave', 'leaves': 'leave', 'leaving': 'leave',
    'felt': 'feel', 'feels': 'feel', 'feeling': 'feel',
    'brought': 'bring', 'brings': 'bring',
    'wrote': 'write', 'written': 'write', 'writes': 'write',
    'ran': 'run', 'runs': 'run', 'running': 'run',
    'kept': 'keep', 'keeps': 'keep', 'keeping': 'keep',
    'set': 'set', 'sat': 'sit', 'sits': 'sit',
    'stood': 'stand', 'stands': 'stand',
    'lost': 'lose', 'loses': 'lose', 'losing': 'lose',
    'paid': 'pay', 'pays': 'pay', 'paying': 'pay',
    'met': 'meet', 'meets': 'meet', 'meeting': 'meet',
    'led': 'lead', 'leads': 'lead', 'leading': 'lead',
    'better': 'good', 'best': 'good',
    'worse': 'bad', 'worst': 'bad',
    'children': 'child', 'men': 'man', 'women': 'woman',
    'people': 'person', 'mice': 'mouse', 'teeth': 'tooth',
  };

  if (irregulars.containsKey(w)) return irregulars[w]!;

  // Suffix stripping rules (order matters)
  if (w.endsWith('ies') && w.length > 4) return '${w.substring(0, w.length - 3)}y';
  if (w.endsWith('ves') && w.length > 4) return '${w.substring(0, w.length - 3)}f';
  if (w.endsWith('ses') || w.endsWith('xes') || w.endsWith('zes') ||
      w.endsWith('ches') || w.endsWith('shes')) return w.substring(0, w.length - 2);
  if (w.endsWith('ing') && w.length > 5) {
    final stem = w.substring(0, w.length - 3);
    // running → run (doubled consonant)
    if (stem.length >= 2 && stem[stem.length - 1] == stem[stem.length - 2]) {
      return stem.substring(0, stem.length - 1);
    }
    return stem.endsWith('e') ? stem : '${stem}e'; // making → make
  }
  if (w.endsWith('ed') && w.length > 4) {
    final stem = w.substring(0, w.length - 2);
    if (w.endsWith('ied')) return '${w.substring(0, w.length - 3)}y';
    if (stem.length >= 2 && stem[stem.length - 1] == stem[stem.length - 2]) {
      return stem.substring(0, stem.length - 1);
    }
    return stem;
  }
  if (w.endsWith('ly') && w.length > 4) return w.substring(0, w.length - 2);
  if (w.endsWith('s') && !w.endsWith('ss') && w.length > 3) return w.substring(0, w.length - 1);

  return w;
}
```

**Upgrade path:** When app gains users, replace with pre-built `lemma_map` table (~50K entries) generated from Python nltk/spaCy. Flutter does simple DB lookup instead of suffix stripping.

---

## Free Dictionary API Integration

```python
# FastAPI endpoint for words not in base
@app.post("/scan/lookup")
async def lookup_unknown_word(word: str):
    """Look up a word not in our base vocabulary."""

    # 1. Check if already in words table
    existing = await db.fetchrow(
        "SELECT * FROM words WHERE word = $1", word
    )
    if existing:
        return existing

    # 2. Call Free Dictionary API
    async with httpx.AsyncClient() as client:
        resp = await client.get(
            f"https://api.dictionaryapi.dev/api/v2/entries/en/{word}"
        )

    if resp.status_code != 200:
        return {"error": "Word not found", "word": word}

    data = resp.json()[0]

    # 3. Extract structured data
    definitions = []
    for meaning in data.get("meanings", []):
        for defn in meaning.get("definitions", [])[:2]:  # max 2 per POS
            definitions.append({
                "pos": meaning["partOfSpeech"],
                "en": defn["definition"],
                "vi": None  # to be filled later
            })

    ipa = None
    for phonetic in data.get("phonetics", []):
        if phonetic.get("text"):
            ipa = phonetic["text"]
            break

    # 4. Get frequency rank
    from wordfreq import zipf_frequency
    freq = zipf_frequency(word, 'en')
    # Convert zipf to rank (higher zipf = more common = lower rank)
    frequency_rank = max(1, int(10000 / max(freq, 0.1)))

    # 5. Auto-insert into words table
    new_word = await db.fetchrow("""
        INSERT INTO words (word, ipa, definitions, frequency_rank, verified, created_by)
        VALUES ($1, $2, $3, $4, false, 'auto_scan')
        RETURNING *
    """, word, ipa, json.dumps(definitions), frequency_rank)

    return new_word
```
