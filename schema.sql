CREATE TABLE IF NOT EXISTS products (
    sku TEXT NOT NULL,
    warehouse_id TEXT NOT NULL,
    product_name TEXT NOT NULL,
    product_url TEXT,
    aisle TEXT,
    bay TEXT,
    is_wrong INTEGER NOT NULL DEFAULT 0,
    is_discontinued INTEGER NOT NULL DEFAULT 0,
    updated_at TEXT DEFAULT (datetime('now')),
    
    PRIMARY KEY (sku, warehouse_id)
);

-- Index for searching items across any warehouse by SKU alone
CREATE INDEX IF NOT EXISTS idx_products_sku ON products(sku);

-- Index for quickly filtering reported errors
CREATE INDEX IF NOT EXISTS idx_products_flagged ON products(warehouse_id, is_wrong);