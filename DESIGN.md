# Vietjet Travel & Flight Booking - Design Specification

## 1. Triết lý thiết kế (Design Philosophy)

Giao diện Vietjet Travel hướng đến phong cách **Modern Airline & Travel OTA (Online Travel Agency)**:
* **Tông sáng, nền trắng tinh khôi (`#ffffff`):** Tạo cảm giác sạch sẽ, thoáng đãng, chuyên nghiệp và đáng tin cậy.
* **Màu đỏ Vietjet đặc trưng (`#ee1d23`):** Mang lại sự năng động, nổi bật, thúc đẩy hành động (Call to Action - CTA).
* **Màu vàng ấm áp (`#ffd100`):** Điểm xuyết tinh tế tạo nên cặp màu nhận diện thương hiệu Vietjet bất hủ.
* **Bố cục khoa học:** Tách biệt rõ ràng các khu vực chức năng, thông tin giá vé, thời gian bay và các tiện ích được trình bày dễ đọc trong vòng 3 giây đầu tiên.

---

## 2. Bảng mã màu chuẩn (Color System)

Các biến CSS được định nghĩa tại `:root`:

```css
:root {
  /* Màu chủ đạo thương hiệu */
  --color-primary: #ee1d23;          /* Đỏ Vietjet rực rỡ */
  --color-primary-hover: #c91419;    /* Đỏ đậm khi hover */
  --color-primary-light: #fef2f2;    /* Nền đỏ siêu nhạt cho badge, highlight */
  --color-primary-border: #fecaca;   /* Viền đỏ nhạt */

  /* Màu phụ trợ */
  --color-secondary: #ffd100;        /* Vàng Vietjet */
  --color-secondary-hover: #e6bc00;  /* Vàng sẫm hover */
  --color-secondary-light: #fefce8;  /* Nền vàng nhạt */

  /* Nền & Thẻ */
  --color-white: #ffffff;            /* Nền trắng chủ đạo */
  --color-bg-body: #ffffff;          /* Nền trang */
  --color-bg-gray: #f8fafc;          /* Nền xám nhạt cho section so le */
  --color-card-bg: #ffffff;          /* Nền card trắng */

  /* Màu chữ & Tiêu đề */
  --color-dark: #0f172a;             /* Tiêu đề chính, đậm nét */
  --color-text: #334155;             /* Nội dung văn bản thường */
  --color-text-muted: #64748b;       /* Chữ phụ, ghi chú, icon phụ */

  /* Đường kẻ & Viền */
  --color-border: #e2e8f0;           /* Đường viền chuẩn */
  --color-border-focus: #ee1d23;     /* Viền khi focus ô input */

  /* Trạng thái */
  --color-success: #16a34a;          /* Xanh lá - Thành công */
  --color-success-bg: #dcfce7;
  --color-warning: #ea580c;          /* Cam - Lưu ý */
  --color-danger: #dc2626;           /* Đỏ báo lỗi */
  --color-badge: #eff6ff;            /* Xanh dương nhạt cho tiện ích */
  --color-badge-text: #1d4ed8;

  /* Bóng đổ (Box Shadow) */
  --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
  --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.08), 0 2px 4px -2px rgba(0, 0, 0, 0.05);
  --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.08), 0 4px 6px -4px rgba(0, 0, 0, 0.04);
  --shadow-hover: 0 12px 24px -4px rgba(238, 29, 35, 0.15);

  /* Bo góc (Border Radius) */
  --radius-sm: 6px;
  --radius-md: 10px;
  --radius-lg: 16px;
  --radius-full: 9999px;
}
```

---

## 3. Typography & Kiểu chữ

* **Font chữ chính:** `'Be Vietnam Pro', 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif`
* **Quy ước cỡ chữ & trọng số:**
  * **H1 (Hero Heading):** 36px - 44px, Weight 700, Line-height 1.2
  * **H2 (Section Heading):** 28px - 32px, Weight 700, Màu `--color-dark`, có gạch chân đỏ hoặc icon máy bay phụ họa
  * **H3 (Card Title / Subsection):** 18px - 22px, Weight 600
  * **Body text:** 15px - 16px, Weight 400, Line-height 1.6, Màu `--color-text`
  * **Small / Caption / Tag:** 12px - 13px, Weight 500, Màu `--color-text-muted`
  * **Giá tiền nổi bật:** 20px - 26px, Weight 700, Màu `--color-primary` (`#ee1d23`)

---

## 4. Hệ thống bố cục (Layout System)

* **Chiều rộng tối đa (Max Container Width):** `1240px`, căn giữa `margin: 0 auto; padding: 0 20px;`
* **Khoảng cách giữa các Section:** `60px` đến `80px`
* **Cấu trúc 2 cột cho trang Chuyến bay & Tour (2-Column OTA Layout):**
  * **Cột trái (Sidebar Filter):** Chiều rộng cố định `280px` - `300px`, dính theo cuộn trang (`position: sticky; top: 90px;`)
  * **Cột phải (Main Content):** `flex: 1` hoặc `1fr`, hiển thị danh sách dạng Card danh sách phẳng, mỗi card có đầy đủ thông tin chi tiết.

---

## 5. Đặc tả chi tiết các thành phần giao diện (UI Components)

### 5.1. Header & Navigation chung
* Chiều cao cố định: `76px`, nền trắng, bóng mờ nhẹ phía dưới (`--shadow-sm`).
* Bên trái: Logo Vietjet nổi bật (`images/download2.png` hoặc `images/download.jpg`).
* Ở giữa: Menu điều hướng:
  * Trang Chủ (`index.html`)
  * Chuyến Bay (`flights.html`)
  * Tour Du Lịch (`tours.html`)
* Bên phải:
  * Hotline hỗ trợ: `1900 1886` với icon điện thoại.
  * Nút "Giỏ Hàng" (`cart.html`) với icon chiếc túi/vali du lịch và **Badge đếm số lượng** (màu đỏ bo tròn, cập nhật thời gian thực khi thêm vé/tour).

---

### 5.2. Trang Chủ (`index.html`)

#### A. Hero Banner & Flight Search Widget
* Banner hình ảnh bầu trời, máy bay Vietjet cất cánh (`images/images.jpg`) với lớp phủ (overlay) nhẹ giúp nổi bật khung tìm kiếm.
* **Flight Search Box (Hộp tìm kiếm vé máy bay):**
  * Nằm nổi bật ở trung tâm hero, nền trắng, bo góc `--radius-lg`, đổ bóng sâu `--shadow-lg`.
  * **Tabs chọn loại hành trình:**
    * [x] Vé khứ hồi (Round-trip)
    * [ ] Vé một chiều (One-way)
    * [ ] Nhiều thành phố (Multi-city)
  * **Lưới 4 cột chọn thông tin:**
    1. *Điểm đi (Departure):* Dropdown chọn thành phố/sân bay (TP. Hồ Chí Minh - SGN, Hà Nội - HAN, Đà Nẵng - DAD, Nha Trang - CXR, Phú Quốc - PQC, Singapore - SIN, Bangkok - BKK...).
    2. *Điểm đến (Destination):* Dropdown chọn tương tự, tự động kiểm tra không trùng điểm đi.
    3. *Ngày đi & Ngày về (Date Pickers):* Ô chọn ngày xuất phát và ngày về. Nếu chọn "Vé một chiều", ô "Ngày về" sẽ bị vô hiệu hóa (disabled) và làm mờ thẩm mỹ.
    4. *Hành khách (Passengers):* Dropdown chọn số lượng người lớn, trẻ em.
  * **Nút CTA "Tìm Kiếm Chuyến Bay":** Nút to, màu đỏ `#ee1d23`, chữ trắng in đậm, icon kính lúp. Khi click sẽ điều hướng sang `flights.html` với query string lưu lựa chọn (hoặc cập nhật vào state bộ lọc).

#### B. Phần Tour Du Lịch Nổi Bật (8 Tour)
* Tiêu đề: **"Tour Du Lịch Hấp Dẫn Nhất"** kèm phụ đề giới thiệu.
* Lưới 4 cột x 2 hàng (Responsive: 1 cột mobile, 2 cột tablet, 4 cột desktop).
* **Đặc tả Card Tour:**
  * **Hình ảnh thumbnail:** Kích thước hiển thị tỷ lệ chuẩn **600x400** (aspect ratio 3:2), `object-fit: cover;`, bo góc trên `--radius-md`.
  * **Badge trên ảnh:** Thời lượng chuyến đi (ví dụ: `4N3Đ`, `5N4Đ`) nền vàng chữ đen hoặc nền đỏ chữ trắng.
  * **Hãng du lịch / tổ chức:** Hiển thị tên hãng lữ hành (Vietjet Holidays, Vietravel, Saigontourist...).
  * **Tiêu đề Tour:** Tối đa 2 dòng, chữ đậm.
  * **Thời gian cất cánh & Hãng bay:** Icon máy bay nhỏ + tên hãng bay vận chuyển.
  * **Giá Tour:** Mức giá định dạng tiếng Việt rõ ràng (ví dụ: `4.590.000 ₫ / khách`).
  * **Tương tác:** Click vào card dẫn trực tiếp đến trang `tours.html` hoặc `tour-detail.html?id=...`.

#### C. Phần Hãng Hàng Không Đối Tác (Airline Logos)
* Tiêu đề: **"Đối Tác Hàng Không Đồng Hành"**.
* Hiển thị danh sách logo các hãng hàng không uy tín:
  1. VietJet Air
  2. Vietnam Airlines
  3. Singapore Airlines
  4. Bamboo Airways
  5. Emirates
  6. Qatar Airways
  7. Thai Airways
* **Thiết kế Card Logo:** Nền trắng, viền mảnh `--color-border`, bo góc `--radius-md`, logo căn giữa, hiệu ứng hover phóng to nhẹ (`transform: translateY(-4px)`), kèm tên hãng bên dưới.
* **Tương tác:** Click vào logo bất kỳ sẽ lập tức chuyển hướng sang trang Chuyến Bay (`flights.html?airline=VietJet%20Air`) và kích hoạt bộ lọc theo hãng tương ứng.

---

### 5.3. Trang Chuyến Bay (`flights.html`)

#### A. Cột bên trái (Sidebar Filter)
* Nền trắng, bo viền mảnh, padding 20px, bo góc `--radius-md`.
* Gồm các khối lọc:
  1. **Sắp xếp theo giá:** Radio button `Giá thấp đến cao` (mặc định) và `Giá cao đến thấp`.
  2. **Loại vé:** Checkbox `Vé một chiều`, `Vé khứ hồi`, `Bay thẳng`, `Nhiều thành phố`.
  3. **Hãng hàng không:** Checkbox kèm số lượng chuyến bay tương ứng: `VietJet Air`, `Vietnam Airlines`, `Singapore Airlines`, `Bamboo Airways`, v.v.
  4. **Thời gian cất cánh:** Lọc theo 4 khung giờ trực quan:
     * Sáng sớm (00:00 - 06:00)
     * Buổi sáng (06:00 - 12:00)
     * Buổi chiều (12:00 - 18:00)
     * Buổi tối (18:00 - 24:00)
  5. **Hạng dịch vụ:** Checkbox `Hạng Phổ Thông (Economy)` và `Hạng Thương Gia (Business)`.
  6. **Nút "Đặt lại bộ lọc" (Reset Filter):** Giúp người dùng xóa toàn bộ điều kiện lọc về mặc định.

#### B. Cột bên phải (Flight Cards Listing)
* Thanh tiêu đề tóm tắt: Hành trình tìm kiếm (VD: TP. Hồ Chí Minh -> Hà Nội), Ngày bay, Số lượng chuyến bay tìm thấy.
* Mỗi Card chuyến bay gồm 4 phân vùng ngang:
  1. *Hãng bay:* Logo hãng, tên hãng, mã số hiệu chuyến bay (VD: `VJ-124`, `VN-256`).
  2. *Hành trình & Giờ bay:*
     * Giờ cất cánh -> Tên sân bay đi.
     * Đường kẻ timeline ở giữa kèm thời lượng bay (VD: `2h 10m`) và nhãn "Bay thẳng".
     * Giờ hạ cánh -> Tên sân bay đến.
  3. *Tiện ích:* Icon hành lý xách tay 7kg, suất ăn, nước uống, loại máy bay (Airbus A321 / Boeing 787).
  4. *Giá vé & Thao tác:*
     * Giá hiển thị màu đỏ to đậm (VD: `899.000 ₫ / khách`).
     * Nút "Chọn Chuyến Bay" nền đỏ viền đỏ, hover đổi nền sẫm hơn.
* **Tương tác:** Click "Chọn Chuyến Bay" -> chuyển đến trang `flight-detail.html?id=...`.

---

### 5.4. Trang Chi Tiết Chuyến Bay (`flight-detail.html`)

* **Khối thông tin hành trình chi tiết:**
  * Điểm đi - Điểm đến, Ngày cất cánh, Giờ bay cụ thể, Tổng thời lượng bay.
  * Hãng hàng không, Số hiệu chuyến bay.
  * Loại tàu bay được ghi rõ (ví dụ: `Airbus A321neo`, `Boeing 787-9 Dreamliner`).
* **Bảng so sánh và chọn Hạng Vé (Ticket Class Selection):**
  * Thiết kế dạng 2 thẻ so sánh song song cực kỳ trực quan:
    1. **Hạng Phổ Thông (Eco):**
       * Giá vé cơ bản tiết kiệm.
       * 7kg hành lý xách tay tiêu chuẩn.
       * Được mua thêm hành lý ký gửi giá ưu đãi.
       * Thay đổi ngày bay có tính phí chênh lệch.
       * Nút radio/button: `Chọn Hạng Phổ Thông`.
    2. **Hạng Thương Gia (SkyBoss / Business):**
       * Huy hiệu "Cao Cấp / Đề Xuất" màu vàng ánh kim.
       * Ghế ngồi da êm ái ngả lưng rộng rãi hoặc giường nằm.
       * Ưu tiên làm thủ tục tại quầy riêng, lối đi an ninh ưu tiên, xe đưa đón riêng.
       * Quyền sử dụng Phòng Chờ Thương Gia sang trọng (VIP Lounge).
       * Miễn phí 30kg - 40kg hành lý ký gửi + 1 bộ gậy golf.
       * Suất ăn nóng tươi ngon tự chọn kèm đồ uống cao cấp suốt hành trình.
       * Miễn phí thay đổi giờ bay, hành trình bay.
       * Nút radio/button: `Chọn Hạng Thương Gia`.
* **Khu vực thao tác cuối trang:**
  * Tổng tiền tạm tính theo hạng vé đã chọn.
  * Nút "Chọn Vé & Thêm Vào Giỏ Hàng" (Màu đỏ `#ee1d23`, to rõ).
  * Khi click: Lưu vé vào giỏ hàng (SQLite / LocalStorage), hiển thị Toast thông báo thành công và có nút dẫn nhanh đến trang Giỏ hàng.

---

### 5.5. Trang Tour Du Lịch (`tours.html`)

* **Cấu trúc 2 cột tương tự trang Chuyến bay:**
  * **Cột trái (Filter):**
    * Sắp xếp giá: Tăng dần / Giảm dần.
    * Hãng hàng không bay cùng tour: VietJet Air, Vietnam Airlines...
    * Khung giờ cất cánh tour.
    * Điểm đến: Du lịch miền Bắc, miền Trung, miền Nam, Tour Châu Á, Tour Châu Âu.
  * **Cột phải (Tour Listing):**
    * Card tour mở rộng, hình ảnh 600x400 rõ nét.
    * Thông tin: Tên tour trọn gói, Hãng hàng không đối tác, Ngày cất cánh, Thời gian bay & số ngày/đêm, Mức giá trọn gói, Các tiện ích bao gồm (khách sạn 4-5 sao, xe đưa đón, vé tham quan, bảo hiểm du lịch).
    * Nút "Xem Chi Tiết Tour" -> Dẫn sang `tour-detail.html?id=...`.

---

### 5.6. Trang Chi Tiết Tour (`tour-detail.html`)

* **Hero Tour:** Tên tour lớn, mã tour, đánh giá sao, thời gian (VD: `5 Ngày 4 Đêm`).
* **Khối thông tin chuyến bay kèm theo tour:**
  * Điểm xuất phát và điểm đến.
  * Thời gian bay, hãng hàng không vận chuyển (VietJet Air / Vietnam Airlines), Loại máy bay (Airbus A321 / Boeing 777...).
* **Lịch trình chuyến đi chi tiết (Day-by-Day Itinerary):**
  * Thiết kế dạng Timeline từng ngày:
    * *Ngày 1:* Khởi hành từ Sân bay - Đến nơi nhận phòng - Tham quan điểm đến đầu tiên.
    * *Ngày 2:* Khám phá danh lam thắng cảnh - Thưởng thức ẩm thực địa phương đặc sắc.
    * *Ngày 3:* Trải nghiệm văn hóa & vui chơi giải trí.
    * *Ngày 4/5:* Tự do mua sắm đặc sản - Bay về điểm xuất phát.
* **Chính sách tour:**
  * Bảng dịch vụ bao gồm (Vé máy bay khứ hồi, khách sạn, các bữa ăn theo chương trình, bảo hiểm).
  * Bảng dịch vụ không bao gồm (Chi phí cá nhân, tiền tip...).
* **Nút hành động:** "Đặt Tour Ngay / Thêm Vào Giỏ Hàng" -> Thêm dữ liệu tour vào Giỏ hàng, cập nhật tức thì.

---

### 5.7. Trang Giỏ Hàng & Xác Nhận Đặt Chỗ (`cart.html`)

* **Bảng danh sách mục đã chọn:**
  * Liệt kê rõ ràng từng dòng: Tên chuyến bay hoặc tên tour, Loại dịch vụ, Hạng vé (Phổ thông / Thương gia), Ngày khởi hành, Đơn giá, Số lượng khách, Thành tiền.
  * Nút "Xóa" từng dòng (Icon thùng rác đỏ) và nút "Xóa tất cả giỏ hàng".
  * Dòng tổng kết: Tạm tính, Thuế & Phí (0đ hoặc minh bạch), **Tổng Tiền Thanh Toán (Màu đỏ `#ee1d23`, cỡ chữ 24px đậm)**.
* **Form thông tin liên hệ khách hàng:**
  * Họ và tên hành khách đại diện (Bắt buộc)
  * Số điện thoại liên hệ (Bắt buộc)
  * Địa chỉ Email nhận vé (Bắt buộc - dùng để gửi email xác nhận)
  * Số CCCD / Hộ chiếu (Bắt buộc)
  * Ghi chú bổ sung (yêu cầu suất ăn chay, hỗ trợ xe lăn, v.v.)
* **Nút xác nhận:** "Xác Nhận Đăng Ký & Đặt Vé" (Màu đỏ Vietjet).
* **Quy trình xử lý khi click Đăng Ký:**
  1. Kiểm tra validation toàn bộ form (bắt buộc nhập đủ và đúng định dạng email, phone).
  2. Ghi nhận bản ghi đơn hàng mới vào cơ sở dữ liệu SQLite (bảng `orders` và `order_items`).
  3. Kích hoạt gửi email xác nhận từ địa chỉ `nvhai061993@gmail.com` đến địa chỉ email mà khách vừa nhập, nội dung email chứa Mã đặt chỗ (Booking Code), chi tiết các chuyến bay/tour đã đặt, tổng tiền thanh toán và hướng dẫn làm thủ tục.
  4. Hiển thị Popup / Modal thông báo:
     * Biểu tượng dấu tick xanh thành công lớn.
     * Tiêu đề: "ĐẶT CHỖ THÀNH CÔNG!".
     * Thông báo: "Hệ thống đã gửi email xác nhận từ nvhai061993@gmail.com tới [email của khách]. Vui lòng kiểm tra hộp thư của bạn."
     * Tùy chọn xem hóa đơn điện tử hoặc quay về Trang Chủ.
  5. Xóa giỏ hàng sau khi đặt thành công.
