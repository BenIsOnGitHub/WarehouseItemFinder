import csv
import os

csv_filename = "warehouse_products.csv"
sql_filename = "seed_products.sql"

print(f"[*] Checking directory: {os.getcwd()}")

if not os.path.exists(csv_filename):
    print(f"[!] ERROR: '{csv_filename}' does not exist in this folder!")
    print("    Existing files here:", os.listdir("."))
    exit(1)

print(f"[+] Found '{csv_filename}'. Opening...")

def clean_sql(val: str) -> str:
    """Escapes single quotes for SQL string literals."""
    if not val:
        return ""
    return val.replace("'", "''").strip()

with open(csv_filename, mode="r", encoding="utf-8") as f_in:
    reader = csv.reader(f_in)
    try:
        headers = next(reader)
        print(f"[+] Detected CSV Headers: {headers}")
    except StopIteration:
        print("[!] ERROR: CSV file is completely empty!")
        exit(1)

    headers_lower = [h.lower().strip() for h in headers]

    # Map column indices accurately from header row
    def get_idx(name_substring):
        return next((i for i, h in enumerate(headers_lower) if name_substring in h), -1)

    id_idx = get_idx("id") if "id" in headers_lower else 0
    wh_idx = get_idx("warehouse")
    prod_id_idx = get_idx("product_id")
    item_num_idx = get_idx("item_number")
    name_idx = next((i for i, h in enumerate(headers_lower) if "product_name" in h or "title" in h or "name" in h), -1)
    cat_idx = next((i for i, h in enumerate(headers_lower) if h == "category"), -1)
    cat_url_idx = get_idx("category_url")
    url_idx = get_idx("product_url")
    updated_idx = get_idx("updated")

    row_count = 0
    with open(sql_filename, mode="w", encoding="utf-8") as f_out:
        # D1 Table Schema
        f_out.write("""CREATE TABLE IF NOT EXISTS products (
    id TEXT PRIMARY KEY,
    warehouse_id TEXT NOT NULL,
    product_id TEXT,
    item_number TEXT,
    product_name TEXT NOT NULL,
    category TEXT,
    category_url TEXT,
    product_url TEXT,
    aisle TEXT,
    bay TEXT,
    is_wrong INTEGER NOT NULL DEFAULT 0,
    is_discontinued INTEGER NOT NULL DEFAULT 0,
    updated_at TEXT,
    FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_products_warehouse_search ON products(warehouse_id, item_number, product_id);
CREATE INDEX IF NOT EXISTS idx_products_warehouse_name ON products(warehouse_id, product_name COLLATE NOCASE);
CREATE INDEX IF NOT EXISTS idx_products_warehouse_category ON products(warehouse_id, category, product_name COLLATE NOCASE);
CREATE INDEX IF NOT EXISTS idx_products_warehouse_aisle ON products(warehouse_id, aisle, bay);
CREATE INDEX IF NOT EXISTS idx_products_flagged ON products(warehouse_id, is_wrong);

""")

        for row in reader:
            if not row or len(row) < 2:
                continue

            rec_id = clean_sql(row[id_idx]) if (id_idx != -1 and len(row) > id_idx) else ""
            wh_id = clean_sql(row[wh_idx]) if (wh_idx != -1 and len(row) > wh_idx) else "1738"
            prod_id = clean_sql(row[prod_id_idx]) if (prod_id_idx != -1 and len(row) > prod_id_idx) else ""
            item_num = clean_sql(row[item_num_idx]) if (item_num_idx != -1 and len(row) > item_num_idx) else ""
            title = clean_sql(row[name_idx]) if (name_idx != -1 and len(row) > name_idx) else ""
            category = clean_sql(row[cat_idx]) if (cat_idx != -1 and len(row) > cat_idx) else ""
            cat_url = clean_sql(row[cat_url_idx]) if (cat_url_idx != -1 and len(row) > cat_url_idx) else ""
            url = clean_sql(row[url_idx]) if (url_idx != -1 and len(row) > url_idx) else ""
            updated_at = clean_sql(row[updated_idx]) if (updated_idx != -1 and len(row) > updated_idx and row[updated_idx].strip()) else "2026-10-08 00:00:00"

            if not rec_id or not title:
                continue

            sql = f"""INSERT INTO products (id, warehouse_id, product_id, item_number, product_name, category, category_url, product_url, is_wrong, is_discontinued, updated_at) 
VALUES ('{rec_id}', '{wh_id}', '{prod_id}', '{item_num}', '{title}', '{category}', '{cat_url}', '{url}', 0, 0, '{updated_at}')
ON CONFLICT(id) DO UPDATE SET 
    warehouse_id = excluded.warehouse_id,
    product_id = excluded.product_id,
    item_number = excluded.item_number,
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    updated_at = excluded.updated_at;\n"""
            f_out.write(sql)
            row_count += 1

print(f"\n[+] SUCCESS: Written {row_count} INSERT queries to '{sql_filename}'")