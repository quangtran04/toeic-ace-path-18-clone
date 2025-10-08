# TOEIC Ace Path - Database Entity Relationship Diagram

## 📊 Database Schema Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         TOEIC ACE PATH DATABASE SCHEMA                      │
└─────────────────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────────────────┐
│                          1. USERS & AUTHENTICATION                           │
└──────────────────────────────────────────────────────────────────────────────┘

    auth.users (Supabase Auth)
         │
         ├──────────────────────────────────────────────┐
         │                                              │
         ▼                                              ▼
    ┌─────────┐                                  ┌──────────────┐
    │  users  │                                  │user_preferences│
    ├─────────┤                                  ├──────────────┤
    │ id (PK) │──────────────────┐              │ id (PK)      │
    │username │                  │              │user_id (FK)  │
    │ email   │                  │              │ language     │
    │role     │                  │              │daily_goal    │
    │ level   │                  │              └──────────────┘
    │ score   │                  │
    │streak   │                  │              ┌──────────────────┐
    └─────────┘                  │              │user_login_history│
         │                       │              ├──────────────────┤
         │                       │              │ id (PK)          │
         │                       └──────────────│user_id (FK)      │
         │                                      │ login_at         │
         │                                      │ ip_address       │
         │                                      └──────────────────┘
         │
┌────────┴────────────────────────────────────────────────────────────────────┐
│                                                                              │

┌──────────────────────────────────────────────────────────────────────────────┐
│                        2. CONTENT & EXERCISES                                │
└──────────────────────────────────────────────────────────────────────────────┘

    ┌──────────┐
    │  topics  │
    ├──────────┤
    │ id (PK)  │
    │  name    │
    │  slug    │
    │  icon    │
    └──────────┘
         │
         │ topic_id (FK)
         ▼
    ┌───────────┐
    │ exercises │
    ├───────────┤
    │ id (PK)   │──────┬──────────┬───────────┐
    │  title    │      │          │           │
    │   slug    │      │          │           │
    │topic_id(FK)│     │          │           │
    │   type    │      │          │           │
    │  level    │      │          │           │
    │toeic_part │      │          │           │
    │is_published│     │          │           │
    └───────────┘      │          │           │
                       │          │           │
                       ▼          ▼           ▼
                ┌──────────┐ ┌─────────┐ ┌─────────┐
                │materials │ │questions│ │learning │
                ├──────────┤ ├─────────┤ │  plans  │
                │ id (PK)  │ │ id (PK) │ ├─────────┤
                │exercise  │ │exercise │ │ id (PK) │
                │  _id(FK) │ │  _id(FK)│ │user_id  │
                │  type    │ │question │ │exercise │
                │ content  │ │  _text  │ │  _id(FK)│
                │file_url  │ │  type   │ │  status │
                └──────────┘ └─────────┘ │  date   │
                                  │      └─────────┘
                                  │
                                  ▼
                             ┌─────────┐
                             │ options │
                             ├─────────┤
                             │ id (PK) │
                             │question │
                             │  _id(FK)│
                             │  label  │
                             │  text   │
                             │is_correct│
                             └─────────┘

┌──────────────────────────────────────────────────────────────────────────────┐
│                      3. USER PROGRESS & SUBMISSIONS                          │
└──────────────────────────────────────────────────────────────────────────────┘

    ┌─────────┐
    │  users  │
    └─────────┘
         │
         │ user_id (FK)
         ├───────────────┬────────────────┐
         ▼               ▼                ▼
    ┌────────────┐  ┌──────────┐  ┌──────────────┐
    │submissions │  │  study   │  │learning_plans│
    ├────────────┤  │ sessions │  ├──────────────┤
    │ id (PK)    │  ├──────────┤  │ id (PK)      │
    │user_id(FK) │  │ id (PK)  │  │user_id (FK)  │
    │exercise_id │  │user_id   │  │exercise_id   │
    │   (FK)     │  │  (FK)    │  │    (FK)      │
    │  score     │  │exercise  │  │planned_date  │
    │  correct   │  │  _id(FK) │  │   status     │
    │ duration   │  │ duration │  │ day_number   │
    │is_completed│  │   date   │  └──────────────┘
    └────────────┘  └──────────┘
         │
         │ submission_id (FK)
         ▼
    ┌────────────┐
    │   user     │
    │  answers   │
    ├────────────┤
    │ id (PK)    │
    │submission  │
    │   _id(FK)  │
    │question_id │
    │    (FK)    │
    │selected_   │
    │ option_id  │
    │answer_text │
    │is_correct  │
    └────────────┘

┌──────────────────────────────────────────────────────────────────────────────┐
│                      4. ASSESSMENTS & EVALUATIONS                            │
└──────────────────────────────────────────────────────────────────────────────┘

    ┌─────────────┐
    │ assessments │
    ├─────────────┤
    │ id (PK)     │
    │   title     │
    │    type     │
    │  questions  │
    │  duration   │
    │is_published │
    └─────────────┘
         │
         │ assessment_id (FK)
         ▼
    ┌──────────────┐
    │ assessment   │
    │   results    │
    ├──────────────┤
    │ id (PK)      │
    │user_id (FK)  │
    │assessment_id │
    │    (FK)      │
    │ total_score  │
    │listening_score│
    │reading_score │
    │writing_score │
    │speaking_score│
    │predicted_score│
    │ai_analysis   │
    └──────────────┘

┌──────────────────────────────────────────────────────────────────────────────┐
│                          5. GAMIFICATION                                     │
└──────────────────────────────────────────────────────────────────────────────┘

    ┌─────────┐
    │ badges  │
    ├─────────┤
    │ id (PK) │
    │  name   │
    │ badge   │
    │  _type  │
    │ points  │
    │ rarity  │
    │criteria │
    └─────────┘
         │
         │ badge_id (FK)
         ▼
    ┌──────────┐       ┌─────────┐
    │   user   │       │  users  │
    │  badges  │       └─────────┘
    ├──────────┤            │
    │ id (PK)  │            │ user_id (FK)
    │user_id   │            │
    │  (FK)    │◄───────────┼──────────────────┐
    │badge_id  │            │                  │
    │  (FK)    │            │                  │
    │awarded_at│            ▼                  ▼
    └──────────┘     ┌─────────────┐    ┌────────────┐
                     │achievements │    │leaderboard │
                     ├─────────────┤    ├────────────┤
                     │ id (PK)     │    │ id (PK)    │
                     │user_id (FK) │    │user_id(FK) │
                     │achievement  │    │  period    │
                     │   _type     │    │total_points│
                     │   _name     │    │   rank     │
                     │  points     │    │exercises   │
                     │ metadata    │    │ _completed │
                     └─────────────┘    │ avg_score  │
                                        └────────────┘

┌──────────────────────────────────────────────────────────────────────────────┐
│                      6. AI & PERSONALIZATION                                 │
└──────────────────────────────────────────────────────────────────────────────┘

    ┌─────────┐
    │  users  │
    └─────────┘
         │
         │ user_id (FK)
         ├──────────────────────┬─────────────────────┐
         ▼                      ▼                     ▼
    ┌──────────┐         ┌──────────────┐     ┌─────────────┐
    │   ai     │         │recommendations│    │submissions  │
    │ feedback │         ├──────────────┤     └─────────────┘
    ├──────────┤         │ id (PK)      │           │
    │ id (PK)  │         │user_id (FK)  │           │
    │user_id   │         │exercise_id   │           │ submission_id (FK)
    │  (FK)    │         │    (FK)      │           │
    │submission│◄────────┤recommendation│           │
    │  _id(FK) │         │    _type     │           │
    │feedback  │         │   reason     │           │
    │  _type   │         │  priority    │           │
    │ai_model  │         │  is_viewed   │           │
    │feedback  │         │is_completed  │           │
    │  _text   │         └──────────────┘           │
    │suggestions│                                   │
    │strengths │                                    │
    │weaknesses│                                    │
    └──────────┘

┌──────────────────────────────────────────────────────────────────────────────┐
│                    7. COMMUNICATION & NOTIFICATIONS                          │
└──────────────────────────────────────────────────────────────────────────────┘

    ┌─────────┐
    │  users  │
    └─────────┘
         │
         │ user_id (FK)
         ▼
    ┌──────────────┐
    │notifications │
    ├──────────────┤
    │ id (PK)      │
    │user_id (FK)  │
    │   title      │
    │  message     │
    │notification  │
    │    _type     │
    │   link       │
    │  is_read     │
    └──────────────┘

    ┌──────────────┐
    │announcements │
    ├──────────────┤
    │ id (PK)      │
    │   title      │
    │  content     │
    │announcement  │
    │    _type     │
    │   target     │
    │  _audience   │
    │  priority    │
    │is_published  │
    │published_at  │
    │ expires_at   │
    │ created_by   │
    │    (FK)      │
    └──────────────┘

┌──────────────────────────────────────────────────────────────────────────────┐
│                          8. SYSTEM & ADMIN                                   │
└──────────────────────────────────────────────────────────────────────────────┘

    ┌───────────────┐
    │    system     │
    │   settings    │
    ├───────────────┤
    │ id (PK)       │
    │ setting_key   │
    │setting_value  │
    │ setting_type  │
    │ description   │
    │  is_public    │
    │  updated_by   │
    │     (FK)      │
    └───────────────┘

    ┌──────────────┐
    │  audit_logs  │
    ├──────────────┤
    │ id (PK)      │
    │user_id (FK)  │
    │   action     │
    │ table_name   │
    │  record_id   │
    │  old_data    │
    │  new_data    │
    │ ip_address   │
    │ user_agent   │
    └──────────────┘

    ┌──────────────┐
    │    user      │
    │  feedback    │
    ├──────────────┤
    │ id (PK)      │
    │user_id (FK)  │
    │feedback_type │
    │   subject    │
    │   message    │
    │   status     │
    │  priority    │
    │ assigned_to  │
    │    (FK)      │
    └──────────────┘

```

## 🔑 Key Relationships

### One-to-Many Relationships
- users → submissions (One user has many submissions)
- users → learning_plans (One user has many learning plans)
- users → study_sessions (One user has many study sessions)
- exercises → questions (One exercise has many questions)
- questions → options (One question has many options)
- exercises → materials (One exercise has many materials)
- topics → exercises (One topic has many exercises)

### Many-to-Many Relationships
- users ↔ badges (via user_badges)
- users ↔ exercises (via submissions, learning_plans)

### One-to-One Relationships
- users → user_preferences (One user has one preferences record)

## 📋 Table Categories

### Core Tables (8)
- users, topics, exercises, questions, options, materials, submissions, user_answers

### Progress Tracking (3)
- learning_plans, study_sessions, assessment_results

### Gamification (4)
- badges, user_badges, achievements, leaderboard

### AI & Personalization (2)
- ai_feedback, recommendations

### Communication (2)
- notifications, announcements

### System & Admin (4)
- system_settings, audit_logs, user_feedback, user_login_history

### User Management (2)
- user_preferences, assessments

**Total: 25 Tables**

## 🎯 Key Features

1. **Comprehensive User Management**: Roles, levels, scores, streaks
2. **Flexible Exercise System**: Multiple types, topics, difficulty levels
3. **Detailed Progress Tracking**: Submissions, answers, study time
4. **Gamification**: Badges, achievements, leaderboard
5. **AI Integration**: Feedback, recommendations
6. **Security**: RLS policies, audit logs
7. **Scalability**: Proper indexing, efficient queries

## 🔒 Security Layers

1. **Row Level Security (RLS)**: All tables protected
2. **Foreign Key Constraints**: Data integrity maintained
3. **Audit Logs**: Track all critical operations
4. **Login History**: Monitor user access
5. **Role-based Access**: student, teacher, admin roles

## ⚡ Performance Optimizations

1. **20+ Indexes**: On frequently queried columns
2. **Automatic Triggers**: Update stats automatically
3. **JSONB Fields**: Flexible data storage
4. **Efficient Queries**: Optimized helper functions
5. **Partitioning Ready**: Can partition by date if needed

---

**Legend:**
- PK = Primary Key
- FK = Foreign Key
- ─── = One-to-Many relationship
- ◄─► = Many-to-Many relationship
