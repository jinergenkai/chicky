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
