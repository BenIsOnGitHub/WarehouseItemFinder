import csv

FILE_OLD = "warehouse_products_old.csv"
FILE_COMBINED = "warehouse_products_combined.csv"
OUTPUT_MISSING = "missing_1017_items.csv"


def get_canonical_item_key(row):
    item_num = row.get("item_number", "").strip()
    sku = row.get("sku", "").strip()

    if not item_num and sku:
        item_num = sku

    canonical_id = item_num or sku

    if not canonical_id:
        canonical_id = " ".join(row.get("product_name", "").lower().split())

    return canonical_id


def main():
    # 1. Load all canonical keys from the updated combined run
    combined_keys = set()
    with open(FILE_COMBINED, mode="r", encoding="utf-8-sig") as f:
        reader = csv.DictReader(f)
        for row in reader:
            key = get_canonical_item_key(row)
            if key:
                combined_keys.add(key)

    print(f"[+] Loaded {len(combined_keys)} unique keys from '{FILE_COMBINED}'.")

    # 2. Extract rows from OLD baseline that are NOT in combined
    missing_rows = []
    seen_missing_keys = set()

    with open(FILE_OLD, mode="r", encoding="utf-8-sig") as f:
        reader = csv.DictReader(f)
        fieldnames = reader.fieldnames
        for row in reader:
            key = get_canonical_item_key(row)
            if key and key not in combined_keys and key not in seen_missing_keys:
                missing_rows.append(row)
                seen_missing_keys.add(key)

    print(f"[+] Extracted {len(missing_rows)} missing items from baseline.")

    # 3. Export to missing_1017_items.csv
    with open(OUTPUT_MISSING, mode="w", newline="", encoding="utf-8-sig") as f:
        if fieldnames and missing_rows:
            writer = csv.DictWriter(f, fieldnames=fieldnames)
            writer.writeheader()
            writer.writerows(missing_rows)

    print(f"[+] Successfully created '{OUTPUT_MISSING}' with all missing baseline items!")


if __name__ == "__main__":
    main()