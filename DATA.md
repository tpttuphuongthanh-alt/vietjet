# Vietjet Travel & Flight Booking - Data Specification

## 1. Kiến trúc lưu trữ dữ liệu (Database Architecture)

Hệ thống hoạt động theo tiêu chí **Frontend thuần - Không có backend**, do đó cơ sở dữ liệu SQLite được triển khai trực tiếp trên trình duyệt thông qua **WebAssembly (`sql.js`)**:

* **Thư viện nhân (Core Engine):** SQLite 3 WebAssembly (`sql.js` qua CDN `https://cdnjs.cloudflare.com/ajax/libs/sql.js/1.8.0/sql-wasm.js`).
* **Cơ chế hoạt động:**
  1. Khi ứng dụng khởi chạy lần đầu: `sql.js` khởi tạo SQLite database trong bộ nhớ WebAssembly, nạp cấu trúc bảng (Schema DDL) và bộ dữ liệu mẫu ban đầu (Seed Data).
  2. Dữ liệu nhị phân của database (`Uint8Array`) được tự động đồng bộ và lưu vào `localStorage` (hoặc `IndexedDB`).
  3. Khi chuyển đổi qua lại giữa các trang HTML (`index.html`, `flights.html`, `tours.html`, `cart.html`...), ứng dụng đọc lại database nhị phân từ storage để giữ nguyên toàn bộ trạng thái giỏ hàng và các đơn hàng đã đặt.
* **Toàn vẹn dữ liệu:** Mọi thao tác truy vấn tìm kiếm, bộ lọc phức tạp, thêm vào giỏ hàng và ghi nhận đơn hàng đều thực thi bằng câu lệnh SQL chuẩn (`SELECT`, `INSERT`, `UPDATE`, `DELETE`, `JOIN`).

---

## 2. Lược đồ cơ sở dữ liệu SQLite (Database Schema DDL)

```sql
-- 1. BẢNG HÃNG HÀNG KHÔNG (airlines)
CREATE TABLE IF NOT EXISTS airlines (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    code TEXT UNIQUE NOT NULL,            -- Mã hãng: VJ, VN, SQ, QH, EK...
    name TEXT NOT NULL,                   -- Tên hãng: VietJet Air, Vietnam Airlines...
    logo_url TEXT NOT NULL,               -- Đường dẫn logo hoặc ảnh SVG
    hotline TEXT,
    website TEXT
);

-- 2. BẢNG SÂN BAY / THÀNH PHỐ (airports)
CREATE TABLE IF NOT EXISTS airports (
    code TEXT PRIMARY KEY,                -- Mã IATA: SGN, HAN, DAD, CXR, PQC, SIN, BKK
    city TEXT NOT NULL,                   -- TP. Hồ Chí Minh, Hà Nội, Đà Nẵng...
    name TEXT NOT NULL,                   -- Sân bay Tân Sơn Nhất, Nội Bài...
    country TEXT NOT NULL                 -- Việt Nam, Singapore, Thái Lan...
);

-- 3. BẢNG CHUYẾN BAY (flights)
CREATE TABLE IF NOT EXISTS flights (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    flight_number TEXT NOT NULL,          -- Mã chuyến bay: VJ-128, VN-244, SQ-178...
    airline_id INTEGER NOT NULL,          -- Khóa ngoại liên kết bảng airlines
    origin_code TEXT NOT NULL,            -- Sân bay cất cánh (SGN, HAN...)
    destination_code TEXT NOT NULL,       -- Sân bay hạ cánh (HAN, DAD...)
    departure_time TEXT NOT NULL,         -- Giờ cất cánh (VD: '06:15', '14:30', '21:00')
    arrival_time TEXT NOT NULL,           -- Giờ hạ cánh (VD: '08:25', '16:45', '23:10')
    duration_minutes INTEGER NOT NULL,    -- Thời gian bay tính theo phút (VD: 130)
    time_slot TEXT NOT NULL,              -- Khung giờ: 'early_morning', 'morning', 'afternoon', 'night'
    flight_type TEXT NOT NULL,            -- 'direct' (Bay thẳng) hoặc 'connecting' (Quá cảnh)
    aircraft_type TEXT NOT NULL,          -- Loại máy bay: 'Airbus A321neo', 'Boeing 787-9 Dreamliner', 'Airbus A350'
    price_economy INTEGER NOT NULL,       -- Giá vé Hạng Phổ Thông (VND, VD: 890000)
    price_business INTEGER NOT NULL,      -- Giá vé Hạng Thương Gia (VND, VD: 2890000)
    baggage_info TEXT NOT NULL,           -- Chi tiết hành lý tiêu chuẩn
    services_info TEXT,                   -- Tiện ích: Wifi, Suất ăn nóng, Màn hình giải trí...
    featured INTEGER DEFAULT 0,           -- 1: Nổi bật, 0: Thường
    FOREIGN KEY (airline_id) REFERENCES airlines(id),
    FOREIGN KEY (origin_code) REFERENCES airports(code),
    FOREIGN KEY (destination_code) REFERENCES airports(code)
);

-- 4. BẢNG TOUR DU LỊCH (tours)
CREATE TABLE IF NOT EXISTS tours (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    code TEXT UNIQUE NOT NULL,            -- Mã tour: TOUR-DAD-01, TOUR-PQC-02...
    title TEXT NOT NULL,                  -- Tên tour trọn gói
    thumbnail_url TEXT NOT NULL,          -- Ảnh tỷ lệ chuẩn 600x400 (aspect ratio 3:2)
    agency_name TEXT NOT NULL,            -- Hãng tổ chức: Vietjet Holidays, Vietravel...
    airline_id INTEGER NOT NULL,          -- Hãng hàng không bay cùng tour
    origin_city TEXT NOT NULL,            -- Điểm xuất phát: TP. Hồ Chí Minh, Hà Nội...
    destination_city TEXT NOT NULL,       -- Điểm đến: Đà Nẵng, Phú Quốc, Bangkok...
    duration_days INTEGER NOT NULL,       -- Số ngày (VD: 4)
    duration_nights INTEGER NOT NULL,     -- Số đêm (VD: 3)
    departure_time TEXT NOT NULL,         -- Giờ cất cánh chuyến bay tour (VD: '07:30')
    flight_duration TEXT NOT NULL,        -- Thời gian bay (VD: '1 giờ 20 phút')
    aircraft_type TEXT NOT NULL,          -- Loại máy bay: 'Airbus A321neo', 'Boeing 787'
    price INTEGER NOT NULL,               -- Giá tour trọn gói (VND, VD: 4590000)
    included_services TEXT NOT NULL,      -- Dịch vụ bao gồm (Khách sạn 4*, Xe đưa đón, Ăn uống...)
    itinerary_json TEXT NOT NULL,         -- JSON mô tả lịch trình chi tiết từng ngày
    featured INTEGER DEFAULT 0,           -- 1: Hiển thị trong 8 tour nổi bật trang chủ
    FOREIGN KEY (airline_id) REFERENCES airlines(id)
);

-- 5. BẢNG ĐƠN ĐẶT CHỖ / GIỎ HÀNG (orders)
CREATE TABLE IF NOT EXISTS orders (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_code TEXT UNIQUE NOT NULL,      -- Mã đặt vé: VJ-ORD-XXXX
    customer_name TEXT NOT NULL,          -- Họ tên khách hàng
    customer_email TEXT NOT NULL,         -- Email khách nhận vé
    customer_phone TEXT NOT NULL,         -- Số điện thoại liên hệ
    customer_id_card TEXT NOT NULL,       -- Số CCCD / CMND / Hộ chiếu
    customer_notes TEXT,                  -- Ghi chú bổ sung
    total_amount INTEGER NOT NULL,        -- Tổng tiền đơn hàng (VND)
    sender_email TEXT DEFAULT 'nvhai061993@gmail.com', -- Email hệ thống gửi xác nhận
    email_status TEXT DEFAULT 'sent',     -- Trạng thái email: 'sent', 'failed'
    status TEXT DEFAULT 'completed',      -- Trạng thái đơn: 'pending', 'completed', 'cancelled'
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 6. BẢNG CHI TIẾT MỤC ĐẶT TRONG ĐƠN (order_items)
CREATE TABLE IF NOT EXISTS order_items (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id INTEGER NOT NULL,            -- Khóa ngoại liên kết orders(id)
    item_type TEXT NOT NULL,              -- 'flight' hoặc 'tour'
    reference_id INTEGER NOT NULL,        -- ID của chuyến bay hoặc tour
    item_title TEXT NOT NULL,             -- Tên chuyến bay (VJ-124 SGN->HAN) hoặc Tên tour
    ticket_class TEXT,                    -- 'economy' hoặc 'business' (đối với chuyến bay)
    flight_details TEXT,                  -- Lưu thông tin hãng bay, giờ bay, loại máy bay
    departure_date TEXT NOT NULL,         -- Ngày bay / khởi hành
    quantity INTEGER DEFAULT 1,           -- Số lượng vé / khách
    unit_price INTEGER NOT NULL,          -- Đơn giá (VND)
    subtotal INTEGER NOT NULL,            -- Thành tiền (VND)
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
);
```

---

## 3. Dữ liệu mẫu khởi tạo sẵn (Initial Seed Data)

### 3.1. Dữ liệu Hãng Hàng Không (`airlines`)
| id | code | name | logo_url |
|---|---|---|---|
| 1 | VJ | VietJet Air | assets/images/airlines/vietjet.svg |
| 2 | VN | Vietnam Airlines | assets/images/airlines/vietnam-airlines.svg |
| 3 | SQ | Singapore Airlines | assets/images/airlines/singapore-airlines.svg |
| 4 | QH | Bamboo Airways | assets/images/airlines/bamboo-airways.svg |
| 5 | EK | Emirates | assets/images/airlines/emirates.svg |
| 6 | QR | Qatar Airways | assets/images/airlines/qatar-airways.svg |

### 3.2. Dữ liệu Sân Bay (`airports`)
| code | city | name | country |
|---|---|---|---|
| SGN | TP. Hồ Chí Minh | Sân bay Quốc tế Tân Sơn Nhất | Việt Nam |
| HAN | Hà Nội | Sân bay Quốc tế Nội Bài | Việt Nam |
| DAD | Đà Nẵng | Sân bay Quốc tế Đà Nẵng | Việt Nam |
| CXR | Nha Trang | Sân bay Quốc tế Cam Ranh | Việt Nam |
| PQC | Phú Quốc | Sân bay Quốc tế Phú Quốc | Việt Nam |
| SIN | Singapore | Sân bay Quốc tế Changi | Singapore |
| BKK | Bangkok | Sân bay Quốc tế Suvarnabhumi | Thái Lan |
| HND | Tokyo | Sân bay Quốc tế Haneda | Nhật Bản |

### 3.3. Dữ liệu Chuyến Bay mẫu (`flights`)
* Dữ liệu đa dạng khung giờ: Sáng sớm (05:00 - 06:00), Sáng (08:00 - 10:00), Chiều (13:00 - 15:00), Tối (19:00 - 22:00).
* Nhiều hãng bay cạnh tranh: VietJet Air, Vietnam Airlines, Bamboo Airways, Singapore Airlines.
* Loại tàu bay: `Airbus A321neo`, `Boeing 787-9 Dreamliner`, `Airbus A350-900`.
* Cả hai mức giá: `price_economy` (từ 799.000đ - 2.100.000đ) và `price_business` (từ 2.490.000đ - 6.500.000đ).

### 3.4. Dữ liệu 8 Tour Du Lịch Nổi Bật (`tours`)
Tất cả 8 tour du lịch đều có hình ảnh thumbnail tỷ lệ chuẩn **600x400**, đầy đủ số ngày/đêm, hãng hàng không, loại máy bay và lịch trình:

1. **Tour Đà Nẵng - Hội An - Bà Nà Hills**
   * *Mã:* `TOUR-DAD-01` | *Thời lượng:* 4 Ngày 3 Đêm
   * *Hãng bay:* VietJet Air | *Máy bay:* Airbus A321neo
   * *Giá:* 4.590.000 ₫
   * *Thumbnail:* `assets/images/tours/tour-danang-600x400.jpg`
2. **Tour Thiên Đường Đảo Ngọc Phú Quốc - Grand World**
   * *Mã:* `TOUR-PQC-02` | *Thời lượng:* 3 Ngày 2 Đêm
   * *Hãng bay:* VietJet Air | *Máy bay:* Airbus A321neo
   * *Giá:* 3.990.000 ₫
   * *Thumbnail:* `assets/images/tours/tour-phuquoc-600x400.jpg`
3. **Tour Hà Nội - Kỳ Quan Vịnh Hạ Long - Sa Pa**
   * *Mã:* `TOUR-HAN-03` | *Thời lượng:* 5 Ngày 4 Đêm
   * *Hãng bay:* Vietnam Airlines | *Máy bay:* Boeing 787-9
   * *Giá:* 6.890.000 ₫
   * *Thumbnail:* `assets/images/tours/tour-halong-600x400.jpg`
4. **Tour Biển Xanh Nha Trang - VinWonders Đẳng Cấp**
   * *Mã:* `TOUR-CXR-04` | *Thời lượng:* 3 Ngày 2 Đêm
   * *Hãng bay:* Bamboo Airways | *Máy bay:* Airbus A320
   * *Giá:* 3.450.000 ₫
   * *Thumbnail:* `assets/images/tours/tour-nhatrang-600x400.jpg`
5. **Tour Bangkok - Thành Phố Không Ngủ Pattaya (Thái Lan)**
   * *Mã:* `TOUR-BKK-05` | *Thời lượng:* 5 Ngày 4 Đêm
   * *Hãng bay:* VietJet Air | *Máy bay:* Airbus A321neo
   * *Giá:* 5.990.000 ₫
   * *Thumbnail:* `assets/images/tours/tour-bangkok-600x400.jpg`
6. **Tour Đảo Quốc Sư Tử Singapore - Khám Phá Changi Jewel**
   * *Mã:* `TOUR-SIN-06` | *Thời lượng:* 4 Ngày 3 Đêm
   * *Hãng bay:* Singapore Airlines | *Máy bay:* Boeing 787-10
   * *Giá:* 10.990.000 ₫
   * *Thumbnail:* `assets/images/tours/tour-singapore-600x400.jpg`
7. **Tour Xứ Sở Kim Chi Seoul - Đảo Nami Lãng Mạn (Hàn Quốc)**
   * *Mã:* `TOUR-ICN-07` | *Thời lượng:* 5 Ngày 4 Đêm
   * *Hãng bay:* VietJet Air | *Máy bay:* Airbus A330
   * *Giá:* 13.990.000 ₫
   * *Thumbnail:* `assets/images/tours/tour-korea-600x400.jpg`
8. **Tour Xứ Sở Mặt Trời Mọc Tokyo - Núi Phú Sĩ (Nhật Bản)**
   * *Mã:* `TOUR-TYO-08` | *Thời lượng:* 6 Ngày 5 Đêm
   * *Hãng bay:* Vietnam Airlines | *Máy bay:* Airbus A350-900
   * *Giá:* 24.990.000 ₫
   * *Thumbnail:* `assets/images/tours/tour-japan-600x400.jpg`

---

## 4. Các câu lệnh truy vấn mẫu cho chức năng ứng dụng

### 4.1. Lọc danh sách chuyến bay theo tiêu chí phía client:
```sql
SELECT f.*, a.name AS airline_name, a.logo_url, 
       dep.city AS origin_city, arr.city AS dest_city
FROM flights f
JOIN airlines a ON f.airline_id = a.id
JOIN airports dep ON f.origin_code = dep.code
JOIN airports arr ON f.destination_code = arr.code
WHERE 1=1
  AND (? IS NULL OR a.name IN (?))
  AND (? IS NULL OR f.flight_type = ?)
  AND (? IS NULL OR f.time_slot IN (?))
ORDER BY 
  CASE WHEN ? = 'price_desc' THEN f.price_economy END DESC,
  CASE WHEN ? = 'price_asc'  THEN f.price_economy END ASC;
```

### 4.2. Ghi nhận đơn hàng & chi tiết đơn hàng:
```sql
-- Thêm đơn hàng
INSERT INTO orders (order_code, customer_name, customer_email, customer_phone, customer_id_card, customer_notes, total_amount, sender_email, email_status)
VALUES (?, ?, ?, ?, ?, ?, ?, 'nvhai061993@gmail.com', 'sent');

-- Thêm các mục vé / tour đã chọn vào đơn
INSERT INTO order_items (order_id, item_type, reference_id, item_title, ticket_class, flight_details, departure_date, quantity, unit_price, subtotal)
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
```
