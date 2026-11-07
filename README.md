# Vietjet Travel & Flight Booking - Antigravity Specification Kit

Chào mừng bạn đến với bộ tài liệu đặc tả chuẩn hóa (PRD & Technical Specifications) dành cho dự án **Vietjet Travel Website**, được thiết kế chuyên biệt để bạn thực hiện **Vibe Coding với Antigravity**.

---

## 1. Tổng quan dự án

* **Tên website:** Vietjet Travel
* **Lĩnh vực:** Du lịch & Đặt vé máy bay trực tuyến (OTA)
* **Công nghệ:** HTML5, CSS3, Vanilla JavaScript (Không backend)
* **Cơ sở dữ liệu:** SQLite 3 (Chạy trong trình duyệt thông qua WebAssembly `sql.js`, đồng bộ LocalStorage)
* **Phong cách giao diện:** Tông sáng, nền trắng, màu sắc chủ đạo là màu đỏ Vietjet (`#ee1d23`) và điểm xuyết sắc vàng (`#ffd100`)
* **Email hệ thống:** Tự động gửi email xác nhận đặt chỗ từ `nvhai061993@gmail.com` đến email của khách hàng.

---

## 2. Danh mục các file đặc tả (.MD)

Tất cả các file đều được biên soạn chi tiết, chặt chẽ và tương thích hoàn toàn với Antigravity:

| Tên File | Mục đích & Nội dung chính |
|---|---|
| [`PROJECT.md`](file:///d:/Phuong%20Thanh/vietjet/PROJECT.md) | Tổng quan dự án, mục tiêu kinh doanh, đối tượng người dùng, phạm vi chức năng (In-Scope / Out-of-Scope), ràng buộc công nghệ. |
| [`DESIGN.md`](file:///d:/Phuong%20Thanh/vietjet/DESIGN.md) | Đặc tả thiết kế giao diện: Bảng mã màu chuẩn (`#ee1d23`, `#ffd100`), Typography, Layout 2 cột OTA, Wireframe chi tiết cho 6 màn hình, tỷ lệ ảnh 600x400. |
| [`DATA.md`](file:///d:/Phuong%20Thanh/vietjet/DATA.md) | Kiến trúc dữ liệu SQLite trong trình duyệt (WebAssembly `sql.js`), lược đồ CSDL DDL (6 bảng: `airlines`, `airports`, `flights`, `tours`, `orders`, `order_items`), dữ liệu mẫu và các truy vấn SQL nghiệp vụ. |
| [`FUNCTIONAL.md`](file:///d:/Phuong%20Thanh/vietjet/FUNCTIONAL.md) | Luồng nghiệp vụ và tương tác chi tiết của từng màn hình: Tìm kiếm, Bộ lọc nâng cao, Chi tiết chuyến bay & chọn hạng vé (Phổ Thông/Thương Gia), Lịch trình tour, Giỏ hàng, Gửi email từ `nvhai061993@gmail.com`. |
| [`IMPLEMENTATION.md`](file:///d:/Phuong%20Thanh/vietjet/IMPLEMENTATION.md) | Hướng dẫn triển khai kỹ thuật, cấu trúc thư mục, quy trình phát triển theo 6 module tuần tự và danh sách 10 test case kiểm thử chất lượng. |
| [`prompt/prompt.txt`](file:///d:/Phuong%20Thanh/vietjet/prompt/prompt.txt) | Tập hợp các câu lệnh Prompt mẫu chuẩn hóa để gửi cho Antigravity (Cả phương án One-shot tạo toàn bộ và Phương án làm từng Module). |
| [`prompt/huongdan.txt`](file:///d:/Phuong%20Thanh/vietjet/prompt/huongdan.txt) | Hướng dẫn nhanh quy trình khởi chạy dự án với Live Server. |

---

## 3. Bản đồ các màn hình ứng dụng

```text
1. Trang Chủ (index.html)
   ├── Widget tìm chuyến bay (Khứ hồi / Một chiều / Nhiều thành phố) -> Dẫn sang flights.html
   ├── 8 Tour du lịch nổi bật (Thumbnail 600x400, giá, số ngày/đêm) -> Dẫn sang tour-detail.html
   └── Danh sách logo các hãng hàng không (VietJet Air, Vietnam Airlines...) -> Lọc theo hãng ở flights.html

2. Trang Chuyến Bay (flights.html)
   ├── Cột trái: Bộ lọc giá tăng/giảm, loại vé, hãng bay, 4 khung giờ cất cánh, hạng dịch vụ
   └── Cột phải: Danh sách các chuyến bay -> Click "Chọn Chuyến Bay" dẫn sang flight-detail.html

3. Trang Chi Tiết Chuyến Bay (flight-detail.html)
   ├── Điểm đi, điểm đến, thời gian bay, hãng bay, loại máy bay (Boeing, Airbus...)
   ├── Bảng chọn Hạng Vé: Hạng Phổ Thông vs Hạng Thương Gia
   └── Nút "Thêm vào Giỏ Hàng" -> Cập nhật giỏ hàng & badge Header

4. Trang Danh Sách Tour (tours.html)
   ├── Cột trái: Bộ lọc giá vé, hãng hàng không, khung giờ cất cánh
   └── Cột phải: Danh sách tour du lịch, ảnh 600x400, dịch vụ đi kèm -> Dẫn sang tour-detail.html

5. Trang Chi Tiết Tour (tour-detail.html)
   ├── Thông tin bay: Điểm đi/đến, thời gian bay, hãng bay, loại máy bay
   ├── Lịch trình chuyến đi chi tiết (Day-by-Day Itinerary)
   └── Nút "Đặt Tour / Thêm vào Giỏ Hàng"

6. Trang Giỏ Hàng & Hoàn Tất (cart.html)
   ├── Danh sách chuyến bay & tour đã chọn (Cho phép xóa từng mục hoặc xóa hết, tính tổng tiền)
   ├── Form nhập thông tin cá nhân khách hàng (Validation đầy đủ)
   └── Đăng ký -> Ghi nhận vào SQLite (orders & order_items)
              -> Gửi email từ nvhai061993@gmail.com đến khách hàng
              -> Hiển thị Popup chúc mừng đặt vé thành công
```

---

## 4. Cách sử dụng với Antigravity (Vibe Coding Workflow)

### Bước 1: Mở thư mục dự án
Mở thư mục `d:\Phuong Thanh\vietjet` trong Antigravity.

### Bước 2: Gửi Prompt cho Antigravity
Bạn có thể mở file `prompt/prompt.txt`, copy câu lệnh và gửi cho Antigravity:
* Nếu bạn muốn Antigravity **tạo ngay toàn bộ website một lần**: Sử dụng câu lệnh tại mục **CÁCH 1**.
* Nếu bạn muốn Antigravity **xây dựng từng module bài bản** (khuyên dùng): Lần lượt gửi từng prompt từ Bước 1 đến Bước 6 tại mục **CÁCH 2**.

### Bước 3: Chạy và kiểm tra giao diện
Vì website sử dụng WebAssembly (`sql.js`) và nạp dữ liệu động không qua backend, bạn cần chạy website qua một Web Server cục bộ:
* Trong VS Code / Antigravity: Chuột phải vào `index.html` -> Chọn **Open with Live Server**.
* Hoặc bằng dòng lệnh: `npx serve .` hoặc `python -m http.server 8000`.
