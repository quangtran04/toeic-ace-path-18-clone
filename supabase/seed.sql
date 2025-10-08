-- =====================================================
-- TOEIC ACE PATH - SEED DATA
-- =====================================================
-- Sample data for testing and development
-- =====================================================

-- =====================================================
-- TOPICS
-- =====================================================

INSERT INTO public.topics (name, slug, description, icon, color, order_index, is_active) VALUES
('Nationalities', 'nationalities', 'Learn about countries and nationalities in TOEIC context', 'Globe', 'blue', 1, true),
('Business Communication', 'business-communication', 'Professional communication in business settings', 'Briefcase', 'purple', 2, true),
('Office Environment', 'office-environment', 'Vocabulary and scenarios about office life', 'Building', 'green', 3, true),
('Travel & Tourism', 'travel-tourism', 'Travel-related vocabulary and situations', 'Plane', 'orange', 4, true),
('Meetings & Conferences', 'meetings-conferences', 'Meeting and conference scenarios', 'Users', 'red', 5, true),
('Finance & Banking', 'finance-banking', 'Financial and banking terminology', 'DollarSign', 'yellow', 6, true),
('Technology', 'technology', 'Technology and IT-related content', 'Laptop', 'cyan', 7, true),
('Human Resources', 'human-resources', 'HR and employment topics', 'UserPlus', 'pink', 8, true);

-- =====================================================
-- BADGES
-- =====================================================

INSERT INTO public.badges (name, description, icon, badge_type, points, rarity) VALUES
('First Exercise Complete', 'Complete your first exercise', 'Award', 'achievement', 10, 'common'),
('Perfect Score', 'Get a perfect score of 100%', 'Trophy', 'score', 50, 'rare'),
('7 Day Streak', 'Study for 7 consecutive days', 'Flame', 'streak', 100, 'epic'),
('30 Day Streak', 'Study for 30 consecutive days', 'Flame', 'streak', 500, 'legendary'),
('Speed Learner', 'Complete an exercise in record time', 'Zap', 'achievement', 25, 'common'),
('TOEIC Master', 'Achieve a predicted score of 900+', 'Crown', 'score', 1000, 'legendary'),
('Early Bird', 'Study before 8 AM', 'Sunrise', 'achievement', 15, 'common'),
('Night Owl', 'Study after 10 PM', 'Moon', 'achievement', 15, 'common'),
('Consistency King', 'Complete exercises 5 days in a row', 'Target', 'streak', 75, 'rare'),
('Knowledge Seeker', 'Complete 50 exercises', 'BookOpen', 'completion', 200, 'epic');

-- =====================================================
-- SAMPLE EXERCISES
-- =====================================================

-- Exercise 1: Nationalities - Reading
INSERT INTO public.exercises (
    title, 
    slug, 
    description, 
    topic_id,
    exercise_type,
    difficulty_level,
    toeic_part,
    estimated_duration_minutes,
    total_questions,
    passing_score,
    order_index,
    is_published
) VALUES (
    'Nationalities and Countries - Day 1',
    'nationalities-countries-day-1',
    'Learn vocabulary related to nationalities and their corresponding countries',
    (SELECT id FROM public.topics WHERE slug = 'nationalities'),
    'Reading',
    'A1',
    'Part 5',
    30,
    10,
    70,
    1,
    true
);

-- Materials for Nationalities exercise
INSERT INTO public.materials (exercise_id, material_type, title, content, order_index) VALUES
((SELECT id FROM public.exercises WHERE slug = 'nationalities-countries-day-1'),
 'Text',
 'Introduction to Nationalities',
 E'In TOEIC, you will often encounter questions about nationalities and countries. Understanding the suffixes used to form nationalities is important:\n\n- Countries ending in common suffixes:\n  • -ian: Italy → Italian, Brazil → Brazilian\n  • -an: Mexico → Mexican, America → American\n  • -ish: Britain → British, Spain → Spanish\n  • -ese: Japan → Japanese, China → Chinese\n\nLet\'s practice with some common examples!',
 1);

-- Questions for Nationalities exercise
INSERT INTO public.questions (exercise_id, question_text, question_type, explanation, points, order_index) VALUES
((SELECT id FROM public.exercises WHERE slug = 'nationalities-countries-day-1'),
 'What is NOT a common suffix for nationalities?',
 'multiple_choice',
 'The suffix "-ion" is typically used for nouns and verbs, not for forming nationalities. Common nationality suffixes include -an, -ish, -ese, and -ian.',
 1,
 1),
 
((SELECT id FROM public.exercises WHERE slug = 'nationalities-countries-day-1'),
 'What is the nationality for someone from Mexico?',
 'multiple_choice',
 'People from Mexico are called "Mexican" using the -an suffix.',
 1,
 2),
 
((SELECT id FROM public.exercises WHERE slug = 'nationalities-countries-day-1'),
 'Which country uses the suffix "-ese" for its nationality?',
 'multiple_choice',
 'Japan uses the suffix "-ese" to form Japanese. Other examples include China (Chinese) and Vietnam (Vietnamese).',
 1,
 3);

-- Options for Question 1
INSERT INTO public.options (question_id, option_label, option_text, is_correct, order_index) VALUES
((SELECT id FROM public.questions WHERE order_index = 1 AND exercise_id = (SELECT id FROM public.exercises WHERE slug = 'nationalities-countries-day-1')),
 'A', '-an', false, 1),
((SELECT id FROM public.questions WHERE order_index = 1 AND exercise_id = (SELECT id FROM public.exercises WHERE slug = 'nationalities-countries-day-1')),
 'B', '-ish', false, 2),
((SELECT id FROM public.questions WHERE order_index = 1 AND exercise_id = (SELECT id FROM public.exercises WHERE slug = 'nationalities-countries-day-1')),
 'C', '-ese', false, 3),
((SELECT id FROM public.questions WHERE order_index = 1 AND exercise_id = (SELECT id FROM public.exercises WHERE slug = 'nationalities-countries-day-1')),
 'D', '-ion', true, 4);

-- Options for Question 2
INSERT INTO public.options (question_id, option_label, option_text, is_correct, order_index) VALUES
((SELECT id FROM public.questions WHERE order_index = 2 AND exercise_id = (SELECT id FROM public.exercises WHERE slug = 'nationalities-countries-day-1')),
 'A', 'Mexician', false, 1),
((SELECT id FROM public.questions WHERE order_index = 2 AND exercise_id = (SELECT id FROM public.exercises WHERE slug = 'nationalities-countries-day-1')),
 'B', 'Mexican', true, 2),
((SELECT id FROM public.questions WHERE order_index = 2 AND exercise_id = (SELECT id FROM public.exercises WHERE slug = 'nationalities-countries-day-1')),
 'C', 'Mexicoian', false, 3);

-- Options for Question 3
INSERT INTO public.options (question_id, option_label, option_text, is_correct, order_index) VALUES
((SELECT id FROM public.questions WHERE order_index = 3 AND exercise_id = (SELECT id FROM public.exercises WHERE slug = 'nationalities-countries-day-1')),
 'A', 'Italy', false, 1),
((SELECT id FROM public.questions WHERE order_index = 3 AND exercise_id = (SELECT id FROM public.exercises WHERE slug = 'nationalities-countries-day-1')),
 'B', 'Spain', false, 2),
((SELECT id FROM public.questions WHERE order_index = 3 AND exercise_id = (SELECT id FROM public.exercises WHERE slug = 'nationalities-countries-day-1')),
 'C', 'Japan', true, 3),
((SELECT id FROM public.questions WHERE order_index = 3 AND exercise_id = (SELECT id FROM public.exercises WHERE slug = 'nationalities-countries-day-1')),
 'D', 'Britain', false, 4);

-- Exercise 2: Business Communication - Listening
INSERT INTO public.exercises (
    title, 
    slug, 
    description, 
    topic_id,
    exercise_type,
    difficulty_level,
    toeic_part,
    estimated_duration_minutes,
    total_questions,
    passing_score,
    order_index,
    is_published
) VALUES (
    'Business Email Vocabulary',
    'business-email-vocabulary',
    'Common phrases and vocabulary used in business emails',
    (SELECT id FROM public.topics WHERE slug = 'business-communication'),
    'Reading',
    'A2',
    'Part 7',
    25,
    8,
    70,
    1,
    true
);

-- Exercise 3: Office Environment - Grammar
INSERT INTO public.exercises (
    title, 
    slug, 
    description, 
    topic_id,
    exercise_type,
    difficulty_level,
    toeic_part,
    estimated_duration_minutes,
    total_questions,
    passing_score,
    order_index,
    is_published
) VALUES (
    'Office Supplies and Equipment',
    'office-supplies-equipment',
    'Learn vocabulary for common office items and equipment',
    (SELECT id FROM public.topics WHERE slug = 'office-environment'),
    'Vocabulary',
    'A1',
    'Part 5',
    20,
    12,
    70,
    1,
    true
);

-- =====================================================
-- SAMPLE ASSESSMENTS
-- =====================================================

INSERT INTO public.assessments (title, description, assessment_type, total_questions, duration_minutes, is_published) VALUES
('TOEIC Placement Test', 'Determine your current TOEIC level and get personalized recommendations', 'placement', 30, 60, true),
('Full TOEIC Mock Test', 'Complete TOEIC practice test with all sections', 'mock_test', 200, 120, true),
('Weekly Progress Check', 'Check your weekly learning progress', 'progress_check', 20, 30, true);

-- =====================================================
-- SYSTEM SETTINGS
-- =====================================================

INSERT INTO public.system_settings (setting_key, setting_value, setting_type, description, is_public) VALUES
('site_name', 'TOEIC Ace Path', 'string', 'Website name', true),
('site_description', 'Master TOEIC in 25 days with AI-powered learning', 'string', 'Website description', true),
('support_email', 'support@toeicacepath.com', 'string', 'Support contact email', true),
('max_daily_exercises', '10', 'number', 'Maximum exercises a user can complete per day', false),
('enable_ai_feedback', 'true', 'boolean', 'Enable AI-powered feedback feature', false),
('min_passing_score', '70', 'number', 'Minimum score to pass an exercise', false),
('streak_reward_points', '10', 'number', 'Points awarded for maintaining streak', false);

-- =====================================================
-- SAMPLE ANNOUNCEMENTS
-- =====================================================

INSERT INTO public.announcements (title, content, announcement_type, target_audience, priority, is_published, published_at) VALUES
('Welcome to TOEIC Ace Path!', 'Start your journey to TOEIC mastery with our 25-day personalized learning path. Complete your assessment to get started!', 'general', 'all', 'high', true, NOW()),
('New AI Features Available', 'We have added AI-powered speaking practice and pronunciation feedback. Try it now in your dashboard!', 'feature', 'all', 'normal', true, NOW()),
('Weekly Challenge: Vocabulary Builder', 'Join our weekly vocabulary challenge and compete with other learners. Top 10 participants win special badges!', 'event', 'students', 'normal', true, NOW());

-- =====================================================
-- HELPER FUNCTIONS FOR DEVELOPMENT
-- =====================================================

-- Function to get exercise statistics
CREATE OR REPLACE FUNCTION get_exercise_stats(exercise_uuid UUID)
RETURNS TABLE (
    total_attempts BIGINT,
    avg_score NUMERIC,
    completion_rate NUMERIC,
    avg_duration NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*)::BIGINT as total_attempts,
        ROUND(AVG(score), 2) as avg_score,
        ROUND(COUNT(*) FILTER (WHERE is_completed = true)::NUMERIC / NULLIF(COUNT(*)::NUMERIC, 0) * 100, 2) as completion_rate,
        ROUND(AVG(duration_minutes), 2) as avg_duration
    FROM public.submissions
    WHERE exercise_id = exercise_uuid;
END;
$$ LANGUAGE plpgsql;

-- Function to get user progress summary
CREATE OR REPLACE FUNCTION get_user_progress_summary(user_uuid UUID)
RETURNS TABLE (
    total_exercises_completed INTEGER,
    avg_score NUMERIC,
    current_streak INTEGER,
    total_study_hours NUMERIC,
    badges_earned INTEGER,
    current_level VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        (SELECT COUNT(DISTINCT exercise_id)::INTEGER FROM public.submissions WHERE user_id = user_uuid AND is_completed = true),
        (SELECT ROUND(AVG(score), 2) FROM public.submissions WHERE user_id = user_uuid AND is_completed = true),
        u.streak_days,
        ROUND(u.total_study_time_minutes::NUMERIC / 60, 2),
        (SELECT COUNT(*)::INTEGER FROM public.user_badges WHERE user_badges.user_id = user_uuid),
        u.level
    FROM public.users u
    WHERE u.id = user_uuid;
END;
$$ LANGUAGE plpgsql;

-- Function to get leaderboard
CREATE OR REPLACE FUNCTION get_leaderboard(period_type VARCHAR DEFAULT 'all_time', limit_count INTEGER DEFAULT 10)
RETURNS TABLE (
    rank BIGINT,
    user_id UUID,
    username VARCHAR,
    total_points INTEGER,
    exercises_completed INTEGER,
    avg_score NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        ROW_NUMBER() OVER (ORDER BY l.total_points DESC) as rank,
        l.user_id,
        u.username,
        l.total_points,
        l.exercises_completed,
        l.avg_score
    FROM public.leaderboard l
    JOIN public.users u ON u.id = l.user_id
    WHERE l.period = period_type
    ORDER BY l.total_points DESC
    LIMIT limit_count;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- NOTES
-- =====================================================

-- To use this seed data:
-- 1. First run schema.sql to create the database structure
-- 2. Then run this seed.sql to populate sample data
-- 3. Use the helper functions to query statistics and progress

-- Sample queries:
-- SELECT * FROM get_exercise_stats('exercise-uuid-here');
-- SELECT * FROM get_user_progress_summary('user-uuid-here');
-- SELECT * FROM get_leaderboard('weekly', 20);
