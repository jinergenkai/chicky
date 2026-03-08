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
