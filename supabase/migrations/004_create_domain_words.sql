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
