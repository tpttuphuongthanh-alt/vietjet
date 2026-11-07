/**
 * VIETJET TRAVEL - FLIGHTS CONTROLLER (flights.js)
 * Xử lý lọc, sắp xếp và hiển thị danh sách chuyến bay từ SQLite
 */

let currentFilters = {
  origin: '',
  destination: '',
  sortBy: 'price_asc',
  directOnly: false,
  airlines: [],
  timeSlots: []
};

document.addEventListener('DOMContentLoaded', async () => {
  try {
    await window.VietjetDB.init();
    console.log('[Flights] SQLite Database sẵn sàng!');

    // 1. Đọc tham số tìm kiếm từ URL
    parseUrlParams();

    // 2. Khởi tạo danh sách hãng bay trong bộ lọc
    initAirlineFilters();

    // 3. Gắn sự kiện cho các thành phần bộ lọc
    bindFilterEvents();

    // 4. Tải và hiển thị chuyến bay
    applyFiltersAndRender();

  } catch (err) {
    console.error('[Flights] Lỗi khởi chạy:', err);
  }
});

/**
 * Đọc query parameters trên URL
 */
function parseUrlParams() {
  const urlParams = new URLSearchParams(window.location.search);
  
  const origin = urlParams.get('origin');
  const dest = urlParams.get('dest');
  const airline = urlParams.get('airline');

  if (origin) currentFilters.origin = origin;
  if (dest) currentFilters.destination = dest;
  if (airline) currentFilters.airlines = [decodeURIComponent(airline)];

  // Cập nhật tiêu đề tóm tắt
  const summaryTitle = document.getElementById('routeSummaryTitle');
  const summarySub = document.getElementById('routeSummarySub');
  
  if (origin && dest) {
    summaryTitle.textContent = `Chuyến bay từ ${origin} đi ${dest}`;
    summarySub.textContent = `Hành trình cất cánh cập nhật từ cơ sở dữ liệu SQLite`;
  } else if (airline) {
    summaryTitle.textContent = `Các chuyến bay của hãng ${decodeURIComponent(airline)}`;
    summarySub.textContent = `Danh sách lịch bay của đối tác ${decodeURIComponent(airline)}`;
  }
}

/**
 * Tạo danh sách checkbox Hãng Hàng Không trong Sidebar
 */
function initAirlineFilters() {
  const container = document.getElementById('airlineFilterList');
  if (!container) return;

  const airlines = window.VietjetDB.getAirlines();
  
  container.innerHTML = airlines.map(a => {
    const isChecked = currentFilters.airlines.includes(a.name) ? 'checked' : '';
    return `
      <label class="filter-checkbox-label">
        <input type="checkbox" class="airline-filter-cb" value="${a.name}" ${isChecked}>
        <span>${a.name}</span>
      </label>
    `;
  }).join('');

  // Lắng nghe sự kiện click checkbox hãng
  container.querySelectorAll('.airline-filter-cb').forEach(cb => {
    cb.addEventListener('change', () => {
      updateAirlinesFromCheckboxes();
      applyFiltersAndRender();
    });
  });
}

function updateAirlinesFromCheckboxes() {
  const checked = document.querySelectorAll('.airline-filter-cb:checked');
  currentFilters.airlines = Array.from(checked).map(c => c.value);
}

/**
 * Gắn sự kiện các bộ lọc
 */
function bindFilterEvents() {
  // Sắp xếp giá
  document.querySelectorAll('input[name="sortByPrice"]').forEach(r => {
    r.addEventListener('change', (e) => {
      currentFilters.sortBy = e.target.value;
      applyFiltersAndRender();
    });
  });

  // Bay thẳng
  const directCb = document.getElementById('filterDirectOnly');
  if (directCb) {
    directCb.addEventListener('change', (e) => {
      currentFilters.directOnly = e.target.checked;
      applyFiltersAndRender();
    });
  }

  // Khung giờ cất cánh
  document.querySelectorAll('.time-filter-cb').forEach(cb => {
    cb.addEventListener('change', () => {
      const checkedSlots = document.querySelectorAll('.time-filter-cb:checked');
      currentFilters.timeSlots = Array.from(checkedSlots).map(c => c.value);
      applyFiltersAndRender();
    });
  });

  // Đặt lại bộ lọc
  const btnReset = document.getElementById('btnResetFilters');
  if (btnReset) {
    btnReset.addEventListener('click', () => {
      currentFilters = {
        origin: '',
        destination: '',
        sortBy: 'price_asc',
        directOnly: false,
        airlines: [],
        timeSlots: []
      };

      // Reset DOM
      document.getElementById('sortPriceAsc').checked = true;
      if (directCb) directCb.checked = false;
      document.querySelectorAll('.airline-filter-cb').forEach(c => c.checked = false);
      document.querySelectorAll('.time-filter-cb').forEach(c => c.checked = false);

      applyFiltersAndRender();
    });
  }
}

/**
 * Truy vấn SQLite và render danh sách chuyến bay
 */
function applyFiltersAndRender() {
  const container = document.getElementById('flightListContainer');
  const countBadge = document.getElementById('resultsCountBadge');
  if (!container) return;

  try {
    const flights = window.VietjetDB.getFlights(currentFilters);

    countBadge.textContent = `${flights.length} chuyến bay`;

    if (flights.length === 0) {
      container.innerHTML = `
        <div style="background: #fff; padding: 48px; border-radius: var(--radius-md); text-align: center; border: 1px solid var(--color-border);">
          <i class="fa-solid fa-plane-slash fa-3x" style="color: var(--color-text-muted); margin-bottom: 16px;"></i>
          <h3 style="font-size: 18px; color: var(--color-dark); margin-bottom: 8px;">Không tìm thấy chuyến bay phù hợp</h3>
          <p style="color: var(--color-text-muted); font-size: 14px;">Vui lòng thử bỏ bớt điều kiện lọc hoặc chọn ngày bay khác.</p>
        </div>
      `;
      return;
    }

    container.innerHTML = flights.map(f => `
      <article class="flight-card">
        <!-- Hãng bay & Mã số -->
        <div class="flight-airline-col">
          <img src="${f.airline_logo}" alt="${f.airline_name}" class="flight-airline-logo" onerror="this.src='images/download2.png'">
          <div class="flight-airline-info">
            <h4>${f.airline_name}</h4>
            <span class="flight-code">${f.flight_number}</span>
          </div>
        </div>

        <!-- Giờ cất cánh & Hành trình -->
        <div class="flight-schedule-col">
          <div class="flight-time-point">
            <div class="flight-time">${f.departure_time}</div>
            <div class="flight-airport">${f.origin_code} • ${f.origin_city}</div>
          </div>

          <div class="flight-timeline-connector">
            <span class="flight-duration">${f.duration_text}</span>
            <div class="flight-timeline-line"></div>
            <span class="flight-type-badge">${f.flight_type === 'direct' ? 'Bay thẳng' : 'Quá cảnh'} • ${f.aircraft_type}</span>
          </div>

          <div class="flight-time-point">
            <div class="flight-time">${f.arrival_time}</div>
            <div class="flight-airport">${f.destination_code} • ${f.dest_city}</div>
          </div>
        </div>

        <!-- Giá tiền & Nút chọn -->
        <div class="flight-action-col">
          <span class="flight-price-from">Giá chỉ từ</span>
          <div class="flight-price-value">${window.VietjetUI.formatVND(f.price_economy)}</div>
          <a href="flight-detail.html?id=${f.id}" class="btn btn-primary btn-sm btn-block">
            Chọn Chuyến Bay <i class="fa-solid fa-arrow-right"></i>
          </a>
        </div>
      </article>
    `).join('');

  } catch (err) {
    console.error('[Flights] Lỗi truy vấn chuyến bay:', err);
    container.innerHTML = '<p style="color: red; padding: 20px;">Lỗi truy vấn cơ sở dữ liệu SQLite.</p>';
  }
}
