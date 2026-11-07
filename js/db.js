/**
 * VIETJET TRAVEL - SQLITE DATABASE CONTROLLER (WASM)
 * Vận hành SQLite trực tiếp trên trình duyệt bằng sql.js WebAssembly
 * Đọc dữ liệu từ file db.db hoặc localStorage
 */

window.VietjetDB = {
  db: null,
  isReady: false,
  readyPromise: null,

  init() {
    if (this.readyPromise) return this.readyPromise;

    this.readyPromise = new Promise(async (resolve, reject) => {
      try {
        console.log('[VietjetDB] Đang khởi tạo SQLite WebAssembly...');
        
        // Load sql.js config
        const config = {
          locateFile: file => `https://cdnjs.cloudflare.com/ajax/libs/sql.js/1.8.0/${file}`
        };

        const SQL = await initSqlJs(config);

        // 1. Kiểm tra xem đã có dữ liệu binary trong LocalStorage hay chưa
        const localBinaryStr = localStorage.getItem('vietjet_db_binary');
        if (localBinaryStr) {
          try {
            const binaryArr = Uint8Array.from(atob(localBinaryStr), c => c.charCodeAt(0));
            this.db = new SQL.Database(binaryArr);
            console.log('[VietjetDB] Đã tải cơ sở dữ liệu SQLite từ LocalStorage.');
            this.isReady = true;
            resolve(this.db);
            return;
          } catch (e) {
            console.warn('[VietjetDB] Lỗi đọc LocalStorage binary, chuyển sang đọc file db.db:', e);
          }
        }

        // 2. Thử nạp trực tiếp file db.db từ server / thư mục sqlite/
        let dbLoaded = false;
        const candidatePaths = ['sqlite/db.db', 'db.db', 'sqlite/vietjet.db'];
        
        for (const p of candidatePaths) {
          try {
            const res = await fetch(p);
            if (res.ok) {
              const buf = await res.arrayBuffer();
              if (buf && buf.byteLength > 0) {
                this.db = new SQL.Database(new Uint8Array(buf));
                console.log(`[VietjetDB] Đã nạp thành công database từ ${p} (${buf.byteLength} bytes)`);
                this.persist();
                dbLoaded = true;
                break;
              }
            }
          } catch (err) {
            // Trường hợp chạy file:/// hoặc đường dẫn chưa khớp
          }
        }

        // 3. Fallback: Khởi tạo database mẫu bằng SQL nếu không load được binary file
        if (!dbLoaded) {
          console.warn('[VietjetDB] Không nạp được file binary (có thể do mở trực tiếp bằng file:///), tự động khởi tạo database bằng bộ Seed SQL mặc định.');
          this.db = new SQL.Database();
          this.initFallbackSchemaAndData();
          this.persist();
        }

        this.isReady = true;
        resolve(this.db);
      } catch (err) {
        console.error('[VietjetDB] Lỗi khởi tạo SQLite:', err);
        reject(err);
      }
    });

    return this.readyPromise;
  },

  // Lưu database binary vào LocalStorage để duy trì trạng thái giỏ hàng & đơn hàng
  persist() {
    if (!this.db) return;
    try {
      const data = this.db.export();
      let binaryStr = '';
      const len = data.byteLength;
      for (let i = 0; i < len; i++) {
        binaryStr += String.fromCharCode(data[i]);
      }
      localStorage.setItem('vietjet_db_binary', btoa(binaryStr));
    } catch (e) {
      console.warn('[VietjetDB] Không thể lưu binary vào LocalStorage:', e);
    }
  },

  // Thực thi câu lệnh SQL SELECT trả về danh sách đối tượng JSON thuần
  query(sql, params = []) {
    if (!this.db) throw new Error('Cơ sở dữ liệu SQLite chưa được khởi tạo!');
    const stmt = this.db.prepare(sql);
    stmt.bind(params);
    const results = [];
    while (stmt.step()) {
      results.push(stmt.getAsObject());
    }
    stmt.free();
    return results;
  },

  // Thực thi câu lệnh INSERT / UPDATE / DELETE và tự động lưu
  execute(sql, params = []) {
    if (!this.db) throw new Error('Cơ sở dữ liệu SQLite chưa được khởi tạo!');
    this.db.run(sql, params);
    this.persist();
    return true;
  },

  // Lấy danh sách hãng hàng không
  getAirlines() {
    return this.query('SELECT * FROM airlines ORDER BY id ASC');
  },

  // Lấy danh sách sân bay
  getAirports() {
    return this.query('SELECT * FROM airports ORDER BY city ASC');
  },

  // Tìm kiếm & lọc chuyến bay
  getFlights(filters = {}) {
    let sql = `
      SELECT f.*, a.name AS airline_name, a.logo_url AS airline_logo,
             dep.city AS origin_city, dep.name AS origin_airport_name,
             arr.city AS dest_city, arr.name AS dest_airport_name
      FROM flights f
      JOIN airlines a ON f.airline_id = a.id
      JOIN airports dep ON f.origin_code = dep.code
      JOIN airports arr ON f.destination_code = arr.code
      WHERE 1=1
    `;
    const params = [];

    // Lọc điểm đi
    if (filters.origin) {
      sql += ` AND f.origin_code = ?`;
      params.push(filters.origin);
    }

    // Lọc điểm đến
    if (filters.destination) {
      sql += ` AND f.destination_code = ?`;
      params.push(filters.destination);
    }

    // Lọc theo hãng hàng không
    if (filters.airlines && filters.airlines.length > 0) {
      const placeholders = filters.airlines.map(() => '?').join(',');
      sql += ` AND a.name IN (${placeholders})`;
      params.push(...filters.airlines);
    }

    // Lọc theo khung giờ cất cánh
    if (filters.timeSlots && filters.timeSlots.length > 0) {
      const placeholders = filters.timeSlots.map(() => '?').join(',');
      sql += ` AND f.time_slot IN (${placeholders})`;
      params.push(...filters.timeSlots);
    }

    // Lọc loại chuyến bay (bay thẳng)
    if (filters.directOnly) {
      sql += ` AND f.flight_type = 'direct'`;
    }

    // Sắp xếp
    if (filters.sortBy === 'price_desc') {
      sql += ` ORDER BY f.price_economy DESC`;
    } else {
      sql += ` ORDER BY f.price_economy ASC`;
    }

    return this.query(sql, params);
  },

  // Lấy chi tiết chuyến bay theo ID
  getFlightById(id) {
    const list = this.query(`
      SELECT f.*, a.name AS airline_name, a.logo_url AS airline_logo, a.hotline AS airline_hotline,
             dep.city AS origin_city, dep.name AS origin_airport_name,
             arr.city AS dest_city, arr.name AS dest_airport_name
      FROM flights f
      JOIN airlines a ON f.airline_id = a.id
      JOIN airports dep ON f.origin_code = dep.code
      JOIN airports arr ON f.destination_code = arr.code
      WHERE f.id = ?
    `, [id]);
    return list.length > 0 ? list[0] : null;
  },

  // Lấy 8 tour nổi bật trang chủ
  getFeaturedTours() {
    return this.query(`
      SELECT t.*, a.name AS airline_name
      FROM tours t
      JOIN airlines a ON t.airline_id = a.id
      WHERE t.featured = 1
      LIMIT 8
    `);
  },

  // Lọc danh sách tour
  getTours(filters = {}) {
    let sql = `
      SELECT t.*, a.name AS airline_name
      FROM tours t
      JOIN airlines a ON t.airline_id = a.id
      WHERE 1=1
    `;
    const params = [];

    if (filters.airlines && filters.airlines.length > 0) {
      const placeholders = filters.airlines.map(() => '?').join(',');
      sql += ` AND a.name IN (${placeholders})`;
      params.push(...filters.airlines);
    }

    if (filters.destination) {
      sql += ` AND (t.destination_city LIKE ? OR t.title LIKE ?)`;
      params.push(`%${filters.destination}%`, `%${filters.destination}%`);
    }

    if (filters.sortBy === 'price_desc') {
      sql += ` ORDER BY t.price DESC`;
    } else {
      sql += ` ORDER BY t.price ASC`;
    }

    return this.query(sql, params);
  },

  // Lấy chi tiết tour theo ID
  getTourById(id) {
    const list = this.query(`
      SELECT t.*, a.name AS airline_name, a.logo_url AS airline_logo
      FROM tours t
      JOIN airlines a ON t.airline_id = a.id
      WHERE t.id = ?
    `, [id]);
    return list.length > 0 ? list[0] : null;
  },

  // Tạo đơn hàng mới và lưu vào SQLite
  createOrder(orderData, items) {
    const orderCode = 'VJ-ORD-' + Math.floor(10000 + Math.random() * 90000);
    
    // 1. Thêm vào bảng orders
    this.execute(`
      INSERT INTO orders (order_code, customer_name, customer_email, customer_phone, customer_id_card, customer_notes, total_amount, sender_email, email_status, status)
      VALUES (?, ?, ?, ?, ?, ?, ?, 'nvhai061993@gmail.com', 'sent', 'completed')
    `, [
      orderCode,
      orderData.name,
      orderData.email,
      orderData.phone,
      orderData.idCard,
      orderData.notes || '',
      orderData.totalAmount
    ]);

    // Lấy order ID vừa tạo
    const createdOrders = this.query(`SELECT id FROM orders WHERE order_code = ?`, [orderCode]);
    const orderId = createdOrders[0].id;

    // 2. Thêm từng mục vào order_items
    for (const item of items) {
      this.execute(`
        INSERT INTO order_items (order_id, item_type, reference_id, item_title, ticket_class, flight_details, departure_date, quantity, unit_price, subtotal)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      `, [
        orderId,
        item.type,
        item.id,
        item.title,
        item.ticketClass || 'standard',
        item.details || '',
        item.departureDate || new Date().toISOString().split('T')[0],
        item.quantity || 1,
        item.price,
        item.subtotal || (item.price * (item.quantity || 1))
      ]);
    }

    return {
      orderCode,
      orderId,
      senderEmail: 'nvhai061993@gmail.com',
      customerEmail: orderData.email
    };
  },

  // Bộ dữ liệu khởi tạo mặc định nếu trình duyệt không fetch được binary file
  initFallbackSchemaAndData() {
    this.db.run(`
      CREATE TABLE IF NOT EXISTS airlines (id INTEGER PRIMARY KEY, code TEXT, name TEXT, logo_url TEXT, hotline TEXT, website TEXT);
      CREATE TABLE IF NOT EXISTS airports (code TEXT PRIMARY KEY, city TEXT, name TEXT, country TEXT);
      CREATE TABLE IF NOT EXISTS flights (id INTEGER PRIMARY KEY, flight_number TEXT, airline_id INTEGER, origin_code TEXT, destination_code TEXT, departure_time TEXT, arrival_time TEXT, duration_minutes INTEGER, duration_text TEXT, time_slot TEXT, flight_type TEXT, aircraft_type TEXT, price_economy INTEGER, price_business INTEGER, baggage_economy TEXT, baggage_business TEXT, services_info TEXT, featured INTEGER);
      CREATE TABLE IF NOT EXISTS tours (id INTEGER PRIMARY KEY, code TEXT, title TEXT, thumbnail_url TEXT, agency_name TEXT, airline_id INTEGER, origin_city TEXT, destination_city TEXT, duration_days INTEGER, duration_nights TEXT, duration_text TEXT, departure_time TEXT, flight_duration TEXT, aircraft_type TEXT, price INTEGER, included_services TEXT, excluded_services TEXT, itinerary_json TEXT, featured INTEGER);
      CREATE TABLE IF NOT EXISTS orders (id INTEGER PRIMARY KEY AUTOINCREMENT, order_code TEXT UNIQUE, customer_name TEXT, customer_email TEXT, customer_phone TEXT, customer_id_card TEXT, customer_notes TEXT, total_amount INTEGER, sender_email TEXT, email_status TEXT, status TEXT, created_at DATETIME DEFAULT CURRENT_TIMESTAMP);
      CREATE TABLE IF NOT EXISTS order_items (id INTEGER PRIMARY KEY AUTOINCREMENT, order_id INTEGER, item_type TEXT, reference_id INTEGER, item_title TEXT, ticket_class TEXT, flight_details TEXT, departure_date TEXT, quantity INTEGER, unit_price INTEGER, subtotal INTEGER);
    `);

    // Hãng bay
    this.db.run(`
      INSERT INTO airlines VALUES 
      (1, 'VJ', 'VietJet Air', 'images/download2.png', '1900 1886', 'https://www.vietjetair.com'),
      (2, 'VN', 'Vietnam Airlines', 'https://upload.wikimedia.org/wikipedia/en/thumb/e/e0/Vietnam_Airlines_logo.svg/320px-Vietnam_Airlines_logo.svg.png', '1900 1100', 'https://www.vietnamairlines.com'),
      (3, 'SQ', 'Singapore Airlines', 'https://upload.wikimedia.org/wikipedia/en/thumb/6/6b/Singapore_Airlines_Logo_2.svg/320px-Singapore_Airlines_Logo_2.svg.png', '+65 6223 8888', 'https://www.singaporeair.com'),
      (4, 'QH', 'Bamboo Airways', 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e9/Bamboo_Airways_logo.svg/320px-Bamboo_Airways_logo.svg.png', '1900 1166', 'https://www.bambooairways.com'),
      (5, 'EK', 'Emirates', 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d0/Emirates_logo.svg/320px-Emirates_logo.svg.png', '1900 6006', 'https://www.emirates.com'),
      (6, 'QR', 'Qatar Airways', 'https://upload.wikimedia.org/wikipedia/en/thumb/9/9b/Qatar_Airways_Logo.svg/320px-Qatar_Airways_Logo.svg.png', '1900 8899', 'https://www.qatarairways.com');
    `);

    // Sân bay
    this.db.run(`
      INSERT INTO airports VALUES
      ('SGN', 'TP. Hồ Chí Minh', 'Sân bay Quốc tế Tân Sơn Nhất', 'Việt Nam'),
      ('HAN', 'Hà Nội', 'Sân bay Quốc tế Nội Bài', 'Việt Nam'),
      ('DAD', 'Đà Nẵng', 'Sân bay Quốc tế Đà Nẵng', 'Việt Nam'),
      ('CXR', 'Nha Trang', 'Sân bay Quốc tế Cam Ranh', 'Việt Nam'),
      ('PQC', 'Phú Quốc', 'Sân bay Quốc tế Phú Quốc', 'Việt Nam'),
      ('SIN', 'Singapore', 'Sân bay Quốc tế Changi', 'Singapore'),
      ('BKK', 'Bangkok', 'Sân bay Quốc tế Suvarnabhumi', 'Thái Lan'),
      ('HND', 'Tokyo', 'Sân bay Quốc tế Haneda', 'Nhật Bản'),
      ('ICN', 'Seoul', 'Sân bay Quốc tế Incheon', 'Hàn Quốc');
    `);

    // Chuyến bay mẫu
    this.db.run(`
      INSERT INTO flights VALUES
      (1, 'VJ-124', 1, 'SGN', 'HAN', '05:45', '07:55', 130, '2 giờ 10 phút', 'early_morning', 'direct', 'Airbus A321neo', 899000, 2890000, '7kg xách tay tiêu chuẩn', '30kg ký gửi + 10kg xách tay + Phòng chờ VIP', 'Suất ăn nhẹ, Ghế bọc da', 1),
      (2, 'VN-216', 2, 'SGN', 'HAN', '08:30', '10:45', 135, '2 giờ 15 phút', 'morning', 'direct', 'Boeing 787-9 Dreamliner', 1450000, 3950000, '23kg ký gửi + 12kg xách tay', '32kg ký gửi + 18kg xách tay + Bông Sen Vàng', 'Suất ăn nóng, Màn hình HD', 1),
      (3, 'QH-202', 4, 'SGN', 'HAN', '13:15', '15:25', 130, '2 giờ 10 phút', 'afternoon', 'direct', 'Airbus A320', 1190000, 3200000, '20kg ký gửi + 7kg xách tay', '30kg ký gửi + 14kg xách tay', 'Nước uống, Khăn lạnh', 0),
      (4, 'VJ-158', 1, 'SGN', 'HAN', '19:40', '21:50', 130, '2 giờ 10 phút', 'night', 'direct', 'Airbus A321neo', 799000, 2690000, '7kg xách tay tiêu chuẩn', '30kg ký gửi + 10kg xách tay', 'Báo chí, Mua suất ăn', 0),
      (5, 'VJ-362', 1, 'SGN', 'DAD', '06:30', '07:50', 80, '1 giờ 20 phút', 'morning', 'direct', 'Airbus A321neo', 690000, 2190000, '7kg xách tay', '30kg ký gửi + Xe riêng', 'Suất ăn nhẹ, Nước suối', 1),
      (6, 'VN-128', 2, 'SGN', 'DAD', '14:00', '15:20', 80, '1 giờ 20 phút', 'afternoon', 'direct', 'Airbus A350-900', 1250000, 3100000, '23kg ký gửi + 12kg xách tay', '32kg ký gửi + Phòng VIP', 'Suất ăn cao cấp', 0),
      (7, 'VJ-322', 1, 'SGN', 'PQC', '09:15', '10:20', 65, '1 giờ 05 phút', 'morning', 'direct', 'Airbus A321neo', 590000, 1890000, '7kg xách tay', '30kg ký gửi + Ưu tiên lên tàu', 'Đồ ăn vặt', 1),
      (8, 'VN-1822', 2, 'SGN', 'PQC', '16:45', '17:50', 65, '1 giờ 05 phút', 'afternoon', 'direct', 'Airbus A321', 1100000, 2750000, '23kg ký gửi', '32kg ký gửi + Lối VIP', 'Bánh ngọt, Trà sen', 0),
      (9, 'SQ-178', 3, 'SGN', 'SIN', '12:15', '15:20', 125, '2 giờ 05 phút', 'afternoon', 'direct', 'Boeing 787-10 Dreamliner', 2850000, 7890000, '30kg ký gửi + 7kg xách tay', '40kg ký gửi + Ghế phẳng 180°', 'Suất ăn 5 sao, Wifi', 1),
      (10, 'VJ-801', 1, 'SGN', 'BKK', '11:15', '12:45', 90, '1 giờ 30 phút', 'morning', 'direct', 'Airbus A321neo', 1350000, 3450000, '7kg xách tay', '30kg ký gửi + SkyBoss VIP', 'Ẩm thực Thái Lan', 1),
      (11, 'EK-393', 5, 'HAN', 'SGN', '21:00', '23:15', 135, '2 giờ 15 phút', 'night', 'direct', 'Boeing 777-300ER', 1990000, 5600000, '30kg ký gửi', '40kg ký gửi + Bộ Bvlgari', 'Hệ thống giải trí ICE', 0),
      (12, 'QR-971', 6, 'SGN', 'HAN', '17:30', '19:45', 135, '2 giờ 15 phút', 'afternoon', 'direct', 'Airbus A350-1000', 2150000, 6200000, '35kg ký gửi', 'Qsuite giường đôi riêng tư', 'Ẩm thực Trung Đông', 0);
    `);

    // 8 Tour du lịch
    this.db.run(`
      INSERT INTO tours VALUES
      (1, 'TOUR-DAD-01', 'Tour Đà Nẵng - Cầu Vàng Bà Nà Hills - Phố Cổ Hội An', 'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?w=600&h=400&fit=crop', 'Vietjet Holidays', 1, 'TP. Hồ Chí Minh', 'Đà Nẵng', 4, 3, '4N3Đ', '06:30', '1 giờ 20 phút', 'Airbus A321neo', 4590000, 'Vé máy bay khứ hồi Vietjet, Khách sạn 4 sao trung tâm, Vé cáp treo Bà Nà, Ăn buffet', 'Chi phí cá nhân, Nước uống ngoài chương trình', '[{"day":1,"title":"TP.HCM - Đà Nẵng - Sơn Trà - Ngũ Hành Sơn"},{"day":2,"title":"Bà Nà Hills - Cầu Vàng Huyền Thoại"},{"day":3,"title":"Phố Cổ Hội An - Thả Hoa Đăng Sông Hoài"},{"day":4,"title":"Chợ Hàn Đà Nẵng - Mua Sắm Bay Về"}]', 1),
      (2, 'TOUR-PQC-02', 'Tour Phú Quốc - Thành Phố Không Ngủ Grand World - Cáp Treo Hòn Thơm', 'https://images.unsplash.com/photo-1583417319070-4a69db38a482?w=600&h=400&fit=crop', 'Vietjet Holidays', 1, 'TP. Hồ Chí Minh', 'Phú Quốc', 3, 2, '3N2Đ', '09:15', '1 giờ 05 phút', 'Airbus A321neo', 3990000, 'Vé máy bay khứ hồi Vietjet, Resort 5 sao mặt biển, Vé cáp treo Hòn Thơm, Buffet hải sản', 'Chi phí các trò chơi có tính phí riêng', '[{"day":1,"title":"TP.HCM - Đảo Ngọc Phú Quốc - Sunset Sanato"},{"day":2,"title":"Cáp Treo Hòn Thơm - Grand World Không Ngủ"},{"day":3,"title":"Làng Chài Hàm Ninh - Mua Đặc Sản Bay Về"}]', 1),
      (3, 'TOUR-HAN-03', 'Tour Hành Trình Di Sản: Hà Nội - Kỳ Quan Vịnh Hạ Long - Sapa Fansipan', 'https://images.unsplash.com/photo-1528127269322-539801943592?w=600&h=400&fit=crop', 'Vietnam Airlines Tour', 2, 'TP. Hồ Chí Minh', 'Hà Nội', 5, 4, '5N4Đ', '08:30', '2 giờ 15 phút', 'Boeing 787-9 Dreamliner', 6890000, 'Vé máy bay khứ hồi Vietnam Airlines, Du thuyền 5 sao Hạ Long, Khách sạn Sapa, Cáp treo Fansipan', 'Vé tàu hỏa leo núi Mường Hoa', '[{"day":1,"title":"TP.HCM - Hà Nội 36 Phố Phường"},{"day":2,"title":"Hạ Long - Du Thuyền 5 Sao"},{"day":3,"title":"Hạ Long - Thị Trấn Sapa Trong Mây"},{"day":4,"title":"Chinh Phục Đỉnh Fansipan"},{"day":5,"title":"Chợ Sapa - Bay Về TP.HCM"}]', 1),
      (4, 'TOUR-CXR-04', 'Tour Biển Xanh Nha Trang - Thiên Đường Giải Trí VinWonders - Tắm Khoáng Nóng', 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=600&h=400&fit=crop', 'Bamboo Holidays', 4, 'Hà Nội', 'Nha Trang', 3, 2, '3N2Đ', '07:45', '1 giờ 50 phút', 'Airbus A320', 3450000, 'Vé máy bay khứ hồi Bamboo Airways, Khách sạn 4 sao sát biển, Vé VinWonders Hòn Tre, Tắm bùn khoáng', 'Chi phí lặn biển bình khí', '[{"day":1,"title":"Hà Nội - Nha Trang - Tháp Bà Ponagar"},{"day":2,"title":"VinWonders Hòn Tre Trọn Gói"},{"day":3,"title":"Du Ngoạn Vịnh Nha Trang - Bay Về"}]', 1),
      (5, 'TOUR-BKK-05', 'Tour Thái Lan: Bangkok Hiện Đại - Thành Phố Không Ngủ Pattaya - Đảo San Hô', 'https://images.unsplash.com/photo-1508009603885-50cf7c579365?w=600&h=400&fit=crop', 'Vietjet Holidays', 1, 'TP. Hồ Chí Minh', 'Bangkok', 5, 4, '5N4Đ', '11:15', '1 giờ 30 phút', 'Airbus A321neo', 5990000, 'Vé máy bay Vietjet, Khách sạn 4 sao quốc tế, Buffet Baiyoke Sky 86 tầng, Vé Alcazar Show', 'Tiền bồi dưỡng tài xế HDV (5$/ngày)', '[{"day":1,"title":"TP.HCM - Bangkok - Chợ Đêm Jodd Fairs"},{"day":2,"title":"Bangkok - Pattaya - Alcazar Show"},{"day":3,"title":"Đảo San Hô Koh Larn - Trân Bảo Phật Sơn"},{"day":4,"title":"Dạo Thuyền Sông Chao Phraya - Chùa Wat Arun"},{"day":5,"title":"Buffet 86 Tầng Baiyoke Sky - Bay Về"}]', 1),
      (6, 'TOUR-SIN-06', 'Tour Singapore Đảo Quốc Sư Tử - Thác Nước Jewel Changi - Gardens by the Bay', 'https://images.unsplash.com/photo-1525625293386-3f8f99389edd?w=600&h=400&fit=crop', 'Singapore Airlines Tour', 3, 'TP. Hồ Chí Minh', 'Singapore', 4, 3, '4N3Đ', '12:15', '2 giờ 05 phút', 'Boeing 787-10 Dreamliner', 10990000, 'Vé máy bay 5 sao Singapore Airlines, Khách sạn 4 sao Orchard Road, Vé Gardens by the Bay', 'Vé Universal Studios', '[{"day":1,"title":"TP.HCM - Sân Bay Changi - Jewel Changi"},{"day":2,"title":"Merlion Park - Marina Bay Sands"},{"day":3,"title":"Gardens by the Bay - Đảo Sentosa"},{"day":4,"title":"Haji Lane - Mua Sắm Orchard - Bay Về"}]', 1),
      (7, 'TOUR-ICN-07', 'Tour Xứ Sở Kim Chi: Thủ Đô Seoul Năng Động - Đảo Nami Lãng Mạn - Everland', 'https://images.unsplash.com/photo-1538485399081-7191377e8241?w=600&h=400&fit=crop', 'Vietjet Holidays', 1, 'Hà Nội', 'Seoul', 5, 4, '5N4Đ', '23:30', '4 giờ 15 phút', 'Airbus A330', 13990000, 'Vé máy bay Vietjet, Khách sạn 4 sao Seoul, Vé Everland, Vé Đảo Nami, Trang phục Hanbok', 'Chi phí visa du lịch Hàn Quốc', '[{"day":1,"title":"Hà Nội - Incheon Seoul (Bay Đêm)"},{"day":2,"title":"Seoul - Đảo Nami Lãng Mạn"},{"day":3,"title":"Cung Điện Gyeongbokgung - Làng Cổ Bukchon"},{"day":4,"title":"Công Viên Everland - Myeongdong"},{"day":5,"title":"Tháp N Seoul - Mua Sắm - Bay Về"}]', 1),
      (8, 'TOUR-TYO-08', 'Tour Nhật Bản Mùa Hoa: Tokyo Sầm Uất - Núi Phú Sĩ Hùng Vĩ - Tắm Khoáng Onsen', 'https://images.unsplash.com/photo-1503899036084-c55cdd92da26?w=600&h=400&fit=crop', 'Vietnam Airlines Tour', 2, 'TP. Hồ Chí Minh', 'Tokyo', 6, 5, '6N5Đ', '06:00', '5 giờ 40 phút', 'Airbus A350-900', 24990000, 'Vé máy bay Vietnam Airlines 46kg ký gửi, Khách sạn 4 sao, 01 đêm resort tắm Onsen, Bò Wagyu', 'Chi phí visa Nhật Bản', '[{"day":1,"title":"TP.HCM - Tokyo Sân Bay Haneda"},{"day":2,"title":"Núi Phú Sĩ Trạm 5 - Làng Cổ Oshino Hakkai"},{"day":3,"title":"Trải Nghiệm Tắm Onsen - Tiệc Kaiseki"},{"day":4,"title":"Chùa Asakusa Kannon - Akihabara"},{"day":5,"title":"Giao Lộ Shibuya - Mua Sắm Ginza"},{"day":6,"title":"Vịnh Odaiba - Tượng Nữ Thần Tự Do - Bay Về"}]', 1);
    `);
  }
};
