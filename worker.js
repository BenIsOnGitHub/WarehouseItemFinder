import puppeteer from '@cloudflare/puppeteer';

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
        const selectedAisle = url.searchParams.get('aisle');
        const selectedCategory = url.searchParams.get('category');
        const offset = (page - 1) * limit;

        try {
          const whereConditions = [];
          const bindParams = [warehouseId];

          if (!showDiscontinued) {
            whereConditions.push("(gp.is_discontinued IS NULL OR gp.is_discontinued = 0)");
          }

          if (showIncorrect) {
            whereConditions.push("(loc.is_wrong = 1 OR loc.is_wrong = '1' OR loc.is_wrong IS TRUE)");
          }

          if (sort === 'aisle') {
            whereConditions.push("(loc.aisle IS NOT NULL AND TRIM(loc.aisle) != '')");
          }

          if (selectedAisle) {
            whereConditions.push("loc.aisle = ?");
            bindParams.push(selectedAisle);
          }

          if (selectedCategory) {
            whereConditions.push("gp.category = ?");
            bindParams.push(selectedCategory);
          }

          const whereClause = whereConditions.length > 0 ? "WHERE " + whereConditions.join(" AND ") : "";

          const countQuery = `
            SELECT COUNT(*) AS total 
            FROM global_products gp
            LEFT JOIN product_locations loc 
              ON gp.item_number = loc.item_number 
             AND loc.warehouse_id = ?
            ${whereClause}
          `;
          const countStmt = await env.DB.prepare(countQuery).bind(...bindParams).first();
          const total = countStmt ? Number(countStmt.total || countStmt['COUNT(*)'] || 0) : 0;

          // Clean ORDER BY expressions WITHOUT duplicate 'ORDER BY' keywords
          let orderByClause = 'gp.product_name ASC';
          if (sort === 'sku') {
            orderByClause = `
              CASE 
                WHEN gp.sku IS NULL OR TRIM(gp.sku) = '' THEN 1 
                ELSE 0 
              END ASC, 
              gp.sku ASC, 
              gp.product_name ASC
            `;
          } else if (sort === 'aisle') {
            orderByClause = `
              CAST(loc.aisle AS INTEGER) ASC, 
              CAST(loc.bay AS INTEGER) ASC, 
              gp.product_name ASC
            `;
          } else if (sort === 'category') {
            orderByClause = `
              CASE WHEN gp.category IS NULL OR TRIM(gp.category) = '' THEN 1 ELSE 0 END,
              gp.category ASC,
              gp.product_name ASC
            `;
          } else if (sort === 'item_number') {
            orderByClause = `
              CASE WHEN gp.item_number GLOB '[0-9]*' THEN CAST(gp.item_number AS INTEGER) ELSE 999999999 END ASC,
              gp.item_number ASC
            `;
          } else if (sort === 'updated_at' || sort === 'updated') {
            orderByClause = `loc.updated_at DESC`;
          }

          const selectQuery = `
            SELECT 
              COALESCE(loc.id, 'temp_' || gp.item_number) AS id,
              gp.item_number,
              gp.sku,
              gp.product_name,
              gp.category,
              gp.product_url,
              loc.warehouse_id,
              loc.aisle,
              loc.bay,
              loc.is_wrong,
              loc.updated_at
            FROM global_products gp
            LEFT JOIN product_locations loc 
              ON gp.item_number = loc.item_number 
             AND loc.warehouse_id = ?
            ${whereClause}
            ORDER BY ${orderByClause}
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
          FROM product_locations 
          WHERE warehouse_id = ? 
            AND aisle IS NOT NULL 
            AND TRIM(aisle) != ''
          ORDER BY CAST(aisle AS INTEGER) ASC, aisle ASC
        `).bind(warehouseId).all();

        const aisles = (results || []).map(r => r.aisle);
        return new Response(JSON.stringify(aisles), { headers: corsHeaders });
      }

      // 3b. Distinct Categories API
      if (pathname === '/api/categories') {
        const { results } = await env.DB.prepare(`
          SELECT DISTINCT category 
          FROM global_products 
          WHERE category IS NOT NULL 
            AND TRIM(category) != ''
          ORDER BY category ASC
        `).all();

        const categories = (results || []).map(r => r.category);
        return new Response(JSON.stringify(categories), { headers: corsHeaders });
      }

      // 4. Update Location API
      if (pathname === '/api/update-location' && request.method === 'POST') {
        const body = await request.json();
        const { id, warehouse_id, item_number, aisle, bay, is_wrong } = body;

        let targetItemNumber = item_number;
        let targetWarehouseId = warehouse_id;

        if (!targetItemNumber || !targetWarehouseId) {
          if (!id) {
            return new Response(JSON.stringify({ error: 'Missing product ID or item_number/warehouse_id' }), { status: 400, headers: corsHeaders });
          }

          if (id.startsWith('temp_')) {
            targetItemNumber = id.replace('temp_', '');
          } else {
            const locRecord = await env.DB.prepare('SELECT item_number, warehouse_id FROM product_locations WHERE id = ?').bind(id).first();
            if (locRecord) {
              targetItemNumber = locRecord.item_number;
              targetWarehouseId = locRecord.warehouse_id;
            }
          }
        }

        if (!targetItemNumber || !targetWarehouseId) {
          return new Response(JSON.stringify({ error: 'Could not resolve item_number and warehouse_id' }), { status: 400, headers: corsHeaders });
        }

        const now = new Date().toISOString();

        const existingLoc = await env.DB.prepare('SELECT id FROM product_locations WHERE warehouse_id = ? AND item_number = ?')
          .bind(targetWarehouseId, targetItemNumber).first();

        const targetId = existingLoc?.id || (id && !id.startsWith('temp_') ? id : ((typeof crypto !== 'undefined' && crypto.randomUUID) 
          ? crypto.randomUUID() 
          : `${Date.now()}-${Math.random().toString(36).substring(2, 9)}`));

        await env.DB.prepare(`
          INSERT INTO product_locations (id, warehouse_id, item_number, aisle, bay, is_wrong, updated_at)
          VALUES (?, ?, ?, ?, ?, ?, ?)
          ON CONFLICT(warehouse_id, item_number) DO UPDATE SET
            aisle = excluded.aisle,
            bay = excluded.bay,
            is_wrong = excluded.is_wrong,
            updated_at = excluded.updated_at
        `).bind(targetId, targetWarehouseId, targetItemNumber, aisle || '', bay || '', is_wrong ? 1 : 0, now).run();

        return new Response(JSON.stringify({ success: true, id: targetId }), { headers: corsHeaders });
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
          UPDATE product_locations SET is_wrong = 1, updated_at = datetime('now') WHERE id = ?
        `).bind(id).run();

        return new Response(JSON.stringify({ success: true }), { headers: corsHeaders });
      }

      // 7. Flag Product as Discontinued API
      if (pathname === '/api/flag-discontinued' && request.method === 'POST') {
        const { id, is_discontinued } = await request.json();
        if (!id) return new Response(JSON.stringify({ error: 'Missing product ID' }), { status: 400, headers: corsHeaders });

        await env.DB.prepare(`
          UPDATE global_products SET is_discontinued = ? WHERE item_number = (
            SELECT item_number FROM product_locations WHERE id = ?
          ) OR item_number = ?
        `).bind(is_discontinued ? 1 : 0, id, id.replace('temp_', '')).run();

        return new Response(JSON.stringify({ success: true }), { headers: corsHeaders });
      }

      // 8. Update Item Number / SKU Identifier API
      if (pathname === '/api/update-identifier' && request.method === 'POST') {
        const { id, item_number, sku } = await request.json();
        if (!id) {
          return new Response(JSON.stringify({ error: 'Missing product ID' }), { status: 400, headers: corsHeaders });
        }

        const targetItemNumber = id.startsWith('temp_') ? id.replace('temp_', '') : id;

        const existing = await env.DB.prepare('SELECT item_number, sku FROM global_products WHERE item_number = ?').bind(targetItemNumber).first();
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

        bindParams.push(targetItemNumber);

        const query = `UPDATE global_products SET ${updateFields.join(', ')} WHERE item_number = ?`;
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

    if (!query || !warehouseId) {
      return new Response(JSON.stringify([]), { headers: corsHeaders });
    }

    let dbQuery = "";
    let bindings = [];

    const baseSelect = `
      SELECT 
        COALESCE(loc.id, 'temp_' || gp.item_number) AS id,
        gp.item_number,
        gp.sku,
        gp.product_name,
        gp.category,
        gp.product_url,
        gp.is_discontinued,
        loc.warehouse_id,
        loc.aisle,
        loc.bay,
        loc.is_wrong,
        loc.updated_at
      FROM global_products gp
      LEFT JOIN product_locations loc 
        ON gp.item_number = loc.item_number 
       AND loc.warehouse_id = ?
    `;

    if (searchMode === 'item_number') {
      dbQuery = `${baseSelect} WHERE gp.item_number = ?`;
      bindings = [warehouseId, query];
    } else if (searchMode === 'sku') {
      dbQuery = `${baseSelect} WHERE gp.sku = ?`;
      bindings = [warehouseId, query];
    } else {
      dbQuery = `${baseSelect} WHERE gp.product_name LIKE ?`;
      bindings = [warehouseId, `%${query}%`];
    }

    const results = await env.DB.prepare(dbQuery).bind(...bindings).all();

    if (results && results.results && results.results.length > 0) {
      return new Response(JSON.stringify(results.results), { headers: corsHeaders });
    }

    // Live Fallback on D1 Miss
    if (searchMode === 'item_number' && /^\d{5,7}$/.test(query)) {
      let fetchedProduct = await fetchCostcoItemDetails(query, warehouseId);

      if (!fetchedProduct) {
        let zipCode = '01331';
        try {
          const wh = await env.DB.prepare("SELECT zip_code FROM warehouses WHERE warehouse_id = ?").bind(warehouseId).first();
          if (wh && wh.zip_code) {
            zipCode = String(wh.zip_code).trim().split('-')[0].substring(0, 5);
          }
        } catch (e) {}

        fetchedProduct = await fetchFromSamedayGraphQL(query, warehouseId, zipCode, env);
      }

      if (fetchedProduct) {
        // Upsert into global_products
        await env.DB.prepare(`
          INSERT INTO global_products (item_number, product_name, category, product_url, updated_at)
          VALUES (?, ?, ?, ?, datetime('now'))
          ON CONFLICT(item_number) DO UPDATE SET
            product_name = excluded.product_name,
            category = excluded.category,
            product_url = excluded.product_url
        `).bind(
          query,
          fetchedProduct.product_name || '',
          fetchedProduct.category || '',
          fetchedProduct.product_url || ''
        ).run();

        fetchedProduct.id = `temp_${query}`;
        return new Response(JSON.stringify([fetchedProduct]), { headers: corsHeaders });
      }
    }

    return new Response(JSON.stringify([]), { headers: corsHeaders });
  } catch (err) {
    return new Response(JSON.stringify({ error: err.message, stack: err.stack }), { 
      status: 500, 
      headers: corsHeaders 
    });
  }
}

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
      } catch (e) {}
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
        } catch (parseErr) {}
      }
    }

    if (!extractedCategory) {
      const metaCategory = html.match(/<meta[^>]*name=["'](category|keywords|search\.category)["'][^>]*content=["']([^"']+)["']/i);
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
        id: `temp_${itemNumber}`,
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

function extractCategoryFromItem(item) {
  if (!item || typeof item !== 'object') return '';

  const parts = [];

  if (Array.isArray(item.breadcrumbs) && item.breadcrumbs.length > 0) {
    const crumbs = item.breadcrumbs
      .map(b => typeof b === 'string' ? b : (b.name || b.label || b.text || b.title))
      .filter(Boolean)
      .filter(c => !['home', 'costco', 'departments', 'categories', 'all products'].includes(c.toLowerCase()));
    if (crumbs.length > 0) return crumbs.join(' > ');
  }

  const dept = item.departmentName || item.department_name || item.department?.name || (typeof item.department === 'string' ? item.department : '');
  const aisle = item.aisleName || item.aisle_name || item.aisle?.name || (typeof item.aisle === 'string' ? item.aisle : '');
  const cat = item.categoryName || item.category_name || item.category?.name || (typeof item.category === 'string' ? item.category : '');

  if (dept) parts.push(dept);
  if (aisle) parts.push(aisle);
  if (cat) parts.push(cat);

  const cleanParts = parts
    .map(p => typeof p === 'string' ? p.trim() : '')
    .filter(Boolean)
    .filter(c => !['home', 'costco', 'departments', 'categories'].includes(c.toLowerCase()))
    .filter((v, idx, arr) => arr.indexOf(v) === idx);

  if (cleanParts.length > 0) {
    return cleanParts.join(' > ');
  }

  const title = (item.name || item.title || '').toLowerCase();
  if (title.includes('mango') || title.includes('berry') || title.includes('strawberries') || title.includes('cherries') || title.includes('fruit')) {
    return 'Frozen Foods > Frozen Fruit';
  }
  if (title.includes('chicken') || title.includes('beef') || title.includes('pork') || title.includes('salmon')) {
    return 'Meat & Seafood';
  }
  if (title.includes('milk') || title.includes('yogurt') || title.includes('cheese') || title.includes('butter')) {
    return 'Dairy & Eggs';
  }
  if (title.includes('water') || title.includes('juice') || title.includes('soda') || title.includes('coffee')) {
    return 'Coffee & Beverages';
  }

  return '';
}

async function fetchFromSamedayGraphQL(itemNumber, warehouseId, zipCode, env) {
  const cleanZip = String(zipCode).split('-')[0].trim().substring(0, 5);
  const landingUrl = 'https://sameday.costco.com/';
  const searchUrl = `https://sameday.costco.com/store/costco/s?k=${encodeURIComponent(itemNumber)}`;

  let browser = null;
  let interceptedProduct = null;

  try {
    browser = await puppeteer.launch(env.MYBROWSER);
    const page = await browser.newPage();

    await page.setViewport({ width: 1280, height: 800 });
    await page.setUserAgent(
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
    );

    page.on('response', async (response) => {
      const url = response.url();
      if (url.includes('graphql') || url.includes('v3') || url.includes('items')) {
        try {
          const contentType = response.headers()['content-type'] || '';
          if (contentType.includes('application/json')) {
            const json = await response.json();
            
            const items = json?.data?.search?.products || 
                          json?.data?.items || 
                          json?.data?.itemDetails ||
                          json?.items || 
                          json?.products || [];

            const productData = Array.isArray(items) ? items[0] : (json?.data?.product || json?.data?.item || null);

            if (productData) {
              const title = (productData.name || productData.title || '').replace(/\s+/g, ' ').trim();

              if (title && !['departments', 'categories', 'cart'].includes(title.toLowerCase())) {
                const category = extractCategoryFromItem(productData);

                interceptedProduct = {
                  title: title,
                  id: productData.id || productData.itemId || productData.product_id || productData.productId,
                  slug: productData.slug || '',
                  category: category || interceptedProduct?.category || ''
                };
              }
            }
          }
        } catch (e) {}
      }
    });

    await page.setCookie(
      { name: 'warehouse_zip', value: cleanZip, domain: '.costco.com', path: '/' },
      { name: 'instacart_async_service_address', value: JSON.stringify({ postal_code: cleanZip }), domain: '.costco.com', path: '/' },
      { name: 'viewed_guest_landing', value: 'true', domain: '.costco.com', path: '/' }
    );

    try {
      await page.goto(landingUrl, { waitUntil: 'domcontentloaded', timeout: 12000 });
    } catch (e) {}

    try {
      const guestButton = await page.$('button::-p-text("Browse as a guest")');
      if (guestButton) {
        await guestButton.click();
        await new Promise(resolve => setTimeout(resolve, 2000));
      }
    } catch (btnErr) {}

    try {
      await page.goto(searchUrl, { waitUntil: 'domcontentloaded', timeout: 15000 });
    } catch (e) {}

    await new Promise(resolve => setTimeout(resolve, 3000));

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
                return {
                  title: title,
                  id: first.id || first.itemId || first.product_id || first.productId,
                  slug: first.slug || ''
                };
              }
            }
          } catch (e) {}
        }

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
              slug: match ? match[2] : ''
            };
          }
        }

        return null;
      });

      if (fallbackData) {
        productTitle = fallbackData.title;
        productId = fallbackData.id;
        productSlug = fallbackData.slug;
      }
    }

    if (productTitle) {
      const fullPath = productSlug ? `${productId}-${productSlug}` : String(productId || '');
      const productUrl = productId ? `https://sameday.costco.com/store/costco/products/${fullPath}` : searchUrl;

      if (!productCategory && productId) {
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
            if (interceptedProduct?.category) {
              productCategory = interceptedProduct.category;
            }
          }
        } catch (pdpErr) {}
      }

      const finalCategory = productCategory || 'Uncategorized';

      return {
        id: `temp_${itemNumber}`,
        item_number: itemNumber,
        product_id: productId || '',
        product_name: productTitle,
        category: finalCategory,
        product_url: productUrl,
        warehouse_id: warehouseId,
        aisle: '',
        bay: '',
        is_wrong: 0,
        is_discontinued: 0
      };
    }

  } catch (err) {
    console.error(`💥 [Puppeteer Exception]:`, err);
  } finally {
    if (browser) {
      await browser.close();
    }
  }

  return null;
}