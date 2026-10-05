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
            SELECT id, sku, item_number, product_name, category, warehouse_id, product_url, aisle, bay, is_wrong, is_discontinued, updated_at
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
          SELECT warehouse_id, warehouse_name FROM warehouses ORDER BY warehouse_id ASC
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
    const query = url.searchParams.get('q')?.trim();
    const searchMode = url.searchParams.get('mode') || 'item_number';
    const rawWarehouse = url.searchParams.get('warehouse') || '';
    const warehouseId = rawWarehouse.replace(/-wh$/i, '').trim();

    if (!query || !warehouseId) {
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
      return new Response(JSON.stringify(results.results), { headers: corsHeaders });
    }

    // Live Fallback
    if (searchMode === 'item_number' && /^\d{5,7}$/.test(query)) {
      const fetchedProduct = await fetchCostcoItemDetails(query, warehouseId);

      if (fetchedProduct) {
        const newId = (typeof crypto !== 'undefined' && crypto.randomUUID) 
          ? crypto.randomUUID() 
          : `${Date.now()}-${Math.random().toString(36).substring(2, 9)}`;

        const now = new Date().toISOString();

        try {
          await env.DB.prepare(`
            INSERT INTO products (id, item_number, product_name, category, product_url, warehouse_id, updated_at)
            VALUES (?, ?, ?, ?, ?, ?, ?)
          `).bind(
            newId,
            query,
            fetchedProduct.product_name || '',
            fetchedProduct.category || '',
            fetchedProduct.product_url || '',
            warehouseId,
            now
          ).run();
        } catch (dbErr) {
          console.error("D1 Insert failed with category column, running schema fallback insert:", dbErr);
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

  // 1. Clean the warehouse ID (ensures raw 3-4 digit string like "1738")
  const cleanWhsId = String(warehouseId).replace(/-wh$/i, '').trim();

  // 2. Build Costco's warehouse cookie payloads
  const whsCookieValue = JSON.stringify({
    nearestWarehouse: { catalog: `${cleanWhsId}-wh` }
  });

  const myWhsCookieValue = JSON.stringify({
    warehouseId: cleanWhsId,
    warehouseName: `Warehouse ${cleanWhsId}`
  });

  // 3. Format complete cookie string
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
        // Continue if state JSON parsing fails
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

    if (!extractedCategory) {
      const finalUrl = response.url || targetUrl;
      const urlPathMatches = finalUrl.match(/costco\.com\/([a-z0-9-]+)\.html/i);
      if (urlPathMatches && urlPathMatches[1] && !urlPathMatches[1].includes('product')) {
        extractedCategory = urlPathMatches[1]
          .replace(/-/g, ' ')
          .replace(/\b\w/g, l => l.toUpperCase());
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
        product_name: productTitle,
        category: extractedCategory || 'Uncategorized',
        product_url: response.url || targetUrl,
        warehouse_id: cleanWhsId,
        aisle: '',
        bay: ''
      };
    }

  } catch (err) {
    console.error('Error fetching live Costco item:', err);
  }

  return null;
}