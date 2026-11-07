-- ====================================================================
-- DATABASE SCHEMA DDL - VIETJET TRAVEL & FLIGHT BOOKING
-- Hệ quản trị cơ sở dữ liệu: SQLite 3
-- Thư mục: sqlite/schema.sql
-- ====================================================================

PRAGMA foreign_keys = ON;

-- Xóa bảng cũ nếu tồn tại (theo thứ tự khóa ngoại)
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS tours;
DROP TABLE IF EXISTS flights;
DROP TABLE IF EXISTS airports;
DROP TABLE IF EXISTS airlines;

-- --------------------------------------------------------------------
-- 1. BẢNG HÃNG HÀNG KHÔNG (airlines)
-- --------------------------------------------------------------------
CREATE TABLE airlines (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    code TEXT UNIQUE NOT NULL,             -- Mã hãng: VJ, VN, SQ, QH, EK, QR...
    name TEXT NOT NULL,                    -- Tên hãng: VietJet Air, Vietnam Airlines, Singapore Airlines...
    logo_url TEXT NOT NULL,                -- Đường dẫn logo (VD: images/download2.png, SVG)
    hotline TEXT,                          -- Số điện thoại tổng đài hỗ trợ
    website TEXT                           -- Website chính thức của hãng
);

-- --------------------------------------------------------------------
-- 2. BẢNG SÂN BAY / ĐIỂM ĐẾN (airports)
-- --------------------------------------------------------------------
CREATE TABLE airports (
    code TEXT PRIMARY KEY,                 -- Mã IATA sân bay: SGN, HAN, DAD, CXR, PQC, SIN, BKK, HND, ICN
    city TEXT NOT NULL,                    -- TP. Hồ Chí Minh, Hà Nội, Đà Nẵng, Nha Trang, Phú Quốc...
    name TEXT NOT NULL,                    -- Tên sân bay: Tân Sơn Nhất, Nội Bài, Changi...
    country TEXT NOT NULL                  -- Quốc gia: Việt Nam, Singapore, Thái Lan, Nhật Bản, Hàn Quốc
);

-- --------------------------------------------------------------------
-- 3. BẢNG CHUYẾN BAY (flights)
-- --------------------------------------------------------------------
CREATE TABLE flights (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    flight_number TEXT NOT NULL,           -- Số hiệu chuyến bay: VJ-124, VN-216, SQ-178...
    airline_id INTEGER NOT NULL,           -- Khóa ngoại -> airlines(id)
    origin_code TEXT NOT NULL,             -- Sân bay đi: SGN, HAN...
    destination_code TEXT NOT NULL,        -- Sân bay đến: HAN, DAD, PQC, SIN, BKK...
    departure_time TEXT NOT NULL,          -- Giờ cất cánh: '05:45', '08:30', '13:15', '19:40'
    arrival_time TEXT NOT NULL,            -- Giờ hạ cánh: '07:55', '10:45', '15:25', '21:50'
    duration_minutes INTEGER NOT NULL,     -- Thời lượng bay tính theo phút (VD: 130)
    duration_text TEXT NOT NULL,           -- Hiển thị trực quan: '2 giờ 10 phút'
    time_slot TEXT NOT NULL,               -- Khung giờ: 'early_morning' (00-06h), 'morning' (06-12h), 'afternoon' (12-18h), 'night' (18-24h)
    flight_type TEXT NOT NULL,             -- 'direct' (Bay thẳng) hoặc 'connecting' (Quá cảnh)
    aircraft_type TEXT NOT NULL,           -- Loại máy bay: 'Airbus A321neo', 'Boeing 787-9 Dreamliner', 'Airbus A350-900', 'Boeing 777-300ER'
    price_economy INTEGER NOT NULL,        -- Giá vé Hạng Phổ Thông (VND, VD: 899000)
    price_business INTEGER NOT NULL,       -- Giá vé Hạng Thương Gia (VND, VD: 2890000)
    baggage_economy TEXT NOT NULL,         -- Chi tiết hành lý Hạng Phổ Thông (VD: '7kg xách tay tiêu chuẩn')
    baggage_business TEXT NOT NULL,        -- Chi tiết hành lý Hạng Thương Gia (VD: '30kg ký gửi + 10kg xách tay + 1 bộ gậy golf')
    services_info TEXT,                    -- Dịch vụ tiện ích (Suất ăn nóng, Wifi, Phòng chờ VIP...)
    featured INTEGER DEFAULT 0,            -- 1: Nổi bật, 0: Thường
    FOREIGN KEY (airline_id) REFERENCES airlines(id) ON DELETE RESTRICT,
    FOREIGN KEY (origin_code) REFERENCES airports(code) ON DELETE RESTRICT,
    FOREIGN KEY (destination_code) REFERENCES airports(code) ON DELETE RESTRICT
);

-- --------------------------------------------------------------------
-- 4. BẢNG TOUR DU LỊCH (tours)
-- --------------------------------------------------------------------
CREATE TABLE tours (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    code TEXT UNIQUE NOT NULL,             -- Mã tour: TOUR-DAD-01, TOUR-PQC-02...
    title TEXT NOT NULL,                   -- Tiêu đề tour trọn gói
    thumbnail_url TEXT NOT NULL,           -- Hình ảnh thumbnail tỷ lệ chuẩn 600x400 (aspect ratio 3:2)
    agency_name TEXT NOT NULL,             -- Hãng du lịch lữ hành: Vietjet Holidays, Vietravel, Saigontourist...
    airline_id INTEGER NOT NULL,           -- Hãng hàng không bay cùng tour
    origin_city TEXT NOT NULL,             -- Điểm xuất phát: TP. Hồ Chí Minh, Hà Nội...
    destination_city TEXT NOT NULL,        -- Điểm đến: Đà Nẵng, Phú Quốc, Bangkok, Singapore, Tokyo...
    duration_days INTEGER NOT NULL,        -- Số ngày: 4
    duration_nights INTEGER NOT NULL,      -- Số đêm: 3
    duration_text TEXT NOT NULL,           -- Chuỗi hiển thị: '4N3Đ', '5N4Đ'
    departure_time TEXT NOT NULL,          -- Thời gian cất cánh: '06:30'
    flight_duration TEXT NOT NULL,         -- Thời gian bay: '1 giờ 20 phút'
    aircraft_type TEXT NOT NULL,           -- Loại máy bay vận chuyển: 'Airbus A321neo', 'Boeing 787-9'...
    price INTEGER NOT NULL,                -- Giá tour trọn gói (VND, VD: 4590000)
    included_services TEXT NOT NULL,       -- Dịch vụ bao gồm: Vé máy bay khứ hồi, Khách sạn 4-5 sao, Xe đưa đón, Ăn uống, Hướng dẫn viên, Bảo hiểm du lịch
    excluded_services TEXT NOT NULL,       -- Dịch vụ không bao gồm: Chi phí cá nhân, Tiền tip, Thuế VAT
    itinerary_json TEXT NOT NULL,          -- Lịch trình chi tiết từng ngày (JSON format)
    featured INTEGER DEFAULT 1,            -- 1: 8 Tour nổi bật trang chủ
    FOREIGN KEY (airline_id) REFERENCES airlines(id) ON DELETE RESTRICT
);

-- --------------------------------------------------------------------
-- 5. BẢNG ĐƠN ĐẶT CHỖ (orders)
-- --------------------------------------------------------------------
CREATE TABLE orders (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_code TEXT UNIQUE NOT NULL,       -- Mã đặt chỗ (Booking Code): VJ-ORD-XXXX
    customer_name TEXT NOT NULL,           -- Họ và tên khách hàng
    customer_email TEXT NOT NULL,          -- Email khách nhận vé (Dùng để gửi email xác nhận)
    customer_phone TEXT NOT NULL,          -- Số điện thoại khách hàng (10 số)
    customer_id_card TEXT NOT NULL,        -- Số CMND / CCCD / Hộ chiếu
    customer_notes TEXT,                   -- Ghi chú bổ sung (yêu cầu đặc biệt)
    total_amount INTEGER NOT NULL,         -- Tổng tiền thanh toán (VND)
    sender_email TEXT DEFAULT 'nvhai061993@gmail.com', -- Email hệ thống gửi xác nhận
    email_status TEXT DEFAULT 'sent',      -- Trạng thái gửi mail: 'sent', 'pending', 'failed'
    status TEXT DEFAULT 'completed',       -- Trạng thái đơn: 'completed', 'pending', 'cancelled'
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP -- Thời gian đặt vé
);

-- --------------------------------------------------------------------
-- 6. BẢNG CHI TIẾT MỤC ĐẶT (order_items)
-- --------------------------------------------------------------------
CREATE TABLE order_items (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id INTEGER NOT NULL,             -- Khóa ngoại -> orders(id)
    item_type TEXT NOT NULL,               -- 'flight' (Vé máy bay) hoặc 'tour' (Tour du lịch)
    reference_id INTEGER NOT NULL,         -- ID chuyến bay hoặc ID tour
    item_title TEXT NOT NULL,              -- Tên chuyến bay (VD: VJ-124 SGN->HAN) hoặc Tên tour
    ticket_class TEXT,                     -- 'economy' (Hạng Phổ Thông) hoặc 'business' (Hạng Thương Gia)
    flight_details TEXT,                   -- Chi tiết: Hãng bay, Loại máy bay, Thời gian bay
    departure_date TEXT NOT NULL,          -- Ngày khởi hành / bay
    quantity INTEGER DEFAULT 1,            -- Số lượng hành khách / vé
    unit_price INTEGER NOT NULL,           -- Đơn giá (VND)
    subtotal INTEGER NOT NULL,             -- Thành tiền = quantity * unit_price
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
);

-- --------------------------------------------------------------------
-- CHỈ MỤC TỐI ƯU HÓA TRUY VẤN (INDEXES)
-- --------------------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_flights_route ON flights(origin_code, destination_code);
CREATE INDEX IF NOT EXISTS idx_flights_airline ON flights(airline_id);
CREATE INDEX IF NOT EXISTS idx_flights_price_eco ON flights(price_economy);
CREATE INDEX IF NOT EXISTS idx_flights_time_slot ON flights(time_slot);
CREATE INDEX IF NOT EXISTS idx_tours_featured ON tours(featured);
CREATE INDEX IF NOT EXISTS idx_tours_price ON tours(price);
CREATE INDEX IF NOT EXISTS idx_orders_code ON orders(order_code);
CREATE INDEX IF NOT EXISTS idx_order_items_order ON order_items(order_id);
