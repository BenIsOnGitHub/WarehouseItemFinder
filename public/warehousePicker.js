// --- CONFIGURATION ---
const API_BASE_URL = 'https://warehouse-item-finder.pant.workers.dev';

const geoOptions = {
  enableHighAccuracy: true,
  timeout: 10000,
  maximumAge: 60000
};

let cachedWarehouses = [];
let debounceTimer = null;

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

  // 3. Attach search listeners to search input
  const searchInput = document.getElementById('warehouse-search-input');
  if (searchInput) {
    // Live filter as user types
    searchInput.addEventListener('input', (e) => {
      handleSearchInput(e.target.value);
    });

    // Execute geocode/nearest lookup on Enter key press
    searchInput.addEventListener('keydown', async (e) => {
      if (e.key === 'Enter') {
        e.preventDefault();
        const query = e.target.value.trim();
        if (query) {
          await handleWarehouseSearch(query);
        }
      }
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

  // Fetch warehouses into cache right away on load
  await fetchWarehouses();

  // No saved store found -> perform geolocation check
  handleLocateUser();
}

// --- GEOLOCATION HANDLER ---
async function handleLocateUser() {
  if (window.location.protocol !== 'https:' && window.location.hostname !== 'localhost') {
    showSearchPopover();
    return;
  }

  if (!navigator.geolocation) {
    showSearchPopover();
    return;
  }

  navigator.geolocation.getCurrentPosition(
    (position) => {
      const { latitude, longitude } = position.coords;
      findAndSetNearestWarehouse(latitude, longitude);
    },
    () => {
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

// --- LIVE TYPING SEARCH FILTERING ---
async function handleSearchInput(query) {
  const term = query.trim().toLowerCase();
  const resultsContainer = getOrCreateResultsContainer();

  clearTimeout(debounceTimer);

  if (!term) {
    resultsContainer.innerHTML = '';
    resultsContainer.style.display = 'none';
    return;
  }

  const warehouses = await fetchWarehouses();

  // 1. Direct text match across local database fields
  const matches = warehouses.filter(w => {
    const name = (w.warehouse_name || '').toLowerCase();
    const city = (w.city || '').toLowerCase();
    const state = (w.state || '').toLowerCase();
    const id = String(w.warehouse_id || '').toLowerCase();
    const zip = String(w.zip_code || '').toLowerCase();
    const street = (w.street_address || '').toLowerCase();

    return (
      name.includes(term) ||
      city.includes(term) ||
      state.includes(term) ||
      id.includes(term) ||
      zip.includes(term) ||
      street.includes(term)
    );
  });

  if (matches.length > 0) {
    renderSearchResults(matches, resultsContainer);
    return;
  }

  // Hide local dropdown list
  resultsContainer.style.display = 'none';

  // 2. Immediate Zip Code Check (5 Digits)
  // If the user typed exactly 5 numbers (e.g. 34472), skip the delay and geocode immediately
  if (/^\d{5}$/.test(term)) {
    const coords = await geocodeSearchQuery(term);
    if (coords) {
      await findAndSetNearestWarehouse(coords.lat, coords.lng);
    }
    return;
  }

  // 3. Text query fallback for cities/states (e.g., "Ocala")
  if (term.length >= 3) {
    debounceTimer = setTimeout(async () => {
      const coords = await geocodeSearchQuery(term);
      if (coords) {
        await findAndSetNearestWarehouse(coords.lat, coords.lng);
      }
    }, 500);
  }
}

function renderSearchResults(matches, container) {
  container.innerHTML = '';

  if (matches.length === 0) {
    container.style.display = 'none';
    return;
  }

  const list = document.createElement('ul');
  list.style.cssText = 'list-style: none; margin: 0; padding: 0; max-height: 200px; overflow-y: auto;';

  matches.slice(0, 10).forEach(store => {
    const item = document.createElement('li');
    const storeName = store.warehouse_name || `${store.city}, ${store.state}`;
    const storeId = store.warehouse_id;

    item.style.cssText = 'padding: 8px 12px; cursor: pointer; border-bottom: 1px solid #eee;';
    item.textContent = `${storeName}`;

    item.addEventListener('click', () => {
      selectWarehouse(store);
      hideSearchPopover();
    });

    list.appendChild(item);
  });

  container.appendChild(list);
  container.style.display = 'block';
}

// --- SEARCH SUBMIT HANDLER (ENTER KEY) ---
async function handleWarehouseSearch(searchInput) {
  const query = searchInput.trim();
  if (!query) return;

  const warehouses = await fetchWarehouses();

  // Direct match check
  const directMatch = warehouses.find(w => 
    String(w.warehouse_id || '').toLowerCase() === query.toLowerCase() ||
    String(w.warehouse_name || '').toLowerCase().includes(query.toLowerCase()) ||
    String(w.zip_code || '').startsWith(query)
  );

  if (directMatch) {
    selectWarehouse(directMatch);
    hideSearchPopover();
    return;
  }

  // Geocode fallback for cities/ZIPs (e.g. "34472" or "Ocala, FL")
  const coords = await geocodeSearchQuery(query);
  if (coords) {
    await findAndSetNearestWarehouse(coords.lat, coords.lng);
  }
}

// --- GEOCODING LOOKUP WITH ZIP FALLBACK ---
async function geocodeSearchQuery(query) {
  // If query is a 5-digit ZIP code, use Zippopotam API (faster and reliable on mobile networks)
  if (/^\d{5}$/.test(query)) {
    try {
      const zipRes = await fetch(`https://api.zippopotam.us/us/${query}`);
      if (zipRes.ok) {
        const zipData = await zipRes.json();
        if (zipData.places && zipData.places.length > 0) {
          return {
            lat: parseFloat(zipData.places[0].latitude),
            lng: parseFloat(zipData.places[0].longitude)
          };
        }
      }
    } catch (e) {
      // Fall through to Nominatim if Zippopotam fails
    }
  }

  // Standard Nominatim lookup for cities/places
  try {
    const url = `https://nominatim.openstreetmap.org/search?format=json&countrycodes=us&q=${encodeURIComponent(query)}`;
    const response = await fetch(url, {
      headers: { 'User-Agent': 'WarehousePickerApp/1.0' }
    });

    if (!response.ok) return null;
    const results = await response.json();

    if (results && results.length > 0) {
      return {
        lat: parseFloat(results[0].lat),
        lng: parseFloat(results[0].lon)
      };
    }
    return null;
  } catch (err) {
    return null;
  }
}

function haversineDistance(lat1, lon1, lat2, lon2) {
  const R = 3958.8; // Miles
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

  if (!Array.isArray(warehouses) || warehouses.length === 0) {
    showSearchPopover();
    return;
  }

  let nearest = null;
  let minDistance = Infinity;

  warehouses.forEach(store => {
    const lat = parseFloat(store.lat);
    const lng = parseFloat(store.lng);

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
    hideSearchPopover();
  } else {
    showSearchPopover();
  }
}

// --- SELECTION & UI HELPERS ---
function selectWarehouse(warehouse) {
  const warehouseId = String(warehouse.warehouse_id || warehouse.id);
  localStorage.setItem('selected_warehouse', warehouseId);
  displayWarehouse(warehouse);

  if (typeof onWarehouseChange === 'function') {
    onWarehouseChange(warehouseId);
  } else if (typeof CURRENT_WAREHOUSE !== 'undefined') {
    CURRENT_WAREHOUSE = warehouseId;
  }
}

function displayWarehouse(warehouse) {
  const warehouseTextEl = document.getElementById('active-warehouse-text');
  if (warehouseTextEl) {
    const label = warehouse.warehouse_name || warehouse.name || `${warehouse.city || 'Warehouse'}, ${warehouse.state || ''}`;
    warehouseTextEl.textContent = label;
  }
}

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