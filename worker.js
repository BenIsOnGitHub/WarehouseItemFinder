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
        return await handleSearch(request, env);
      }

      // 2. Paginated Browse API
      if (pathname === '/api/browse') {
        const warehouseId = url.searchParams.get('warehouse') || url.searchParams.get('warehouse_id') || '1738';
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
            SELECT id, sku, item_number, product_name, warehouse_id, product_url, aisle, bay, is_wrong, is_discontinued, updated_at
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

      // 3. Distinct Aisles API (PLACED INSIDE FETCH HANDLER)
      if (pathname === '/api/aisles') {
        const warehouseId = url.searchParams.get('warehouse') || '1738';
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

      return new Response(JSON.stringify({ error: 'Endpoint not found' }), { status: 404, headers: corsHeaders });

    } catch (err) {
      return new Response(JSON.stringify({ error: err.message || 'Internal Server Error' }), { status: 500, headers: corsHeaders });
    }
  }
};

async function handleSearch(request, env) {
  const url = new URL(request.url);
  const query = url.searchParams.get('q')?.trim();
  const rawWarehouse = url.searchParams.get('warehouse') || '';
  const warehouseId = rawWarehouse.replace(/-wh$/i, '').trim();

  if (!query) {
    return Response.json([]);
  }

  if (!warehouseId) {
    return Response.json({ error: 'Warehouse ID is required' }, { status: 400 });
  }

  // 1. Query local D1 database first
  // Note: Using LIKE for text search, or exact match for item_number
  let results = await env.DB.prepare(`
    SELECT * FROM products 
    WHERE (item_number = ? OR product_name LIKE ? OR product_id = ?) 
      AND warehouse_id = ?
  `).bind(query, `%${query}%`, query, warehouseId).all();

  if (results.results && results.results.length > 0) {
    return Response.json(results.results);
  }

  // 2. Fallback: If no local DB results and query is a 5-7 digit item number
  if (/^\d{5,7}$/.test(query)) {
    const fetchedProduct = await fetchCostcoItemDetails(query, warehouseId);
    
    if (fetchedProduct) {
      // 3. Save newly discovered product into D1 for future lookups
      await env.DB.prepare(`
        INSERT INTO products (id, item_number, product_name, product_url, warehouse_id, updated_at)
        VALUES (?, ?, ?, ?, ?, datetime('now'))
      `).bind(
        crypto.randomUUID(),
        query,
        fetchedProduct.product_name,
        fetchedProduct.product_url,
        warehouseId
      ).run();

      return Response.json([fetchedProduct]);
    }
  }

  return Response.json([]);
}

async function fetchCostcoItemDetails(itemNumber, warehouseId) {
  const targetUrl = `https://www.costco.com/.product.${itemNumber}.html`;

  const whsCookieValue = JSON.stringify({
    nearestWarehouse: { catalog: `${warehouseId}-wh` }
  });

  const cookieHeader = [
    `WHSE=${warehouseId}`,
    `WAREHOUSEDELIVERY_WHS=${encodeURIComponent(whsCookieValue)}`,
    `buyInWarehouse=true`
  ].join('; ');

  try {
    const response = await fetch(targetUrl, {
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36',
        'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
        'Cookie': cookieHeader
      }
    });

    if (!response.ok) return null;

    const html = await response.text();

    if (html.includes("We're sorry. We were not able to find a match.")) {
      return null;
    }

    const jsonLdMatch = html.match(/<script type="application\/ld\+json">([\s\S]*?)<\/script>/i);
    
    if (jsonLdMatch && jsonLdMatch[1]) {
      const metadata = JSON.parse(jsonLdMatch[1]);
      const productSchema = Array.isArray(metadata) 
        ? metadata.find(m => m['@type'] === 'Product') 
        : metadata;

      if (productSchema && productSchema.name) {
        return {
          id: crypto.randomUUID(),
          item_number: itemNumber,
          product_name: productSchema.name,
          category: productSchema.category || '',
          product_url: targetUrl,
          warehouse_id: warehouseId,
          aisle: '',
          bay: ''
        };
      }
    }

    const titleMatch = html.match(/<h1[^>]*>([\s\S]*?)<\/h1>/i);
    if (titleMatch) {
      return {
        id: crypto.randomUUID(),
        item_number: itemNumber,
        product_name: titleMatch[1].replace(/<[^>]+>/g, '').trim(),
        product_url: targetUrl,
        warehouse_id: warehouseId,
        aisle: '',
        bay: ''
      };
    }

  } catch (err) {
    console.error('Error fetching live Costco item:', err);
  }

  return null;
}

export default {
  async fetch(request, env, ctx) {
    const url = new URL(request.url);
    const path = url.pathname;

    // ... existing CORS headers setup ...

    // ----------------------------------------------------
    // SEARCH ROUTE
    // ----------------------------------------------------
    if (path === '/api/search') {
      return await handleSearch(request, env);
    }

    // ... your other routes (/api/update-location, etc.) ...

    return new Response('Not Found', { status: 404 });
  }
};

// ----------------------------------------------------
// HELPER FUNCTIONS (Place below export default)
// ----------------------------------------------------

async function handleSearch(request, env) {
  const url = new URL(request.url);
  const query = url.searchParams.get('q')?.trim();
  const searchMode = url.searchParams.get('mode') || 'item_number';
  const rawWarehouse = url.searchParams.get('warehouse') || '';
  const warehouseId = rawWarehouse.replace(/-wh$/i, '').trim();

  if (!query || !warehouseId) {
    return Response.json([]);
  }

  let dbQuery = "";
  let bindings = [];

  // 1. Build targeted D1 SQL query based on selected radio mode
  if (searchMode === 'item_number') {
    dbQuery = "SELECT * FROM products WHERE item_number = ? AND warehouse_id = ?";
    bindings = [query, warehouseId];
  } else if (searchMode === 'sku') {
    dbQuery = "SELECT * FROM products WHERE sku = ? AND warehouse_id = ?";
    bindings = [query, warehouseId];
  } else {
    // product_name mode
    dbQuery = "SELECT * FROM products WHERE product_name LIKE ? AND warehouse_id = ?";
    bindings = [`%${query}%`, warehouseId];
  }

  let results = await env.DB.prepare(dbQuery).bind(...bindings).all();

  if (results.results && results.results.length > 0) {
    return Response.json(results.results);
  }

  // 2. Live Fallback: ONLY attempt web lookup if mode is 'item_number' and query is 5-7 digits
  if (searchMode === 'item_number' && /^\d{5,7}$/.test(query)) {
    const fetchedProduct = await fetchCostcoItemDetails(query, warehouseId);
    
    if (fetchedProduct) {
      const newId = crypto.randomUUID();
      await env.DB.prepare(`
        INSERT INTO products (id, item_number, product_name, product_url, warehouse_id, updated_at)
        VALUES (?, ?, ?, ?, ?, datetime('now'))
      `).bind(
        newId,
        query,
        fetchedProduct.product_name,
        fetchedProduct.product_url,
        warehouseId
      ).run();

      fetchedProduct.id = newId;
      return Response.json([fetchedProduct]);
    }
  }

  return Response.json([]);
}

async function fetchCostcoItemDetails(itemNumber, warehouseId) {
  const targetUrl = `https://www.costco.com/.product.${itemNumber}.html`;

  const whsCookieValue = JSON.stringify({
    nearestWarehouse: { catalog: `${warehouseId}-wh` }
  });

  const cookieHeader = [
    `WHSE=${warehouseId}`,
    `WAREHOUSEDELIVERY_WHS=${encodeURIComponent(whsCookieValue)}`,
    `buyInWarehouse=true`
  ].join('; ');

  try {
    const response = await fetch(targetUrl, {
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36',
        'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
        'Cookie': cookieHeader
      }
    });

    if (!response.ok) return null;

    const html = await response.text();

    if (html.includes("We're sorry. We were not able to find a match.")) {
      return null;
    }

    const jsonLdMatch = html.match(/<script type="application\/ld\+json">([\s\S]*?)<\/script>/i);
    
    if (jsonLdMatch && jsonLdMatch[1]) {
      const metadata = JSON.parse(jsonLdMatch[1]);
      const productSchema = Array.isArray(metadata) 
        ? metadata.find(m => m['@type'] === 'Product') 
        : metadata;

      if (productSchema && productSchema.name) {
        return {
          id: crypto.randomUUID(),
          item_number: itemNumber,
          product_name: productSchema.name,
          category: productSchema.category || '',
          product_url: targetUrl,
          warehouse_id: warehouseId,
          aisle: '',
          bay: ''
        };
      }
    }

    const titleMatch = html.match(/<h1[^>]*>([\s\S]*?)<\/h1>/i);
    if (titleMatch) {
      return {
        id: crypto.randomUUID(),
        item_number: itemNumber,
        product_name: titleMatch[1].replace(/<[^>]+>/g, '').trim(),
        product_url: targetUrl,
        warehouse_id: warehouseId,
        aisle: '',
        bay: ''
      };
    }

  } catch (err) {
    console.error('Error fetching live Costco item:', err);
  }

  return null;
}