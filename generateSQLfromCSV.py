import csv
import os
import re

csv_filename = "warehouse_products_notUploaded.csv"
sql_filename = "seed_products.sql"

print(f"[*] Checking directory: {os.getcwd()}")

if not os.path.exists(csv_filename):
    print(f"[!] ERROR: '{csv_filename}' does not exist in this folder!")
    print("    Existing files here:", os.listdir("."))
    exit(1)

print(f"[+] Found '{csv_filename}'. Opening...")

def parse_category(url_str):
    """Extracts clean category name from URL slug (between final '/' and '.html')."""
    if not url_str:
        return ""
    
    # Extract filename slug before .html
    match = re.search(r'([^/]+)\.html(?:[?#].*)?$', url_str, re.IGNORECASE)
    if match:
        slug = match.group(1)
        # Format slug: replace hyphens/underscores with spaces and convert to Title Case
        clean_name = re.sub(r'[-_]+', ' ', slug).strip().title()
        return clean_name
    
    # Fallback if URL doesn't end in .html: grab string after last slash
    fallback_match = re.search(r'([^/]+)/?$', url_str)
    if fallback_match:
        return re.sub(r'[-_]+', ' ', fallback_match.group(1)).strip().title()
        
    return ""

with open(csv_filename, mode="r", encoding="utf-8") as f_in:
    reader = csv.reader(f_in)
    try:
        headers = next(reader)
        print(f"[+] Detected CSV Headers: {headers}")
    except StopIteration:
        print("[!] ERROR: CSV file is completely empty!")
        exit(1)

    headers_lower = [h.lower().strip() for h in headers]

    # Map column indices
    sku_idx = next((i for i, h in enumerate(headers_lower) if "sku" in h), 0)
    name_idx = next((i for i, h in enumerate(headers_lower) if "name" in h or "title" in h), 1)
    wh_idx = next((i for i, h in enumerate(headers_lower) if "warehouse" in h or "wh" in h), 2)
    url_idx = next((i for i, h in enumerate(headers_lower) if "product_url" in h or "url" in h), 3)
    cat_url_idx = next((i for i, h in enumerate(headers_lower) if "category" in h), -1)
    updated_idx = next((i for i, h in enumerate(headers_lower) if "updated" in h), -1)

    row_count = 0
    with open(sql_filename, mode="w", encoding="utf-8") as f_out:
        # Schema Header
        f_out.write("""CREATE TABLE IF NOT EXISTS products (
    id TEXT PRIMARY KEY,
    warehouse_id TEXT NOT NULL,
    item_number TEXT,
    sku TEXT NOT NULL,
    product_name TEXT NOT NULL,
    aisle TEXT,
    bay TEXT,
    is_wrong INTEGER NOT NULL DEFAULT 0,
    is_discontinued INTEGER NOT NULL DEFAULT 0,
    product_url TEXT,
    updated_at TEXT,
    category TEXT,
    FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_products_warehouse_search ON products(warehouse_id, item_number, sku);
CREATE INDEX IF NOT EXISTS idx_products_warehouse_name ON products(warehouse_id, product_name COLLATE NOCASE);
CREATE INDEX IF NOT EXISTS idx_products_warehouse_category ON products(warehouse_id, category, product_name COLLATE NOCASE);
CREATE INDEX IF NOT EXISTS idx_products_warehouse_aisle ON products(warehouse_id, aisle, bay);
CREATE INDEX IF NOT EXISTS idx_products_flagged ON products(warehouse_id, is_wrong);

""")

        for row in reader:
            if not row or len(row) < 2:
                continue

            sku = row[sku_idx].replace("'", "''").strip() if len(row) > sku_idx else ""
            title = row[name_idx].replace("'", "''").strip() if len(row) > name_idx else ""
            wh_id = row[wh_idx].replace("'", "''").strip() if len(row) > wh_idx else "1738"
            url = row[url_idx].replace("'", "''").strip() if len(row) > url_idx else ""
            
            raw_cat_url = row[cat_url_idx].strip() if (cat_url_idx != -1 and len(row) > cat_url_idx) else ""
            category_name = parse_category(raw_cat_url).replace("'", "''")

            updated_at = row[updated_idx].replace("'", "''").strip() if (updated_idx != -1 and len(row) > updated_idx and row[updated_idx].strip()) else "2026-09-27 00:00:00"

            if not sku or not title:
                continue

            sql = f"""INSERT INTO products (sku, warehouse_id, product_name, product_url, category, updated_at) 
VALUES ('{sku}', '{wh_id}', '{title}', '{url}', '{category_name}', '{updated_at}')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    category = excluded.category,
    updated_at = excluded.updated_at;\n"""
            f_out.write(sql)
            row_count += 1

print(f"\n[+] SUCCESS: Written {row_count} INSERT queries to '{sql_filename}'")