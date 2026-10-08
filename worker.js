export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    const pathname = url.pathname;

    const corsHeaders = {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type',
      'Content-Type': 'application/json'
    };

    if (request.method === 'OPTIONS') {
      return new Response(null, { headers: corsHeaders });
    }

    try {
      // 1. Live Search API
      if (pathname === '/api/search') {
        return await handleSearch(request, env, corsHeaders);
      }

      // 2. Paginated Browse API
      if (pathname === '/api/browse') {
        const warehouseId = url.searchParams.get('warehouse') || url.searchParams.get('warehouse_id');
        const page = Math.max(1, parseInt(url.searchParams.get('page') || '1', 10) || 1);
        const limit = Math.max(1, parseInt(url.searchParams.get('limit') || '20', 10) || 20);
        const sort = url.searchParams.get('sort') || 'name';
        const showDiscontinued = url.searchParams.get('show_discontinued') === 'true';
        const showIncorrect = url.searchParams.get('show_incorrect') === 'true' || url.searchParams.get('show_incorrect') === '1';
        const offset = (page - 1) * limit;
        const selectedAisle = url.searchParams.get('aisle');

        try {
          const whereConditions = ["warehouse_id = ?"];
          const bindParams = [warehouseId];

          if (!showDiscontinued) {
            whereConditions.push("(is_discontinued IS NULL OR is_discontinued = 0)");
          }

          if (showIncorrect) {
            whereConditions.push("(is_wrong = 1 OR is_wrong = '1' OR is_wrong IS TRUE)");
          }

          if (sort === 'aisle') {
            whereConditions.push("(aisle IS NOT NULL AND TRIM(aisle) != '')");
          }

          if (selectedAisle) {
            whereConditions.push("aisle = ?");
            bindParams.push(selectedAisle);
          }

          const whereClause = "WHERE " + whereConditions.join(" AND ");

          const countQuery = `SELECT COUNT(*) AS total FROM products ${whereClause}`;
          const countStmt = await env.DB.prepare(countQuery).bind(...bindParams).first();
          const total = countStmt ? Number(countStmt.total || countStmt['COUNT(*)'] || 0) : 0;

          let orderByClause = "ORDER BY product_name ASC";
          if (sort === 'aisle') {
            orderByClause = `
              ORDER BY 
                CAST(aisle AS INTEGER) ASC, 
                CAST(bay AS INTEGER) ASC, 
                product_name ASC
            `;
          } else if (sort === 'item_number') {
            orderByClause = `ORDER BY CAST(item_number AS INTEGER) ASC, item_number ASC`;
          } else if (sort === 'sku') {
            orderByClause = `ORDER BY CAST(sku AS INTEGER) ASC, sku ASC`;
          } else if (sort === 'updated_at' || sort === 'updated') {
            orderByClause = `ORDER BY updated_at DESC`;
          }

          const selectQuery = `
            SELECT id, sku, item_number, product_id, product_name, category, warehouse_id, product_url, aisle, bay, is_wrong, is_discontinued, updated_at
            FROM products
            ${whereClause}
            ${orderByClause}
            LIMIT ? OFFSET ?
          `;

          const { results } = await env.DB.prepare(selectQuery)
            .bind(...bindParams, limit, offset)
            .all();

          return new Response(JSON.stringify({
            total: total,
            page: page,
            totalPages: Math.max(1, Math.ceil(total / limit)),
            products: results || []
          }), { status: 200, headers: corsHeaders });

        } catch (err) {
          console.error("D1 Error:", err);
          return new Response(JSON.stringify({ 
            error: err.message,
            products: [] 
          }), { status: 500, headers: corsHeaders });
        }
      }

      // 3. Distinct Aisles API
      if (pathname === '/api/aisles') {
        const warehouseId = url.searchParams.get('warehouse');
        const { results } = await env.DB.prepare(`
          SELECT DISTINCT aisle 
          FROM products 
          WHERE warehouse_id = ? 
            AND aisle IS NOT NULL 
            AND TRIM(aisle) != ''
          ORDER BY CAST(aisle AS INTEGER) ASC, aisle ASC
        `).bind(warehouseId).all();

        const aisles = (results || []).map(r => r.aisle);
        return new Response(JSON.stringify(aisles), { headers: corsHeaders });
      }

      // 4. Update Location API
      if (pathname === '/api/update-location' && request.method === 'POST') {
        const { id, aisle, bay, is_wrong } = await request.json();
        if (!id) return new Response(JSON.stringify({ error: 'Missing product ID' }), { status: 400, headers: corsHeaders });

        await env.DB.prepare(`
          UPDATE products
          SET aisle = ?, bay = ?, is_wrong = ?, updated_at = datetime('now')
          WHERE id = ?
        `).bind(aisle || '', bay || '', is_wrong ? 1 : 0, id).run();

        return new Response(JSON.stringify({ success: true }), { headers: corsHeaders });
      }

      // 5. Warehouses API
      if (pathname === '/api/warehouses') {
        const { results } = await env.DB.prepare(`
          SELECT warehouse_id, warehouse_name, street_address, city, state, zip_code, lat, lng
          FROM warehouses 
          ORDER BY warehouse_id ASC
        `).all();

        return new Response(JSON.stringify(results || []), { headers: corsHeaders });
      }

      // 6. Flag Location Incorrect API
      if (pathname === '/api/flag-incorrect' && request.method === 'POST') {
        const { id } = await request.json();
        if (!id) return new Response(JSON.stringify({ error: 'Missing product ID' }), { status: 400, headers: corsHeaders });

        await env.DB.prepare(`
          UPDATE products SET is_wrong = 1, updated_at = datetime('now') WHERE id = ?
        `).bind(id).run();

        return new Response(JSON.stringify({ success: true }), { headers: corsHeaders });
      }

      // 7. Flag Product as Discontinued API
      if (pathname === '/api/flag-discontinued' && request.method === 'POST') {
        const { id, is_discontinued } = await request.json();
        if (!id) return new Response(JSON.stringify({ error: 'Missing product ID' }), { status: 400, headers: corsHeaders });

        await env.DB.prepare(`
          UPDATE products SET is_discontinued = ?, updated_at = datetime('now') WHERE id = ?
        `).bind(is_discontinued ? 1 : 0, id).run();

        return new Response(JSON.stringify({ success: true }), { headers: corsHeaders });
      }

      // 8. Update Item Number / SKU Identifier API
      if (pathname === '/api/update-identifier' && request.method === 'POST') {
        const { id, item_number, sku } = await request.json();
        if (!id) {
          return new Response(JSON.stringify({ error: 'Missing product ID' }), { status: 400, headers: corsHeaders });
        }

        const existing = await env.DB.prepare('SELECT item_number, sku FROM products WHERE id = ?').bind(id).first();
        if (!existing) {
          return new Response(JSON.stringify({ error: 'Product not found' }), { status: 404, headers: corsHeaders });
        }

        let updateFields = [];
        let bindParams = [];

        if (item_number !== undefined) {
          const isCurrentlyEmpty = !existing.item_number || String(existing.item_number).trim() === '';
          if (isCurrentlyEmpty) {
            updateFields.push('item_number = ?');
            bindParams.push(item_number.trim());
          } else {
            return new Response(JSON.stringify({ error: 'Item number is already set and cannot be edited.' }), { status: 400, headers: corsHeaders });
          }
        }

        if (sku !== undefined) {
          updateFields.push('sku = ?');
          bindParams.push(sku.trim());
        }

        if (updateFields.length === 0) {
          return new Response(JSON.stringify({ error: 'No valid fields to update' }), { status: 400, headers: corsHeaders });
        }

        updateFields.push("updated_at = datetime('now')");
        bindParams.push(id);

        const query = `UPDATE products SET ${updateFields.join(', ')} WHERE id = ?`;
        await env.DB.prepare(query).bind(...bindParams).run();

        return new Response(JSON.stringify({ success: true }), { headers: corsHeaders });
      }

      return new Response(JSON.stringify({ error: 'Endpoint not found' }), { status: 404, headers: corsHeaders });

    } catch (err) {
      return new Response(JSON.stringify({ error: err.message || 'Internal Server Error' }), { status: 500, headers: corsHeaders });
    }
  }
};

// ----------------------------------------------------
// HELPER FUNCTIONS
// ----------------------------------------------------

async function handleSearch(request, env, corsHeaders) {
  try {
    const url = new URL(request.url);
    const query = (url.searchParams.get('q') || '').trim();
    const searchMode = (url.searchParams.get('mode') || 'item_number').trim();
    const rawWarehouse = url.searchParams.get('warehouse') || '';
    const warehouseId = String(rawWarehouse).replace(/-wh$/i, '').trim();

    console.log(`\n🔍 --- SEARCH INITIATED ---`);
    console.log(`Query: "${query}" | Mode: "${searchMode}" | Warehouse ID: "${warehouseId}"`);

    if (!query || !warehouseId) {
      console.log(`⚠️ Search aborted: missing query or warehouseId.`);
      return new Response(JSON.stringify([]), { headers: corsHeaders });
    }

    let dbQuery = "";
    let bindings = [];

    if (searchMode === 'item_number') {
      dbQuery = "SELECT * FROM products WHERE item_number = ? AND warehouse_id = ?";
      bindings = [query, warehouseId];
    } else if (searchMode === 'sku') {
      dbQuery = "SELECT * FROM products WHERE sku = ? AND warehouse_id = ?";
      bindings = [query, warehouseId];
    } else {
      dbQuery = "SELECT * FROM products WHERE product_name LIKE ? AND warehouse_id = ?";
      bindings = [`%${query}%`, warehouseId];
    }

    const results = await env.DB.prepare(dbQuery).bind(...bindings).all();

    if (results && results.results && results.results.length > 0) {
      console.log(`✅ Local D1 Hit: Found ${results.results.length} product(s).`);
      return new Response(JSON.stringify(results.results), { headers: corsHeaders });
    }

    console.log(`❌ Local D1 Miss for item "${query}". Attempting Live Fallback...`);

    // Live Fallback on D1 Miss
    if (searchMode === 'item_number' && /^\d{5,7}$/.test(query)) {
      // Step A: Attempt Costco.com scrape first
      console.log(`🌐 Step A: Querying main Costco.com...`);
      let fetchedProduct = await fetchCostcoItemDetails(query, warehouseId);

      if (fetchedProduct) {
        console.log(`✅ Costco.com Hit: "${fetchedProduct.product_name}"`);
      } else {
        console.log(`❌ Costco.com Miss or 404.`);
      }

      // Step B: Fallback to Sameday/Instacart if Costco.com fails
      if (!fetchedProduct) {
        let zipCode = '01331';
        try {
          const wh = await env.DB.prepare("SELECT zip_code FROM warehouses WHERE warehouse_id = ?").bind(warehouseId).first();
          if (wh && wh.zip_code) {
            zipCode = String(wh.zip_code).trim().split('-')[0].substring(0, 5);
            console.log(`📍 D1 Warehouse ZIP Found: ${zipCode} for Warehouse #${warehouseId}`);
          }
        } catch (e) {
          console.error("⚠️ Failed to query warehouse ZIP code from D1:", e);
        }

        console.log(`🛒 Step B: Querying Sameday (ZIP: ${zipCode})...`);
        fetchedProduct = await fetchFromSamedayGraphQL(query, warehouseId, zipCode, env);
      }

      if (fetchedProduct) {
        console.log(`🎉 Live Fetch Success: Found "${fetchedProduct.product_name}". Inserting into D1...`);
        const newId = (typeof crypto !== 'undefined' && crypto.randomUUID) 
          ? crypto.randomUUID() 
          : `${Date.now()}-${Math.random().toString(36).substring(2, 9)}`;

        const now = new Date().toISOString();

        // Exact 8-column insert with 8 bound parameters
        try {
          await env.DB.prepare(`
            INSERT INTO products (id, item_number, product_id, product_name, category, product_url, warehouse_id, updated_at)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
          `).bind(
            newId,
            query,
            fetchedProduct.product_id || '',
            fetchedProduct.product_name || '',
            fetchedProduct.category || '',
            fetchedProduct.product_url || '',
            warehouseId,
            now
          ).run();
          console.log(`💾 Saved to D1 with ID: ${newId} | Product ID: ${fetchedProduct.product_id} (Item Number: ${query})`);
        } catch (dbErr) {
          console.error("⚠️ D1 Insert error, running fallback insert:", dbErr);
          await env.DB.prepare(`
            INSERT INTO products (id, item_number, product_name, product_url, warehouse_id, updated_at)
            VALUES (?, ?, ?, ?, ?, ?)
          `).bind(
            newId,
            query,
            fetchedProduct.product_name || '',
            fetchedProduct.product_url || '',
            warehouseId,
            now
          ).run();
        }

        fetchedProduct.id = newId;
        return new Response(JSON.stringify([fetchedProduct]), { headers: corsHeaders });
      } else {
        console.log(`❌ All Fallbacks Exhausted: Item "${query}" not found on Costco.com or Sameday.`);
      }
    } else {
      console.log(`⚠️ Skipping Live Fallback: searchMode="${searchMode}" or regex match failed.`);
    }

    return new Response(JSON.stringify([]), { headers: corsHeaders });
  } catch (err) {
    console.error(`💥 Search Handler Exception:`, err);
    return new Response(JSON.stringify({ error: err.message, stack: err.stack }), { 
      status: 500, 
      headers: corsHeaders 
    });
  }
}

// --- FALLBACK 1: Main Costco.com HTML/Metadata Scraper ---
async function fetchCostcoItemDetails(itemNumber, warehouseId) {
  const targetUrl = `https://www.costco.com/.product.${itemNumber}.html`;

  const cleanWhsId = String(warehouseId).replace(/-wh$/i, '').trim();

  const whsCookieValue = JSON.stringify({
    nearestWarehouse: { catalog: `${cleanWhsId}-wh` }
  });

  const myWhsCookieValue = JSON.stringify({
    warehouseId: cleanWhsId,
    warehouseName: `Warehouse ${cleanWhsId}`
  });

  const cookieHeader = [
    `WHSE=${cleanWhsId}`,
    `WAREHOUSEDELIVERY_WHS=${encodeURIComponent(whsCookieValue)}`,
    `MY_WAREHOUSE=${encodeURIComponent(myWhsCookieValue)}`,
    `buyInWarehouse=true`
  ].join('; ');

  try {
    const response = await fetch(targetUrl, {
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36',
        'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
        'Cookie': cookieHeader
      },
      redirect: 'follow'
    });

    if (!response.ok) return null;

    const html = await response.text();

    if (html.includes("We're sorry. We were not able to find a match.")) {
      return null;
    }

    let extractedCategory = '';
    let productTitle = '';

    const stateMatches = html.match(/window\.__PRELOADED_STATE__\s*=\s*({[\s\S]*?});<\/script>/i) ||
                         html.match(/window\.__INITIAL_STATE__\s*=\s*({[\s\S]*?});<\/script>/i);

    if (stateMatches && stateMatches[1]) {
      try {
        const state = JSON.parse(stateMatches[1]);
        const productData = state.productDetails || state.product || {};
        productTitle = productData.name || productData.productName || '';

        if (Array.isArray(productData.breadcrumbs)) {
          extractedCategory = productData.breadcrumbs
            .map(b => b.name || b.label)
            .filter(Boolean)
            .filter(name => name.toLowerCase() !== 'home')
            .join(' > ');
        } else if (productData.category) {
          extractedCategory = typeof productData.category === 'string' ? productData.category : productData.category.name;
        }
      } catch (e) {
        // Continue if JSON parsing fails
      }
    }

    if (!extractedCategory || !productTitle) {
      const scriptBlocks = html.split('<script type="application/ld+json">');
      for (let i = 1; i < scriptBlocks.length; i++) {
        const blockContent = scriptBlocks[i].split('</script>')[0];
        if (!blockContent) continue;

        try {
          const metadata = JSON.parse(blockContent.trim());
          const items = Array.isArray(metadata) ? metadata : [metadata];

          for (const item of items) {
            if (!item) continue;

            if (item['@type'] === 'Product' && item.name) {
              if (!productTitle) productTitle = item.name;
              if (!extractedCategory && typeof item.category === 'string') {
                extractedCategory = item.category;
              }
            }

            if (!extractedCategory && item['@type'] === 'BreadcrumbList' && Array.isArray(item.itemListElement)) {
              const crumbs = item.itemListElement
                .map(c => c.name || (c.item && c.item.name))
                .filter(Boolean)
                .filter(name => name.toLowerCase() !== 'home');

              if (crumbs.length > 0) {
                extractedCategory = crumbs.join(' > ');
              }
            }
          }
        } catch (parseErr) {
          // Skip malformed script blocks
        }
      }
    }

    if (!extractedCategory) {
      const metaCategory = html.match(/<meta[^>]*name=["'](category|keywords|search\.category)["'][^>]*content=["']([^"']+)["']/i) ||
                           html.match(/<meta[^>]*content=["']([^"']+)["']/i) && html.match(/name=["'](category|keywords|search\.category)["']/i);
      if (metaCategory && metaCategory[2]) {
        extractedCategory = metaCategory[2].split(',')[0].trim();
      }
    }

    if (!productTitle) {
      const titleMatch = html.match(/<h1[^>]*>([\s\S]*?)<\/h1>/i);
      if (titleMatch) {
        productTitle = titleMatch[1].replace(/<[^>]+>/g, '').trim();
      }
    }

    if (extractedCategory) {
      extractedCategory = extractedCategory
        .replace(/&amp;/g, '&')
        .replace(/&quot;/g, '"')
        .replace(/\s+/g, ' ')
        .trim();
    }

    if (productTitle) {
      return {
        id: '',
        item_number: itemNumber,
        product_id: '',
        product_name: productTitle,
        category: extractedCategory || 'Uncategorized',
        product_url: response.url || targetUrl,
        warehouse_id: cleanWhsId,
        aisle: '',
        bay: '',
        is_wrong: 0,
        is_discontinued: 0
      };
    }

  } catch (err) {
    console.error('Error fetching live Costco item:', err);
  }

  return null;
}

// --- Helper Function to Extract & Clean Categories ---
function extractCategoryFromItem(item) {
  if (!item) return '';

  // 1. Check Breadcrumbs
  if (Array.isArray(item.breadcrumbs) && item.breadcrumbs.length > 0) {
    const crumbs = item.breadcrumbs
      .map(b => typeof b === 'string' ? b : (b.name || b.label || b.text || b.title))
      .filter(Boolean)
      .filter(c => !['home', 'costco', 'departments', 'categories', 'all products'].includes(c.toLowerCase()));
    if (crumbs.length > 0) return crumbs.join(' > ');
  }

  // 2. Check Department / Category / Aisle / Taxonomy properties
  const dept = item.department_name || item.departmentName || item.department?.name || item.department || '';
  const aisle = item.aisle_name || item.aisleName || item.aisle?.name || item.aisle || '';
  const cat = item.category_name || item.categoryName || item.category?.name || item.category || item.taxonomy || '';

  const parts = [dept, aisle, cat]
    .map(p => typeof p === 'string' ? p.trim() : (p?.name || ''))
    .filter(Boolean)
    .filter(c => !['home', 'costco', 'departments', 'categories'].includes(c.toLowerCase()))
    .filter((v, idx, arr) => arr.indexOf(v) === idx);

  if (parts.length > 0) return parts.join(' > ');

  return '';
}

import puppeteer from '@cloudflare/puppeteer';

async function fetchFromSamedayGraphQL(itemNumber, warehouseId, zipCode, env) {
  const cleanZip = String(zipCode).split('-')[0].trim().substring(0, 5);
  const landingUrl = 'https://sameday.costco.com/';
  const searchUrl = `https://sameday.costco.com/store/costco/s?k=${encodeURIComponent(itemNumber)}`;

  console.log(`🌐 [Puppeteer] Launching Cloudflare Headless Browser for Item #${itemNumber}...`);

  let browser = null;
  let interceptedProduct = null;

  try {
    browser = await puppeteer.launch(env.MYBROWSER);
    const page = await browser.newPage();

    await page.setViewport({ width: 1280, height: 800 });
    await page.setUserAgent(
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
    );

    // 📡 Network Response Interceptor
    page.on('response', async (response) => {
      const url = response.url();
      if (url.includes('graphql') || url.includes('search') || url.includes('items') || url.includes('v3')) {
        try {
          const contentType = response.headers()['content-type'] || '';
          if (contentType.includes('application/json')) {
            const json = await response.json();
            
            const items = json?.data?.search?.products || 
                          json?.data?.items || 
                          json?.items || 
                          json?.products || [];

            if (items.length > 0 && !interceptedProduct) {
              const first = items[0];
              const title = (first.name || first.title || '').replace(/\s+/g, ' ').trim();

              if (title && !['departments', 'categories', 'cart'].includes(title.toLowerCase())) {
                const category = extractCategoryFromItem(first);

                interceptedProduct = {
                  title: title,
                  id: first.id || first.itemId || first.product_id || first.productId,
                  slug: first.slug || '',
                  category: category
                };
                console.log(`🎯 [Puppeteer Interceptor] Captured product: "${interceptedProduct.title}" | ID: "${interceptedProduct.id}" | Category: "${category}"`);
              }
            }
          }
        } catch (e) {}
      }
    });

    // Set ZIP cookies upfront
    await page.setCookie(
      { name: 'warehouse_zip', value: cleanZip, domain: '.costco.com', path: '/' },
      { name: 'instacart_async_service_address', value: JSON.stringify({ postal_code: cleanZip }), domain: '.costco.com', path: '/' },
      { name: 'viewed_guest_landing', value: 'true', domain: '.costco.com', path: '/' }
    );

    // Step 1: Open Landing Page & Guest Gate
    console.log(`🌐 [Puppeteer Step 1] Opening Landing Page: ${landingUrl}`);
    try {
      await page.goto(landingUrl, { waitUntil: 'domcontentloaded', timeout: 12000 });
    } catch (e) {}

    try {
      const guestButton = await page.$('button::-p-text("Browse as a guest")');
      if (guestButton) {
        console.log(`👆 [Puppeteer Step 1] Clicking "Browse as a guest"...`);
        await guestButton.click();
        await new Promise(resolve => setTimeout(resolve, 2000));
      }
    } catch (btnErr) {}

    // Step 2: Search URL
    console.log(`🌐 [Puppeteer Step 2] Navigating to Search URL: ${searchUrl}`);
    try {
      await page.goto(searchUrl, { waitUntil: 'domcontentloaded', timeout: 15000 });
    } catch (e) {}

    await new Promise(resolve => setTimeout(resolve, 3000));

    // Step 3: Extract Product Details
    let productTitle = interceptedProduct?.title;
    let productId = interceptedProduct?.id;
    let productSlug = interceptedProduct?.slug;
    let productCategory = interceptedProduct?.category;

    if (!productTitle) {
      const fallbackData = await page.evaluate(() => {
        function sanitizeProductName(rawText) {
          if (!rawText) return '';
          return rawText.replace(/\s+/g, ' ').trim();
        }

        // Check DOM breadcrumbs if present on search page
        const breadcrumbEls = Array.from(document.querySelectorAll('[data-testid*="breadcrumb"] a, nav[aria-label*="breadcrumb"] a, a[href*="/categories/"]'));
        let domCategory = '';
        if (breadcrumbEls.length > 0) {
          domCategory = breadcrumbEls
            .map(el => el.textContent.trim())
            .filter(text => text && !['home', 'costco', 'departments'].includes(text.toLowerCase()))
            .join(' > ');
        }

        // 1. Check __NEXT_DATA__ JSON script tag
        const script = document.getElementById('__NEXT_DATA__');
        if (script && script.textContent) {
          try {
            const parsed = JSON.parse(script.textContent);
            const pageProps = parsed?.props?.pageProps;
            const initialData = pageProps?.initialData;
            const searchContainer = initialData?.search || pageProps?.fallbackData || initialData;
            const items = searchContainer?.products || searchContainer?.items || searchContainer?.modules?.[0]?.data?.products || [];

            if (items.length > 0) {
              const first = items[0];
              const title = sanitizeProductName(first.name || first.title);

              if (title && !['departments', 'categories', 'cart'].includes(title.toLowerCase())) {
                let catStr = '';

                if (Array.isArray(first.breadcrumbs) && first.breadcrumbs.length > 0) {
                  catStr = first.breadcrumbs
                    .map(b => typeof b === 'string' ? b : (b.name || b.label))
                    .filter(Boolean)
                    .filter(c => !['home', 'costco', 'departments'].includes(c.toLowerCase()))
                    .join(' > ');
                }

                if (!catStr) {
                  const dept = first.department?.name || first.department_name || first.department || '';
                  const aisle = first.aisle?.name || first.aisle_name || first.aisle || '';
                  const catName = first.category?.name || first.category_name || first.category || '';
                  catStr = [dept, aisle, catName].filter(Boolean).join(' > ');
                }

                return {
                  title: title,
                  id: first.id || first.itemId || first.product_id || first.productId,
                  slug: first.slug || '',
                  category: catStr || domCategory
                };
              }
            }
          } catch (e) {}
        }

        // 2. DOM Scrape Fallback
        const titleEl = document.querySelector('[data-testid="item_card_name"]') ||
                        document.querySelector('h3[class*="ItemCardName"]') ||
                        document.querySelector('a[href*="/products/"] h3') ||
                        document.querySelector('a[href*="/products/"] [class*="title"]');

        if (titleEl) {
          const rawTitle = titleEl.textContent ? titleEl.textContent.trim() : '';
          const cleanTitle = sanitizeProductName(rawTitle);

          if (cleanTitle.length > 3) {
            const parentLink = titleEl.closest('a[href*="/products/"]');
            const href = parentLink ? parentLink.getAttribute('href') : '';
            const match = href.match(/\/products\/(\d+)(?:-(.+))?/);

            return {
              title: cleanTitle,
              id: match ? match[1] : '',
              slug: match ? match[2] : '',
              href: href,
              category: domCategory
            };
          }
        }

        return null;
      });

      if (fallbackData) {
        productTitle = fallbackData.title;
        productId = fallbackData.id;
        productSlug = fallbackData.slug;
        productCategory = fallbackData.category;
      }
    }

    if (productTitle) {
      const fullPath = productSlug ? `${productId}-${productSlug}` : String(productId || '');
      const productUrl = productId ? `https://sameday.costco.com/store/costco/products/${fullPath}` : searchUrl;

// STEP 4: Click product card on search page to load real PDP & extract Apollo category
      if (!productCategory && productId) {
        console.log(`🌐 [Puppeteer Step 4] Clicking product card to open PDP for real category...`);
        try {
          const productClicked = await page.evaluate((pid) => {
            const card = document.querySelector(`a[href*="${pid}"]`) || 
                         document.querySelector('[data-testid="item_card_name"]') ||
                         document.querySelector('a[href*="/products/"]');
            if (card) {
              card.click();
              return true;
            }
            return false;
          }, productId);

          if (productClicked) {
            await new Promise(resolve => setTimeout(resolve, 3500));

            const apolloDebug = await page.evaluate(() => {
              try {
                if (!window.__APOLLO_CLIENT__) return { keys: [], productNode: null };
                const cache = window.__APOLLO_CLIENT__.cache.extract();
                const allKeys = Object.keys(cache);
                
                // Find any cache keys related to the product or categories
                const relevantKeys = allKeys.filter(k => 
                  k.includes('Product') || k.includes('Item') || k.includes('Department') || k.includes('Category') || k.includes('Taxonomy') || k.includes('Breadcrumb')
                );

                // Find the specific Product node
                const prodKey = allKeys.find(k => k.includes('Product:') || k.includes('Item:'));
                const prodNode = prodKey ? cache[prodKey] : null;

                return {
                  sampleKeys: relevantKeys.slice(0, 15),
                  productFields: prodNode ? Object.keys(prodNode) : [],
                  productData: prodNode
                };
              } catch (e) {
                return { error: e.message };
              }
            });

            console.log("🔬 [APOLLO CACHE KEYS]:", JSON.stringify(apolloDebug.sampleKeys));
            console.log("🔬 [PRODUCT NODE FIELDS]:", JSON.stringify(apolloDebug.productFields));
            if (apolloDebug.productData) {
              console.log("🔬 [PRODUCT NODE DATA]:", JSON.stringify(apolloDebug.productData).substring(0, 500));
            }

          } else {
            console.log(`⚠️ [Puppeteer PDP] Could not find product card element to click on search page.`);
          }

        } catch (pdpErr) {
          console.error("⚠️ PDP navigation error:", pdpErr);
        }
      }

// HTML Session Page Fallback
async function fetchSamedayPageFallback(itemNumber, warehouseId, zipCode) {
  try {
    const searchUrl = `https://sameday.costco.com/store/costco/s?k=${encodeURIComponent(itemNumber)}`;
    console.log(`📡 [Sameday Page] Fetching HTML fallback: ${searchUrl}`);

    const response = await fetch(searchUrl, {
      method: "GET",
      headers: {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36",
        "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
        "Cookie": `warehouse_zip=${zipCode}; instacart_async_service_address=%7B%22postal_code%22%3A%22${zipCode}%22%7D`
      },
      redirect: "follow"
    });

    if (!response.ok) return null;

    const html = await response.text();
    const nextDataMatch = html.match(/<script id="__NEXT_DATA__" type="application\/json">(.*?)<\/script>/s);

    if (nextDataMatch && nextDataMatch[1]) {
      const parsed = JSON.parse(nextDataMatch[1]);
      const container = parsed?.props?.pageProps?.initialData?.search || parsed?.props?.pageProps?.fallbackData;
      const items = container?.products || container?.items || [];

      if (items.length > 0) {
        const first = items[0];
        const productId = first.id || first.itemId || first.product_id || first.productId;
        const title = first.name || first.title;
        const slug = first.slug || "";
        const fullPath = slug ? `${productId}-${slug}` : String(productId);

        return {
          id: '',
          item_number: itemNumber,
          product_id: productId || '',
          product_name: title,
          category: 'In-Store Item',
          product_url: `https://sameday.costco.com/store/costco/products/${fullPath}`,
          warehouse_id: warehouseId,
          aisle: '',
          bay: '',
          is_wrong: 0,
          is_discontinued: 0
        };
      }
    }
  } catch (e) {
    console.error("💥 [Sameday Page] Fallback error:", e);
  }
  return null;
}