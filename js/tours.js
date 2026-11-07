/**
 * VIETJET TRAVEL - TOURS CONTROLLER (tours.js)
 * Xử lý lọc và hiển thị danh sách tour du lịch từ SQLite
 */

let tourFilters = {
  sortBy: 'price_asc',
  airlines: [],
  timeSlots: []
};

document.addEventListener('DOMContentLoaded', async () => {
  try {
    await window.VietjetDB.init();

    initTourAirlineFilters();
    bindTourFilterEvents();
    renderTourList();

  } catch (err) {
    console.error('[Tours] Lỗi:', err);
  }
});

function initTourAirlineFilters() {
  const container = document.getElementById('tourAirlinesFilterList');
  if (!container) return;

  const airlines = window.VietjetDB.getAirlines();
  container.innerHTML = airlines.map(a => `
    <label class="filter-checkbox-label">
      <input type="checkbox" class="tour-airline-cb" value="${a.name}">
      <span>${a.name}</span>
    </label>
  `).join('');

  container.querySelectorAll('.tour-airline-cb').forEach(cb => {
    cb.addEventListener('change', () => {
      const checked = document.querySelectorAll('.tour-airline-cb:checked');
      tourFilters.airlines = Array.from(checked).map(c => c.value);
      renderTourList();
    });
  });
}

function bindTourFilterEvents() {
  // Sắp xếp giá
  document.querySelectorAll('input[name="sortTourPrice"]').forEach(r => {
    r.addEventListener('change', (e) => {
      tourFilters.sortBy = e.target.value;
      renderTourList();
    });
  });

  // Khung giờ cất cánh
  document.querySelectorAll('.tour-time-cb').forEach(cb => {
    cb.addEventListener('change', () => {
      const checked = document.querySelectorAll('.tour-time-cb:checked');
      tourFilters.timeSlots = Array.from(checked).map(c => c.value);
      renderTourList();
    });
  });

  // Reset
  const btnReset = document.getElementById('btnResetTourFilters');
  if (btnReset) {
    btnReset.addEventListener('click', () => {
      tourFilters = { sortBy: 'price_asc', airlines: [], timeSlots: [] };
      document.getElementById('sortTourAsc').checked = true;
      document.querySelectorAll('.tour-airline-cb').forEach(c => c.checked = false);
      document.querySelectorAll('.tour-time-cb').forEach(c => c.checked = false);
      renderTourList();
    });
  }
}

function renderTourList() {
  const container = document.getElementById('tourListContainer');
  const countBadge = document.getElementById('toursCountBadge');
  if (!container) return;

  try {
    const tours = window.VietjetDB.getTours(tourFilters);
    countBadge.textContent = `${tours.length} tour du lịch`;

    if (tours.length === 0) {
      container.innerHTML = `
        <div style="background: #fff; padding: 48px; border-radius: var(--radius-md); text-align: center; border: 1px solid var(--color-border);">
          <i class="fa-solid fa-umbrella-beach fa-3x" style="color: var(--color-text-muted); margin-bottom: 16px;"></i>
          <h3>Không tìm thấy tour phù hợp</h3>
          <p style="color: var(--color-text-muted); font-size: 14px; margin-top: 6px;">Vui lòng thử bỏ bớt điều kiện lọc để xem thêm tour.</p>
        </div>
      `;
      return;
    }

    container.innerHTML = tours.map(t => `
      <article class="tour-list-card">
        <div class="tour-list-thumb">
          <img src="${t.thumbnail_url}" alt="${t.title}" onerror="this.src='images/images.jpg'">
          <span class="tour-duration-badge" style="top: 10px; right: 10px;">${t.duration_text || (t.duration_days + 'N' + t.duration_nights + 'Đ')}</span>
        </div>

        <div class="tour-list-info">
          <div class="tour-list-meta">
            <span><i class="fa-solid fa-plane"></i> <strong>${t.airline_name}</strong></span>
            <span><i class="fa-solid fa-clock"></i> Cất cánh: <strong>${t.departure_time}</strong> (${t.flight_duration})</span>
            <span><i class="fa-solid fa-location-dot"></i> Từ <strong>${t.origin_city}</strong> đến <strong>${t.destination_city}</strong></span>
          </div>

          <h3 class="tour-list-title">${t.title}</h3>

          <div class="tour-list-services">
            <i class="fa-solid fa-gift" style="color: var(--color-primary); margin-right: 6px;"></i>
            <strong>Dịch vụ bao gồm:</strong> ${t.included_services}
          </div>
        </div>

        <div class="tour-list-action">
          <span style="font-size: 11px; color: var(--color-text-muted); text-transform: uppercase;">Giá trọn gói</span>
          <div class="tour-list-price">${window.VietjetUI.formatVND(t.price)}</div>
          <a href="tour-detail.html?id=${t.id}" class="btn btn-primary btn-sm btn-block">
            Xem Chi Tiết Tour <i class="fa-solid fa-arrow-right"></i>
          </a>
        </div>
      </article>
    `).join('');

  } catch (err) {
    console.error('[Tours] Lỗi render:', err);
  }
}
