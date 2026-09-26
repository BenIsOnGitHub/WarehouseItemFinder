-- 1. Create dedicated warehouses table
CREATE TABLE IF NOT EXISTS warehouses (
  warehouse_id TEXT PRIMARY KEY,
  warehouse_name TEXT NOT NULL
);

-- 2. Populate initial warehouses
INSERT OR IGNORE INTO warehouses (warehouse_id, warehouse_name) VALUES 
('1738', 'The Villages, FL #1738'),
('1649', 'Clermont, FL #1649');


-- 3. Populate any other unique warehouse IDs currently inside products table
INSERT OR IGNORE INTO warehouses (warehouse_id, warehouse_name)
SELECT DISTINCT warehouse_id, 'Warehouse #' || warehouse_id 
FROM products 
WHERE warehouse_id IS NOT NULL AND warehouse_id != '';