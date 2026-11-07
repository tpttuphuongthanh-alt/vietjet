-- DỮ LIỆU KHỞI TẠO MẪU - VIETJET TRAVEL

-- 1. HÃNG HÀNG KHÔNG
INSERT INTO airlines (id, code, name, logo_url, hotline, website) VALUES
(1, 'VJ', 'VietJet Air', 'images/download2.png', '1900 1886', 'https://www.vietjetair.com'),
(2, 'VN', 'Vietnam Airlines', 'assets/images/airlines/vietnam-airlines.svg', '1900 1100', 'https://www.vietnamairlines.com'),
(3, 'SQ', 'Singapore Airlines', 'assets/images/airlines/singapore-airlines.svg', '+65 6223 8888', 'https://www.singaporeair.com'),
(4, 'QH', 'Bamboo Airways', 'assets/images/airlines/bamboo-airways.svg', '1900 1166', 'https://www.bambooairways.com'),
(5, 'EK', 'Emirates', 'assets/images/airlines/emirates.svg', '1900 6006', 'https://www.emirates.com'),
(6, 'QR', 'Qatar Airways', 'assets/images/airlines/qatar-airways.svg', '1900 8899', 'https://www.qatarairways.com');

-- 2. SÂN BAY
INSERT INTO airports (code, city, name, country) VALUES
('SGN', 'TP. Hồ Chí Minh', 'Sân bay Quốc tế Tân Sơn Nhất', 'Việt Nam'),
('HAN', 'Hà Nội', 'Sân bay Quốc tế Nội Bài', 'Việt Nam'),
('DAD', 'Đà Nẵng', 'Sân bay Quốc tế Đà Nẵng', 'Việt Nam'),
('CXR', 'Nha Trang', 'Sân bay Quốc tế Cam Ranh', 'Việt Nam'),
('PQC', 'Phú Quốc', 'Sân bay Quốc tế Phú Quốc', 'Việt Nam'),
('SIN', 'Singapore', 'Sân bay Quốc tế Changi', 'Singapore'),
('BKK', 'Bangkok', 'Sân bay Quốc tế Suvarnabhumi', 'Thái Lan'),
('HND', 'Tokyo', 'Sân bay Quốc tế Haneda', 'Nhật Bản');

-- 3. CHUYẾN BAY MẪU
INSERT INTO flights (id, flight_number, airline_id, origin_code, destination_code, departure_time, arrival_time, duration_minutes, time_slot, flight_type, aircraft_type, price_economy, price_business, baggage_info, services_info, featured) VALUES
(1, 'VJ-124', 1, 'SGN', 'HAN', '05:45', '07:55', 130, 'early_morning', 'direct', 'Airbus A321neo', 899000, 2890000, 'Xách tay 7kg', 'Suất ăn nhẹ, Báo chí', 1),
(2, 'VN-216', 2, 'SGN', 'HAN', '08:30', '10:45', 135, 'morning', 'direct', 'Boeing 787-9 Dreamliner', 1450000, 3950000, 'Ký gửi 23kg + Xách tay 12kg', 'Suất ăn nóng, Màn hình giải trí cá nhân', 1),
(3, 'QH-202', 4, 'SGN', 'HAN', '13:15', '15:25', 130, 'afternoon', 'direct', 'Airbus A320', 1190000, 3200000, 'Ký gửi 20kg + Xách tay 7kg', 'Nước uống, Khăn lạnh', 0),
(4, 'VJ-158', 1, 'SGN', 'HAN', '19:40', '21:50', 130, 'night', 'direct', 'Airbus A321neo', 799000, 2690000, 'Xách tay 7kg', 'Mua trước suất ăn ưu đãi', 0),
(5, 'VJ-362', 1, 'SGN', 'DAD', '06:30', '07:50', 80, 'morning', 'direct', 'Airbus A321neo', 690000, 2190000, 'Xách tay 7kg', 'Suất ăn nhẹ', 1),
(6, 'VN-128', 2, 'SGN', 'DAD', '14:00', '15:20', 80, 'afternoon', 'direct', 'Airbus A350-900', 1250000, 3100000, 'Ký gửi 23kg + Xách tay 12kg', 'Suất ăn nhẹ, Phòng chờ VIP', 0),
(7, 'VJ-322', 1, 'SGN', 'PQC', '09:15', '10:20', 65, 'morning', 'direct', 'Airbus A321neo', 590000, 1890000, 'Xách tay 7kg', 'Nước suối', 1),
(8, 'VN-1822', 2, 'SGN', 'PQC', '16:45', '17:50', 65, 'afternoon', 'direct', 'Airbus A321', 1100000, 2750000, 'Ký gửi 23kg', 'Suất ăn nhẹ', 0),
(9, 'SQ-178', 3, 'SGN', 'SIN', '12:15', '15:20', 125, 'afternoon', 'direct', 'Boeing 787-10', 2850000, 7890000, 'Ký gửi 30kg + Xách tay 7kg', 'Suất ăn 5 sao, Wifi vệ tinh', 1),
(10, 'VJ-801', 1, 'SGN', 'BKK', '11:15', '12:45', 90, 'morning', 'direct', 'Airbus A321neo', 1350000, 3450000, 'Xách tay 7kg', 'Suất ăn ẩm thực Thái', 1),
(11, 'EK-393', 5, 'HAN', 'SGN', '21:00', '23:15', 135, 'night', 'direct', 'Boeing 777-300ER', 1990000, 5600000, 'Ký gửi 30kg', 'Suất ăn quốc tế, Màn hình HD', 0),
(12, 'QR-971', 6, 'SGN', 'HAN', '17:30', '19:45', 135, 'afternoon', 'direct', 'Airbus A350-1000', 2150000, 6200000, 'Ký gửi 35kg', 'Qsuite đẳng cấp thế giới', 0);

-- 4. 8 TOUR DU LỊCH NỔI BẬT (ẢNH 600x400)
INSERT INTO tours (id, code, title, thumbnail_url, agency_name, airline_id, origin_city, destination_city, duration_days, duration_nights, departure_time, flight_duration, aircraft_type, price, included_services, itinerary_json, featured) VALUES
(1, 'TOUR-DAD-01', 'Tour Đà Nẵng - Cầu Vàng Bà Nà Hills - Phố Cổ Hội An', 'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?w=600&h=400&fit=crop', 'Vietjet Holidays', 1, 'TP. Hồ Chí Minh', 'Đà Nẵng', 4, 3, '06:30', '1 giờ 20 phút', 'Airbus A321neo', 4590000, 'Vé máy bay khứ hồi, Khách sạn 4 sao, Vé cáp treo Bà Nà, Ăn uống trọn gói', '[{"day":1,"title":"TP.HCM - Đà Nẵng - Ngũ Hành Sơn"},{"day":2,"title":"Khám phá Cầu Vàng - Tiên Cảnh Bà Nà Hills"},{"day":3,"title":"Phố Cổ Hội An - Thuyền hoa đăng Sông Hoài"},{"day":4,"title":"Bán đảo Sơn Trà - Chợ Hàn - Mua sắm bay về TP.HCM"}]', 1),

(2, 'TOUR-PQC-02', 'Tour Phú Quốc - Thành Phố Không Ngủ Grand World - Cáp Treo Hòn Thơm', 'https://images.unsplash.com/photo-1583417319070-4a69db38a482?w=600&h=400&fit=crop', 'Vietjet Holidays', 1, 'TP. Hồ Chí Minh', 'Phú Quốc', 3, 2, '09:15', '1 giờ 05 phút', 'Airbus A321neo', 3990000, 'Vé máy bay khứ hồi, Resort 5 sao mặt biển, Vé VinWonders & Safari, Ăn hải sản', '[{"day":1,"title":"TP.HCM - Đảo Ngọc Phú Quốc - Sunset Sanato ngắm hoàng hôn"},{"day":2,"title":"Cáp treo vượt biển Hòn Thơm - Grand World rực rỡ"},{"day":3,"title":"Chợ Đêm Dương Đông - Mua đặc sản tiêu ngọc - Bay về"}]', 1),

(3, 'TOUR-HAN-03', 'Tour Hành Trình Di Sản: Hà Nội - Kỳ Quan Vịnh Hạ Long - Sapa Fansipan', 'https://images.unsplash.com/photo-1528127269322-539801943592?w=600&h=400&fit=crop', 'Vietnam Airlines Tour', 2, 'TP. Hồ Chí Minh', 'Hà Nội', 5, 4, '08:30', '2 giờ 15 phút', 'Boeing 787-9 Dreamliner', 6890000, 'Vé máy bay khứ hồi, Du thuyền 5 sao Hạ Long, Khách sạn trung tâm Sapa, Cáp treo Fansipan', '[{"day":1,"title":"TP.HCM - Thủ đô Hà Nội nghìn năm văn hiến - Hồ Gươm 36 phố phường"},{"day":2,"title":"Hà Nội - Du ngoạn Vịnh Hạ Long di sản thiên nhiên thế giới"},{"day":3,"title":"Hạ Long - Cao tốc đến Thị trấn Sapa mờ sương"},{"day":4,"title":"Chinh phục Nóc nhà Đông Dương Fansipan - Bản Cát Cát"},{"day":5,"title":"Sapa - Hà Nội - Bay về lại TP.HCM"}]', 1),

(4, 'TOUR-CXR-04', 'Tour Biển Xanh Nha Trang - Thiên Đường Giải Trí VinWonders - Du Thuyền 5 Sao', 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=600&h=400&fit=crop', 'Bamboo Holidays', 4, 'Hà Nội', 'Nha Trang', 3, 2, '07:45', '1 giờ 50 phút', 'Airbus A320', 3450000, 'Vé máy bay khứ hồi, Khách sạn 4 sao sát biển, Vé trọn gói VinWonders đảo Hòn Tre', '[{"day":1,"title":"Hà Nội - Nha Trang - Tháp Bà Ponagar - Tắm bùn khoáng nóng"},{"day":2,"title":"Oanh tạc Công viên giải trí VinWonders trên đảo Hòn Tre"},{"day":3,"title":"Du thuyền ngắm vịnh Nha Trang - Bay về Hà Nội"}]', 1),

(5, 'TOUR-BKK-05', 'Tour Thái Lan: Bangkok Hiện Đại - Thành Phố Không Ngủ Pattaya - Đảo San Hô', 'https://images.unsplash.com/photo-1508009603885-50cf7c579365?w=600&h=400&fit=crop', 'Vietjet Holidays', 1, 'TP. Hồ Chí Minh', 'Bangkok', 5, 4, '11:15', '1 giờ 30 phút', 'Airbus A321neo', 5990000, 'Vé máy bay Vietjet, Khách sạn 4 sao quốc tế, Buffet Baiyoke Sky 86 tầng, Vé Alcazar Show', '[{"day":1,"title":"TP.HCM - Sân bay Bangkok - Khám phá Chợ đêm Jodd Fairs"},{"day":2,"title":"Bangkok - Thành phố biển Pattaya - Show diễn hoành tráng"},{"day":3,"title":"Đảo San Hô Coral Koh Larn - Trân Bảo Phật Sơn Khao Chee Chan"},{"day":4,"title":"Dạo thuyền sông Chao Phraya huyền thoại - Chùa Wat Arun"},{"day":5,"title":"Mua sắm thỏa thích tại Siam Paragon / Central World - Bay về"}]', 1),

(6, 'TOUR-SIN-06', 'Tour Singapore Đảo Quốc Sư Tử - Thác Nước Jewel Changi - Gardens by the Bay', 'https://images.unsplash.com/photo-1525625293386-3f8f99389edd?w=600&h=400&fit=crop', 'Singapore Tour Co.', 3, 'TP. Hồ Chí Minh', 'Singapore', 4, 3, '12:15', '2 giờ 05 phút', 'Boeing 787-10', 10990000, 'Vé máy bay 5 sao Singapore Airlines, Khách sạn 4 sao, Vé siêu cây Gardens by the Bay', '[{"day":1,"title":"TP.HCM - Sân bay Changi - Check-in thác nước Vortex trong nhà khổng lồ"},{"day":2,"title":"Công viên Sư tử biển Merlion Park - Đảo Sentosa - Universal Studios"},{"day":3,"title":"Khu vườn năng lượng Gardens by the Bay - Marina Bay Sands"},{"day":4,"title":"Khu phố đa văn hóa Chinatown & Little India - Bay về"}]', 1),

(7, 'TOUR-ICN-07', 'Tour Xứ Sở Kim Chi: Seoul Năng Động - Đảo Nami Lãng Mạn - Công Viên Everland', 'https://images.unsplash.com/photo-1538485399081-7191377e8241?w=600&h=400&fit=crop', 'Vietjet Holidays', 1, 'Hà Nội', 'Seoul', 5, 4, '23:30', '4 giờ 15 phút', 'Airbus A330', 13990000, 'Vé máy bay khứ hồi Vietjet, Khách sạn 4 sao Seoul, Vé Everland, Trải nghiệm mặc Hanbok', '[{"day":1,"title":"Hà Nội - Seoul (Bay đêm ngắm bầu trời đầy sao)"},{"day":2,"title":"Thủ đô Seoul - Đảo Nami bối cảnh phim Bản tình ca mùa đông"},{"day":3,"title":"Cung điện Gyeongbokgung - Làng cổ Bukchon Hanok rực rỡ"},{"day":4,"title":"Oanh tạc Đại công viên giải trí Everland - Phố mua sắm Myeongdong"},{"day":5,"title":"Tháp N Seoul ngắm toàn cảnh - Bay về Hà Nội"}]', 1),

(8, 'TOUR-TYO-08', 'Tour Nhật Bản Mùa Lễ Hội: Tokyo Sầm Uất - Núi Phú Sĩ Hùng Vĩ - Chùa Asakusa', 'https://images.unsplash.com/photo-1503899036084-c55cdd92da26?w=600&h=400&fit=crop', 'Vietnam Airlines Tour', 2, 'TP. Hồ Chí Minh', 'Tokyo', 6, 5, '06:00', '5 giờ 40 phút', 'Airbus A350-900', 24990000, 'Vé máy bay khứ hồi Vietnam Airlines, Khách sạn 4 sao, Tắm suối khoáng nóng Onsen', '[{"day":1,"title":"TP.HCM - Tokyo Sân bay Haneda - Nhận phòng nghỉ ngơi"},{"day":2,"title":"Khám phá Núi Phú Sĩ Trạm số 5 - Làng cổ Oshino Hakkai thanh bình"},{"day":3,"title":"Trải nghiệm Tắm khoáng nóng Onsen truyền thống Nhật Bản"},{"day":4,"title":"Chùa cổ Asakusa Kannon - Phố điện tử Akihabara - Giao lộ Shibuya"},{"day":5,"title":"Vịnh Odaiba ngắm tượng Nữ thần Tự do - Mua sắm Ginza"},{"day":6,"title":"Tokyo - Bay về lại TP. Hồ Chí Minh"}]', 1);
