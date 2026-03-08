-- Domain-word associations (rule-based tagging)
-- Run AFTER all_migrations.sql and words_seed.sql

INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'in'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'in'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'in'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'in'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'in'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'in'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'in'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'in'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'in'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'in'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'in'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'in'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'is'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'is'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'is'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'is'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'is'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'it'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'it'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'it'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'it'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'it'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'it'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'it'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'it'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'it'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'on'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'on'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'on'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'on'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'on'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'on'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'on'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'on'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'on'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'on'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'was'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'be'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'be'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'as'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'as'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'as'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'as'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'as'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'as'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'as'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'as'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'are'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'at'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'at'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'at'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'at'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'at'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'at'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'at'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'at'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'at'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'at'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'at'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'at'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'he'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'he'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'he'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'he'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'he'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'he'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'he'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'he'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'but'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'or'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'or'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'or'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'or'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'or'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'or'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'or'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'or'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'or'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'or'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'or'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'or'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'an'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'an'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'an'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'an'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'an'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'an'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'an'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'an'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'all'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'all'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'all'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'so'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'so'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'so'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'so'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'so'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'me'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'me'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'me'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'me'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'me'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'me'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'me'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'me'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'me'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'me'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'one'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'one'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'up'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'up'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'do'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'do'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'no'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'no'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'no'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'time'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'get'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'get'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'get'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'now'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'good'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'know'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'two'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'make'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'over'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'think'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'any'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'us'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'us'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'us'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'us'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'us'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'want'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'go'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'go'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'go'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'even'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'need'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'work'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'work'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'year'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'years'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'day'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'day'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'too'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'going'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'off'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'off'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'take'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'got'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'got'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'down'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'great'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'man'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'home'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'use'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'am'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'am'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'am'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'am'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'am'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'am'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'am'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'come'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'come'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'part'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'part'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'help'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'own'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'under'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'game'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'give'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'school'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'each'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'each'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'end'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'end'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'end'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'feel'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'feel'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'team'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'team'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'team'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'team'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'family'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'put'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'money'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'city'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'days'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'lot'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'night'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'play'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'company'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'company'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'let'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'called'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'different'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'set'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'getting'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'god'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'government'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'business'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'start'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'system'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'system'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'times'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'week'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'already'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'today'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'read'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'read'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'music'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'water'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'call'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'men'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'men'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'men'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'men'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'try'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'try'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'try'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'try'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'less'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'less'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'party'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'run'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'service'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'country'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'season'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'using'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'following'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'makes'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'together'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'war'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'car'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'story'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'working'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'course'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'games'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'health'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'able'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'able'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'book'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'friends'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'ago'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'talk'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'court'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'given'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'single'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'become'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'body'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'death'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'food'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'office'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'pay'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'history'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'research'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'research'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'started'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'university'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'win'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'win'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'win'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'air'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'friend'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'needs'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'playing'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'understand'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'class'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'comes'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'wanted'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'happy'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'months'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'data'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'light'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'morning'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'taken'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'age'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'age'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'age'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'age'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'age'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'red'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'red'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'report'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'form'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'form'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'form'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'heart'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'heart'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'services'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'act'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'act'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'act'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'act'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'fun'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'players'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'art'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'art'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'art'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'art'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'market'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'market'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'plan'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'talking'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'works'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'ready'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'sometimes'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'son'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'son'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'current'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'example'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'meet'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'meet'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'program'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'process'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'study'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'action'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'gets'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'month'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'students'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'board'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'cost'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'field'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'instead'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'thinking'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'wants'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'de'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'de'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'de'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'de'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'de'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'de'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'de'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'department'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'energy'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'energy'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'force'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'hear'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'played'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'price'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'price'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 're'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 're'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 're'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 're'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 're'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 're'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 're'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 're'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 're'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 're'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 're'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 're'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'rest'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'rest'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'rest'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'running'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'goes'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'project'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'account'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'co'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'co'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'co'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'co'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'co'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'co'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'co'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'co'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'co'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'co'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'co'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'co'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'parents'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'film'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'happened'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'security'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'happen'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'industry'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'player'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'test'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'weeks'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'break'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'companies'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'needed'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'present'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'takes'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'training'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'training'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'training'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'design'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'gold'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'gone'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'interest'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'learn'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'learn'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'al'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'al'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'al'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'al'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'al'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'al'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'al'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'al'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'al'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'bank'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'hot'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'hot'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'performance'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'performance'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'sent'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'worked'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'books'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'meeting'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'meeting'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'source'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'evidence'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'ok'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'ok'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'ok'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'production'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'rate'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'rate'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'reading'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'save'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'stand'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'tax'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'blue'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'drive'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'eat'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'eat'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'eat'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'eat'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'eat'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'fast'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'feeling'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'feeling'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'green'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'management'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'match'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'key'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'science'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'trade'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'character'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'football'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'led'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'style'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'blood'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'oil'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'article'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'kill'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'code'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'cover'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'currently'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'financial'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'race'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'sign'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'staff'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'walk'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'die'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'die'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'hospital'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'loss'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'parts'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'starting'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'systems'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'earth'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'earth'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'forget'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'goal'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'goal'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'internet'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'practice'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'sea'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'sea'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'sea'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'sea'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'base'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'created'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'created'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'la'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'la'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'la'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'la'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'la'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'la'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'mark'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'mark'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'missing'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'pass'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'professional'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'schools'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'sleep'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'table'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'ball'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'products'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'culture'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'culture'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'gives'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'growth'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'officer'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'pain'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'pain'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'tonight'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'write'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'write'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'create'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'create'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'network'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'network'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'sales'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'student'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'beat'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'capital'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'potential'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'treatment'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'treatment'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'ass'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'ass'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'ass'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'credit'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'hi'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'ice'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'ice'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'ice'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'ice'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'ice'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'ice'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'interesting'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'particular'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'reported'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'speed'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'travel'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'feet'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'sale'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'tour'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'welcome'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'forces'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'nature'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'nature'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'winning'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'clean'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'computer'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'income'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'income'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'photo'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'spend'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'sun'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'teams'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'teams'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'teams'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'asking'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'calling'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'coach'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'costs'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'designed'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'friday'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'happens'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'knowledge'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'particularly'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'search'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'search'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'train'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'train'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'train'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'fit'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'fit'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'goals'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'goals'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'hotel'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'interested'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'nobody'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'product'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'workers'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'brain'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'brain'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'contract'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'degree'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'features'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'growing'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'image'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'insurance'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'pro'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'pro'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'pro'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'sports'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'approach'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'dance'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'stock'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'weekend'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'beach'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'cash'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'latest'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'learning'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'learning'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'sunday'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'sunday'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'calls'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'color'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'competition'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'resources'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'skin'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'yesterday'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'disease'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'doctor'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'drink'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'feels'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'feels'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'fish'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'greater'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'grow'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'programs'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'reports'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'sit'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'trip'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'japan'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'parties'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'plant'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'spot'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'winter'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'characters'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'helped'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'nation'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'prices'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'prices'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'rates'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'shop'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'showing'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'sick'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'teacher'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'teacher'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'theory'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'theory'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'cell'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'drug'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'economy'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'environment'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'officers'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'ran'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'ran'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'ran'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'saturday'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'weather'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'weather'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'application'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'coffee'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'coffee'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'flight'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'google'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'heat'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'heat'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'heat'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'walking'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'appear'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'eating'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'learned'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'learned'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'losing'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'mobile'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'screen'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'serve'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'airport'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'animals'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'appears'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'investment'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'lie'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'partner'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'partner'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'plays'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'runs'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'wind'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'wind'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'appeared'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'becomes'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'brand'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'bus'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'chicago'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'count'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'count'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'digital'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'forced'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'fresh'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'mental'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'score'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'separate'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'smart'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'starts'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'throw'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'tom'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'tom'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'tom'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'budget'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'budget'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'feature'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'fund'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'seat'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'target'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'understanding'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'animal'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'apply'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'draw'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'employees'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'ex'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'ex'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'ex'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'ex'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'ex'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'japanese'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'memory'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'projects'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'spread'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'waste'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'apparently'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'apparently'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'artist'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'grade'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'happening'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'healthy'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'monday'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'somebody'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'strength'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'window'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'window'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'winner'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'ed'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'ed'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'ed'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'ed'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'ed'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'ed'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'greatest'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'greatest'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'apart'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'cat'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'cat'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'customers'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'dinner'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'helping'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'marketing'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'marketing'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'thinks'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'classes'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'drugs'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'housing'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'inc'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'skills'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'software'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'ad'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'ad'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'ad'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'ad'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'ad'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'apple'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'birthday'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'knowing'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'map'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'net'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'cells'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'driver'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'guide'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'images'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'investigation'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'paying'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'treat'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'treat'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'appreciate'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'discovered'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'edge'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'funds'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'helps'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'iron'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'martin'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'strategy'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'strategy'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'teachers'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'teachers'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'wine'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'wine'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'accounts'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'core'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'excellent'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'lee'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'medicine'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'mountain'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'port'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'port'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'port'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'reaction'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'spanish'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'sport'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'sport'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'stress'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'taste'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'tea'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'tea'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'tea'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'tea'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'tea'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'classic'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'ill'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'ill'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'kick'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'quarter'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'teaching'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'windows'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'windows'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'articles'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'capacity'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'climate'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'drinking'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'feelings'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'feelings'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'governor'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'mix'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'museum'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'plants'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'rain'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'rain'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'rain'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'rain'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'spending'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'treated'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'vice'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'vice'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'arts'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'beer'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'elements'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'environmental'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'environmental'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'forest'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'ocean'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'profit'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'wins'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'appearance'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'banks'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'creating'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'debt'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'homes'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'jump'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'writer'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'writer'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'download'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'exercise'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'exercise'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'girlfriend'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'increasing'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'loan'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'performed'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'restaurant'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'shopping'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'soft'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'sugar'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'transport'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'appeal'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'applied'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'appropriate'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'artists'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'ca'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'ca'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'ca'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'ca'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'ca'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'device'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'era'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'era'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'era'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'feed'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'golden'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'mistake'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'platform'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'saved'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'teach'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'teach'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'testing'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'tests'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'walked'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'businesses'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'holiday'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'holiday'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'interests'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'lunch'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'milk'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'pack'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'payment'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'perform'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'perform'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'apartment'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'cook'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'cook'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'journey'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'kitchen'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'mm'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'mm'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'specifically'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'taxes'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'applications'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'approved'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'approximately'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'corporate'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'corporate'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'films'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'friendly'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'lay'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'mixed'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'revenue'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'temperature'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'temperature'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'basically'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'display'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'examples'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'forgot'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'funding'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'ma'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'ma'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'ma'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'ma'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'ma'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'ma'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'ma'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'ma'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'ma'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'meat'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'novel'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'passing'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'scored'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'tuesday'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'allowing'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'champion'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'eu'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'literature'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'stream'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'talked'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'thursday'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'typically'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'un'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'un'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'un'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'un'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'un'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'un'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'un'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'breakfast'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'customer'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'drunk'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'id'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'id'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'markets'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'markets'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'talks'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'ticket'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'wing'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'creative'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'cycle'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'fields'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'goods'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'painting'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'painting'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'row'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'row'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'salt'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'threat'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'tickets'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'appointed'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'bond'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'boyfriend'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'cry'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'devices'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'matches'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'singing'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'spain'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'wednesday'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'drawing'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'drawing'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'ha'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'ha'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'load'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'plot'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'rent'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'trained'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'accurate'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'category'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'diet'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'em'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'em'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'em'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'em'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'em'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'fruit'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'parent'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'programme'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'storage'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'transportation'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'weekly'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'assets'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'basketball'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'creation'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'drivers'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'el'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'el'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'el'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'el'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'el'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'el'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'el'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'golf'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'grace'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'partners'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'partners'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'performing'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'revolution'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'sleeping'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'tournament'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'ban'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'carbon'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'doctors'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'earned'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'mate'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'panel'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'practices'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'rice'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'rice'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'writers'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'writers'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'advertising'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'baseball'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'championship'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'client'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'da'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'da'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'da'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'da'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'degrees'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'driven'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'expansion'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'manage'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'reporting'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'sing'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'causing'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'contest'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'deaths'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'drawn'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'fees'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'loud'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'raw'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'seats'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'automatically'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'balls'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'battery'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'breath'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'ft'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'paint'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'paint'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'rising'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'seasons'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'singer'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'steam'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'steam'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'steam'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'steam'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'theatre'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'theatre'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'cap'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'comedy'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'defeat'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'fee'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'fee'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'fee'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'loans'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'musical'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'approval'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'bread'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'bread'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'champions'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'employee'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'en'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'en'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'en'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'en'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'en'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'en'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'en'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'en'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'en'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'en'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'en'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'en'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'inner'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'le'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'le'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'le'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'le'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'le'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'le'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'le'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'le'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'le'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'le'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'le'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'monthly'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'mountains'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'operate'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'appointment'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'celebrate'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'gallery'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'repeat'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'wanting'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'earn'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'earn'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'meal'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'meetings'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'meetings'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'offices'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'pants'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'partnership'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'partnership'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'payments'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'symptoms'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'tested'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'bone'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'chart'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'everyday'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'fishing'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'gotten'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'healthcare'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'lesson'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'mount'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'nights'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'tears'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'thin'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'adventure'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'closing'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'cloud'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'colorado'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'colors'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'courses'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'courts'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'element'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'pa'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'pa'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'pa'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'pa'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'pa'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'pa'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'package'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'processing'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'server'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'clients'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'cooking'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'cooking'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'discovery'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'enforcement'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'featuring'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'governments'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'hungry'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'losses'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'math'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'mistakes'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'networks'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'networks'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'pet'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'photography'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'protest'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'waters'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'featured'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'happiness'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'hearts'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'hearts'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'muscle'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'singles'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'thread'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'wage'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'wings'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'beating'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'custom'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'drinks'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'ear'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'ear'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'ear'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'ear'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'ear'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'ear'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'electricity'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'helpful'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'ny'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'raising'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'scores'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'strategic'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'swimming'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'winners'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'wire'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'worker'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'designer'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'disappointed'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'kit'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'maps'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'min'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'na'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'na'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'na'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'na'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'na'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'na'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'na'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'participate'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'skill'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'soil'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'studying'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'walker'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'arthur'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'dragon'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'dust'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'evolution'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'foods'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'knife'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'readers'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'steal'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'butter'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'contracts'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'forgotten'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'gods'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'hop'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'hop'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'layer'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'organic'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'participants'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'participants'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'poetry'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'pot'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'recall'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'throwing'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'thrown'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'vacation'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'cleaning'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'discover'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'fitness'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'friendship'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'lifetime'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'makeup'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'mortgage'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'pan'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'pan'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'physics'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'potentially'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'researchers'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'researchers'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'resource'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'sciences'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'seattle'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'bishop'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'designs'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'experiment'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'increasingly'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'iv'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'iv'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'kicked'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'lessons'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'mo'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'mo'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'mo'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'mo'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'mo'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'pen'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'races'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'styles'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'agriculture'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'agriculture'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'log'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'nov'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'programming'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'sin'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'sin'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'asleep'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'diseases'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'doc'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'headquarters'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'juice'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'meets'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'profits'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'salary'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'strip'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'threatened'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'writes'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'writes'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'banking'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'carter'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'chemistry'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'expand'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'gorgeous'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'grateful'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'leather'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'oct'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'operated'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'outcome'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'painted'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'painted'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'poll'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'rep'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'reporter'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'singapore'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'tear'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'theater'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'theater'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'theater'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'ate'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'ate'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'ate'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'ate'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'ate'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'ate'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'ate'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'athletes'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'delicious'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'ease'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'generated'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'investors'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'reader'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'representation'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'restaurants'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'shops'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'swing'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'twin'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'computers'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'crossing'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'elementary'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'fundamental'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'fundamental'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'greatly'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'guidance'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'hospitals'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'participation'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'proven'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'spots'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'temperatures'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'temperatures'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'apparent'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'apparent'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'bones'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'brands'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'desperate'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'eve'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'feedback'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'il'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'il'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'il'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'il'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'il'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'il'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'invest'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'nursing'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'ongoing'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'painful'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'suspended'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'ukraine'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'walks'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'categories'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'database'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'explore'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'investigate'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'midnight'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'packed'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'presentation'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'sec'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'steady'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'toilet'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'treaty'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'triple'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'bat'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'edit'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'goodbye'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'mi'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'mi'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'mi'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'mi'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'mi'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'oregon'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'partly'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'petition'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'physically'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'rated'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'sa'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'sa'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'sa'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'sa'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'separated'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'stem'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'stem'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'accounting'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'certificate'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'coaching'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'framework'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'funded'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'integrated'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'lifestyle'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'mp'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'mp'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'mp'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'mp'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'mp'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'mp'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'performances'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'performances'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'se'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'se'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'se'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'se'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'se'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'se'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'se'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'se'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'se'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'strategies'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'targets'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'bloody'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'breathing'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'butt'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'characteristics'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'con'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'con'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'creates'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'creates'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'drives'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'expanded'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'experimental'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'experimental'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'feeding'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'grades'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'knight'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'las'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'logo'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'repeated'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'stocks'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'surprising'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'threats'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'tourism'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'bonds'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'corp'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'credits'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'earnings'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'investments'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'moderate'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'overcome'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'pit'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'pit'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'trains'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'traveling'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'treating'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'breathe'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'choosing'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'classical'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'classified'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'coaches'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'disappeared'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'exam'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'examination'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'homeless'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'mainstream'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'panic'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'pays'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'rip'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'va'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'va'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'venture'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'yea'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'ac'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'ac'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'ac'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'ac'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'ac'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'ac'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'ac'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'ac'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'accompanied'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'approaches'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'des'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'des'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'designated'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'focusing'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'forgive'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'guidelines'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'jumped'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'li'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'li'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'li'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'li'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'li'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'li'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'reads'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'signature'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'signature'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'stewart'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'venue'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'wages'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'applying'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'artificial'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'beneath'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'celebrated'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'destination'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'er'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'er'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'er'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'er'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'er'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'er'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'er'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'er'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'er'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'er'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'er'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'fastest'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'professionals'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'reactions'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'upgrade'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'ai'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'ai'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'ai'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'ai'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'ai'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'ai'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'applies'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'asset'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'baker'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'charter'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'differently'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'discussing'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'earning'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'jumping'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'maker'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'photograph'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'quarters'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'recipe'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'recipe'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'stealing'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'trips'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'appeals'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'beats'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'biology'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'cancelled'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'demonstrated'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'departure'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'dig'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'generate'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'gop'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'ho'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'ho'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'ho'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'ho'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'ho'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'ho'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'holidays'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'holidays'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'hotels'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'productive'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'ron'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'streaming'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'targeted'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'winds'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'winds'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'arc'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'arc'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'beaten'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'cia'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'creator'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'creatures'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'flights'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'gravity'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'hung'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'investigations'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'negotiations'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'playoffs'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'poet'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'repeatedly'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'swim'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'blowing'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'cheating'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'cheating'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'cultures'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'cultures'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'demonstrate'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'departments'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'experiments'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'fa'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'fa'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'hr'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'incorporated'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'incorporated'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'jerusalem'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'mentally'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'paintings'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'paintings'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'pollution'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'protests'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'th'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'th'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Health' AND w.word = 'th'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'th'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'th'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'th'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Science' AND w.word = 'th'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'th'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'th'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Travel' AND w.word = 'tourist'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'wireless'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'cargo'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'colored'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'filming'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'glasgow'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'invested'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'lit'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'mar'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'mar'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'mar'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'meals'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'nightmare'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'overnight'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'partially'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Arts' AND w.word = 'participating'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'platforms'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'pr'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'pr'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'pr'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Business' AND w.word = 'pr'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'pr'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Daily Life' AND w.word = 'practically'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'ram'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Cooking' AND w.word = 'spotted'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'spreading'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'sustainable'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'taxi'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Food & Drink' AND w.word = 'threatening'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'trace'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'trapped'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Environment' AND w.word = 'wasted'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'widespread'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'acknowledge'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'classification'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Technology' AND w.word = 'codes'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Finance' AND w.word = 'costume'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Sports' AND w.word = 'displayed'
ON CONFLICT DO NOTHING;
INSERT INTO domain_words (domain_id, word_id)
SELECT d.id, w.id FROM domains d, words w
WHERE d.name = 'Education' AND w.word = 'examine'
ON CONFLICT DO NOTHING;
