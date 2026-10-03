import csv

# Compare category URLs present in OLD vs COMBINED
FILE_OLD = "warehouse_products_old.csv"
FILE_COMBINED = "warehouse_products_combined.csv"

def get_canonical_key(row):
    item_num = row.get("item_number", "").strip() or row.get("sku", "").strip()
    if not item_num:
        item_num = " ".join(row.get("product_name", "").lower().split())
    return item_num

def main():
    combined_keys = set()
    with open(FILE_COMBINED, mode="r", encoding="utf-8-sig") as f:
        for row in csv.DictReader(f):
            k = get_canonical_key(row)
            if k:
                combined_keys.add(k)

    # Find items in OLD that are missing in COMBINED
    missing_by_cat = {}
    with open(FILE_OLD, mode="r", encoding="utf-8-sig") as f:
        for row in csv.DictReader(f):
            k = get_canonical_key(row)
            if k and k not in combined_keys:
                cat = row.get("category_url", "").strip()
                item_name = row.get("product_name", "").strip()
                if cat not in missing_by_cat:
                    missing_by_cat[cat] = []
                missing_by_cat[cat].append((k, item_name))

    print(f"[+] Total Categories containing missing items: {len(missing_by_cat)}\n")
    for cat, items in sorted(missing_by_cat.items(), key=lambda x: len(x[1]), reverse=True)[:15]:
        print(f"URL: {cat} (Missing {len(items)} items)")
        print(f"  Sample missing items: {[name for _, name in items[:3]]}\n")

if __name__ == "__main__":
    main()