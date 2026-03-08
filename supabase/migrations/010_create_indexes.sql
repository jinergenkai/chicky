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
