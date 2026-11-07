# Vietjet Travel & Flight Booking - Project Overview

## 1. Tổng quan dự án

Dự án **Vietjet Travel** là một ứng dụng web lĩnh vực du lịch và đặt vé máy bay hiện đại, được xây dựng hoàn toàn bằng công nghệ frontend thuần:

* **Tên website:** Vietjet Travel
* **Công nghệ cốt lõi:** HTML5, CSS3, JavaScript (Vanilla ES6+)
* **Kiến trúc:** 100% Client-side (Không sử dụng Node.js, PHP, Python, Java hay bất kỳ backend server nào)
* **Cơ sở dữ liệu:** SQLite (vận hành trực tiếp trên trình duyệt thông qua WebAssembly `sql.js`, đồng bộ và lưu trữ trạng thái vào LocalStorage/IndexedDB)
* **Phong cách giao diện:** Hiện đại, tông sáng, nền trắng (`#ffffff`), màu sắc nhận diện thương hiệu chủ đạo là màu đỏ Vietjet (`#ee1d23`) kết hợp sắc vàng năng động (`#ffd100`)

---

## 2. Mục tiêu dự án

* Xây dựng giao diện đặt vé máy bay và tour du lịch chuyên nghiệp, tốc độ tải tức thì, thân thiện với người dùng.
* Cung cấp trải nghiệm người dùng (UX) mượt mà tương tự như các nền tảng OTA (Online Travel Agency) hàng đầu như Vietjet Air, Traveloka, Agoda.
* Khai thác sức mạnh của SQLite WebAssembly chạy độc lập trong trình duyệt để truy vấn, lọc dữ liệu chuyến bay, tour du lịch và lưu trữ đơn hàng bền vững.
* Hoàn thiện quy trình từ tìm kiếm -> lọc chuyến bay/tour -> xem chi tiết -> chọn hạng vé -> thêm vào giỏ hàng -> nhập thông tin khách hàng -> xác nhận đặt chỗ và gửi email xác nhận tự động từ `nvhai061993@gmail.com`.
* Cung cấp bộ tài liệu đặc tả chuẩn hóa (.MD) để Antigravity AI thực hiện lập trình trực tiếp (Vibe Coding).

---

## 3. Đối tượng người dùng

* **Khách du lịch cá nhân & gia đình:** Tìm kiếm các chuyến bay giá rẻ, so sánh giá giữa các hãng bay, lựa chọn khung giờ bay phù hợp.
* **Người đi công tác:** Đặt vé bay thẳng nhanh chóng, chọn hạng vé Thương Gia (Business/SkyBoss) với dịch vụ phòng chờ và hành lý ưu tiên.
* **Khách đặt tour trọn gói:** Xem lịch trình chi tiết tour, số ngày/đêm, hãng hàng không vận chuyển và đặt tour nhanh gọn.

---

## 4. Phạm vi dự án (Scope)

### 4.1. Các trang và tính năng chính (In-Scope)

1. **Trang Chủ (`index.html`):**
   * Header thanh điều hướng, hotline hỗ trợ, giỏ hàng đếm số lượng.
   * Thanh tìm kiếm chuyến bay chuyên nghiệp: Vé khứ hồi, vé một chiều, điểm xuất phát, điểm đến, ngày bay, ngày về, số khách -> Click "Tìm Kiếm" dẫn sang trang Chuyến Bay (`flights.html`).
   * Mục Tour du lịch nổi bật: Hiển thị 8 tour tiêu biểu với ảnh thumbnail tỷ lệ chuẩn 600x400, tên tour, hãng lữ hành, thời gian (ngày/đêm), mức giá -> Click card dẫn sang trang Chi tiết Tour (`tour-detail.html`).
   * Mục Hãng hàng không đối tác: Logo các hãng hàng không lớn (VietJet Air, Vietnam Airlines, Singapore Airlines, Bamboo Airways, Emirates, v.v.) -> Click logo tự động chuyển sang trang Chuyến Bay và lọc theo hãng được chọn.
   * Footer đầy đủ thông tin liên hệ, chính sách bảo mật, liên kết nhanh.

2. **Trang Chuyến Bay (`flights.html`):**
   * Cột bên trái (Filter Sidebar): Lọc theo giá vé tăng/giảm dần, vé khứ hồi / một chiều / bay thẳng / nhiều thành phố, chọn hãng hàng không, lọc theo khung giờ cất cánh, lọc theo hạng dịch vụ (phổ thông, thương gia).
   * Cột bên phải (Flight Listing): Hiển thị danh sách các chuyến bay trực quan (logo hãng, giờ bay, thời lượng, điểm đi/đến, giá vé từ, dịch vụ đi kèm). Click chọn chuyến bay -> chuyển đến trang Chi tiết Chuyến Bay (`flight-detail.html`).

3. **Trang Chi Tiết Chuyến Bay (`flight-detail.html`):**
   * Thông tin chi tiết hành trình: Điểm đi, điểm đến, thời gian bay, hãng bay vận hành, loại tàu bay (Airbus A321neo, Boeing 787-9 Dreamliner...).
   * Khối lựa chọn hạng vé trực quan:
     * **Hạng Phổ Thông (Eco/Deluxe):** Giá vé tiết kiệm, hành lý xách tay 7kg, điều kiện thay đổi vé.
     * **Hạng Thương Gia (SkyBoss/Business):** Ghế da cao cấp ngả phẳng, ưu tiên check-in, phòng chờ VIP, suất ăn nóng, hành lý ký gửi 30kg.
   * Nút "Chọn vé & Thêm vào Giỏ Hàng": Cập nhật giỏ hàng tức thời với thông báo thành công.

4. **Trang Danh Sách Tour (`tours.html`):**
   * Cột bên trái (Tour Filter): Lọc theo giá tour tăng/giảm dần, hãng hàng không bay cùng tour, khung giờ khởi hành, điểm đến trong nước/quốc tế.
   * Cột bên phải: Danh sách các tour du lịch đa dạng, hình ảnh thumbnail 600x400 sắc nét, hãng bay liên kết, ngày cất cánh, thời gian bay, giá trọn gói, danh sách dịch vụ đi kèm.
   * Click chọn tour -> dẫn đến trang Chi tiết Tour (`tour-detail.html`).

5. **Trang Chi Tiết Tour (`tour-detail.html`):**
   * Thông tin tổng quan tour: Tên tour, điểm đi, điểm đến, thời gian bay, hãng hàng không, loại máy bay vận chuyển.
   * Lịch trình chuyến đi chi tiết theo từng ngày (Day-by-day Itinerary).
   * Bảng dịch vụ bao gồm & không bao gồm.
   * Nút "Đặt Tour / Thêm vào Giỏ Hàng".

6. **Trang Giỏ Hàng & Đặt Chỗ (`cart.html`):**
   * Danh sách hiển thị các chuyến bay và tour đã chọn.
   * Tính năng xóa từng mục hoặc xóa toàn bộ giỏ hàng, tự động cập nhật tổng tiền.
   * Form nhập thông tin khách hàng: Họ và tên, Số điện thoại, Email, Số CMND/CCCD/Hộ chiếu, Ghi chú.
   * Nút "Xác nhận Đăng Ký / Đặt Vé": Lưu đơn hàng vào database SQLite (bảng `orders` và `order_items`), hiển thị modal thông báo hoàn thành đơn hàng.
   * Gửi email xác nhận đặt chỗ từ `nvhai061993@gmail.com` đến địa chỉ email của khách hàng (kèm mã đặt chỗ, chi tiết chuyến bay/tour và tổng tiền).

### 4.2. Ngoài phạm vi (Out-of-Scope)

* Không dựng backend server độc lập (Node/Express, Django, Laravel, Spring Boot...).
* Không tích hợp cổng thanh toán trực tiếp của ngân hàng (VNPAY, OnePay thực tế) - quy trình thanh toán được giả lập hoàn thành thông qua form đăng ký nhận email xác nhận.
* Không có phân quyền người dùng phức tạp (Admin/User login).

---

## 5. Danh mục công nghệ chi tiết

```text
Frontend Core:
  - HTML5 (Semantic Elements: header, main, nav, section, article, aside, footer)
  - CSS3 (Flexbox, CSS Grid, Custom Properties/CSS Variables, Responsive Media Queries)
  - JavaScript (Vanilla ES6+: Async/Await, Fetch API, DOM Manipulation, Modules)

Database & Client Storage:
  - SQLite 3 (Chạy trong trình duyệt qua WebAssembly sql.js CDN)
  - LocalStorage / IndexedDB (Lưu trữ và phục hồi database binary, duy trì giỏ hàng khi reload)

Icons & Fonts:
  - Google Fonts (Be Vietnam Pro / Inter - hiển thị tiếng Việt mượt mà)
  - FontAwesome 6 / SVG Icons (Hệ thống icon máy bay, lịch, hành lý, vị trí...)

Email Confirmation:
  - Client-side Email Integration (EmailJS CDN hoặc Trình gửi mô phỏng chuẩn xác từ nvhai061993@gmail.com)
```

---

## 6. Nguyên tắc phát triển (Vibe Coding Principles)

1. **Giao diện sáng sủa & Chuẩn thương hiệu:** Tuân thủ chặt chẽ tông màu sáng, nền trắng, màu chủ đạo đỏ `#ee1d23`.
2. **Module hóa rõ ràng:** Tách bạch mã nguồn thành các file HTML độc lập cho từng trang, CSS theo component, JavaScript xử lý chuyên biệt cho từng trang hoặc dùng chung qua `js/common.js` và `js/db.js`.
3. **Thao tác dữ liệu qua SQLite:** Mọi thông tin chuyến bay, tour, hãng hàng không và đơn hàng đều được truy vấn/ghi thông qua các câu lệnh SQL (`SELECT`, `INSERT`) chuẩn mực của SQLite.
4. **Không phụ thuộc thư viện nặng:** Không dùng React, Vue, jQuery, Tailwind CLI hay các bundler cồng kềnh. Mở file HTML là chạy ngay lập tức.
5. **Thân thiện thiết bị:** Giao diện co giãn tự nhiên (Responsive) từ màn hình điện thoại di động (375px+), máy tính bảng (768px+) cho đến màn hình máy tính (1200px+).
