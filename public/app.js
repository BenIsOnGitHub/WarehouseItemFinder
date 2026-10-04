// ==========================================
// CONFIGURATION
// ==========================================
const API_BASE_URL = 'https://warehouse-item-finder.pant.workers.dev';
let CURRENT_WAREHOUSE = localStorage.getItem('selected_warehouse') || '1738';

const FAVORITES_KEY = 'product_favorites';
const NOTES_KEY = 'product_notes';

let selectedAisle = '';
let browseData = [];
let currentBrowsePageNum = 1;
let showDiscontinuedItems = false; // Moved to global declarations
let totalBrowsePages = 1;
const ITEMS_PER_PAGE = 20;
let showReportedIncorrectOnly = false;

// Register Service Worker for PWA
if ('serviceWorker' in navigator) {
  window.addEventListener('load', () => {
    navigator.serviceWorker.register('/sw.js').catch(console.error);
  });
}

function getIdentifierDisplay(prod) {
  const parts = [];
  if (prod.item_number) parts.push(`Item #${prod.item_number}`);
  if (prod.sku) parts.push(`SKU: ${prod.sku}`);
  return parts.length > 0 ? parts.join(' | ') : 'No Identifier';
}

function formatTimeAgo(dateStr) {
  if (!dateStr) return '';
  // Parse date string (appending 'Z' if missing to ensure UTC evaluation)
  const utcStr = dateStr.endsWith('Z') ? dateStr : dateStr + 'Z';
  const updatedDate = new Date(utcStr);
  if (isNaN(updatedDate.getTime())) return '';

  const diffMs = new Date() - updatedDate;
  const diffMins = Math.floor(diffMs / (1000 * 60));
  const diffHours = Math.floor(diffMins / 60);
  const diffDays = Math.floor(diffHours / 24);

  if (diffMins < 1) return 'Updated just now';
  if (diffMins < 60) return `Updated ${diffMins}m ago`;
  if (diffHours < 24) return `Updated ${diffHours}h ago`;
  if (diffDays === 1) return 'Updated yesterday';
  if (diffDays < 30) return `Updated ${diffDays}d ago`;
  
  return `Updated ${updatedDate.toLocaleDateString(undefined, { month: 'short', day: 'numeric' })}`;
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

function saveNote(id, noteText) {
  let notes = getNotes();
  if (!noteText.trim()) {
    delete notes[id];
  } else {
    notes[id] = noteText;
  }
  localStorage.setItem(NOTES_KEY, JSON.stringify(notes));
}

function toggleFavorite(product, starElement) {
  let favorites = getFavorites();
  const existingIndex = favorites.findIndex(item => item.id === product.id);

  if (existingIndex > -1) {
    favorites.splice(existingIndex, 1);
    if (starElement) starElement.classList.remove('active');
  } else {
    favorites.push({
      id: product.id,
      sku: product.sku || '',
      item_number: product.item_number || '',
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
function openLocationEditor(id, currentAisle, currentBay, isWrong = 0) {
  const container = document.getElementById(`loc-edit-${id}`);
  if (!container) return;

  const safeAisle = String(currentAisle).replace(/'/g, "\\'");
  const safeBay = String(currentBay).replace(/'/g, "\\'");

  container.innerHTML = `
    <div class="loc-edit-form">
      <input type="text" id="aisle-input-${id}" class="loc-edit-input aisle-input" placeholder="Aisle" value="${currentAisle || ''}">
      <input type="text" id="bay-input-${id}" class="loc-edit-input bay-input" placeholder="Bay" value="${currentBay || ''}">
      <button class="help-icon-btn" onclick="openHelpModal()" type="button" title="Where do I find the Bay number?">?</button>
      <button class="btn btn-save" onclick="saveLocation('${id}')">Save</button>
      <button class="btn btn-cancel" onclick="cancelLocationEdit('${id}', '${safeAisle}', '${safeBay}', ${isWrong})">Cancel</button>
    </div>
  `;
}

function openHelpModal() {
  const modal = document.getElementById('helpModal');
  if (modal) modal.classList.add('active');
}

function closeHelpModal(event) {
  const modal = document.getElementById('helpModal');
  if (modal) modal.classList.remove('active');
}

async function saveLocation(id) {
  const aisleInput = document.getElementById(`aisle-input-${id}`);
  const bayInput = document.getElementById(`bay-input-${id}`);
  const newAisle = aisleInput ? aisleInput.value.trim() : '';
  const newBay = bayInput ? bayInput.value.trim() : '';

  const itemInBrowse = browseData.find(p => p.id === id);
  let clearFlag = 0;

  if (itemInBrowse && itemInBrowse.is_wrong === 1) {
    const userConfirmed = confirm('This location had been flagged as incorrect. Have you corrected it?');
    if (userConfirmed) clearFlag = 1;
  }

  const finalIsWrong = (itemInBrowse && itemInBrowse.is_wrong === 1 && !clearFlag) ? 1 : 0;

  try {
    const response = await fetch(`${API_BASE_URL}/api/update-location`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        id: id,
        aisle: newAisle,
        bay: newBay,
        is_wrong: finalIsWrong
      })
    });

    if (response.ok) {
    	const currentIsoTime = new Date().toISOString();
      if (itemInBrowse) {
        itemInBrowse.aisle = newAisle;
        itemInBrowse.bay = newBay;
        itemInBrowse.is_wrong = finalIsWrong;
        itemInBrowse.updated_at = currentIsoTime;
      }
      renderLocationDisplay(id, newAisle, newBay, finalIsWrong, currentIsoTime);
    } else {
      alert('Failed to update product location in database.');
    }
  } catch (err) {
    console.error('Error updating location:', err);
    alert('Error connecting to database server.');
  }
}

function cancelLocationEdit(id, aisle, bay, isWrong = 0) {
  renderLocationDisplay(id, aisle, bay, isWrong);
}

async function flagLocationIncorrect(id) {
  if (!confirm('Report this aisle/bay location as incorrect?')) return;

  try {
    const response = await fetch(`${API_BASE_URL}/api/flag-incorrect`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        id: id,
        warehouse_id: CURRENT_WAREHOUSE
      })
    });

    if (response.ok) {
      const itemInBrowse = browseData.find(p => p.id === id);
      if (itemInBrowse) itemInBrowse.is_wrong = 1;
      renderLocationDisplay(id, itemInBrowse?.aisle, itemInBrowse?.bay, 1);
      alert('Thank you! Location reported as incorrect.');
    } else {
      alert('Failed to report incorrect location.');
    }
  } catch (err) {
    console.error('Error reporting location:', err);
  }
}

function renderLocationDisplay(id, aisle, bay, isWrong = 0) {
  const container = document.getElementById(`loc-edit-${id}`);
  if (!container) return;

  const locationStr = aisle ? `Aisle ${aisle}${bay ? ' - Bay ' + bay : ''}` : 'Location unassigned';
  const badgeClass = aisle ? 'loc-badge assigned' : 'loc-badge unassigned';

  let incorrectBtnHTML = '';
  if (aisle) {
    if (isWrong) {
      incorrectBtnHTML = `<button class="flag-incorrect-btn reported" disabled>Reported as incorrect</button>`;
    } else {
      incorrectBtnHTML = `<button class="flag-incorrect-btn" onclick="flagLocationIncorrect('${id}')">Report as incorrect</button>`;
    }
  }

  const safeAisle = String(aisle).replace(/'/g, "\\'");
  const safeBay = String(bay).replace(/'/g, "\\'");

  container.innerHTML = `
    <span class="${badgeClass}" onclick="openLocationEditor('${id}', '${safeAisle}', '${safeBay}', ${isWrong})" title="Click to update location">
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
      const res = await fetch(`${API_BASE_URL}/api/search?q=${encodeURIComponent(query)}&warehouse=${CURRENT_WAREHOUSE}&show_discontinued=${showDiscontinuedItems}`);
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
  const favoriteIds = new Set(favorites.map(f => f.id));

  container.innerHTML = results.map(prod => {
    const isFav = favoriteIds.has(prod.id);
    const identifierText = getIdentifierDisplay(prod);
    const favClass = isFav ? 'fav-btn active' : 'fav-btn';
    const aisle = prod.aisle || '';
    const bay = prod.bay || '';
    const isWrong = prod.is_wrong ? 1 : 0;
    const locationStr = aisle ? `Aisle ${aisle}${bay ? ' - Bay ' + bay : ''}` : 'Location unassigned';
    const badgeClass = aisle ? 'loc-badge assigned' : 'loc-badge unassigned';

		const timeAgoText = formatTimeAgo(prod.updated_at);
		const timeAgoHtml = timeAgoText ? ` <span class="updated-time-tag" style="font-size: 11px; color: #777; margin-left: 4px;">(${timeAgoText})</span>` : '';

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
          <button class="flag-incorrect-btn" onclick="flagLocationIncorrect('${prod.id}')" title="Report incorrect location">
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
        ${identifierText} | 
        <span id="loc-edit-${prod.id}">
          <span class="${badgeClass}" onclick="openLocationEditor('${prod.id}', '${safeAisle}', '${safeBay}', ${isWrong})">
            ${locationStr} &#9998;
          </span>
          ${incorrectBtn}
        </span>
        ${timeAgoHtml}
      </div>
      ${prod.product_url ? `<a href="${prod.product_url}" target="_blank" class="external-product-link">View on Retailer Website</a>` : ''}
    </div>
    <button class="${favClass}" onclick='toggleFavorite(${JSON.stringify(prod)}, this)'>&#9733;</button>
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
    const prodNote = notes[prod.id] || '';
    const identifierText = getIdentifierDisplay(prod);
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
	      <div class="product-details">${identifierText}</div>
	      <div class="note-container">
	        <input 
	          type="text" 
	          class="note-input" 
	          placeholder="Add note (e.g. check endcap)" 
	          value="${prodNote.replace(/"/g, '&quot;')}"
	          onchange="saveNote('${prod.id}', this.value)"
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

  const byNameBtn = document.getElementById('browseByNameBtn');
  const byAisleBtn = document.getElementById('browseByAisleBtn');

  if (byNameBtn) byNameBtn.classList.toggle('active', mode === 'name');
  if (byAisleBtn) byAisleBtn.classList.toggle('active', mode === 'aisle');
	populateAisleDropdown();
  startBrowse(1);
}

async function startBrowse(page = 1) {
  currentBrowsePageNum = page;
  const container = document.getElementById('browseListContainer');
  if (container) container.innerHTML = '<div class="loading-state">Loading products...</div>';

  try {
    const url = `${API_BASE_URL}/api/browse?warehouse=${CURRENT_WAREHOUSE}&page=${page}&limit=${ITEMS_PER_PAGE}&sort=${currentBrowseMode}&show_discontinued=${showDiscontinuedItems}&show_incorrect=${showReportedIncorrectOnly}&aisle=${encodeURIComponent(selectedAisle)}`;

    const res = await fetch(url);
    const data = await res.json();

    if (!res.ok || data.error) {
      console.error('API Error:', data.error);
      if (container) {
        if (data.error && data.error.includes('exceeded D1\'s free tier')) {
          container.innerHTML = `<div class="empty-aisle-notice">Cloudflare D1 daily free quota exceeded. Please try again tomorrow or upgrade your Cloudflare plan.</div>`;
        } else {
          container.innerHTML = `<div class="empty-aisle-notice">Error loading products: ${data.error || 'Server error'}</div>`;
        }
      }
      return;
    }

    browseData = data.products || [];
    totalBrowsePages = data.totalPages || 1;

    if (currentBrowseMode === 'aisle') {
      renderBrowseByAislePage();
    } else {
      renderBrowsePage();
    }
  } catch (err) {
    console.error('Failed to load browse page:', err);
    if (container) container.innerHTML = '<div class="empty-aisle-notice">Unable to connect to server.</div>';
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
  const favoriteIds = new Set(favorites.map(f => f.id));

  container.innerHTML = browseData.map(prod => {
    const isFav = favoriteIds.has(prod.id);
    const identifierText = getIdentifierDisplay(prod);
    const favClass = isFav ? 'fav-btn active' : 'fav-btn';
    const aisle = prod.aisle || '';
    const bay = prod.bay || '';
    const isWrong = prod.is_wrong ? 1 : 0;
    const locationStr = aisle ? `Aisle ${aisle}${bay ? ' - Bay ' + bay : ''}` : 'Location unassigned';
    const badgeClass = aisle ? 'loc-badge assigned' : 'loc-badge unassigned';

    // Compute updated time badge per product
    const timeAgoText = formatTimeAgo(prod.updated_at);
    const timeAgoHtml = timeAgoText 
      ? ` <span class="updated-time-tag" style="font-size: 11px; color: #777; margin-left: 4px;">(${timeAgoText})</span>` 
      : '';

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
          <button class="flag-incorrect-btn" onclick="flagLocationIncorrect('${prod.id}')" title="Report incorrect location">
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
            ${identifierText} | 
            <span id="loc-edit-${prod.id}">
              <span class="${badgeClass}" onclick="openLocationEditor('${prod.id}', '${safeAisle}', '${safeBay}', ${isWrong})" title="Click to update location">
                ${locationStr} &#9998;
              </span>
              ${incorrectBtn}
            </span>
            ${timeAgoHtml}
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

  if (browseData.length === 0) {
    container.innerHTML = '<div class="empty-aisle-notice">No items found for this aisle page.</div>';
    return;
  }

  // 1. Group by Aisle
  const aisleGroups = {};
  browseData.forEach(prod => {
    const aisleKey = prod.aisle ? `Aisle ${prod.aisle}` : 'Aisle Unassigned';
    if (!aisleGroups[aisleKey]) aisleGroups[aisleKey] = [];
    aisleGroups[aisleKey].push(prod);
  });

  const sortedAisles = Object.keys(aisleGroups).sort((a, b) => {
    const numA = parseInt(a.replace(/\D/g, ''), 10) || 0;
    const numB = parseInt(b.replace(/\D/g, ''), 10) || 0;
    return numA - numB;
  });

  const favorites = getFavorites();
  const favoriteIds = new Set(favorites.map(f => f.id));

  container.innerHTML = sortedAisles.map(aisleKey => {
    const aisleItems = aisleGroups[aisleKey];

    // 2. Sub-group items in this Aisle by Bay
    const bayGroups = {};
    aisleItems.forEach(prod => {
      const bayKey = prod.bay ? `Bay ${prod.bay}` : 'Bay Unassigned';
      if (!bayGroups[bayKey]) bayGroups[bayKey] = [];
      bayGroups[bayKey].push(prod);
    });

    const sortedBays = Object.keys(bayGroups).sort((a, b) => {
      const numA = parseInt(a.replace(/\D/g, ''), 10) || 0;
      const numB = parseInt(b.replace(/\D/g, ''), 10) || 0;
      return numA - numB;
    });

    return `
      <div class="aisle-group">
        <h2 class="aisle-group-header">
          ${aisleKey}
        </h2>
        <div class="aisle-group-body">
          ${sortedBays.map(bayKey => {
            const items = bayGroups[bayKey];
            const subHeadingText = aisleKey !== 'Aisle Unassigned' && bayKey !== 'Bay Unassigned'
              ? `${aisleKey} -${bayKey}`
              : bayKey;

            return `
              <div class="bay-subgroup">
                <h3 class="bay-group-header">${subHeadingText}</h3>${items.map(prod => {
                  const isFav = favoriteIds.has(prod.id);
                  const identifierText = getIdentifierDisplay(prod);
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
                        <button class="flag-incorrect-btn" onclick="flagLocationIncorrect('${prod.id}')" title="Report incorrect location">
                          Report as incorrect
                        </button>
                      `;
                    }
                  }

                  const safeAisle = String(aisle).replace(/'/g, "\\'");
                  const safeBay = String(bay).replace(/'/g, "\\'");

                  return `
                    <div class="browse-product-row aisle-item-row">
                      <div class="browse-product-details">
                        <div class="browse-product-title"><strong>${prod.product_name}</strong></div>
                        <div class="product-details">
                          ${identifierText} | 
                          <span id="loc-edit-${prod.id}">
                            <span class="${badgeClass}" onclick="openLocationEditor('${prod.id}', '${safeAisle}', '${safeBay}', ${isWrong})" title="Click to update location">
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

    if (!res.ok || !Array.isArray(warehouses)) {
      console.error('Invalid response from /api/warehouses:', warehouses);
      return;
    }

    const selectElements = document.querySelectorAll('.warehouse-select-dropdown, #warehouseSelect');
    if (selectElements.length === 0 || warehouses.length === 0) return;

    const optionsHTML = warehouses.map(w => {
      const name = (w.warehouse_name || `Warehouse #${w.warehouse_id}`)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;');

      return `<option value="${w.warehouse_id}" ${w.warehouse_id === CURRENT_WAREHOUSE ? 'selected' : ''}>${name}</option>`;
    }).join('');

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
	populateAisleDropdown();
  document.querySelectorAll('.warehouse-select-dropdown, #warehouseSelect').forEach(selectEl => {
    selectEl.value = newWarehouseId;
  });

  const searchBox = document.getElementById('searchBox');
  if (searchBox && searchBox.value.trim()) {
    handleSearchInput({ target: searchBox });
  }

  const activeView = document.querySelector('.page-view.active');
  if (activeView && activeView.id === 'browse-view') {
    populateAisleDropdown();
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

function toggleShowDiscontinued(checkbox) {
  showDiscontinuedItems = checkbox.checked;
  const activeView = document.querySelector('.page-view.active');

  if (activeView && activeView.id === 'browse-view') {
  	populateAisleDropdown();
    startBrowse(1);
  } else {
    const searchBox = document.getElementById('searchBox');
    if (searchBox && searchBox.value.trim()) {
      handleSearchInput({ target: searchBox });
    }
  }
}

async function flagDiscontinued(id, currentStatus) {
  const newStatus = !currentStatus;
  const actionText = newStatus ? 'mark this item as discontinued/out of stock' : 'restore this item as active';
  if (!confirm(`Are you sure you want to ${actionText}?`)) return;

  try {
    const res = await fetch(`${API_BASE_URL}/api/flag-discontinued`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ id, is_discontinued: newStatus })
    });

    if (res.ok) {
      alert(`Item updated successfully.`);
      const activeView = document.querySelector('.page-view.active');
      if (activeView && activeView.id === 'browse-view') {
        startBrowse(currentBrowsePageNum);
      }
    }
  } catch (err) {
    console.error('Error updating discontinued status:', err);
  }
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

function toggleFilterDrawer(open) {
  const drawer = document.getElementById('filterDrawer');
  const backdrop = document.getElementById('filterDrawerBackdrop');
  
  if (open) {
    backdrop.style.display = 'block';
    drawer.style.right = '0px';
  } else {
    drawer.style.right = '-300px';
    backdrop.style.display = 'none';
  }
}

function onBrowseSortChange(sortValue) {
  // If event object was passed instead of value string, extract value safely
  const value = (typeof sortValue === 'string') ? sortValue : sortValue?.target?.value;
  
  if (value) {
    currentBrowseMode = value; // Update global browse mode
  }
  populateAisleDropdown();
  startBrowse(1); // Re-fetch products with the updated sort order
}

function applyFilters() {
  toggleFilterDrawer(false);
  populateAisleDropdown();
  startBrowse(1); // Reload browse results using current dropdown selections
}

function resetFilters() {
  selectedAisle = '';
  showReportedIncorrectOnly = false;
  
  const categorySelect = document.getElementById('filterCategorySelect');
  const aisleSelect = document.getElementById('filterAisleSelect');
  const reportedCheckbox = document.getElementById('showReportedCheckbox');

  if (categorySelect) categorySelect.value = '';
  if (aisleSelect) aisleSelect.value = '';
  if (reportedCheckbox) reportedCheckbox.checked = false;

  applyFilters();
}

function onToggleIncorrectFilter(checked) {
  // Support either passing boolean or event object
  const isChecked = typeof checked === 'boolean' ? checked : checked?.target?.checked;
  
  showReportedIncorrectOnly = !!isChecked;
  startBrowse(1); // Reset to page 1 and refresh list
}

async function populateAisleDropdown() {
  const aisleSelect = document.getElementById('filterAisleSelect') || document.getElementById('browseAisleSelect');
  if (!aisleSelect) return;

  try {
    const res = await fetch(`${API_BASE_URL}/api/aisles?warehouse=${CURRENT_WAREHOUSE}`);
    const aisles = await res.json();

    let optionsHtml = '<option value="">All Aisles</option>';
    optionsHtml += (Array.isArray(aisles) ? aisles : []).map(aisle => {
      const isSelected = String(aisle) === String(selectedAisle) ? 'selected' : '';
      return `<option value="${aisle}" ${isSelected}>Aisle ${aisle}</option>`;
    }).join('');

    aisleSelect.innerHTML = optionsHtml;
  } catch (err) {
    console.error('Failed to populate aisle dropdown:', err);
  }
}

// Ensure populateAisleDropdown runs when the app loads
document.addEventListener('DOMContentLoaded', () => {
  loadWarehouses();
  populateAisleDropdown(); // <-- Populates aisles on load
  startBrowse(1);

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



function onAisleFilterChange(value) {
  selectedAisle = value;
  startBrowse(1);
}