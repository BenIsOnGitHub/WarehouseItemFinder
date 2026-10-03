import csv

FILE_OLD = "warehouse_products_old.csv"
FILE_COMBINED = "warehouse_products_combined.csv"

def get_item_key(row):
    wh_id = row.get("warehouse_id", "").strip()
    item_num = row.get("item_number", "").strip() or row.get("sku", "").strip()
    if not item_num:
        item_num = " ".join(row.get("product_name", "").lower().split())
    return f"{wh_id}:{item_num}"

def main():
    combined_keys = set()
    with open(FILE_COMBINED, mode="r", encoding="utf-8-sig") as f:
        for row in csv.DictReader(f):
            combined_keys.add(get_item_key(row))

    missing_urls = set()
    with open(FILE_OLD, mode="r", encoding="utf-8-sig") as f:
        for row in csv.DictReader(f):
            key = get_item_key(row)
            if key not in combined_keys:
                cat_url = row.get("category_url", "").strip()
                if cat_url:
                    missing_urls.add(cat_url)

    print(f"[+] Found {len(missing_urls)} category URLs containing missing items.\n")
    print("TARGET_CATEGORY_KEYWORDS = [")
    for url in sorted(missing_urls):
        print(f'    "{url}",')
    print("]")

if __name__ == "__main__":
    main()