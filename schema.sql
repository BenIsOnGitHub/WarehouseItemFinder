PRAGMA foreign_keys = ON;

CREATE TABLE warehouses ( 
	warehouse_id TEXT PRIMARY KEY, 
	warehouse_name TEXT NOT NULL 
);

INSERT OR IGNORE INTO warehouses (warehouse_id, warehouse_name) VALUES 
	('1738', 'The Villages, FL #1738'),
	('1649', 'Clermont, FL #1649');

CREATE TABLE "products" ( 
	id TEXT PRIMARY KEY, 
	warehouse_id TEXT NOT NULL, 
	sku TEXT, 
	item_number TEXT, 
	product_name TEXT NOT NULL, 
	product_url TEXT, 
	aisle TEXT, 
	bay TEXT, 
	is_wrong INTEGER DEFAULT 0, 
	updated_at TEXT,
	category TEXT,
	is_discontinued INTEGER DEFAULT 0
	FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- need to do this
-- 6. Recreate indexes on the new products table
CREATE INDEX IF NOT EXISTS idx_products_flagged ON products(warehouse_id, is_wrong);
CREATE INDEX IF NOT EXISTS idx_products_warehouse_aisle ON products(warehouse_id, aisle, bay);
CREATE INDEX IF NOT EXISTS idx_products_warehouse_search ON products(warehouse_id, item_number, sku);
CREATE INDEX IF NOT EXISTS idx_products_warehouse_category ON products(warehouse_id, category);
CREATE INDEX IF NOT EXISTS idx_products_warehouse_name_nocase 
ON products(warehouse_id, product_name COLLATE NOCASE);


Compound Index for Category Filtering & Sorting:
When browsing by subcategory, users will often sort the results by name or aisle within that category (e.g., WHERE warehouse_id = ? AND category = ? ORDER BY product_name). If you notice subcategory page loading lagging on large datasets, you can extend idx_products_warehouse_category to cover sorting:

SQL
CREATE INDEX IF NOT EXISTS idx_products_warehouse_category_name 
ON products(warehouse_id, category, product_name COLLATE NOCASE);