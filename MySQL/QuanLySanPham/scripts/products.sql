-- ============================================================
-- [Bài tập] Thao tác dữ liệu với SQL: INSERT, UPDATE, DELETE, SELECT
-- Bảng sử dụng: categories, products
-- Chạy trong MySQL Workbench: File > Open SQL Script... > Execute (Ctrl+Shift+Enter)
-- ============================================================

-- ------------------------------------------------------------
-- 0. Thiết kế CSDL theo sơ đồ
--    products(id PK, name, price, category_id FK) --> categories(id PK, name)
-- ------------------------------------------------------------
DROP DATABASE IF EXISTS QuanLySanPham;
CREATE DATABASE QuanLySanPham
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE QuanLySanPham;

CREATE TABLE categories (
    id    INT          NOT NULL AUTO_INCREMENT,
    name  VARCHAR(255) NOT NULL,
    CONSTRAINT PK_categories PRIMARY KEY (id)
);

CREATE TABLE products (
    id           INT          NOT NULL AUTO_INCREMENT,
    name         VARCHAR(255) NOT NULL,
    price        DOUBLE       NOT NULL,
    category_id  INT,
    CONSTRAINT PK_products PRIMARY KEY (id),
    CONSTRAINT FK_products_categories FOREIGN KEY (category_id)
        REFERENCES categories (id)
);

-- Dữ liệu ban đầu
INSERT INTO categories (name) VALUES
('Điện thoại'),     -- id = 1
('Laptop'),         -- id = 2
('Phụ kiện'),       -- id = 3
('Máy tính bảng');  -- id = 4

INSERT INTO products (name, price, category_id) VALUES
('iPhone 15',           22990000, 1),   -- id = 1
('Samsung Galaxy S24',  19990000, 1),   -- id = 2
('Dell Inspiron 15',    15490000, 2),   -- id = 3
('MacBook Air M2',      24990000, 2),   -- id = 4
('Tai nghe Bluetooth',    590000, 3);   -- id = 5

-- ============================================================
-- YÊU CẦU 1: Thêm 3 sản phẩm mới vào bảng products
-- ============================================================
INSERT INTO products (name, price, category_id) VALUES
('Xiaomi Redmi Note 13',      4990000, 1),
('Chuột không dây Logitech',   350000, 3),
('iPad Gen 10',               9990000, 4);

SELECT * FROM products;   -- kiểm tra: 8 sản phẩm

-- ============================================================
-- YÊU CẦU 2: Cập nhật giá của một sản phẩm đã có
--   'iPhone 15' (id = 1): 22.990.000 -> 20.990.000
-- ============================================================
UPDATE products
SET    price = 20990000
WHERE  id = 1;

SELECT * FROM products WHERE id = 1;   -- kiểm tra giá mới

-- ============================================================
-- YÊU CẦU 3: Xóa một sản phẩm
--   Xóa 'Tai nghe Bluetooth' (id = 5)
-- ============================================================
DELETE FROM products
WHERE  id = 5;

SELECT * FROM products;   -- kiểm tra: còn 7 sản phẩm, không còn id = 5

-- ============================================================
-- YÊU CẦU 4: Hiển thị tất cả sản phẩm, sắp xếp GIẢM DẦN theo giá
-- ============================================================
SELECT p.id,
       p.name,
       p.price,
       c.name AS category_name
FROM   products p
LEFT JOIN categories c ON c.id = p.category_id
ORDER BY p.price DESC;

-- ============================================================
-- YÊU CẦU 5: Thống kê số lượng sản phẩm cho từng danh mục
--   LEFT JOIN để danh mục chưa có sản phẩm vẫn hiển thị với số lượng 0
-- ============================================================
SELECT c.id,
       c.name               AS category_name,
       COUNT(p.id)          AS product_count
FROM   categories c
LEFT JOIN products p ON p.category_id = c.id
GROUP BY c.id, c.name
ORDER BY c.id;
