-- ============================================================
-- [Bài tập] Làm quen với View (Một bảng)
-- VIEW v_student_basic: chỉ hiển thị mã sinh viên, họ tên, lớp học
-- (không chứa năm sinh và địa chỉ)
-- ============================================================
USE QuanLySinhVienView;

CREATE VIEW v_student_basic AS
SELECT student_id,
       full_name,
       class_name
FROM   students;
