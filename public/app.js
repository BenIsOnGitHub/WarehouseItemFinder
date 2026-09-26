// ==========================================
// CONFIGURATION
// ==========================================
const API_BASE_URL = 'https://warehouse-item-finder.pant.workers.dev';
let CURRENT_WAREHOUSE = localStorage.getItem('selected_warehouse') || '1738';

const FAVORITES_KEY = 'product_favorites';
const NOTES_KEY = 'product_notes';

let browseData = [];
let currentBrowsePageNum = 1;
let totalBrowsePages = 1;
const ITEMS_PER_PAGE = 20;

// Register Service Worker for PWA
if ('serviceWorker' in navigator) {
  window.addEventListener('load', () => {
    navigator.serviceWorker.register('/sw.js').catch(console.error);
  });
}

// ==========================================
// FAVORITES & LOCAL STORAGE HELPERS
// ==========================================
function getFavorites() {
  const favs = localStorage.getItem(FAVORITES_KEY);
  return favs ? JSON.parse(favs) : [];
}

function saveFavorites(favorites) {
  localStorage.setItem(FAVORITES_KEY, JSON.stringify(favorites));
}

function getNotes() {
  const notes = localStorage.getItem(NOTES_KEY);
  return notes ? JSON.parse(notes) : {};
}

function saveNote(sku, noteText) {
  let notes = getNotes();
  if (!noteText.trim()) {
    delete notes[sku];
  } else {
    notes[sku] = noteText;
  }
  localStorage.setItem(NOTES_KEY, JSON.stringify(notes));
}

function toggleFavorite(product, starElement) {
  let favorites = getFavorites();
  const existingIndex = favorites.findIndex(item => item.sku === product.sku);

  if (existingIndex > -1) {
    favorites.splice(existingIndex, 1);
    if (starElement) starElement.classList.remove('active');
  } else {
    favorites.push({
      sku: product.sku,
      product_name: product.product_name,
      warehouse_id: product.warehouse_id,
      product_url: product.product_url,
      aisle: product.aisle || '',
      bay: product.bay || ''
    });
    if (starElement) starElement.classList.add('active');
  }

  saveFavorites(favorites);

  const favView = document.getElementById('favorites-view');
  if (favView && favView.classList.contains('active')) {
    renderFavoritesUI();
  }
}

function moveFavorite(index, direction) {
  let favorites = getFavorites();
  const targetIndex = index + direction;
  if (targetIndex < 0 || targetIndex >= favorites.length) return;

  const [movedItem] = favorites.splice(index, 1);
  favorites.splice(targetIndex, 0, movedItem);

  saveFavorites(favorites);
  renderFavoritesUI();
}

// ==========================================
// INTERACTIVE LOCATION UPDATE (D1 API)
// ==========================================
function openLocationEditor(sku, currentAisle, currentBay, isWrong = 0) {
  const container = document.getElementById(`loc-edit-${sku}`);
  if (!container) return;

  container.innerHTML = `
    <div class="loc-edit-form">
      <input type="text" id="aisle-input-${sku}" class="loc-edit-input aisle-input" placeholder="Aisle (e.g. 12)" value="${currentAisle || ''}">
      <input type="text" id="bay-input-${sku}" class="loc-edit-input bay-input" placeholder="Bay (e.g. 2)" value="${currentBay || ''}">
      <button class="help-icon-btn" onclick="openHelpModal()" type="button" title="Where do I find the Bay number?">?</button>
      <button class="btn btn-save" onclick="saveLocation('${sku}')">Save</button>
      <button class="btn btn-cancel" onclick="cancelLocationEdit('${sku}', '${currentAisle}', '${currentBay}', ${isWrong})">Cancel</button>
    </div>
  `;
}

// Help Modal Controls
function openHelpModal() {
  const modal = document.getElementById('helpModal');
  if (modal) modal.classList.add('active');
}

function closeHelpModal(event) {
  const modal = document.getElementById('helpModal');
  if (modal) modal.classList.remove('active');
}

async function saveLocation(sku) {
  const aisleInput = document.getElementById(`aisle-input-${sku}`);
  const bayInput = document.getElementById(`bay-input-${sku}`);
  const newAisle = aisleInput ? aisleInput.value.trim() : '';
  const newBay = bayInput ? bayInput.value.trim() : '';

  try {
    const response = await fetch(`${API_BASE_URL}/api/update-location`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        sku: sku,
        warehouse_id: CURRENT_WAREHOUSE,
        aisle: newAisle,
        bay: newBay
      })
    });

    if (response.ok) {
      // Update local memory representations and clear the wrong flag
      const itemInBrowse = browseData.find(p => p.sku === sku);
      if (itemInBrowse) {
        itemInBrowse.aisle = newAisle;
        itemInBrowse.bay = newBay;
        itemInBrowse.is_wrong = 0; // Reset flag in memory
      }
      renderLocationDisplay(sku, newAisle, newBay, 0); // Reset flag in UI
    } else {
      alert('Failed to update product location in database.');
    }
  } catch (err) {
    console.error('Error updating location:', err);
    alert('Error connecting to database server.');
  }
}

function cancelLocationEdit(sku, aisle, bay, isWrong = 0) {
  renderLocationDisplay(sku, aisle, bay, isWrong);
}

// Report incorrect location API call
async function flagLocationIncorrect(sku) {
  if (!confirm('Report this aisle/bay location as incorrect?')) return;

  try {
    const response = await fetch(`${API_BASE_URL}/api/flag-incorrect`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        sku: sku,
        warehouse_id: CURRENT_WAREHOUSE
      })
    });

    if (response.ok) {
      // Update memory state
      const itemInBrowse = browseData.find(p => p.sku === sku);
      if (itemInBrowse) itemInBrowse.is_wrong = 1;

      // Re-render button in reported state
      renderLocationDisplay(sku, itemInBrowse?.aisle, itemInBrowse?.bay, 1);
      alert('Thank you! Location reported as incorrect.');
    } else {
      alert('Failed to report incorrect location.');
    }
  } catch (err) {
    console.error('Error reporting location:', err);
    alert('Server error while reporting location.');
  }
}

function renderLocationDisplay(sku, aisle, bay, isWrong = 0) {
  const container = document.getElementById(`loc-edit-${sku}`);
  if (!container) return;

  const locationStr = aisle ? `Aisle ${aisle}${bay ? ' - Bay ' + bay : ''}` : 'Location unassigned';
  const badgeClass = aisle ? 'loc-badge assigned' : 'loc-badge unassigned';

  let incorrectBtnHTML = '';
  if (aisle) {
    if (isWrong) {
      incorrectBtnHTML = `
        <button class="flag-incorrect-btn reported" disabled title="Reported as incorrect">
          Reported as incorrect
        </button>
      `;
    } else {
      incorrectBtnHTML = `
        <button class="flag-incorrect-btn" onclick="flagLocationIncorrect('${sku}')" title="Report incorrect location">
          Report as incorrect
        </button>
      `;
    }
  }

  const safeAisle = String(aisle).replace(/'/g, "\\'");
  const safeBay = String(bay).replace(/'/g, "\\'");

  container.innerHTML = `
    <span class="${badgeClass}" onclick="openLocationEditor('${sku}', '${safeAisle}', '${safeBay}', ${isWrong})" title="Click to update location">
      ${locationStr} &#9998;
    </span>
    ${incorrectBtnHTML}
  `;
}

// ==========================================
// SEARCH LOGIC (D1 API CALL)
// ==========================================
let searchDebounceTimer = null;

function handleSearchInput(e) {
  const query = e.target.value;
  clearTimeout(searchDebounceTimer);

  if (!query.trim()) {
    document.getElementById('results').innerHTML = '';
    document.getElementById('count').textContent = '';
    return;
  }

  searchDebounceTimer = setTimeout(async () => {
    try {
      const res = await fetch(`${API_BASE_URL}/api/search?q=${encodeURIComponent(query)}&warehouse=${CURRENT_WAREHOUSE}`);
      const results = await res.json();
      renderResultsUI(results);
    } catch (err) {
      console.error('Search query failed:', err);
    }
  }, 200);
}

function renderResultsUI(results) {
  const container = document.getElementById('results');
  const countEl = document.getElementById('count');
  if (!container) return;

  countEl.textContent = `${results.length} item${results.length === 1 ? '' : 's'} found`;

  if (results.length === 0) {
    container.innerHTML = '<li class="no-results">No products found.</li>';
    return;
  }

  const favorites = getFavorites();
  const favoriteSkus = new Set(favorites.map(f => f.sku));

  container.innerHTML = results.map(prod => {
    const isFav = favoriteSkus.has(prod.sku);
    const favClass = isFav ? 'fav-btn active' : 'fav-btn';
    const aisle = prod.aisle || '';
    const bay = prod.bay || '';
    const isWrong = prod.is_wrong ? 1 : 0;
    const locationStr = aisle ? `Aisle ${aisle}${bay ? ' - Bay ' + bay : ''}` : 'Location unassigned';
    const badgeClass = aisle ? 'loc-badge assigned' : 'loc-badge unassigned';

    let incorrectBtn = '';
    if (aisle) {
      if (prod.is_wrong) {
        incorrectBtn = `
          <button class="flag-incorrect-btn reported" disabled title="Reported as incorrect">
            Reported as incorrect
          </button>
        `;
      } else {
        incorrectBtn = `
          <button class="flag-incorrect-btn" onclick="flagLocationIncorrect('${prod.sku}')" title="Report incorrect location">
            Report as incorrect
          </button>
        `;
      }
    }

    const safeAisle = String(aisle).replace(/'/g, "\\'");
    const safeBay = String(bay).replace(/'/g, "\\'");

    return `
      <li class="product-card">
        <div class="product-info">
          <div class="product-title">${prod.product_name}</div>
          <div class="product-details">
            SKU: ${prod.sku} | 
            <span id="loc-edit-${prod.sku}">
              <span class="${badgeClass}" onclick="openLocationEditor('${prod.sku}', '${safeAisle}', '${safeBay}', ${isWrong})" title="Click to update location">
                ${locationStr} &#9998;
              </span>
              ${incorrectBtn}
            </span>
          </div>
          ${prod.product_url ? `<a href="${prod.product_url}" target="_blank" class="external-product-link">View on Retailer Website</a>` : ''}
        </div>
        <button class="${favClass}" onclick='toggleFavorite(${JSON.stringify(prod)}, this)' aria-label="Favorite product">&#9733;</button>
      </li>
    `;
  }).join('');
}

// ==========================================
// FAVORITES VIEW RENDER
// ==========================================
function renderFavoritesUI() {
  const favorites = getFavorites();
  const notes = getNotes();
  const container = document.getElementById('favoritesList');
  const countEl = document.getElementById('favCount');

  if (countEl) {
    countEl.textContent = `${favorites.length} favorite ${favorites.length === 1 ? 'item' : 'items'}`;
  }

  if (!container) return;

  if (favorites.length === 0) {
    container.innerHTML = '<li class="no-results">No favorite products added yet.</li>';
    return;
  }

  container.innerHTML = favorites.map((prod, index) => {
    const prodNote = notes[prod.sku] || '';
    const isFirst = index === 0;
    const isLast = index === favorites.length - 1;

    return `
      <li class="product-card">
        <div class="reorder-btns">
          <button class="move-btn" onclick="moveFavorite(${index}, -1)" ${isFirst ? 'disabled' : ''}>&#9650;</button>
          <button class="move-btn" onclick="moveFavorite(${index}, 1)" ${isLast ? 'disabled' : ''}>&#9660;</button>
        </div>
        <div class="product-info">
          <div class="product-title">${prod.product_name}</div>
          <div class="product-details">SKU: ${prod.sku}</div>
          <div class="note-container">
            <input 
              type="text" 
              class="note-input" 
              placeholder="Add note (e.g. check endcap)" 
              value="${prodNote.replace(/"/g, '&quot;')}"
              onchange="saveNote('${prod.sku}', this.value)"
            />
          </div>
        </div>
        <button class="fav-btn active" onclick='toggleFavorite(${JSON.stringify(prod)}, this)'>&#9733;</button>
      </li>
    `;
  }).join('');
}

// ==========================================
// BROWSE PRODUCTS & PAGINATION
// ==========================================
let currentBrowseMode = 'name'; // Default: 'name' | Alternative: 'aisle'

function setBrowseMode(mode) {
  currentBrowseMode = mode;

  // Toggle active class on mode buttons
  const byNameBtn = document.getElementById('browseByNameBtn');
  const byAisleBtn = document.getElementById('browseByAisleBtn');

  if (byNameBtn) byNameBtn.classList.toggle('active', mode === 'name');
  if (byAisleBtn) byAisleBtn.classList.toggle('active', mode === 'aisle');

  // Reset to Page 1 whenever switching modes
  startBrowse(1);
}

async function startBrowse(page = 1) {
  currentBrowsePageNum = page;
  const container = document.getElementById('browseListContainer');
  if (container) container.innerHTML = '<div class="loading-state">Loading products...</div>';

  try {
    const res = await fetch(`${API_BASE_URL}/api/browse?warehouse=${CURRENT_WAREHOUSE}&page=${page}&limit=${ITEMS_PER_PAGE}&sort=${currentBrowseMode}`);
    const data = await res.json();
    
    browseData = data.products;
    totalBrowsePages = data.totalPages;

    if (currentBrowseMode === 'aisle') {
      renderBrowseByAislePage();
    } else {
      renderBrowsePage(); // Standard By Name rendering
    }
  } catch (err) {
    console.error('Failed to load browse page:', err);
  }
}

function changeBrowsePage(step, isBottom = false) {
  const targetPage = currentBrowsePageNum + step;
  if (targetPage < 1 || targetPage > totalBrowsePages) return;

  startBrowse(targetPage);

  if (!isBottom) {
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }
}

function updatePaginationUI() {
  const pageText = `Page ${currentBrowsePageNum} of ${totalBrowsePages}`;
  document.querySelectorAll('.pageIndicatorTop, .pageIndicatorBottom').forEach(el => el.innerText = pageText);

  document.querySelectorAll('.top-prev-btn, .bottom-prev-btn').forEach(btn => btn.disabled = currentBrowsePageNum === 1);
  document.querySelectorAll('.top-next-btn, .bottom-next-btn').forEach(btn => btn.disabled = currentBrowsePageNum === totalBrowsePages);

  document.querySelectorAll('.top-prev5-btn, .bottom-prev5-btn').forEach(btn => btn.disabled = currentBrowsePageNum <= 5);
  document.querySelectorAll('.top-next5-btn, .bottom-next5-btn').forEach(btn => btn.disabled = currentBrowsePageNum > totalBrowsePages - 5);
}

function renderBrowsePage() {
  updatePaginationUI();
  const container = document.getElementById('browseListContainer');
  if (!container) return;

  const favorites = getFavorites();
  const favoriteSkus = new Set(favorites.map(f => f.sku));

  container.innerHTML = browseData.map(prod => {
    const isFav = favoriteSkus.has(prod.sku);
    const favClass = isFav ? 'fav-btn active' : 'fav-btn';
    const aisle = prod.aisle || '';
    const bay = prod.bay || '';
    const isWrong = prod.is_wrong ? 1 : 0;
    const locationStr = aisle ? `Aisle ${aisle}${bay ? ' - Bay ' + bay : ''}` : 'Location unassigned';
    const badgeClass = aisle ? 'loc-badge assigned' : 'loc-badge unassigned';

    let incorrectBtn = '';
    if (aisle) {
      if (prod.is_wrong) {
        incorrectBtn = `
          <button class="flag-incorrect-btn reported" disabled title="Reported as incorrect">
            Reported as incorrect
          </button>
        `;
      } else {
        incorrectBtn = `
          <button class="flag-incorrect-btn" onclick="flagLocationIncorrect('${prod.sku}')" title="Report incorrect location">
            Report as incorrect
          </button>
        `;
      }
    }

    const safeAisle = String(aisle).replace(/'/g, "\\'");
    const safeBay = String(bay).replace(/'/g, "\\'");

    return `
      <div class="browse-product-row">
        <div class="browse-product-details">
          <div class="browse-product-title"><strong>${prod.product_name}</strong></div>
          <div class="product-details">
            SKU: ${prod.sku} | 
            <span id="loc-edit-${prod.sku}">
              <span class="${badgeClass}" onclick="openLocationEditor('${prod.sku}', '${safeAisle}', '${safeBay}', ${isWrong})" title="Click to update location">
                ${locationStr} &#9998;
              </span>
              ${incorrectBtn}
            </span>
          </div>
        </div>
        <button class="${favClass}" onclick='toggleFavorite(${JSON.stringify(prod)}, this)'>&#9733;</button>
      </div>
    `;
  }).join('');
}

function renderBrowseByAislePage() {
  updatePaginationUI();
  const container = document.getElementById('browseListContainer');
  if (!container) return;

  const assigned = browseData.filter(p => p.aisle && p.aisle.toString().trim() !== '');

  if (assigned.length === 0) {
    container.innerHTML = '<div class="empty-aisle-notice">No items on this page have an assigned aisle.</div>';
    return;
  }

  const grouped = {};
  assigned.forEach(prod => {
    const key = `Aisle ${prod.aisle}`;
    if (!grouped[key]) grouped[key] = [];
    grouped[key].push(prod);
  });

  const sortedAisles = Object.keys(grouped).sort((a, b) => {
    const numA = parseInt(a.replace(/\D/g, ''), 10) || 0;
    const numB = parseInt(b.replace(/\D/g, ''), 10) || 0;
    return numA - numB;
  });

  const favorites = getFavorites();
  const favoriteSkus = new Set(favorites.map(f => f.sku));

  container.innerHTML = sortedAisles.map(aisleKey => {
    const items = grouped[aisleKey];
    items.sort((a, b) => (parseInt(a.bay, 10) || 0) - (parseInt(b.bay, 10) || 0));

    return `
      <div class="aisle-group">
        <h2 class="aisle-group-header">
          ${aisleKey}
        </h2>
        <div class="aisle-group-body">
          ${items.map(prod => {
            const isFav = favoriteSkus.has(prod.sku);
            const favClass = isFav ? 'fav-btn active' : 'fav-btn';
            const aisle = prod.aisle || '';
            const bay = prod.bay || '';
            const isWrong = prod.is_wrong ? 1 : 0;
            const locationStr = aisle ? `Aisle ${aisle}${bay ? ' - Bay ' + bay : ''}` : 'Location unassigned';
            const badgeClass = aisle ? 'loc-badge assigned' : 'loc-badge unassigned';

            let incorrectBtn = '';
            if (aisle) {
              if (prod.is_wrong) {
                incorrectBtn = `
                  <button class="flag-incorrect-btn reported" disabled title="Reported as incorrect">
                    Reported as incorrect
                  </button>
                `;
              } else {
                incorrectBtn = `
                  <button class="flag-incorrect-btn" onclick="flagLocationIncorrect('${prod.sku}')" title="Report incorrect location">
                    Report as incorrect
                  </button>
                `;
              }
            }

            // Escaping single quotes for the inline onclick handler
            const safeAisle = String(aisle).replace(/'/g, "\\'");
            const safeBay = String(bay).replace(/'/g, "\\'");

            return `
              <div class="browse-product-row aisle-item-row">
                <div class="browse-product-details">
                  <div class="browse-product-title"><strong>${prod.product_name}</strong></div>
                  <div class="product-details">
                    SKU: ${prod.sku} | 
                    <span id="loc-edit-${prod.sku}">
                      <span class="${badgeClass}" onclick="openLocationEditor('${prod.sku}', '${safeAisle}', '${safeBay}',${isWrong})" title="Click to update location">
                        ${locationStr} &#9998;
                      </span>
                      ${incorrectBtn}
                    </span>
                  </div>
                </div>
                <button class="${favClass}" onclick='toggleFavorite(${JSON.stringify(prod)}, this)'>&#9733;</button>
              </div>
            `;
          }).join('')}
        </div>
      </div>
    `;
  }).join('');
}

// ==========================================
// WAREHOUSE SELECTOR & NAVIGATION
// ==========================================
async function loadWarehouses() {
  try {
    const res = await fetch(`${API_BASE_URL}/api/warehouses`);
    const warehouses = await res.json();
    
    const selectElements = document.querySelectorAll('.warehouse-select-dropdown, #warehouseSelect');
    if (selectElements.length === 0 || warehouses.length === 0) return;

    const optionsHTML = warehouses.map(w => `
      <option value="${w.warehouse_id}" ${w.warehouse_id === CURRENT_WAREHOUSE ? 'selected' : ''}>
        ${w.warehouse_name || 'Warehouse #' + w.warehouse_id}
      </option>
    `).join('');

    selectElements.forEach(selectEl => {
      selectEl.innerHTML = optionsHTML;
    });

  } catch (err) {
    console.error('Failed to fetch warehouses list:', err);
  }
}

function onWarehouseChange(newWarehouseId) {
  CURRENT_WAREHOUSE = newWarehouseId;
  localStorage.setItem('selected_warehouse', newWarehouseId);

  document.querySelectorAll('.warehouse-select-dropdown, #warehouseSelect').forEach(selectEl => {
    selectEl.value = newWarehouseId;
  });

  const searchBox = document.getElementById('searchBox');
  if (searchBox && searchBox.value.trim()) {
    handleSearchInput({ target: searchBox });
  }

  const activeView = document.querySelector('.page-view.active');
  if (activeView && activeView.id === 'browse-view') {
    startBrowse(1);
  }
}

function switchView(viewId) {
  document.querySelectorAll('.page-view').forEach(view => view.classList.remove('active'));
  const targetView = document.getElementById(viewId);
  if (targetView) targetView.classList.add('active');

  const navDropdown = document.getElementById('navDropdown');
  if (navDropdown) navDropdown.classList.remove('active');
}

function showFavoritesView() {
  switchView('favorites-view');
  renderFavoritesUI();
}

function resetSearchView() {
  const searchBox = document.getElementById('searchBox');
  if (searchBox) searchBox.value = '';
  document.getElementById('results').innerHTML = '';
  document.getElementById('count').textContent = '';
}

// ==========================================
// APP INITIALIZATION
// ==========================================
document.addEventListener('DOMContentLoaded', () => {
  loadWarehouses();

  const searchBox = document.getElementById('searchBox');
  if (searchBox) {
    searchBox.addEventListener('input', handleSearchInput);
  }

  const menuToggle = document.getElementById('menuToggle');
  const navDropdown = document.getElementById('navDropdown');
  if (menuToggle && navDropdown) {
    menuToggle.addEventListener('click', (e) => {
      e.stopPropagation();
      navDropdown.classList.toggle('active');
    });

    document.addEventListener('click', (e) => {
      if (!navDropdown.contains(e.target) && !menuToggle.contains(e.target)) {
        navDropdown.classList.remove('active');
      }
    });
  }
});