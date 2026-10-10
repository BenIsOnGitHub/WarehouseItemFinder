// ==========================================
// CONFIGURATION
// ==========================================
function getStoredWarehouseId() {
  try {
    const raw = localStorage.getItem('selected_warehouse');
    if (!raw) return null;
    const parsed = JSON.parse(raw);
    return parsed.warehouse_id || parsed.id || raw;
  } catch (e) {
    return null;
  }
}

let CURRENT_WAREHOUSE = getStoredWarehouseId();
const FAVORITES_KEY = 'product_favorites';
const NOTES_KEY = 'product_notes';

let selectedAisle = '';
let browseData = [];
let currentBrowsePageNum = 1;
let showDiscontinuedItems = false;
let totalBrowsePages = 1;
const ITEMS_PER_PAGE = 20;
let showReportedIncorrectOnly = false;

if ('serviceWorker' in navigator) {
  window.addEventListener('load', () => {
    navigator.serviceWorker.register('/sw.js').catch(console.error);
  });
}

function getIdentifierDisplay(prod) {
  const hasItemNumber = prod.item_number && String(prod.item_number).trim() !== '';
  const hasSku = prod.sku && String(prod.sku).trim() !== '';

  if (!hasItemNumber && !hasSku) {
    return `
      <div class="product-identifiers">
        <span class="loc-badge unassigned" role="button" onclick="promptEditItemNumber('${prod.id}')">
          Item number: Unknown ✎
        </span> 
        <span class="loc-badge unassigned" role="button" onclick="promptEditSku('${prod.id}')">
          SKU: Unknown ✎
        </span>
      </div>
    `;
  }

  const itemText = hasItemNumber 
    ? `Item: ${escapeHtml(prod.item_number)}`
    : `<span class="loc-badge unassigned" role="button" onclick="promptEditItemNumber('${prod.id}')">Item: Unknown ✎</span>`;

  const skuText = hasSku
    ? `SKU: ${escapeHtml(prod.sku)}`
    : `<span class="loc-badge unassigned" role="button" onclick="promptEditSku('${prod.id}')">SKU: Unknown ✎</span>`;

  return `
    <div class="product-identifiers">
      ${itemText} | ${skuText}
    </div>
  `;
}

function formatTimeAgo(dateStr) {
  if (!dateStr) return '';
  
  let cleanStr = dateStr.replace(/(\.\d{3})\d+/, '$1');
  if (!cleanStr.endsWith('Z') && !cleanStr.includes('+')) {
    cleanStr += 'Z';
  }

  const updatedDate = new Date(cleanStr);
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

function toggleFavorite(prodOrId, starElement) {
  let favorites = getFavorites();

  let product = typeof prodOrId === 'object' ? prodOrId : null;

  if (!product) {
    const targetKey = String(prodOrId).trim();
    product = browseData.find(p => String(p.id) === targetKey || String(p.item_number) === targetKey) ||
              (window._lastSearchResults || []).find(p => String(p.id) === targetKey || String(p.item_number) === targetKey) ||
              favorites.find(p => String(p.id) === targetKey || String(p.item_number) === targetKey);
  }

  if (!product) return;

  const productItemNumber = String(product.item_number || '').trim();

  const existingIndex = favorites.findIndex(item => {
    if (productItemNumber && String(item.item_number).trim()) {
      return String(item.item_number).trim() === productItemNumber;
    }
    return String(item.id) === String(product.id);
  });

  if (existingIndex > -1) {
    favorites.splice(existingIndex, 1);
    if (starElement) starElement.classList.remove('active');
  } else {
    favorites.push({
      id: product.id,
      item_number: productItemNumber,
      sku: product.sku || '',
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
// INTERACTIVE LOCATION UPDATE
// ==========================================
function openLocationEditor(id, currentAisle, currentBay, isWrong = 0) {
  const container = document.getElementById(`loc-edit-${id}`);
  if (!container) return;

  const safeAisle = String(currentAisle).replace(/'/g, "\\'");
  const safeBay = String(currentBay).replace(/'/g, "\\'");

  const bayOptions = [
    ...Array.from({ length: 10 }, (_, i) => String(i + 1)),
    "End Cap",
    "Exterior Wall"
  ];

  const baySelectHtml = `
    <select id="bay-input-${id}" class="loc-edit-input bay-input">
      <option value="">Bay</option>
      ${bayOptions.map(opt => `
        <option value="${opt}" ${String(currentBay) === opt ? 'selected' : ''}>
          ${opt}
        </option>
      `).join('')}
    </select>
  `;

  container.innerHTML = `
    <div class="loc-edit-form">
      <input type="number" id="aisle-input-${id}" class="loc-edit-input aisle-input" placeholder="Aisle" value="${currentAisle || ''}">
      ${baySelectHtml}
      <button class="help-icon-btn" onclick="openHelpModal()" type="button" title="Where do I find the Bay number?">?</button>
      <button class="btn btn-save" onclick="saveLocation('${id}')">Save</button>
      <button class="btn btn-cancel" onclick="cancelLocationEdit('${id}', '${safeAisle}', '${safeBay}', ${isWrong})">Cancel</button>
    </div>
    <div id="aisle-error-${id}" style="color: #d9534f; font-size: 0.85em; display: none; margin-top: 4px;"></div>
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
  const errorDiv = document.getElementById(`aisle-error-${id}`);

  const newAisle = aisleInput ? aisleInput.value.trim() : '';
  const newBay = bayInput ? bayInput.value.trim() : '';

  if (newAisle !== '') {
    const aisleNum = parseInt(newAisle, 10);
    const isValid = (aisleNum >= 100 && aisleNum <= 199) || (aisleNum >= 300 && aisleNum <= 399);

    if (isNaN(aisleNum) || !isValid) {
      if (errorDiv) {
        errorDiv.textContent = 'Aisle must be between 100–199 or 300–399.';
        errorDiv.style.display = 'block';
      }
      return;
    }
  }

  if (errorDiv) errorDiv.style.display = 'none';

  const itemInBrowse = browseData.find(p => p.id === id);
  let clearFlag = 0;

  if (itemInBrowse && itemInBrowse.is_wrong === 1) {
    const userConfirmed = confirm('This location had been flagged as incorrect. Have you corrected it?');
    if (userConfirmed) clearFlag = 1;
  }

  const finalIsWrong = (itemInBrowse && itemInBrowse.is_wrong === 1 && !clearFlag) ? 1 : 0;

  const itemNumber = itemInBrowse?.item_number || (String(id).startsWith('temp_') ? id.replace('temp_', '') : '');
  const warehouseId = itemInBrowse?.warehouse_id || CURRENT_WAREHOUSE;

  try {
    const response = await fetch(`${API_BASE_URL}/api/update-location`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        id: id,
        warehouse_id: warehouseId,
        item_number: itemNumber,
        aisle: newAisle,
        bay: newBay,
        is_wrong: finalIsWrong
      })
    });

    if (response.ok) {
      const data = await response.json();
      const currentIsoTime = new Date().toISOString();

      if (itemInBrowse) {
        if (data.id) {
          itemInBrowse.id = data.id;
        }
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
// SEARCH LOGIC
// ==========================================
function renderResultsUI(results) {
  const container = document.getElementById('results');
  const countEl = document.getElementById('count');
  
  if (!container) return;

  if (countEl) {
    countEl.textContent = `${results.length} item${results.length === 1 ? '' : 's'} found`;
  }

  if (results.length === 0) {
    container.innerHTML = '<li class="no-results">No products found.</li>';
    return;
  }

  const favorites = getFavorites();
  const favoriteItemNumbers = new Set(favorites.map(f => String(f.item_number).trim()));

  container.innerHTML = results.map(prod => {
    const prodItemNumber = String(prod.item_number || '').trim();
    const isFav = favoriteItemNumbers.has(prodItemNumber);
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
          <div class="product-title">${escapeHtml(prod.product_name)}</div>
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
        <button class="${favClass}" onclick="toggleFavorite('${prod.id}', this)">&#9733;</button>
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
    const noteKey = prod.item_number || prod.id;
    const prodNote = notes[noteKey] || '';
    const identifierText = getIdentifierDisplay(prod);
    const isFirst = index === 0;
    const isLast = index === favorites.length - 1;
    const targetKey = prod.item_number || prod.id;

    const reorderBtnsHtml = favorites.length > 1 ? `
    <div class="reorder-btns">
      <button class="move-btn" onclick="moveFavorite(${index}, -1)" ${isFirst ? 'disabled' : ''}>&#9650;</button>
      <button class="move-btn" onclick="moveFavorite(${index}, 1)" ${isLast ? 'disabled' : ''}>&#9660;</button>
    </div>
  ` : '';

	  return `
	    <li class="product-card">
	      ${reorderBtnsHtml}
	      <div class="product-info">
	        <div class="product-title">${escapeHtml(prod.product_name)}</div>
	        <div class="product-details">${identifierText}</div>
	        <div class="note-container">
	          <input 
	            type="text" 
	            class="note-input" 
	            placeholder="Add note (e.g. check endcap)" 
	            value="${escapeHtml(prodNote)}"
	            onchange="saveNote('${escapeHtml(noteKey)}', this.value)"
	          />
	        </div>
	      </div>
	      <button class="fav-btn active" onclick="toggleFavorite('${targetKey}', this)">&#9733;</button>
	    </li>
	  `;
	}).join('');
}

// ==========================================
// BROWSE PRODUCTS & PAGINATION
// ==========================================
let currentBrowseMode = 'name';

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
  const warehouseId = CURRENT_WAREHOUSE;
  const selectedCategory = document.getElementById('filterCategorySelect')?.value || '';
  const selectedAisle = document.getElementById('filterAisleSelect')?.value || document.getElementById('browseAisleSelect')?.value || '';

  let url = `${API_BASE_URL}/api/browse?warehouse=${warehouseId}&page=${page}&limit=${ITEMS_PER_PAGE}&sort=${currentBrowseMode}`;

  if (showReportedIncorrectOnly) url += `&show_incorrect=true`;
  if (showDiscontinuedItems) url += `&show_discontinued=true`;
  if (selectedCategory) url += `&category=${encodeURIComponent(selectedCategory)}`;
  if (selectedAisle) url += `&aisle=${encodeURIComponent(selectedAisle)}`;

  try {
    const res = await fetch(url);
    const data = await res.json();

    browseData = data.products || [];
    currentBrowsePageNum = data.page || page;
    totalBrowsePages = data.totalPages || 1;

    renderActiveFilterChips();

    if (currentBrowseMode === 'aisle') {
      renderBrowseByAislePage();
    } else if (currentBrowseMode === 'category') {
      renderBrowseByCategoryPage();
    } else if (['updated_at', 'updated', 'date_added'].includes(currentBrowseMode)) {
      renderBrowseByDatePage();
    } else {
      renderBrowsePage();
    }
  } catch (err) {
    console.error('Error fetching browse products:', err);
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
  const favoriteItemNumbers = new Set(favorites.map(f => String(f.item_number).trim()));

  container.innerHTML = browseData.map(prod => {
    const prodItemNumber = String(prod.item_number || '').trim();
    const isFav = favoriteItemNumbers.has(prodItemNumber);
    const identifierText = getIdentifierDisplay(prod);
    const favClass = isFav ? 'fav-btn active' : 'fav-btn';
    const aisle = prod.aisle || '';
    const bay = prod.bay || '';
    const isWrong = prod.is_wrong ? 1 : 0;
    const locationStr = aisle ? `Aisle ${aisle}${bay ? ' - Bay ' + bay : ''}` : 'Location unassigned';
    const badgeClass = aisle ? 'loc-badge assigned' : 'loc-badge unassigned';

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
          <div class="browse-product-title"><strong>${escapeHtml(prod.product_name)}</strong></div>
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
        <button class="${favClass}" onclick="toggleFavorite('${prod.id}', this)">&#9733;</button>
      </div>
    `;
  }).join('');
}

function renderBrowseByCategoryPage() {
  updatePaginationUI();
  const container = document.getElementById('browseListContainer');
  if (!container) return;

  if (browseData.length === 0) {
    container.innerHTML = '<div class="empty-aisle-notice">No items found for this category page.</div>';
    return;
  }

  const categoryGroups = {};
  browseData.forEach(prod => {
    const catKey = (prod.category && prod.category.trim()) ? prod.category.trim() : 'Uncategorized';
    if (!categoryGroups[catKey]) categoryGroups[catKey] = [];
    categoryGroups[catKey].push(prod);
  });

  const sortedCategories = Object.keys(categoryGroups).sort((a, b) => {
    if (a === 'Uncategorized') return 1;
    if (b === 'Uncategorized') return -1;
    return a.localeCompare(b);
  });

  const favorites = getFavorites();
  const favoriteItemNumbers = new Set(favorites.map(f => String(f.item_number).trim()));

  container.innerHTML = sortedCategories.map(catKey => {
    const catItems = categoryGroups[catKey];

    return `
      <div class="aisle-group">
        <h2 class="aisle-group-header">
          ${escapeHtml(catKey)}
        </h2>
        <div class="aisle-group-body">
          ${catItems.map(prod => {
            const prodItemNumber = String(prod.item_number || '').trim();
            const isFav = favoriteItemNumbers.has(prodItemNumber);
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
                  <div class="browse-product-title"><strong>${escapeHtml(prod.product_name)}</strong></div>
                  <div class="product-details">
                    ${identifierText} | 
                    <span id="loc-edit-${prod.id}">
                      <span class="${badgeClass}" onclick="openLocationEditor('${prod.id}', '${safeAisle}', '${safeBay}',${isWrong})" title="Click to update location">
                        ${locationStr} &#9998;
                      </span>
                      ${incorrectBtn}
                    </span>
                  </div>
                </div>
                <button class="${favClass}" onclick="toggleFavorite('${prod.id}', this)">&#9733;</button>
              </div>
            `;
          }).join('')}
        </div>
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
  const favoriteItemNumbers = new Set(favorites.map(f => String(f.item_number).trim()));

  container.innerHTML = sortedAisles.map(aisleKey => {
    const aisleItems = aisleGroups[aisleKey];

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
              ? `${aisleKey} - ${bayKey}`
              : bayKey;

            return `
              <div class="bay-subgroup">
                <h3 class="bay-group-header">${subHeadingText}</h3>${items.map(prod => {
                  const prodItemNumber = String(prod.item_number || '').trim();
                  const isFav = favoriteItemNumbers.has(prodItemNumber);
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
                        <div class="browse-product-title"><strong>${escapeHtml(prod.product_name)}</strong></div>
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
                      <button class="${favClass}" onclick="toggleFavorite('${prod.id}', this)">&#9733;</button>
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

function getDateGroupLabel(dateStr) {
  if (!dateStr) return 'Unknown Date';

  let cleanStr = dateStr.replace(/(\.\d{3})\d+/, '$1');
  if (!cleanStr.endsWith('Z') && !cleanStr.includes('+')) {
    cleanStr += 'Z';
  }

  const itemDate = new Date(cleanStr);
  if (isNaN(itemDate.getTime())) return 'Unknown Date';

  const now = new Date();
  const startOfToday = new Date(now.getFullYear(), now.getMonth(), now.getDate());
  const startOfItemDate = new Date(itemDate.getFullYear(), itemDate.getMonth(), itemDate.getDate());

  const diffMs = startOfToday - startOfItemDate;
  const diffDays = Math.floor(diffMs / (1000 * 60 * 60 * 24));

  if (diffDays <= 0) return 'Today';
  if (diffDays === 1) return 'Yesterday';
  if (diffDays <= 7) return 'This Week';
  if (diffDays <= 30) return 'This Month';

  return 'Earlier';
}

function renderBrowseByDatePage() {
  updatePaginationUI();
  const container = document.getElementById('browseListContainer');
  if (!container) return;

  if (browseData.length === 0) {
    container.innerHTML = '<div class="empty-aisle-notice">No items found for this page.</div>';
    return;
  }

  const dateGroups = {};
  browseData.forEach(prod => {
    const groupKey = getDateGroupLabel(prod.updated_at);
    if (!dateGroups[groupKey]) dateGroups[groupKey] = [];
    dateGroups[groupKey].push(prod);
  });

  const groupOrder = ['Today', 'Yesterday', 'This Week', 'This Month', 'Earlier', 'Unknown Date'];
  const activeGroups = groupOrder.filter(key => dateGroups[key] && dateGroups[key].length > 0);

  const favorites = getFavorites();
  const favoriteItemNumbers = new Set(favorites.map(f => String(f.item_number).trim()));

  container.innerHTML = activeGroups.map(groupKey => {
    const items = dateGroups[groupKey];

    return `
      <div class="aisle-group">
        <h2 class="aisle-group-header">
          ${groupKey}
        </h2>
        <div class="aisle-group-body">
          ${items.map(prod => {
            const prodItemNumber = String(prod.item_number || '').trim();
            const isFav = favoriteItemNumbers.has(prodItemNumber);
            const identifierText = getIdentifierDisplay(prod);
            const favClass = isFav ? 'fav-btn active' : 'fav-btn';
            const aisle = prod.aisle || '';
            const bay = prod.bay || '';
            const isWrong = prod.is_wrong ? 1 : 0;
            const locationStr = aisle ? `Aisle ${aisle}${bay ? ' - Bay ' + bay : ''}` : 'Location unassigned';
            const badgeClass = aisle ? 'loc-badge assigned' : 'loc-badge unassigned';

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
              <div class="browse-product-row aisle-item-row">
                <div class="browse-product-details">
                  <div class="browse-product-title"><strong>${escapeHtml(prod.product_name)}</strong></div>
                  <div class="product-details">
                    ${identifierText} | 
                    <span id="loc-edit-${prod.id}">
                      <span class="${badgeClass}" onclick="openLocationEditor('${prod.id}', '${safeAisle}', '${safeBay}',${isWrong})" title="Click to update location">
                        ${locationStr} &#9998;
                      </span>
                      ${incorrectBtn}
                    </span>
                    ${timeAgoHtml}
                  </div>
                </div>
                <button class="${favClass}" onclick="toggleFavorite('${prod.id}', this)">&#9733;</button>
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
  const warehouseId = (typeof newWarehouseId === 'object' && newWarehouseId !== null)
    ? (newWarehouseId.warehouse_id || newWarehouseId.id)
    : newWarehouseId;

  CURRENT_WAREHOUSE = String(warehouseId);

  if (typeof newWarehouseId === 'object' && newWarehouseId !== null) {
    localStorage.setItem('selected_warehouse', JSON.stringify(newWarehouseId));
  } else if (!localStorage.getItem('selected_warehouse')) {
    localStorage.setItem('selected_warehouse', JSON.stringify({ warehouse_id: CURRENT_WAREHOUSE }));
  }

  populateAisleDropdown();
  populateCategoryDropdown();
  
  document.querySelectorAll('.warehouse-select-dropdown, #warehouseSelect').forEach(selectEl => {
    selectEl.value = CURRENT_WAREHOUSE;
  });

  const searchBox = document.getElementById('search-input');
  if (searchBox && searchBox.value.trim()) {
    performSearch();
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
  const searchBox = document.getElementById('search-input');
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
    const searchBox = document.getElementById('search-input');
    if (searchBox && searchBox.value.trim()) {
      performSearch();
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
// FILTER DRAWER & SORT HELPERS
// ==========================================
function toggleFilterDrawer(open) {
  const drawer = document.getElementById('filterDrawer');
  const backdrop = document.getElementById('filterDrawerBackdrop');
  
  if (open) {
    populateCategoryDropdown();
    populateAisleDropdown();

    if (backdrop) backdrop.style.display = 'block';
    if (drawer) drawer.style.right = '0px';
  } else {
    if (drawer) drawer.style.right = '-300px';
    if (backdrop) backdrop.style.display = 'none';
  }
}

function onBrowseSortChange(sortValue) {
  const value = (typeof sortValue === 'string') ? sortValue : sortValue?.target?.value;
  
  if (value) {
    currentBrowseMode = value;
  }

  if (currentBrowseMode === 'aisle') {
    populateAisleDropdown();
  } else if (currentBrowseMode === 'category') {
    populateCategoryDropdown();
  }

  startBrowse(1);
}

function applyFilters() {
  toggleFilterDrawer(false);
  populateAisleDropdown();
  startBrowse(1);
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
  const isChecked = typeof checked === 'boolean' ? checked : checked?.target?.checked;
  
  showReportedIncorrectOnly = !!isChecked;
  startBrowse(1);
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

function onAisleFilterChange(value) {
  selectedAisle = value;
  startBrowse(1);
}

// ==========================================
// SEARCH LOGIC & APP INITIALIZATION
// ==========================================
function showLoadingSpinner(show) {
  const searchInput = document.getElementById('search-input');
  const searchBtn = document.getElementById('search-btn');
  const globalSpinner = document.getElementById('loading-spinner');

  if (globalSpinner) {
    globalSpinner.style.display = show ? 'block' : 'none';
  }

  if (searchBtn && searchInput) {
    if (show) {
      searchInput.disabled = true;
      searchBtn.disabled = true;
      searchBtn.innerHTML = `<span class="spinner"></span> Searching...`;
    } else {
      searchInput.disabled = false;
      searchBtn.disabled = false;
      searchBtn.textContent = 'Search';
    }
  }
}

async function performSearch() {
  const searchInput = document.getElementById('search-input');
  const query = searchInput ? searchInput.value.trim() : '';
  const searchMode = document.querySelector('input[name="searchMode"]:checked')?.value || 'item_number';

  if (!query) return;

  showLoadingSpinner(true);

  try {
    const params = new URLSearchParams({
      q: query,
      mode: searchMode,
      warehouse: CURRENT_WAREHOUSE,
      show_discontinued: showDiscontinuedItems
    });

    const response = await fetch(`${API_BASE_URL}/api/search?${params.toString()}`);
    if (response.ok) {
      const data = await response.json();
      window._lastSearchResults = data;
      renderResultsUI(data);
    } else {
      alert('Search request failed.');
    }
  } catch (err) {
    console.error('Search error:', err);
    alert('Error connecting to search server.');
  } finally {
    showLoadingSpinner(false);
  }
}

document.addEventListener('DOMContentLoaded', () => {
  initWarehouseSelection();
  loadWarehouses();
  populateAisleDropdown();
  populateCategoryDropdown();
  startBrowse(1);

  initSearchModeToggle();
  initVoiceSearch();

  const searchInput = document.getElementById('search-input');
  const searchBtn = document.getElementById('search-btn');
  const radioButtons = document.querySelectorAll('input[name="searchMode"]');

  if (searchBtn) {
    searchBtn.addEventListener('click', performSearch);
  }

  if (searchInput) {
    searchInput.addEventListener('keydown', (e) => {
      if (e.key === 'Enter') {
        e.preventDefault();
        performSearch();
      }
    });
  }

  radioButtons.forEach(radio => {
    radio.addEventListener('change', (e) => {
      const mode = e.target.value;
      if (mode === 'item_number') {
        searchInput.placeholder = 'Enter 3-7 digit item number...';
      } else if (mode === 'product_name') {
        searchInput.placeholder = 'Search by product title...';
      } else if (mode === 'sku') {
        searchInput.placeholder = 'Scan or enter SKU barcode...';
      }
    });
  });

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

async function promptEditItemNumber(productId) {
  const newItemNumber = prompt("Enter Item Number:");
  if (!newItemNumber || !newItemNumber.trim()) return;

  await updateProductIdentifier(productId, { item_number: newItemNumber.trim() });
}

async function promptEditSku(productId) {
  const modal = document.getElementById('skuChoiceModal');
  const cameraBtn = document.getElementById('skuCameraBtn');
  const manualBtn = document.getElementById('skuManualBtn');

  if (!modal) {
    // Fallback if modal HTML isn't present
    const choice = confirm("Choose SKU entry method:\n\n[OK] = Camera\n[Cancel] = Manual");
    if (choice) {
      startCameraBarcodeScanner(async (code) => { if (code) await updateProductIdentifier(productId, { sku: code }); });
    } else {
      const sku = prompt("Enter SKU manually:");
      if (sku && sku.trim()) await updateProductIdentifier(productId, { sku: sku.trim() });
    }
    return;
  }

  modal.style.display = 'flex';

  return new Promise((resolve) => {
    function cleanup() {
      modal.style.display = 'none';
      cameraBtn.onclick = null;
      manualBtn.onclick = null;
    }

    cameraBtn.onclick = async () => {
      cleanup();
      startCameraBarcodeScanner(async (scannedBarcode) => {
        if (scannedBarcode) {
          await updateProductIdentifier(productId, { sku: scannedBarcode });
        }
      });
      resolve();
    };

    manualBtn.onclick = async () => {
      cleanup();
      const newSku = prompt("Enter SKU manually:");
      if (newSku && newSku.trim()) {
        await updateProductIdentifier(productId, { sku: newSku.trim() });
      }
      resolve();
    };
  });
}

async function startCameraBarcodeScanner(onScanned) {
  if (!('BarcodeDetector' in window)) {
    const manualFallback = prompt("Camera scanning not natively supported on this browser. Enter SKU manually:");
    if (manualFallback) onScanned(manualFallback.trim());
    return;
  }

  const video = document.createElement('video');
  video.style.position = 'fixed';
  video.style.top = '0';
  video.style.left = '0';
  video.style.width = '100vw';
  video.style.height = '100vh';
  video.style.zIndex = '9999';
  video.style.backgroundColor = 'black';
  video.autoplay = true;

  const closeBtn = document.createElement('button');
  closeBtn.innerText = 'Close Scanner';
  closeBtn.style.position = 'fixed';
  closeBtn.style.top = '20px';
  closeBtn.style.right = '20px';
  closeBtn.style.zIndex = '10000';
  closeBtn.style.padding = '10px 15px';
  closeBtn.onclick = () => stopScanner();

  document.body.appendChild(video);
  document.body.appendChild(closeBtn);

  let stream = null;
  let intervalId = null;

  function stopScanner() {
    if (intervalId) clearInterval(intervalId);
    if (stream) stream.getTracks().forEach(track => track.stop());
    video.remove();
    closeBtn.remove();
  }

  try {
    stream = await navigator.mediaDevices.getUserMedia({ video: { facingMode: 'environment' } });
    video.srcObject = stream;

    const barcodeDetector = new BarcodeDetector({ formats: ['upc_a', 'upc_e', 'ean_13', 'code_128', 'qr_code'] });

    intervalId = setInterval(async () => {
      try {
        const barcodes = await barcodeDetector.detect(video);
        if (barcodes.length > 0) {
          const code = barcodes[0].rawValue;
          stopScanner();
          onScanned(code);
        }
      } catch (err) {
        console.error("Barcode detection error:", err);
      }
    }, 500);

  } catch (err) {
    alert("Could not access camera for scanning: " + err.message);
    stopScanner();
  }
}

async function updateProductIdentifier(productId, updates) {
  try {
    const res = await fetch(`${API_BASE_URL}/api/update-identifier`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ id: productId, ...updates })
    });

    const data = await res.json();
    if (res.ok && data.success) {
      alert("Updated successfully!");
      if (typeof performSearch === 'function') performSearch();
    } else {
      alert("Error: " + (data.error || "Failed to update identifier"));
    }
  } catch (err) {
    console.error("Update identifier error:", err);
    alert("Network error updating identifier.");
  }
}

function escapeHtml(str) {
  if (!str) return '';
  return String(str)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#039;');
}

function initSearchModeToggle() {
  const searchInput = document.getElementById('search-input');
  const radioButtons = document.querySelectorAll('input[name="searchMode"]');
  const barcodeBtn = document.getElementById('barcodeBtn');

  if (!searchInput || !radioButtons.length) return;

  function updateInputMode(mode) {
    if (mode === 'item_number') {
      searchInput.placeholder = 'Scan price tag or enter item #...';
      searchInput.setAttribute('inputmode', 'numeric');
      searchInput.setAttribute('pattern', '[0-9]*');
      if (barcodeBtn) barcodeBtn.style.display = 'inline-flex';
      searchInput.classList.add('has-double-icon');
    } else if (mode === 'product_name') {
      searchInput.placeholder = 'Search by product title...';
      searchInput.setAttribute('inputmode', 'text');
      searchInput.removeAttribute('pattern');
      if (barcodeBtn) barcodeBtn.style.display = 'none';
      searchInput.classList.remove('has-double-icon');
    } else if (mode === 'sku') {
      searchInput.placeholder = 'Scan or enter SKU barcode...';
      searchInput.setAttribute('inputmode', 'numeric');
      searchInput.setAttribute('pattern', '[0-9]*');
      if (barcodeBtn) barcodeBtn.style.display = 'inline-flex';
      searchInput.classList.add('has-double-icon');
    }
  }

  const checkedRadio = document.querySelector('input[name="searchMode"]:checked');
  if (checkedRadio) updateInputMode(checkedRadio.value);

  radioButtons.forEach(radio => {
    radio.addEventListener('change', (e) => updateInputMode(e.target.value));
  });

  if (barcodeBtn) {
    barcodeBtn.addEventListener('click', () => {
      if (typeof startCameraBarcodeScanner === 'function') {
        startCameraBarcodeScanner((scannedBarcode) => {
          if (scannedBarcode) {
            searchInput.value = scannedBarcode;
            if (typeof performSearch === 'function') performSearch();
          }
        });
      }
    });
  }
}

function disableProductSearch(placeholderText = "Select a warehouse first...") {
  const productInput = document.getElementById('search-input');
  const productButton = document.getElementById('search-btn');

  if (productInput) {
    productInput.disabled = true;
    productInput.placeholder = placeholderText;
    productInput.style.cursor = 'not-allowed';
    productInput.style.opacity = '0.6';
  }

  if (productButton) {
    productButton.disabled = true;
    productButton.style.cursor = 'not-allowed';
    productButton.style.opacity = '0.6';
  }
}

function enableProductSearch() {
  const productInput = document.getElementById('search-input');
  const productButton = document.getElementById('search-btn');

  if (productInput) {
    productInput.disabled = false;
    productInput.placeholder = "Search items or item #...";
    productInput.style.cursor = 'text';
    productInput.style.opacity = '1';
  }

  if (productButton) {
    productButton.disabled = false;
    productButton.style.cursor = 'pointer';
    productButton.style.opacity = '1';
  }
}

function initVoiceSearch() {
  const micBtn = document.getElementById('micBtn');
  const searchInput = document.getElementById('search-input');

  if (!micBtn || !searchInput) return;

  const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;

  if (!SpeechRecognition) {
    micBtn.style.display = 'none';
    return;
  }

  const recognition = new SpeechRecognition();
  recognition.continuous = false;
  recognition.interimResults = false;
  recognition.lang = 'en-US';

  micBtn.addEventListener('click', () => {
    try {
      recognition.start();
      micBtn.classList.add('listening');
    } catch (err) {
      console.error('Speech recognition already started or failed:', err);
    }
  });

  recognition.onresult = (event) => {
    const transcript = event.results[0][0].transcript;
    searchInput.value = transcript;
    micBtn.classList.remove('listening');
    
    if (typeof performSearch === 'function') {
      performSearch();
    }
  };

  recognition.onerror = (event) => {
    console.error('Speech recognition error:', event.error);
    micBtn.classList.remove('listening');
  };

  recognition.onend = () => {
    micBtn.classList.remove('listening');
  };
}

async function populateCategoryDropdown() {
  const categorySelect = document.getElementById('filterCategorySelect');
  if (!categorySelect) return;

  const currentlySelected = categorySelect.value || '';

  try {
    const res = await fetch(`${API_BASE_URL}/api/categories?warehouse=${CURRENT_WAREHOUSE}`);
    const categories = await res.json();

    categorySelect.innerHTML = '<option value="">All Categories</option>';
    
    if (Array.isArray(categories)) {
      categories.forEach(cat => {
        if (!cat || !cat.trim()) return;
        const cleanCat = cat.trim();
        const option = document.createElement('option');
        option.value = cleanCat;
        option.textContent = cleanCat;

        if (cleanCat === currentlySelected) {
          option.selected = true;
        }

        categorySelect.appendChild(option);
      });
    }

    if (currentlySelected) {
      categorySelect.value = currentlySelected;
    }
  } catch (err) {
    console.error('Error populating categories dropdown:', err);
  }
}

function renderActiveFilterChips() {
  const container = document.getElementById('activeFilterChips');
  if (!container) return;

  const selectedCategory = document.getElementById('filterCategorySelect')?.value || '';
  const selectedAisle = document.getElementById('filterAisleSelect')?.value || document.getElementById('browseAisleSelect')?.value || '';

  const chips = [];

  if (selectedAisle) {
    chips.push({
      label: `Aisle: ${selectedAisle}`,
      clear: () => {
        const select = document.getElementById('filterAisleSelect') || document.getElementById('browseAisleSelect');
        if (select) select.value = '';
        onAisleFilterChange('');
      }
    });
  }

  if (selectedCategory) {
    chips.push({
      label: `Category: ${selectedCategory}`,
      clear: () => {
        const select = document.getElementById('filterCategorySelect');
        if (select) select.value = '';
        startBrowse(1);
      }
    });
  }

  if (showReportedIncorrectOnly) {
    chips.push({
      label: `Reported Incorrect`,
      clear: () => {
        const checkbox = document.getElementById('showReportedCheckbox');
        if (checkbox) checkbox.checked = false;
        onToggleIncorrectFilter(false);
      }
    });
  }

  if (chips.length === 0) {
    container.innerHTML = '';
    container.style.display = 'none';
    return;
  }

  container.style.display = 'flex';
  container.innerHTML = chips.map((chip, index) => `
    <span class="filter-chip">
      ${escapeHtml(chip.label)}
      <button class="filter-chip-remove" onclick="removeFilterChip(${index})">&times;</button>
    </span>
  `).join('');

  window._activeChipHandlers = chips.map(c => c.clear);
}

function removeFilterChip(index) {
  if (window._activeChipHandlers && window._activeChipHandlers[index]) {
    window._activeChipHandlers[index]();
  }
}