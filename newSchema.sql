-- 1. Master Universal Catalog
CREATE TABLE IF NOT EXISTS global_products (
  item_number TEXT PRIMARY KEY,
  sku TEXT,
  product_id TEXT,
  product_name TEXT NOT NULL,
  category TEXT,
  category_url TEXT,
  product_url TEXT,
  is_discontinued INTEGER DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 2. Warehouse Product Location & State Overlay
CREATE TABLE IF NOT EXISTS product_locations (
  id TEXT PRIMARY KEY,
  warehouse_id TEXT NOT NULL,
  item_number TEXT NOT NULL,
  aisle TEXT,
  bay TEXT,
  is_wrong INTEGER DEFAULT 0,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (item_number) REFERENCES global_products(item_number),
  UNIQUE(warehouse_id, item_number)
);

-- ============================================================================
-- PERFORMANCE INDEXES
-- ============================================================================

-- 1. Fast Name Search & Discontinued Filtering on Global Catalog
-- Speeds up: WHERE product_name LIKE '%mango%' AND is_discontinued = 0
CREATE INDEX IF NOT EXISTS idx_global_name_disc 
  ON global_products(product_name, is_discontinued);

-- 2. Fast Category Filtering on Global Catalog
-- Speeds up browsing by Category
CREATE INDEX IF NOT EXISTS idx_global_category 
  ON global_products(category);

-- 3. Core Warehouse Lookup & Joining Index (Unique constraint already creates this, but explicitly listed)
-- Speeds up: LEFT JOIN product_locations ON warehouse_id AND item_number
CREATE INDEX IF NOT EXISTS idx_loc_warehouse_item 
  ON product_locations(warehouse_id, item_number);

-- 4. Fast Aisle & Bay Sorting/Browsing
-- Speeds up: WHERE warehouse_id = ? ORDER BY aisle, bay
CREATE INDEX IF NOT EXISTS idx_loc_warehouse_aisle 
  ON product_locations(warehouse_id, aisle, bay);

-- 5. Fast Date/Recency Browsing
-- Speeds up: ORDER BY updated_at DESC
CREATE INDEX IF NOT EXISTS idx_loc_warehouse_updated 
  ON product_locations(warehouse_id, updated_at DESC);

-- 6. Fast "Reported as Incorrect" Filtering
-- Speeds up: WHERE warehouse_id = ? AND is_wrong = 1
CREATE INDEX IF NOT EXISTS idx_loc_warehouse_wrong 
  ON product_locations(warehouse_id, is_wrong);