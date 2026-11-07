# HƯỚNG DẪN SỬ DỤNG DATABASE SQLITE - DỰ ÁN VIETJET TRAVEL

Thư mục này chứa toàn bộ các file `.sql` và file cơ sở dữ liệu nhị phân `.db` hoàn chỉnh cho website Vietjet Travel.

---

## 1. Danh sách các file trong thư mục `sqlite/`

| Tên File | Chức năng |
|---|---|
| [`schema.sql`](file:///d:/Phuong%20Thanh/vietjet/sqlite/schema.sql) | Chứa câu lệnh DDL (`CREATE TABLE`, `INDEX`, `PRAGMA`) tạo 6 bảng dữ liệu chuẩn hóa và các chỉ mục tối ưu truy vấn. |
| [`seed.sql`](file:///d:/Phuong%20Thanh/vietjet/sqlite/seed.sql) | Chứa câu lệnh DML (`INSERT INTO`) nạp dữ liệu mẫu phong phú: 6 hãng hàng không, 9 sân bay, 16 chuyến bay nhiều khung giờ, 8 tour du lịch nổi bật (ảnh 600x400) và 1 đơn hàng mẫu. |
| [`init_database.sql`](file:///d:/Phuong%20Thanh/vietjet/sqlite/init_database.sql) | File hợp nhất toàn bộ `schema.sql` và `seed.sql`. Chỉ cần chạy file này là tự động tạo trọn vẹn database trong 1 lệnh duy nhất. |
| [`vietjet.db`](file:///d:/Phuong%20Thanh/vietjet/sqlite/vietjet.db) | File cơ sở dữ liệu SQLite binary thực tế đã được biên dịch sẵn. Bạn có thể mở trực tiếp bằng DB Browser for SQLite hoặc VS Code Extension. |

---

## 2. Thống kê dữ liệu trong `vietjet.db`

* **`airlines` (6 hãng bay):** VietJet Air, Vietnam Airlines, Singapore Airlines, Bamboo Airways, Emirates, Qatar Airways.
* **`airports` (9 sân bay):** TP. Hồ Chí Minh (SGN), Hà Nội (HAN), Đà Nẵng (DAD), Nha Trang (CXR), Phú Quốc (PQC), Singapore (SIN), Bangkok (BKK), Tokyo (HND), Seoul (ICN).
* **`flights` (16 chuyến bay):**
  * Bao phủ 4 khung giờ: Sáng sớm (00-06h), Sáng (06-12h), Chiều (12-18h), Tối (18-24h).
  * Loại tàu bay: `Airbus A321neo`, `Boeing 787-9 Dreamliner`, `Airbus A350-900`, `Boeing 777-300ER`.
  * Đầy đủ 2 mức giá: `price_economy` (Hạng Phổ Thông) và `price_business` (Hạng Thương Gia).
* **`tours` (8 tour nổi bật):**
  * Hình ảnh thumbnail tỷ lệ chuẩn **600x400** (aspect ratio 3:2).
  * Đầy đủ số ngày/đêm (4N3Đ, 3N2Đ, 5N4Đ, 6N5Đ), hãng hàng không, giờ cất cánh, thời gian bay, loại máy bay, dịch vụ bao gồm/không bao gồm.
  * Trường `itinerary_json` lưu trữ chi tiết lịch trình từng ngày định dạng JSON.
* **`orders` & `order_items`:**
  * Lưu trữ đơn hàng với mã đặt chỗ `VJ-ORD-XXXX`, thông tin cá nhân khách hàng, email người gửi `nvhai061993@gmail.com`.

---

## 3. Cách sử dụng

### Cách 1: Sử dụng trực tiếp trong Javascript Frontend qua `sql.js` (WebAssembly)
Trong file `js/db.js`, ứng dụng có thể đọc nội dung file `init_database.sql` hoặc nạp trực tiếp file nhị phân `vietjet.db` vào bộ nhớ WebAssembly:
```javascript
const SQL = await initSqlJs({ locateFile: file => `https://cdnjs.cloudflare.com/ajax/libs/sql.js/1.8.0/${file}` });
// Nạp từ file init_database.sql
const response = await fetch('sqlite/init_database.sql');
const sqlScript = await response.text();
const db = new SQL.Database();
db.run(sqlScript);
```

### Cách 2: Chạy bằng SQLite Command Line (CLI)
```bash
sqlite3 vietjet.db < init_database.sql
```

### Cách 3: Chạy lại bằng Python
```python
import sqlite3

conn = sqlite3.connect("vietjet.db")
with open("init_database.sql", "r", encoding="utf-8") as f:
    conn.executescript(f.read())
conn.close()
```
