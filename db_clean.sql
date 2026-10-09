DELETE FROM products 
WHERE id NOT IN (
  SELECT id FROM (
    SELECT id, ROW_NUMBER() OVER (
      PARTITION BY warehouse_id, item_number 
      ORDER BY updated_at DESC
    ) AS row_num
    FROM products
    WHERE item_number IS NOT NULL AND TRIM(item_number) != ''
  ) WHERE row_num = 1
);"