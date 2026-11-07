/**
 * VIETJET TRAVEL - TOUR DETAIL CONTROLLER (tour-detail.js)
 * Hiển thị điểm đi/đến, hãng bay, loại máy bay (Boeing/Airbus), lịch trình chi tiết và lưu giỏ hàng
 */

let currentTour = null;

document.addEventListener('DOMContentLoaded', async () => {
  try {
    await window.VietjetDB.init();

    const urlParams = new URLSearchParams(window.location.search);
    const tourId = urlParams.get('id') || 1;

    currentTour = window.VietjetDB.getTourById(tourId);

    if (!currentTour) {
      document.getElementById('tourDetailContainer').innerHTML = `
        <div style="background:#fff; text-align: center; padding: 50px; border-radius: var(--radius-md); border: 1px solid var(--color-border);">
          <i class="fa-solid fa-triangle-exclamation fa-3x" style="color: var(--color-warning); margin-bottom: 16px;"></i>
          <h3>Không tìm thấy tour du lịch yêu cầu</h3>
          <p style="margin-top: 8px;"><a href="tours.html" class="btn btn-primary btn-sm">Xem danh sách tour</a></p>
        </div>
      `;
      return;
    }

    renderTourDetail();

  } catch (err) {
    console.error('[TourDetail] Lỗi:', err);
  }
});

function renderTourDetail() {
  const container = document.getElementById('tourDetailContainer');
  const t = currentTour;

  // Parse itinerary JSON
  let itineraryList = [];
  try {
    itineraryList = typeof t.itinerary_json === 'string' ? JSON.parse(t.itinerary_json) : t.itinerary_json;
  } catch (e) {
    console.warn('[TourDetail] Lỗi parse JSON lịch trình:', e);
  }

  container.innerHTML = `
    <!-- Hero Header -->
    <div class="tour-hero-header">
      <div class="tour-hero-img-box">
        <img src="${t.thumbnail_url}" alt="${t.title}" onerror="this.src='images/images.jpg'">
        <span class="tour-hero-badge"><i class="fa-solid fa-clock"></i> ${t.duration_text || (t.duration_days + ' Ngày ' + t.duration_nights + ' Đêm')}</span>
      </div>

      <div class="tour-hero-content">
        <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 8px;">
          <span style="background: var(--color-primary-light); color: var(--color-primary); font-size: 12px; font-weight: 700; padding: 4px 10px; border-radius: var(--radius-sm);">${t.code}</span>
          <span style="font-size: 13px; color: var(--color-text-muted);">Đơn vị tổ chức: <strong>${t.agency_name}</strong></span>
        </div>

        <h1 style="font-size: 28px; font-weight: 800; color: var(--color-dark); margin-bottom: 16px; line-height: 1.3;">${t.title}</h1>

        <!-- Hộp Thông Tin Chuyến Bay Cùng Tour -->
        <div class="tour-flight-summary-box">
          <div style="display: flex; align-items: center; gap: 14px;">
            <i class="fa-solid fa-plane-circle-check fa-2x"></i>
            <div>
              <div style="font-size: 15px; font-weight: 700; color: var(--color-dark);">
                Chuyến Bay: ${t.origin_city} ➔ ${t.destination_city}
              </div>
              <div style="font-size: 13px; color: #166534; margin-top: 2px;">
                Hãng vận chuyển: <strong>${t.airline_name}</strong> • Tàu bay: <strong>${t.aircraft_type || 'Airbus / Boeing'}</strong>
              </div>
            </div>
          </div>

          <div style="display: flex; gap: 16px; font-size: 13px; color: #166534;">
            <div><i class="fa-solid fa-clock"></i> Cất cánh: <strong>${t.departure_time}</strong></div>
            <div><i class="fa-solid fa-hourglass-half"></i> Thời gian bay: <strong>${t.flight_duration}</strong></div>
          </div>
        </div>

      </div>
    </div>

    <!-- Nội Dung Chi Tiết Tour: Lịch Trình & Dịch Vụ -->
    <div style="background: var(--color-white); border-radius: var(--radius-lg); border: 1px solid var(--color-border); padding: 36px; margin-bottom: 30px;">
      
      <!-- Lịch Trình Từng Ngày -->
      <h2 style="font-size: 22px; font-weight: 800; color: var(--color-dark); margin-bottom: 6px;">
        <i class="fa-solid fa-calendar-days" style="color: var(--color-primary); margin-right: 8px;"></i>
        Lịch Trình Chuyến Đi Chi Tiết
      </h2>
      <p style="color: var(--color-text-muted); font-size: 14px; margin-bottom: 24px;">Chương trình tour trọn gói được thiết kế khoa học, trải nghiệm phong phú:</p>

      <div class="itinerary-timeline">
        ${itineraryList.map(item => `
          <div class="timeline-item">
            <div class="timeline-dot">N${item.day}</div>
            <div class="timeline-box">
              <h4>Ngày ${item.day}: ${item.title}</h4>
              <p>${item.desc || 'Quý khách dùng bữa, tham quan các điểm du lịch nổi tiếng theo chương trình và nghỉ ngơi tại khách sạn tiêu chuẩn.'}</p>
            </div>
          </div>
        `).join('')}
      </div>

      <!-- Dịch Vụ Bao Gồm & Không Bao Gồm -->
      <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 24px; margin-top: 36px; padding-top: 28px; border-top: 1px solid var(--color-border);">
        <div style="background-color: #f0fdf4; border: 1px solid #bbf7d0; border-radius: var(--radius-md); padding: 20px;">
          <h4 style="font-size: 16px; font-weight: 700; color: #166534; margin-bottom: 12px; display: flex; align-items: center; gap: 8px;">
            <i class="fa-solid fa-circle-check"></i> Dịch Vụ Bao Gồm
          </h4>
          <p style="font-size: 13px; color: #14532d; line-height: 1.6;">${t.included_services}</p>
        </div>

        <div style="background-color: #fef2f2; border: 1px solid #fecaca; border-radius: var(--radius-md); padding: 20px;">
          <h4 style="font-size: 16px; font-weight: 700; color: #991b1b; margin-bottom: 12px; display: flex; align-items: center; gap: 8px;">
            <i class="fa-solid fa-circle-xmark"></i> Không Bao Gồm
          </h4>
          <p style="font-size: 13px; color: #7f1d1d; line-height: 1.6;">${t.excluded_services || 'Chi phí cá nhân ngoài chương trình, tiền tip hướng dẫn viên và tài xế, thuế VAT.'}</p>
        </div>
      </div>

    </div>

    <!-- Thanh Đặt Tour Cuối Trang -->
    <div class="flight-bottom-bar" style="margin-top: 20px;">
      <div class="flight-total-box">
        <span>Giá tour trọn gói / 1 khách:</span>
        <h3>${window.VietjetUI.formatVND(t.price)}</h3>
      </div>

      <button type="button" class="btn btn-primary btn-lg" onclick="addToCartTour()">
        <i class="fa-solid fa-cart-plus"></i> Đặt Tour & Thêm Vào Giỏ Hàng
      </button>
    </div>
  `;
}

/**
 * Thêm tour vào giỏ hàng
 */
function addToCartTour() {
  if (!currentTour) return;
  const t = currentTour;

  const cartItem = {
    type: 'tour',
    id: t.id,
    title: t.title,
    ticketClass: 'standard',
    details: `${t.agency_name} • ${t.airline_name} (${t.aircraft_type || 'Máy bay hiện đại'}) • Thời lượng ${t.duration_text || (t.duration_days + 'N' + t.duration_nights + 'Đ')}`,
    price: t.price,
    quantity: 1,
    departureDate: new Date().toISOString().split('T')[0]
  };

  window.VietjetCart.addItem(cartItem);

  setTimeout(() => {
    if (confirm('Tour đã được thêm vào Giỏ Hàng thành công! Bạn có muốn đến trang Giỏ Hàng để hoàn tất đăng ký ngay không?')) {
      window.location.href = 'cart.html';
    }
  }, 400);
}
