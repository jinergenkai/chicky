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
