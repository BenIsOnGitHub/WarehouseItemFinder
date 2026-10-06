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
    
  // Geocode and find nearest warehouse when pressing Enter
  searchInput.addEventListener('keydown', async (e) => {
    if (e.key === 'Enter') {
      e.preventDefault();
      const query = e.target.value.trim();
      if (query) {
        await handleWarehouseSearch(query);
        hideSearchPopover();
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

  // No saved store found -> perform geolocation check (no hardcoded default)
  handleLocateUser();
}

// --- GEOLOCATION HANDLER ---
async function handleLocateUser() {
  // Check if HTTPS is being used (Geolocation requires HTTPS or localhost)
  if (window.location.protocol !== 'https:' && window.location.hostname !== 'localhost') {
    console.warn("Geolocation requires HTTPS.");
    showSearchPopover();
    return;
  }

  if (!navigator.geolocation) {
    console.warn("Geolocation not supported by browser.");
    showSearchPopover();
    return;
  }

  navigator.geolocation.getCurrentPosition(
    (position) => {
      const { latitude, longitude } = position.coords;
      console.log(`GPS Acquired: ${latitude}, ${longitude}`);
      findAndSetNearestWarehouse(latitude, longitude);
    },
    (error) => {
      console.warn(`Geolocation error code ${error.code}: ${error.message}`);
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

  // Local text match across database fields
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
  const warehouseId = String(warehouse.warehouse_id || warehouse.id);
  
  localStorage.setItem('selected_warehouse', warehouseId);
  displayWarehouse(warehouse);

  // Sync with app.js state and refresh UI views
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
  const R = 3958.8; // Radius of Earth in miles
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
    console.warn("No warehouses returned from API endpoint.");
    showSearchPopover();
    return;
  }

  let nearest = null;
  let minDistance = Infinity;

  warehouses.forEach(store => {
    // Explicitly parse lat and lng numeric values
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
    console.warn("Could not calculate nearest store — invalid or missing lat/lng in database records.");
    showSearchPopover();
  }
}

async function getCoordsFromZip(zipCode) {
  try {
    const response = await fetch(`https://api.zippopotam.us/us/${zipCode}`);
    if (!response.ok) {
      throw new Error('Invalid ZIP code');
    }
    const data = await response.json();
    const place = data.places[0];
    
    return {
      lat: parseFloat(place.latitude),
      lng: parseFloat(place.longitude)
    };
  } catch (err) {
    console.error('Failed to geocode ZIP code:', err);
    return null;
  }
}

async function handleZipSearch(zipInput) {
  const cleanZip = zipInput.trim();
  
  if (!/^\d{5}$/.test(cleanZip)) {
    alert('Please enter a valid 5-digit US ZIP code.');
    return;
  }

  const coords = await getCoordsFromZip(cleanZip);
  
  if (coords) {
    // Reuses your exact Haversine distance logic!
    await findAndSetNearestWarehouse(coords.lat, coords.lng);
  } else {
    alert('ZIP code not found. Please try another standard 5-digit ZIP code.');
  }
}

async function geocodeSearchQuery(query) {
  try {
    // OpenStreetMap Nominatim geocoding API (free, no API key required)
    const url = `https://nominatim.openstreetmap.org/search?format=json&countrycodes=us&q=${encodeURIComponent(query)}`;
    
    const response = await fetch(url, {
      headers: {
        'User-Agent': 'WarehousePickerApp/1.0' // Nominatim requires a user-agent header
      }
    });

    if (!response.ok) throw new Error('Geocoding request failed');

    const results = await response.json();

    if (results && results.length > 0) {
      return {
        lat: parseFloat(results[0].lat),
        lng: parseFloat(results[0].lon)
      };
    }
    
    return null; // Query couldn't be resolved
  } catch (err) {
    console.error('Error geocoding search query:', err);
    return null;
  }
}

async function handleWarehouseSearch(searchInput) {
  const query = searchInput.trim();
  if (!query) return;

  const warehouses = await fetchWarehouses();

  // 1. First check if input directly matches a warehouse ID or ZIP prefix
  const directMatch = warehouses.find(w => 
    String(w.warehouse_id || '').toLowerCase() === query.toLowerCase() ||
    String(w.zip_code || '').startsWith(query)
  );

  if (directMatch) {
    selectWarehouse(directMatch);
    hideSearchPopover();
    return;
  }

  // 2. Fallback: Geocode ZIP/Address (e.g. 34472) and find closest warehouse by lat/lng
  const coords = await geocodeSearchQuery(query);

  if (coords) {
    await findAndSetNearestWarehouse(coords.lat, coords.lng);
  } else {
    alert('No warehouses found matching that ZIP code, city, or address.');
  }
}