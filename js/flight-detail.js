/**
 * VIETJET TRAVEL - FLIGHT DETAIL CONTROLLER (flight-detail.js)
 * Hiển thị thông tin hành trình, tàu bay (Boeing/Airbus), chọn Hạng Phổ Thông / Thương Gia, thêm vào giỏ hàng
 */

let currentFlight = null;
let selectedTicketClass = 'economy'; // 'economy' hoặc 'business'

document.addEventListener('DOMContentLoaded', async () => {
  try {
    await window.VietjetDB.init();
    
    const urlParams = new URLSearchParams(window.location.search);
    const flightId = urlParams.get('id') || 1;

    currentFlight = window.VietjetDB.getFlightById(flightId);

    if (!currentFlight) {
      document.getElementById('flightDetailContainer').innerHTML = `
        <div style="text-align: center; padding: 40px;">
          <i class="fa-solid fa-triangle-exclamation fa-3x" style="color: var(--color-warning); margin-bottom: 16px;"></i>
          <h3>Không tìm thấy chuyến bay yêu cầu</h3>
          <p style="margin-top: 8px;"><a href="flights.html" class="btn btn-primary btn-sm">Xem danh sách chuyến bay</a></p>
        </div>
      `;
      return;
    }

    renderFlightDetail();

  } catch (err) {
    console.error('[FlightDetail] Lỗi:', err);
  }
});

function renderFlightDetail() {
  const container = document.getElementById('flightDetailContainer');
  const f = currentFlight;

  container.innerHTML = `
    <!-- Tiêu Đề Hành Trình & Máy Bay -->
    <div class="flight-detail-header">
      <div>
        <h1 class="flight-route-title">${f.origin_city} (${f.origin_code}) <i class="fa-solid fa-arrow-right-long" style="color: var(--color-primary); font-size: 22px;"></i> ${f.dest_city} (${f.destination_code})</h1>
        <div style="display: flex; align-items: center; gap: 12px; margin-top: 8px;">
          <span style="font-weight: 700; color: var(--color-dark);">${f.airline_name} • ${f.flight_number}</span>
          <span class="flight-aircraft-badge">
            <i class="fa-solid fa-plane"></i> ${f.aircraft_type}
          </span>
          <span style="color: var(--color-success); font-weight: 600; font-size: 13px;">
            <i class="fa-solid fa-circle-check"></i> ${f.flight_type === 'direct' ? 'Bay thẳng' : 'Quá cảnh'}
          </span>
        </div>
      </div>

      <img src="${f.airline_logo}" alt="${f.airline_name}" style="height: 54px; object-fit: contain;" onerror="this.src='images/download2.png'">
    </div>

    <!-- Thông Tin Giờ Bay & Lịch Trình -->
    <div style="background-color: var(--color-bg-light); border-radius: var(--radius-md); padding: 20px 24px; margin-bottom: 30px; display: flex; align-items: center; justify-content: space-between;">
      <div>
        <span style="font-size: 12px; color: var(--color-text-muted); text-transform: uppercase;">Khởi hành</span>
        <div style="font-size: 24px; font-weight: 800; color: var(--color-dark);">${f.departure_time}</div>
        <div style="font-size: 13px; font-weight: 600; color: var(--color-text);">${f.origin_airport_name}</div>
      </div>

      <div style="text-align: center;">
        <span style="font-size: 13px; font-weight: 700; color: var(--color-primary);">${f.duration_text}</span>
        <div style="width: 140px; height: 2px; background-color: var(--color-primary); margin: 6px auto; position: relative;">
          <i class="fa-solid fa-plane" style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); color: var(--color-primary); background: var(--color-bg-light); padding: 0 4px;"></i>
        </div>
        <span style="font-size: 12px; color: var(--color-text-muted);">Tàu bay ${f.aircraft_type}</span>
      </div>

      <div style="text-align: right;">
        <span style="font-size: 12px; color: var(--color-text-muted); text-transform: uppercase;">Hạ cánh</span>
        <div style="font-size: 24px; font-weight: 800; color: var(--color-dark);">${f.arrival_time}</div>
        <div style="font-size: 13px; font-weight: 600; color: var(--color-text);">${f.dest_airport_name}</div>
      </div>
    </div>

    <!-- Bảng Chọn Hạng Vé (Hạng Phổ Thông vs Hạng Thương Gia) -->
    <h3 style="font-size: 20px; font-weight: 800; color: var(--color-dark); margin-bottom: 6px;">
      <i class="fa-solid fa-couch" style="color: var(--color-primary);"></i> Chọn Hạng Vé & Tiện Ích
    </h3>
    <p style="color: var(--color-text-muted); font-size: 14px; margin-bottom: 20px;">
      Vui lòng chọn 1 trong 2 hạng dịch vụ để tiếp tục thêm vào giỏ hàng:
    </p>

    <div class="ticket-classes-grid">
      <!-- 1. Hạng Phổ Thông (Economy) -->
      <div class="ticket-class-card ${selectedTicketClass === 'economy' ? 'selected' : ''}" id="cardClassEconomy" onclick="selectTicketClass('economy')">
        <h4 class="ticket-class-name">Hạng Phổ Thông (Eco)</h4>
        <div class="ticket-class-price">${window.VietjetUI.formatVND(f.price_economy)} <span style="font-size: 13px; font-weight: 400; color: var(--color-text-muted);">/ khách</span></div>
        
        <ul class="ticket-benefits-list">
          <li><i class="fa-solid fa-check"></i> <span>Hành lý xách tay: <strong>${f.baggage_economy}</strong></span></li>
          <li><i class="fa-solid fa-check"></i> <span>Suất ăn: Nước uống tiêu chuẩn (có thể mua thêm suất ăn nóng)</span></li>
          <li><i class="fa-solid fa-check"></i> <span>Loại ghế: Ghế bọc da êm ái tiêu chuẩn trên ${f.aircraft_type}</span></li>
          <li><i class="fa-solid fa-check"></i> <span>Đổi ngày bay: Có tính phí thay đổi + chênh lệch giá vé</span></li>
          <li><i class="fa-solid fa-check"></i> <span>Tích lũy điểm khách hàng thân thiết Vietjet SkyJoy</span></li>
        </ul>

        <button type="button" class="btn ${selectedTicketClass === 'economy' ? 'btn-primary' : 'btn-outline'} ticket-class-select-btn">
          ${selectedTicketClass === 'economy' ? '<i class="fa-solid fa-circle-check"></i> Đang Chọn Hạng Này' : 'Chọn Hạng Phổ Thông'}
        </button>
      </div>

      <!-- 2. Hạng Thương Gia (Business / SkyBoss) -->
      <div class="ticket-class-card business-highlight ${selectedTicketClass === 'business' ? 'selected' : ''}" id="cardClassBusiness" onclick="selectTicketClass('business')">
        <span class="vip-ribbon"><i class="fa-solid fa-crown"></i> Hạng Cao Cấp SkyBoss</span>
        <h4 class="ticket-class-name">Hạng Thương Gia (SkyBoss)</h4>
        <div class="ticket-class-price">${window.VietjetUI.formatVND(f.price_business)} <span style="font-size: 13px; font-weight: 400; color: var(--color-text-muted);">/ khách</span></div>
        
        <ul class="ticket-benefits-list">
          <li><i class="fa-solid fa-check"></i> <span>Hành lý ưu tiên: <strong>${f.baggage_business}</strong></span></li>
          <li><i class="fa-solid fa-check"></i> <span><strong>Phòng Chờ Thương Gia sang trọng</strong> (VIP Lounge) trước giờ bay</span></li>
          <li><i class="fa-solid fa-check"></i> <span>Ưu tiên làm thủ tục tại quầy riêng, lối đi an ninh VIP & xe riêng ra máy bay</span></li>
          <li><i class="fa-solid fa-check"></i> <span>Phục vụ suất ăn nóng cao cấp tự chọn kèm đồ uống hảo hạng suốt hành trình</span></li>
          <li><i class="fa-solid fa-check"></i> <span>Ghế ngồi da cao cấp không gian rộng rãi ngả lưng thoải mái</span></li>
          <li><i class="fa-solid fa-check"></i> <span><strong>Miễn phí</strong> đổi giờ bay, ngày bay và hành trình</span></li>
        </ul>

        <button type="button" class="btn ${selectedTicketClass === 'business' ? 'btn-primary' : 'btn-outline'} ticket-class-select-btn">
          ${selectedTicketClass === 'business' ? '<i class="fa-solid fa-circle-check"></i> Đang Chọn Hạng Này' : 'Chọn Hạng Thương Gia'}
        </button>
      </div>
    </div>

    <!-- Thanh Xác Nhận Cuối Trang -->
    <div class="flight-bottom-bar" style="margin-top: 36px;">
      <div class="flight-total-box">
        <span id="selectedClassNameText">Đang chọn: <strong>Hạng Phổ Thông (Eco)</strong></span>
        <h3 id="selectedPriceDisplay">${window.VietjetUI.formatVND(f.price_economy)}</h3>
      </div>

      <button type="button" class="btn btn-primary btn-lg" onclick="addToCartFlight()">
        <i class="fa-solid fa-cart-plus"></i> Chọn Vé & Thêm Vào Giỏ Hàng
      </button>
    </div>
  `;
}

/**
 * Chọn chuyển đổi giữa Hạng Phổ Thông và Hạng Thương Gia
 */
function selectTicketClass(className) {
  selectedTicketClass = className;
  
  const f = currentFlight;
  const isEco = className === 'economy';
  const price = isEco ? f.price_economy : f.price_business;

  // Cập nhật giao diện card
  document.getElementById('cardClassEconomy').classList.toggle('selected', isEco);
  document.getElementById('cardClassBusiness').classList.toggle('selected', !isEco);

  // Cập nhật nút trong thẻ
  const ecoBtn = document.querySelector('#cardClassEconomy button');
  const busBtn = document.querySelector('#cardClassBusiness button');
  if (ecoBtn && busBtn) {
    ecoBtn.className = `btn ${isEco ? 'btn-primary' : 'btn-outline'} ticket-class-select-btn`;
    ecoBtn.innerHTML = isEco ? '<i class="fa-solid fa-circle-check"></i> Đang Chọn Hạng Này' : 'Chọn Hạng Phổ Thông';

    busBtn.className = `btn ${!isEco ? 'btn-primary' : 'btn-outline'} ticket-class-select-btn`;
    busBtn.innerHTML = !isEco ? '<i class="fa-solid fa-circle-check"></i> Đang Chọn Hạng Này' : 'Chọn Hạng Thương Gia';
  }

  // Cập nhật thanh tổng tiền
  document.getElementById('selectedClassNameText').innerHTML = `Đang chọn: <strong>${isEco ? 'Hạng Phổ Thông (Eco)' : 'Hạng Thương Gia (SkyBoss)'}</strong>`;
  document.getElementById('selectedPriceDisplay').textContent = window.VietjetUI.formatVND(price);
}

/**
 * Thêm vé máy bay vào giỏ hàng
 */
function addToCartFlight() {
  if (!currentFlight) return;
  const f = currentFlight;

  const isEco = selectedTicketClass === 'economy';
  const price = isEco ? f.price_economy : f.price_business;
  const classNameStr = isEco ? 'Hạng Phổ Thông' : 'Hạng Thương Gia';

  const cartItem = {
    type: 'flight',
    id: f.id,
    title: `Vé máy bay ${f.origin_city} (${f.origin_code}) đi ${f.dest_city} (${f.destination_code})`,
    ticketClass: selectedTicketClass,
    details: `${f.airline_name} • ${f.flight_number} • Tàu bay ${f.aircraft_type} • ${classNameStr} • Cất cánh ${f.departure_time}`,
    price: price,
    quantity: 1,
    departureDate: new Date().toISOString().split('T')[0]
  };

  window.VietjetCart.addItem(cartItem);

  // Tùy chọn chuyển tới giỏ hàng
  setTimeout(() => {
    if (confirm('Vé đã được lưu vào Giỏ Hàng! Bạn có muốn chuyển đến Giỏ Hàng để xem ngay không?')) {
      window.location.href = 'cart.html';
    }
  }, 400);
}
