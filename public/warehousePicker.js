// 1. Triggered explicitly by a user click (e.g., "Use My Location" or "Set Warehouse")
async function handleLocateUser() {
  if (!navigator.geolocation) {
    showSearchModal("Geolocation not supported. Enter ZIP or City:");
    return;
  }

  // Check current permission status via Permissions API
  if (navigator.permissions && navigator.permissions.query) {
    try {
      const status = await navigator.permissions.query({ name: 'geolocation' });
      if (status.state === 'denied') {
        alert("Location access is blocked in browser settings. Please enter your ZIP code manually.");
        showSearchModal("Enter ZIP or City:");
        return;
      }
    } catch (e) {
      // Permissions API query fallback
    }
  }

  // Must run inside the click event turn
  navigator.geolocation.getCurrentPosition(
    (position) => {
      const { latitude, longitude } = position.coords;
      findAndSetNearestWarehouse(latitude, longitude);
    },
    (error) => {
      console.warn(`Geolocation error (${error.code}): ${error.message}`);
      // Fall back to manual input modal when GPS lock fails or times out
      showSearchModal("Could not get exact location. Enter ZIP or City:");
    },
    {
      enableHighAccuracy: true,
      timeout: 10000,
      maximumAge: 60000
    }
  );
}

// 2. Auto-load logic when the page opens
function initWarehouseSelection() {
  const savedWarehouse = localStorage.getItem('selected_warehouse');
  
  if (savedWarehouse) {
    displayWarehouse(JSON.parse(savedWarehouse));
  } else {
    // If no warehouse is saved yet, prompt user with manual search or "Locate Me" button
    showWarehouseModal();
  }
}