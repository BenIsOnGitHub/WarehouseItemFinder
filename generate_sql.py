# Save as generate_sql.py and run after scrape_warehouses.py
import csv

with open('costco_warehouses.csv', 'r', encoding='utf-8') as f, open('import_warehouses.sql', 'w', encoding='utf-8') as sql_out:
    reader = csv.DictReader(f)
    for row in reader:
        wh_id = row['warehouse_id'].replace("'", "''")
        wh_name = row['warehouse_name'].replace("'", "''")
        street = row['street_address'].replace("'", "''")
        city = row['city'].replace("'", "''")
        state = row['state'].replace("'", "''")
        zip_code = row['zip_code'].replace("'", "''")

        sql = f"""INSERT INTO warehouses (warehouse_id, warehouse_name, street_address, city, state, zip_code)
VALUES ('{wh_id}', '{wh_name}', '{street}', '{city}', '{state}', '{zip_code}')
ON CONFLICT(warehouse_id) DO UPDATE SET
  warehouse_name = EXCLUDED.warehouse_name,
  street_address = EXCLUDED.street_address,
  city = EXCLUDED.city,
  state = EXCLUDED.state,
  zip_code = EXCLUDED.zip_code;\n"""
        sql_out.write(sql)

print("Generated import_warehouses.sql")