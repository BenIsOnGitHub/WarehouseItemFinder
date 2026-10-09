INSERT OR IGNORE INTO global_products (
  item_number, sku, product_id, product_name, category, category_url, product_url, is_discontinued, created_at, updated_at
)
SELECT 
  TRIM(item_number),
  COALESCE(sku, ''),
  COALESCE(product_id, ''),
  product_name,
  COALESCE(category, ''),
  COALESCE(category_url, ''),
  COALESCE(product_url, ''),
  COALESCE(is_discontinued, 0),
  CURRENT_TIMESTAMP,
  COALESCE(updated_at, CURRENT_TIMESTAMP)
FROM products 
WHERE item_number IS NOT NULL AND TRIM(item_number) != '';

INSERT OR IGNORE INTO product_locations (
  id, warehouse_id, item_number, aisle, bay, is_wrong, updated_at
)
SELECT 
  id,
  warehouse_id,
  TRIM(item_number),
  COALESCE(aisle, ''),
  COALESCE(bay, ''),
  COALESCE(is_wrong, 0),
  COALESCE(updated_at, CURRENT_TIMESTAMP)
FROM products 
WHERE item_number IS NOT NULL AND TRIM(item_number) != '';
"