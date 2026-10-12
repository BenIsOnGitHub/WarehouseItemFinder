import csv
import os

csv_filename = "warehouse_products.csv"
sql_filename = "seed_global_products.sql"

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

    def get_idx(name_substring):
        return next((i for i, h in enumerate(headers_lower) if name_substring in h), -1)

    item_num_idx = get_idx("item_number")
    name_idx = next((i for i, h in enumerate(headers_lower) if "product_name" in h or "title" in h or "name" in h), -1)
    cat_idx = next((i for i, h in enumerate(headers_lower) if h == "category"), -1)
    cat_url_idx = get_idx("category_url")
    url_idx = get_idx("product_url")
    disc_idx = get_idx("is_discontinued")
    updated_idx = get_idx("updated")

    rows_data = []
    for row in reader:
        if not row or len(row) < 2:
            continue

        item_num = clean_sql(row[item_num_idx]) if (item_num_idx != -1 and len(row) > item_num_idx) else ""
        title = clean_sql(row[name_idx]) if (name_idx != -1 and len(row) > name_idx) else ""
        category = clean_sql(row[cat_idx]) if (cat_idx != -1 and len(row) > cat_idx) else ""
        cat_url = clean_sql(row[cat_url_idx]) if (cat_url_idx != -1 and len(row) > cat_url_idx) else ""
        url = clean_sql(row[url_idx]) if (url_idx != -1 and len(row) > url_idx) else ""
        is_disc = clean_sql(row[disc_idx]) if (disc_idx != -1 and len(row) > disc_idx) else "0"
        updated_at = clean_sql(row[updated_idx]) if (updated_idx != -1 and len(row) > updated_idx and row[updated_idx].strip()) else "2026-10-11 00:00:00"

        if not item_num or not title:
            continue

        is_disc = is_disc if is_disc in ("0", "1") else "0"
        rows_data.append((item_num, title, category, cat_url, url, is_disc, updated_at))

    batch_size = 100
    row_count = 0

    with open(sql_filename, mode="w", encoding="utf-8") as f_out:
        f_out.write("""CREATE TABLE IF NOT EXISTS global_products (
    item_number TEXT PRIMARY KEY,
    sku TEXT,
    product_name TEXT NOT NULL,
    category TEXT,
    category_url TEXT,
    product_url TEXT,
    is_discontinued INTEGER NOT NULL DEFAULT 0,
    updated_at TEXT
);

CREATE INDEX IF NOT EXISTS idx_global_products_sku ON global_products(sku);
CREATE INDEX IF NOT EXISTS idx_global_products_name ON global_products(product_name COLLATE NOCASE);
CREATE INDEX IF NOT EXISTS idx_global_products_category ON global_products(category, product_name COLLATE NOCASE);

""")

        for i in range(0, len(rows_data), batch_size):
            batch = rows_data[i:i + batch_size]
            
            values_clauses = []
            for item_num, title, category, cat_url, url, is_disc, updated_at in batch:
                values_clauses.append(f"('{item_num}', '{title}', '{category}', '{cat_url}', '{url}', {is_disc}, '{updated_at}')")
                row_count += 1

            joined_values = ",\n    ".join(values_clauses)
            sql = f"""INSERT INTO global_products (item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES 
    {joined_values}
ON CONFLICT(item_number) DO UPDATE SET 
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;\n\n"""
            f_out.write(sql)

print(f"\n[+] SUCCESS: Written {row_count} rows across batched multi-row inserts to '{sql_filename}'")