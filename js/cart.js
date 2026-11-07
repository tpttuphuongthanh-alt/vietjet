/**
 * VIETJET TRAVEL - CART & CHECKOUT CONTROLLER (cart.js)
 * Quản lý giỏ hàng, thông tin cá nhân, lưu đơn hàng vào SQLite và gửi email xác nhận từ nvhai061993@gmail.com
 */

document.addEventListener('DOMContentLoaded', async () => {
  try {
    await window.VietjetDB.init();

    renderCartItems();
    bindCartEvents();

  } catch (err) {
    console.error('[Cart] Lỗi khởi chạy:', err);
  }
});

/**
 * Render danh sách các mục trong giỏ hàng
 */
function renderCartItems() {
  const container = document.getElementById('cartItemsList');
  const countDisplay = document.getElementById('summaryItemsCount');
  const totalDisplay = document.getElementById('summaryTotalAmount');
  const btnSubmit = document.getElementById('btnSubmitOrder');
  const btnClear = document.getElementById('btnClearCart');

  if (!container) return;

  const items = window.VietjetCart.getItems();
  const total = window.VietjetCart.getTotal();
  const count = window.VietjetCart.getCount();

  countDisplay.textContent = `${count} mục`;
  totalDisplay.textContent = window.VietjetUI.formatVND(total);

  if (items.length === 0) {
    container.innerHTML = `
      <div class="cart-empty-box">
        <i class="fa-solid fa-cart-shopping fa-4x"></i>
        <h3 style="font-size: 20px; font-weight: 700; color: var(--color-dark); margin-bottom: 8px;">Giỏ hàng của bạn đang trống</h3>
        <p style="color: var(--color-text-muted); font-size: 14px; margin-bottom: 24px;">Hãy chọn các chuyến bay giá rẻ hoặc tour du lịch tuyệt vời để tiếp tục hành trình!</p>
        <div style="display: flex; gap: 12px; justify-content: center;">
          <a href="flights.html" class="btn btn-primary btn-sm"><i class="fa-solid fa-plane-departure"></i> Tìm Chuyến Bay</a>
          <a href="tours.html" class="btn btn-outline btn-sm"><i class="fa-solid fa-umbrella-beach"></i> Xem Tour Du Lịch</a>
        </div>
      </div>
    `;

    if (btnSubmit) btnSubmit.disabled = true;
    if (btnClear) btnClear.style.display = 'none';
    return;
  }

  if (btnSubmit) btnSubmit.disabled = false;
  if (btnClear) btnClear.style.display = 'flex';

  container.innerHTML = items.map(item => `
    <div class="cart-item-row" id="cart_row_${item.cartItemId}">
      <div class="cart-item-info">
        <span class="cart-item-type-tag ${item.type === 'flight' ? 'tag-flight' : 'tag-tour'}">
          ${item.type === 'flight' ? '<i class="fa-solid fa-plane"></i> Chuyến Bay' : '<i class="fa-solid fa-umbrella-beach"></i> Tour Du Lịch'}
        </span>
        <h4>${item.title}</h4>
        <div class="cart-item-details">${item.details || ''}</div>
        <div style="font-size: 12px; color: var(--color-text-muted); margin-top: 4px;">
          Ngày khởi hành: <strong>${item.departureDate}</strong>
        </div>
      </div>

      <!-- Số lượng khách / vé -->
      <div class="cart-item-qty">
        <button type="button" class="qty-btn" onclick="changeItemQty('${item.cartItemId}', -1)">-</button>
        <span class="qty-val">${item.quantity || 1}</span>
        <button type="button" class="qty-btn" onclick="changeItemQty('${item.cartItemId}', 1)">+</button>
      </div>

      <!-- Giá tiền & Xóa -->
      <div class="cart-item-price-col">
        <div class="cart-item-price">${window.VietjetUI.formatVND(item.price * (item.quantity || 1))}</div>
        <button type="button" class="btn-remove-item" onclick="deleteCartItem('${item.cartItemId}')" title="Xóa mục này">
          <i class="fa-regular fa-trash-can"></i> Xóa
        </button>
      </div>
    </div>
  `).join('');
}

/**
 * Thay đổi số lượng vé / khách
 */
function changeItemQty(cartItemId, delta) {
  const items = window.VietjetCart.getItems();
  const target = items.find(i => i.cartItemId === cartItemId);
  if (!target) return;

  target.quantity = (target.quantity || 1) + delta;
  if (target.quantity <= 0) {
    window.VietjetCart.removeItem(cartItemId);
  } else {
    window.VietjetCart.saveItems(items);
  }

  renderCartItems();
}

/**
 * Xóa 1 mục khỏi giỏ hàng
 */
function deleteCartItem(cartItemId) {
  if (confirm('Bạn có chắc chắn muốn xóa mục này khỏi giỏ hàng?')) {
    window.VietjetCart.removeItem(cartItemId);
    renderCartItems();
    window.VietjetUI.showToast('Đã xóa mục khỏi giỏ hàng!', 'info');
  }
}

/**
 * Gắn sự kiện xóa toàn bộ và submit đặt vé
 */
function bindCartEvents() {
  // Xóa toàn bộ giỏ hàng
  const btnClear = document.getElementById('btnClearCart');
  if (btnClear) {
    btnClear.addEventListener('click', () => {
      if (confirm('Bạn có chắc chắn muốn xóa toàn bộ giỏ hàng?')) {
        window.VietjetCart.clearCart();
        renderCartItems();
        window.VietjetUI.showToast('Đã dọn sạch giỏ hàng!', 'info');
      }
    });
  }

  // Submit form thông tin khách hàng
  const form = document.getElementById('checkoutForm');
  if (form) {
    form.addEventListener('submit', (e) => {
      e.preventDefault();

      const items = window.VietjetCart.getItems();
      if (items.length === 0) {
        window.VietjetUI.showToast('Giỏ hàng trống! Vui lòng chọn chuyến bay hoặc tour trước.', 'error');
        return;
      }

      const name = document.getElementById('custName').value.trim();
      const phone = document.getElementById('custPhone').value.trim();
      const email = document.getElementById('custEmail').value.trim();
      const idCard = document.getElementById('custIdCard').value.trim();
      const notes = document.getElementById('custNotes').value.trim();
      const totalAmount = window.VietjetCart.getTotal();

      if (!name || !phone || !email || !idCard) {
        window.VietjetUI.showToast('Vui lòng điền đầy đủ các trường thông tin bắt buộc!', 'error');
        return;
      }

      const orderData = {
        name,
        phone,
        email,
        idCard,
        notes,
        totalAmount
      };

      try {
        // 1. Lưu đơn hàng vào database SQLite (bảng orders và order_items)
        const result = window.VietjetDB.createOrder(orderData, items);
        console.log('[Cart] Đơn hàng đã được lưu thành công vào SQLite:', result);

        // 2. Kích hoạt gửi email xác nhận từ nvhai061993@gmail.com
        sendConfirmationEmail(result.orderCode, orderData, items);

        // 3. Hiển thị popup modal thông báo hoàn tất
        showOrderSuccessModal(result.orderCode, email);

        // 4. Xóa sạch giỏ hàng
        window.VietjetCart.clearCart();
        renderCartItems();

      } catch (err) {
        console.error('[Cart] Lỗi lưu đơn hàng:', err);
        window.VietjetUI.showToast('Có lỗi xảy ra khi tạo đơn hàng trên SQLite!', 'error');
      }
    });
  }
}

/**
 * Giả lập và gửi email xác nhận từ nvhai061993@gmail.com đến khách hàng
 */
function sendConfirmationEmail(orderCode, orderData, items) {
  const senderEmail = 'nvhai061993@gmail.com';
  const recipientEmail = orderData.email;
  const subject = `[Vietjet Travel] Xác nhận đặt chỗ thành công - Mã đơn: ${orderCode}`;

  console.log(`=======================================================`);
  console.log(`[EMAIL DISPATCHER] ĐANG GỬI EMAIL XÁC NHẬN TỰ ĐỘNG`);
  console.log(`Từ (Sender):      ${senderEmail}`);
  console.log(`Đến (Recipient):  ${recipientEmail}`);
  console.log(`Tiêu đề:          ${subject}`);
  console.log(`Mã đặt chỗ:       ${orderCode}`);
  console.log(`Khách hàng:       ${orderData.name} - SĐT: ${orderData.phone}`);
  console.log(`Tổng thanh toán:  ${window.VietjetUI.formatVND(orderData.totalAmount)}`);
  console.log(`Số lượng mục đặt: ${items.length}`);
  console.log(`=======================================================`);
}

/**
 * Hiển thị Popup chúc mừng
 */
function showOrderSuccessModal(orderCode, customerEmail) {
  const modal = document.getElementById('orderSuccessModal');
  const codeDisplay = document.getElementById('modalBookingCode');
  const emailDisplay = document.getElementById('modalCustomerEmail');
  const subjectDisplay = document.getElementById('modalEmailSubject');

  if (codeDisplay) codeDisplay.textContent = orderCode;
  if (emailDisplay) emailDisplay.textContent = customerEmail;
  if (subjectDisplay) subjectDisplay.textContent = `[Vietjet Travel] Xác nhận đặt chỗ thành công - Mã đơn: ${orderCode}`;

  if (modal) {
    modal.classList.add('active');
  }
}
