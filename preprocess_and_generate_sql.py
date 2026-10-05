import csv

input_csv = "costco_warehouses.csv"
output_csv = "costco_warehouses_cleaned.csv"
output_sql = "import_warehouses.sql"

suffix_to_remove = " Warehouse | Costco"

processed_rows = []

with open(input_csv, 'r', encoding='utf-8') as infile:
    reader = csv.DictReader(infile)
    fieldnames = reader.fieldnames

    for row in reader:
        raw_name = row['warehouse_name']
        wh_id = row['warehouse_id']

        # 1. Strip " Warehouse | Costco" suffix
        if raw_name.endswith(suffix_to_remove):
            clean_name = raw_name[:-len(suffix_to_remove)]
        else:
            clean_name = raw_name.replace(suffix_to_remove, "").strip()

        # 2. Append " #" + warehouse_id
        row['warehouse_name'] = f"{clean_name} #{wh_id}"
        processed_rows.append(row)

# Save cleaned CSV
with open(output_csv, 'w', newline='', encoding='utf-8') as outfile:
    writer = csv.DictWriter(outfile, fieldnames=fieldnames)
    writer.writeheader()
    writer.writerows(processed_rows)

print(f"Updated CSV saved to {output_csv}")

# Generate SQL Upsert script
with open(output_sql, 'w', encoding='utf-8') as sql_out:
    for row in processed_rows:
        wh_id = row['warehouse_id'].replace("'", "''")
        wh_name = row['warehouse_name'].replace("'", "''")
        street = (row['street_address'] or '').replace("'", "''")
        city = (row['city'] or '').replace("'", "''")
        state = (row['state'] or '').replace("'", "''")
        zip_code = (row['zip_code'] or '').replace("'", "''")

        sql = f"""INSERT INTO warehouses (warehouse_id, warehouse_name, street_address, city, state, zip_code)
VALUES ('{wh_id}', '{wh_name}', '{street}', '{city}', '{state}', '{zip_code}')
ON CONFLICT(warehouse_id) DO UPDATE SET
  warehouse_name = EXCLUDED.warehouse_name,
  street_address = EXCLUDED.street_address,
  city = EXCLUDED.city,
  state = EXCLUDED.state,
  zip_code = EXCLUDED.zip_code;\n"""
        sql_out.write(sql)

print(f"Generated SQL import script at {output_sql}")