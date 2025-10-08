# Quick Start Guide - Supabase Setup

## 🚀 5-Minute Setup

### Step 1: Create Supabase Project (2 minutes)

1. Go to [https://supabase.com](https://supabase.com)
2. Click **"Start your project"**
3. Sign in with GitHub
4. Click **"New Project"**
5. Fill in:
   - **Name**: toeic-ace-path
   - **Database Password**: (save this!)
   - **Region**: Choose closest to your users
6. Click **"Create new project"**
7. Wait for initialization (~2 minutes)

### Step 2: Run Database Schema (2 minutes)

1. In Supabase Dashboard, click **SQL Editor** in sidebar
2. Click **"New Query"**
3. Copy entire content from `supabase/schema.sql`
4. Paste into the editor
5. Click **RUN** (or Ctrl+Enter)
6. Wait for success message ✅

### Step 3: Add Sample Data (1 minute) - Optional

1. Create another new query in SQL Editor
2. Copy entire content from `supabase/seed.sql`
3. Paste into the editor
4. Click **RUN**
5. Check success ✅

### Step 4: Get API Keys (30 seconds)

1. In Supabase Dashboard, click **Settings** (gear icon)
2. Click **API** in sidebar
3. Find:
   - **Project URL**: `https://xxxxx.supabase.co`
   - **anon public**: `eyJhbG...` (click to copy)
4. Save these for next step

### Step 5: Configure App (30 seconds)

Create or update `.env.local`:

```env
VITE_SUPABASE_URL=https://xxxxx.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbG...your-anon-key
```

**Done! 🎉** Your database is ready!

---

## 🧪 Test Your Setup

### Test 1: Check Tables

In SQL Editor:

```sql
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public'
ORDER BY table_name;
```

You should see 25 tables.

### Test 2: Check Sample Data

```sql
SELECT COUNT(*) FROM topics;
SELECT COUNT(*) FROM badges;
SELECT COUNT(*) FROM exercises;
```

Should return counts > 0 if you ran seed.sql.

### Test 3: Test from App

```typescript
import { supabase } from '@/lib/supabase'

// Test connection
const { data, error } = await supabase
  .from('topics')
  .select('*')
  .limit(1)

console.log('Connected:', !error)
```

---

## 📋 What You Get

### 25 Database Tables:

**Core Features:**
- ✅ Users & Authentication
- ✅ Exercises & Questions
- ✅ Progress Tracking
- ✅ Learning Plans
- ✅ Badges & Achievements
- ✅ AI Feedback
- ✅ Notifications
- ✅ Admin Tools

### Security:
- ✅ Row Level Security (RLS) enabled
- ✅ Role-based access control
- ✅ Audit logging
- ✅ Secure by default

### Performance:
- ✅ 20+ indexes
- ✅ Automatic triggers
- ✅ Optimized queries
- ✅ Helper functions

---

## 🎯 Next Steps

### For Students:
1. Sign up → Create account
2. Complete assessment test
3. Get personalized 25-day plan
4. Start learning!

### For Teachers:
1. Sign up with teacher role
2. Create exercises
3. Monitor student progress
4. Provide feedback

### For Admins:
1. Access admin dashboard
2. Manage users
3. View analytics
4. Configure system

---

## 📚 Quick Reference

### Common Queries

**Get all published exercises:**
```sql
SELECT * FROM exercises WHERE is_published = true;
```

**Get user's streak:**
```sql
SELECT streak_days FROM users WHERE id = 'user-uuid';
```

**Get leaderboard:**
```sql
SELECT * FROM leaderboard 
WHERE period = 'weekly' 
ORDER BY total_points DESC 
LIMIT 10;
```

**Get user badges:**
```sql
SELECT b.* 
FROM user_badges ub
JOIN badges b ON b.id = ub.badge_id
WHERE ub.user_id = 'user-uuid';
```

### Helper Functions

```sql
-- Exercise statistics
SELECT * FROM get_exercise_stats('exercise-uuid');

-- User progress
SELECT * FROM get_user_progress_summary('user-uuid');

-- Leaderboard
SELECT * FROM get_leaderboard('weekly', 10);
```

---

## 🔧 Troubleshooting

### Can't see tables?
- Make sure you ran schema.sql
- Check for errors in SQL Editor
- Refresh database schema

### RLS blocking queries?
- You need to be authenticated
- Check RLS policies
- Use service role key for admin

### Seed data not working?
- Run schema.sql first
- Check for FK constraint errors
- Run seed.sql line by line if needed

### Connection errors?
- Check .env file
- Verify API keys
- Check project URL

---

## 📞 Support

- 📖 [Full Documentation](./README.md)
- 🗺️ [Database Diagram](./DATABASE_DIAGRAM.md)
- 🔄 [Migration Guide](./MIGRATION_GUIDE.md)
- 🌐 [Supabase Docs](https://supabase.com/docs)

---

**Ready to build? Start coding! 🚀**
