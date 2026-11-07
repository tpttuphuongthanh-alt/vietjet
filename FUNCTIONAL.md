# Vietjet Travel & Flight Booking - Functional Specification

## 1. Kiến trúc luồng chức năng (User Flow)

```text
[Trang Chủ - index.html]
    ├── Tìm chuyến bay (Khứ hồi / Một chiều, Điểm đi, Điểm đến, Ngày) ──> [Trang Chuyến Bay - flights.html]
    ├── Click chọn 1 trong 8 Tour du lịch nổi bật ───────────────────────> [Chi Tiết Tour - tour-detail.html]
    └── Click logo Hãng Hàng Không ─────────────────────────────────────> [Trang Chuyến Bay - lọc theo hãng]

[Trang Chuyến Bay - flights.html]
    ├── Bộ lọc bên trái (Giá tăng/giảm, Loại vé, Hãng, Khung giờ, Hạng vé)
    └── Danh sách chuyến bay bên phải ── Click "Chọn Chuyến Bay" ───────> [Chi Tiết Chuyến Bay - flight-detail.html]

[Chi Tiết Chuyến Bay - flight-detail.html]
    ├── Xem điểm đi, đến, thời gian bay, loại tàu bay (Airbus / Boeing)
    ├── Chọn Hạng Vé (Hạng Phổ Thông vs Hạng Thương Gia)
    └── Click "Thêm vào Giỏ Hàng" ──────────────────────────────────────> Cập nhật Giỏ Hàng & Header Badge

[Trang Tour - tours.html]
    ├── Bộ lọc bên trái (Giá tăng/giảm, Hãng hàng không, Khung giờ bay)
    └── Danh sách tour bên phải ─────── Click "Xem Chi Tiết Tour" ──────> [Chi Tiết Tour - tour-detail.html]

[Chi Tiết Tour - tour-detail.html]
    ├── Điểm đi, điểm đến, thời gian bay, hãng bay, loại máy bay
    ├── Xem Lịch trình chi tiết từng ngày (Itinerary)
    └── Click "Đặt Tour / Thêm vào Giỏ Hàng" ───────────────────────────> Cập nhật Giỏ Hàng & Header Badge

[Trang Giỏ Hàng - cart.html]
    ├── Xem danh sách vé & tour đã chọn (Cho phép Xóa từng mục hoặc Xóa hết)
    ├── Nhập thông tin cá nhân khách hàng (Họ tên, SĐT, Email, CCCD)
    └── Click "Đăng ký & Đặt vé" ──> Ghi vào SQLite (orders & order_items)
                                  ──> Gửi email từ nvhai061993@gmail.com đến khách
                                  ──> Hiển thị Popup Đặt vé thành công & Mã đặt chỗ
```

---

## 2. Đặc tả chi tiết từng trang

### 2.1. Trang Chủ (`index.html`)

#### A. Module Tìm Kiếm Chuyến Bay
* **Loại chuyến đi:**
  * Chuyển đổi giữa 3 tùy chọn: `Khứ hồi` (Round-trip), `Một chiều` (One-way), `Nhiều thành phố`.
  * Khi chọn `Một chiều`: Input chọn `Ngày về` tự động disabled, mờ đi và xóa giá trị.
  * Khi chọn `Khứ hồi`: Bật lại input `Ngày về`, bắt buộc `Ngày về >= Ngày đi`.
* **Điểm xuất phát & Điểm đến:**
  * Dropdown lấy từ bảng `airports` trong SQLite (SGN, HAN, DAD, CXR, PQC, SIN, BKK...).
  * Kiểm tra tự động: Không cho phép chọn Điểm đến trùng với Điểm xuất phát (hiển thị thông báo nhắc nhở nhẹ).
* **Ngày bay:**
  * Date picker giới hạn ngày nhỏ nhất là ngày hiện tại (`min = today`).
* **Hành khách:**
  * Hộp chọn nhanh số lượng người lớn (mặc định 1), trẻ em (mặc định 0).
* **Nút "Tìm Kiếm":**
  * Gom toàn bộ dữ liệu tìm kiếm thành URL Parameters hoặc lưu vào `sessionStorage`:
    `flights.html?origin=SGN&dest=HAN&trip=roundtrip&depDate=2026-11-15&retDate=2026-11-20&adults=1`
  * Chuyển hướng người dùng sang trang `flights.html`.

#### B. Module 8 Tour Du Lịch Nổi Bật
* **Truy vấn dữ liệu:**
  * Chạy câu lệnh SQL: `SELECT * FROM tours WHERE featured = 1 LIMIT 8`.
* **Hiển thị Card Tour chuẩn chỉnh:**
  * Ảnh đại diện kích thước tỷ lệ vàng **600x400** pixel.
  * Badge thời lượng (ví dụ: `4N3Đ`).
  * Tên hãng du lịch phụ trách (Vietjet Holidays, v.v.).
  * Tên tour ngắn gọn, súc tích.
  * Mức giá tour định dạng VND: `4.590.000 ₫`.
* **Sự kiện Click:**
  * Click vào bất kỳ vùng nào trên thẻ tour sẽ mở trang `tour-detail.html?id={tour.id}`.

#### C. Module Đối Tác Hàng Không
* **Dữ liệu:**
  * Lấy từ bảng `airlines`: VietJet Air, Vietnam Airlines, Singapore Airlines, Bamboo Airways, Emirates, Qatar Airways...
* **Sự kiện Click:**
  * Click vào logo hãng hàng không (ví dụ click vào logo Vietnam Airlines) sẽ điều hướng trực tiếp đến:
    `flights.html?airline=Vietnam%20Airlines`
  * Trang `flights.html` tự động tick chọn hãng đó trong bộ lọc bên trái và hiển thị danh sách các chuyến bay tương ứng.

---

### 2.2. Trang Chuyến Bay (`flights.html`)

#### A. Cột bên trái: Bộ Lọc Nâng Cao (Filter Sidebar)
1. **Sắp xếp theo giá:**
   * `Giá vé tăng dần`: Sắp xếp các chuyến bay từ thấp nhất đến cao nhất.
   * `Giá vé giảm dần`: Sắp xếp từ giá vé cao nhất xuống thấp nhất.
2. **Loại vé & Loại chuyến bay:**
   * Vé khứ hồi
   * Vé một chiều
   * Bay thẳng (Direct flight: `flight_type = 'direct'`)
   * Nhiều thành phố
3. **Các hãng hàng không:**
   * Danh sách checkbox động: `[ ] VietJet Air`, `[ ] Vietnam Airlines`, `[ ] Singapore Airlines`, `[ ] Bamboo Airways`...
   * Cho phép chọn cùng lúc nhiều hãng (Multi-select) hoặc lọc theo hãng truyền từ Trang Chủ.
4. **Thời gian cất cánh (Khung giờ):**
   * Sáng sớm (00:00 - 06:00)
   * Buổi sáng (06:00 - 12:00)
   * Buổi chiều (12:00 - 18:00)
   * Buổi tối (18:00 - 24:00)
5. **Hạng dịch vụ:**
   * `Hạng Phổ Thông`: Lọc và hiển thị mức giá `price_economy`.
   * `Hạng Thương Gia`: Lọc và hiển thị mức giá `price_business`.
6. **Nút "Đặt lại bộ lọc":** Xóa toàn bộ điều kiện lọc và tải lại danh sách đầy đủ.

#### B. Cột bên phải: Danh Sách Chuyến Bay
* Hiển thị số lượng chuyến bay tìm được theo bộ lọc thời gian thực (Reactive Filtering).
* Mỗi thẻ chuyến bay hiển thị:
  * Logo hãng bay + Tên hãng + Mã số hiệu chuyến bay (VD: `VJ-124`).
  * Giờ cất cánh (VD: `07:15`) -> Điểm đi (VD: `SGN`).
  * Thời gian bay (VD: `2h 10m`) + Nhãn "Bay thẳng".
  * Giờ hạ cánh (VD: `09:25`) -> Điểm đến (VD: `HAN`).
  * Dịch vụ: Hành lý xách tay 7kg, Suất ăn tiêu chuẩn, Máy bay A321neo.
  * Mức giá: Hiển thị giá từ `899.000 ₫`.
  * Nút "Chọn Chuyến Bay": Click chuyển hướng đến `flight-detail.html?id={flight.id}`.

---

### 2.3. Trang Chi Tiết Chuyến Bay (`flight-detail.html`)

#### A. Tiếp nhận và hiển thị thông tin
* Đọc tham số `id` trên URL (`window.location.search`).
* Chạy truy vấn SQL: `SELECT f.*, a.name AS airline_name, a.logo_url FROM flights f JOIN airlines a ON f.airline_id = a.id WHERE f.id = ?`.
* Hiển thị nổi bật:
  * Hành trình: Điểm đi -> Điểm đến.
  * Thời gian bay, Ngày bay, Giờ cất cánh, Giờ hạ cánh.
  * Tên hãng hàng không vận hành & Mã chuyến bay.
  * **Loại máy bay:** Hiển thị rõ ràng (ví dụ: `Boeing 787-9 Dreamliner` hoặc `Airbus A321neo`).

#### B. Khối Lựa Chọn Hạng Vé (Ticket Class Selection)
* Trình bày 2 thẻ so sánh rõ ràng:
  * **Hạng Phổ Thông (Economy / Eco):**
    * Giá hiển thị lấy từ trường `price_economy`.
    * Bao gồm: 7kg hành lý xách tay.
    * Đổi ngày bay mất phí + chênh lệch giá vé.
    * Nút chọn: "Chọn Hạng Phổ Thông".
  * **Hạng Thương Gia (Business / SkyBoss):**
    * Giá hiển thị lấy từ trường `price_business`.
    * Bao gồm: 30kg hành lý ký gửi + 10kg hành lý xách tay.
    * Ghế ngồi rộng rãi bọc da cao cấp / Giường nằm tiện nghi.
    * Quyền ưu tiên: Quầy làm thủ tục riêng, lối qua an ninh ưu tiên, xe bus đưa đón VIP.
    * Sử dụng Phòng Chờ Thương Gia sang trọng.
    * Phục vụ suất ăn nóng tươi ngon kèm rượu vang/nước uống cao cấp.
    * Miễn phí đổi ngày, giờ bay.
    * Nút chọn: "Chọn Hạng Thương Gia".

#### C. Thêm vào Giỏ Hàng
* Khi người dùng bấm nút "Chọn Vé & Thêm Vào Giỏ Hàng":
  * Lưu vào cấu trúc Cart (LocalStorage): ID chuyến bay, Hạng vé đã chọn (Economy hoặc Business), Đơn giá tương ứng, Ngày bay, Số lượng (mặc định 1).
  * Hiển thị thông báo Toast đẹp mắt: "Đã thêm chuyến bay vào giỏ hàng thành công!".
  * Cập nhật số đếm badge giỏ hàng trên thanh Header.
  * Nút dẫn trực tiếp tới trang Giỏ Hàng (`cart.html`).

---

### 2.4. Trang Danh Sách Tour (`tours.html`)

* **Cột bên trái:**
  * Bộ lọc giá tour tăng/giảm dần.
  * Lọc theo Hãng hàng không bay cùng tour (VietJet Air, Vietnam Airlines...).
  * Lọc theo khung giờ khởi hành chuyến bay đi tour.
* **Cột bên phải:**
  * Hiển thị danh sách toàn bộ tour du lịch có trong cơ sở dữ liệu SQLite.
  * Mỗi tour có ảnh đại diện 600x400, tên tour, số ngày/đêm, hãng bay, giờ cất cánh, thời gian bay, giá trọn gói và các dịch vụ bao gồm.
  * Click vào tour -> Chuyển đến `tour-detail.html?id={tour.id}`.

---

### 2.5. Trang Chi Tiết Tour (`tour-detail.html`)

* Đọc tham số `id` từ URL và truy vấn bảng `tours` trong SQLite.
* Hiển thị toàn diện:
  * Điểm đi, điểm đến.
  * Thời gian bay, hãng hàng không, loại máy bay (Boeing/Airbus).
  * **Lịch trình chuyến đi chi tiết (Itinerary):** Render danh sách từng ngày (Ngày 1, Ngày 2, Ngày 3, Ngày 4...) từ trường `itinerary_json` dạng timeline có icon và mô tả điểm tham quan, ẩm thực.
  * Dịch vụ bao gồm (Khách sạn tiêu chuẩn, xe đời mới đưa đón, vé tham quan, bảo hiểm du lịch) và Dịch vụ không bao gồm.
* **Nút "Đặt Tour / Thêm vào Giỏ Hàng":**
  * Đẩy thông tin tour vào Giỏ Hàng (Loại mục: Tour, Đơn giá, Số lượng khách, Ngày khởi hành).
  * Cập nhật badge giỏ hàng và thông báo thành công.

---

### 2.6. Trang Giỏ Hàng & Hoàn Tất Đơn Hàng (`cart.html`)

#### A. Quản lý các mục trong giỏ hàng
* Đọc dữ liệu giỏ hàng từ LocalStorage.
* Render bảng chi tiết các mục đã chọn:
  * Cột 1: Thông tin sản phẩm (Tên chuyến bay / Tên tour, Hãng bay, Hạng vé).
  * Cột 2: Ngày khởi hành.
  * Cột 3: Đơn giá (VND).
  * Cột 4: Số lượng khách (Input cho phép tăng giảm số lượng, tự động tính lại thành tiền).
  * Cột 5: Thành tiền.
  * Cột 6: Thao tác (Nút xóa hình thùng rác).
* **Nút "Xóa Toàn Bộ Giỏ Hàng":** Dọn dẹp toàn bộ dữ liệu giỏ hàng sau khi người dùng xác nhận.
* **Khu vực tổng tiền:** Tự động tính toán tổng số tiền của toàn bộ vé và tour trong giỏ.

#### B. Form Thông Tin Cá Nhân Khách Hàng
* Gồm các trường:
  * Họ và tên khách hàng (Bắt buộc).
  * Số điện thoại (Bắt buộc, kiểm tra định dạng số điện thoại Việt Nam 10 chữ số).
  * Email khách hàng (Bắt buộc, kiểm tra định dạng email chuẩn để nhận thư xác nhận).
  * Số CMND / CCCD / Hộ chiếu (Bắt buộc theo quy định hàng không).
  * Ghi chú bổ sung (Tùy chọn).

#### C. Thao tác "Đăng Ký / Đặt Vé" & Gửi Email Xác Nhận
Khi người dùng nhấn nút **"Xác Nhận Đăng Ký & Đặt Vé"**:
1. **Kiểm tra hợp lệ (Form Validation):** Báo lỗi nếu thiếu thông tin bắt buộc hoặc giỏ hàng trống.
2. **Sinh mã đặt chỗ ngẫu nhiên:** Ví dụ `VJ-ORD-89213`.
3. **Ghi vào SQLite:**
   * Thêm 1 dòng vào bảng `orders` (mã đơn, họ tên, email khách, điện thoại, CCCD, tổng tiền, `sender_email = 'nvhai061993@gmail.com'`).
   * Thêm các dòng vào bảng `order_items` tương ứng với từng vé/tour trong giỏ.
   * Đồng bộ lưu file SQLite nhị phân vào LocalStorage.
4. **Quy trình gửi Email tự động:**
   * Email được cấu hình gửi từ: `nvhai061993@gmail.com`.
   * Gửi đến: Địa chỉ email của khách hàng vừa nhập.
   * Tiêu đề: `[Vietjet Travel] Xác nhận đặt chỗ thành công - Mã đơn: VJ-ORD-XXXX`.
   * Nội dung email:
     * Lời cảm ơn khách hàng đã tin tưởng chọn Vietjet Travel.
     * Bảng chi tiết chuyến bay / tour đã đặt (Giờ bay, điểm đi, điểm đến, hãng hàng không, loại máy bay, hạng vé).
     * Thông tin hành khách đại diện.
     * Tổng số tiền đã xác nhận.
     * Hướng dẫn thủ tục check-in tại sân bay và hotline hỗ trợ `1900 1886`.
   * Tích hợp gửi thực tế qua EmailJS client SDK (hoặc cơ chế Simulated Email Dispatcher giao diện chi tiết kèm log hiển thị thông điệp gửi thành công).
5. **Hiển thị Modal Hoàn Thành:**
   * Popup modal chúc mừng với icon tick xanh rực rỡ.
   * Thông báo rõ ràng: *"Đăng ký thành công! Đơn hàng VJ-ORD-XXXX đã được khởi tạo. Một email xác nhận chi tiết đã được gửi từ nvhai061993@gmail.com tới [email của bạn]."*
   * Xóa sạch giỏ hàng hiện tại, đưa badge về 0.
   * Nút "In Vé Điện Tử" hoặc "Quay Về Trang Chủ".
