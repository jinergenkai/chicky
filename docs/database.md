# Database Schema

Supabase PostgreSQL — all tables, indexes, and RLS policies.

---

## Tables

### `words` — Base vocabulary (shared, ~5000+ entries)

```sql
CREATE TABLE words (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  word TEXT NOT NULL,
  ipa TEXT,
  definitions JSONB NOT NULL DEFAULT '[]',
    -- Format: [{"pos": "verb", "en": "to decide firmly", "vi": "quyết định"}]
    -- "vi" can be null initially, populated later by admin/AI
  cefr_level TEXT CHECK (cefr_level IN ('A1','A2','B1','B2','C1','C2')),
  frequency_rank INT,
    -- Lower = more common. Source: Wordfreq library / COCA corpus
    -- Used for weighted random card selection
  example_sentences JSONB DEFAULT '[]',
    -- Format: ["She determined to finish the project."]
  verified BOOLEAN NOT NULL DEFAULT true,
    -- false = auto-added from scan, pending admin review
  created_by TEXT NOT NULL DEFAULT 'system' CHECK (created_by IN ('system', 'auto_scan', 'admin')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT words_word_unique UNIQUE (word)
);

CREATE INDEX idx_words_freq ON words(frequency_rank);
CREATE INDEX idx_words_cefr ON words(cefr_level);
CREATE INDEX idx_words_verified ON words(verified);
```

**Notes:**
- `word` stores headword only ("determine", not "determined", "determines").
- Inflected forms ("determined" → "determine") handled via lemmatization at scan time.
- Oxford 5000 headwords ≈ 15,000-20,000 actual word forms when including inflections.
- `definitions` is JSONB for flexibility — supports multiple POS, bilingual definitions, and future expansion.

---

### `word_relationships` — Edges in the vocabulary graph

```sql
CREATE TYPE rel_type AS ENUM (
  'synonym',         -- happy ↔ joyful
  'antonym',         -- happy ↔ sad
  'collocation',     -- make + decision (not "do decision")
  'domain_related',  -- bank → mortgage → collateral
  'word_form',       -- determine → determination → predetermined
  'phrasal_verb'     -- give → give up → give in
);

CREATE TABLE word_relationships (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  source_word_id UUID NOT NULL REFERENCES words(id) ON DELETE CASCADE,
  target_word_id UUID NOT NULL REFERENCES words(id) ON DELETE CASCADE,
  rel_type rel_type NOT NULL,
  strength FLOAT NOT NULL DEFAULT 0.5 CHECK (strength >= 0 AND strength <= 1),
    -- How strongly related. Used for sorting related cards.
  verified BOOLEAN NOT NULL DEFAULT false,
  domain_id UUID REFERENCES domains(id),

  CONSTRAINT no_self_relation CHECK (source_word_id != target_word_id),
  CONSTRAINT unique_relationship UNIQUE (source_word_id, target_word_id, rel_type)
);

CREATE INDEX idx_rel_source_type ON word_relationships(source_word_id, rel_type);
CREATE INDEX idx_rel_target_type ON word_relationships(target_word_id, rel_type);
CREATE INDEX idx_rel_domain ON word_relationships(domain_id);
```

**Relationship examples:**

```
determine (id:001) ←word_form→ determination (id:002)
determine (id:001) ←word_form→ predetermined (id:003)
happy (id:010)     ←synonym→   joyful (id:011)
happy (id:010)     ←antonym→   sad (id:012)
make (id:020)      ←collocation→ decision (id:021)
bank (id:030)      ←domain_related→ mortgage (id:031)
give (id:040)      ←phrasal_verb→  give_up (id:041)
```

---

### `domains` — Topic categories with hierarchy

```sql
CREATE TABLE domains (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL UNIQUE,
  parent_id UUID REFERENCES domains(id),
    -- Hierarchy: Food → Cooking → Baking
  icon TEXT
    -- Emoji or icon name for UI
);

-- Example data:
-- (id:d1, "Food & Drink", null, "🍕")
-- (id:d2, "Cooking", d1, "🍳")
-- (id:d3, "Baking", d1, "🧁")
-- (id:d4, "Finance", null, "💰")
-- (id:d5, "Fintech", d4, "📱")
```

---

### `domain_words` — Many-to-many: word belongs to domains

```sql
CREATE TABLE domain_words (
  domain_id UUID NOT NULL REFERENCES domains(id) ON DELETE CASCADE,
  word_id UUID NOT NULL REFERENCES words(id) ON DELETE CASCADE,
  PRIMARY KEY (domain_id, word_id)
);

CREATE INDEX idx_domain_words_domain ON domain_words(domain_id);
CREATE INDEX idx_domain_words_word ON domain_words(word_id);
```

**Note:** One word can belong to multiple domains. "bank" → Finance + Geography.

---

### `user_vocabulary` — Per-user learning state (FSRS)

```sql
CREATE TYPE vocab_status AS ENUM ('new', 'learning', 'review', 'mastered', 'skipped');
CREATE TYPE vocab_source AS ENUM ('scan', 'manual', 'domain_expand', 'bot');
CREATE TYPE fsrs_grade AS ENUM ('again', 'hard', 'good', 'easy');

CREATE TABLE user_vocabulary (
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  word_id UUID NOT NULL REFERENCES words(id) ON DELETE CASCADE,
  status vocab_status NOT NULL DEFAULT 'new',

  -- FSRS (Free Spaced Repetition Scheduler) fields
  stability FLOAT NOT NULL DEFAULT 0,
    -- Time (in days) for recall probability to reach 90%
    -- Higher = word is more deeply learned
  difficulty FLOAT NOT NULL DEFAULT 0.3,
    -- 0 to 1. Higher = word is harder for this user
  due_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    -- When this word needs to be reviewed next
  last_grade fsrs_grade,
    -- User's last rating: again/hard/good/easy
  reps INT NOT NULL DEFAULT 0,
    -- Total successful review count
  lapses INT NOT NULL DEFAULT 0,
    -- Times user forgot (graded "again")

  -- Tracking
  source vocab_source NOT NULL DEFAULT 'manual',
    -- How this word entered user's vault
  first_seen_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  last_reviewed_at TIMESTAMPTZ,

  PRIMARY KEY (user_id, word_id)
);

-- Query: "Which words are due for review today?"
CREATE INDEX idx_user_due ON user_vocabulary(user_id, due_at)
  WHERE status IN ('learning', 'review');

-- Query: "How many words does user know at each status?"
CREATE INDEX idx_user_status ON user_vocabulary(user_id, status);
```

**FSRS Algorithm Overview:**

FSRS (Free Spaced Repetition Scheduler) is the next-gen algorithm replacing SM-2 in Anki. Core idea: after each review, calculate optimal next review time based on difficulty and stability.

```python
# Simplified FSRS update logic (implemented in FastAPI or Flutter)
def fsrs_update(card, grade):
    """
    card: current user_vocabulary record
    grade: 'again' | 'hard' | 'good' | 'easy'
    """
    if grade == 'again':
        card.lapses += 1
        card.stability = max(card.stability * 0.5, 0.1)  # decay
        card.difficulty = min(card.difficulty + 0.1, 1.0)
        card.due_at = now() + timedelta(minutes=10)  # review soon
        card.status = 'learning'
    else:
        card.reps += 1
        grade_bonus = {'hard': 0.8, 'good': 1.0, 'easy': 1.3}[grade]
        card.stability = card.stability * (1 + grade_bonus)
        card.difficulty = max(card.difficulty - 0.05, 0.0) if grade == 'easy' else card.difficulty
        interval_days = card.stability * grade_bonus
        card.due_at = now() + timedelta(days=interval_days)
        card.status = 'review' if card.reps < 5 else 'mastered'

    card.last_grade = grade
    card.last_reviewed_at = now()
    return card
```

**Note:** This is simplified. Production FSRS uses more sophisticated math (power-forgetting-curve model). Use the `fsrs` Python library or `dart_fsrs` Flutter package for accurate implementation.

---

### `chat_sessions` — Conversation sessions

```sql
CREATE TYPE chat_mode AS ENUM ('buddy', 'role_play');

CREATE TABLE chat_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  mode chat_mode NOT NULL DEFAULT 'buddy',
  scenario_id UUID REFERENCES scenarios(id),
    -- Only for role_play mode
  started_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  ended_at TIMESTAMPTZ,
  vocab_practiced UUID[] DEFAULT '{}',
    -- Word IDs that bot intentionally used in this session

  CONSTRAINT role_play_needs_scenario
    CHECK (mode != 'role_play' OR scenario_id IS NOT NULL)
);

CREATE INDEX idx_chat_sessions_user ON chat_sessions(user_id, started_at DESC);
```

---

### `chat_messages` — Individual messages with corrections

```sql
CREATE TYPE message_role AS ENUM ('user', 'assistant');

CREATE TABLE chat_messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id UUID NOT NULL REFERENCES chat_sessions(id) ON DELETE CASCADE,
  role message_role NOT NULL,
  content_text TEXT NOT NULL,
  corrections JSONB DEFAULT '[]',
    -- Format: [
    --   {"original": "I go yesterday",
    --    "corrected": "I went yesterday",
    --    "rule": "past_simple",
    --    "explanation": "Use past tense for completed actions"}
    -- ]
  vocab_highlighted UUID[] DEFAULT '{}',
    -- Word IDs from user's learning list used in this message
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  order_index INT NOT NULL
);

CREATE INDEX idx_messages_session ON chat_messages(session_id, order_index);
```

---

### `scenarios` — Pre-built role-play scenarios

```sql
CREATE TABLE scenarios (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
    -- "Job Interview", "Ordering Food", "Doctor Visit"
  description TEXT,
  difficulty TEXT CHECK (difficulty IN ('beginner', 'intermediate', 'advanced')),
  domain_id UUID REFERENCES domains(id),
  system_prompt_addon TEXT NOT NULL,
    -- Extra prompt context for this scenario
  suggested_vocab UUID[] DEFAULT '{}'
    -- Words particularly useful for this scenario
);
```

---

### `scan_sessions` — Scan history

```sql
CREATE TABLE scan_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  source_text TEXT,
  title TEXT,
    -- "Fintech article Mar 2026" (auto-generated or user-set)
  total_words INT NOT NULL DEFAULT 0,
  unknown_count INT NOT NULL DEFAULT 0,
  new_added_count INT NOT NULL DEFAULT 0,
    -- How many unknown words user added to vault
  domain_id UUID REFERENCES domains(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_scan_sessions_user ON scan_sessions(user_id, created_at DESC);
```

**Note:** UI for scan history is deferred. Table exists to collect data for future features.

---

## Row Level Security (RLS)

```sql
-- Enable RLS on all user-specific tables
ALTER TABLE user_vocabulary ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE scan_sessions ENABLE ROW LEVEL SECURITY;

-- Users can only access their own data
CREATE POLICY user_vocab_policy ON user_vocabulary
  FOR ALL USING (auth.uid() = user_id);

CREATE POLICY chat_sessions_policy ON chat_sessions
  FOR ALL USING (auth.uid() = user_id);

CREATE POLICY chat_messages_policy ON chat_messages
  FOR ALL USING (
    session_id IN (SELECT id FROM chat_sessions WHERE user_id = auth.uid())
  );

CREATE POLICY scan_sessions_policy ON scan_sessions
  FOR ALL USING (auth.uid() = user_id);

-- Shared tables: anyone can read, only admin can write
CREATE POLICY words_read ON words FOR SELECT USING (true);
CREATE POLICY word_rel_read ON word_relationships FOR SELECT USING (true);
CREATE POLICY domains_read ON domains FOR SELECT USING (true);
CREATE POLICY domain_words_read ON domain_words FOR SELECT USING (true);
CREATE POLICY scenarios_read ON scenarios FOR SELECT USING (true);
```

---

## Quick Reference Queries

```sql
-- Words due for review today
SELECT w.*, uv.* FROM user_vocabulary uv
JOIN words w ON w.id = uv.word_id
WHERE uv.user_id = $1 AND uv.due_at <= NOW()
AND uv.status IN ('learning', 'review')
ORDER BY uv.due_at LIMIT 20;

-- New words weighted by frequency (common first)
SELECT w.* FROM words w
LEFT JOIN user_vocabulary uv ON uv.word_id = w.id AND uv.user_id = $1
WHERE uv.word_id IS NULL AND w.verified = true
ORDER BY random() * (1.0 / COALESCE(w.frequency_rank, 50000))
LIMIT 10;

-- All words in a domain that user hasn't mastered
SELECT w.*, uv.status FROM domain_words dw
JOIN words w ON w.id = dw.word_id
LEFT JOIN user_vocabulary uv ON uv.word_id = w.id AND uv.user_id = $1
WHERE dw.domain_id = $2 AND (uv.status IS NULL OR uv.status != 'mastered')
ORDER BY w.frequency_rank;

-- Related words (1 level)
SELECT w2.*, wr.rel_type, wr.strength FROM word_relationships wr
JOIN words w2 ON w2.id = wr.target_word_id
WHERE wr.source_word_id = $1
ORDER BY wr.strength DESC;

-- User's learning words (for prompt building)
SELECT w.word FROM user_vocabulary uv
JOIN words w ON w.id = uv.word_id
WHERE uv.user_id = $1 AND uv.status IN ('learning', 'review')
ORDER BY uv.due_at LIMIT 20;

-- User stats
SELECT
  COUNT(*) FILTER (WHERE status = 'mastered') as mastered,
  COUNT(*) FILTER (WHERE status = 'learning') as learning,
  COUNT(*) FILTER (WHERE status = 'review') as reviewing,
  COUNT(*) as total
FROM user_vocabulary WHERE user_id = $1;
```
