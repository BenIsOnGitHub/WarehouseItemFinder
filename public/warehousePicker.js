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
      let parsed = JSON.parse(savedWarehouse);

      // Handle primitive numbers/strings stored in localStorage
      if (typeof parsed === 'string' || typeof parsed === 'number') {
        parsed = { warehouse_id: String(parsed) };
      }

      if (parsed && (parsed.warehouse_id || parsed.id)) {
        const warehouseId = String(parsed.warehouse_id || parsed.id);

        // 1. Hydrate global state variable
        if (typeof CURRENT_WAREHOUSE !== 'undefined') {
          CURRENT_WAREHOUSE = warehouseId;
        }

        // 2. Fetch warehouse list to get full details if name/city is missing
        if (!parsed.warehouse_name && !parsed.name && !parsed.city) {
          const warehouses = await fetchWarehouses();
          const match = warehouses.find(w => String(w.warehouse_id) === warehouseId);
          if (match) {
            parsed = match;
            localStorage.setItem('selected_warehouse', JSON.stringify(match));
          }
        }

        // 3. Render header UI & unlock product search
        displayWarehouse(parsed);
        enableProductSearch();

        // 4. Force hide popover cleanly BEFORE any callbacks
        hideSearchPopover();

        return; // EXIT EARLY — NEVER CALL showSearchPopover() OR onWarehouseChange() ON BOOT!
      }
    } catch (e) {
      console.error("❌ Invalid stored warehouse JSON, clearing...", e);
      localStorage.removeItem('selected_warehouse');
    }
  }

  // --- NO WAREHOUSE SET (Only runs when localStorage is empty) ---
  if (typeof CURRENT_WAREHOUSE !== 'undefined') {
    CURRENT_WAREHOUSE = null;
  }
  
  disableProductSearch("Select a warehouse above to search products");
  showSearchPopover(); 
  await fetchWarehouses();
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

  // 1. Immediate 5-Digit ZIP Geocoding (e.g., 34472)
  if (/^\d{5}$/.test(term)) {
    const coords = await geocodeSearchQuery(term);
    if (coords) {
      await showWarehousesByDistance(coords.lat, coords.lng);
    } else {
      // If ZIP lookup fails, fall back to local text matches
      await showLocalMatches(term);
    }
    return;
  }

  // 2. Local Text Search (shows all matching stores in dropdown without auto-selecting)
  await showLocalMatches(term);

  // 3. Text query geocoding fallback for non-ZIP queries (e.g., "Ocala, FL") after pause
  if (!/^\d+$/.test(term) && term.length >= 3) {
    debounceTimer = setTimeout(async () => {
      const coords = await geocodeSearchQuery(term);
      if (coords) {
        await showWarehousesByDistance(coords.lat, coords.lng);
      }
    }, 600);
  }
}


// --- SHOW LOCAL TEXT MATCHES IN DROPDOWN ---
async function showLocalMatches(term) {
  const warehouses = await fetchWarehouses();
  const resultsContainer = getOrCreateResultsContainer();
  const isNumeric = /^\d+$/.test(term);

  const matches = warehouses.filter(w => {
    const name = (w.warehouse_name || '').toLowerCase();
    const city = (w.city || '').toLowerCase();
    const state = (w.state || '').toLowerCase();
    const id = String(w.warehouse_id || '').toLowerCase();
    const zip = String(w.zip_code || '').toLowerCase();
    const street = (w.street_address || '').toLowerCase();

    if (isNumeric) {
      // 1. Always match exact Warehouse ID or starting ZIP code digits (e.g. "344", "3447")
      if (id === term || zip.startsWith(term)) {
        return true;
      }

      // 2. ONLY check street address if the number is 5 digits long (e.g. a full street number)
      // This stops partial ZIP entries like "344" from pulling up "344 N Main St" in Celina, TX
      if (term.length >= 5) {
        return street.includes(term);
      }

      return false;
    }

    return (
      name.includes(term) ||
      city.includes(term) ||
      state.includes(term) ||
      street.includes(term)
    );
  });

  // Renders matches in dropdown — nothing is auto-selected
  renderSearchResults(matches, resultsContainer, false);
}


// --- SORT ALL WAREHOUSES BY DISTANCE & SHOW TOP RESULTS IN DROPDOWN ---
async function showWarehousesByDistance(userLat, userLng) {
  console.log(`📐 [DEBUG] Sorting warehouses by distance to lat: ${userLat}, lng: ${userLng}`);

  const warehouses = await fetchWarehouses();
  const resultsContainer = getOrCreateResultsContainer();

  if (!Array.isArray(warehouses) || warehouses.length === 0) {
    return;
  }

  // Calculate distance for all valid warehouses
  const warehousesWithDistance = warehouses
    .map(store => {
      const lat = parseFloat(store.lat);
      const lng = parseFloat(store.lng);
      if (!isNaN(lat) && !isNaN(lng)) {
        const dist = haversineDistance(userLat, userLng, lat, lng);
        return { ...store, distance: dist };
      }
      return null;
    })
    .filter(store => store !== null);

  // Sort ascending by distance (closest first)
  warehousesWithDistance.sort((a, b) => a.distance - b.distance);

  // ✅ FIX: Pass `resultsContainer` as the 2nd parameter!
  renderSearchResults(warehousesWithDistance.slice(0, 10), resultsContainer, true);
}

// --- RENDER SEARCH RESULTS LIST ---
function renderSearchResults(matches, container, showDistance = false) {
  container.innerHTML = '';

  if (!matches || matches.length === 0) {
    container.hidden = true;
    container.style.display = 'none';
    return;
  }

  // Limit to top 10 matches and append <li> elements directly to container (no nested <ul>)
  matches.slice(0, 10).forEach(store => {
    const item = document.createElement('li');
    const storeName = store.warehouse_name || `${store.city}, ${store.state}`;
    const storeId = store.warehouse_id;

    // Show distance tag if sorted by coordinates
    const distanceTag = (showDistance && typeof store.distance === 'number') 
      ? `<span style="float: right; color: #666; font-size: 0.85em;">${store.distance.toFixed(1)} mi</span>`
      : '';

    item.style.cssText = 'padding: 8px 12px; cursor: pointer; border-bottom: 1px solid #eee;';
    item.innerHTML = `${storeName} ${distanceTag}`;

    item.addEventListener('click', () => {
      selectWarehouse(store);
      hideSearchPopover();
    });

    container.appendChild(item);
  });

  // 1. Unhide results list element (clears both [hidden] attribute and display rule)
  container.hidden = false;
  container.style.display = 'block';

  // 2. Unhide parent popover wrapper
  const popover = document.getElementById('warehouse-search-popover');
  if (popover) {
    popover.hidden = false;
    popover.style.display = 'block';
  }
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
  console.log('🔍 [DEBUG] Starting geocodeSearchQuery for query:', query);

  // 1. Check 5-digit ZIP via Zippopotam
  if (/^\d{5}$/.test(query)) {
    try {
      console.log('📍 [DEBUG] Query recognized as 5-digit ZIP code. Querying Zippopotam API...');
      const zipRes = await fetch(`https://api.zippopotam.us/us/${query}`);
      if (zipRes.ok) {
        const zipData = await zipRes.json();
        if (zipData.places && zipData.places.length > 0) {
          const lat = parseFloat(zipData.places[0].latitude);
          const lng = parseFloat(zipData.places[0].longitude);
          console.log(`✅ [DEBUG] Zippopotam succeeded! Resolved ${query} to lat: ${lat}, lng: ${lng}`);
          return { lat, lng };
        }
      }
      console.warn('⚠️ [DEBUG] Zippopotam response was not ok or contained no places.');
    } catch (e) {
      console.error('❌ [DEBUG] Zippopotam fetch failed:', e);
    }
  }

  // 2. OpenStreetMap Nominatim Fallback
  try {
    console.log('🌐 [DEBUG] Querying Nominatim OpenStreetMap API for query:', query);
    const url = `https://nominatim.openstreetmap.org/search?format=json&countrycodes=us&q=${encodeURIComponent(query)}`;
    const response = await fetch(url, {
      headers: { 'User-Agent': 'WarehousePickerApp/1.0' }
    });

    if (!response.ok) {
      console.error('❌ [DEBUG] Nominatim HTTP error:', response.status);
      return null;
    }

    const results = await response.json();
    if (results && results.length > 0) {
      const lat = parseFloat(results[0].lat);
      const lng = parseFloat(results[0].lon);
      console.log(`✅ [DEBUG] Nominatim succeeded! Resolved "${query}" to lat: ${lat}, lng: ${lng}`);
      return { lat, lng };
    } else {
      console.warn('⚠️ [DEBUG] Nominatim returned 0 matching results for query:', query);
    }
    return null;
  } catch (err) {
    console.error('❌ [DEBUG] Nominatim geocode exception:', err);
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
  await showWarehousesByDistance(userLat, userLng);
}

// --- SELECTION & UI HELPERS ---
function selectWarehouse(store) {
  const warehouseId = store.warehouse_id;

  // 1. Save to localStorage & update DOM header text
  localStorage.setItem('selected_warehouse', JSON.stringify(store));
  displayWarehouse(store);

  // 2. Unlock product search inputs & buttons
  enableProductSearch();

  // 3. Notify the rest of your app's logic of the active warehouse ID
  if (typeof onWarehouseChange === 'function') {
    onWarehouseChange(store);
  } else if (typeof CURRENT_WAREHOUSE !== 'undefined') {
    CURRENT_WAREHOUSE = warehouseId;
  }

  // 4. Close the warehouse search popover
  hideSearchPopover();
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
    popover.style.display = 'block';
    const input = document.getElementById('warehouse-search-input');
    if (input) input.focus();
  }
}

function hideSearchPopover() {
  const popover = document.getElementById('warehouse-search-popover');
  const resultsContainer = document.getElementById('warehouse-search-results');
  const searchInput = document.getElementById('warehouse-search-input');

  if (popover) {
    popover.hidden = true;
    popover.style.display = 'none';
  }
  if (resultsContainer) {
    resultsContainer.innerHTML = '';
    resultsContainer.style.display = 'none';
  }
  if (searchInput) {
    searchInput.value = '';
  }
}

function getOrCreateResultsContainer() {
  let container = document.getElementById('warehouse-search-results');
  if (!container) {
    const popover = document.getElementById('warehouse-search-popover');
    container = document.createElement('div');
    container.id = 'warehouse-search-results';
    // Single container handles scrolling and height limit
    container.style.cssText = 'background: #fff; border: 1px solid #ccc; border-top: none; max-height: 250px; overflow-y: auto;';
    if (popover) popover.appendChild(container);
  }
  return container;
}