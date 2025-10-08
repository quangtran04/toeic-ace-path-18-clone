# 🎓 TOEIC Ace Path - Hệ thống Database Supabase Hoàn chỉnh

## 🌟 Tổng quan

Đây là hệ thống cơ sở dữ liệu hoàn chỉnh cho nền tảng học TOEIC trực tuyến, được xây dựng trên Supabase (PostgreSQL).

### ✨ Đặc điểm nổi bật

- ✅ **25 bảng** được thiết kế kỹ lưỡng
- ✅ **50+ chính sách bảo mật** Row Level Security
- ✅ **20+ indexes** tối ưu hiệu suất
- ✅ **7 triggers** tự động hóa
- ✅ **6 functions** tiện ích
- ✅ **Dữ liệu mẫu** đầy đủ để test

## 📚 Tài liệu hướng dẫn

### Bắt đầu nhanh (Recommended)

1. **[INDEX.md](./INDEX.md)** - 📍 Điểm bắt đầu - Tìm kiếm mọi thứ
2. **[SUMMARY.md](./SUMMARY.md)** - 📊 Tổng quan dự án
3. **[QUICKSTART.md](./QUICKSTART.md)** - 🚀 Setup trong 5 phút

### Tài liệu chi tiết

4. **[README.md](./README.md)** - 📖 Tài liệu đầy đủ (English)
5. **[DATABASE_DIAGRAM.md](./DATABASE_DIAGRAM.md)** - 🗺️ Sơ đồ ER
6. **[MIGRATION_GUIDE.md](./MIGRATION_GUIDE.md)** - 🔄 Hướng dẫn migration

### Files Database

7. **schema.sql** - Cấu trúc database chính (932 dòng)
8. **seed.sql** - Dữ liệu mẫu (355 dòng)

## 🎯 Hướng dẫn theo từng nhóm người dùng

### ��‍💼 Product Manager / Stakeholder

**Mục tiêu**: Hiểu tổng quan hệ thống

1. Đọc [SUMMARY.md](./SUMMARY.md) - 10 phút
2. Xem [DATABASE_DIAGRAM.md](./DATABASE_DIAGRAM.md) - 15 phút

**Bạn sẽ hiểu**: Toàn bộ tính năng, cấu trúc, và khả năng của hệ thống.

### 👨‍💻 Developer / Lập trình viên

**Mục tiêu**: Setup và bắt đầu code

1. Đọc [QUICKSTART.md](./QUICKSTART.md) - 5 phút
2. Setup database theo hướng dẫn - 5 phút
3. Đọc [MIGRATION_GUIDE.md](./MIGRATION_GUIDE.md) - 20 phút
4. Tham khảo [README.md](./README.md) khi code

**Bạn sẽ có**: Database hoàn chỉnh và code examples để bắt đầu.

### 🎨 Database Admin / DevOps

**Mục tiêu**: Hiểu sâu về database design

1. Review schema.sql - 30 phút
2. Đọc [README.md](./README.md) đầy đủ - 30 phút
3. Xem [DATABASE_DIAGRAM.md](./DATABASE_DIAGRAM.md) - 20 phút

**Bạn sẽ hiểu**: Toàn bộ thiết kế, indexes, policies, triggers.

### 🧪 QA / Tester

**Mục tiêu**: Setup test environment

1. Follow [QUICKSTART.md](./QUICKSTART.md) - 5 phút
2. Run seed.sql - 1 phút
3. Đọc phần test trong [README.md](./README.md) - 10 phút

**Bạn sẽ có**: Test database với sample data đầy đủ.

## 🏗️ Cấu trúc Database

### 25 Bảng được chia thành 7 nhóm:

#### 1. 👥 Users & Authentication (3 bảng)
- `users` - Thông tin người dùng
- `user_preferences` - Cài đặt cá nhân
- `user_login_history` - Lịch sử đăng nhập

#### 2. 📚 Content & Exercises (6 bảng)
- `topics` - Chủ đề học tập
- `exercises` - Bài tập/bài học
- `materials` - Tài liệu (text, audio, video)
- `questions` - Câu hỏi
- `options` - Lựa chọn trả lời
- `assessments` - Bài kiểm tra đánh giá

#### 3. 📈 Progress Tracking (4 bảng)
- `submissions` - Bài làm của học viên
- `user_answers` - Chi tiết câu trả lời
- `learning_plans` - Lộ trình học 25 ngày
- `study_sessions` - Phiên học tập

#### 4. 🏆 Gamification (4 bảng)
- `badges` - Huy hiệu
- `user_badges` - Huy hiệu đã đạt được
- `achievements` - Thành tích
- `leaderboard` - Bảng xếp hạng

#### 5. 🤖 AI & Personalization (3 bảng)
- `ai_feedback` - Phản hồi từ AI
- `recommendations` - Đề xuất cá nhân hóa
- `assessment_results` - Kết quả test với AI analysis

#### 6. 🔔 Communication (2 bảng)
- `notifications` - Thông báo người dùng
- `announcements` - Thông báo hệ thống

#### 7. ⚙️ System & Admin (3 bảng)
- `system_settings` - Cấu hình hệ thống
- `audit_logs` - Nhật ký hoạt động
- `user_feedback` - Phản hồi & hỗ trợ

## 🚀 Cài đặt nhanh

### Yêu cầu
- Tài khoản Supabase (miễn phí)
- 5 phút thời gian

### Các bước

1. **Tạo project Supabase**
   ```
   → Vào supabase.com
   → Tạo project mới
   → Lưu API keys
   ```

2. **Chạy schema**
   ```
   → Mở SQL Editor trong Supabase
   → Copy nội dung schema.sql
   → Paste và Run
   ✅ Xong! 25 tables đã được tạo
   ```

3. **Thêm dữ liệu mẫu** (Optional)
   ```
   → Copy nội dung seed.sql
   → Paste và Run
   ✅ Có data để test ngay
   ```

4. **Cấu hình app**
   ```env
   VITE_SUPABASE_URL=your-project-url
   VITE_SUPABASE_ANON_KEY=your-anon-key
   ```

Chi tiết đầy đủ: [QUICKSTART.md](./QUICKSTART.md)

## 🎯 Tính năng chính

### Cho học viên (Students)
- ✅ Theo dõi tiến độ học tập
- ✅ Lộ trình học 25 ngày cá nhân hóa
- ✅ Streak tracking (học liên tiếp)
- ✅ Hệ thống huy hiệu & thành tích
- ✅ AI feedback cho bài làm
- ✅ Đề xuất bài học thông minh
- ✅ Bảng xếp hạng cạnh tranh
- ✅ Theo dõi thời gian học

### Cho giáo viên (Teachers)
- ✅ Tạo và quản lý bài tập
- ✅ Xem tiến độ học viên
- ✅ Cung cấp feedback
- ✅ Quản lý nội dung
- ✅ Theo dõi hiệu quả lớp học
- ✅ Dashboard phân tích

### Cho quản trị viên (Admins)
- ✅ Quản lý người dùng
- ✅ Kiểm duyệt nội dung
- ✅ Cấu hình hệ thống
- ✅ Phân tích & báo cáo
- ✅ Nhật ký hoạt động
- ✅ Thông báo hệ thống
- ✅ Xử lý phản hồi

## 🔐 Bảo mật

### Row Level Security (RLS)
- ✅ **Tất cả 25 bảng** đều có RLS
- ✅ **50+ policies** kiểm soát truy cập
- ✅ **Phân quyền rõ ràng**: student, teacher, admin
- ✅ **Cách ly dữ liệu**: User chỉ thấy data của mình
- ✅ **Nội dung công khai**: Bài học published cho tất cả

### Authentication
- ✅ Supabase Auth tích hợp sẵn
- ✅ Email/password authentication
- ✅ Hỗ trợ OAuth (Google, GitHub...)
- ✅ Quản lý session tự động
- ✅ Reset password
- ✅ Email verification

### Audit & Monitoring
- ✅ Lịch sử đăng nhập
- ✅ Nhật ký hoạt động admin
- ✅ Lưu IP address
- ✅ Theo dõi User agent

## ⚡ Tối ưu hiệu suất

### Indexes (20+)
Đã tạo indexes cho tất cả queries thường dùng:
- Users: email, username, role, level
- Exercises: topic, type, level, published
- Submissions: user_id, exercise_id, date
- Learning Plans: user_id, date, status
- Và nhiều hơn nữa...

### Automatic Triggers (7)
- ✅ Tự động update timestamps
- ✅ Tính điểm trung bình tự động
- ✅ Update streak days
- ✅ Trao huy hiệu tự động
- ✅ Cập nhật leaderboard

### Helper Functions (6)
- ✅ `get_exercise_stats()` - Thống kê bài tập
- ✅ `get_user_progress_summary()` - Tổng quan tiến độ
- ✅ `get_leaderboard()` - Bảng xếp hạng
- ✅ Và nhiều functions khác...

## 📊 Dữ liệu mẫu

Khi chạy seed.sql, bạn sẽ có:

### Topics (8)
- Nationalities (Quốc tịch)
- Business Communication (Giao tiếp kinh doanh)
- Office Environment (Môi trường văn phòng)
- Travel & Tourism (Du lịch)
- Meetings & Conferences (Họp & Hội nghị)
- Finance & Banking (Tài chính & Ngân hàng)
- Technology (Công nghệ)
- Human Resources (Nhân sự)

### Badges (10)
- First Exercise Complete (Hoàn thành bài đầu tiên)
- Perfect Score (Điểm tuyệt đối)
- 7 Day Streak (Học 7 ngày liên tiếp)
- 30 Day Streak (Học 30 ngày liên tiếp)
- Speed Learner (Học nhanh)
- TOEIC Master (Chuyên gia TOEIC)
- Early Bird (Chim sớm)
- Night Owl (Cú đêm)
- Consistency King (Nhất quán)
- Knowledge Seeker (Tìm kiếm tri thức)

### Exercises (3 mẫu)
- Nationalities and Countries - Day 1
- Business Email Vocabulary
- Office Supplies and Equipment

### Assessments (3)
- TOEIC Placement Test (Test đầu vào)
- Full TOEIC Mock Test (Test thử hoàn chỉnh)
- Weekly Progress Check (Kiểm tra tiến độ)

## 💻 Ví dụ sử dụng

### Lấy tất cả bài tập
```typescript
const { data } = await supabase
  .from('exercises')
  .select('*, topic:topics(*), questions(*)')
  .eq('is_published', true)
```

### Nộp bài tập
```typescript
const { data } = await supabase
  .from('submissions')
  .insert({
    user_id: userId,
    exercise_id: exerciseId,
    score: 85,
    is_completed: true
  })
```

### Lấy bảng xếp hạng
```typescript
const { data } = await supabase
  .from('leaderboard')
  .select('*, user:users(*)')
  .eq('period', 'weekly')
  .order('total_points', { ascending: false })
  .limit(10)
```

### Real-time notifications
```typescript
supabase
  .channel('notifications')
  .on('postgres_changes', {
    event: 'INSERT',
    schema: 'public',
    table: 'notifications',
    filter: `user_id=eq.${userId}`
  }, (payload) => {
    console.log('Thông báo mới:', payload)
  })
  .subscribe()
```

Xem thêm: [MIGRATION_GUIDE.md](./MIGRATION_GUIDE.md)

## 🆘 Hỗ trợ

### Câu hỏi thường gặp

**Q: Làm sao setup database?**  
A: Xem [QUICKSTART.md](./QUICKSTART.md)

**Q: Làm sao migrate từ REST API?**  
A: Xem [MIGRATION_GUIDE.md](./MIGRATION_GUIDE.md)

**Q: Tìm ví dụ query ở đâu?**  
A: Xem [README.md](./README.md) phần "Sample Queries"

**Q: RLS policies hoạt động thế nào?**  
A: Xem [README.md](./README.md) phần "Row Level Security"

### Liên hệ

- 📧 Email: support@toeicacepath.com
- 🐛 Issues: [GitHub Issues](https://github.com/quangtran04/toeic-ace-path-18-clone/issues)
- 📚 Docs: [Supabase Docs](https://supabase.com/docs)

## 📈 Thống kê

- **Tổng files**: 8
- **Tổng dòng code**: 3,394
- **Số bảng**: 25
- **Số indexes**: 20+
- **Số triggers**: 7
- **Số functions**: 6
- **RLS policies**: 50+
- **Sample records**: 30+

## 🎓 Resources

- [Supabase Documentation](https://supabase.com/docs)
- [PostgreSQL Docs](https://www.postgresql.org/docs/)
- [Row Level Security](https://supabase.com/docs/guides/auth/row-level-security)
- [Real-time](https://supabase.com/docs/guides/realtime)

## 🚀 Tiếp theo

1. ✅ **Database đã tạo** - Bạn đang ở đây!
2. ⬜ **Cài Supabase Client** - `npm install @supabase/supabase-js`
3. ⬜ **Cấu hình môi trường** - Thêm API keys
4. ⬜ **Migrate API calls** - Từ REST sang Supabase
5. ⬜ **Test queries** - Kiểm tra hoạt động
6. ⬜ **Thêm real-time** - Subscribe to updates
7. ⬜ **Deploy** - Đưa lên production!

---

**🎉 Chúc mừng! Database TOEIC của bạn đã sẵn sàng!**

Được tạo với ❤️ cho việc học TOEIC hiệu quả
