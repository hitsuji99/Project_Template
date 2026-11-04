# [Bài tập] Làm quen với View (Một bảng)

## 1. VIEW là gì?
**VIEW** là một **bảng ảo** được tạo từ một câu `SELECT`. VIEW không lưu dữ liệu riêng;
mỗi lần truy vấn VIEW, MySQL chạy lại câu `SELECT` trên bảng gốc nên dữ liệu luôn mới nhất.

## 2. Vì sao dùng VIEW thay vì truy vấn trực tiếp bảng?
- **Bảo mật / giới hạn thông tin**: giảng viên chỉ thấy mã SV, họ tên, lớp; không thấy năm sinh, địa chỉ.
- **Đơn giản hóa**: không phải viết lại câu `SELECT` dài nhiều lần, chỉ cần `SELECT * FROM v_student_basic`.
- **Tách biệt**: bảng gốc thay đổi cấu trúc thì chỉ cần sửa VIEW, người dùng vẫn truy vấn như cũ.

## 3. Bảng `students`

| Cột          | Ý nghĩa       |
|--------------|---------------|
| student_id   | Mã sinh viên (PK) |
| full_name    | Họ tên        |
| birth_year   | Năm sinh      |
| class_name   | Lớp học       |
| address      | Địa chỉ       |

## 4. Bài làm – tạo VIEW `v_student_basic`

```sql
CREATE VIEW v_student_basic AS
SELECT student_id,
       full_name,
       class_name
FROM   students;
```

## 5. Cách chạy
1. Chạy [`scripts/01_students.sql`](scripts/01_students.sql) để tạo bảng `students` và dữ liệu mẫu.
2. Chạy [`scripts/02_v_student_basic.sql`](scripts/02_v_student_basic.sql) để tạo VIEW.
3. Kiểm tra: `SELECT * FROM v_student_basic;`

| student_id | full_name      | class_name |
|------------|----------------|------------|
| SV001      | Nguyễn Văn An  | CNTT01     |
| SV002      | Trần Thị Bình  | CNTT01     |
| SV003      | Lê Hoàng Cường | CNTT02     |

→ VIEW chỉ có 3 cột, không có `birth_year` và `address`.
