class WarehousePicker {
  constructor(containerIds, onSelectCallback) {
    this.containers = containerIds.map(id => document.getElementById(id)).filter(Boolean);
    this.onSelectCallback = onSelectCallback;
    this.allWarehouses = [];
    this.selectedWarehouse = null;
    this.STORAGE_KEY = 'favorite_warehouse_id';
  }

  async init() {
    this.allWarehouses = await this.fetchWarehouses();
    this.render();
    this.loadFavorite();
  }

  async fetchWarehouses() {
    // API fetch from Cloudflare D1 endpoint
    const response = await fetch('/api/warehouses');
    return await response.json();
  }

  render() {
    const markup = `
      <div class="warehouse-picker-box">
        <label>Warehouse:</label>
        <div class="selected-warehouse-info">
          <span class="selected-name">Select a Warehouse</span>
          <button class="fav-btn" type="button">⭐ Save as Favorite</button>
        </div>
        <input type="text" class="warehouse-search-input" placeholder="Search ID, name, address, city, state, zip..." />
        <ul class="warehouse-results-list" hidden></ul>
      </div>
    `;

    this.containers.forEach(container => {
      container.innerHTML = markup;
      this.attachEvents(container);
    });
  }

  attachEvents(container) {
    const input = container.querySelector('.warehouse-search-input');
    const resultsList = container.querySelector('.warehouse-results-list');
    const favBtn = container.querySelector('.fav-btn');

    input.addEventListener('input', (e) => {
      const query = e.target.value.trim().toLowerCase();
      if (!query) {
        resultsList.hidden = true;
        return;
      }

      const matches = this.allWarehouses.filter(w => 
        String(w.warehouse_id).toLowerCase().includes(query) ||
        String(w.warehouse_name).toLowerCase().includes(query) ||
        String(w.street_address).toLowerCase().includes(query) ||
        String(w.city).toLowerCase().includes(query) ||
        String(w.state).toLowerCase().includes(query) ||
        String(w.zip_code).toLowerCase().includes(query)
      ).slice(0, 10);

      resultsList.innerHTML = matches.map(w => `
        <li data-id="${w.warehouse_id}">
          #${w.warehouse_id} - ${w.warehouse_name} (${w.city}, ${w.state})
        </li>
      `).join('');

      resultsList.hidden = matches.length === 0;
    });

    resultsList.addEventListener('click', (e) => {
      const li = e.target.closest('li');
      if (!li) return;
      const id = li.dataset.id;
      const warehouse = this.allWarehouses.find(w => String(w.warehouse_id) === String(id));
      if (warehouse) this.selectWarehouse(warehouse);
      resultsList.hidden = true;
    });

    favBtn.addEventListener('click', () => {
      if (this.selectedWarehouse) {
        localStorage.setItem(this.STORAGE_KEY, this.selectedWarehouse.warehouse_id);
        alert(`Saved ${this.selectedWarehouse.warehouse_name} as favorite!`);
      }
    });
  }

  selectWarehouse(warehouse) {
    this.selectedWarehouse = warehouse;

    // Sync UI across all picker instances on the page
    document.querySelectorAll('.selected-name').forEach(el => {
      el.textContent = `#${warehouse.warehouse_id} - ${warehouse.warehouse_name} (${warehouse.city}, ${warehouse.state})`;
    });

    if (typeof this.onSelectCallback === 'function') {
      this.onSelectCallback(warehouse.warehouse_id);
    }
  }

  loadFavorite() {
    const favId = localStorage.getItem(this.STORAGE_KEY);
    if (favId) {
      const favorite = this.allWarehouses.find(w => String(w.warehouse_id) === String(favId));
      if (favorite) this.selectWarehouse(favorite);
    }
  }
}

// Initialize on App Load
document.addEventListener('DOMContentLoaded', () => {
  const picker = new WarehousePicker(
    ['search-warehouse-picker-target', 'browse-warehouse-picker-target'],
    (warehouseId) => {
      // Trigger globally existing onWarehouseChange function
      if (typeof onWarehouseChange === 'function') {
        onWarehouseChange(warehouseId);
      }
    }
  );
  picker.init();
});