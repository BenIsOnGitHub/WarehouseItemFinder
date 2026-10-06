// --- CONFIGURATION & OPTIONS ---
const geoOptions = {
  enableHighAccuracy: true,
  timeout: 10000,
  maximumAge: 60000
};

// --- INITIALIZATION ---
document.addEventListener('DOMContentLoaded', () => {
  // 1. Initialize warehouse selection from localStorage or auto-locate
  initWarehouseSelection();

  // 2. Attach click listener to "Set Warehouse" button
  const setWarehouseBtn = document.getElementById('set-warehouse-btn');
  if (setWarehouseBtn) {
    setWarehouseBtn.addEventListener('click', (e) => {
      e.preventDefault();
      // When clicked, try geolocation or open search modal
      handleLocateUser();
    });
  }

  // 3. Attach click listener to Hamburger Menu (if present)
  const menuBtn = document.getElementById('menu-btn');
  const navDrawer = document.getElementById('nav-drawer');
  if (menuBtn && navDrawer) {
    menuBtn.addEventListener('click', () => {
      navDrawer.classList.toggle('active');
    });
  }
});

// --- CORE GEOLOCATION HANDLER ---
async function handleLocateUser() {
  if (!navigator.geolocation) {
    showSearchModal("Geolocation is not supported by your browser. Enter ZIP or City:");
    return;
  }

  // Check current permission status via Permissions API
  if (navigator.permissions && navigator.permissions.query) {
    try {
      const status = await navigator.permissions.query({ name: 'geolocation' });
      if (status.state === 'denied') {
        showSearchModal("Location access is blocked. Enter ZIP or City:");
        return;
      }
    } catch (e) {
      // Permissions API not supported in all browsers, proceed to getCurrentPosition
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
      // Fall back to manual input modal when GPS lock fails or times out
      showSearchModal("Could not detect location automatically. Enter ZIP or City:");
    },
    geoOptions
  );
}

// --- INITIAL LOAD CHECK ---
function initWarehouseSelection() {
  const savedWarehouse = localStorage.getItem('selected_warehouse');
  
  if (savedWarehouse) {
    displayWarehouse(JSON.parse(savedWarehouse));
  } else {
    // If no warehouse saved, attempt automatic GPS lookup on first visit
    handleLocateUser();
  }
}

// --- UI HELPERS & MODAL HANDLERS ---
function showSearchModal(message = "Search for a Costco Warehouse:") {
  const modal = document.getElementById('warehouse-modal');
  const messageEl = document.getElementById('modal-message');
  
  if (messageEl) messageEl.textContent = message;
  if (modal) modal.classList.add('active');
}

function displayWarehouse(warehouse) {
  const warehouseNameEl = document.getElementById('current-warehouse-name');
  if (warehouseNameEl) {
    warehouseNameEl.textContent = `${warehouse.city}, ${warehouse.state}`;
  }
}

// --- HA VERSINE DISTANCE & NEAREST CALCULATOR ---
function haversineDistance(lat1, lon1, lat2, lon2) {
  const R = 3958.8; // Radius of Earth in miles
  const dLat = (lat2 - lat1) * Math.PI / 180;
  const dLon = (lon2 - lon1) * Math.PI / 180;
  const a = 
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) * 
    Math.sin(dLon / 2) * Math.sin(dLon / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return R * c;
}

async function findAndSetNearestWarehouse(userLat, userLng) {
  try {
    // Fetch warehouses array from API endpoint or local store
    const response = await fetch('/api/warehouses');
    const warehouses = await response.json();

    let nearest = null;
    let minDistance = Infinity;

    warehouses.forEach(store => {
      if (store.lat && store.lng) {
        const dist = haversineDistance(userLat, userLng, store.lat, store.lng);
        if (dist < minDistance) {
          minDistance = dist;
          nearest = store;
        }
      }
    });

    if (nearest) {
      localStorage.setItem('selected_warehouse', JSON.stringify(nearest));
      displayWarehouse(nearest);
      
      // Close modal if open
      const modal = document.getElementById('warehouse-modal');
      if (modal) modal.classList.remove('active');
    } else {
      showSearchModal("No warehouses found nearby. Search manually:");
    }
  } catch (err) {
    console.error("Failed to fetch warehouses for location match:", err);
    showSearchModal("Enter ZIP or City to find nearest store:");
  }
}