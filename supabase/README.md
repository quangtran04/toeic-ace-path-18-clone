# TOEIC Ace Path - Supabase Database Documentation

## 📋 Tổng quan

Cơ sở dữ liệu này được thiết kế đầy đủ cho nền tảng học TOEIC trực tuyến với các tính năng:
- Quản lý người dùng và phân quyền (Student, Teacher, Admin)
- Bài học và bài tập đa dạng (Reading, Listening, Writing, Speaking)
- Theo dõi tiến độ và kết quả học tập
- Hệ thống gamification (Badges, Achievements, Leaderboard)
- AI feedback và đề xuất cá nhân hóa
- Quản trị viên và phân tích hệ thống

## 🚀 Cài đặt

### Bước 1: Tạo project Supabase

1. Truy cập [https://supabase.com](https://supabase.com)
2. Tạo tài khoản hoặc đăng nhập
3. Tạo project mới
4. Lưu lại URL và API keys

### Bước 2: Chạy Schema

1. Mở Supabase Dashboard của project
2. Vào **SQL Editor**
3. Tạo query mới
4. Copy nội dung file `schema.sql` và paste vào
5. Click **Run** để thực thi

### Bước 3: Thêm dữ liệu mẫu (Optional)

1. Trong **SQL Editor**, tạo query mới
2. Copy nội dung file `seed.sql` và paste vào
3. Click **Run** để thực thi

### Bước 4: Cấu hình trong ứng dụng

Tạo file `.env` trong thư mục gốc:

```env
VITE_SUPABASE_URL=your-project-url
VITE_SUPABASE_ANON_KEY=your-anon-key
```

## 📊 Cấu trúc Database

### 👥 Users & Authentication

#### `users`
Bảng người dùng chính, mở rộng từ `auth.users` của Supabase.

| Cột | Kiểu | Mô tả |
|-----|------|-------|
| id | UUID | Primary key (liên kết với auth.users) |
| username | VARCHAR(50) | Tên đăng nhập (unique) |
| email | VARCHAR(255) | Email (unique) |
| full_name | VARCHAR(100) | Họ tên đầy đủ |
| avatar_url | TEXT | URL ảnh đại diện |
| role | VARCHAR(20) | Vai trò: student, teacher, admin |
| level | VARCHAR(10) | Cấp độ: A1, A2, B1, B2, C1, C2 |
| target_score | INTEGER | Điểm mục tiêu TOEIC (0-990) |
| current_score | INTEGER | Điểm hiện tại TOEIC (0-990) |
| streak_days | INTEGER | Số ngày học liên tiếp |
| total_study_time_minutes | INTEGER | Tổng thời gian học (phút) |
| last_login_at | TIMESTAMPTZ | Lần đăng nhập gần nhất |
| created_at | TIMESTAMPTZ | Ngày tạo |
| updated_at | TIMESTAMPTZ | Ngày cập nhật |

#### `user_preferences`
Cài đặt cá nhân của người dùng.

#### `user_login_history`
Lịch sử đăng nhập cho bảo mật và phân tích.

### 📚 Content & Exercises

#### `topics`
Chủ đề/danh mục bài học (Nationalities, Business Communication, etc.)

#### `exercises`
Bài tập/bài học chính.

| Cột | Kiểu | Mô tả |
|-----|------|-------|
| id | UUID | Primary key |
| title | VARCHAR(255) | Tiêu đề bài tập |
| slug | VARCHAR(255) | URL-friendly identifier |
| description | TEXT | Mô tả chi tiết |
| topic_id | UUID | Liên kết với topics |
| exercise_type | VARCHAR(50) | Reading, Listening, Writing, Speaking, etc. |
| difficulty_level | VARCHAR(10) | A1-C2 |
| toeic_part | VARCHAR(20) | Part 1-7 của TOEIC |
| estimated_duration_minutes | INTEGER | Thời gian ước tính |
| total_questions | INTEGER | Tổng số câu hỏi |
| passing_score | INTEGER | Điểm đạt (%) |
| is_published | BOOLEAN | Đã công khai chưa |
| is_premium | BOOLEAN | Nội dung premium |

#### `materials`
Tài liệu học tập (Text, Audio, Video, Image).

#### `questions`
Câu hỏi trong bài tập.

#### `options`
Các lựa chọn cho câu hỏi trắc nghiệm.

### 📈 User Progress & Submissions

#### `submissions`
Bài làm của học viên.

| Cột | Kiểu | Mô tả |
|-----|------|-------|
| id | UUID | Primary key |
| user_id | UUID | Người làm bài |
| exercise_id | UUID | Bài tập |
| score | NUMERIC(5,2) | Điểm số (0-100) |
| total_questions | INTEGER | Tổng câu hỏi |
| correct_answers | INTEGER | Số câu đúng |
| duration_minutes | INTEGER | Thời gian làm bài |
| is_completed | BOOLEAN | Đã hoàn thành |
| started_at | TIMESTAMPTZ | Bắt đầu |
| submitted_at | TIMESTAMPTZ | Nộp bài |

#### `user_answers`
Chi tiết câu trả lời của từng câu hỏi.

#### `learning_plans`
Lộ trình học tập cá nhân (25-day roadmap).

#### `study_sessions`
Phiên học tập để theo dõi thời gian.

### 🎯 Assessments

#### `assessments`
Các bài test đánh giá (placement test, mock test).

#### `assessment_results`
Kết quả các bài test đánh giá.

### 🏆 Gamification

#### `badges`
Huy hiệu có thể đạt được.

| Cột | Kiểu | Mô tả |
|-----|------|-------|
| id | UUID | Primary key |
| name | VARCHAR(100) | Tên huy hiệu |
| description | TEXT | Mô tả |
| icon | VARCHAR(50) | Icon name |
| badge_type | VARCHAR(50) | achievement, streak, score, etc. |
| criteria | JSONB | Điều kiện đạt được |
| points | INTEGER | Điểm thưởng |
| rarity | VARCHAR(20) | common, rare, epic, legendary |

#### `user_badges`
Huy hiệu mà người dùng đã đạt được.

#### `achievements`
Thành tích của người dùng.

#### `leaderboard`
Bảng xếp hạng (daily, weekly, monthly, all_time).

### 🤖 AI & Personalization

#### `ai_feedback`
Phản hồi từ AI cho bài làm của học viên.

#### `recommendations`
Đề xuất bài học cá nhân hóa.

### 🔔 Communication

#### `notifications`
Thông báo cho người dùng.

#### `announcements`
Thông báo hệ thống cho tất cả/nhóm người dùng.

### ⚙️ System & Admin

#### `system_settings`
Cài đặt hệ thống.

#### `audit_logs`
Nhật ký hệ thống cho admin.

#### `user_feedback`
Phản hồi và hỗ trợ từ người dùng.

## 🔒 Row Level Security (RLS)

Database sử dụng RLS policies để bảo mật:

- **Users**: Chỉ xem được profile của mình (trừ admin/teacher)
- **Exercises**: Ai cũng xem được bài đã publish
- **Submissions**: Chỉ xem được bài làm của mình
- **Learning Plans**: Chỉ quản lý lộ trình của mình
- **Admin**: Admin có quyền truy cập đầy đủ

## ⚡ Functions & Triggers

### Automatic Triggers

1. **update_updated_at_column()**: Tự động cập nhật `updated_at`
2. **update_user_stats_after_submission()**: Cập nhật điểm trung bình sau mỗi bài làm
3. **update_user_streak()**: Cập nhật streak days khi học
4. **check_and_award_badges()**: Tự động trao huy hiệu

### Helper Functions

```sql
-- Thống kê bài tập
SELECT * FROM get_exercise_stats('exercise-uuid');

-- Tổng quan tiến độ người dùng
SELECT * FROM get_user_progress_summary('user-uuid');

-- Bảng xếp hạng
SELECT * FROM get_leaderboard('weekly', 20);
```

## 📝 Indexes

Đã tạo indexes cho các queries thường dùng:
- User lookups (email, username, role)
- Exercise filtering (type, level, topic)
- Submissions by user and exercise
- Learning plan by date and status
- Notifications by user and read status

## 🔄 Migration và Backup

### Backup Database

```bash
# Sử dụng Supabase CLI
supabase db dump -f backup.sql

# Hoặc export từ Dashboard
```

### Restore Database

```bash
supabase db reset
supabase db push
```

## 📊 Sample Queries

### Lấy bài tập theo topic

```sql
SELECT e.*, t.name as topic_name
FROM exercises e
JOIN topics t ON t.id = e.topic_id
WHERE t.slug = 'nationalities'
  AND e.is_published = true
ORDER BY e.order_index;
```

### Lấy tiến độ học tập của user

```sql
SELECT 
    COUNT(DISTINCT s.exercise_id) as completed_exercises,
    ROUND(AVG(s.score), 2) as avg_score,
    SUM(s.duration_minutes) as total_study_minutes,
    u.streak_days
FROM submissions s
JOIN users u ON u.id = s.user_id
WHERE s.user_id = 'user-uuid'
  AND s.is_completed = true
GROUP BY u.streak_days;
```

### Lấy bài học được đề xuất

```sql
SELECT e.*
FROM recommendations r
JOIN exercises e ON e.id = r.exercise_id
WHERE r.user_id = 'user-uuid'
  AND r.is_completed = false
ORDER BY r.priority DESC, r.created_at DESC
LIMIT 5;
```

### Lấy leaderboard theo tuần

```sql
SELECT 
    ROW_NUMBER() OVER (ORDER BY total_points DESC) as rank,
    u.username,
    l.total_points,
    l.exercises_completed,
    l.avg_score
FROM leaderboard l
JOIN users u ON u.id = l.user_id
WHERE l.period = 'weekly'
ORDER BY l.total_points DESC
LIMIT 10;
```

## 🔐 Authentication Flow

1. User đăng ký qua Supabase Auth
2. Trigger tạo record trong bảng `users`
3. Tạo `user_preferences` mặc định
4. RLS policies tự động áp dụng

## 🎨 Best Practices

1. **Always use transactions** khi thực hiện nhiều thao tác liên quan
2. **Use prepared statements** để tránh SQL injection
3. **Monitor slow queries** trong Supabase Dashboard
4. **Regular backups** trước khi update schema
5. **Test RLS policies** trước khi deploy production

## 🐛 Troubleshooting

### Không thể insert dữ liệu

- Kiểm tra RLS policies
- Đảm bảo user đã authenticate
- Verify foreign key constraints

### Query chậm

- Kiểm tra indexes
- Sử dụng EXPLAIN ANALYZE
- Consider adding composite indexes

### Trigger không chạy

- Kiểm tra function có lỗi không
- Verify trigger đã được create
- Check logs trong Dashboard

## 📚 Resources

- [Supabase Documentation](https://supabase.com/docs)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Row Level Security Guide](https://supabase.com/docs/guides/auth/row-level-security)

## 📞 Support

Nếu cần hỗ trợ:
- Email: support@toeicacepath.com
- GitHub Issues: [Repository Issues](https://github.com/quangtran04/toeic-ace-path-18-clone/issues)

---

**Version**: 1.0.0  
**Last Updated**: 2024
**Author**: TOEIC Ace Path Team
