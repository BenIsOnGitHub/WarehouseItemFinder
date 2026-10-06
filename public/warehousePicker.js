// --- CONFIGURATION ---
const API_BASE_URL = 'https://warehouse-item-finder.pant.workers.dev';

const geoOptions = {
  enableHighAccuracy: true,
  timeout: 10000,
  maximumAge: 60000
};

// Store cached warehouses in memory once fetched
let cachedWarehouses = [];

// --- INITIALIZATION ---
document.addEventListener('DOMContentLoaded', () => {
  // 1. Initialize warehouse state on load
  initWarehouseSelection();

  // 2. Setup button click to toggle popover
  const setWarehouseBtn = document.getElementById('warehouse-selector-btn');
  if (setWarehouseBtn) {
    setWarehouseBtn.addEventListener('click', (e) => {
      e.preventDefault();
      toggleSearchPopover();
    });
  }

  // 3. Attach real-time search listener to search input
  const searchInput = document.getElementById('warehouse-search-input');
  if (searchInput) {
    searchInput.addEventListener('input', (e) => {
      handleSearchInput(e.target.value);
    });
  }
});

// --- INITIAL LOAD CHECK ---
async function initWarehouseSelection() {
  const savedWarehouse = localStorage.getItem('selected_warehouse');
  
  if (savedWarehouse) {
    try {
      const parsed = JSON.parse(savedWarehouse);
      if (parsed && typeof parsed === 'object') {
        displayWarehouse(parsed);
        return;
      }
    } catch (e) {
      // Ignore parse error
    }
  }

  // No saved store found -> perform geolocation check (no hardcoded default)
  handleLocateUser();
}

// --- GEOLOCATION HANDLER ---
async function handleLocateUser() {
  if (!navigator.geolocation) {
    console.warn("Geolocation is not supported by this browser.");
    showSearchPopover();
    return;
  }

  navigator.geolocation.getCurrentPosition(
    (position) => {
      const { latitude, longitude } = position.coords;
      findAndSetNearestWarehouse(latitude, longitude);
    },
    (error) => {
      console.warn(`Geolocation failed (${error.code}): ${error.message}`);
      // Prompt user to search manually if GPS permission was denied or timed out
      showSearchPopover();
    },
    geoOptions
  );
}

// --- FETCH & CACHE WAREHOUSES ---
async function fetchWarehouses() {
  if (cachedWarehouses.length > 0) return cachedWarehouses;

  try {
    const response = await fetch(`${API_BASE_URL}/api/warehouses`);
    if (!response.ok) throw new Error(`HTTP ${response.status}`);
    const data = await response.json();
    cachedWarehouses = Array.isArray(data) ? data : (data.warehouses || []);
    return cachedWarehouses;
  } catch (err) {
    console.error("Failed to fetch warehouse list:", err);
    return [];
  }
}

// --- SEARCH FILTERING ---
async function handleSearchInput(query) {
  const term = query.trim().toLowerCase();
  const resultsContainer = getOrCreateResultsContainer();

  if (!term) {
    resultsContainer.innerHTML = '';
    resultsContainer.style.display = 'none';
    return;
  }

  const warehouses = await fetchWarehouses();
  const matches = warehouses.filter(w => {
    const name = (w.warehouse_name || w.name || '').toLowerCase();
    const city = (w.city || '').toLowerCase();
    const state = (w.state || '').toLowerCase();
    const id = String(w.warehouse_id || w.id || '').toLowerCase();

    return name.includes(term) || city.includes(term) || state.includes(term) || id.includes(term);
  });

  renderSearchResults(matches, resultsContainer);
}

function renderSearchResults(matches, container) {
  container.innerHTML = '';

  if (matches.length === 0) {
    container.innerHTML = '<div style="padding: 10px; color: #888;">No matching locations found</div>';
    container.style.display = 'block';
    return;
  }

  const list = document.createElement('ul');
  list.style.cssText = 'list-style: none; margin: 0; padding: 0; max-height: 200px; overflow-y: auto;';

  matches.slice(0, 10).forEach(store => {
    const item = document.createElement('li');
    const storeName = store.warehouse_name || store.name || `${store.city}, ${store.state}`;
    const storeId = store.warehouse_id || store.id;

    item.style.cssText = 'padding: 8px 12px; cursor: pointer; border-bottom: 1px solid #eee;';
    item.textContent = `${storeName} (#${storeId})`;

    item.addEventListener('click', () => {
      selectWarehouse(store);
      hideSearchPopover();
    });

    list.appendChild(item);
  });

  container.appendChild(list);
  container.style.display = 'block';
}

// --- SELECTION & DISPLAY ---
function selectWarehouse(warehouse) {
  localStorage.setItem('selected_warehouse', JSON.stringify(warehouse));
  displayWarehouse(warehouse);

  // Update global variable in app.js if present
  if (typeof CURRENT_WAREHOUSE !== 'undefined') {
    CURRENT_WAREHOUSE = warehouse.warehouse_id || warehouse.id;
  }
}

function displayWarehouse(warehouse) {
  const warehouseTextEl = document.getElementById('active-warehouse-text');
  if (warehouseTextEl) {
    const label = warehouse.warehouse_name || warehouse.name || `${warehouse.city || 'Warehouse'}, ${warehouse.state || ''}`;
    warehouseTextEl.textContent = label;
  }
}

// --- POPOVER & SEARCH CONTAINER HELPERS ---
function toggleSearchPopover() {
  const popover = document.getElementById('warehouse-search-popover');
  if (popover) {
    popover.hidden = !popover.hidden;
    if (!popover.hidden) {
      const input = document.getElementById('warehouse-search-input');
      if (input) input.focus();
    }
  }
}

function showSearchPopover() {
  const popover = document.getElementById('warehouse-search-popover');
  if (popover) {
    popover.hidden = false;
    const input = document.getElementById('warehouse-search-input');
    if (input) input.focus();
  }
}

function hideSearchPopover() {
  const popover = document.getElementById('warehouse-search-popover');
  if (popover) {
    popover.hidden = true;
  }
}

function getOrCreateResultsContainer() {
  let container = document.getElementById('warehouse-search-results');
  if (!container) {
    const popover = document.getElementById('warehouse-search-popover');
    container = document.createElement('div');
    container.id = 'warehouse-search-results';
    container.style.cssText = 'background: #fff; border: 1px solid #ccc; border-top: none; max-height: 220px; overflow-y: auto;';
    if (popover) popover.appendChild(container);
  }
  return container;
}

// --- HAVERSINE DISTANCE & GEOLOCATION MATCH ---
function haversineDistance(lat1, lon1, lat2, lon2) {
  const R = 3958.8; // Radius in miles
  const dLat = (lat2 - lat1) * Math.PI / 180;
  const dLon = (lon2 - lon1) * Math.PI / 180;
  const a = 
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) * 
    Math.sin(dLon / 2) * Math.sin(dLon / 2);
  return R * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
}

async function findAndSetNearestWarehouse(userLat, userLng) {
  const warehouses = await fetchWarehouses();

  if (warehouses.length === 0) {
    showSearchPopover();
    return;
  }

  let nearest = null;
  let minDistance = Infinity;

  warehouses.forEach(store => {
    const lat = parseFloat(store.lat || store.latitude);
    const lng = parseFloat(store.lng || store.longitude);

    if (!isNaN(lat) && !isNaN(lng)) {
      const dist = haversineDistance(userLat, userLng, lat, lng);
      if (dist < minDistance) {
        minDistance = dist;
        nearest = store;
      }
    }
  });

  if (nearest) {
    selectWarehouse(nearest);
  } else {
    showSearchPopover();
  }
}