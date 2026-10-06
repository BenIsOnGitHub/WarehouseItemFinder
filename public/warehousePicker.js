class HeaderWarehousePicker {
  constructor() {
    this.searchInput = document.getElementById('warehouse-search-input');
    this.resultsList = document.getElementById('warehouse-search-results');
    this.badgeText = document.getElementById('active-warehouse-text');
    this.favBtn = document.getElementById('set-favorite-btn');
    this.allWarehouses = [];
    this.selectedWarehouse = null;
    this.STORAGE_KEY = 'favorite_warehouse_id';
  }

  async init() {
    if (!this.searchInput || !this.resultsList) return;
    try {
      const response = await fetch('/api/warehouses');
      this.allWarehouses = await response.json();
      this.attachEvents();
      this.loadInitialWarehouse();
    } catch (err) {
      console.error('Failed to load warehouses:', err);
      if (this.badgeText) this.badgeText.textContent = 'Select a Warehouse';
    }
  }

  attachEvents() {
    this.searchInput.addEventListener('input', (e) => {
      const query = e.target.value.trim().toLowerCase();
      if (!query) {
        this.resultsList.hidden = true;
        return;
      }

      const matches = this.allWarehouses.filter(w =>
        String(w.warehouse_id).toLowerCase().includes(query) ||
        String(w.warehouse_name || '').toLowerCase().includes(query) ||
        String(w.city || '').toLowerCase().includes(query) ||
        String(w.state || '').toLowerCase().includes(query)
      ).slice(0, 8);

      this.resultsList.innerHTML = matches.map(w => `
        <li data-id="${w.warehouse_id}">
          #${w.warehouse_id} - ${w.warehouse_name || 'Warehouse'} (${w.city || ''}, ${w.state || ''})
        </li>
      `).join('');

      this.resultsList.hidden = matches.length === 0;
    });

    this.resultsList.addEventListener('click', (e) => {
      const li = e.target.closest('li');
      if (!li) return;
      const id = li.dataset.id;
      const warehouse = this.allWarehouses.find(w => String(w.warehouse_id) === String(id));
      if (warehouse) this.selectWarehouse(warehouse);
      this.resultsList.hidden = true;
      this.searchInput.value = '';
    });

    if (this.favBtn) {
      this.favBtn.addEventListener('click', () => {
        if (this.selectedWarehouse) {
          localStorage.setItem(this.STORAGE_KEY, this.selectedWarehouse.warehouse_id);
          alert(`Saved Warehouse #${this.selectedWarehouse.warehouse_id} as favorite!`);
        }
      });
    }

    // Hide dropdown when clicking outside
    document.addEventListener('click', (e) => {
      if (!this.searchInput.contains(e.target) && !this.resultsList.contains(e.target)) {
        this.resultsList.hidden = true;
      }
    });
  }

  selectWarehouse(warehouse) {
    this.selectedWarehouse = warehouse;
    if (this.badgeText) {
      this.badgeText.textContent = `#${warehouse.warehouse_id} - ${warehouse.warehouse_name || 'Warehouse'}`;
    }
    if (typeof onWarehouseChange === 'function') {
      onWarehouseChange(warehouse.warehouse_id);
    }
  }

  loadInitialWarehouse() {
    const favId = localStorage.getItem(this.STORAGE_KEY) || localStorage.getItem('selected_warehouse');
    if (favId) {
      const warehouse = this.allWarehouses.find(w => String(w.warehouse_id) === String(favId));
      if (warehouse) {
        this.selectWarehouse(warehouse);
        return;
      }
    }
    if (this.badgeText) {
      this.badgeText.textContent = 'Select a Warehouse';
    }
  }
}

document.addEventListener('DOMContentLoaded', () => {
  const picker = new HeaderWarehousePicker();
  picker.init();
});