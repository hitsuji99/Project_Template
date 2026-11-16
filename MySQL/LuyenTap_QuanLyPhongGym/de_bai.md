# BÀI LUYỆN TẬP – CSDL MYSQL: QUẢN LÝ LỚP TẬP PHÒNG GYM

> Bài luyện tập này có **cùng cấu trúc và cùng các kỹ thuật** với đề thi kết thúc môn
> (DDL, ràng buộc, DML, truy vấn, JOIN, GROUP BY/HAVING, phân trang, INDEX, VIEW, TRIGGER,
> STORED PROCEDURE + TRANSACTION), nhưng dùng chủ đề khác.
>
> **Cách học hiệu quả:** tự làm từng câu trước, chạy thử trong MySQL Workbench,
> rồi mới mở `loi_giai.sql` để so sánh và đọc phần giải thích.

---

## PHẦN 1. DDL – THIẾT KẾ CSDL

Tạo CSDL `gym_management` gồm 5 bảng: `gyms`, `members`, `classes`, `class_bookings`, `booking_logs`.

Yêu cầu chung:
- Mỗi bảng có khóa chính kiểu `INT`, tự tăng.
- Khóa ngoại dùng `ON UPDATE CASCADE` và `ON DELETE RESTRICT`.
- Đặt ràng buộc `NOT NULL`, `UNIQUE`, `DEFAULT`, `CHECK` phù hợp.
- Một hội viên không được đặt chỗ trùng một lớp tập.

### 1. `gyms`
| Cột | Kiểu | Mô tả | Ràng buộc |
|---|---|---|---|
| gym_id | INT | Mã chi nhánh | PK, AUTO_INCREMENT |
| gym_name | VARCHAR(100) | Tên chi nhánh | NOT NULL |
| gym_code | VARCHAR(20) | Mã viết tắt | NOT NULL, UNIQUE |
| address | VARCHAR(150) | Địa chỉ | NOT NULL |
| opened_date | DATE | Ngày khai trương | NOT NULL |

### 2. `members`
| Cột | Kiểu | Mô tả | Ràng buộc |
|---|---|---|---|
| member_id | INT | Mã hội viên | PK, AUTO_INCREMENT |
| full_name | VARCHAR(100) | Họ tên | NOT NULL |
| membership_type | VARCHAR(20) | Gói tập | Basic, Silver, Gold |
| phone_number | VARCHAR(15) | Số điện thoại | NOT NULL, UNIQUE |
| fitness_score | DECIMAL(3,1) | Điểm thể lực | DEFAULT 5.0, CHECK 0 – 10 |

### 3. `classes`
| Cột | Kiểu | Mô tả | Ràng buộc |
|---|---|---|---|
| class_id | INT | Mã lớp | PK, AUTO_INCREMENT |
| gym_id | INT | Chi nhánh tổ chức | FK → gyms |
| class_name | VARCHAR(100) | Tên lớp | NOT NULL |
| room | VARCHAR(50) | Phòng tập | NOT NULL |
| start_time | DATETIME | Giờ bắt đầu | NOT NULL |
| fee | DECIMAL(10,2) | Học phí | CHECK ≥ 0 |
| status | VARCHAR(30) | Trạng thái | Scheduled, Completed, Cancelled |

### 4. `class_bookings`
| Cột | Kiểu | Mô tả | Ràng buộc |
|---|---|---|---|
| booking_id | INT | Mã đặt chỗ | PK, AUTO_INCREMENT |
| class_id | INT | Lớp | FK → classes |
| member_id | INT | Hội viên | FK → members |
| attendance_status | VARCHAR(30) | Trạng thái | Booked, Attended, Absent |
| calories | INT | Calo tiêu hao | DEFAULT 0, CHECK ≥ 0 |
| booked_at | DATETIME | Thời điểm đặt | DEFAULT CURRENT_TIMESTAMP |

Thêm `UNIQUE` kết hợp trên (`class_id`, `member_id`).

### 5. `booking_logs`
| Cột | Kiểu | Mô tả | Ràng buộc |
|---|---|---|---|
| log_id | INT | Mã nhật ký | PK, AUTO_INCREMENT |
| booking_id | INT | Đặt chỗ liên quan | FK → class_bookings |
| member_id | INT | Hội viên liên quan | FK → members |
| log_time | DATETIME | Thời gian ghi | NOT NULL |
| note | TEXT | Nội dung | NOT NULL |

---

## PHẦN 2. DML

### Câu 1 – INSERT
**gyms**
| gym_id | gym_name | gym_code | address | opened_date |
|---|---|---|---|---|
| 1 | Iron House | IRH | Quận 3 | 2021-02-14 |
| 2 | Fit Zone | FTZ | Quận 10 | 2022-07-01 |
| 3 | Power Gym | PWG | Tân Bình | 2020-10-10 |

**members**
| member_id | full_name | membership_type | phone_number | fitness_score |
|---|---|---|---|---|
| 1 | Đỗ Thu Hà | Gold | 0911000111 | 8.4 |
| 2 | Ngô Đức Anh | Silver | 0911000222 | 7.2 |
| 3 | Bùi Minh Tâm | Basic | 0911000333 | 6.5 |
| 4 | Lý Ngọc Mai | Gold | 0911000444 | 8.4 |
| 5 | Hồ Văn Lộc | Silver | 0911000555 | 7.0 |

**classes**
| class_id | gym_id | class_name | room | start_time | fee | status |
|---|---|---|---|---|---|---|
| 501 | 1 | Yoga Flow | P101 | 2026-06-01 07:00 | 150000 | Completed |
| 502 | 2 | Boxing Basic | P202 | 2026-06-02 18:00 | 200000 | Completed |
| 503 | 3 | Body Pump | P301 | 2026-06-03 19:00 | 180000 | Scheduled |
| 504 | 1 | Bike Race | P102 | 2026-06-04 06:30 | 120000 | Cancelled |

**class_bookings**
| booking_id | class_id | member_id | attendance_status | calories | booked_at |
|---|---|---|---|---|---|
| 901 | 501 | 1 | Attended | 300 | 2026-05-30 10:00 |
| 902 | 502 | 1 | Attended | 450 | 2026-05-31 09:00 |
| 903 | 502 | 2 | Attended | 400 | 2026-05-31 11:15 |
| 904 | 503 | 3 | Booked | 0 | 2026-06-01 20:00 |
| 905 | 501 | 4 | Absent | 0 | 2026-05-30 12:30 |

**booking_logs**
| log_id | booking_id | member_id | log_time | note |
|---|---|---|---|---|
| 1 | 901 | 1 | 2026-05-30 10:01 | Đặt chỗ thành công |
| 2 | 902 | 1 | 2026-05-31 09:01 | Đặt chỗ thành công |
| 3 | 904 | 3 | 2026-06-01 20:01 | Đặt chỗ thành công |
| 4 | 905 | 4 | 2026-06-01 07:30 | Vắng mặt không báo |

### Câu 2 – UPDATE & DELETE
1. Giảm `fee` 10% cho các lớp có trạng thái `Cancelled`.
2. Xóa các bản ghi `booking_logs` có `log_time` trước ngày `31/05/2026`.

---

## PHẦN 3. TRUY VẤN CƠ BẢN
1. Liệt kê `full_name`, `membership_type`, `fitness_score` của hội viên có điểm thể lực **nhỏ hơn 7.0** **hoặc** gói tập là `Gold`.
2. Liệt kê `class_name`, `room`, `start_time` của các lớp diễn ra **từ 2026-06-01 đến hết ngày 2026-06-03** và tên lớp **chứa chữ `o`**.
3. Liệt kê `booking_id`, `calories`, `booked_at`: sắp xếp `calories` giảm dần, nếu bằng nhau thì `booking_id` tăng dần; mỗi trang 2 bản ghi; **chỉ hiển thị trang thứ ba**.

## PHẦN 4. TRUY VẤN NÂNG CAO
1. JOIN để liệt kê: tên chi nhánh, tên lớp, họ tên hội viên, gói tập, calo tiêu hao, giờ bắt đầu.
2. Liệt kê họ tên hội viên và **tổng calo** trong các đặt chỗ `Attended`; chỉ hiện người có tổng calo **lớn hơn 500**.
3. Liệt kê `member_id`, `full_name`, `fitness_score` của hội viên có điểm thể lực **cao nhất** (hiện tất cả nếu đồng hạng).

## PHẦN 5. INDEX & VIEW
1. Tạo chỉ mục kết hợp trên `class_bookings` gồm `attendance_status`, `calories`.
2. Tạo view gồm `member_id`, `full_name`, tổng số lớp đã đặt, tổng calo; **không tính** đặt chỗ `Absent`; hội viên chưa có đặt chỗ hợp lệ vẫn phải xuất hiện với tổng = 0.

## PHẦN 6. TRIGGER
1. Trigger **AFTER UPDATE** trên `class_bookings`: khi `attendance_status` **thực sự chuyển** sang `Attended`, thêm bản ghi vào `booking_logs` (booking_id, member_id, `NOW()`, `'Member checked in'`). Không ghi log nếu đã là `Attended` từ trước.
2. Trigger **AFTER INSERT** trên `class_bookings`: nếu bản ghi mới là `Attended` thì tăng `fitness_score` của hội viên thêm 0.2, **không vượt quá 10.0**.

## PHẦN 7. STORED PROCEDURE
1. Procedure nhận `member_id`, trả về thông báo theo tổng calo (chỉ tính `Attended`):
   - > 600: `Excellent`  - = 600: `On track`  - < 600: `Need more effort`
   - Chưa tập thì tổng calo xem như 0.
2. Procedure chuyển một đặt chỗ sang hội viên khác (nhận `booking_id`, `new_member_id`):
   bắt đầu transaction → cập nhật `member_id` → thêm log `'Booking transferred'` → `COMMIT`;
   lỗi ở bất kỳ bước nào thì `ROLLBACK` bằng `EXIT HANDLER`.
