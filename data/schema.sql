-- CẤU TRÚC CƠ SỞ DỮ LIỆU SQLITE - VIETJET TRAVEL

CREATE TABLE IF NOT EXISTS airlines (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    code TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL,
    logo_url TEXT NOT NULL,
    hotline TEXT,
    website TEXT
);

CREATE TABLE IF NOT EXISTS airports (
    code TEXT PRIMARY KEY,
    city TEXT NOT NULL,
    name TEXT NOT NULL,
    country TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS flights (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    flight_number TEXT NOT NULL,
    airline_id INTEGER NOT NULL,
    origin_code TEXT NOT NULL,
    destination_code TEXT NOT NULL,
    departure_time TEXT NOT NULL,
    arrival_time TEXT NOT NULL,
    duration_minutes INTEGER NOT NULL,
    time_slot TEXT NOT NULL,
    flight_type TEXT NOT NULL,
    aircraft_type TEXT NOT NULL,
    price_economy INTEGER NOT NULL,
    price_business INTEGER NOT NULL,
    baggage_info TEXT NOT NULL,
    services_info TEXT,
    featured INTEGER DEFAULT 0,
    FOREIGN KEY (airline_id) REFERENCES airlines(id),
    FOREIGN KEY (origin_code) REFERENCES airports(code),
    FOREIGN KEY (destination_code) REFERENCES airports(code)
);

CREATE TABLE IF NOT EXISTS tours (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    code TEXT UNIQUE NOT NULL,
    title TEXT NOT NULL,
    thumbnail_url TEXT NOT NULL,
    agency_name TEXT NOT NULL,
    airline_id INTEGER NOT NULL,
    origin_city TEXT NOT NULL,
    destination_city TEXT NOT NULL,
    duration_days INTEGER NOT NULL,
    duration_nights INTEGER NOT NULL,
    departure_time TEXT NOT NULL,
    flight_duration TEXT NOT NULL,
    aircraft_type TEXT NOT NULL,
    price INTEGER NOT NULL,
    included_services TEXT NOT NULL,
    itinerary_json TEXT NOT NULL,
    featured INTEGER DEFAULT 0,
    FOREIGN KEY (airline_id) REFERENCES airlines(id)
);

CREATE TABLE IF NOT EXISTS orders (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_code TEXT UNIQUE NOT NULL,
    customer_name TEXT NOT NULL,
    customer_email TEXT NOT NULL,
    customer_phone TEXT NOT NULL,
    customer_id_card TEXT NOT NULL,
    customer_notes TEXT,
    total_amount INTEGER NOT NULL,
    sender_email TEXT DEFAULT 'nvhai061993@gmail.com',
    email_status TEXT DEFAULT 'sent',
    status TEXT DEFAULT 'completed',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS order_items (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id INTEGER NOT NULL,
    item_type TEXT NOT NULL,
    reference_id INTEGER NOT NULL,
    item_title TEXT NOT NULL,
    ticket_class TEXT,
    flight_details TEXT,
    departure_date TEXT NOT NULL,
    quantity INTEGER DEFAULT 1,
    unit_price INTEGER NOT NULL,
    subtotal INTEGER NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
);
