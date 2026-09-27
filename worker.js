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
      // /api/search endpoint
			if (pathname === '/api/search') {
			  const query = url.searchParams.get('q') || '';
			  const warehouseId = url.searchParams.get('warehouse_id') || '1738';

			  const { results } = await env.DB.prepare(`
			    SELECT id, warehouse_id, sku, item_number, product_name, product_url, aisle, bay, is_wrong
			    FROM products
			    WHERE warehouse_id = ?
			      AND (
			        LOWER(product_name) LIKE LOWER(?)
			        OR sku LIKE ?
			        OR item_number LIKE ?
			      )
			    ORDER BY product_name ASC
			    LIMIT 50
			  `).bind(warehouseId, `%${query}%`, `%${query}%`, `%${query}%`).all();

			  return new Response(JSON.stringify(results || []), { headers: corsHeaders });
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
      // 1B. Update product location handler (/api/update-location)
			if (pathname === '/api/update-location' && request.method === 'POST') {
			  try {
			    const { id, aisle, bay, is_wrong } = await request.json();

			    if (!id) {
			      return new Response(JSON.stringify({ error: 'Missing product ID' }), { 
			        status: 400, 
			        headers: corsHeaders 
			      });
			    }

			    await env.DB.prepare(`
			      UPDATE products
			      SET aisle = ?, bay = ?, is_wrong = ?, updated_at = datetime('now')
			      WHERE id = ?
			    `).bind(aisle || '', bay || '', is_wrong ? 1 : 0, id).run();

			    return new Response(JSON.stringify({ success: true }), { headers: corsHeaders });
			  } catch (err) {
			    console.error('Error updating location:', err);
			    return new Response(JSON.stringify({ error: 'Failed to update location' }), { 
			      status: 500, 
			      headers: corsHeaders 
			    });
			  }
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