# Vietjet Travel & Flight Booking - Implementation Guide

## 1. Vai trò & Tiêu chuẩn phát triển

* **Vai trò:** Bạn là một Senior Frontend Engineer & Web Architect chuyên sâu về Vanilla JavaScript và WebAssembly.
* **Nguyên tắc kỹ thuật:**
  * Chỉ sử dụng **HTML5, CSS3, Vanilla JavaScript (ES6+)** và **SQLite WebAssembly (`sql.js`)**.
  * **Không sử dụng bất kỳ backend server hay framework frontend nào** (Không Node.js server, Không PHP, Không Python, Không React, Không Vue).
  * Mã nguồn viết tường minh, chia nhỏ module sạch sẽ, dễ bảo trì, có chú thích tiếng Việt rõ ràng.

---

## 2. Cấu trúc thư mục dự án chuẩn hóa

```text
vietjet/
│
├── index.html                   # Trang chủ (Tìm kiếm chuyến bay, 8 tour nổi bật, logo hãng bay)
├── flights.html                 # Danh sách chuyến bay & bộ lọc bên trái
├── flight-detail.html           # Chi tiết chuyến bay & chọn hạng vé (Phổ thông / Thương gia)
├── tours.html                   # Danh sách tour du lịch & bộ lọc
├── tour-detail.html             # Chi tiết tour & lịch trình chuyến đi chi tiết
├── cart.html                    # Giỏ hàng, form thông tin khách, lưu SQLite & gửi email
│
├── css/
│   ├── style.css                # Biến màu, CSS reset, layout chung, Header, Footer, Toast
│   ├── home.css                 # Giao diện Trang chủ (Hero search widget, tour grid, airline carousel)
│   ├── flights.css              # Giao diện Trang chuyến bay & Chi tiết chuyến bay
│   ├── tours.css                # Giao diện Trang tour & Chi tiết tour (Timeline lịch trình)
│   └── cart.css                 # Giao diện Giỏ hàng, Form đặt chỗ & Modal xác nhận
│
├── js/
│   ├── db.js                    # Khởi tạo SQLite WebAssembly, nạp schema, seed data, quản lý lưu trữ
│   ├── common.js                # Xử lý giỏ hàng, cập nhật badge Header, format tiền tệ, Toast
│   ├── home.js                  # Xử lý tương tác Trang chủ (Widget tìm kiếm, click tour, click logo)
│   ├── flights.js               # Xử lý logic lọc, sắp xếp và render chuyến bay
│   ├── flight-detail.js         # Xử lý chọn hạng vé Phổ Thông/Thương Gia và thêm vào giỏ hàng
│   ├── tours.js                 # Xử lý lọc và hiển thị danh sách tour
│   ├── tour-detail.js           # Xử lý render lịch trình chi tiết và thêm tour vào giỏ hàng
│   └── cart.js                  # Xử lý giỏ hàng, validation form, ghi SQLite và gửi email xác nhận
│
├── data/
│   ├── schema.sql               # File DDL định nghĩa các bảng SQLite
│   └── seed.sql                 # File dữ liệu mẫu khởi tạo (Hãng bay, Sân bay, Chuyến bay, Tour)
│
└── assets/
    └── images/
        ├── logo/                # Logo Vietjet
        ├── airlines/            # Logo VietJet Air, Vietnam Airlines, Singapore Airlines, Bamboo...
        ├── tours/               # Hình ảnh 8 tour nổi bật kích thước chuẩn 600x400
        └── banners/             # Hình nền du lịch & máy bay cất cánh
```

---

## 3. Lộ trình phát triển theo từng Module (Step-by-Step)

### Module 1: Nền tảng Dữ liệu SQLite & Kiến trúc chung
* **Mục tiêu:** Thiết lập cơ sở dữ liệu SQLite trong trình duyệt và hệ thống Style nền tảng.
* **Các file thực hiện:** `data/schema.sql`, `data/seed.sql`, `js/db.js`, `css/style.css`, `js/common.js`.
* **Tiêu chí hoàn thành:**
  * Nạp `sql.js` thành công qua CDN.
  * Tự động tạo 6 bảng SQLite: `airlines`, `airports`, `flights`, `tours`, `orders`, `order_items`.
  * Nạp đầy đủ dữ liệu mẫu (các hãng bay, các chuyến bay nhiều khung giờ, 8 tour nổi bật).
  * Tạo hàm tiện ích truy vấn SQL `executeSql(query, params)` trả về Array of Objects.
  * Xây dựng hệ thống biến màu sắc `:root` với đỏ chủ đạo `#ee1d23`, nền trắng, font tiếng Việt và Header/Footer dùng chung.

---

### Module 2: Xây dựng Trang Chủ (`index.html`)
* **Mục tiêu:** Hoàn thiện trang chủ theo đúng yêu cầu đề bài.
* **Các file thực hiện:** `index.html`, `css/home.css`, `js/home.js`.
* **Tiêu chí hoàn thành:**
  * **Thanh tìm kiếm chuyến bay:** Chọn Khứ hồi / Một chiều (tự động toggle trường Ngày về), Điểm đi, Điểm đến (không trùng nhau), Ngày đi, Số lượng khách. Bấm "Tìm Kiếm" -> Chuyển sang `flights.html` kèm query parameters.
  * **Phần 8 Tour nổi bật:** Truy vấn từ SQLite, render card với ảnh thumbnail đúng tỷ lệ **600x400**, tên hãng lữ hành, số ngày/đêm, giá tiền format `x.xxx.xxx ₫`. Click dẫn sang trang Tour.
  * **Phần Logo Hãng Hàng Không:** Hiển thị logo các hãng (VietJet Air, Vietnam Airlines, Singapore Airlines, Bamboo Airways, Emirates...). Click vào logo -> Chuyển sang `flights.html` và kích hoạt lọc theo hãng đó.

---

### Module 3: Xây dựng Trang Chuyến Bay (`flights.html`)
* **Mục tiêu:** Xây dựng màn hình tìm kiếm và so sánh chuyến bay đa chiều.
* **Các file thực hiện:** `flights.html`, `css/flights.css`, `js/flights.js`.
* **Tiêu chí hoàn thành:**
  * **Cột trái (Sidebar Filter):**
    * Lọc giá tăng/giảm dần.
    * Lọc loại vé: khứ hồi, một chiều, bay thẳng, nhiều thành phố.
    * Lọc hãng hàng không (checkbox đa chọn).
    * Lọc khung giờ cất cánh (Sáng sớm, Sáng, Chiều, Tối).
    * Lọc hạng dịch vụ (Phổ thông, Thương gia).
    * Nút đặt lại bộ lọc.
  * **Cột phải (Flight Listing):**
    * Hiển thị card chuyến bay chuyên nghiệp: Logo hãng, số hiệu chuyến bay, giờ cất cánh/hạ cánh, thời gian bay, nhãn bay thẳng, giá tiền màu đỏ to rõ.
    * Nút "Chọn Chuyến Bay" -> Chuyển đến `flight-detail.html?id=...`.

---

### Module 4: Xây dựng Trang Chi Tiết Chuyến Bay (`flight-detail.html`)
* **Mục tiêu:** Chi tiết chuyến bay và bảng chọn hạng vé.
* **Các file thực hiện:** `flight-detail.html`, `js/flight-detail.js`.
* **Tiêu chí hoàn thành:**
  * Đọc `id` chuyến bay từ URL, truy vấn SQLite lấy thông tin chi tiết: Điểm đi, điểm đến, giờ bay, hãng bay, **loại máy bay** (Boeing 787, Airbus A321neo...).
  * **Bảng lựa chọn hạng vé:**
    * Thẻ Hạng Phổ Thông (Economy): Giá vé, hành lý xách tay 7kg, chính sách đổi vé.
    * Thẻ Hạng Thương Gia (Business): Giá vé, quầy làm thủ tục ưu tiên, phòng chờ VIP, hành lý 30kg, suất ăn nóng cao cấp.
    * Có thể chọn chuyển đổi giữa 2 hạng vé, giá tiền cập nhật tương ứng.
  * Bấm "Chọn vé & Thêm vào Giỏ Hàng": Lưu vé vào giỏ hàng, tăng số lượng badge trên Header và hiển thị Toast thông báo.

---

### Module 5: Xây dựng Trang Tour & Chi Tiết Tour (`tours.html`, `tour-detail.html`)
* **Mục tiêu:** Màn hình danh sách tour và chi tiết lịch trình tour.
* **Các file thực hiện:** `tours.html`, `tour-detail.html`, `css/tours.css`, `js/tours.js`, `js/tour-detail.js`.
* **Tiêu chí hoàn thành:**
  * **Trang Tour (`tours.html`):** Bộ lọc bên trái (giá, hãng bay, khung giờ), danh sách tour bên phải có ảnh 600x400, thông tin hãng bay, ngày cất cánh, thời gian bay, giá tiền, dịch vụ.
  * **Trang Chi Tiết Tour (`tour-detail.html`):**
    * Điểm đi, điểm đến, thời gian bay, hãng bay, loại máy bay (Boeing/Airbus).
    * **Lịch trình chuyến đi (Day-by-Day Itinerary):** Trình bày dạng timeline sinh động từ JSON lịch trình.
    * Bảng dịch vụ bao gồm và không bao gồm.
    * Nút "Đặt Tour / Thêm vào Giỏ Hàng": Lưu tour vào giỏ hàng.

---

### Module 6: Xây dựng Trang Giỏ Hàng & Xác Nhận Đặt Chỗ (`cart.html`)
* **Mục tiêu:** Quản lý giỏ hàng, thông tin khách hàng, lưu đơn vào SQLite và gửi email xác nhận.
* **Các file thực hiện:** `cart.html`, `css/cart.css`, `js/cart.js`.
* **Tiêu chí hoàn thành:**
  * Hiển thị bảng danh sách vé chuyến bay và tour đã chọn.
  * Hỗ trợ xóa từng mục hoặc xóa toàn bộ giỏ hàng, cập nhật lại tổng tiền.
  * Form thông tin khách hàng: Họ tên, Số điện thoại, Email, Số CMND/CCCD, Ghi chú (Validate đầy đủ).
  * Khi click "Xác Nhận Đăng Ký / Đặt Vé":
    * Lưu bản ghi đơn hàng vào bảng `orders` và các mục vào bảng `order_items` trong SQLite.
    * Kích hoạt quy trình gửi email từ **`nvhai061993@gmail.com`** đến email của khách hàng với đầy đủ thông tin mã đơn, chi tiết chuyến bay/tour và tổng tiền.
    * Hiển thị modal thông báo hoàn thành đơn hàng, thông báo đã gửi email xác nhận tới khách hàng.

---

## 4. Danh sách kiểm thử & tiêu chuẩn chất lượng (Test Cases)

| Mã kiểm thử | Hạng mục kiểm tra | Kết quả mong đợi |
|---|---|---|
| TC-01 | Khởi chạy không cần cài backend | Mở bằng trình duyệt (hoặc Live Server), `sql.js` nạp SQLite và chạy trơn tru |
| TC-02 | Tìm kiếm chuyến bay từ Trang chủ | Chuyển đúng sang `flights.html` với đầy đủ tham số tìm kiếm |
| TC-03 | Click 8 Tour nổi bật ở Trang chủ | Mở đúng trang chi tiết của tour đó kèm ảnh 600x400 sắc nét |
| TC-04 | Click Logo hãng bay ở Trang chủ | Sang `flights.html` và tự động lọc danh sách chỉ hiện hãng đó |
| TC-05 | Bộ lọc chuyến bay đa tiêu chí | Lọc đúng giá tăng/giảm, khung giờ cất cánh, hãng bay, hạng vé |
| TC-06 | Chọn Hạng Vé trong Chi tiết chuyến bay | Chọn Phổ Thông hoặc Thương Gia cập nhật đúng giá và thêm vào giỏ |
| TC-07 | Lịch trình tour chi tiết | Hiển thị rõ điểm đi/đến, hãng bay, loại máy bay và timeline từng ngày |
| TC-08 | Thao tác Giỏ Hàng | Xóa item, đổi số lượng khách, tính đúng tổng tiền, duy trì khi F5 |
| TC-09 | Ghi đơn vào SQLite | Bảng `orders` và `order_items` lưu trữ đầy đủ thông tin khách và đơn hàng |
| TC-10 | Email xác nhận khách hàng | Ghi nhận người gửi `nvhai061993@gmail.com`, người nhận là email của khách, hiển thị modal thông báo hoàn thành |
