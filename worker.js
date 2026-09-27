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
        const query = url.searchParams.get('q') || '';
        const warehouseId = url.searchParams.get('warehouse') || url.searchParams.get('warehouse_id') || '1738';
        const showDiscontinued = url.searchParams.get('show_discontinued') === 'true';

        const discontinuedClause = showDiscontinued ? '' : 'AND (is_discontinued = 0 OR is_discontinued IS NULL)';

        const { results } = await env.DB.prepare(`
          SELECT id, warehouse_id, sku, item_number, product_name, product_url, aisle, bay, is_wrong, is_discontinued
          FROM products
          WHERE warehouse_id = ?
            ${discontinuedClause}
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

      // 2. Paginated Browse API
      if (pathname === '/api/browse') {
  const warehouseId = url.searchParams.get('warehouse') || url.searchParams.get('warehouse_id') || '1738';
  const page = Math.max(1, parseInt(url.searchParams.get('page') || '1', 10) || 1);
  const limit = Math.max(1, parseInt(url.searchParams.get('limit') || '20', 10) || 20);
  const sort = url.searchParams.get('sort') || 'name';
  const showDiscontinued = url.searchParams.get('show_discontinued') === 'true';
  const offset = (page - 1) * limit;

  try {
    // 1. Build WHERE conditions cleanly
    let whereClause = "WHERE warehouse_id = ?";
    const bindParams = [warehouseId];

    if (!showDiscontinued) {
      whereClause += " AND (is_discontinued IS NULL OR is_discontinued = 0)";
    }

    // 2. Count Query
    const countQuery = `SELECT COUNT(*) AS total FROM products ${whereClause}`;
    const countStmt = await env.DB.prepare(countQuery).bind(...bindParams).first();
    const total = countStmt ? Number(countStmt.total || countStmt['COUNT(*)'] || 0) : 0;

    // 3. Select Query
    let orderByClause = "ORDER BY product_name ASC";
    if (sort === 'aisle') {
      orderByClause = `
        ORDER BY 
          CASE WHEN aisle IS NULL OR aisle = '' THEN 1 ELSE 0 END ASC, 
          CAST(aisle AS INTEGER) ASC, 
          CAST(bay AS INTEGER) ASC, 
          product_name ASC
      `;
    }

    const selectQuery = `
      SELECT id, sku, item_number, product_name, warehouse_id, product_url, aisle, bay, is_wrong, is_discontinued
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

      // 3. Update Location API
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

      // 4. Warehouses API
      if (pathname === '/api/warehouses') {
        const { results } = await env.DB.prepare(`
          SELECT warehouse_id, warehouse_name FROM warehouses ORDER BY warehouse_id ASC
        `).all();

        return new Response(JSON.stringify(results || []), { headers: corsHeaders });
      }

      // 5. Flag Location Incorrect API
      if (pathname === '/api/flag-incorrect' && request.method === 'POST') {
        const { id } = await request.json();
        if (!id) return new Response(JSON.stringify({ error: 'Missing product ID' }), { status: 400, headers: corsHeaders });

        await env.DB.prepare(`
          UPDATE products SET is_wrong = 1, updated_at = datetime('now') WHERE id = ?
        `).bind(id).run();

        return new Response(JSON.stringify({ success: true }), { headers: corsHeaders });
      }

      // 6. Flag Product as Discontinued API
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