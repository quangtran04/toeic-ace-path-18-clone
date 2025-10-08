# Migration Guide: From REST API to Supabase

## 📋 Overview

Hướng dẫn này giúp migrate từ REST API hiện tại sang Supabase database.

## 🔄 API Mapping

### Current API vs Supabase Tables

| Current API Endpoint | Supabase Table | Notes |
|---------------------|----------------|-------|
| `/users/register` | `users` + `user_preferences` | Use Supabase Auth |
| `/users/login` | Supabase Auth | Built-in authentication |
| `/users/{id}` | `users` | RLS protected |
| `/exercises` | `exercises` + `materials` + `questions` | Joined query |
| `/exercises/by-topic` | `exercises` JOIN `topics` | Group by topic |
| `/submissions` | `submissions` + `user_answers` | Related inserts |
| `/learningplans/user/{id}` | `learning_plans` | Filtered by user |
| `/userbadges/{id}` | `user_badges` JOIN `badges` | Joined query |
| `/dashboard/summary/{id}` | Multiple tables | Aggregate query |

## 🛠️ Installation

### 1. Install Supabase Client

```bash
npm install @supabase/supabase-js
```

### 2. Create Supabase Client

Create `src/lib/supabase.ts`:

```typescript
import { createClient } from '@supabase/supabase-js'

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY

export const supabase = createClient(supabaseUrl, supabaseAnonKey)

// TypeScript types
export type Database = {
  public: {
    Tables: {
      users: {
        Row: {
          id: string
          username: string
          email: string
          // ... other fields
        }
        Insert: {
          id?: string
          username: string
          email: string
          // ... other fields
        }
        Update: {
          id?: string
          username?: string
          email?: string
          // ... other fields
        }
      }
      // ... other tables
    }
  }
}
```

### 3. Environment Variables

Update `.env`:

```env
VITE_SUPABASE_URL=https://your-project.supabase.co
VITE_SUPABASE_ANON_KEY=your-anon-key
```

## 📝 Code Migration Examples

### Authentication

#### Before (REST API):

```typescript
async login(credentials: { email: string; password: string }) {
  const response = await fetch(`${API_BASE_URL}/users/login`, {
    method: 'POST',
    body: JSON.stringify({
      email: credentials.email,
      passwordHash: credentials.password
    }),
  });
  const data = await response.json();
  localStorage.setItem('authToken', data.token);
  return data;
}
```

#### After (Supabase):

```typescript
async login(credentials: { email: string; password: string }) {
  const { data, error } = await supabase.auth.signInWithPassword({
    email: credentials.email,
    password: credentials.password,
  })
  
  if (error) throw error
  
  // Session is managed automatically by Supabase
  return data
}
```

### User Registration

#### Before (REST API):

```typescript
async register(userData: { username: string; email: string; password: string }) {
  return this.request<User>('/users/register', {
    method: 'POST',
    body: JSON.stringify(userData),
  });
}
```

#### After (Supabase):

```typescript
async register(userData: { username: string; email: string; password: string }) {
  // 1. Create auth user
  const { data: authData, error: authError } = await supabase.auth.signUp({
    email: userData.email,
    password: userData.password,
  })
  
  if (authError) throw authError
  
  // 2. Create user profile (triggered automatically or manually)
  const { data, error } = await supabase
    .from('users')
    .insert({
      id: authData.user!.id,
      username: userData.username,
      email: userData.email,
    })
    .select()
    .single()
  
  if (error) throw error
  return data
}
```

### Get Exercises

#### Before (REST API):

```typescript
async getAllExercises(): Promise<Exercise[]> {
  return this.request<Exercise[]>('/exercises');
}
```

#### After (Supabase):

```typescript
async getAllExercises() {
  const { data, error } = await supabase
    .from('exercises')
    .select(`
      *,
      topic:topics(*),
      materials(*),
      questions(
        *,
        options(*)
      )
    `)
    .eq('is_published', true)
    .order('order_index')
  
  if (error) throw error
  return data
}
```

### Get Exercises by Topic

#### Before (REST API):

```typescript
async getExercisesByTopic(): Promise<ExercisesByTopicResponse[]> {
  return this.request<ExercisesByTopicResponse[]>('/exercises/by-topic');
}
```

#### After (Supabase):

```typescript
async getExercisesByTopic() {
  const { data, error } = await supabase
    .from('exercises')
    .select(`
      *,
      topic:topics(*)
    `)
    .eq('is_published', true)
    .order('order_index')
  
  if (error) throw error
  
  // Group by topic
  const grouped = data.reduce((acc, exercise) => {
    const topicName = exercise.topic.name
    if (!acc[topicName]) {
      acc[topicName] = {
        topic: topicName,
        exercises: []
      }
    }
    acc[topicName].exercises.push(exercise)
    return acc
  }, {} as Record<string, any>)
  
  return Object.values(grouped)
}
```

### Submit Exercise

#### Before (REST API):

```typescript
async submitExercise(submissionData: {
  userId: number;
  exerciseId: number;
  score: number;
  isCompleted: boolean;
}): Promise<Submission> {
  return this.request<Submission>('/submissions', {
    method: 'POST',
    body: JSON.stringify(submissionData),
  });
}
```

#### After (Supabase):

```typescript
async submitExercise(submissionData: {
  exerciseId: string;
  score: number;
  isCompleted: boolean;
  answers: Array<{
    questionId: string;
    selectedOptionId?: string;
    answerText?: string;
  }>;
}) {
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) throw new Error('Not authenticated')
  
  // 1. Create submission
  const { data: submission, error: submissionError } = await supabase
    .from('submissions')
    .insert({
      user_id: user.id,
      exercise_id: submissionData.exerciseId,
      score: submissionData.score,
      is_completed: submissionData.isCompleted,
      submitted_at: new Date().toISOString(),
    })
    .select()
    .single()
  
  if (submissionError) throw submissionError
  
  // 2. Save user answers
  const { error: answersError } = await supabase
    .from('user_answers')
    .insert(
      submissionData.answers.map(answer => ({
        submission_id: submission.id,
        question_id: answer.questionId,
        selected_option_id: answer.selectedOptionId,
        answer_text: answer.answerText,
      }))
    )
  
  if (answersError) throw answersError
  
  return submission
}
```

### Get Dashboard Stats

#### Before (REST API):

```typescript
async getDashboardStats(userId: number): Promise<DashboardStats> {
  const [summary, progress, recentResults] = await Promise.all([
    this.getDashboardSummary(userId),
    this.getDashboardProgress(userId),
    this.getDashboardRecentResults(userId)
  ]);
  
  return {
    streakDays: summary.streakDays,
    totalScore: summary.predictedScore,
    // ... combine data
  };
}
```

#### After (Supabase):

```typescript
async getDashboardStats(userId: string) {
  // Get user stats
  const { data: user, error: userError } = await supabase
    .from('users')
    .select('streak_days, current_score, total_study_time_minutes')
    .eq('id', userId)
    .single()
  
  if (userError) throw userError
  
  // Get submissions stats
  const { data: submissions, error: submissionsError } = await supabase
    .from('submissions')
    .select('score, exercise_id')
    .eq('user_id', userId)
    .eq('is_completed', true)
    .order('submitted_at', { ascending: false })
    .limit(5)
  
  if (submissionsError) throw submissionsError
  
  // Get progress by type
  const { data: progress, error: progressError } = await supabase
    .rpc('get_user_progress_by_type', { user_uuid: userId })
  
  if (progressError) throw progressError
  
  return {
    streakDays: user.streak_days,
    totalScore: user.current_score,
    studyHours: Math.round(user.total_study_time_minutes / 60),
    completedExercises: submissions.length,
    progress,
    recentResults: submissions.map(s => ({
      exercise: s.exercise_id,
      score: s.score,
    })),
  }
}
```

### Get Learning Plan

#### Before (REST API):

```typescript
async getLearningPlan(userId: number): Promise<LearningPlan[]> {
  return this.request<LearningPlan[]>(`/learningplans/user/${userId}`);
}
```

#### After (Supabase):

```typescript
async getLearningPlan(userId: string) {
  const { data, error } = await supabase
    .from('learning_plans')
    .select(`
      *,
      exercise:exercises(*)
    `)
    .eq('user_id', userId)
    .order('planned_date')
  
  if (error) throw error
  return data
}
```

### Get User Badges

#### Before (REST API):

```typescript
async getUserBadges(userId: number): Promise<Badge[]> {
  return this.request<Badge[]>(`/userbadges/${userId}`);
}
```

#### After (Supabase):

```typescript
async getUserBadges(userId: string) {
  const { data, error } = await supabase
    .from('user_badges')
    .select(`
      *,
      badge:badges(*)
    `)
    .eq('user_id', userId)
    .order('awarded_at', { ascending: false })
  
  if (error) throw error
  return data.map(ub => ub.badge)
}
```

## 🔒 Real-time Subscriptions

Supabase cho phép real-time updates:

```typescript
// Subscribe to new notifications
const notificationSubscription = supabase
  .channel('notifications')
  .on(
    'postgres_changes',
    {
      event: 'INSERT',
      schema: 'public',
      table: 'notifications',
      filter: `user_id=eq.${userId}`,
    },
    (payload) => {
      console.log('New notification:', payload.new)
      // Update UI
    }
  )
  .subscribe()

// Subscribe to leaderboard changes
const leaderboardSubscription = supabase
  .channel('leaderboard')
  .on(
    'postgres_changes',
    {
      event: '*',
      schema: 'public',
      table: 'leaderboard',
    },
    (payload) => {
      console.log('Leaderboard updated:', payload)
      // Refresh leaderboard
    }
  )
  .subscribe()
```

## 📊 Custom Database Functions

Create PostgreSQL functions for complex queries:

```sql
-- Get user progress by exercise type
CREATE OR REPLACE FUNCTION get_user_progress_by_type(user_uuid UUID)
RETURNS TABLE (
    exercise_type VARCHAR,
    completed INTEGER,
    avg_score NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        e.exercise_type,
        COUNT(DISTINCT s.exercise_id)::INTEGER as completed,
        ROUND(AVG(s.score), 2) as avg_score
    FROM submissions s
    JOIN exercises e ON e.id = s.exercise_id
    WHERE s.user_id = user_uuid
      AND s.is_completed = true
    GROUP BY e.exercise_type;
END;
$$ LANGUAGE plpgsql;
```

Call from client:

```typescript
const { data, error } = await supabase
  .rpc('get_user_progress_by_type', { user_uuid: userId })
```

## 🧪 Testing

### Unit Tests

```typescript
import { supabase } from '@/lib/supabase'

describe('Exercises API', () => {
  it('should fetch all exercises', async () => {
    const { data, error } = await supabase
      .from('exercises')
      .select('*')
      .eq('is_published', true)
    
    expect(error).toBeNull()
    expect(data).toBeInstanceOf(Array)
  })
})
```

## 🚀 Migration Steps

1. ✅ Set up Supabase project
2. ✅ Run schema.sql
3. ✅ Run seed.sql (optional)
4. ✅ Install Supabase client
5. ⬜ Update authentication flow
6. ⬜ Migrate API calls one by one
7. ⬜ Test each migration
8. ⬜ Update RLS policies if needed
9. ⬜ Deploy and monitor

## 📈 Performance Benefits

- **Faster queries**: Direct database access
- **Real-time updates**: WebSocket connections
- **Auto-caching**: Built-in caching layer
- **CDN**: Global edge network
- **Optimized**: PostgreSQL optimizations

## 🆘 Troubleshooting

### Issue: RLS blocking queries

**Solution**: Check policies or use service role key for admin operations

### Issue: Type mismatches

**Solution**: Generate TypeScript types:

```bash
npx supabase gen types typescript --project-id your-project-id > src/types/supabase.ts
```

### Issue: Complex queries slow

**Solution**: Create database views or functions

## 📚 Resources

- [Supabase JS Client Docs](https://supabase.com/docs/reference/javascript)
- [Supabase Auth Guide](https://supabase.com/docs/guides/auth)
- [Row Level Security](https://supabase.com/docs/guides/auth/row-level-security)
- [Realtime Subscriptions](https://supabase.com/docs/guides/realtime)

---

**Next Steps**: Start with authentication migration, then gradually migrate other API calls.
