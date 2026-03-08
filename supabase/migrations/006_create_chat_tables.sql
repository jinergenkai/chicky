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
