# Chicky — AI English Companion App

## Full System Design Document v1.0

> **Purpose:** This document is the single source of truth for building Chicky MVP. Written for both human developers and AI coding assistants (Claude Code) to understand architecture, data models, and implementation details.

> **Last updated:** 2026-03-08

---

## Table of Contents

1. [Product Overview](#1-product-overview)
2. [Architecture Overview](#2-architecture-overview)
3. [Tech Stack](#3-tech-stack)
4. [Database Schema (Supabase PostgreSQL)](#4-database-schema)
5. [Feature 1: VocMap — Flashcard Vocabulary Graph](#5-feature-1-vocmap)
6. [Feature 2: Scan Text — Detect Unknown Words](#6-feature-2-scan-text)
7. [Feature 3: AI Buddy Chat — Voice Conversation](#7-feature-3-ai-buddy-chat)
8. [Data Pipeline — Bootstrap Base Vocabulary](#8-data-pipeline)
9. [API Contracts](#9-api-contracts)
10. [Voice Pipeline — Latency & Streaming](#10-voice-pipeline)
11. [Prompt Engineering](#11-prompt-engineering)
12. [Project Structure](#12-project-structure)
13. [MVP Milestones & Roadmap](#13-mvp-milestones)
14. [Cost Estimation](#14-cost-estimation)
15. [Future Backlog](#15-future-backlog)

---

## 1. Product Overview

### What is Chicky?

Chicky is a mobile AI English companion app. Not a typical "English learning app" — it's a **personalized AI buddy** that helps users improve English naturally through conversation, vocabulary expansion via a knowledge graph, and contextual learning.

### Core Value Proposition

- **VocMap (Vault):** Card-based vocabulary graph. Users see what they know, expand into related words by domain/word-form, and learn via FSRS spaced repetition. No repetition of already-known words.
- **Scan Text:** Paste any English text → app highlights unknown words → tap to learn → add to vault. Vocabulary grows organically from real content.
- **AI Buddy Chat:** Voice-activated AI companion (wakeword "Hey Chicky"). Corrects grammar inline, uses user's learning words naturally in conversation, answers knowledge questions — all in mixed Vietnamese-English.

### Target Users

- **Primary (MVP):** The developer himself — custom personal tool.
- **Secondary:** Vietnamese adults (25-35) actively learning English, willing to pay for quality (200-500K VND/month).
- **Tertiary:** Portfolio/skill showcase piece.

### Design Philosophy

- AI companion, not a teacher. Warm, smart, slightly humorous.
- Vietnamese-English mix — not full immersion, not full translation.
- Graph-based vocabulary — never repeat what user already knows.
- Voice-first for outdoor/commute use, card-based for study sessions.

---

## 2. Architecture Overview

```
┌─────────────────────────────────────────────────────────┐
│                     Flutter App                          │
│  ┌──────────┐  ┌──────────┐  ┌────────────────────┐    │
│  │ VocMap   │  │  Scan    │  │  Buddy Chat        │    │
│  │ (Cards)  │  │  Text    │  │  (Voice + Text)    │    │
│  └────┬─────┘  └────┬─────┘  └────────┬───────────┘    │
│       │              │                  │                 │
│  ┌────┴──────────────┴──────┐  ┌───────┴──────────┐    │
│  │   Supabase Flutter SDK   │  │   Dio / WebSocket │    │
│  └────────────┬─────────────┘  └───────┬──────────┘    │
│               │                         │                │
│  ┌────────────┴─────────┐              │                │
│  │  Hive (Local Cache)  │              │                │
│  └──────────────────────┘              │                │
└───────────────┬────────────────────────┤────────────────┘
                │                        │
                ▼                        ▼
┌───────────────────────────┐  ┌─────────────────────────┐
│      Supabase (Managed)   │  │   FastAPI (AI Service)  │
│  ┌─────────────────────┐  │  │                         │
│  │  Auth (OAuth/Email)  │  │  │  POST /chat/voice      │
│  ├─────────────────────┤  │  │  POST /chat/text       │
│  │  PostgreSQL          │  │  │  POST /tts             │
│  │  ├── words           │  │  │  POST /scan/process    │
│  │  ├── word_relations  │  │  │                         │
│  │  ├── domains         │  │  │  Integrations:          │
│  │  ├── domain_words    │  │  │  ├── Whisper API (STT) │
│  │  ├── user_vocabulary │  │  │  ├── LLM (configurable)│
│  │  ├── chat_sessions   │  │  │  ├── Edge TTS (free)   │
│  │  ├── chat_messages   │  │  │  └── Free Dict API     │
│  │  └── scan_sessions   │  │  │                         │
│  ├─────────────────────┤  │  │  Connects to Supabase   │
│  │  Edge Functions      │  │  │  PostgreSQL via asyncpg │
│  │  (simple helpers)    │  │  │                         │
│  └─────────────────────┘  │  └─────────────────────────┘
└───────────────────────────┘
```

### Key Architecture Decisions

| Decision          | Choice                       | Rationale                                                            |
| ----------------- | ---------------------------- | -------------------------------------------------------------------- |
| Data layer        | Supabase (Auth + PostgreSQL) | Managed, free tier 50K MAU, relational data fits vocab graph         |
| AI service        | FastAPI (Python)             | Native AI ecosystem (Whisper, edge-tts, Wordfreq, FSRS), lightweight |
| Mobile framework  | Flutter                      | Cross-platform iOS/Android, Picovoice SDK support, prior experience  |
| State management  | Riverpod                     | Clean, testable, scalable, Flutter community recommended             |
| Spaced repetition | FSRS                         | Newer than SM-2, Anki migrating to it, better retention curves       |
| DB migrations     | Supabase CLI migrations      | Raw SQL, simple, no ORM overhead                                     |
| Local cache       | Hive                         | Offline vocab access, fast key-value store for Flutter               |
| Voice wakeword    | Picovoice                    | On-device, offline, custom wakeword "Hey Chicky", tested             |

### Separation of Concerns

- **Supabase** handles ONLY: auth, data storage, user management.
- **FastAPI** handles ONLY: AI processing (STT, LLM, TTS), external API calls.
- **Flutter** handles ONLY: UI, local cache, wakeword detection, audio recording/playback.
- **Fault isolation:** Supabase down → chat still works from cache. FastAPI down → VocMap/Scan still work. Neither takes the other down.

---

## 3. Tech Stack

### Flutter App

```yaml
dependencies:
  # Core
  flutter_riverpod: ^2.x # State management
  supabase_flutter: ^2.x # Auth + DB (single SDK)

  # HTTP & Networking
  dio: ^5.x # HTTP client for FastAPI
  web_socket_channel: ^2.x # WebSocket for voice streaming

  # Voice
  picovoice_flutter: ^3.x # Wakeword "Hey Chicky" (offline)
  record: ^5.x # Audio recording from mic
  just_audio: ^0.9.x # Play TTS audio responses

  # UI
  flutter_card_swiper: ^7.x # Swipe cards for VocMap
  shimmer: ^3.x # Loading skeletons

  # Data
  hive_flutter: ^1.x # Local cache (offline vocab)
  json_annotation: ^4.x # JSON serialization
  freezed_annotation: ^2.x # Immutable data models

  # Utils
  go_router: ^14.x # Navigation

dev_dependencies:
  build_runner: ^2.x
  freezed: ^2.x
  json_serializable: ^6.x
  hive_generator: ^2.x
  riverpod_generator: ^2.x
```

### FastAPI (AI Service)

```txt
# requirements.txt
fastapi>=0.110.0
uvicorn>=0.27.0
asyncpg>=0.29.0          # PostgreSQL async driver
websockets>=12.0          # WebSocket support
httpx>=0.27.0             # Async HTTP client

# AI / NLP
openai>=1.12.0            # Whisper API + optional GPT
anthropic>=0.18.0         # Claude API (optional)
edge-tts>=6.1.0           # Microsoft Edge TTS (free)
wordfreq>=3.0.0           # Word frequency data

# Utils
python-dotenv>=1.0.0
pydantic>=2.6.0
```

### Infrastructure

| Component            | Service                     | Cost (MVP/1 user) |
| -------------------- | --------------------------- | ----------------- |
| Database + Auth      | Supabase Free Tier          | $0/month          |
| AI Service hosting   | Personal server (existing)  | $0/month          |
| Whisper API (OpenAI) | ~30 min/day voice           | ~$6/month         |
| LLM API              | GPT-4o-mini or Claude Haiku | ~$1-3/month       |
| TTS                  | Edge TTS                    | $0 (free)         |
| Free Dictionary API  | dictionaryapi.dev           | $0 (free)         |
| **Total**            |                             | **~$7-9/month**   |

---

## 4. Database Schema

### Supabase PostgreSQL — All Tables

#### 4.1 `words` — Base vocabulary (shared, ~5000+ entries)

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

#### 4.2 `word_relationships` — Edges in the vocabulary graph

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

#### 4.3 `domains` — Topic categories with hierarchy

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

#### 4.4 `domain_words` — Many-to-many: word belongs to domains

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

#### 4.5 `user_vocabulary` — Per-user learning state (FSRS)

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

#### 4.6 `chat_sessions` — Conversation sessions

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

#### 4.7 `chat_messages` — Individual messages with corrections

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

#### 4.8 `scenarios` — Pre-built role-play scenarios

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

#### 4.9 `scan_sessions` — Scan history (backlog, create table now)

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

### Row Level Security (RLS)

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

## 5. Feature 1: VocMap

### 5.1 Overview

Card-based vocabulary interface. Users see flashcards, swipe to mark known/unknown, explore related words by domain or word-form, and review via FSRS spaced repetition.

### 5.2 User Flow

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

### 5.3 Card Selection Algorithm

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

### 5.4 User Level (Computed, Not Stored)

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

### 5.5 Graph Expansion Query

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

## 6. Feature 2: Scan Text

### 6.1 Overview

User pastes English text → app tokenizes → checks against known vocabulary → highlights unknown words → user taps to learn and add to vault.

### 6.2 User Flow

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

### 6.3 Lemmatization Strategy (MVP — Simple)

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

### 6.4 Free Dictionary API Integration

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

---

## 7. Feature 3: AI Buddy Chat

### 7.1 Overview

Voice-activated AI English companion. User says "Hey Chicky" → speaks → Chicky responds with grammar correction + natural conversation in mixed Vietnamese-English. Also available as text chat.

### 7.2 Two Modes

| Mode           | Description                                                          | When to use                                          |
| -------------- | -------------------------------------------------------------------- | ---------------------------------------------------- |
| **Buddy Chat** | Free conversation, grammar correction, knowledge Q&A, mixed Vi-En    | Default. 80% of usage. Walking, commuting, studying. |
| **Role-play**  | Structured scenarios (job interview, ordering food, etc.) with goals | Practice specific situations before real encounters. |

### 7.3 Buddy Chat Personality — "Chicky"

Chicky is a smart, warm, slightly humorous AI companion. Not a teacher — a friend who happens to be great at English.

Key traits:

- Warm but not cheesy. Smart friend at a café vibe.
- Has opinions. Recommends things. Shares perspectives.
- Corrects grammar naturally (repeats corrected version, doesn't lecture).
- Uses Vietnamese when it helps, defaults to English.
- Remembers context within session.

### 7.4 Response Format

When user makes a grammar error:

```
📝 Correction (spoken first):
"Oh you WENT to the bank yesterday?"

💬 Reply (then content):
"What for — chuyện gì vậy? Were you applying for a loan?"

📌 Vocab note (subtle, text only):
"mortgage", "collateral" highlighted as learning words
```

In voice: Bot reads the corrected sentence naturally (as if confirming what user said), pauses briefly, then responds to content. User hears the correct form before the conversation continues.

### 7.5 Bot Response JSON Format

FastAPI returns structured response:

```json
{
  "reply": "Oh you went to the bank yesterday? What for — chuyện gì vậy? Were you applying for a loan?",
  "corrections": [
    {
      "original": "I go to bank yesterday",
      "corrected": "I went to the bank yesterday",
      "rule": "past_simple",
      "explanation": "Use past tense 'went' for completed past actions"
    }
  ],
  "vocab_used": ["mortgage", "loan"],
  "vocab_ids": ["uuid-1", "uuid-2"]
}
```

Flutter parses this to:

- Play audio of `reply` (via Edge TTS)
- Store `corrections` in `chat_messages.corrections`
- Highlight `vocab_used` in chat UI
- Update `user_vocabulary` tracking for practiced words

---

## 8. Data Pipeline

### 8.1 Bootstrap Strategy

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

### 8.2 Pipeline Scripts Location

```
chicky-data-pipeline/
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

### 8.3 Data Quality Rules

- All base words must have: word, at least 1 definition (en), cefr_level
- frequency_rank is required for card selection algorithm
- Relationships must be bidirectional where applicable (synonym A↔B)
- Auto-scanned words (verified=false) are excluded from card selection until reviewed
- Vietnamese definitions (vi field) are optional — app works without them

---

## 9. API Contracts

### 9.1 FastAPI Endpoints

Base URL: `http://your-server:8000/api/v1`

#### Chat — Text Mode

```
POST /chat/text
Authorization: Bearer <supabase_jwt>

Request:
{
  "message": "Yesterday I go to bank and ask about mortgage",
  "session_id": "uuid-session",  // null to create new session
  "mode": "buddy"  // "buddy" | "role_play"
}

Response:
{
  "session_id": "uuid-session",
  "reply": "Oh you went to the bank yesterday and asked about a mortgage? ...",
  "corrections": [...],
  "vocab_used": ["mortgage"],
  "vocab_ids": ["uuid-word"]
}
```

#### Chat — Voice Mode (WebSocket)

```
WS /chat/voice
Authorization: via query param ?token=<supabase_jwt>

Flow:
1. Client sends: {"type": "start", "session_id": "uuid", "mode": "buddy"}
2. Client sends: binary audio data (WAV/PCM chunks)
3. Client sends: {"type": "end"}  // recording finished
4. Server sends: {"type": "transcript", "text": "Yesterday I go..."}
5. Server sends: {"type": "corrections", "data": [...]}
6. Server sends: binary audio chunks (TTS response, sentence by sentence)
7. Server sends: {"type": "done", "reply_text": "full response", "vocab_used": [...]}
```

#### Scan — Word Lookup

```
POST /scan/lookup
Authorization: Bearer <supabase_jwt>

Request:
{
  "word": "collateralized"
}

Response:
{
  "id": "uuid-word",
  "word": "collateralized",
  "ipa": "/kəˈlætərəlaɪzd/",
  "definitions": [{"pos": "verb", "en": "to pledge assets as security", "vi": null}],
  "frequency_rank": 12500,
  "verified": false,
  "created_by": "auto_scan"
}
```

#### TTS — Text to Speech

```
POST /tts

Request:
{
  "text": "Oh you went to the bank yesterday?",
  "voice": "en-US-AriaNeural"  // Edge TTS voice
}

Response: audio/mpeg binary stream
```

### 9.2 Supabase Direct Queries (Flutter SDK)

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

---

## 10. Voice Pipeline

### 10.1 End-to-End Flow

```
User says "Hey Chicky"
  ↓ ~200ms (Picovoice on-device, offline)

App starts recording (Record package)
  ↓ User speaks... silence detection (~500ms pause)

Audio sent to FastAPI via WebSocket
  ↓
FastAPI: Whisper API (speech → text)
  ↓ ~0.5-1s for ~10s audio

FastAPI: Build prompt (inject learning words + history)
  ↓
FastAPI: LLM streaming response
  ↓ First token ~0.3s, then streaming

FastAPI: Sentence-level streaming TTS
  ↓ Each complete sentence → Edge TTS → audio chunk → WebSocket

Flutter: Play audio chunks as they arrive
  ↓ User hears first sentence after ~2-3s total

Total perceived latency: ~2-3s (with streaming)
Without streaming: ~4-6s (wait for full response)
```

### 10.2 Streaming Implementation

```python
# FastAPI WebSocket endpoint with sentence-level streaming TTS
import edge_tts
import io

@app.websocket("/chat/voice")
async def voice_chat(websocket: WebSocket):
    await websocket.accept()

    # 1. Receive audio
    config = await websocket.receive_json()  # {type: "start", session_id, mode}
    audio_chunks = []
    while True:
        data = await websocket.receive()
        if isinstance(data, dict) and data.get("type") == "end":
            break
        audio_chunks.append(data)

    audio_data = b"".join(audio_chunks)

    # 2. Whisper STT
    transcript = await whisper_transcribe(audio_data)
    await websocket.send_json({"type": "transcript", "text": transcript})

    # 3. Build prompt with user context
    user_id = get_user_from_token(config.get("token"))
    learning_words = await get_learning_words(user_id)
    prompt = build_buddy_prompt(transcript, learning_words, config["mode"])

    # 4. LLM streaming + sentence-level TTS
    buffer = ""
    async for chunk in llm_stream(prompt):
        buffer += chunk

        # Check for sentence boundary
        for sep in ['. ', '? ', '! ', '.\n', '?\n', '!\n']:
            if sep in buffer:
                sentence, buffer = buffer.split(sep, 1)
                sentence += sep.strip()

                # TTS this sentence
                audio_bytes = await tts_sentence(sentence)
                await websocket.send_bytes(audio_bytes)

    # Handle remaining buffer
    if buffer.strip():
        audio_bytes = await tts_sentence(buffer.strip())
        await websocket.send_bytes(audio_bytes)

    # 5. Send final metadata
    full_response = parse_llm_response(full_text)
    await websocket.send_json({
        "type": "done",
        "reply_text": full_response["reply"],
        "corrections": full_response["corrections"],
        "vocab_used": full_response["vocab_used"]
    })


async def tts_sentence(text: str, voice: str = "en-US-AriaNeural") -> bytes:
    """Convert a sentence to audio using Edge TTS."""
    communicate = edge_tts.Communicate(text, voice)
    audio_buffer = io.BytesIO()
    async for chunk in communicate.stream():
        if chunk["type"] == "audio":
            audio_buffer.write(chunk["data"])
    return audio_buffer.getvalue()
```

### 10.3 Flutter Audio Handling

```dart
// Simplified voice chat flow in Flutter
class VoiceChatService {
  late WebSocketChannel _channel;
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();
  final Queue<Uint8List> _audioQueue = Queue();

  Future<void> startVoiceChat(String sessionId, String mode) async {
    // 1. Connect WebSocket
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://your-server:8000/chat/voice?token=$jwt')
    );

    // 2. Send start signal
    _channel.sink.add(jsonEncode({
      'type': 'start',
      'session_id': sessionId,
      'mode': mode
    }));

    // 3. Listen for responses
    _channel.stream.listen((data) {
      if (data is String) {
        final json = jsonDecode(data);
        if (json['type'] == 'transcript') {
          // Show user's transcribed text
        } else if (json['type'] == 'done') {
          // Show corrections, update vocab
        }
      } else if (data is List<int>) {
        // Audio chunk → add to queue → play
        _audioQueue.add(Uint8List.fromList(data));
        _playNextChunk();
      }
    });

    // 4. Start recording
    await _recorder.start(
      const RecordConfig(encoder: AudioEncoder.pcm16bits),
      path: tempPath,
    );
  }

  Future<void> stopRecording() async {
    await _recorder.stop();
    // Send audio to WebSocket
    final audioBytes = await File(tempPath).readAsBytes();
    _channel.sink.add(audioBytes);
    _channel.sink.add(jsonEncode({'type': 'end'}));
  }
}
```

---

## 11. Prompt Engineering

### 11.1 Buddy Mode System Prompt

```python
BUDDY_SYSTEM_PROMPT = """You are Chicky — a smart, warm, slightly humorous AI companion.
You're like a close friend who happens to be fluent in both Vietnamese and English.

## PERSONALITY
- Warm but not cheesy. Think: smart friend at a café.
- Mix Vietnamese and English naturally.
- Have opinions. Recommend things. Share perspectives.
- Remember context within the conversation.
- Be curious about the user's life and interests.

## LANGUAGE RULES
- If user speaks Vietnamese → reply ~70% English, 30% Vietnamese
- If user speaks English → reply ~90% English, Vietnamese only to clarify hard concepts
- ALWAYS respond in a way that gently pushes English skills up

## GRAMMAR CORRECTION (CRITICAL)
When user makes grammar or vocabulary errors:
1. First, naturally repeat the CORRECTED version (as if confirming what they said)
2. Then respond to the content
3. Do NOT lecture or explain grammar rules unless asked

Example:
- User: "Yesterday I go to bank"
- Chicky: "Oh you went to the bank yesterday? What happened — chuyện gì vậy?"

## VOCABULARY INTEGRATION
The user is currently learning these words: {learning_words}
- Use them naturally when they fit the context
- Do NOT force them into unrelated conversations
- When you use a learning word, it helps the user hear it in context

## KNOWLEDGE MODE
- User can ask ANY question about the world (science, tech, life, cooking, etc.)
- Answer clearly and helpfully
- If user asks in Vietnamese, answer in English with Vietnamese clarification for hard concepts
- If asked to translate, provide the translation and a brief usage example

## RESPONSE FORMAT
Always return a valid JSON object:
{{
  "reply": "Your natural conversational response here",
  "corrections": [
    {{
      "original": "what user said wrong",
      "corrected": "the correct form",
      "rule": "grammar_rule_name",
      "explanation": "brief explanation in Vietnamese"
    }}
  ],
  "vocab_used": ["list", "of", "learning", "words", "you", "used"]
}}

If no corrections needed, return empty corrections array.
If no learning words used, return empty vocab_used array.
Keep replies conversational — 2-4 sentences typically. Don't write essays."""


def build_buddy_prompt(user_message, learning_words, conversation_history):
    system = BUDDY_SYSTEM_PROMPT.replace(
        "{learning_words}",
        ", ".join(learning_words) if learning_words else "none currently"
    )

    messages = [{"role": "system", "content": system}]

    # Add conversation history (last 10 turns)
    for msg in conversation_history[-10:]:
        messages.append({
            "role": msg["role"],
            "content": msg["content_text"]
        })

    messages.append({"role": "user", "content": user_message})

    return messages
```

### 11.2 Role-play Mode System Prompt

```python
ROLEPLAY_SYSTEM_PROMPT = """You are playing a character in an English practice scenario.

## SCENARIO
{scenario_description}

## YOUR ROLE
{character_description}

## RULES
- Stay in character throughout the conversation
- Still correct grammar errors naturally (repeat corrected version)
- Use vocabulary from the user's learning list when contextually appropriate
- Learning words: {learning_words}
- Guide the conversation toward the scenario's goal
- When the scenario reaches a natural conclusion, suggest ending or continuing

## DIFFICULTY: {difficulty}
- beginner: Speak slowly, use simple vocabulary, be patient
- intermediate: Normal conversation speed, some complex vocabulary
- advanced: Natural speed, idiomatic expressions, subtle corrections

## RESPONSE FORMAT
Same JSON format as buddy mode:
{{
  "reply": "Your in-character response",
  "corrections": [...],
  "vocab_used": [...]
}}"""
```

### 11.3 Scenario Examples

```json
[
  {
    "title": "Job Interview — Software Engineer",
    "description": "User is interviewing for a senior backend engineer position at a fintech company. The interviewer asks about experience, technical skills, and behavioral questions.",
    "character": "You are Sarah, a friendly but thorough Engineering Manager at a fintech startup. You ask clear questions and give the candidate time to answer. You're looking for technical depth and communication skills.",
    "difficulty": "intermediate",
    "domain": "Technology",
    "suggested_vocab": [
      "scalability",
      "microservices",
      "deployment",
      "collaborate",
      "initiative"
    ]
  },
  {
    "title": "Ordering at a Restaurant",
    "description": "User is ordering food at an American restaurant. The waiter helps with menu choices, dietary restrictions, and recommendations.",
    "character": "You are Mike, a friendly waiter at a casual American restaurant. You know the menu well and enjoy making recommendations. You speak naturally and don't slow down unless asked.",
    "difficulty": "beginner",
    "domain": "Food & Drink",
    "suggested_vocab": [
      "appetizer",
      "entree",
      "dessert",
      "recommend",
      "allergy"
    ]
  },
  {
    "title": "Business Meeting — Project Update",
    "description": "User is presenting a project status update to their team lead. They need to explain progress, blockers, and next steps.",
    "character": "You are David, a supportive but detail-oriented team lead. You ask follow-up questions about timelines, risks, and resource needs. You appreciate clear, structured communication.",
    "difficulty": "intermediate",
    "domain": "Business",
    "suggested_vocab": [
      "deadline",
      "milestone",
      "stakeholder",
      "prioritize",
      "bottleneck"
    ]
  }
]
```

---

## 12. Project Structure

### 12.1 Flutter App

```
chicky_app/
├── lib/
│   ├── main.dart
│   ├── app.dart                    # App root, GoRouter setup
│   │
│   ├── core/
│   │   ├── config/
│   │   │   ├── env.dart            # Environment variables
│   │   │   └── supabase_config.dart
│   │   ├── theme/
│   │   │   ├── app_theme.dart
│   │   │   └── colors.dart
│   │   ├── utils/
│   │   │   ├── lemmatizer.dart     # Simple suffix stripping
│   │   │   └── text_tokenizer.dart
│   │   └── services/
│   │       ├── supabase_service.dart
│   │       ├── api_service.dart    # Dio client for FastAPI
│   │       └── audio_service.dart  # Record + Play
│   │
│   ├── features/
│   │   ├── auth/
│   │   │   ├── presentation/
│   │   │   │   ├── login_screen.dart
│   │   │   │   └── register_screen.dart
│   │   │   └── providers/
│   │   │       └── auth_provider.dart
│   │   │
│   │   ├── vocmap/
│   │   │   ├── data/
│   │   │   │   ├── models/
│   │   │   │   │   ├── word_model.dart
│   │   │   │   │   ├── user_vocab_model.dart
│   │   │   │   │   └── domain_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── vocab_repository.dart
│   │   │   ├── presentation/
│   │   │   │   ├── vocmap_screen.dart
│   │   │   │   ├── widgets/
│   │   │   │   │   ├── vocab_card.dart
│   │   │   │   │   ├── card_swiper.dart
│   │   │   │   │   ├── domain_list.dart
│   │   │   │   │   └── word_detail_sheet.dart
│   │   │   │   └── review_session_screen.dart
│   │   │   └── providers/
│   │   │       ├── vocmap_provider.dart
│   │   │       ├── review_provider.dart
│   │   │       └── fsrs_provider.dart
│   │   │
│   │   ├── scan/
│   │   │   ├── data/
│   │   │   │   └── repositories/
│   │   │   │       └── scan_repository.dart
│   │   │   ├── presentation/
│   │   │   │   ├── scan_screen.dart
│   │   │   │   └── widgets/
│   │   │   │       ├── text_input_area.dart
│   │   │   │       └── highlighted_text.dart
│   │   │   └── providers/
│   │   │       └── scan_provider.dart
│   │   │
│   │   └── chat/
│   │       ├── data/
│   │       │   ├── models/
│   │       │   │   ├── chat_message_model.dart
│   │       │   │   └── chat_session_model.dart
│   │       │   └── repositories/
│   │       │       └── chat_repository.dart
│   │       ├── presentation/
│   │       │   ├── chat_screen.dart
│   │       │   └── widgets/
│   │       │       ├── message_bubble.dart
│   │       │       ├── correction_card.dart
│   │       │       ├── voice_button.dart
│   │       │       └── mode_selector.dart
│   │       └── providers/
│   │           ├── chat_provider.dart
│   │           ├── voice_provider.dart
│   │           └── wakeword_provider.dart
│   │
│   └── shared/
│       ├── widgets/
│       │   ├── loading_widget.dart
│       │   └── error_widget.dart
│       └── models/
│           └── app_user.dart
│
├── test/
├── pubspec.yaml
└── README.md
```

### 12.2 FastAPI Service

```
chicky_api/
├── app/
│   ├── main.py                 # FastAPI app, CORS, lifespan
│   ├── config.py               # Environment config
│   ├── database.py             # asyncpg pool setup
│   │
│   ├── routers/
│   │   ├── chat.py             # POST /chat/text, WS /chat/voice
│   │   ├── scan.py             # POST /scan/lookup
│   │   └── tts.py              # POST /tts
│   │
│   ├── services/
│   │   ├── whisper_service.py  # OpenAI Whisper STT
│   │   ├── llm_service.py      # LLM abstraction (Claude/GPT/Gemini)
│   │   ├── tts_service.py      # Edge TTS wrapper
│   │   ├── prompt_builder.py   # Build system prompts with user context
│   │   └── dictionary_service.py  # Free Dictionary API
│   │
│   ├── models/
│   │   ├── chat_models.py      # Pydantic request/response models
│   │   └── scan_models.py
│   │
│   └── utils/
│       ├── auth.py             # Verify Supabase JWT
│       └── text_utils.py       # Sentence splitting, etc.
│
├── requirements.txt
├── Dockerfile
├── docker-compose.yml
└── README.md
```

### 12.3 Data Pipeline

```
chicky_data_pipeline/
├── scripts/
│   ├── import_oxford5000.py
│   ├── fill_frequency.py
│   ├── fill_definitions.py
│   ├── fill_relationships.py
│   ├── fill_domains.py
│   └── fill_vietnamese.py
├── data/
│   ├── oxford_5000.csv
│   └── domains_seed.json
├── requirements.txt
└── README.md
```

### 12.4 Supabase Migrations

```
supabase/
├── migrations/
│   ├── 001_create_words.sql
│   ├── 002_create_relationships.sql
│   ├── 003_create_domains.sql
│   ├── 004_create_user_vocabulary.sql
│   ├── 005_create_chat_tables.sql
│   ├── 006_create_scan_sessions.sql
│   ├── 007_create_scenarios.sql
│   ├── 008_enable_rls.sql
│   └── 009_create_indexes.sql
├── seed.sql                    # Initial domain data
└── config.toml
```

---

## 13. MVP Milestones

### Phase 1: Foundation (Week 1-2)

- [ ] Setup Supabase project + run all migrations
- [ ] Run data pipeline: import Oxford 5000 + WordNet
- [ ] Flutter project setup: Riverpod, Supabase SDK, routing
- [ ] Auth flow: login/register with Supabase Auth
- [ ] Basic UI shell: bottom navigation (VocMap, Scan, Chat)

### Phase 2: VocMap (Week 3-4)

- [ ] Card UI component with swipe gestures
- [ ] Review session: FSRS algorithm integration
- [ ] New word cards with weighted random selection
- [ ] Domain browser: list domains → show words
- [ ] Word detail sheet: definition, IPA, related words
- [ ] Local cache with Hive for offline vocab access

### Phase 3: Scan Text (Week 5)

- [ ] Text input area with paste support
- [ ] Simple lemmatizer implementation
- [ ] Color-coded text display (known/learning/unknown)
- [ ] Tap word → show detail + "Add to Vault"
- [ ] Free Dictionary API integration for unknown words
- [ ] FastAPI endpoint: /scan/lookup

### Phase 4: AI Chat — Text Mode (Week 6-7)

- [ ] FastAPI service setup with asyncpg
- [ ] Chat UI: message bubbles, correction cards
- [ ] Prompt builder with learning word injection
- [ ] LLM integration (GPT-4o-mini initially)
- [ ] Grammar correction display in chat
- [ ] Chat session/message persistence in Supabase

### Phase 5: AI Chat — Voice Mode (Week 8-9)

- [ ] Picovoice wakeword integration ("Hey Chicky")
- [ ] Audio recording + send to FastAPI
- [ ] Whisper STT integration
- [ ] Edge TTS integration
- [ ] WebSocket streaming: sentence-level TTS
- [ ] Audio playback queue in Flutter

### Phase 6: Polish & Deploy (Week 10)

- [ ] Role-play mode + 3 initial scenarios
- [ ] Error handling, loading states, offline fallbacks
- [ ] Deploy FastAPI (Docker on personal server)
- [ ] Flutter web build for browser testing
- [ ] Flutter Android build for personal device
- [ ] End-to-end testing

**Total estimated time: 10 weeks (part-time, evenings/weekends)**

---

## 14. Cost Estimation

### Monthly Cost (1 user — personal use)

| Service             | Usage                            | Cost            |
| ------------------- | -------------------------------- | --------------- |
| Supabase            | Free tier (500MB DB, 50K MAU)    | $0              |
| Whisper API         | ~30 min/day × 30 days = 15 hours | ~$5.40          |
| LLM (GPT-4o-mini)   | ~100 messages/day                | ~$1-3           |
| Edge TTS            | Unlimited                        | $0              |
| Free Dictionary API | Unlimited                        | $0              |
| Personal server     | Already owned                    | $0              |
| **Total**           |                                  | **~$7-9/month** |

### Monthly Cost (100 users — early growth)

| Service                 | Usage              | Cost              |
| ----------------------- | ------------------ | ----------------- |
| Supabase Pro            | Needed at ~50K MAU | $25               |
| Whisper API             | ~50 hours total    | ~$18              |
| LLM API                 | ~10K messages      | ~$10-30           |
| Server (Railway/Fly.io) | Small instance     | ~$10-20           |
| **Total**               |                    | **~$63-93/month** |

### Revenue target to break even (100 users)

At 300K VND/month (~$12): 100 users × $12 = $1,200/month → profitable from ~8 paying users.

---

## 15. Future Backlog

Features deferred from MVP, to be implemented after validation:

### High Priority

- [ ] Scan history UI (data already collected in scan_sessions)
- [ ] Grammar error analytics dashboard ("Top 5 mistakes you make")
- [ ] Push notifications for FSRS review reminders
- [ ] Vietnamese definitions batch import
- [ ] User-contributed definitions (community feature)

### Medium Priority

- [ ] Camera OCR scan (scan physical books/menus)
- [ ] Multi-language support (language column in words table)
- [ ] Lemma lookup table (replace simple suffix stripping)
- [ ] More role-play scenarios (20+)
- [ ] Conversation topic suggestions based on domain progress
- [ ] Audio pronunciation for vocabulary cards
- [ ] Social features: leaderboard, study groups

### Low Priority / Exploration

- [ ] Offline AI chat (local LLM on device)
- [ ] iOS app store deployment
- [ ] Integration with external content (news articles, YouTube subtitles)
- [ ] Gamification (streaks, achievements, XP)
- [ ] Admin dashboard for content management
- [ ] A/B testing FSRS parameters

---

## Appendix A: Environment Variables

### Flutter (.env)

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=eyJ...
FASTAPI_BASE_URL=http://your-server:8000/api/v1
PICOVOICE_ACCESS_KEY=your-picovoice-key
```

### FastAPI (.env)

```env
SUPABASE_DB_URL=postgresql://postgres:password@db.your-project.supabase.co:5432/postgres
SUPABASE_JWT_SECRET=your-jwt-secret
OPENAI_API_KEY=sk-...
ANTHROPIC_API_KEY=sk-ant-...  # optional, for Claude
LLM_PROVIDER=openai  # openai | anthropic | gemini
LLM_MODEL=gpt-4o-mini
WHISPER_MODEL=whisper-1
TTS_VOICE=en-US-AriaNeural
```

---

## Appendix B: Key Queries Quick Reference

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

---

_Document generated: 2026-03-08. Version 1.0._
_This document should be updated as design decisions evolve during implementation._
