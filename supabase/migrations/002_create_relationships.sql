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
