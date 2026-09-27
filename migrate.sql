-- 1. Reset destination table
DELETE FROM products_new;

-- 2. Copy and transform data into products_new
INSERT OR REPLACE INTO products_new (id, warehouse_id, sku, item_number, product_name, product_url, aisle, bay, is_wrong, updated_at)
SELECT 
  warehouse_id || '_' || CASE 
    WHEN LENGTH(TRIM(sku)) >= 5 AND LENGTH(TRIM(sku)) <= 7 AND TRIM(sku) GLOB '[0-9]*' THEN 'item_' || TRIM(sku)
    WHEN TRIM(sku) != '' THEN 'sku_' || TRIM(sku)
    ELSE 'row_' || rowid
  END AS id,
  warehouse_id,
  CASE 
    WHEN LENGTH(TRIM(sku)) >= 5 AND LENGTH(TRIM(sku)) <= 7 AND TRIM(sku) GLOB '[0-9]*' THEN '' 
    ELSE TRIM(sku) 
  END AS sku,
  CASE 
    WHEN LENGTH(TRIM(sku)) >= 5 AND LENGTH(TRIM(sku)) <= 7 AND TRIM(sku) GLOB '[0-9]*' THEN TRIM(sku) 
    ELSE '' 
  END AS item_number,
  TRIM(product_name),
  product_url,
  aisle,
  bay,
  is_wrong,
  updated_at
FROM products;

-- 3. Consolidate missing values across matching product names per warehouse
UPDATE products_new
SET 
  aisle = COALESCE(NULLIF(aisle, ''), (
    SELECT p2.aisle FROM products_new p2 
    WHERE LOWER(p2.product_name) = LOWER(products_new.product_name) 
      AND p2.warehouse_id = products_new.warehouse_id 
      AND p2.aisle != '' LIMIT 1
  )),
  bay = COALESCE(NULLIF(bay, ''), (
    SELECT p2.bay FROM products_new p2 
    WHERE LOWER(p2.product_name) = LOWER(products_new.product_name) 
      AND p2.warehouse_id = products_new.warehouse_id 
      AND p2.bay != '' LIMIT 1
  )),
  item_number = COALESCE(NULLIF(item_number, ''), (
    SELECT p2.item_number FROM products_new p2 
    WHERE LOWER(p2.product_name) = LOWER(products_new.product_name) 
      AND p2.warehouse_id = products_new.warehouse_id 
      AND p2.item_number != '' LIMIT 1
  )),
  sku = COALESCE(NULLIF(sku, ''), (
    SELECT p2.sku FROM products_new p2 
    WHERE LOWER(p2.product_name) = LOWER(products_new.product_name) 
      AND p2.warehouse_id = products_new.warehouse_id 
      AND p2.sku != '' LIMIT 1
  ));

-- 4. Delete duplicates, keeping 1 record per product name
DELETE FROM products_new
WHERE rowid NOT IN (
  SELECT MIN(rowid)
  FROM products_new
  GROUP BY warehouse_id, LOWER(product_name)
);

-- 5. Swap old and new tables
DROP TABLE products;
ALTER TABLE products_new RENAME TO products;