-- =====================================================
-- TOEIC ACE PATH - COMPLETE SUPABASE DATABASE SCHEMA
-- =====================================================
-- This schema supports a comprehensive TOEIC learning platform
-- with user management, exercises, assessments, progress tracking,
-- gamification, and admin features.
-- =====================================================

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- =====================================================
-- USERS & AUTHENTICATION
-- =====================================================

-- Users table (extends Supabase auth.users)
CREATE TABLE public.users (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    full_name VARCHAR(100),
    avatar_url TEXT,
    role VARCHAR(20) DEFAULT 'student' CHECK (role IN ('student', 'teacher', 'admin')),
    level VARCHAR(10) DEFAULT 'A1' CHECK (level IN ('A1', 'A2', 'B1', 'B2', 'C1', 'C2')),
    target_score INTEGER DEFAULT 600 CHECK (target_score >= 0 AND target_score <= 990),
    current_score INTEGER DEFAULT 0 CHECK (current_score >= 0 AND current_score <= 990),
    streak_days INTEGER DEFAULT 0,
    total_study_time_minutes INTEGER DEFAULT 0,
    last_login_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- User preferences
CREATE TABLE public.user_preferences (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    language VARCHAR(10) DEFAULT 'vi',
    email_notifications BOOLEAN DEFAULT true,
    push_notifications BOOLEAN DEFAULT true,
    daily_goal_minutes INTEGER DEFAULT 30,
    preferred_study_time VARCHAR(20) DEFAULT 'morning' CHECK (preferred_study_time IN ('morning', 'afternoon', 'evening', 'night')),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id)
);

-- User login history
CREATE TABLE public.user_login_history (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    login_at TIMESTAMPTZ DEFAULT NOW(),
    ip_address INET,
    user_agent TEXT,
    device_type VARCHAR(50)
);

-- =====================================================
-- CONTENT & EXERCISES
-- =====================================================

-- Topics/Categories
CREATE TABLE public.topics (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    slug VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    icon VARCHAR(50),
    color VARCHAR(20),
    order_index INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Exercises/Lessons
CREATE TABLE public.exercises (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    description TEXT,
    topic_id UUID REFERENCES public.topics(id) ON DELETE SET NULL,
    exercise_type VARCHAR(50) NOT NULL CHECK (exercise_type IN ('Reading', 'Listening', 'Writing', 'Speaking', 'Grammar', 'Vocabulary', 'Mixed')),
    difficulty_level VARCHAR(10) DEFAULT 'A1' CHECK (difficulty_level IN ('A1', 'A2', 'B1', 'B2', 'C1', 'C2')),
    toeic_part VARCHAR(20), -- e.g., 'Part 1', 'Part 5', etc.
    estimated_duration_minutes INTEGER DEFAULT 30,
    total_questions INTEGER DEFAULT 0,
    passing_score INTEGER DEFAULT 70,
    order_index INTEGER DEFAULT 0,
    is_published BOOLEAN DEFAULT false,
    is_premium BOOLEAN DEFAULT false,
    created_by UUID REFERENCES public.users(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Materials (for exercises - text, audio, video content)
CREATE TABLE public.materials (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    exercise_id UUID NOT NULL REFERENCES public.exercises(id) ON DELETE CASCADE,
    material_type VARCHAR(50) NOT NULL CHECK (material_type IN ('Text', 'Audio', 'Video', 'Image')),
    title VARCHAR(255),
    content TEXT, -- For text content or instructions
    file_url TEXT, -- For audio/video/image files
    duration_seconds INTEGER, -- For audio/video
    transcript TEXT, -- For audio/video
    order_index INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Questions
CREATE TABLE public.questions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    exercise_id UUID NOT NULL REFERENCES public.exercises(id) ON DELETE CASCADE,
    question_text TEXT NOT NULL,
    question_type VARCHAR(50) DEFAULT 'multiple_choice' CHECK (question_type IN ('multiple_choice', 'fill_blank', 'essay', 'speaking', 'true_false')),
    context TEXT, -- Additional context or passage for the question
    explanation TEXT, -- Explanation for the correct answer
    points INTEGER DEFAULT 1,
    order_index INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Options (for multiple choice questions)
CREATE TABLE public.options (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    question_id UUID NOT NULL REFERENCES public.questions(id) ON DELETE CASCADE,
    option_label VARCHAR(10) NOT NULL, -- A, B, C, D, etc.
    option_text TEXT NOT NULL,
    is_correct BOOLEAN DEFAULT false,
    order_index INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================================================
-- USER PROGRESS & SUBMISSIONS
-- =====================================================

-- User submissions
CREATE TABLE public.submissions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    exercise_id UUID NOT NULL REFERENCES public.exercises(id) ON DELETE CASCADE,
    score NUMERIC(5,2) DEFAULT 0,
    total_questions INTEGER DEFAULT 0,
    correct_answers INTEGER DEFAULT 0,
    duration_minutes INTEGER,
    is_completed BOOLEAN DEFAULT false,
    started_at TIMESTAMPTZ DEFAULT NOW(),
    submitted_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- User answers
CREATE TABLE public.user_answers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    submission_id UUID NOT NULL REFERENCES public.submissions(id) ON DELETE CASCADE,
    question_id UUID NOT NULL REFERENCES public.questions(id) ON DELETE CASCADE,
    selected_option_id UUID REFERENCES public.options(id) ON DELETE SET NULL,
    answer_text TEXT, -- For essay or fill-in-the-blank questions
    is_correct BOOLEAN,
    points_earned NUMERIC(5,2) DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================================================
-- LEARNING PLANS & ROADMAPS
-- =====================================================

-- Learning plans (25-day roadmap, etc.)
CREATE TABLE public.learning_plans (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    exercise_id UUID NOT NULL REFERENCES public.exercises(id) ON DELETE CASCADE,
    planned_date DATE NOT NULL,
    day_number INTEGER, -- For 25-day roadmap
    status VARCHAR(20) DEFAULT 'Pending' CHECK (status IN ('Pending', 'InProgress', 'Completed', 'Skipped')),
    start_time TIMESTAMPTZ,
    end_time TIMESTAMPTZ,
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id, exercise_id, planned_date)
);

-- Study sessions (time tracking)
CREATE TABLE public.study_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    exercise_id UUID REFERENCES public.exercises(id) ON DELETE SET NULL,
    session_date DATE DEFAULT CURRENT_DATE,
    duration_minutes INTEGER DEFAULT 0,
    activities JSONB, -- Track different activities during the session
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================================================
-- ASSESSMENTS & EVALUATIONS
-- =====================================================

-- Assessment tests (placement tests, mock tests)
CREATE TABLE public.assessments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    assessment_type VARCHAR(50) DEFAULT 'placement' CHECK (assessment_type IN ('placement', 'mock_test', 'progress_check', 'final_exam')),
    total_questions INTEGER DEFAULT 0,
    duration_minutes INTEGER DEFAULT 120,
    is_published BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Assessment results
CREATE TABLE public.assessment_results (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    assessment_id UUID NOT NULL REFERENCES public.assessments(id) ON DELETE CASCADE,
    total_score INTEGER DEFAULT 0,
    listening_score INTEGER DEFAULT 0,
    reading_score INTEGER DEFAULT 0,
    writing_score INTEGER DEFAULT 0,
    speaking_score INTEGER DEFAULT 0,
    predicted_toeic_score INTEGER,
    recommended_level VARCHAR(10),
    ai_analysis TEXT, -- AI-generated analysis
    completed_at TIMESTAMPTZ DEFAULT NOW(),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================================================
-- GAMIFICATION
-- =====================================================

-- Badges
CREATE TABLE public.badges (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    icon VARCHAR(50),
    badge_type VARCHAR(50) DEFAULT 'achievement' CHECK (badge_type IN ('achievement', 'streak', 'score', 'completion', 'special')),
    criteria JSONB, -- Conditions to earn the badge
    points INTEGER DEFAULT 0,
    rarity VARCHAR(20) DEFAULT 'common' CHECK (rarity IN ('common', 'rare', 'epic', 'legendary')),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- User badges
CREATE TABLE public.user_badges (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    badge_id UUID NOT NULL REFERENCES public.badges(id) ON DELETE CASCADE,
    awarded_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id, badge_id)
);

-- Achievements
CREATE TABLE public.achievements (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    achievement_type VARCHAR(50) NOT NULL,
    achievement_name VARCHAR(100) NOT NULL,
    description TEXT,
    points INTEGER DEFAULT 0,
    metadata JSONB,
    achieved_at TIMESTAMPTZ DEFAULT NOW()
);

-- Leaderboard
CREATE TABLE public.leaderboard (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    period VARCHAR(20) DEFAULT 'all_time' CHECK (period IN ('daily', 'weekly', 'monthly', 'all_time')),
    total_points INTEGER DEFAULT 0,
    rank INTEGER,
    exercises_completed INTEGER DEFAULT 0,
    avg_score NUMERIC(5,2) DEFAULT 0,
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id, period)
);

-- =====================================================
-- AI & PERSONALIZATION
-- =====================================================

-- AI feedback
CREATE TABLE public.ai_feedback (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    submission_id UUID REFERENCES public.submissions(id) ON DELETE CASCADE,
    feedback_type VARCHAR(50) CHECK (feedback_type IN ('writing', 'speaking', 'general', 'pronunciation')),
    ai_model VARCHAR(50),
    feedback_text TEXT,
    suggestions JSONB,
    strengths JSONB,
    weaknesses JSONB,
    improvement_areas JSONB,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Personalized recommendations
CREATE TABLE public.recommendations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    exercise_id UUID REFERENCES public.exercises(id) ON DELETE CASCADE,
    recommendation_type VARCHAR(50) DEFAULT 'next_exercise' CHECK (recommendation_type IN ('next_exercise', 'review', 'challenge', 'weak_area')),
    reason TEXT,
    priority INTEGER DEFAULT 0,
    is_viewed BOOLEAN DEFAULT false,
    is_completed BOOLEAN DEFAULT false,
    expires_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================================================
-- COMMUNICATION & NOTIFICATIONS
-- =====================================================

-- Notifications
CREATE TABLE public.notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    message TEXT,
    notification_type VARCHAR(50) DEFAULT 'info' CHECK (notification_type IN ('info', 'success', 'warning', 'error', 'reminder')),
    link TEXT,
    is_read BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Announcements
CREATE TABLE public.announcements (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(255) NOT NULL,
    content TEXT,
    announcement_type VARCHAR(50) DEFAULT 'general' CHECK (announcement_type IN ('general', 'maintenance', 'feature', 'event')),
    target_audience VARCHAR(50) DEFAULT 'all' CHECK (target_audience IN ('all', 'students', 'teachers', 'admins')),
    priority VARCHAR(20) DEFAULT 'normal' CHECK (priority IN ('low', 'normal', 'high', 'urgent')),
    is_published BOOLEAN DEFAULT false,
    published_at TIMESTAMPTZ,
    expires_at TIMESTAMPTZ,
    created_by UUID REFERENCES public.users(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================================================
-- SYSTEM & ADMIN
-- =====================================================

-- System settings
CREATE TABLE public.system_settings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    setting_key VARCHAR(100) UNIQUE NOT NULL,
    setting_value TEXT,
    setting_type VARCHAR(50) DEFAULT 'string' CHECK (setting_type IN ('string', 'number', 'boolean', 'json')),
    description TEXT,
    is_public BOOLEAN DEFAULT false,
    updated_by UUID REFERENCES public.users(id) ON DELETE SET NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Audit logs
CREATE TABLE public.audit_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
    action VARCHAR(100) NOT NULL,
    table_name VARCHAR(100),
    record_id UUID,
    old_data JSONB,
    new_data JSONB,
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Feedback & support
CREATE TABLE public.user_feedback (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
    feedback_type VARCHAR(50) CHECK (feedback_type IN ('bug', 'feature_request', 'general', 'content_issue')),
    subject VARCHAR(255),
    message TEXT NOT NULL,
    status VARCHAR(20) DEFAULT 'new' CHECK (status IN ('new', 'in_progress', 'resolved', 'closed')),
    priority VARCHAR(20) DEFAULT 'normal' CHECK (priority IN ('low', 'normal', 'high', 'urgent')),
    assigned_to UUID REFERENCES public.users(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================================================
-- INDEXES FOR PERFORMANCE
-- =====================================================

-- Users
CREATE INDEX idx_users_email ON public.users(email);
CREATE INDEX idx_users_username ON public.users(username);
CREATE INDEX idx_users_role ON public.users(role);
CREATE INDEX idx_users_level ON public.users(level);

-- Exercises
CREATE INDEX idx_exercises_topic ON public.exercises(topic_id);
CREATE INDEX idx_exercises_type ON public.exercises(exercise_type);
CREATE INDEX idx_exercises_level ON public.exercises(difficulty_level);
CREATE INDEX idx_exercises_published ON public.exercises(is_published);
CREATE INDEX idx_exercises_slug ON public.exercises(slug);

-- Questions
CREATE INDEX idx_questions_exercise ON public.questions(exercise_id);

-- Options
CREATE INDEX idx_options_question ON public.options(question_id);

-- Submissions
CREATE INDEX idx_submissions_user ON public.submissions(user_id);
CREATE INDEX idx_submissions_exercise ON public.submissions(exercise_id);
CREATE INDEX idx_submissions_completed ON public.submissions(is_completed);
CREATE INDEX idx_submissions_submitted_at ON public.submissions(submitted_at);

-- Learning Plans
CREATE INDEX idx_learning_plans_user ON public.learning_plans(user_id);
CREATE INDEX idx_learning_plans_date ON public.learning_plans(planned_date);
CREATE INDEX idx_learning_plans_status ON public.learning_plans(status);

-- User Badges
CREATE INDEX idx_user_badges_user ON public.user_badges(user_id);
CREATE INDEX idx_user_badges_badge ON public.user_badges(badge_id);

-- Notifications
CREATE INDEX idx_notifications_user ON public.notifications(user_id);
CREATE INDEX idx_notifications_read ON public.notifications(is_read);

-- Study Sessions
CREATE INDEX idx_study_sessions_user ON public.study_sessions(user_id);
CREATE INDEX idx_study_sessions_date ON public.study_sessions(session_date);

-- =====================================================
-- FUNCTIONS & TRIGGERS
-- =====================================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers for updated_at
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON public.users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_preferences_updated_at BEFORE UPDATE ON public.user_preferences
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_topics_updated_at BEFORE UPDATE ON public.topics
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_exercises_updated_at BEFORE UPDATE ON public.exercises
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_learning_plans_updated_at BEFORE UPDATE ON public.learning_plans
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_assessments_updated_at BEFORE UPDATE ON public.assessments
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_feedback_updated_at BEFORE UPDATE ON public.user_feedback
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Function to update user stats after submission
CREATE OR REPLACE FUNCTION update_user_stats_after_submission()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.is_completed = true AND NEW.submitted_at IS NOT NULL THEN
        -- Update user's current score (average of recent scores)
        UPDATE public.users
        SET 
            current_score = (
                SELECT COALESCE(AVG(score), 0)::INTEGER
                FROM public.submissions
                WHERE user_id = NEW.user_id
                    AND is_completed = true
                    AND submitted_at >= NOW() - INTERVAL '30 days'
            ),
            updated_at = NOW()
        WHERE id = NEW.user_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_user_stats
    AFTER INSERT OR UPDATE ON public.submissions
    FOR EACH ROW
    EXECUTE FUNCTION update_user_stats_after_submission();

-- Function to update streak days
CREATE OR REPLACE FUNCTION update_user_streak()
RETURNS TRIGGER AS $$
DECLARE
    last_session_date DATE;
    current_streak INTEGER;
BEGIN
    -- Get the last session date before this one
    SELECT session_date INTO last_session_date
    FROM public.study_sessions
    WHERE user_id = NEW.user_id
        AND session_date < NEW.session_date
    ORDER BY session_date DESC
    LIMIT 1;

    -- Get current streak
    SELECT streak_days INTO current_streak
    FROM public.users
    WHERE id = NEW.user_id;

    -- Update streak
    IF last_session_date IS NULL THEN
        -- First session
        UPDATE public.users
        SET streak_days = 1
        WHERE id = NEW.user_id;
    ELSIF last_session_date = NEW.session_date - INTERVAL '1 day' THEN
        -- Consecutive day
        UPDATE public.users
        SET streak_days = current_streak + 1
        WHERE id = NEW.user_id;
    ELSIF last_session_date < NEW.session_date - INTERVAL '1 day' THEN
        -- Streak broken
        UPDATE public.users
        SET streak_days = 1
        WHERE id = NEW.user_id;
    END IF;

    -- Update total study time
    UPDATE public.users
    SET total_study_time_minutes = total_study_time_minutes + NEW.duration_minutes
    WHERE id = NEW.user_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_user_streak
    AFTER INSERT ON public.study_sessions
    FOR EACH ROW
    EXECUTE FUNCTION update_user_streak();

-- Function to auto-award badges
CREATE OR REPLACE FUNCTION check_and_award_badges()
RETURNS TRIGGER AS $$
BEGIN
    -- Award "First Exercise" badge
    IF (SELECT COUNT(*) FROM public.submissions WHERE user_id = NEW.user_id AND is_completed = true) = 1 THEN
        INSERT INTO public.user_badges (user_id, badge_id)
        SELECT NEW.user_id, id FROM public.badges WHERE name = 'First Exercise Complete'
        ON CONFLICT DO NOTHING;
    END IF;

    -- Award "Perfect Score" badge
    IF NEW.score >= 100 THEN
        INSERT INTO public.user_badges (user_id, badge_id)
        SELECT NEW.user_id, id FROM public.badges WHERE name = 'Perfect Score'
        ON CONFLICT DO NOTHING;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_award_badges
    AFTER INSERT OR UPDATE ON public.submissions
    FOR EACH ROW
    EXECUTE FUNCTION check_and_award_badges();

-- =====================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- =====================================================

-- Enable RLS on all tables
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_preferences ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_login_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.topics ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.exercises ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.materials ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.options ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.submissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_answers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.learning_plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.study_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.assessments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.assessment_results ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.badges ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_badges ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.achievements ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.leaderboard ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ai_feedback ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.recommendations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.announcements ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.system_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.audit_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_feedback ENABLE ROW LEVEL SECURITY;

-- Users policies
CREATE POLICY "Users can view their own profile"
    ON public.users FOR SELECT
    USING (auth.uid() = id OR EXISTS (
        SELECT 1 FROM public.users WHERE id = auth.uid() AND role IN ('admin', 'teacher')
    ));

CREATE POLICY "Users can update their own profile"
    ON public.users FOR UPDATE
    USING (auth.uid() = id);

CREATE POLICY "Admins can do everything with users"
    ON public.users FOR ALL
    USING (EXISTS (
        SELECT 1 FROM public.users WHERE id = auth.uid() AND role = 'admin'
    ));

-- User preferences policies
CREATE POLICY "Users can manage their own preferences"
    ON public.user_preferences FOR ALL
    USING (auth.uid() = user_id);

-- Topics policies (public read)
CREATE POLICY "Topics are viewable by everyone"
    ON public.topics FOR SELECT
    USING (is_active = true);

CREATE POLICY "Admins and teachers can manage topics"
    ON public.topics FOR ALL
    USING (EXISTS (
        SELECT 1 FROM public.users WHERE id = auth.uid() AND role IN ('admin', 'teacher')
    ));

-- Exercises policies
CREATE POLICY "Published exercises are viewable by everyone"
    ON public.exercises FOR SELECT
    USING (is_published = true OR EXISTS (
        SELECT 1 FROM public.users WHERE id = auth.uid() AND role IN ('admin', 'teacher')
    ));

CREATE POLICY "Teachers and admins can manage exercises"
    ON public.exercises FOR ALL
    USING (EXISTS (
        SELECT 1 FROM public.users WHERE id = auth.uid() AND role IN ('admin', 'teacher')
    ));

-- Materials policies (inherit from exercises)
CREATE POLICY "Materials are viewable if exercise is viewable"
    ON public.materials FOR SELECT
    USING (EXISTS (
        SELECT 1 FROM public.exercises e
        WHERE e.id = exercise_id
        AND (e.is_published = true OR EXISTS (
            SELECT 1 FROM public.users WHERE id = auth.uid() AND role IN ('admin', 'teacher')
        ))
    ));

CREATE POLICY "Teachers and admins can manage materials"
    ON public.materials FOR ALL
    USING (EXISTS (
        SELECT 1 FROM public.users WHERE id = auth.uid() AND role IN ('admin', 'teacher')
    ));

-- Questions policies
CREATE POLICY "Questions are viewable if exercise is viewable"
    ON public.questions FOR SELECT
    USING (EXISTS (
        SELECT 1 FROM public.exercises e
        WHERE e.id = exercise_id
        AND (e.is_published = true OR EXISTS (
            SELECT 1 FROM public.users WHERE id = auth.uid() AND role IN ('admin', 'teacher')
        ))
    ));

CREATE POLICY "Teachers and admins can manage questions"
    ON public.questions FOR ALL
    USING (EXISTS (
        SELECT 1 FROM public.users WHERE id = auth.uid() AND role IN ('admin', 'teacher')
    ));

-- Options policies
CREATE POLICY "Options are viewable if question is viewable"
    ON public.options FOR SELECT
    USING (EXISTS (
        SELECT 1 FROM public.questions q
        JOIN public.exercises e ON e.id = q.exercise_id
        WHERE q.id = question_id
        AND (e.is_published = true OR EXISTS (
            SELECT 1 FROM public.users WHERE id = auth.uid() AND role IN ('admin', 'teacher')
        ))
    ));

CREATE POLICY "Teachers and admins can manage options"
    ON public.options FOR ALL
    USING (EXISTS (
        SELECT 1 FROM public.users WHERE id = auth.uid() AND role IN ('admin', 'teacher')
    ));

-- Submissions policies
CREATE POLICY "Users can view their own submissions"
    ON public.submissions FOR SELECT
    USING (auth.uid() = user_id OR EXISTS (
        SELECT 1 FROM public.users WHERE id = auth.uid() AND role IN ('admin', 'teacher')
    ));

CREATE POLICY "Users can create their own submissions"
    ON public.submissions FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own incomplete submissions"
    ON public.submissions FOR UPDATE
    USING (auth.uid() = user_id AND is_completed = false);

-- User answers policies
CREATE POLICY "Users can manage their own answers"
    ON public.user_answers FOR ALL
    USING (EXISTS (
        SELECT 1 FROM public.submissions s
        WHERE s.id = submission_id AND s.user_id = auth.uid()
    ));

-- Learning plans policies
CREATE POLICY "Users can manage their own learning plans"
    ON public.learning_plans FOR ALL
    USING (auth.uid() = user_id);

-- Study sessions policies
CREATE POLICY "Users can manage their own study sessions"
    ON public.study_sessions FOR ALL
    USING (auth.uid() = user_id);

-- Assessments policies
CREATE POLICY "Published assessments are viewable by everyone"
    ON public.assessments FOR SELECT
    USING (is_published = true OR EXISTS (
        SELECT 1 FROM public.users WHERE id = auth.uid() AND role IN ('admin', 'teacher')
    ));

CREATE POLICY "Admins and teachers can manage assessments"
    ON public.assessments FOR ALL
    USING (EXISTS (
        SELECT 1 FROM public.users WHERE id = auth.uid() AND role IN ('admin', 'teacher')
    ));

-- Assessment results policies
CREATE POLICY "Users can view their own assessment results"
    ON public.assessment_results FOR SELECT
    USING (auth.uid() = user_id OR EXISTS (
        SELECT 1 FROM public.users WHERE id = auth.uid() AND role IN ('admin', 'teacher')
    ));

CREATE POLICY "Users can create their own assessment results"
    ON public.assessment_results FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- Badges policies
CREATE POLICY "Badges are viewable by everyone"
    ON public.badges FOR SELECT
    USING (true);

CREATE POLICY "Admins can manage badges"
    ON public.badges FOR ALL
    USING (EXISTS (
        SELECT 1 FROM public.users WHERE id = auth.uid() AND role = 'admin'
    ));

-- User badges policies
CREATE POLICY "Users can view their own badges"
    ON public.user_badges FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "System can award badges"
    ON public.user_badges FOR INSERT
    WITH CHECK (true);

-- Achievements policies
CREATE POLICY "Users can view their own achievements"
    ON public.achievements FOR SELECT
    USING (auth.uid() = user_id);

-- Leaderboard policies
CREATE POLICY "Leaderboard is viewable by everyone"
    ON public.leaderboard FOR SELECT
    USING (true);

-- AI feedback policies
CREATE POLICY "Users can view their own AI feedback"
    ON public.ai_feedback FOR SELECT
    USING (auth.uid() = user_id OR EXISTS (
        SELECT 1 FROM public.users WHERE id = auth.uid() AND role IN ('admin', 'teacher')
    ));

CREATE POLICY "System can create AI feedback"
    ON public.ai_feedback FOR INSERT
    WITH CHECK (true);

-- Recommendations policies
CREATE POLICY "Users can view their own recommendations"
    ON public.recommendations FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can update their recommendations"
    ON public.recommendations FOR UPDATE
    USING (auth.uid() = user_id);

-- Notifications policies
CREATE POLICY "Users can view their own notifications"
    ON public.notifications FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can update their own notifications"
    ON public.notifications FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "System can create notifications"
    ON public.notifications FOR INSERT
    WITH CHECK (true);

-- Announcements policies
CREATE POLICY "Published announcements are viewable by everyone"
    ON public.announcements FOR SELECT
    USING (is_published = true AND (expires_at IS NULL OR expires_at > NOW()));

CREATE POLICY "Admins can manage announcements"
    ON public.announcements FOR ALL
    USING (EXISTS (
        SELECT 1 FROM public.users WHERE id = auth.uid() AND role = 'admin'
    ));

-- System settings policies
CREATE POLICY "Public settings are viewable by everyone"
    ON public.system_settings FOR SELECT
    USING (is_public = true OR EXISTS (
        SELECT 1 FROM public.users WHERE id = auth.uid() AND role = 'admin'
    ));

CREATE POLICY "Admins can manage system settings"
    ON public.system_settings FOR ALL
    USING (EXISTS (
        SELECT 1 FROM public.users WHERE id = auth.uid() AND role = 'admin'
    ));

-- Audit logs policies
CREATE POLICY "Admins can view audit logs"
    ON public.audit_logs FOR SELECT
    USING (EXISTS (
        SELECT 1 FROM public.users WHERE id = auth.uid() AND role = 'admin'
    ));

-- User feedback policies
CREATE POLICY "Users can view their own feedback"
    ON public.user_feedback FOR SELECT
    USING (auth.uid() = user_id OR EXISTS (
        SELECT 1 FROM public.users WHERE id = auth.uid() AND role IN ('admin', 'teacher')
    ));

CREATE POLICY "Users can create feedback"
    ON public.user_feedback FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Admins can manage feedback"
    ON public.user_feedback FOR ALL
    USING (EXISTS (
        SELECT 1 FROM public.users WHERE id = auth.uid() AND role = 'admin'
    ));
