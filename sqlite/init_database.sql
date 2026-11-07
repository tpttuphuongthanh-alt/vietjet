-- ====================================================================
-- DATABASE SCHEMA DDL - VIETJET TRAVEL & FLIGHT BOOKING
-- Há»‡ quáº£n trá»‹ cÆ¡ sá»Ÿ dá»¯ liá»‡u: SQLite 3
-- ThÆ° má»¥c: sqlite/schema.sql
-- ====================================================================

PRAGMA foreign_keys = ON;

-- XÃ³a báº£ng cÅ© náº¿u tá»“n táº¡i (theo thá»© tá»± khÃ³a ngoáº¡i)
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS tours;
DROP TABLE IF EXISTS flights;
DROP TABLE IF EXISTS airports;
DROP TABLE IF EXISTS airlines;

-- --------------------------------------------------------------------
-- 1. Báº¢NG HÃƒNG HÃ€NG KHÃ”NG (airlines)
-- --------------------------------------------------------------------
CREATE TABLE airlines (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    code TEXT UNIQUE NOT NULL,             -- MÃ£ hÃ£ng: VJ, VN, SQ, QH, EK, QR...
    name TEXT NOT NULL,                    -- TÃªn hÃ£ng: VietJet Air, Vietnam Airlines, Singapore Airlines...
    logo_url TEXT NOT NULL,                -- ÄÆ°á»ng dáº«n logo (VD: images/download2.png, SVG)
    hotline TEXT,                          -- Sá»‘ Ä‘iá»‡n thoáº¡i tá»•ng Ä‘Ã i há»— trá»£
    website TEXT                           -- Website chÃ­nh thá»©c cá»§a hÃ£ng
);

-- --------------------------------------------------------------------
-- 2. Báº¢NG SÃ‚N BAY / ÄIá»‚M Äáº¾N (airports)
-- --------------------------------------------------------------------
CREATE TABLE airports (
    code TEXT PRIMARY KEY,                 -- MÃ£ IATA sÃ¢n bay: SGN, HAN, DAD, CXR, PQC, SIN, BKK, HND, ICN
    city TEXT NOT NULL,                    -- TP. Há»“ ChÃ­ Minh, HÃ  Ná»™i, ÄÃ  Náºµng, Nha Trang, PhÃº Quá»‘c...
    name TEXT NOT NULL,                    -- TÃªn sÃ¢n bay: TÃ¢n SÆ¡n Nháº¥t, Ná»™i BÃ i, Changi...
    country TEXT NOT NULL                  -- Quá»‘c gia: Viá»‡t Nam, Singapore, ThÃ¡i Lan, Nháº­t Báº£n, HÃ n Quá»‘c
);

-- --------------------------------------------------------------------
-- 3. Báº¢NG CHUYáº¾N BAY (flights)
-- --------------------------------------------------------------------
CREATE TABLE flights (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    flight_number TEXT NOT NULL,           -- Sá»‘ hiá»‡u chuyáº¿n bay: VJ-124, VN-216, SQ-178...
    airline_id INTEGER NOT NULL,           -- KhÃ³a ngoáº¡i -> airlines(id)
    origin_code TEXT NOT NULL,             -- SÃ¢n bay Ä‘i: SGN, HAN...
    destination_code TEXT NOT NULL,        -- SÃ¢n bay Ä‘áº¿n: HAN, DAD, PQC, SIN, BKK...
    departure_time TEXT NOT NULL,          -- Giá» cáº¥t cÃ¡nh: '05:45', '08:30', '13:15', '19:40'
    arrival_time TEXT NOT NULL,            -- Giá» háº¡ cÃ¡nh: '07:55', '10:45', '15:25', '21:50'
    duration_minutes INTEGER NOT NULL,     -- Thá»i lÆ°á»£ng bay tÃ­nh theo phÃºt (VD: 130)
    duration_text TEXT NOT NULL,           -- Hiá»ƒn thá»‹ trá»±c quan: '2 giá» 10 phÃºt'
    time_slot TEXT NOT NULL,               -- Khung giá»: 'early_morning' (00-06h), 'morning' (06-12h), 'afternoon' (12-18h), 'night' (18-24h)
    flight_type TEXT NOT NULL,             -- 'direct' (Bay tháº³ng) hoáº·c 'connecting' (QuÃ¡ cáº£nh)
    aircraft_type TEXT NOT NULL,           -- Loáº¡i mÃ¡y bay: 'Airbus A321neo', 'Boeing 787-9 Dreamliner', 'Airbus A350-900', 'Boeing 777-300ER'
    price_economy INTEGER NOT NULL,        -- GiÃ¡ vÃ© Háº¡ng Phá»• ThÃ´ng (VND, VD: 899000)
    price_business INTEGER NOT NULL,       -- GiÃ¡ vÃ© Háº¡ng ThÆ°Æ¡ng Gia (VND, VD: 2890000)
    baggage_economy TEXT NOT NULL,         -- Chi tiáº¿t hÃ nh lÃ½ Háº¡ng Phá»• ThÃ´ng (VD: '7kg xÃ¡ch tay tiÃªu chuáº©n')
    baggage_business TEXT NOT NULL,        -- Chi tiáº¿t hÃ nh lÃ½ Háº¡ng ThÆ°Æ¡ng Gia (VD: '30kg kÃ½ gá»­i + 10kg xÃ¡ch tay + 1 bá»™ gáº­y golf')
    services_info TEXT,                    -- Dá»‹ch vá»¥ tiá»‡n Ã­ch (Suáº¥t Äƒn nÃ³ng, Wifi, PhÃ²ng chá» VIP...)
    featured INTEGER DEFAULT 0,            -- 1: Ná»•i báº­t, 0: ThÆ°á»ng
    FOREIGN KEY (airline_id) REFERENCES airlines(id) ON DELETE RESTRICT,
    FOREIGN KEY (origin_code) REFERENCES airports(code) ON DELETE RESTRICT,
    FOREIGN KEY (destination_code) REFERENCES airports(code) ON DELETE RESTRICT
);

-- --------------------------------------------------------------------
-- 4. Báº¢NG TOUR DU Lá»ŠCH (tours)
-- --------------------------------------------------------------------
CREATE TABLE tours (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    code TEXT UNIQUE NOT NULL,             -- MÃ£ tour: TOUR-DAD-01, TOUR-PQC-02...
    title TEXT NOT NULL,                   -- TiÃªu Ä‘á» tour trá»n gÃ³i
    thumbnail_url TEXT NOT NULL,           -- HÃ¬nh áº£nh thumbnail tá»· lá»‡ chuáº©n 600x400 (aspect ratio 3:2)
    agency_name TEXT NOT NULL,             -- HÃ£ng du lá»‹ch lá»¯ hÃ nh: Vietjet Holidays, Vietravel, Saigontourist...
    airline_id INTEGER NOT NULL,           -- HÃ£ng hÃ ng khÃ´ng bay cÃ¹ng tour
    origin_city TEXT NOT NULL,             -- Äiá»ƒm xuáº¥t phÃ¡t: TP. Há»“ ChÃ­ Minh, HÃ  Ná»™i...
    destination_city TEXT NOT NULL,        -- Äiá»ƒm Ä‘áº¿n: ÄÃ  Náºµng, PhÃº Quá»‘c, Bangkok, Singapore, Tokyo...
    duration_days INTEGER NOT NULL,        -- Sá»‘ ngÃ y: 4
    duration_nights INTEGER NOT NULL,      -- Sá»‘ Ä‘Ãªm: 3
    duration_text TEXT NOT NULL,           -- Chuá»—i hiá»ƒn thá»‹: '4N3Ä', '5N4Ä'
    departure_time TEXT NOT NULL,          -- Thá»i gian cáº¥t cÃ¡nh: '06:30'
    flight_duration TEXT NOT NULL,         -- Thá»i gian bay: '1 giá» 20 phÃºt'
    aircraft_type TEXT NOT NULL,           -- Loáº¡i mÃ¡y bay váº­n chuyá»ƒn: 'Airbus A321neo', 'Boeing 787-9'...
    price INTEGER NOT NULL,                -- GiÃ¡ tour trá»n gÃ³i (VND, VD: 4590000)
    included_services TEXT NOT NULL,       -- Dá»‹ch vá»¥ bao gá»“m: VÃ© mÃ¡y bay khá»© há»“i, KhÃ¡ch sáº¡n 4-5 sao, Xe Ä‘Æ°a Ä‘Ã³n, Ä‚n uá»‘ng, HÆ°á»›ng dáº«n viÃªn, Báº£o hiá»ƒm du lá»‹ch
    excluded_services TEXT NOT NULL,       -- Dá»‹ch vá»¥ khÃ´ng bao gá»“m: Chi phÃ­ cÃ¡ nhÃ¢n, Tiá»n tip, Thuáº¿ VAT
    itinerary_json TEXT NOT NULL,          -- Lá»‹ch trÃ¬nh chi tiáº¿t tá»«ng ngÃ y (JSON format)
    featured INTEGER DEFAULT 1,            -- 1: 8 Tour ná»•i báº­t trang chá»§
    FOREIGN KEY (airline_id) REFERENCES airlines(id) ON DELETE RESTRICT
);

-- --------------------------------------------------------------------
-- 5. Báº¢NG ÄÆ N Äáº¶T CHá»– (orders)
-- --------------------------------------------------------------------
CREATE TABLE orders (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_code TEXT UNIQUE NOT NULL,       -- MÃ£ Ä‘áº·t chá»— (Booking Code): VJ-ORD-XXXX
    customer_name TEXT NOT NULL,           -- Há» vÃ  tÃªn khÃ¡ch hÃ ng
    customer_email TEXT NOT NULL,          -- Email khÃ¡ch nháº­n vÃ© (DÃ¹ng Ä‘á»ƒ gá»­i email xÃ¡c nháº­n)
    customer_phone TEXT NOT NULL,          -- Sá»‘ Ä‘iá»‡n thoáº¡i khÃ¡ch hÃ ng (10 sá»‘)
    customer_id_card TEXT NOT NULL,        -- Sá»‘ CMND / CCCD / Há»™ chiáº¿u
    customer_notes TEXT,                   -- Ghi chÃº bá»• sung (yÃªu cáº§u Ä‘áº·c biá»‡t)
    total_amount INTEGER NOT NULL,         -- Tá»•ng tiá»n thanh toÃ¡n (VND)
    sender_email TEXT DEFAULT 'nvhai061993@gmail.com', -- Email há»‡ thá»‘ng gá»­i xÃ¡c nháº­n
    email_status TEXT DEFAULT 'sent',      -- Tráº¡ng thÃ¡i gá»­i mail: 'sent', 'pending', 'failed'
    status TEXT DEFAULT 'completed',       -- Tráº¡ng thÃ¡i Ä‘Æ¡n: 'completed', 'pending', 'cancelled'
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP -- Thá»i gian Ä‘áº·t vÃ©
);

-- --------------------------------------------------------------------
-- 6. Báº¢NG CHI TIáº¾T Má»¤C Äáº¶T (order_items)
-- --------------------------------------------------------------------
CREATE TABLE order_items (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id INTEGER NOT NULL,             -- KhÃ³a ngoáº¡i -> orders(id)
    item_type TEXT NOT NULL,               -- 'flight' (VÃ© mÃ¡y bay) hoáº·c 'tour' (Tour du lá»‹ch)
    reference_id INTEGER NOT NULL,         -- ID chuyáº¿n bay hoáº·c ID tour
    item_title TEXT NOT NULL,              -- TÃªn chuyáº¿n bay (VD: VJ-124 SGN->HAN) hoáº·c TÃªn tour
    ticket_class TEXT,                     -- 'economy' (Háº¡ng Phá»• ThÃ´ng) hoáº·c 'business' (Háº¡ng ThÆ°Æ¡ng Gia)
    flight_details TEXT,                   -- Chi tiáº¿t: HÃ£ng bay, Loáº¡i mÃ¡y bay, Thá»i gian bay
    departure_date TEXT NOT NULL,          -- NgÃ y khá»Ÿi hÃ nh / bay
    quantity INTEGER DEFAULT 1,            -- Sá»‘ lÆ°á»£ng hÃ nh khÃ¡ch / vÃ©
    unit_price INTEGER NOT NULL,           -- ÄÆ¡n giÃ¡ (VND)
    subtotal INTEGER NOT NULL,             -- ThÃ nh tiá»n = quantity * unit_price
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
);

-- --------------------------------------------------------------------
-- CHá»ˆ Má»¤C Tá»I Æ¯U HÃ“A TRUY Váº¤N (INDEXES)
-- --------------------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_flights_route ON flights(origin_code, destination_code);
CREATE INDEX IF NOT EXISTS idx_flights_airline ON flights(airline_id);
CREATE INDEX IF NOT EXISTS idx_flights_price_eco ON flights(price_economy);
CREATE INDEX IF NOT EXISTS idx_flights_time_slot ON flights(time_slot);
CREATE INDEX IF NOT EXISTS idx_tours_featured ON tours(featured);
CREATE INDEX IF NOT EXISTS idx_tours_price ON tours(price);
CREATE INDEX IF NOT EXISTS idx_orders_code ON orders(order_code);
CREATE INDEX IF NOT EXISTS idx_order_items_order ON order_items(order_id);
-- ====================================================================
-- DATABASE SEED DATA - VIETJET TRAVEL & FLIGHT BOOKING
-- Há»‡ quáº£n trá»‹ cÆ¡ sá»Ÿ dá»¯ liá»‡u: SQLite 3
-- ThÆ° má»¥c: sqlite/seed.sql
-- ====================================================================

PRAGMA foreign_keys = ON;

-- --------------------------------------------------------------------
-- 1. Dá»® LIá»†U HÃƒNG HÃ€NG KHÃ”NG (airlines)
-- --------------------------------------------------------------------
INSERT INTO airlines (id, code, name, logo_url, hotline, website) VALUES
(1, 'VJ', 'VietJet Air', 'images/download2.png', '1900 1886', 'https://www.vietjetair.com'),
(2, 'VN', 'Vietnam Airlines', 'https://upload.wikimedia.org/wikipedia/en/thumb/e/e0/Vietnam_Airlines_logo.svg/320px-Vietnam_Airlines_logo.svg.png', '1900 1100', 'https://www.vietnamairlines.com'),
(3, 'SQ', 'Singapore Airlines', 'https://upload.wikimedia.org/wikipedia/en/thumb/6/6b/Singapore_Airlines_Logo_2.svg/320px-Singapore_Airlines_Logo_2.svg.png', '+65 6223 8888', 'https://www.singaporeair.com'),
(4, 'QH', 'Bamboo Airways', 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e9/Bamboo_Airways_logo.svg/320px-Bamboo_Airways_logo.svg.png', '1900 1166', 'https://www.bambooairways.com'),
(5, 'EK', 'Emirates', 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d0/Emirates_logo.svg/320px-Emirates_logo.svg.png', '1900 6006', 'https://www.emirates.com'),
(6, 'QR', 'Qatar Airways', 'https://upload.wikimedia.org/wikipedia/en/thumb/9/9b/Qatar_Airways_Logo.svg/320px-Qatar_Airways_Logo.svg.png', '1900 8899', 'https://www.qatarairways.com');

-- --------------------------------------------------------------------
-- 2. Dá»® LIá»†U SÃ‚N BAY & ÄIá»‚M Äáº¾N (airports)
-- --------------------------------------------------------------------
INSERT INTO airports (code, city, name, country) VALUES
('SGN', 'TP. Há»“ ChÃ­ Minh', 'SÃ¢n bay Quá»‘c táº¿ TÃ¢n SÆ¡n Nháº¥t', 'Viá»‡t Nam'),
('HAN', 'HÃ  Ná»™i', 'SÃ¢n bay Quá»‘c táº¿ Ná»™i BÃ i', 'Viá»‡t Nam'),
('DAD', 'ÄÃ  Náºµng', 'SÃ¢n bay Quá»‘c táº¿ ÄÃ  Náºµng', 'Viá»‡t Nam'),
('CXR', 'Nha Trang', 'SÃ¢n bay Quá»‘c táº¿ Cam Ranh', 'Viá»‡t Nam'),
('PQC', 'PhÃº Quá»‘c', 'SÃ¢n bay Quá»‘c táº¿ PhÃº Quá»‘c', 'Viá»‡t Nam'),
('SIN', 'Singapore', 'SÃ¢n bay Quá»‘c táº¿ Changi', 'Singapore'),
('BKK', 'Bangkok', 'SÃ¢n bay Quá»‘c táº¿ Suvarnabhumi', 'ThÃ¡i Lan'),
('HND', 'Tokyo', 'SÃ¢n bay Quá»‘c táº¿ Haneda', 'Nháº­t Báº£n'),
('ICN', 'Seoul', 'SÃ¢n bay Quá»‘c táº¿ Incheon', 'HÃ n Quá»‘c');

-- --------------------------------------------------------------------
-- 3. Dá»® LIá»†U CHUYáº¾N BAY (flights)
-- Äa dáº¡ng khung giá»: SÃ¡ng sá»›m, SÃ¡ng, Chiá»u, Tá»‘i
-- Äáº§y Ä‘á»§ 2 háº¡ng vÃ©: Háº¡ng Phá»• ThÃ´ng (price_economy) vÃ  Háº¡ng ThÆ°Æ¡ng Gia (price_business)
-- --------------------------------------------------------------------
INSERT INTO flights (id, flight_number, airline_id, origin_code, destination_code, departure_time, arrival_time, duration_minutes, duration_text, time_slot, flight_type, aircraft_type, price_economy, price_business, baggage_economy, baggage_business, services_info, featured) VALUES
(1, 'VJ-124', 1, 'SGN', 'HAN', '05:45', '07:55', 130, '2 giá» 10 phÃºt', 'early_morning', 'direct', 'Airbus A321neo', 899000, 2890000, '7kg xÃ¡ch tay tiÃªu chuáº©n', '30kg kÃ½ gá»­i + 10kg xÃ¡ch tay + PhÃ²ng chá» VIP', 'Suáº¥t Äƒn nháº¹, Gháº¿ bá»c da Ãªm Ã¡i', 1),
(2, 'VN-216', 2, 'SGN', 'HAN', '08:30', '10:45', 135, '2 giá» 15 phÃºt', 'morning', 'direct', 'Boeing 787-9 Dreamliner', 1450000, 3950000, '23kg kÃ½ gá»­i + 12kg xÃ¡ch tay', '32kg kÃ½ gá»­i + 18kg xÃ¡ch tay + BÃ´ng Sen VÃ ng', 'Suáº¥t Äƒn nÃ³ng, MÃ n hÃ¬nh giáº£i trÃ­ cÃ¡ nhÃ¢n HD', 1),
(3, 'QH-202', 4, 'SGN', 'HAN', '13:15', '15:25', 130, '2 giá» 10 phÃºt', 'afternoon', 'direct', 'Airbus A320', 1190000, 3200000, '20kg kÃ½ gá»­i + 7kg xÃ¡ch tay', '30kg kÃ½ gá»­i + 14kg xÃ¡ch tay + Suáº¥t Äƒn Ä‘áº·c biá»‡t', 'NÆ°á»›c uá»‘ng, KhÄƒn láº¡nh, Suáº¥t Äƒn', 0),
(4, 'VJ-158', 1, 'SGN', 'HAN', '19:40', '21:50', 130, '2 giá» 10 phÃºt', 'night', 'direct', 'Airbus A321neo', 799000, 2690000, '7kg xÃ¡ch tay tiÃªu chuáº©n', '30kg kÃ½ gá»­i + 10kg xÃ¡ch tay + Quáº§y thá»§ tá»¥c Æ°u tiÃªn', 'Mua trÆ°á»›c suáº¥t Äƒn Æ°u Ä‘Ã£i, BÃ¡o chÃ­', 0),
(5, 'VJ-362', 1, 'SGN', 'DAD', '06:30', '07:50', 80, '1 giá» 20 phÃºt', 'morning', 'direct', 'Airbus A321neo', 690000, 2190000, '7kg xÃ¡ch tay tiÃªu chuáº©n', '30kg kÃ½ gá»­i + 10kg xÃ¡ch tay + Xe Ä‘Æ°a Ä‘Ã³n riÃªng', 'Suáº¥t Äƒn nháº¹, NÆ°á»›c suá»‘i tinh khiáº¿t', 1),
(6, 'VN-128', 2, 'SGN', 'DAD', '14:00', '15:20', 80, '1 giá» 20 phÃºt', 'afternoon', 'direct', 'Airbus A350-900', 1250000, 3100000, '23kg kÃ½ gá»­i + 12kg xÃ¡ch tay', '32kg kÃ½ gá»­i + 18kg xÃ¡ch tay + PhÃ²ng chá» ThÆ°Æ¡ng Gia', 'Suáº¥t Äƒn nháº¹ cao cáº¥p, NÆ°á»›c Ã©p tÆ°Æ¡i', 0),
(7, 'VJ-322', 1, 'SGN', 'PQC', '09:15', '10:20', 65, '1 giá» 05 phÃºt', 'morning', 'direct', 'Airbus A321neo', 590000, 1890000, '7kg xÃ¡ch tay tiÃªu chuáº©n', '30kg kÃ½ gá»­i + 10kg xÃ¡ch tay + Æ¯u tiÃªn lÃªn tÃ u', 'NÆ°á»›c suá»‘i, Äá»“ Äƒn váº·t', 1),
(8, 'VN-1822', 2, 'SGN', 'PQC', '16:45', '17:50', 65, '1 giá» 05 phÃºt', 'afternoon', 'direct', 'Airbus A321', 1100000, 2750000, '23kg kÃ½ gá»­i + 12kg xÃ¡ch tay', '32kg kÃ½ gá»­i + 18kg xÃ¡ch tay + Lá»‘i an ninh VIP', 'BÃ¡nh ngá»t, TrÃ  sen, KhÄƒn láº¡nh', 0),
(9, 'SQ-178', 3, 'SGN', 'SIN', '12:15', '15:20', 125, '2 giá» 05 phÃºt', 'afternoon', 'direct', 'Boeing 787-10 Dreamliner', 2850000, 7890000, '30kg kÃ½ gá»­i + 7kg xÃ¡ch tay', '40kg kÃ½ gá»­i + 14kg xÃ¡ch tay + Gháº¿ ngáº£ pháº³ng 180Â°', 'Suáº¥t Äƒn 5 sao quá»‘c táº¿, MÃ n hÃ¬nh KrisWorld, Wifi', 1),
(10, 'VJ-801', 1, 'SGN', 'BKK', '11:15', '12:45', 90, '1 giá» 30 phÃºt', 'morning', 'direct', 'Airbus A321neo', 1350000, 3450000, '7kg xÃ¡ch tay tiÃªu chuáº©n', '30kg kÃ½ gá»­i + 10kg xÃ¡ch tay + PhÃ²ng chá» SkyBoss', 'Suáº¥t Äƒn áº©m thá»±c ThÃ¡i Lan Ä‘áº·c sáº¯c', 1),
(11, 'EK-393', 5, 'HAN', 'SGN', '21:00', '23:15', 135, '2 giá» 15 phÃºt', 'night', 'direct', 'Boeing 777-300ER', 1990000, 5600000, '30kg kÃ½ gá»­i + 7kg xÃ¡ch tay', '40kg kÃ½ gá»­i + 14kg xÃ¡ch tay + Bá»™ má»¹ pháº©m Bvlgari', 'Há»‡ thá»‘ng giáº£i trÃ­ ICE 6.500 kÃªnh, Bá»¯a Äƒn thÆ°á»£ng háº¡ng', 0),
(12, 'QR-971', 6, 'SGN', 'HAN', '17:30', '19:45', 135, '2 giá» 15 phÃºt', 'afternoon', 'direct', 'Airbus A350-1000', 2150000, 6200000, '35kg kÃ½ gá»­i + 7kg xÃ¡ch tay', '40kg kÃ½ gá»­i + Qsuite giÆ°á»ng Ä‘Ã´i riÃªng tÆ° sang trá»ng', 'áº¨m thá»±c Trung ÄÃ´ng cao cáº¥p, RÆ°á»£u vang thÆ°á»£ng háº¡ng', 0),
(13, 'VJ-284', 1, 'DAD', 'HAN', '07:15', '08:35', 80, '1 giá» 20 phÃºt', 'morning', 'direct', 'Airbus A320', 650000, 1990000, '7kg xÃ¡ch tay tiÃªu chuáº©n', '30kg kÃ½ gá»­i + 10kg xÃ¡ch tay + Æ¯u tiÃªn chá»n chá»—', 'NÆ°á»›c khoÃ¡ng thiÃªn nhiÃªn', 0),
(14, 'VN-160', 2, 'DAD', 'HAN', '18:50', '20:10', 80, '1 giá» 20 phÃºt', 'night', 'direct', 'Airbus A321neo', 1150000, 2850000, '23kg kÃ½ gá»­i + 12kg xÃ¡ch tay', '32kg kÃ½ gá»­i + 18kg xÃ¡ch tay + Quáº§y lÃ m thá»§ tá»¥c VIP', 'Suáº¥t Äƒn nháº¹ dinh dÆ°á»¡ng', 0),
(15, 'VJ-771', 1, 'HAN', 'CXR', '06:00', '07:50', 110, '1 giá» 50 phÃºt', 'early_morning', 'direct', 'Airbus A321neo', 820000, 2450000, '7kg xÃ¡ch tay tiÃªu chuáº©n', '30kg kÃ½ gá»­i + 10kg xÃ¡ch tay + Suáº¥t Äƒn SkyBoss', 'NÆ°á»›c Ã©p trÃ¡i cÃ¢y tÆ°Æ¡i mÃ¡t', 0),
(16, 'VN-1358', 2, 'HAN', 'CXR', '15:10', '17:00', 110, '1 giá» 50 phÃºt', 'afternoon', 'direct', 'Airbus A321', 1390000, 3350000, '23kg kÃ½ gá»­i + 12kg xÃ¡ch tay', '32kg kÃ½ gá»­i + 18kg xÃ¡ch tay + PhÃ²ng chá» Lotus', 'CÃ  phÃª thÆ¡m ngon, Suáº¥t Äƒn nÃ³ng', 0);

-- --------------------------------------------------------------------
-- 4. Dá»® LIá»†U 8 TOUR DU Lá»ŠCH Ná»”I Báº¬T (tours)
-- HÃ¬nh áº£nh thumbnail chuáº©n tá»· lá»‡ 600x400 (aspect ratio 3:2)
-- Äáº§y Ä‘á»§ sá»‘ ngÃ y/Ä‘Ãªm, hÃ£ng bay, giá» cáº¥t cÃ¡nh, thá»i gian bay, giÃ¡ tour, dá»‹ch vá»¥ vÃ  lá»‹ch trÃ¬nh
-- --------------------------------------------------------------------
INSERT INTO tours (id, code, title, thumbnail_url, agency_name, airline_id, origin_city, destination_city, duration_days, duration_nights, duration_text, departure_time, flight_duration, aircraft_type, price, included_services, excluded_services, itinerary_json, featured) VALUES
(1, 'TOUR-DAD-01', 'Tour ÄÃ  Náºµng - Cáº§u VÃ ng BÃ  NÃ  Hills - Phá»‘ Cá»• Há»™i An', 'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?w=600&h=400&fit=crop', 'Vietjet Holidays', 1, 'TP. Há»“ ChÃ­ Minh', 'ÄÃ  Náºµng', 4, 3, '4N3Ä', '06:30', '1 giá» 20 phÃºt', 'Airbus A321neo', 4590000, 'VÃ© mÃ¡y bay khá»© há»“i Vietjet, KhÃ¡ch sáº¡n 4 sao trung tÃ¢m biá»ƒn Má»¹ KhÃª, VÃ© cÃ¡p treo BÃ  NÃ  Hills, Ä‚n buffet tiÃªu chuáº©n, Xe du lá»‹ch Ä‘Æ°a Ä‘Ã³n VIP, HÆ°á»›ng dáº«n viÃªn suá»‘t tuyáº¿n, Báº£o hiá»ƒm du lá»‹ch 50.000.000Ä‘', 'Chi phÃ­ cÃ¡ nhÃ¢n, Giáº·t á»§i, NÆ°á»›c uá»‘ng ngoÃ i chÆ°Æ¡ng trÃ¬nh, Tiá»n bá»“i dÆ°á»¡ng hÆ°á»›ng dáº«n viÃªn', '[{"day":1,"title":"TP.HCM - ÄÃ  Náºµng - BÃ¡n Äáº£o SÆ¡n TrÃ  - NgÅ© HÃ nh SÆ¡n","desc":"ÄÃ¡p chuyáº¿n bay sÃ¡ng Ä‘áº¿n ÄÃ  Náºµng, viáº¿ng ChÃ¹a Linh á»¨ng SÆ¡n TrÃ  ngáº¯m biá»ƒn Má»¹ KhÃª, tham quan danh tháº¯ng NgÅ© HÃ nh SÆ¡n lÃ ng Ä‘Ã¡ má»¹ nghá»‡ Non NÆ°á»›c."},{"day":2,"title":"Chinh Phá»¥c TiÃªn Cáº£nh BÃ  NÃ  Hills - Check-in Cáº§u VÃ ng Huyá»n Thoáº¡i","desc":"Tráº£i nghiá»‡m tuyáº¿n cÃ¡p treo Ä‘áº¡t ká»· lá»¥c tháº¿ giá»›i, dáº¡o bÆ°á»›c trÃªn Cáº§u VÃ ng khá»•ng lá»“, vui chÆ¡i Fantasy Park vÃ  thÆ°á»Ÿng thá»©c Ä‘áº¡i tiá»‡c buffet hÆ¡n 100 mÃ³n."},{"day":3,"title":"Phá»‘ Cá»• Há»™i An Lung Linh Sáº¯c MÃ u - Tháº£ Hoa ÄÄƒng SÃ´ng HoÃ i","desc":"Dáº¡o bÆ°á»›c ChÃ¹a Cáº§u Nháº­t Báº£n, Há»™i quÃ¡n PhÃºc Kiáº¿n, nhÃ  cá»• PhÃ¹ng HÆ°ng. ThÆ°á»Ÿng thá»©c Ä‘áº·c sáº£n Cao Láº§u, tháº£ Ä‘Ã¨n hoa Ä‘Äƒng lung linh cáº§u may trÃªn dÃ²ng sÃ´ng HoÃ i."},{"day":4,"title":"Chá»£ HÃ n ÄÃ  Náºµng - Mua Sáº¯m Äáº·c Sáº£n - Bay Vá» TP.HCM","desc":"Tá»± do táº¯m biá»ƒn Má»¹ KhÃª buá»•i sá»›m, ghÃ© Chá»£ HÃ n mua cháº£ bÃ², má»±c má»™t náº¯ng, bÃ¡nh khÃ´ mÃ¨. Xe tiá»…n sÃ¢n bay ÄÃ  Náºµng Ä‘Ã¡p chuyáº¿n bay vá» láº¡i TP.HCM."}]', 1),

(2, 'TOUR-PQC-02', 'Tour PhÃº Quá»‘c - ThÃ nh Phá»‘ KhÃ´ng Ngá»§ Grand World - CÃ¡p Treo HÃ²n ThÆ¡m', 'https://images.unsplash.com/photo-1583417319070-4a69db38a482?w=600&h=400&fit=crop', 'Vietjet Holidays', 1, 'TP. Há»“ ChÃ­ Minh', 'PhÃº Quá»‘c', 3, 2, '3N2Ä', '09:15', '1 giá» 05 phÃºt', 'Airbus A321neo', 3990000, 'VÃ© mÃ¡y bay khá»© há»“i Vietjet, Resort 5 sao máº·t biá»ƒn cÃ³ há»“ bÆ¡i vÃ´ cá»±c, VÃ© cÃ¡p treo vÆ°á»£t biá»ƒn HÃ²n ThÆ¡m 2 chiá»u, VÃ© Grand World, 02 bá»¯a buffet sÃ¡ng + 04 bá»¯a chÃ­nh háº£i sáº£n', 'Chi phÃ­ cÃ¡c trÃ² chÆ¡i cÃ³ tÃ­nh phÃ­ riÃªng táº¡i VinWonders, Chi phÃ­ quáº§y bar cÃ¡ nhÃ¢n', '[{"day":1,"title":"TP.HCM - Äáº£o Ngá»c PhÃº Quá»‘c - Sunset Sanato Ngáº¯m HoÃ ng HÃ´n","desc":"Bay tháº³ng Ä‘áº¿n PhÃº Quá»‘c, nháº­n phÃ²ng resort 5 sao. Chiá»u ghÃ© Sunset Sanato check-in biá»ƒu tÆ°á»£ng Ä‘áº§u ngÆ°á»i chia Ä‘Ã´i vÃ  voi chÃ¢n dÃ i ngáº¯m hoÃ ng hÃ´n rá»±c rá»¡."},{"day":2,"title":"Tráº£i Nghiá»‡m CÃ¡p Treo VÆ°á»£t Biá»ƒn HÃ²n ThÆ¡m - Grand World KhÃ´ng Ngá»§","desc":"Äi tuyáº¿n cÃ¡p treo vÆ°á»£t biá»ƒn dÃ i nháº¥t tháº¿ giá»›i sang HÃ²n ThÆ¡m, táº¯m biá»ƒn BÃ£i TrÃ o. Tá»‘i khÃ¡m phÃ¡ kÃªnh Ä‘Ã o Venice thu nhá» táº¡i Grand World vÃ  xem show Sáº¯c MÃ u Venice."},{"day":3,"title":"LÃ ng ChÃ i HÃ m Ninh - Chá»£ ÄÃªm DÆ°Æ¡ng ÄÃ´ng - Mua Äáº·c Sáº£n Bay Vá»","desc":"Tham quan vÆ°á»n tiÃªu Suá»‘i ÄÃ¡, nhÃ  thÃ¹ng nÆ°á»›c máº¯m truyá»n thá»‘ng PhÃº Quá»‘c, trang tráº¡i ngá»c trai. Mua quÃ  Ä‘áº·c sáº£n vÃ  xe tiá»…n Ä‘oÃ n ra sÃ¢n bay vá» láº¡i TP.HCM."}]', 1),

(3, 'TOUR-HAN-03', 'Tour HÃ nh TrÃ¬nh Di Sáº£n: HÃ  Ná»™i - Ká»³ Quan Vá»‹nh Háº¡ Long - Sapa Fansipan', 'https://images.unsplash.com/photo-1528127269322-539801943592?w=600&h=400&fit=crop', 'Vietnam Airlines Tour', 2, 'TP. Há»“ ChÃ­ Minh', 'HÃ  Ná»™i', 5, 4, '5N4Ä', '08:30', '2 giá» 15 phÃºt', 'Boeing 787-9 Dreamliner', 6890000, 'VÃ© mÃ¡y bay khá»© há»“i Vietnam Airlines 23kg kÃ½ gá»­i, Du thuyá»n 5 sao vá»‹nh Háº¡ Long, KhÃ¡ch sáº¡n 4 sao trung tÃ¢m Sapa, VÃ© cÃ¡p treo Fansipan NÃ³c NhÃ  ÄÃ´ng DÆ°Æ¡ng, ToÃ n bá»™ bá»¯a Äƒn cháº¥t lÆ°á»£ng cao', 'VÃ© tÃ u há»a leo nÃºi MÆ°á»ng Hoa, Äá»“ uá»‘ng cÃ¡ nhÃ¢n trong bá»¯a Äƒn', '[{"day":1,"title":"TP.HCM - Thá»§ ÄÃ´ HÃ  Ná»™i NghÃ¬n NÄƒm VÄƒn Hiáº¿n - Há»“ GÆ°Æ¡m 36 Phá»‘ PhÆ°á»ng","desc":"ÄÃ¡p chuyáº¿n bay Boeing 787 Ãªm Ã¡i Ä‘áº¿n Ná»™i BÃ i. Tham quan Quáº£ng trÆ°á»ng Ba ÄÃ¬nh, LÄƒng BÃ¡c, ChÃ¹a Má»™t Cá»™t, Há»“ HoÃ n Kiáº¿m, Äá»n Ngá»c SÆ¡n vÃ  dáº¡o 36 phá»‘ phÆ°á»ng."},{"day":2,"title":"HÃ  Ná»™i - Du Ngoáº¡n Ká»³ Quan ThiÃªn NhiÃªn Vá»‹nh Háº¡ Long","desc":"Di chuyá»ƒn cao tá»‘c Ä‘áº¿n Háº¡ Long, lÃªn du thuyá»n 5 sao thÆ°á»Ÿng ngoáº¡n Äá»™ng ThiÃªn Cung, HÃ²n GÃ  Chá»i, HÃ²n Äá»‰nh HÆ°Æ¡ng. ChÃ¨o thuyá»n kayak trÃªn lÃ n nÆ°á»›c ngá»c bÃ­ch."},{"day":3,"title":"Háº¡ Long - Cao Tá»‘c Ná»™i BÃ i LÃ o Cai Äáº¿n Thá»‹ Tráº¥n Sapa Trong MÃ¢y","desc":"Khá»Ÿi hÃ nh lÃªn vÃ¹ng cao TÃ¢y Báº¯c má»™ng mÆ¡, ngáº¯m cáº£nh ruá»™ng báº­c thang báº¡t ngÃ n. Chiá»u Ä‘áº¿n Sapa dáº¡o NhÃ  thá» Ä‘Ã¡, há»“ Sapa vÃ  thÆ°á»Ÿng thá»©c láº©u cÃ¡ táº§m Ä‘áº·c sáº£n."},{"day":4,"title":"Chinh Phá»¥c Äá»‰nh Cao Fansipan 3.143m - Báº£n LÃ ng CÃ¡t CÃ¡t","desc":"LÃªn cÃ¡p treo Fansipan cháº¡m tay vÃ o Cá»™t má»‘c NÃ³c NhÃ  ÄÃ´ng DÆ°Æ¡ng. Chiá»u tham quan Báº£n CÃ¡t CÃ¡t cá»§a ngÆ°á»i H''MÃ´ng vá»›i guá»“ng nÆ°á»›c, thÃ¡c TiÃªn Sa thÆ¡ má»™ng."},{"day":5,"title":"Chá»£ Sapa - Mua Äáº·c Sáº£n Náº¥m HÆ°Æ¡ng Háº¡t Dáº» - Bay Vá» TP.HCM","desc":"Tá»± do mua sáº¯m thá»• cáº©m, rÆ°á»£u tÃ¡o mÃ¨o táº¡i chá»£ Sapa. Khá»Ÿi hÃ nh vá» sÃ¢n bay Ná»™i BÃ i, Ä‘Ã¡p chuyáº¿n bay tá»‘i vá» láº¡i TP. Há»“ ChÃ­ Minh."}]', 1),

(4, 'TOUR-CXR-04', 'Tour Biá»ƒn Xanh Nha Trang - ThiÃªn ÄÆ°á»ng Giáº£i TrÃ­ VinWonders - Táº¯m KhoÃ¡ng NÃ³ng', 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=600&h=400&fit=crop', 'Bamboo Holidays', 4, 'HÃ  Ná»™i', 'Nha Trang', 3, 2, '3N2Ä', '07:45', '1 giá» 50 phÃºt', 'Airbus A320', 3450000, 'VÃ© mÃ¡y bay khá»© há»“i Bamboo Airways 20kg kÃ½ gá»­i, KhÃ¡ch sáº¡n 4 sao sÃ¡t bá» biá»ƒn Tráº§n PhÃº, VÃ© trá»n gÃ³i CÃ´ng viÃªn chá»§ Ä‘á» VinWonders HÃ²n Tre, Dá»‹ch vá»¥ táº¯m bÃ¹n khoÃ¡ng nÃ³ng I-Resort', 'Chi phÃ­ láº·n biá»ƒn bÃ¬nh khÃ­ chuyÃªn nghiá»‡p, Äá»“ uá»‘ng táº¡i Sailing Club', '[{"day":1,"title":"HÃ  Ná»™i - Nha Trang - ThÃ¡p BÃ  Ponagar - Suá»‘i KhoÃ¡ng NÃ³ng I-Resort","desc":"Bay tá»« HÃ  Ná»™i vÃ o Cam Ranh, viáº¿ng ThÃ¡p BÃ  Ponagar kiáº¿n trÃºc ChÄƒm cá»• kÃ­nh. ThÆ° giÃ£n ngÃ¢m bÃ¹n khoÃ¡ng nÃ³ng phá»¥c há»“i nÄƒng lÆ°á»£ng vÃ  Äƒn tiá»‡c háº£i sáº£n tÆ°Æ¡i ngon."},{"day":2,"title":"Oanh Táº¡c Quáº§n Thá»ƒ Vui ChÆ¡i Giáº£i TrÃ­ Äáº³ng Cáº¥p VinWonders HÃ²n Tre","desc":"Äi cano cao tá»‘c sang Ä‘áº£o HÃ²n Tre, chinh phá»¥c Äá»“i Thá»­ ThÃ¡ch, Vá»‹nh Phao Ná»•i khá»•ng lá»“, Thá»§y cung vá»›i hÃ ng ngÃ n sinh váº­t biá»ƒn vÃ  xem show diá»…n triá»‡u Ä‘Ã´ Tata Show."},{"day":3,"title":"Du Ngoáº¡n Vá»‹nh Nha Trang - Chá»£ Äáº§m Mua Äáº·c Sáº£n - Bay Vá» HÃ  Ná»™i","desc":"Äi tÃ u ngáº¯m váº» Ä‘áº¹p Vá»‹nh Nha Trang, ghÃ© Chá»£ Äáº§m mua yáº¿n sÃ o, cháº£ cÃ¡ Nha Trang, xoÃ i sáº¥y dáº»o. Xe Ä‘Æ°a ra sÃ¢n bay Cam Ranh bay vá» HÃ  Ná»™i."}]', 1),

(5, 'TOUR-BKK-05', 'Tour ThÃ¡i Lan: Bangkok Hiá»‡n Äáº¡i - ThÃ nh Phá»‘ KhÃ´ng Ngá»§ Pattaya - Äáº£o San HÃ´', 'https://images.unsplash.com/photo-1508009603885-50cf7c579365?w=600&h=400&fit=crop', 'Vietjet Holidays', 1, 'TP. Há»“ ChÃ­ Minh', 'Bangkok', 5, 4, '5N4Ä', '11:15', '1 giá» 30 phÃºt', 'Airbus A321neo', 5990000, 'VÃ© mÃ¡y bay khá»© há»“i Vietjet, KhÃ¡ch sáº¡n 4 sao tiÃªu chuáº©n quá»‘c táº¿, Äáº¡i tiá»‡c Buffet táº¡i tÃ²a nhÃ  86 táº§ng Baiyoke Sky, VÃ© xem show diá»…n nghá»‡ thuáº­t Alcazar hoÃ nh trÃ¡ng, Cano ra Äáº£o San HÃ´ Koh Larn', 'Tiá»n bá»“i dÆ°á»¡ng tÃ i xáº¿ vÃ  HDV ThÃ¡i Lan (5$/ngÃ y), Chi phÃ­ Ä‘á»•i tiá»n tá»‡ cÃ¡ nhÃ¢n', '[{"day":1,"title":"TP.HCM - SÃ¢n Bay Suvarnabhumi Bangkok - KhÃ¡m PhÃ¡ Chá»£ ÄÃªm Jodd Fairs","desc":"Bay tháº³ng tá»« SGN Ä‘áº¿n Bangkok. Xe Ä‘Ã³n vá» nháº­n phÃ²ng khÃ¡ch sáº¡n, tá»‘i oanh táº¡c Chá»£ Ä‘Ãªm Jodd Fairs thÆ°á»Ÿng thá»©c SÆ°á»n cay khá»•ng lá»“ vÃ  trÃ  sá»¯a ThÃ¡i truyá»n thá»‘ng."},{"day":2,"title":"Bangkok - ThÃ nh Phá»‘ Biá»ƒn Pattaya - Chá»£ Ná»•i 4 Miá»n - Alcazar Show","desc":"Di chuyá»ƒn Ä‘áº¿n Pattaya, tham quan Chá»£ ná»•i 4 miá»n Ä‘áº·c sáº¯c báº±ng thuyá»n gá»—. Tá»‘i chiÃªm ngÆ°á»¡ng Alcazar Cabaret Show vá»›i Ã¡nh sÃ¡ng vÃ  vÅ© Ä‘iá»‡u Ä‘á»‰nh cao tháº¿ giá»›i."},{"day":3,"title":"Äáº£o San HÃ´ Koh Larn NÆ°á»›c Trong Váº¯t - TrÃ¢n Báº£o Pháº­t SÆ¡n Kháº¯c VÃ ng","desc":"Äi cano lÆ°á»›t sÃ³ng ra Ä‘áº£o Coral Koh Larn tá»± do táº¯m biá»ƒn vÃ  dÃ¹ lÆ°á»£n. Chiá»u viáº¿ng NÃºi Pháº­t VÃ ng Khao Chee Chan Ä‘Æ°á»£c kháº¯c báº±ng vÃ ng 24K uy nghiÃªm."},{"day":4,"title":"Du Thuyá»n TrÃªn SÃ´ng Chao Phraya - Viáº¿ng ChÃ¹a BÃ¬nh Minh Wat Arun","desc":"Dáº¡o thuyá»n trÃªn dÃ²ng sÃ´ng máº¹ Chao Phraya huyá»n thoáº¡i ngáº¯m cÃ¡ ná»•i, check-in ChÃ¹a BÃ¬nh Minh Wat Arun nguy nga trÃ¡ng lá»‡ vÃ  mua sáº¯m táº¡i IconSiam."},{"day":5,"title":"Äáº¡i Tiá»‡c Buffet TÃ²a NhÃ  86 Táº§ng Baiyoke Sky - Big C - Bay Vá» TP.HCM","desc":"Ä‚n buffet quá»‘c táº¿ táº¡i táº§ng cao ngáº¯m toÃ n cáº£nh Bangkok, mua sáº¯m thá»a thÃ­ch táº¡i Big C Supercenter vÃ  xe tiá»…n Ä‘oÃ n ra sÃ¢n bay vá» láº¡i Viá»‡t Nam."}]', 1),

(6, 'TOUR-SIN-06', 'Tour Singapore Äáº£o Quá»‘c SÆ° Tá»­ - ThÃ¡c NÆ°á»›c Jewel Changi - Gardens by the Bay', 'https://images.unsplash.com/photo-1525625293386-3f8f99389edd?w=600&h=400&fit=crop', 'Singapore Airlines Tour', 3, 'TP. Há»“ ChÃ­ Minh', 'Singapore', 4, 3, '4N3Ä', '12:15', '2 giá» 05 phÃºt', 'Boeing 787-10 Dreamliner', 10990000, 'VÃ© mÃ¡y bay 5 sao Singapore Airlines khá»© há»“i, KhÃ¡ch sáº¡n 4 sao trung tÃ¢m Orchard Road, VÃ© tham quan Khu vÆ°á»n tÆ°Æ¡ng lai Gardens by the Bay, VÃ© tÃ u Ä‘iá»‡n sang Äáº£o Sentosa, ThÆ°á»Ÿng thá»©c tiá»‡c Cua Sá»‘t á»št Chilli Crab trá»© danh', 'Chi phÃ­ vÃ© vÃ o Universal Studios Singapore, Chi phÃ­ giáº·t á»§i vÃ  Ä‘á»“ uá»‘ng cÃ³ cá»“n', '[{"day":1,"title":"TP.HCM - SÃ¢n Bay Quá»‘c Táº¿ Changi - ThÃ¡c NÆ°á»›c Trong NhÃ  Khá»•ng Lá»“ Jewel","desc":"Tráº£i nghiá»‡m dá»‹ch vá»¥ bay 5 sao trÃªn mÃ¡y bay thÃ¢n rá»™ng Boeing 787-10. Háº¡ cÃ¡nh Changi, chiÃªm ngÆ°á»¡ng thÃ¡c nÆ°á»›c Vortex 40m Ä‘áº¹p nhÆ° tranh trong tá»• há»£p Jewel."},{"day":2,"title":"CÃ´ng ViÃªn SÆ° Tá»­ Biá»ƒn Merlion Park - TÃ²a NhÃ  Thuyá»n Marina Bay Sands","desc":"Chá»¥p hÃ¬nh cÃ¹ng biá»ƒu tÆ°á»£ng SÆ° tá»­ phun nÆ°á»›c Merlion, dáº¡o bÆ°á»›c cáº§u Helix Ä‘á»™c Ä‘Ã¡o, chiÃªm ngÆ°á»¡ng Marina Bay Sands vÃ  dáº¡o phá»‘ cá»• sáº§m uáº¥t Chinatown."},{"day":3,"title":"SiÃªu CÃ¢y Ká»³ áº¢o Gardens by the Bay - Äáº£o Giáº£i TrÃ­ Sentosa","desc":"Láº¡c bÆ°á»›c vÃ o xá»© sá»Ÿ tÆ°Æ¡ng lai vá»›i dÃ n siÃªu cÃ¢y nÄƒng lÆ°á»£ng Supertree Grove khá»•ng lá»“. Chiá»u qua Ä‘áº£o Sentosa check-in quáº£ cáº§u xoay Universal Studios huyá»n thoáº¡i."},{"day":4,"title":"Khu Phá»‘ Äa Sáº¯c MÃ u Haji Lane - Mua Sáº¯m Äáº¡i Lá»™ Orchard - Bay Vá» TP.HCM","desc":"KhÃ¡m phÃ¡ nghá»‡ thuáº­t tranh tÆ°á»ng graffiti táº¡i Haji Lane, tá»± do mua sáº¯m hÃ ng hiá»‡u miá»…n thuáº¿ táº¡i Orchard Road trÆ°á»›c khi ra sÃ¢n bay Changi Ä‘Ã¡p chuyáº¿n bay vá» TP.HCM."}]', 1),

(7, 'TOUR-ICN-07', 'Tour Xá»© Sá»Ÿ Kim Chi: Thá»§ ÄÃ´ Seoul NÄƒng Äá»™ng - Äáº£o Nami LÃ£ng Máº¡n - CÃ´ng ViÃªn Everland', 'https://images.unsplash.com/photo-1538485399081-7191377e8241?w=600&h=400&fit=crop', 'Vietjet Holidays', 1, 'HÃ  Ná»™i', 'Seoul', 5, 4, '5N4Ä', '23:30', '4 giá» 15 phÃºt', 'Airbus A330', 13990000, 'VÃ© mÃ¡y bay khá»© há»“i Vietjet cháº·ng bay Ä‘Ãªm thoáº£i mÃ¡i, KhÃ¡ch sáº¡n 4 sao Seoul, VÃ© trá»n gÃ³i Äáº¡i cÃ´ng viÃªn giáº£i trÃ­ Everland, VÃ© phÃ  sang Äáº£o Nami, Tráº£i nghiá»‡m máº·c quá»‘c phá»¥c Hanbok chá»¥p áº£nh táº¡i HoÃ ng Cung, Bá»¯a Äƒn thá»‹t nÆ°á»›ng BBQ HÃ n Quá»‘c vÃ  GÃ  háº§m sÃ¢m thÆ°á»£ng háº¡ng', 'Chi phÃ­ visa du lá»‹ch HÃ n Quá»‘c, Tiá»n tip hÆ°á»›ng dáº«n viÃªn Ä‘á»‹a phÆ°Æ¡ng', '[{"day":1,"title":"HÃ  Ná»™i - SÃ¢n Bay Quá»‘c Táº¿ Incheon Seoul (Bay ÄÃªm Nghá»‰ NgÆ¡i)","desc":"Táº­p trung táº¡i Ná»™i BÃ i lÃ m thá»§ tá»¥c Ä‘Ã¡p chuyáº¿n bay tháº³ng cá»§a Vietjet Ä‘áº¿n Incheon, nghá»‰ ngÆ¡i thÆ° giÃ£n trÃªn tÃ u bay thÃ¢n rá»™ng Airbus A330."},{"day":2,"title":"Seoul - Äáº£o Nami Bá»‘i Cáº£nh Phim Báº£n TÃ¬nh Ca MÃ¹a ÄÃ´ng Báº¥t Há»§","desc":"ChÃ o Ä‘Ã³n bÃ¬nh minh xá»© HÃ n, xe Ä‘Æ°a Ä‘oÃ n Ä‘i tham quan Äáº£o Nami thÆ¡ má»™ng vá»›i nhá»¯ng hÃ ng cÃ¢y ngÃ¢n háº¡nh vÃ  báº¡ch dÆ°Æ¡ng tháº³ng táº¯p rá»£p bÃ³ng lÃ£ng máº¡n."},{"day":3,"title":"Cung Äiá»‡n HoÃ ng Gia Gyeongbokgung - LÃ ng Cá»• Bukchon Hanok","desc":"Máº·c trang phá»¥c truyá»n thá»‘ng Hanbok bÆ°á»›c vÃ o Cung Ä‘iá»‡n Gyeongbokgung cá»• kÃ­nh, tham quan NhÃ  Xanh Phá»§ Tá»•ng thá»‘ng vÃ  táº£n bá»™ qua nhá»¯ng con ngÃµ bÃ¬nh yÃªn táº¡i Bukchon."},{"day":4,"title":"Oanh Táº¡c Äáº¡i CÃ´ng ViÃªn Everland - ThiÃªn ÄÆ°á»ng Mua Sáº¯m Myeongdong","desc":"Thá»a sá»©c tham gia cÃ¡c trÃ² chÆ¡i cáº£m giÃ¡c máº¡nh táº¡i Top 10 cÃ´ng viÃªn giáº£i trÃ­ tháº¿ giá»›i Everland. Tá»‘i hÃ²a mÃ¬nh vÃ o thiÃªn Ä‘Æ°á»ng má»¹ pháº©m vÃ  street food Myeongdong."},{"day":5,"title":"ThÃ¡p Truyá»n HÃ¬nh N Seoul - Mua SÃ¢m ChÃ­nh Phá»§ - Bay Vá» HÃ  Ná»™i","desc":"LÃªn ThÃ¡p N Seoul ngáº¯m nhÃ¬n toÃ n cáº£nh thÃ nh phá»‘ vÃ  lÆ°u dáº¥u áº¥n táº¡i Cáº§u khÃ³a tÃ¬nh yÃªu. Mua sáº¯m nhÃ¢n sÃ¢m chÃ­nh phá»§, náº¥m linh chi vÃ  ra sÃ¢n bay Incheon bay vá»."}]', 1),

(8, 'TOUR-TYO-08', 'Tour Nháº­t Báº£n MÃ¹a Hoa: Tokyo Sáº§m Uáº¥t - NÃºi PhÃº SÄ© HÃ¹ng VÄ© - Tráº£i Nghiá»‡m Táº¯m Onsen', 'https://images.unsplash.com/photo-1503899036084-c55cdd92da26?w=600&h=400&fit=crop', 'Vietnam Airlines Tour', 2, 'TP. Há»“ ChÃ­ Minh', 'Tokyo', 6, 5, '6N5Ä', '06:00', '5 giá» 40 phÃºt', 'Airbus A350-900', 24990000, 'VÃ© mÃ¡y bay khá»© há»“i Vietnam Airlines 46kg kÃ½ gá»­i (2 kiá»‡n), KhÃ¡ch sáº¡n 4 sao tiÃªu chuáº©n Nháº­t Báº£n, 01 Ä‘Ãªm nghá»‰ dÆ°á»¡ng resort vÃ  táº¯m khoÃ¡ng nÃ³ng Onsen truyá»n thá»‘ng, ThÆ°á»Ÿng thá»©c thá»‹t bÃ² Wagyu nÆ°á»›ng vÃ  Sushi tÆ°Æ¡i sá»‘ng, VÃ© cÃ¡p treo ngáº¯m NÃºi PhÃº SÄ©', 'Chi phÃ­ visa nháº­p cáº£nh Nháº­t Báº£n, Tiá»n bá»“i dÆ°á»¡ng HDV vÃ  tÃ i xáº¿ (7$/ngÃ y)', '[{"day":1,"title":"TP.HCM - SÃ¢n Bay Quá»‘c Táº¿ Haneda Tokyo - Nghá»‰ NgÆ¡i Nháº­n PhÃ²ng","desc":"ÄÃ¡p chuyáº¿n bay cháº¥t lÆ°á»£ng cao cá»§a Vietnam Airlines Ä‘áº¿n thá»§ Ä‘Ã´ Tokyo nhá»™n nhá»‹p. Xe Ä‘Ã³n vá» nháº­n phÃ²ng khÃ¡ch sáº¡n 4 sao, tá»± do khÃ¡m phÃ¡ phá»‘ Ä‘Ãªm."},{"day":2,"title":"Chinh Phá»¥c NÃºi PhÃº SÄ© Tráº¡m Sá»‘ 5 - LÃ ng Cá»• Thanh BÃ¬nh Oshino Hakkai","desc":"LÃªn Tráº¡m sá»‘ 5 NÃºi PhÃº SÄ© chiÃªm ngÆ°á»¡ng ngá»n nÃºi biá»ƒu tÆ°á»£ng cá»§a nÆ°á»›c Nháº­t. ThÄƒm lÃ ng cá»• Oshino Hakkai dÆ°á»›i chÃ¢n nÃºi vá»›i nhá»¯ng há»“ nÆ°á»›c trong váº¯t tan tá»« bÄƒng tuyáº¿t."},{"day":3,"title":"Tráº£i Nghiá»‡m VÄƒn HÃ³a Táº¯m Suá»‘i KhoÃ¡ng NÃ³ng Onsen Cá»• Truyá»n","desc":"Tráº£i nghiá»‡m phong tá»¥c táº¯m Onsen truyá»n thá»‘ng tá»‘t cho sá»©c khá»e vÃ  sáº¯c Ä‘áº¹p, thÆ°á»Ÿng thá»©c bá»¯a tá»‘i Kaiseki hoÃ ng gia cÃ¹ng rÆ°á»£u sake trá»© danh xá»© PhÃ¹ Tang."},{"day":4,"title":"ChÃ¹a Cá»• Asakusa Kannon - ThÃ¡p Tokyo Skytree - Phá»‘ Äiá»‡n Tá»­ Akihabara","desc":"Viáº¿ng ngÃ´i chÃ¹a cá»• nháº¥t Tokyo Asakusa Kannon vÃ  dáº¡o phá»‘ Nakamise. Check-in thÃ¡p truyá»n hÃ¬nh cao nháº¥t tháº¿ giá»›i Skytree vÃ  thiÃªn Ä‘Æ°á»ng anime Akihabara."},{"day":5,"title":"Giao Lá»™ Báº­n Rá»™n Nháº¥t Tháº¿ Giá»›i Shibuya - Mua Sáº¯m HÃ ng Hiá»‡u Ginza","desc":"Chá»¥p hÃ¬nh cÃ¹ng chÃº chÃ³ trung thÃ nh Hachiko táº¡i giao lá»™ Shibuya huyá»n thoáº¡i, tá»± do mua sáº¯m má»¹ pháº©m, Ä‘á»“ Ä‘iá»‡n tá»­ cao cáº¥p táº¡i khu phá»‘ thÆ°Æ¡ng máº¡i xa hoa Ginza."},{"day":6,"title":"Vá»‹nh NhÃ¢n Táº¡o Odaiba Ngáº¯m TÆ°á»£ng Ná»¯ Tháº§n Tá»± Do - Bay Vá» TP.HCM","desc":"Táº£n bá»™ ngáº¯m Cáº§u Cáº§u Vá»“ng Rainbow Bridge vÃ  TÆ°á»£ng Ná»¯ tháº§n Tá»± do táº¡i Vá»‹nh Odaiba. Xe Ä‘Æ°a ra sÃ¢n bay Haneda Ä‘Ã¡p chuyáº¿n bay vá» láº¡i TP. Há»“ ChÃ­ Minh."}]', 1);

-- --------------------------------------------------------------------
-- 5. Dá»® LIá»†U ÄÆ N HÃ€NG MáºªU (orders & order_items)
-- Kiá»ƒm chá»©ng quy trÃ¬nh gá»­i email tá»« nvhai061993@gmail.com
-- --------------------------------------------------------------------
INSERT INTO orders (id, order_code, customer_name, customer_email, customer_phone, customer_id_card, customer_notes, total_amount, sender_email, email_status, status, created_at) VALUES
(1, 'VJ-ORD-89213', 'Nguyá»…n VÄƒn Háº£i', 'nvhai061993@gmail.com', '0901234567', '079093001234', 'HÃ nh khÃ¡ch yÃªu cáº§u suáº¥t Äƒn nÃ³ng vÃ  gháº¿ cáº¡nh cá»­a sá»•', 5489000, 'nvhai061993@gmail.com', 'sent', 'completed', '2026-11-05 10:30:00');

INSERT INTO order_items (id, order_id, item_type, reference_id, item_title, ticket_class, flight_details, departure_date, quantity, unit_price, subtotal) VALUES
(1, 1, 'flight', 1, 'Chuyáº¿n bay VJ-124: SGN -> HAN', 'economy', 'VietJet Air - Airbus A321neo - 05:45 cáº¥t cÃ¡nh', '2026-11-15', 1, 899000, 899000),
(2, 1, 'tour', 1, 'Tour ÄÃ  Náºµng - Cáº§u VÃ ng BÃ  NÃ  Hills - Phá»‘ Cá»• Há»™i An (4N3Ä)', 'standard', 'Vietjet Holidays - Khá»Ÿi hÃ nh tá»« TP.HCM', '2026-11-20', 1, 4590000, 4590000);
