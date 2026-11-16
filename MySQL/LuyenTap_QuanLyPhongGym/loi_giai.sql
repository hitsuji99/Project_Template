/* =====================================================================
   LỜI GIẢI + HƯỚNG DẪN – BÀI LUYỆN TẬP QUẢN LÝ LỚP TẬP PHÒNG GYM
   Chạy toàn bộ file trong MySQL Workbench (Ctrl + Shift + Enter).
   Đọc kỹ phần "GIẢI THÍCH" ở mỗi câu – đó là chỗ hay mất điểm.
   ===================================================================== */

/* =====================================================================
   PHẦN 1. DDL
   ===================================================================== */
DROP DATABASE IF EXISTS gym_management;
CREATE DATABASE gym_management;
USE gym_management;

-- GIẢI THÍCH: tạo bảng "cha" (không có FK) trước, bảng "con" sau.
-- Thứ tự: gyms, members -> classes -> class_bookings -> booking_logs.

CREATE TABLE gyms (
    gym_id      INT AUTO_INCREMENT PRIMARY KEY,
    gym_name    VARCHAR(100) NOT NULL,
    gym_code    VARCHAR(20)  NOT NULL UNIQUE,
    address     VARCHAR(150) NOT NULL,
    opened_date DATE         NOT NULL
);

CREATE TABLE members (
    member_id       INT AUTO_INCREMENT PRIMARY KEY,
    full_name       VARCHAR(100) NOT NULL,
    -- CHECK ... IN (...) giới hạn giá trị được phép
    membership_type VARCHAR(20)  NOT NULL
        CHECK (membership_type IN ('Basic', 'Silver', 'Gold')),
    phone_number    VARCHAR(15)  NOT NULL UNIQUE,
    -- DECIMAL(3,1): tổng 3 chữ số, 1 chữ số thập phân -> tối đa 99.9
    fitness_score   DECIMAL(3,1) NOT NULL DEFAULT 5.0
        CHECK (fitness_score BETWEEN 0 AND 10)
);

CREATE TABLE classes (
    class_id   INT AUTO_INCREMENT PRIMARY KEY,
    gym_id     INT           NOT NULL,
    class_name VARCHAR(100)  NOT NULL,
    room       VARCHAR(50)   NOT NULL,
    start_time DATETIME      NOT NULL,
    fee        DECIMAL(10,2) NOT NULL CHECK (fee >= 0),
    status     VARCHAR(30)   NOT NULL DEFAULT 'Scheduled'
        CHECK (status IN ('Scheduled', 'Completed', 'Cancelled')),
    -- Đặt tên ràng buộc (CONSTRAINT fk_...) giúp dễ đọc lỗi và dễ DROP sau này
    CONSTRAINT fk_classes_gym FOREIGN KEY (gym_id)
        REFERENCES gyms(gym_id)
        ON UPDATE CASCADE      -- đổi gym_id ở bảng cha -> bảng con tự cập nhật
        ON DELETE RESTRICT     -- không cho xóa gym nếu còn lớp tham chiếu
);

CREATE TABLE class_bookings (
    booking_id        INT AUTO_INCREMENT PRIMARY KEY,
    class_id          INT         NOT NULL,
    member_id         INT         NOT NULL,
    attendance_status VARCHAR(30) NOT NULL DEFAULT 'Booked'
        CHECK (attendance_status IN ('Booked', 'Attended', 'Absent')),
    calories          INT         NOT NULL DEFAULT 0 CHECK (calories >= 0),
    booked_at         DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    -- "Một hội viên không đặt trùng một lớp" = UNIQUE trên CẶP cột
    CONSTRAINT uq_booking_class_member UNIQUE (class_id, member_id),
    CONSTRAINT fk_booking_class FOREIGN KEY (class_id)
        REFERENCES classes(class_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_booking_member FOREIGN KEY (member_id)
        REFERENCES members(member_id) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE booking_logs (
    log_id     INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT      NOT NULL,
    member_id  INT      NOT NULL,
    log_time   DATETIME NOT NULL,
    note       TEXT     NOT NULL,
    CONSTRAINT fk_log_booking FOREIGN KEY (booking_id)
        REFERENCES class_bookings(booking_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_log_member FOREIGN KEY (member_id)
        REFERENCES members(member_id) ON UPDATE CASCADE ON DELETE RESTRICT
);

/* =====================================================================
   PHẦN 6 (viết TRƯỚC khi INSERT?) – LƯU Ý THỨ TỰ
   Nếu tạo trigger AFTER INSERT trước khi chèn dữ liệu mẫu, trigger sẽ chạy
   và làm thay đổi fitness_score của dữ liệu mẫu -> sai "dữ liệu chính xác".
   => Luôn INSERT dữ liệu mẫu TRƯỚC, tạo trigger SAU (như file này).
   ===================================================================== */

/* =====================================================================
   PHẦN 2. DML
   ===================================================================== */
-- Câu 1 – INSERT
-- GIẢI THÍCH: đề cho sẵn mã (class_id = 501...) nên ghi rõ giá trị PK.
-- Ngày tháng viết theo định dạng 'YYYY-MM-DD HH:MM:SS'.
INSERT INTO gyms (gym_id, gym_name, gym_code, address, opened_date) VALUES
(1, 'Iron House', 'IRH', 'Quận 3',   '2021-02-14'),
(2, 'Fit Zone',   'FTZ', 'Quận 10',  '2022-07-01'),
(3, 'Power Gym',  'PWG', 'Tân Bình', '2020-10-10');

-- Số điện thoại lưu VARCHAR -> phải để trong dấu nháy, giữ được số 0 đầu
INSERT INTO members (member_id, full_name, membership_type, phone_number, fitness_score) VALUES
(1, 'Đỗ Thu Hà',    'Gold',   '0911000111', 8.4),
(2, 'Ngô Đức Anh',  'Silver', '0911000222', 7.2),
(3, 'Bùi Minh Tâm', 'Basic',  '0911000333', 6.5),
(4, 'Lý Ngọc Mai',  'Gold',   '0911000444', 8.4),
(5, 'Hồ Văn Lộc',   'Silver', '0911000555', 7.0);

INSERT INTO classes (class_id, gym_id, class_name, room, start_time, fee, status) VALUES
(501, 1, 'Yoga Flow',    'P101', '2026-06-01 07:00:00', 150000, 'Completed'),
(502, 2, 'Boxing Basic', 'P202', '2026-06-02 18:00:00', 200000, 'Completed'),
(503, 3, 'Body Pump',    'P301', '2026-06-03 19:00:00', 180000, 'Scheduled'),
(504, 1, 'Bike Race',    'P102', '2026-06-04 06:30:00', 120000, 'Cancelled');

INSERT INTO class_bookings (booking_id, class_id, member_id, attendance_status, calories, booked_at) VALUES
(901, 501, 1, 'Attended', 300, '2026-05-30 10:00:00'),
(902, 502, 1, 'Attended', 450, '2026-05-31 09:00:00'),
(903, 502, 2, 'Attended', 400, '2026-05-31 11:15:00'),
(904, 503, 3, 'Booked',     0, '2026-06-01 20:00:00'),
(905, 501, 4, 'Absent',     0, '2026-05-30 12:30:00');

INSERT INTO booking_logs (log_id, booking_id, member_id, log_time, note) VALUES
(1, 901, 1, '2026-05-30 10:01:00', 'Đặt chỗ thành công'),
(2, 902, 1, '2026-05-31 09:01:00', 'Đặt chỗ thành công'),
(3, 904, 3, '2026-06-01 20:01:00', 'Đặt chỗ thành công'),
(4, 905, 4, '2026-06-01 07:30:00', 'Vắng mặt không báo');

-- Câu 2 – UPDATE & DELETE
-- Nếu Workbench báo lỗi "safe update mode" (Error 1175), chạy dòng dưới:
SET SQL_SAFE_UPDATES = 0;

-- 2.1 Giảm 10% học phí cho lớp Cancelled  (giảm 10% = nhân 0.9)
UPDATE classes
SET fee = fee * 0.9
WHERE status = 'Cancelled';

-- 2.2 Xóa log trước ngày 31/05/2026
-- GIẢI THÍCH: "trước ngày 31/05" = nhỏ hơn mốc 00:00 của ngày 31/05,
-- tức là log_time < '2026-05-31'. KHÔNG dùng <= (sẽ dính đúng 00:00 ngày 31).
DELETE FROM booking_logs
WHERE log_time < '2026-05-31';

/* =====================================================================
   PHẦN 3. TRUY VẤN CƠ BẢN
   ===================================================================== */
-- Câu 1: điều kiện "hoặc" -> OR
SELECT full_name, membership_type, fitness_score
FROM members
WHERE fitness_score < 7.0
   OR membership_type = 'Gold';

-- Câu 2: "từ ngày A đến HẾT ngày B"
-- GIẢI THÍCH: BETWEEN '2026-06-01' AND '2026-06-03' chỉ lấy đến 00:00 ngày 03
-- => bỏ sót lớp lúc 19:00 ngày 03. Cách đúng: >= ngày đầu và < (ngày cuối + 1).
-- LIKE '%o%': chứa chữ o ; LIKE 'B%': bắt đầu bằng B ; LIKE '%B': kết thúc bằng B
SELECT class_name, room, start_time
FROM classes
WHERE start_time >= '2026-06-01'
  AND start_time <  '2026-06-04'
  AND class_name LIKE '%o%';

-- Câu 3: phân trang
-- GIẢI THÍCH: OFFSET = (số_trang - 1) * số_bản_ghi_mỗi_trang
-- Trang 3, mỗi trang 2  -> OFFSET (3-1)*2 = 4  -> LIMIT 2 OFFSET 4
-- (Trang 2 thì là LIMIT 2 OFFSET 2)
SELECT booking_id, calories, booked_at
FROM class_bookings
ORDER BY calories DESC, booking_id ASC
LIMIT 2 OFFSET 4;

/* =====================================================================
   PHẦN 4. TRUY VẤN NÂNG CAO
   ===================================================================== */
-- Câu 1: JOIN theo chuỗi khóa ngoại
-- class_bookings --(class_id)--> classes --(gym_id)--> gyms
-- class_bookings --(member_id)--> members
SELECT g.gym_name,
       c.class_name,
       m.full_name,
       m.membership_type,
       b.calories,
       c.start_time
FROM class_bookings b
JOIN classes c ON b.class_id  = c.class_id
JOIN gyms    g ON c.gym_id    = g.gym_id
JOIN members m ON b.member_id = m.member_id;

-- Câu 2: WHERE lọc TỪNG DÒNG (trước khi gom nhóm),
--        HAVING lọc NHÓM (sau khi SUM).
SELECT m.full_name,
       SUM(b.calories) AS total_calories
FROM members m
JOIN class_bookings b ON m.member_id = b.member_id
WHERE b.attendance_status = 'Attended'
GROUP BY m.member_id, m.full_name
HAVING SUM(b.calories) > 500;

-- Câu 3: giá trị lớn nhất, hiện TẤT CẢ nếu đồng hạng
-- GIẢI THÍCH: ORDER BY ... LIMIT 1 là SAI vì chỉ trả 1 người.
-- Dùng subquery so sánh với MAX -> ai bằng MAX đều được lấy.
SELECT member_id, full_name, fitness_score
FROM members
WHERE fitness_score = (SELECT MAX(fitness_score) FROM members);

/* =====================================================================
   PHẦN 5. INDEX & VIEW
   ===================================================================== */
-- Câu 1: chỉ mục kết hợp (composite index). Thứ tự cột quan trọng:
-- cột hay dùng để lọc bằng "=" (attendance_status) đặt trước.
CREATE INDEX idx_booking_status_calories
ON class_bookings (attendance_status, calories);

-- Câu 2: VIEW
-- GIẢI THÍCH 3 ý quan trọng:
-- (1) "Hội viên chưa có đặt chỗ vẫn xuất hiện" -> LEFT JOIN từ members.
-- (2) "Không tính Absent" -> đặt điều kiện trong ON, KHÔNG đặt trong WHERE.
--     Nếu đặt WHERE b.attendance_status <> 'Absent' thì dòng NULL của
--     LEFT JOIN bị loại -> hội viên không có đặt chỗ biến mất (sai yêu cầu 1).
-- (3) "Tổng = 0" -> COUNT(b.booking_id) tự trả 0 khi toàn NULL,
--     còn SUM trả NULL -> phải bọc COALESCE(..., 0).
CREATE OR REPLACE VIEW v_member_summary AS
SELECT m.member_id,
       m.full_name,
       COUNT(b.booking_id)          AS total_classes,
       COALESCE(SUM(b.calories), 0) AS total_calories
FROM members m
LEFT JOIN class_bookings b
       ON m.member_id = b.member_id
      AND b.attendance_status <> 'Absent'
GROUP BY m.member_id, m.full_name;

SELECT * FROM v_member_summary;

/* =====================================================================
   PHẦN 6. TRIGGER
   ===================================================================== */
-- DELIMITER: đổi ký tự kết thúc lệnh để MySQL không hiểu nhầm dấu ;
-- bên trong BEGIN...END là kết thúc lệnh CREATE TRIGGER.
DELIMITER //

-- Câu 1: AFTER UPDATE
-- OLD = giá trị trước khi cập nhật, NEW = giá trị sau khi cập nhật.
-- "Thực sự chuyển sang Attended" = NEW là Attended VÀ OLD KHÁC Attended.
-- Nếu chỉ kiểm tra NEW = 'Attended' thì khi update cột calories của dòng
-- đã Attended, trigger vẫn ghi log -> SAI.
CREATE TRIGGER trg_booking_after_update
AFTER UPDATE ON class_bookings
FOR EACH ROW
BEGIN
    IF NEW.attendance_status = 'Attended'
       AND OLD.attendance_status <> 'Attended' THEN
        INSERT INTO booking_logs (booking_id, member_id, log_time, note)
        VALUES (NEW.booking_id, NEW.member_id, NOW(), 'Member checked in');
    END IF;
END //

-- Câu 2: AFTER INSERT (trong trigger INSERT chỉ có NEW, không có OLD)
-- LEAST(a, b) trả giá trị nhỏ hơn -> đảm bảo không vượt 10.0
CREATE TRIGGER trg_booking_after_insert
AFTER INSERT ON class_bookings
FOR EACH ROW
BEGIN
    IF NEW.attendance_status = 'Attended' THEN
        UPDATE members
        SET fitness_score = LEAST(fitness_score + 0.2, 10.0)
        WHERE member_id = NEW.member_id;
    END IF;
END //

DELIMITER ;

-- Kiểm tra trigger 1: 904 từ Booked -> Attended => có log mới
UPDATE class_bookings SET attendance_status = 'Attended' WHERE booking_id = 904;
-- Cập nhật cột khác của dòng đã Attended => KHÔNG có log mới
UPDATE class_bookings SET calories = 350 WHERE booking_id = 904;
SELECT * FROM booking_logs;

-- Kiểm tra trigger 2: Hồ Văn Lộc (7.0) đặt lớp 502 và đã tham gia => 7.2
INSERT INTO class_bookings (class_id, member_id, attendance_status, calories)
VALUES (502, 5, 'Attended', 380);
SELECT member_id, full_name, fitness_score FROM members WHERE member_id = 5;

/* =====================================================================
   PHẦN 7. STORED PROCEDURE
   ===================================================================== */
DELIMITER //

-- Câu 1: dùng tham số OUT để trả thông báo
-- COALESCE(SUM(...), 0): hội viên chưa tập -> SUM ra NULL -> đổi thành 0.
-- Lưu ý: so sánh với NULL luôn ra "không xác định", nên nếu quên COALESCE
-- thì cả 3 nhánh IF đều sai.
CREATE PROCEDURE sp_member_calorie_status(
    IN  p_member_id INT,
    OUT p_message   VARCHAR(50)
)
BEGIN
    DECLARE v_total INT DEFAULT 0;

    SELECT COALESCE(SUM(calories), 0) INTO v_total
    FROM class_bookings
    WHERE member_id = p_member_id
      AND attendance_status = 'Attended';

    IF v_total > 600 THEN
        SET p_message = 'Excellent';
    ELSEIF v_total = 600 THEN
        SET p_message = 'On track';
    ELSE
        SET p_message = 'Need more effort';
    END IF;
END //

-- Câu 2: transaction + EXIT HANDLER
-- EXIT HANDLER FOR SQLEXCEPTION: khi có lỗi SQL bất kỳ (sai FK, trùng UNIQUE...)
-- -> chạy khối BEGIN ROLLBACK; END rồi THOÁT procedure.
-- Phải DECLARE handler ở ĐẦU khối BEGIN (sau các DECLARE biến), trước lệnh khác.
CREATE PROCEDURE sp_transfer_booking(
    IN p_booking_id    INT,
    IN p_new_member_id INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Transfer failed - rolled back' AS result;
    END;

    START TRANSACTION;

    UPDATE class_bookings
    SET member_id = p_new_member_id
    WHERE booking_id = p_booking_id;

    INSERT INTO booking_logs (booking_id, member_id, log_time, note)
    VALUES (p_booking_id, p_new_member_id, NOW(), 'Booking transferred');

    COMMIT;
    SELECT 'Transfer completed' AS result;
END //

DELIMITER ;

-- Kiểm tra procedure 1
CALL sp_member_calorie_status(1, @msg);  SELECT @msg;   -- 750 -> Excellent
CALL sp_member_calorie_status(3, @msg);  SELECT @msg;   -- 350 -> Need more effort
CALL sp_member_calorie_status(4, @msg);  SELECT @msg;   -- 0   -> Need more effort

-- Kiểm tra procedure 2
CALL sp_transfer_booking(905, 2);    -- thành công
CALL sp_transfer_booking(905, 999);  -- hội viên 999 không tồn tại -> lỗi FK -> ROLLBACK
SELECT * FROM class_bookings WHERE booking_id = 905;
SELECT * FROM booking_logs;
