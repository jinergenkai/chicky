-- Seed file: Insert initial domains from domains_seed.json
-- Run after all migrations

BEGIN;

-- Insert root domains first (no parent)
INSERT INTO domains (id, name, parent_id, icon, description) VALUES
    ('11111111-0001-0001-0001-000000000001', 'Daily Life',              NULL, '🏠', 'Everyday activities, routines, and household vocabulary'),
    ('11111111-0001-0001-0001-000000000005', 'Technology',              NULL, '💻', 'Computing, software, hardware, and digital technology'),
    ('11111111-0001-0001-0001-000000000006', 'Finance',                 NULL, '💰', 'Banking, investment, accounting, and financial markets'),
    ('11111111-0001-0001-0001-000000000008', 'Business',                NULL, '💼', 'Corporate vocabulary, management, marketing, and entrepreneurship'),
    ('11111111-0001-0001-0001-000000000009', 'Travel',                  NULL, '✈️', 'Transportation, accommodation, tourism, and travel planning'),
    ('11111111-0001-0001-0001-000000000010', 'Health',                  NULL, '🏥', 'Medicine, wellness, anatomy, and healthcare vocabulary'),
    ('11111111-0001-0001-0001-000000000011', 'Education',               NULL, '📚', 'Academic vocabulary, learning, teaching, and school life'),
    ('11111111-0001-0001-0001-000000000012', 'Sports',                  NULL, '⚽', 'Sports, athletics, fitness, and outdoor activities'),
    ('11111111-0001-0001-0001-000000000013', 'Arts',                    NULL, '🎨', 'Visual arts, music, literature, theatre, and creative vocabulary'),
    ('11111111-0001-0001-0001-000000000014', 'Science',                 NULL, '🔬', 'Natural sciences, research, experiments, and scientific terminology'),
    ('11111111-0001-0001-0001-000000000017', 'Emotions & Psychology',   NULL, '❤️', 'Feelings, mental states, personality, and psychological vocabulary')
ON CONFLICT (name) DO UPDATE
    SET icon        = EXCLUDED.icon,
        description = EXCLUDED.description;

-- Insert child domains (require parent to exist first)
INSERT INTO domains (id, name, parent_id, icon, description) VALUES
    ('11111111-0001-0001-0001-000000000002', 'Food & Drink',    '11111111-0001-0001-0001-000000000001', '🍽️',  'Food items, beverages, tastes, and eating vocabulary'),
    ('11111111-0001-0001-0001-000000000016', 'Social & Relationships', '11111111-0001-0001-0001-000000000001', '👥', 'Family, friendship, social situations, and interpersonal vocabulary'),
    ('11111111-0001-0001-0001-000000000007', 'Fintech',         '11111111-0001-0001-0001-000000000006', '📱',  'Financial technology, digital payments, and cryptocurrency'),
    ('11111111-0001-0001-0001-000000000015', 'Environment',     '11111111-0001-0001-0001-000000000014', '🌿',  'Nature, ecology, climate, and environmental issues')
ON CONFLICT (name) DO UPDATE
    SET icon        = EXCLUDED.icon,
        description = EXCLUDED.description;

-- Insert leaf domains (require sub-parent to exist)
INSERT INTO domains (id, name, parent_id, icon, description) VALUES
    ('11111111-0001-0001-0001-000000000003', 'Cooking', '11111111-0001-0001-0001-000000000002', '👨‍🍳', 'Cooking techniques, kitchen tools, and recipe vocabulary'),
    ('11111111-0001-0001-0001-000000000004', 'Baking',  '11111111-0001-0001-0001-000000000002', '🥐',  'Baking ingredients, methods, and pastry vocabulary')
ON CONFLICT (name) DO UPDATE
    SET icon        = EXCLUDED.icon,
        description = EXCLUDED.description;

COMMIT;
