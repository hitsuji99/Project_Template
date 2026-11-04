-- ============================================================
-- Chuẩn bị: tạo bảng students và dữ liệu mẫu (để chạy thử VIEW)
-- ============================================================
DROP DATABASE IF EXISTS QuanLySinhVienView;
CREATE DATABASE QuanLySinhVienView;
USE QuanLySinhVienView;

CREATE TABLE students (
    student_id  VARCHAR(10)  NOT NULL,   -- Mã sinh viên
    full_name   VARCHAR(100) NOT NULL,   -- Họ tên
    birth_year  INT,                     -- Năm sinh
    class_name  VARCHAR(50),             -- Lớp học
    address     VARCHAR(255),            -- Địa chỉ
    PRIMARY KEY (student_id)
);

INSERT INTO students (student_id, full_name, birth_year, class_name, address) VALUES
('SV001', 'Nguyễn Văn An',  2004, 'CNTT01', 'Hà Nội'),
('SV002', 'Trần Thị Bình',  2005, 'CNTT01', 'Đà Nẵng'),
('SV003', 'Lê Hoàng Cường', 2004, 'CNTT02', 'TP. Hồ Chí Minh');
