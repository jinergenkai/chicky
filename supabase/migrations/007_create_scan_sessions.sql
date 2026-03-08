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
