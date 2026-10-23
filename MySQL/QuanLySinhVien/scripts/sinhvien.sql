-- ============================================================
-- [Bài tập] Quản lý sinh viên - Thực thể SinhVien
-- Chạy trong MySQL Workbench: File > Open SQL Script... > Execute (Ctrl+Shift+Enter)
-- ============================================================

DROP DATABASE IF EXISTS QuanLySinhVien;
CREATE DATABASE QuanLySinhVien
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE QuanLySinhVien;

-- Thực thể: SinhVien
CREATE TABLE SinhVien (
    MaSV        VARCHAR(10)   NOT NULL,           -- Mã sinh viên (khóa chính)
    HoTen       VARCHAR(100)  NOT NULL,           -- Tên sinh viên
    NgaySinh    DATE          NOT NULL,           -- Ngày sinh
    GioiTinh    ENUM('Nam', 'Nu', 'Khac'),        -- Giới tính
    DiaChi      VARCHAR(255),                     -- Địa chỉ
    SoDienThoai VARCHAR(15),                      -- Số điện thoại
    Email       VARCHAR(100)  UNIQUE,             -- Email (không trùng)
    NgayNhapHoc DATE,                             -- Ngày nhập học
    CONSTRAINT PK_SinhVien PRIMARY KEY (MaSV)
);

-- Dữ liệu mẫu
INSERT INTO SinhVien (MaSV, HoTen, NgaySinh, GioiTinh, DiaChi, SoDienThoai, Email, NgayNhapHoc) VALUES
('SV001', 'Nguyễn Văn An',   '2004-03-15', 'Nam', 'Hà Nội',         '0912345678', 'an.nguyen@example.com',  '2022-09-05'),
('SV002', 'Trần Thị Bình',   '2004-07-22', 'Nu',  'Đà Nẵng',        '0987654321', 'binh.tran@example.com',  '2022-09-05'),
('SV003', 'Lê Hoàng Cường',  '2003-11-02', 'Nam', 'TP. Hồ Chí Minh', '0901122334', 'cuong.le@example.com',   '2021-09-06');

-- Kiểm tra
SELECT * FROM SinhVien;
