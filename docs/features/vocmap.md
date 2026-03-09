# Feature: VocMap

Card-based vocabulary interface. Users see flashcards, swipe to mark known/unknown, explore related words by domain or word-form, and review via FSRS spaced repetition.

---

## User Flow

```
App opens → VocMap tab (default)
    │
    ├── Review Queue (FSRS due cards)
    │   ├── Show card: word + definition + example
    │   ├── User taps: "Again" / "Hard" / "Good" / "Easy"
    │   ├── FSRS updates stability, difficulty, due_at
    │   └── Next card
    │
    ├── New Words (weighted random)
    │   ├── Cards weighted by frequency_rank (common words first)
    │   ├── Filtered by user level (don't show C2 words to beginner)
    │   ├── User swipes: "Know it" → mastered / "Learn" → add to vault
    │   └── "Skip" → mark skipped, don't show again
    │
    └── Domain Explorer
        ├── Browse domains: Cooking, Fintech, Travel...
        ├── Tap domain → see words in that domain
        ├── Known words grayed out
        ├── Unknown words highlighted → tap to learn
        └── Expand: tap word → see related words (graph traversal)
```

---

## Card Selection Algorithm

```python
# Pseudocode: Select 20 cards for a study session

def select_cards(user_id, session_size=20):
    review_ratio = 0.7  # 70% review, 30% new

    # 1. FSRS due cards (review old words) — Priority
    review_cards = db.query("""
        SELECT w.*, uv.* FROM user_vocabulary uv
        JOIN words w ON w.id = uv.word_id
        WHERE uv.user_id = :user_id
          AND uv.due_at <= NOW()
          AND uv.status IN ('learning', 'review')
        ORDER BY uv.due_at ASC
        LIMIT :limit
    """, limit=int(session_size * review_ratio))

    remaining = session_size - len(review_cards)

    # 2. New words (weighted random by frequency)
    # More common words (low frequency_rank) appear more often
    new_cards = db.query("""
        SELECT w.* FROM words w
        LEFT JOIN user_vocabulary uv
          ON uv.word_id = w.id AND uv.user_id = :user_id
        WHERE uv.word_id IS NULL  -- not in user's vault yet
          AND w.verified = true
        ORDER BY random() * (1.0 / COALESCE(w.frequency_rank, 50000))
        LIMIT :limit
    """, limit=remaining)

    return shuffle(review_cards + new_cards)
```

---

## User Level (Computed, Not Stored)

```python
def compute_user_level(user_id):
    """
    Determine user's approximate level from their known vocabulary.
    Returns: 'beginner' | 'intermediate' | 'advanced'
    """
    stats = db.query("""
        SELECT
          COUNT(*) FILTER (WHERE w.frequency_rank <= 1000) as common,
          COUNT(*) FILTER (WHERE w.frequency_rank BETWEEN 1001 AND 3000) as mid,
          COUNT(*) FILTER (WHERE w.frequency_rank > 3000) as advanced,
          COUNT(*) as total
        FROM user_vocabulary uv
        JOIN words w ON w.id = uv.word_id
        WHERE uv.user_id = :user_id
          AND uv.status IN ('review', 'mastered')
    """)

    if stats.total < 100:
        return 'beginner'
    elif stats.mid / stats.total > 0.3:
        return 'intermediate'
    elif stats.advanced / stats.total > 0.2:
        return 'advanced'
    return 'intermediate'
```

---

## Graph Expansion Query

```sql
-- "Show me all words related to 'cooking', 2 levels deep"
WITH RECURSIVE word_graph AS (
  -- Start node
  SELECT w.id, w.word, 0 as depth
  FROM words w WHERE w.word = 'cooking'

  UNION

  -- Expand 1 level
  SELECT w2.id, w2.word, wg.depth + 1
  FROM word_graph wg
  JOIN word_relationships wr ON wr.source_word_id = wg.id
  JOIN words w2 ON w2.id = wr.target_word_id
  WHERE wg.depth < 2  -- max 2 levels
)
SELECT DISTINCT wg.*, uv.status
FROM word_graph wg
LEFT JOIN user_vocabulary uv ON uv.word_id = wg.id AND uv.user_id = :user_id
ORDER BY wg.depth, wg.word;
```

---

## Supabase Queries (Flutter SDK)

```dart
// Get review queue
final reviewCards = await supabase
  .from('user_vocabulary')
  .select('*, words(*)')
  .eq('user_id', userId)
  .lte('due_at', DateTime.now().toIso8601String())
  .inFilter('status', ['learning', 'review'])
  .order('due_at')
  .limit(14);

// Get new cards (weighted random handled in app logic)
final newCards = await supabase
  .from('words')
  .select()
  .eq('verified', true)
  .not('id', 'in', knownWordIds)
  .order('frequency_rank')
  .limit(50);  // fetch more, randomly select 6 client-side

// Get domain words
final domainWords = await supabase
  .from('domain_words')
  .select('*, words(*)')
  .eq('domain_id', domainId);

// Get related words
final related = await supabase
  .from('word_relationships')
  .select('*, target:words!target_word_id(*)')
  .eq('source_word_id', wordId);

// Update FSRS after review
await supabase
  .from('user_vocabulary')
  .update({
    'status': newStatus,
    'stability': newStability,
    'difficulty': newDifficulty,
    'due_at': nextDueAt.toIso8601String(),
    'last_grade': grade,
    'reps': newReps,
    'last_reviewed_at': DateTime.now().toIso8601String(),
  })
  .eq('user_id', userId)
  .eq('word_id', wordId);
```
