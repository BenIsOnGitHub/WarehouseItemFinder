class HeaderWarehousePicker {
  constructor() {
    this.selectorBtn = document.getElementById('warehouse-selector-btn');
    this.badgeText = document.getElementById('active-warehouse-text');
    this.popover = document.getElementById('warehouse-search-popover');
    this.searchInput = document.getElementById('warehouse-search-input');
    this.resultsList = document.getElementById('warehouse-search-results');

    this.allWarehouses = [];
    this.selectedWarehouse = null;
    this.STORAGE_KEY = 'favorite_warehouse_id';
  }

  async init() {
    try {
      const response = await fetch('/api/warehouses');
      this.allWarehouses = await response.json();
      this.attachEvents();
      this.loadInitialWarehouse();
    } catch (err) {
      console.error('Failed to load warehouses:', err);
      if (this.badgeText) this.badgeText.textContent = 'Set Warehouse';
    }
  }

  attachEvents() {
    // Toggle popover visibility on click
    if (this.selectorBtn) {
      this.selectorBtn.addEventListener('click', () => {
        const isHidden = this.popover.hidden;
        this.popover.hidden = !isHidden;
        if (!this.popover.hidden) {
          this.searchInput.focus();
        }
      });
    }

    // Filter warehouse results
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

    // Select warehouse from dropdown
    this.resultsList.addEventListener('click', (e) => {
      const li = e.target.closest('li');
      if (!li) return;
      const id = li.dataset.id;
      const warehouse = this.allWarehouses.find(w => String(w.warehouse_id) === String(id));
      if (warehouse) {
        this.selectWarehouse(warehouse);
      }
      this.popover.hidden = true;
      this.resultsList.hidden = true;
      this.searchInput.value = '';
    });

    // Close popover when clicking outside
    document.addEventListener('click', (e) => {
      if (
        this.popover &&
        !this.popover.contains(e.target) &&
        !this.selectorBtn.contains(e.target)
      ) {
        this.popover.hidden = true;
      }
    });
  }

  selectWarehouse(warehouse) {
    this.selectedWarehouse = warehouse;

    // Automatically save as favorite / default
    localStorage.setItem(this.STORAGE_KEY, warehouse.warehouse_id);

    if (this.badgeText) {
      this.badgeText.textContent = warehouse.warehouse_name || `#${warehouse.warehouse_id}`;
    }

    if (typeof onWarehouseChange === 'function') {
      onWarehouseChange(warehouse.warehouse_id);
    }
  }

  loadInitialWarehouse() {
    const savedId = localStorage.getItem(this.STORAGE_KEY);
    if (savedId) {
      const warehouse = this.allWarehouses.find(w => String(w.warehouse_id) === String(savedId));
      if (warehouse) {
        this.selectWarehouse(warehouse);
        return;
      }
    }

    // If no favorite is set, prompt for location to find nearest store
    this.detectNearestWarehouse();
  }

  detectNearestWarehouse() {
    if (!('geolocation' in navigator)) {
      if (this.badgeText) this.badgeText.textContent = 'Set Warehouse';
      return;
    }

    if (this.badgeText) this.badgeText.textContent = 'Locating nearest store...';

    navigator.geolocation.getCurrentPosition(
      (position) => {
        const userLat = position.coords.latitude;
        const userLon = position.coords.longitude;
        const nearest = this.findNearestStore(userLat, userLon);

        if (nearest) {
          this.selectWarehouse(nearest);
        } else if (this.badgeText) {
          this.badgeText.textContent = 'Set Warehouse';
        }
      },
      (error) => {
        console.warn('Geolocation access denied or unavailable:', error.message);
        if (this.badgeText) this.badgeText.textContent = 'Set Warehouse';
      },
      { timeout: 10000, enableHighAccuracy: false }
    );
  }

  findNearestStore(userLat, userLon) {
    let nearest = null;
    let minDistance = Infinity;

    for (const w of this.allWarehouses) {
      const lat = parseFloat(w.latitude);
      const lon = parseFloat(w.longitude);

      if (!isNaN(lat) && !isNaN(lon)) {
        const dist = this.haversineDistanceMiles(userLat, userLon, lat, lon);
        if (dist < minDistance) {
          minDistance = dist;
          nearest = w;
        }
      }
    }

    return nearest;
  }

  haversineDistanceMiles(lat1, lon1, lat2, lon2) {
    const R = 3958.8; // Earth radius in miles
    const dLat = (lat2 - lat1) * Math.PI / 180;
    const dLon = (lon2 - lon1) * Math.PI / 180;
    const a =
      Math.sin(dLat / 2) * Math.sin(dLat / 2) +
      Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) *
      Math.sin(dLon / 2) * Math.sin(dLon / 2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    return R * c;
  }
}

document.addEventListener('DOMContentLoaded', () => {
  const picker = new HeaderWarehousePicker();
  picker.init();
});