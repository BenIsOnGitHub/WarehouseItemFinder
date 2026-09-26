import csv
import os

csv_filename = "warehouse_products_master_merged.csv"
sql_filename = "seed_products.sql"

print(f"[*] Checking directory: {os.getcwd()}")

if not os.path.exists(csv_filename):
    print(f"[!] ERROR: '{csv_filename}' does not exist in this folder!")
    print("    Existing files here:", os.listdir("."))
    exit(1)

print(f"[+] Found '{csv_filename}'. Opening...")

with open(csv_filename, mode="r", encoding="utf-8") as f_in:
    reader = csv.reader(f_in)
    try:
        headers = next(reader)
        print(f"[+] Detected CSV Headers: {headers}")
    except StopIteration:
        print("[!] ERROR: CSV file is completely empty!")
        exit(1)

    # Convert headers to lowercase for flexible matching
    headers_lower = [h.lower().strip() for h in headers]

    # Map column indices automatically
    sku_idx = next((i for i, h in enumerate(headers_lower) if "sku" in h), 0)
    name_idx = next((i for i, h in enumerate(headers_lower) if "name" in h or "title" in h), 1)
    wh_idx = next((i for i, h in enumerate(headers_lower) if "warehouse" in h or "wh" in h), 2)
    url_idx = next((i for i, h in enumerate(headers_lower) if "url" in h), 3)

    row_count = 0
    with open(sql_filename, mode="w", encoding="utf-8") as f_out:
        # Write Schema Header
        f_out.write("""CREATE TABLE IF NOT EXISTS products (
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

CREATE INDEX IF NOT EXISTS idx_products_sku ON products(sku);
CREATE INDEX IF NOT EXISTS idx_products_flagged ON products(warehouse_id, is_wrong);

""")

        for row in reader:
            if not row or len(row) < 2:
                continue

            sku = row[sku_idx].replace("'", "''").strip() if len(row) > sku_idx else ""
            title = row[name_idx].replace("'", "''").strip() if len(row) > name_idx else ""
            wh_id = row[wh_idx].replace("'", "''").strip() if len(row) > wh_idx else "1738"
            url = row[url_idx].replace("'", "''").strip() if len(row) > url_idx else ""

            if not sku or not title:
                continue

            sql = f"""INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('{sku}', '{wh_id}', '{title}', '{url}')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');\n"""
            f_out.write(sql)
            row_count += 1

print(f"\n[+] SUCCESS: Written {row_count} INSERT queries to '{sql_filename}'")