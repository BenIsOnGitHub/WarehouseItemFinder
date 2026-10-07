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
    const query = url.searchParams.get('q')?.trim();
    const searchMode = url.searchParams.get('mode') || 'item_number';
    const rawWarehouse = url.searchParams.get('warehouse') || '';
    const warehouseId = rawWarehouse.replace(/-wh$/i, '').trim();

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

      // Step B: Fallback to Sameday/Instacart GraphQL lookup if Costco.com fails
      if (!fetchedProduct) {
        let zipCode = '32162'; // Default fallback
        try {
          const wh = await env.DB.prepare("SELECT zip_code FROM warehouses WHERE warehouse_id = ?").bind(warehouseId).first();
          if (wh && wh.zip_code) {
            zipCode = String(wh.zip_code).trim();
            console.log(`📍 D1 Warehouse ZIP Found: ${zipCode} for Warehouse #${warehouseId}`);
          } else {
            console.log(`⚠️ No ZIP in D1 for Warehouse #${warehouseId}, using fallback: ${zipCode}`);
          }
        } catch (e) {
          console.error("⚠️ Failed to query warehouse ZIP code from D1:", e);
        }

        console.log(`🛒 Step B: Querying Sameday GraphQL (ZIP: ${zipCode})...`);
        fetchedProduct = await fetchFromSamedayGraphQL(query, warehouseId, zipCode);
      }

      if (fetchedProduct) {
        console.log(`🎉 Live Fetch Success: Found "${fetchedProduct.product_name}". Inserting into D1...`);
        const newId = (typeof crypto !== 'undefined' && crypto.randomUUID) 
          ? crypto.randomUUID() 
          : `${Date.now()}-${Math.random().toString(36).substring(2, 9)}`;

        const now = new Date().toISOString();

        try {
          await env.DB.prepare(`
            INSERT INTO products (id, item_number, sku, product_name, category, product_url, warehouse_id, updated_at)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
          `).bind(
            newId,
            query,
            fetchedProduct.sku || query,
            fetchedProduct.product_name || '',
            fetchedProduct.category || '',
            fetchedProduct.product_url || '',
            warehouseId,
            now
          ).run();
          console.log(`💾 Saved to D1 with ID: ${newId}`);
        } catch (dbErr) {
          console.error("⚠️ D1 Insert failed with category/sku columns, running fallback insert:", dbErr);
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
          console.log(`💾 Saved to D1 via fallback insert.`);
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

// --- FALLBACK 2: Sameday / Instacart GraphQL Engine ---
async function fetchFromSamedayGraphQL(itemNumber, warehouseId, zipCode) {
  try {
    const payload = {
      operationName: "SearchItems",
      variables: {
        query: String(itemNumber).trim(),
        postalCode: String(zipCode).trim(),
        perPage: 5
      },
      query: `
        query SearchItems($query: String!, $postalCode: String, $perPage: Int) {
          search(query: $query, postalCode: $postalCode, perPage: $perPage) {
            products {
              id
              name
              slug
              sku
            }
          }
        }
      `
    };

    console.log(`📡 Sending GraphQL Request to Sameday...`);
    console.log(`Payload:`, JSON.stringify(payload));

    const response = await fetch("https://sameday.costco.com/graphql", {
      method: "POST",
      headers: {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36",
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Cookie": `warehouse_zip=${zipCode}; instacart_async_service_address=%7B%22postal_code%22%3A%22${zipCode}%22%7D`,
        "x-client-identifier": "web"
      },
      body: JSON.stringify(payload)
    });

    console.log(`HTTP Status: ${response.status} ${response.statusText}`);

    if (!response.ok) {
      const errText = await response.text();
      console.log(`❌ Sameday GraphQL HTTP Error Response:`, errText.substring(0, 300));
      return null;
    }

    const resJson = await response.json();
    console.log(`📦 Sameday GraphQL Raw Response:`, JSON.stringify(resJson));

    const products = resJson?.data?.search?.products || [];
    console.log(`Found ${products.length} product(s) in GraphQL response.`);

    if (products.length > 0) {
      const first = products[0];
      const productId = first.id;
      const slug = first.slug || "";
      const title = first.name;
      const fullPath = slug ? `${productId}-${slug}` : String(productId);

      return {
        id: '',
        item_number: itemNumber,
        sku: first.sku || itemNumber,
        product_name: title,
        category: 'Frozen Foods',
        product_url: `https://sameday.costco.com/store/costco/products/${fullPath}`,
        warehouse_id: warehouseId,
        aisle: '',
        bay: ''
      };
    }
  } catch (err) {
    console.error("💥 GraphQL Sameday Exception:", err);
  }
  return null;
}