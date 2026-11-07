/**
 * VIETJET TRAVEL - COMMON UTILITIES & CART ENGINE
 * Xử lý giỏ hàng, thông báo Toast, format tiền tệ và điều hướng Header
 */

window.VietjetCart = {
  STORAGE_KEY: 'vietjet_cart',

  getItems() {
    try {
      const data = localStorage.getItem(this.STORAGE_KEY);
      return data ? JSON.parse(data) : [];
    } catch (e) {
      console.error('[VietjetCart] Lỗi đọc giỏ hàng:', e);
      return [];
    }
  },

  saveItems(items) {
    try {
      localStorage.setItem(this.STORAGE_KEY, JSON.stringify(items));
      this.updateBadge();
    } catch (e) {
      console.error('[VietjetCart] Lỗi lưu giỏ hàng:', e);
    }
  },

  addItem(item) {
    const items = this.getItems();
    // Tạo item ID duy nhất trong giỏ hàng
    item.cartItemId = 'item_' + Date.now() + '_' + Math.floor(Math.random() * 1000);
    if (!item.quantity) item.quantity = 1;
    item.subtotal = item.price * item.quantity;
    
    items.push(item);
    this.saveItems(items);
    this.updateBadge();

    window.VietjetUI.showToast(`Đã thêm "${item.title}" vào giỏ hàng!`, 'success');
  },

  removeItem(cartItemId) {
    let items = this.getItems();
    items = items.filter(i => i.cartItemId !== cartItemId);
    this.saveItems(items);
    this.updateBadge();
  },

  clearCart() {
    localStorage.removeItem(this.STORAGE_KEY);
    this.updateBadge();
  },

  getCount() {
    const items = this.getItems();
    return items.reduce((total, item) => total + (item.quantity || 1), 0);
  },

  getTotal() {
    const items = this.getItems();
    return items.reduce((total, item) => total + ((item.price || 0) * (item.quantity || 1)), 0);
  },

  updateBadge() {
    const count = this.getCount();
    const badges = document.querySelectorAll('.cart-badge');
    badges.forEach(b => {
      b.textContent = count;
      b.style.display = count > 0 ? 'inline-flex' : 'none';
    });
  }
};

window.VietjetUI = {
  formatVND(amount) {
    if (typeof amount !== 'number') amount = Number(amount) || 0;
    return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(amount);
  },

  showToast(message, type = 'success') {
    let container = document.querySelector('.toast-container');
    if (!container) {
      container = document.createElement('div');
      container.className = 'toast-container';
      document.body.appendChild(container);
    }

    const toast = document.createElement('div');
    toast.className = `toast toast-${type}`;
    const iconClass = type === 'success' ? 'fa-circle-check' : (type === 'error' ? 'fa-circle-xmark' : 'fa-circle-info');
    
    toast.innerHTML = `
      <i class="fa-solid ${iconClass}"></i>
      <span>${message}</span>
    `;

    container.appendChild(toast);

    setTimeout(() => {
      toast.style.opacity = '0';
      toast.style.transform = 'translateX(100%)';
      toast.style.transition = 'all 0.3s ease';
      setTimeout(() => toast.remove(), 300);
    }, 3500);
  },

  initNav() {
    // Đánh dấu link active
    const currentPath = window.location.pathname.split('/').pop() || 'index.html';
    document.querySelectorAll('.nav-link').forEach(link => {
      const href = link.getAttribute('href');
      if (href && (href === currentPath || (currentPath === '' && href === 'index.html'))) {
        link.classList.add('active');
      }
    });

    // Mobile menu toggle
    const mobileBtn = document.querySelector('.mobile-menu-btn');
    const mainNav = document.querySelector('.main-nav');
    if (mobileBtn && mainNav) {
      mobileBtn.addEventListener('click', () => {
        if (mainNav.style.display === 'flex') {
          mainNav.style.display = '';
        } else {
          mainNav.style.display = 'flex';
          mainNav.style.flexDirection = 'column';
          mainNav.style.position = 'absolute';
          mainNav.style.top = '76px';
          mainNav.style.left = '0';
          mainNav.style.right = '0';
          mainNav.style.backgroundColor = '#ffffff';
          mainNav.style.padding = '20px';
          mainNav.style.boxShadow = '0 10px 20px rgba(0,0,0,0.1)';
        }
      });
    }

    // Cập nhật số giỏ hàng ban đầu
    window.VietjetCart.updateBadge();
  }
};

document.addEventListener('DOMContentLoaded', () => {
  window.VietjetUI.initNav();
});
