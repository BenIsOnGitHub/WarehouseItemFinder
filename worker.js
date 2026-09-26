export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    const pathname = url.pathname;

    // CORS headers for local testing & PWA integration
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
      // 1. Live Search API: /api/search?q=bourbon&warehouse=1738
      if (pathname === '/api/search') {
        const query = url.searchParams.get('q') || '';
        const warehouseId = url.searchParams.get('warehouse') || '1738';

        if (!query.trim()) {
          return new Response(JSON.stringify([]), { headers: corsHeaders });
        }

        const cleanQuery = `%${query.trim()}%`;
        const { results } = await env.DB.prepare(`
          SELECT sku, warehouse_id, product_name, product_url, aisle, bay, is_wrong, is_discontinued 
          FROM products 
          WHERE warehouse_id = ? AND (product_name LIKE ? OR sku LIKE ?)
          ORDER BY product_name ASC
          LIMIT 100
        `).bind(warehouseId, cleanQuery, cleanQuery).all();

        return new Response(JSON.stringify(results), { headers: corsHeaders });
      }

      // 2. Paginated Browse API: /api/browse?warehouse=1738&page=1&limit=20&sort=aisle
      if (pathname === '/api/browse') {
        const warehouseId = url.searchParams.get('warehouse') || '1738';
        const page = parseInt(url.searchParams.get('page') || '1', 10);
        const limit = parseInt(url.searchParams.get('limit') || '20', 10);
        const sort = url.searchParams.get('sort') || 'name'; // Accepts 'name' or 'aisle'
        const offset = (page - 1) * limit;

        // Total count for pagination calculation
        const countStmt = await env.DB.prepare(`
          SELECT COUNT(*) as total FROM products WHERE warehouse_id = ?
        `).bind(warehouseId).first();
        const total = countStmt.total;

        let query = '';
        if (sort === 'aisle') {
          query = `
            SELECT sku, warehouse_id, product_name, product_url, aisle, bay, is_wrong, is_discontinued 
            FROM products 
            WHERE warehouse_id = ?
            ORDER BY 
              CASE WHEN aisle IS NULL OR aisle = '' THEN 1 ELSE 0 END ASC, 
              CAST(aisle AS INTEGER) ASC, 
              CAST(bay AS INTEGER) ASC, 
              product_name ASC
            LIMIT ? OFFSET ?
          `;
        } else {
          query = `
            SELECT sku, warehouse_id, product_name, product_url, aisle, bay, is_wrong, is_discontinued 
            FROM products 
            WHERE warehouse_id = ?
            ORDER BY product_name ASC
            LIMIT ? OFFSET ?
          `;
        }

        const { results } = await env.DB.prepare(query)
          .bind(warehouseId, limit, offset)
          .all();

        return new Response(JSON.stringify({
          total,
          page,
          totalPages: Math.ceil(total / limit),
          products: results
        }), { headers: corsHeaders });
      }

      // 3. Update Product Location API: /api/update-location
      if (pathname === '/api/update-location' && request.method === 'POST') {
        const { sku, warehouse_id, aisle, bay, is_wrong } = await request.json();

        if (!sku || !warehouse_id) {
          return new Response(JSON.stringify({ error: 'Missing required fields' }), {
            status: 400,
            headers: corsHeaders,
          });
        }

        // Ensure is_wrong defaults to 0 if undefined/null
        const flagValue = is_wrong !== undefined && is_wrong !== null ? Number(is_wrong) : 0;

        await env.DB.prepare(`
          UPDATE products 
          SET aisle = ?, 
              bay = ?, 
              is_wrong = ?, 
              updated_at = datetime('now')
          WHERE sku = ? AND warehouse_id = ?
        `).bind(aisle ?? '', bay ?? '', flagValue, sku, warehouse_id).run();

        return new Response(JSON.stringify({ success: true }), { headers: corsHeaders });
      }

			// 4. Fetch available warehouses list
			if (pathname === '/api/warehouses') {
			  try {
			    const { results } = await env.DB.prepare(`
			      SELECT warehouse_id, warehouse_name 
			      FROM warehouses 
			      ORDER BY warehouse_id ASC
			    `).all();

			    return new Response(JSON.stringify(results || []), {
			      status: 200,
			      headers: corsHeaders
			    });
			  } catch (dbErr) {
			    console.error('Error fetching warehouses:', dbErr);
			    return new Response(JSON.stringify([
			      { warehouse_id: '1738', warehouse_name: 'The Villages, FL #1738' }
			    ]), { status: 200, headers: corsHeaders });
			  }
			}

      // 5. Flag product location as incorrect: /api/flag-incorrect
      if (pathname === '/api/flag-incorrect' && request.method === 'POST') {
        const body = await request.json();
        const { sku, warehouse_id } = body;

        await env.DB.prepare(`
          UPDATE products 
          SET is_wrong = 1, updated_at = datetime('now')
          WHERE sku = ? AND warehouse_id = ?
        `).bind(sku, warehouse_id).run();

        return new Response(JSON.stringify({ success: true }), { headers: corsHeaders });
      }

      return new Response(JSON.stringify({ error: 'Endpoint not found' }), { status: 404, headers: corsHeaders });

    } catch (err) {
      return new Response(JSON.stringify({ error: err.message }), { status: 500, headers: corsHeaders });
    }
  }
};