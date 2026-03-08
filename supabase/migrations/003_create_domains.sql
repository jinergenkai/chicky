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
