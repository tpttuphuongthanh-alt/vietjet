/**
 * VIETJET TRAVEL - HOME PAGE CONTROLLER (home.js)
 * Xử lý tìm kiếm chuyến bay, render 8 tour nổi bật, render logo đối tác từ SQLite
 */

document.addEventListener('DOMContentLoaded', async () => {
  try {
    // 1. Khởi tạo cơ sở dữ liệu SQLite
    await window.VietjetDB.init();
    console.log('[Home] SQLite Database đã sẵn sàng!');

    // 2. Thiết lập bộ chọn ngày mặc định
    setupDatePickers();

    // 3. Xử lý chuyển đổi loại vé (Khứ hồi / Một chiều)
    setupTripTypeTabs();

    // 4. Xử lý Form tìm kiếm
    setupSearchForm();

    // 5. Render 8 Tour du lịch nổi bật từ SQLite
    renderFeaturedTours();

    // 6. Render Logo các hãng hàng không từ SQLite
    renderAirlines();

  } catch (error) {
    console.error('[Home] Lỗi khởi chạy Trang Chủ:', error);
  }
});

/**
 * Thiết lập ngày đi và ngày về
 */
function setupDatePickers() {
  const depInput = document.getElementById('searchDepDate');
  const retInput = document.getElementById('searchRetDate');

  const today = new Date();
  const tomorrow = new Date(today);
  tomorrow.setDate(tomorrow.getDate() + 1);

  const nextWeek = new Date(today);
  nextWeek.setDate(nextWeek.getDate() + 5);

  const formatDate = d => d.toISOString().split('T')[0];

  depInput.min = formatDate(today);
  depInput.value = formatDate(tomorrow);

  retInput.min = formatDate(tomorrow);
  retInput.value = formatDate(nextWeek);

  depInput.addEventListener('change', () => {
    retInput.min = depInput.value;
    if (retInput.value < depInput.value) {
      retInput.value = depInput.value;
    }
  });
}

/**
 * Xử lý tabs Khứ hồi / Một chiều
 */
function setupTripTypeTabs() {
  const tabLabels = document.querySelectorAll('.search-tabs .tab-btn');
  const retGroup = document.getElementById('returnDateFieldGroup');
  const retInput = document.getElementById('searchRetDate');

  tabLabels.forEach(label => {
    label.addEventListener('click', () => {
      tabLabels.forEach(l => l.classList.remove('active'));
      label.classList.add('active');

      const radio = label.querySelector('input[type="radio"]');
      if (radio) radio.checked = true;

      if (radio.value === 'oneway') {
        retInput.disabled = true;
        retGroup.style.opacity = '0.5';
      } else {
        retInput.disabled = false;
        retGroup.style.opacity = '1';
      }
    });
  });
}

/**
 * Xử lý submit tìm kiếm chuyến bay
 */
function setupSearchForm() {
  const form = document.getElementById('flightSearchForm');
  if (!form) return;

  form.addEventListener('submit', (e) => {
    e.preventDefault();

    const origin = document.getElementById('searchOrigin').value;
    const dest = document.getElementById('searchDestination').value;
    const depDate = document.getElementById('searchDepDate').value;
    const retDate = document.getElementById('searchRetDate').value;
    const passengers = document.getElementById('searchPassengers').value;
    const tripTypeRadio = document.querySelector('input[name="tripType"]:checked');
    const tripType = tripTypeRadio ? tripTypeRadio.value : 'roundtrip';

    if (origin === dest) {
      window.VietjetUI.showToast('Điểm xuất phát và Điểm đến không được trùng nhau!', 'error');
      return;
    }

    const params = new URLSearchParams({
      origin,
      dest,
      tripType,
      depDate,
      passengers
    });

    if (tripType !== 'oneway' && retDate) {
      params.append('retDate', retDate);
    }

    // Chuyển hướng đến trang Chuyến Bay
    window.location.href = `flights.html?${params.toString()}`;
  });
}

/**
 * Render 8 Tour Du Lịch Nổi Bật từ SQLite
 */
function renderFeaturedTours() {
  const container = document.getElementById('featuredToursContainer');
  if (!container) return;

  try {
    const tours = window.VietjetDB.getFeaturedTours();

    if (!tours || tours.length === 0) {
      container.innerHTML = '<p style="grid-column: span 4; text-align: center;">Chưa có dữ liệu tour du lịch.</p>';
      return;
    }

    container.innerHTML = tours.map(tour => `
      <article class="tour-card" onclick="window.location.href='tour-detail.html?id=${tour.id}'" style="cursor: pointer;">
        <div class="tour-thumb-wrapper">
          <img src="${tour.thumbnail_url}" alt="${tour.title}" loading="lazy" onerror="this.src='images/images.jpg'">
          <span class="tour-duration-badge">${tour.duration_text || (tour.duration_days + 'N' + tour.duration_nights + 'Đ')}</span>
          <span class="tour-agency-badge">${tour.agency_name}</span>
        </div>
        <div class="tour-body">
          <h3 class="tour-title" title="${tour.title}">${tour.title}</h3>
          <div class="tour-flight-meta">
            <i class="fa-solid fa-plane"></i>
            <span>${tour.airline_name} • ${tour.aircraft_type || 'Máy bay hiện đại'}</span>
          </div>
          <div class="tour-footer">
            <div class="tour-price-box">
              <span class="tour-price-label">Giá trọn gói từ</span>
              <span class="tour-price">${window.VietjetUI.formatVND(tour.price)}</span>
            </div>
            <a href="tour-detail.html?id=${tour.id}" class="btn btn-primary btn-sm" onclick="event.stopPropagation();">
              Xem Tour <i class="fa-solid fa-arrow-right"></i>
            </a>
          </div>
        </div>
      </article>
    `).join('');

  } catch (err) {
    console.error('[Home] Lỗi render tour:', err);
    container.innerHTML = '<p style="grid-column: span 4; text-align: center; color: red;">Không thể tải dữ liệu tour từ SQLite.</p>';
  }
}

/**
 * Render Logo các Hãng Hàng Không từ SQLite
 */
function renderAirlines() {
  const container = document.getElementById('airlinesContainer');
  if (!container) return;

  try {
    const airlines = window.VietjetDB.getAirlines();

    container.innerHTML = airlines.map(airline => `
      <div class="airline-card" onclick="filterByAirline('${encodeURIComponent(airline.name)}')" title="Xem chuyến bay của ${airline.name}">
        <div class="airline-logo-box">
          <img src="${airline.logo_url}" alt="${airline.name}" onerror="this.src='images/download2.png'">
        </div>
        <div class="airline-name">${airline.name}</div>
      </div>
    `).join('');

  } catch (err) {
    console.error('[Home] Lỗi render airlines:', err);
  }
}

/**
 * Click vào logo hãng bay -> Chuyển sang flights.html lọc theo hãng
 */
function filterByAirline(airlineName) {
  window.location.href = `flights.html?airline=${airlineName}`;
}
