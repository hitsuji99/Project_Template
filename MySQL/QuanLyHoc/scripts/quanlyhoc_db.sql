-- ============================================================
-- [Bài tập] Quản lý học vụ - quanlyhoc_db
-- Đã sửa theo nhận xét:
--   1. Bỏ hàm thời gian trong DEFAULT/CHECK, dùng TRIGGER BEFORE INSERT
--   2. Bọc UPDATE/DELETE bằng SET SQL_SAFE_UPDATES = 0 / = 1
--   3. Format lại: thụt lề 4 dấu cách, viết HOA toàn bộ từ khóa SQL
-- ============================================================


-- ============================================================
-- PHẦN 1: TẠO DATABASE VÀ BẢNG
-- ============================================================
DROP DATABASE IF EXISTS quanlyhoc_db;
CREATE DATABASE quanlyhoc_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
USE quanlyhoc_db;

-- Bảng khóa học
CREATE TABLE courses (
    course_id     INT          PRIMARY KEY AUTO_INCREMENT,
    course_name   VARCHAR(100) NOT NULL,
    course_code   VARCHAR(20)  NOT NULL UNIQUE,
    department    VARCHAR(100) NOT NULL,
    creation_date DATE
);

-- Bảng sinh viên
CREATE TABLE students (
    student_id   INT          PRIMARY KEY AUTO_INCREMENT,
    full_name    VARCHAR(100) NOT NULL,
    major        VARCHAR(100) NOT NULL,
    phone_number VARCHAR(15)  NOT NULL UNIQUE,
    gpa          DECIMAL(3,1) DEFAULT 4.0 CHECK (gpa BETWEEN 0.0 AND 4.0)
);

-- Bảng đăng ký học
CREATE TABLE enrollments (
    enrollment_id INT         PRIMARY KEY AUTO_INCREMENT,
    course_id     INT,
    student_id    INT,
    enroll_time   DATETIME    NOT NULL,
    credits       INT         CHECK (credits > 0),
    status        VARCHAR(50) CHECK (status IN ('Pending', 'Completed', 'Dropped')),
    FOREIGN KEY (course_id)  REFERENCES courses (course_id),
    FOREIGN KEY (student_id) REFERENCES students (student_id)
);

-- Bảng chi tiết đánh giá
-- (bỏ DEFAULT CURRENT_TIMESTAMP, giá trị mặc định được gán bằng trigger bên dưới)
CREATE TABLE enrollment_details (
    detail_id        INT          PRIMARY KEY AUTO_INCREMENT,
    enrollment_id    INT,
    attendance_check VARCHAR(150) NOT NULL,
    detail_date      DATETIME,
    FOREIGN KEY (enrollment_id) REFERENCES enrollments (enrollment_id)
);

-- Bảng nhật ký học vụ
CREATE TABLE academic_logs (
    log_id        INT      PRIMARY KEY AUTO_INCREMENT,
    enrollment_id INT,
    student_id    INT,
    log_time      DATETIME NOT NULL,
    note          TEXT,
    FOREIGN KEY (enrollment_id) REFERENCES enrollments (enrollment_id),
    FOREIGN KEY (student_id)    REFERENCES students (student_id)
);


-- ============================================================
-- TRIGGER: kiểm tra / gán giá trị thời gian trước khi INSERT
-- (thay cho DEFAULT và CHECK dùng hàm thời gian)
-- ============================================================
DELIMITER //

-- Ngày tạo khóa học: để trống thì lấy ngày hiện tại, không được lớn hơn ngày hiện tại
CREATE TRIGGER trg_courses_before_insert
BEFORE INSERT ON courses
FOR EACH ROW
BEGIN
    IF NEW.creation_date IS NULL THEN
        SET NEW.creation_date = CURDATE();
    ELSEIF NEW.creation_date > CURDATE() THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'creation_date không được lớn hơn ngày hiện tại';
    END IF;
END //

-- Thời gian đăng ký không được ở tương lai
CREATE TRIGGER trg_enrollments_before_insert
BEFORE INSERT ON enrollments
FOR EACH ROW
BEGIN
    IF NEW.enroll_time > NOW() THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'enroll_time không được lớn hơn thời điểm hiện tại';
    END IF;
END //

-- Ngày đánh giá: để trống thì lấy thời điểm hiện tại (thay DEFAULT CURRENT_TIMESTAMP)
CREATE TRIGGER trg_enrollment_details_before_insert
BEFORE INSERT ON enrollment_details
FOR EACH ROW
BEGIN
    IF NEW.detail_date IS NULL THEN
        SET NEW.detail_date = NOW();
    END IF;
END //

DELIMITER ;


-- ============================================================
-- PHẦN 2: THÊM, SỬA, XÓA DỮ LIỆU
-- ============================================================
INSERT INTO courses (course_id, course_name, course_code, department, creation_date)
VALUES
    (1, 'Lập trình Java',   'JAVA01', 'CNTT',              '2023-12-03'),
    (2, 'Cấu trúc dữ liệu', 'DSA02',  'Khoa học máy tính', '1996-11-25'),
    (3, 'Cơ sở dữ liệu',    'SQL03',  'CNTT',              '2001-07-08'),
    (4, 'Mạng máy tính',    'NET04',  'Truyền thông',      '1998-01-19'),
    (5, 'Trí tuệ nhân tạo', 'AI05',   'Khoa học máy tính', '2000-09-30');

INSERT INTO students (student_id, full_name, major, phone_number, gpa)
VALUES
    (1, 'Nguyễn Văn Hải', 'Hệ thống TT', '0931112223', 3.8),
    (2, 'Trần Thu Hà',    'Kỹ thuật PM', '0932223334', 4.0),
    (3, 'Lê Quốc Tuấn',   'An toàn TT',  '0933334445', 3.6),
    (4, 'Phạm Minh Châu', 'Dữ liệu lớn', '0934445556', 3.9),
    (5, 'Hoàng Gia Bảo',  'Kỹ thuật PM', '0935556667', 3.7);

INSERT INTO enrollments (enrollment_id, course_id, student_id, enroll_time, credits, status)
VALUES
    (7001, 1, 1, '2024-05-20 08:00', 3, 'Pending'),
    (7002, 2, 2, '2024-05-20 09:30', 4, 'Completed'),
    (7003, 3, 3, '2024-05-20 10:15', 3, 'Pending'),
    (7004, 4, 5, '2024-05-21 07:00', 3, 'Completed'),
    (7005, 5, 4, '2024-05-21 08:45', 4, 'Dropped');

INSERT INTO enrollment_details (detail_id, enrollment_id, attendance_check, detail_date)
VALUES
    (8001, 7002, 'Đủ điều kiện thi', '2024-05-20 10:00'),
    (8002, 7004, 'Vắng 1 buổi',      '2024-05-21 08:00'),
    (8003, 7001, 'Đang học',         '2024-05-20 09:00'),
    (8004, 7003, 'Nghỉ phép',        '2024-05-20 11:00'),
    (8005, 7005, 'Không đi học',     '2024-05-21 09:00');

INSERT INTO academic_logs (log_id, enrollment_id, student_id, log_time, note)
VALUES
    (1, 7001, 1, '2024-05-20 09:05', 'Bắt đầu lớp học'),
    (2, 7002, 2, '2024-05-20 10:05', 'Hoàn tất môn học'),
    (3, 7003, 3, '2024-05-20 11:10', 'Đang sắp xếp lịch bù'),
    (4, 7004, 5, '2024-05-21 08:10', 'Chờ phê duyệt điểm'),
    (5, 7005, 4, '2024-05-21 09:05', 'Hủy do vắng quá số buổi');

-- Tắt safe mode trước khi UPDATE / DELETE
SET SQL_SAFE_UPDATES = 0;

-- UPDATE: tăng 1 tín chỉ cho các đăng ký đã hoàn thành của khóa học tạo trước năm 2000
UPDATE enrollments e
JOIN courses c ON e.course_id = c.course_id
SET e.credits = e.credits + 1
WHERE e.status = 'Completed'
  AND YEAR(c.creation_date) < 2000;

-- DELETE: xóa nhật ký trước ngày 20/05/2024
DELETE FROM academic_logs
WHERE log_time < '2024-05-20';

-- Bật lại safe mode
SET SQL_SAFE_UPDATES = 1;


-- ============================================================
-- PHẦN 3: TRUY VẤN CƠ BẢN
-- ============================================================

-- Câu 1
SELECT full_name, major, gpa
FROM students
WHERE gpa > 3.8
   OR major = 'Kỹ thuật PM';

-- Câu 2
SELECT course_name, course_code
FROM courses
WHERE creation_date BETWEEN '1998-01-01' AND '2001-12-31'
  AND course_code LIKE 'A%';

-- Câu 3
SELECT enrollment_id, enroll_time, credits
FROM enrollments
ORDER BY credits DESC, enrollment_id ASC
LIMIT 2 OFFSET 2;


-- ============================================================
-- PHẦN 4: TRUY VẤN NÂNG CAO
-- ============================================================

-- Câu 1
SELECT c.course_name, s.full_name, s.major, e.credits, e.enroll_time
FROM enrollments e
JOIN courses c  ON e.course_id = c.course_id
JOIN students s ON e.student_id = s.student_id;

-- Câu 2
SELECT s.full_name, SUM(e.credits) AS total_credits
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
WHERE e.status = 'Completed'
GROUP BY s.student_id, s.full_name
HAVING SUM(e.credits) > 120;

-- Câu 3
SELECT student_id, full_name, gpa
FROM students
WHERE gpa = (SELECT MAX(gpa) FROM students);


-- ============================================================
-- PHẦN 5: INDEX VÀ VIEW
-- ============================================================

-- Câu 1
CREATE INDEX idx_enrollments ON enrollments (status, credits);

-- Câu 2
CREATE VIEW v_student AS
SELECT s.full_name,
       COUNT(e.enrollment_id) AS total_courses,
       SUM(e.credits)         AS total_credits
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
WHERE e.status <> 'Dropped'
GROUP BY s.student_id, s.full_name;

SELECT * FROM v_student;
