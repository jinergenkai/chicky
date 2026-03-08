-- Chicky: Combined migrations + seed
-- Run in Supabase Dashboard > SQL Editor

-- ============================================
-- migrations/001_create_words.sql
-- ============================================
-- Migration 001: Create words table
-- Stores the master vocabulary dictionary

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";  -- for trigram text search

CREATE TABLE IF NOT EXISTS words (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    word            TEXT NOT NULL,
    ipa             TEXT,
    definitions     JSONB NOT NULL DEFAULT '[]'::jsonb,
    cefr_level      TEXT CHECK (cefr_level IN ('A1', 'A2', 'B1', 'B2', 'C1', 'C2')),
    frequency_rank  INTEGER,
    example_sentences TEXT[] NOT NULL DEFAULT '{}',
    verified        BOOLEAN NOT NULL DEFAULT false,
    vi_translation  TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT words_word_unique UNIQUE (word)
);

-- Trigger to auto-update updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER words_updated_at
    BEFORE UPDATE ON words
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Indexes
CREATE INDEX IF NOT EXISTS idx_words_word ON words USING btree (word);
CREATE INDEX IF NOT EXISTS idx_words_word_trgm ON words USING gin (word gin_trgm_ops);
CREATE INDEX IF NOT EXISTS idx_words_cefr ON words (cefr_level);
CREATE INDEX IF NOT EXISTS idx_words_frequency ON words (frequency_rank);
CREATE INDEX IF NOT EXISTS idx_words_definitions ON words USING gin (definitions);

COMMENT ON TABLE words IS 'Master vocabulary dictionary';
COMMENT ON COLUMN words.definitions IS 'Array of {pos, definitions[], examples[]} objects';
COMMENT ON COLUMN words.frequency_rank IS 'Lower rank = more frequent (1 = most common)';

-- ============================================
-- migrations/002_create_relationships.sql
-- ============================================
-- Migration 002: rel_type enum + word_relationships table

CREATE TYPE rel_type AS ENUM (
    'synonym',
    'antonym',
    'hypernym',
    'hyponym',
    'collocation',
    'derived_form'
);

CREATE TABLE IF NOT EXISTS word_relationships (
    id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    word_id_a   UUID NOT NULL REFERENCES words (id) ON DELETE CASCADE,
    word_id_b   UUID NOT NULL REFERENCES words (id) ON DELETE CASCADE,
    rel_type    rel_type NOT NULL,
    weight      FLOAT NOT NULL DEFAULT 1.0 CHECK (weight >= 0 AND weight <= 1),
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT word_relationships_unique UNIQUE (word_id_a, word_id_b, rel_type)
);

CREATE INDEX IF NOT EXISTS idx_word_relationships_a ON word_relationships (word_id_a, rel_type);
CREATE INDEX IF NOT EXISTS idx_word_relationships_b ON word_relationships (word_id_b, rel_type);

COMMENT ON TABLE word_relationships IS 'Semantic relationships between words (WordNet-derived)';
COMMENT ON COLUMN word_relationships.weight IS 'Relationship strength 0..1';

-- ============================================
-- migrations/003_create_domains.sql
-- ============================================
-- Migration 003: Domains table (hierarchical vocabulary categories)

CREATE TABLE IF NOT EXISTS domains (
    id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name        TEXT NOT NULL,
    parent_id   UUID REFERENCES domains (id) ON DELETE SET NULL,
    icon        TEXT,
    description TEXT,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT domains_name_unique UNIQUE (name)
);

CREATE INDEX IF NOT EXISTS idx_domains_parent ON domains (parent_id);
CREATE INDEX IF NOT EXISTS idx_domains_name ON domains (name);

COMMENT ON TABLE domains IS 'Hierarchical vocabulary domains (e.g. Food > Cooking > Baking)';

-- ============================================
-- migrations/004_create_domain_words.sql
-- ============================================
-- Migration 004: domain_words join table

CREATE TABLE IF NOT EXISTS domain_words (
    id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    domain_id   UUID NOT NULL REFERENCES domains (id) ON DELETE CASCADE,
    word_id     UUID NOT NULL REFERENCES words (id) ON DELETE CASCADE,
    relevance   FLOAT NOT NULL DEFAULT 1.0 CHECK (relevance >= 0 AND relevance <= 1),
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT domain_words_unique UNIQUE (domain_id, word_id)
);

CREATE INDEX IF NOT EXISTS idx_domain_words_domain ON domain_words (domain_id);
CREATE INDEX IF NOT EXISTS idx_domain_words_word ON domain_words (word_id);
CREATE INDEX IF NOT EXISTS idx_domain_words_relevance ON domain_words (domain_id, relevance DESC);

COMMENT ON TABLE domain_words IS 'Mapping words to vocabulary domains with relevance scores';

-- ============================================
-- migrations/005_create_user_vocabulary.sql
-- ============================================
-- Migration 005: User vocabulary with FSRS scheduling fields

CREATE TYPE vocab_status AS ENUM ('new', 'learning', 'known', 'suspended');
CREATE TYPE vocab_source AS ENUM ('manual', 'scan', 'chat', 'domain');
CREATE TYPE fsrs_grade AS ENUM ('again', 'hard', 'good', 'easy');

CREATE TABLE IF NOT EXISTS user_vocabulary (
    user_id             UUID NOT NULL,  -- Supabase auth.users.id
    word_id             UUID NOT NULL REFERENCES words (id) ON DELETE CASCADE,

    -- Status
    status              vocab_status NOT NULL DEFAULT 'new',
    source              vocab_source NOT NULL DEFAULT 'manual',

    -- FSRS-4.5 scheduling parameters
    stability           FLOAT NOT NULL DEFAULT 1.0,   -- S: days until 90% retention
    difficulty          FLOAT NOT NULL DEFAULT 5.0,   -- D: 1 (easy) to 10 (hard)
    due_at              TIMESTAMPTZ,
    last_grade          fsrs_grade,
    reps                INTEGER NOT NULL DEFAULT 0,   -- total review count
    lapses              INTEGER NOT NULL DEFAULT 0,   -- forgotten count

    -- Timestamps
    first_seen_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    last_reviewed_at    TIMESTAMPTZ,

    PRIMARY KEY (user_id, word_id)
);

CREATE INDEX IF NOT EXISTS idx_uv_user_due ON user_vocabulary (user_id, due_at)
    WHERE status NOT IN ('new', 'suspended');
CREATE INDEX IF NOT EXISTS idx_uv_user_status ON user_vocabulary (user_id, status);
CREATE INDEX IF NOT EXISTS idx_uv_word ON user_vocabulary (word_id);

COMMENT ON TABLE user_vocabulary IS 'Per-user vocabulary with FSRS spaced repetition scheduling';
COMMENT ON COLUMN user_vocabulary.stability IS 'FSRS S parameter: interval for 90% recall (days)';
COMMENT ON COLUMN user_vocabulary.difficulty IS 'FSRS D parameter: 1=very easy, 10=very hard';

-- ============================================
-- migrations/006_create_chat_tables.sql
-- ============================================
-- Migration 006: Chat sessions and messages

CREATE TYPE chat_mode AS ENUM ('buddy', 'roleplay');
CREATE TYPE message_role AS ENUM ('user', 'assistant', 'system');

CREATE TABLE IF NOT EXISTS chat_sessions (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id         UUID NOT NULL,
    mode            chat_mode NOT NULL DEFAULT 'buddy',
    scenario_id     UUID,  -- references scenarios.id (created in 008)
    title           TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TRIGGER chat_sessions_updated_at
    BEFORE UPDATE ON chat_sessions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TABLE IF NOT EXISTS chat_messages (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    session_id      UUID NOT NULL REFERENCES chat_sessions (id) ON DELETE CASCADE,
    role            message_role NOT NULL,
    content         TEXT NOT NULL,
    corrections     JSONB NOT NULL DEFAULT '[]'::jsonb,
    audio_url       TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_chat_sessions_user ON chat_sessions (user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_chat_messages_session ON chat_messages (session_id, created_at);
CREATE INDEX IF NOT EXISTS idx_chat_messages_corrections ON chat_messages USING gin (corrections)
    WHERE jsonb_array_length(corrections) > 0;

COMMENT ON TABLE chat_sessions IS 'User chat sessions (buddy or roleplay mode)';
COMMENT ON COLUMN chat_messages.corrections IS 'Array of {type, original, corrected, explanation} correction objects';

-- ============================================
-- migrations/007_create_scan_sessions.sql
-- ============================================
-- Migration 007: Scan sessions table

CREATE TABLE IF NOT EXISTS scan_sessions (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id         UUID NOT NULL,
    raw_text        TEXT NOT NULL,
    word_count      INTEGER NOT NULL DEFAULT 0,
    unknown_count   INTEGER NOT NULL DEFAULT 0,
    scanned_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_scan_sessions_user ON scan_sessions (user_id, scanned_at DESC);

COMMENT ON TABLE scan_sessions IS 'Records of text scanned by users for vocabulary analysis';

-- ============================================
-- migrations/008_create_scenarios.sql
-- ============================================
-- Migration 008: Roleplay scenarios table

CREATE TABLE IF NOT EXISTS scenarios (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title           TEXT NOT NULL,
    description     TEXT NOT NULL,
    system_prompt   TEXT NOT NULL,
    difficulty      TEXT NOT NULL DEFAULT 'intermediate'
                    CHECK (difficulty IN ('beginner', 'intermediate', 'advanced')),
    icon            TEXT,
    is_active       BOOLEAN NOT NULL DEFAULT true,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT scenarios_title_unique UNIQUE (title)
);

-- Add foreign key from chat_sessions to scenarios (now that scenarios table exists)
ALTER TABLE chat_sessions
    ADD CONSTRAINT chat_sessions_scenario_fk
    FOREIGN KEY (scenario_id) REFERENCES scenarios (id) ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_scenarios_difficulty ON scenarios (difficulty)
    WHERE is_active = true;

-- Seed default scenarios
INSERT INTO scenarios (title, description, system_prompt, difficulty, icon) VALUES
(
    'Coffee Shop',
    'Practice ordering food and drinks and making small talk with a barista.',
    'You are a friendly barista at Morning Brew coffee shop. Help the customer order and make natural small talk.',
    'beginner',
    '☕'
),
(
    'Job Interview',
    'Practice answering interview questions for a software developer position.',
    'You are a professional HR manager interviewing the user for a Software Developer role. Ask common interview questions professionally.',
    'intermediate',
    '💼'
),
(
    'Doctor Visit',
    'Practice describing symptoms and asking medical questions.',
    'You are a friendly family doctor. The patient is coming in to describe a health concern. Use appropriate medical vocabulary.',
    'intermediate',
    '🏥'
),
(
    'Hotel Check-in',
    'Practice checking into a hotel and requesting amenities.',
    'You are a courteous hotel receptionist. Help the guest check in and answer questions about the hotel.',
    'beginner',
    '🏨'
),
(
    'Debate Partner',
    'Practice formal argument and persuasion in a structured debate.',
    'You are an articulate debate partner. Take the opposing position on any topic the user proposes and engage in respectful debate.',
    'advanced',
    '🎭'
)
ON CONFLICT (title) DO NOTHING;

-- ============================================
-- migrations/009_enable_rls.sql
-- ============================================
-- Migration 009: Enable Row Level Security (RLS) policies

-- ── words (public read, service role write) ───────────────────────────────

ALTER TABLE words ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Words are publicly readable"
    ON words FOR SELECT
    USING (true);

CREATE POLICY "Only service role can insert words"
    ON words FOR INSERT
    WITH CHECK (auth.role() = 'service_role');

CREATE POLICY "Only service role can update words"
    ON words FOR UPDATE
    USING (auth.role() = 'service_role');

-- ── word_relationships (public read) ─────────────────────────────────────

ALTER TABLE word_relationships ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Relationships are publicly readable"
    ON word_relationships FOR SELECT
    USING (true);

CREATE POLICY "Only service role can manage relationships"
    ON word_relationships FOR ALL
    USING (auth.role() = 'service_role');

-- ── domains (public read) ─────────────────────────────────────────────────

ALTER TABLE domains ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Domains are publicly readable"
    ON domains FOR SELECT
    USING (true);

CREATE POLICY "Only service role can manage domains"
    ON domains FOR ALL
    USING (auth.role() = 'service_role');

-- ── domain_words (public read) ────────────────────────────────────────────

ALTER TABLE domain_words ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Domain words are publicly readable"
    ON domain_words FOR SELECT
    USING (true);

CREATE POLICY "Only service role can manage domain words"
    ON domain_words FOR ALL
    USING (auth.role() = 'service_role');

-- ── user_vocabulary (owner only) ──────────────────────────────────────────

ALTER TABLE user_vocabulary ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own vocabulary"
    ON user_vocabulary FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own vocabulary"
    ON user_vocabulary FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own vocabulary"
    ON user_vocabulary FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own vocabulary"
    ON user_vocabulary FOR DELETE
    USING (auth.uid() = user_id);

-- ── chat_sessions (owner only) ────────────────────────────────────────────

ALTER TABLE chat_sessions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own chat sessions"
    ON chat_sessions FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own chat sessions"
    ON chat_sessions FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own chat sessions"
    ON chat_sessions FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own chat sessions"
    ON chat_sessions FOR DELETE
    USING (auth.uid() = user_id);

-- ── chat_messages (via session ownership) ────────────────────────────────

ALTER TABLE chat_messages ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view messages in their sessions"
    ON chat_messages FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM chat_sessions cs
            WHERE cs.id = chat_messages.session_id
            AND cs.user_id = auth.uid()
        )
    );

CREATE POLICY "Users can insert messages in their sessions"
    ON chat_messages FOR INSERT
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM chat_sessions cs
            WHERE cs.id = chat_messages.session_id
            AND cs.user_id = auth.uid()
        )
    );

-- ── scan_sessions (owner only) ────────────────────────────────────────────

ALTER TABLE scan_sessions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own scan sessions"
    ON scan_sessions FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own scan sessions"
    ON scan_sessions FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- ── scenarios (public read) ───────────────────────────────────────────────

ALTER TABLE scenarios ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Scenarios are publicly readable"
    ON scenarios FOR SELECT
    USING (is_active = true);

CREATE POLICY "Only service role can manage scenarios"
    ON scenarios FOR ALL
    USING (auth.role() = 'service_role');

-- ============================================
-- migrations/010_create_indexes.sql
-- ============================================
-- Migration 010: Additional performance indexes

-- ── Full-text search on words ─────────────────────────────────────────────

-- GIN index for fast full-text search on word text
CREATE INDEX IF NOT EXISTS idx_words_fts ON words
    USING gin (to_tsvector('english', word));

-- Composite index for vocabulary browsing by CEFR + frequency
CREATE INDEX IF NOT EXISTS idx_words_cefr_freq ON words (cefr_level, frequency_rank)
    WHERE verified = true;

-- ── User vocabulary scheduling ────────────────────────────────────────────

-- Covering index for due-card queries (avoids table scan)
CREATE INDEX IF NOT EXISTS idx_uv_due_cards ON user_vocabulary (user_id, due_at, status)
    INCLUDE (word_id, stability, difficulty, reps, lapses)
    WHERE status IN ('learning', 'known');

-- Index for new card queue
CREATE INDEX IF NOT EXISTS idx_uv_new_cards ON user_vocabulary (user_id, first_seen_at)
    WHERE status = 'new';

-- Index for stats aggregation
CREATE INDEX IF NOT EXISTS idx_uv_stats ON user_vocabulary (user_id, status);

-- ── Chat history ──────────────────────────────────────────────────────────

-- Covering index for loading chat history
CREATE INDEX IF NOT EXISTS idx_chat_messages_session_time ON chat_messages
    (session_id, created_at ASC)
    INCLUDE (role, content, corrections);

-- Sessions by user (most recent first)
CREATE INDEX IF NOT EXISTS idx_chat_sessions_user_time ON chat_sessions
    (user_id, updated_at DESC);

-- ── Scan sessions ─────────────────────────────────────────────────────────

CREATE INDEX IF NOT EXISTS idx_scan_sessions_user_time ON scan_sessions
    (user_id, scanned_at DESC);

-- ── Domain vocabulary ─────────────────────────────────────────────────────

-- Composite for fetching words in a domain sorted by frequency
CREATE INDEX IF NOT EXISTS idx_domain_words_freq ON domain_words (domain_id)
    INCLUDE (word_id, relevance);

-- ── Word relationships ────────────────────────────────────────────────────

CREATE INDEX IF NOT EXISTS idx_wr_type_a ON word_relationships (word_id_a, rel_type)
    INCLUDE (word_id_b, weight);

CREATE INDEX IF NOT EXISTS idx_wr_type_b ON word_relationships (word_id_b, rel_type)
    INCLUDE (word_id_a, weight);

-- ============================================
-- seed.sql
-- ============================================
-- Seed file: Insert initial domains from domains_seed.json
-- Run after all migrations

BEGIN;

-- Insert root domains first (no parent)
INSERT INTO domains (id, name, parent_id, icon, description) VALUES
    ('11111111-0001-0001-0001-000000000001', 'Daily Life',              NULL, '🏠', 'Everyday activities, routines, and household vocabulary'),
    ('11111111-0001-0001-0001-000000000005', 'Technology',              NULL, '💻', 'Computing, software, hardware, and digital technology'),
    ('11111111-0001-0001-0001-000000000006', 'Finance',                 NULL, '💰', 'Banking, investment, accounting, and financial markets'),
    ('11111111-0001-0001-0001-000000000008', 'Business',                NULL, '💼', 'Corporate vocabulary, management, marketing, and entrepreneurship'),
    ('11111111-0001-0001-0001-000000000009', 'Travel',                  NULL, '✈️', 'Transportation, accommodation, tourism, and travel planning'),
    ('11111111-0001-0001-0001-000000000010', 'Health',                  NULL, '🏥', 'Medicine, wellness, anatomy, and healthcare vocabulary'),
    ('11111111-0001-0001-0001-000000000011', 'Education',               NULL, '📚', 'Academic vocabulary, learning, teaching, and school life'),
    ('11111111-0001-0001-0001-000000000012', 'Sports',                  NULL, '⚽', 'Sports, athletics, fitness, and outdoor activities'),
    ('11111111-0001-0001-0001-000000000013', 'Arts',                    NULL, '🎨', 'Visual arts, music, literature, theatre, and creative vocabulary'),
    ('11111111-0001-0001-0001-000000000014', 'Science',                 NULL, '🔬', 'Natural sciences, research, experiments, and scientific terminology'),
    ('11111111-0001-0001-0001-000000000017', 'Emotions & Psychology',   NULL, '❤️', 'Feelings, mental states, personality, and psychological vocabulary')
ON CONFLICT (name) DO UPDATE
    SET icon        = EXCLUDED.icon,
        description = EXCLUDED.description;

-- Insert child domains (require parent to exist first)
INSERT INTO domains (id, name, parent_id, icon, description) VALUES
    ('11111111-0001-0001-0001-000000000002', 'Food & Drink',    '11111111-0001-0001-0001-000000000001', '🍽️',  'Food items, beverages, tastes, and eating vocabulary'),
    ('11111111-0001-0001-0001-000000000016', 'Social & Relationships', '11111111-0001-0001-0001-000000000001', '👥', 'Family, friendship, social situations, and interpersonal vocabulary'),
    ('11111111-0001-0001-0001-000000000007', 'Fintech',         '11111111-0001-0001-0001-000000000006', '📱',  'Financial technology, digital payments, and cryptocurrency'),
    ('11111111-0001-0001-0001-000000000015', 'Environment',     '11111111-0001-0001-0001-000000000014', '🌿',  'Nature, ecology, climate, and environmental issues')
ON CONFLICT (name) DO UPDATE
    SET icon        = EXCLUDED.icon,
        description = EXCLUDED.description;

-- Insert leaf domains (require sub-parent to exist)
INSERT INTO domains (id, name, parent_id, icon, description) VALUES
    ('11111111-0001-0001-0001-000000000003', 'Cooking', '11111111-0001-0001-0001-000000000002', '👨‍🍳', 'Cooking techniques, kitchen tools, and recipe vocabulary'),
    ('11111111-0001-0001-0001-000000000004', 'Baking',  '11111111-0001-0001-0001-000000000002', '🥐',  'Baking ingredients, methods, and pastry vocabulary')
ON CONFLICT (name) DO UPDATE
    SET icon        = EXCLUDED.icon,
        description = EXCLUDED.description;

COMMIT;
