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
