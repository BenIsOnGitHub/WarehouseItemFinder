// --- CONFIGURATION & API ---
const API_BASE_URL = 'https://warehouse-item-finder.pant.workers.dev';

const geoOptions = {
  enableHighAccuracy: true,
  timeout: 10000,
  maximumAge: 60000
};

// --- INITIALIZATION ---
document.addEventListener('DOMContentLoaded', () => {
  // 1. Initialize warehouse selection from localStorage or geolocation
  initWarehouseSelection();

  // 2. Attach click listener to "Set Warehouse" button in HTML
  const setWarehouseBtn = document.getElementById('warehouse-selector-btn');
  if (setWarehouseBtn) {
    setWarehouseBtn.addEventListener('click', (e) => {
      e.preventDefault();
      
      // If search popover exists, toggle it; otherwise attempt geolocation search
      const popover = document.getElementById('warehouse-search-popover');
      if (popover) {
        popover.hidden = !popover.hidden;
        if (!popover.hidden) {
          const searchInput = document.getElementById('warehouse-search-input');
          if (searchInput) searchInput.focus();
        }
      } else {
        handleLocateUser();
      }
    });
  }
});

// --- CORE GEOLOCATION HANDLER ---
async function handleLocateUser() {
  if (!navigator.geolocation) {
    showSearchPopover();
    return;
  }

  // Check permission status via Permissions API if available
  if (navigator.permissions && navigator.permissions.query) {
    try {
      const status = await navigator.permissions.query({ name: 'geolocation' });
      if (status.state === 'denied') {
        showSearchPopover();
        return;
      }
    } catch (e) {
      // Permissions API not supported, fall through to getCurrentPosition
    }
  }

  // Trigger Geolocation
  navigator.geolocation.getCurrentPosition(
    (position) => {
      const { latitude, longitude } = position.coords;
      findAndSetNearestWarehouse(latitude, longitude);
    },
    (error) => {
      console.warn(`Geolocation error (${error.code}): ${error.message}`);
      showSearchPopover();
    },
    geoOptions
  );
}

// --- INITIAL LOAD CHECK ---
async function initWarehouseSelection() {
  const savedWarehouse = localStorage.getItem('selected_warehouse');
  
  if (savedWarehouse) {
    // If saved as JSON object or plain ID string
    try {
      const parsed = JSON.parse(savedWarehouse);
      if (parsed && typeof parsed === 'object') {
        displayWarehouse(parsed);
        return;
      }
    } catch (e) {
      // Not JSON, likely plain warehouse ID string
    }
    
    // Fetch warehouse details by ID if needed, or run location detection
    handleLocateUser();
  } else {
    // No saved warehouse found -> auto-detect via GPS
    handleLocateUser();
  }
}

// --- UI HELPERS ---
function showSearchPopover() {
  const popover = document.getElementById('warehouse-search-popover');
  if (popover) {
    popover.hidden = false;
    const input = document.getElementById('warehouse-search-input');
    if (input) input.focus();
  }
}

function displayWarehouse(warehouse) {
  const warehouseTextEl = document.getElementById('active-warehouse-text');
  if (warehouseTextEl) {
    const label = warehouse.warehouse_name || warehouse.name || `${warehouse.city || 'Warehouse'}, ${warehouse.state || warehouse.warehouse_id || ''}`;
    warehouseTextEl.textContent = label;
  }
}

// --- HAVERSINE DISTANCE CALCULATOR ---
function haversineDistance(lat1, lon1, lat2, lon2) {
  const R = 3958.8; // Earth's radius in miles
  const dLat = (lat2 - lat1) * Math.PI / 180;
  const dLon = (lon2 - lon1) * Math.PI / 180;
  const a = 
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) * 
    Math.sin(dLon / 2) * Math.sin(dLon / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return R * c;
}

// --- NEAREST WAREHOUSE SEARCH ---
async function findAndSetNearestWarehouse(userLat, userLng) {
  try {
    const response = await fetch(`${API_BASE_URL}/api/warehouses`);
    const warehouses = await response.json();

    if (!Array.isArray(warehouses) || warehouses.length === 0) {
      showSearchPopover();
      return;
    }

    let nearest = null;
    let minDistance = Infinity;

    warehouses.forEach(store => {
      // Check latitude and longitude properties from API
      const lat = store.lat || store.latitude;
      const lng = store.lng || store.longitude;

      if (lat && lng) {
        const dist = haversineDistance(userLat, userLng, parseFloat(lat), parseFloat(lng));
        if (dist < minDistance) {
          minDistance = dist;
          nearest = store;
        }
      }
    });

    if (nearest) {
      localStorage.setItem('selected_warehouse', JSON.stringify(nearest));
      displayWarehouse(nearest);
      
      // Update global variable in app.js if present
      if (typeof CURRENT_WAREHOUSE !== 'undefined') {
        CURRENT_WAREHOUSE = nearest.warehouse_id || nearest.id;
      }
    } else {
      showSearchPopover();
    }
  } catch (err) {
    console.error("Failed to fetch warehouses for location match:", err);
    showSearchPopover();
  }
}