import csv

FILE_OLD = "warehouse_products_old.csv"
FILE_NEW = "warehouse_products_new.csv"
FILE_RECOVERY = "warehouse_products_rec.csv"  # Latest recovery run


def get_canonical_item_key(row):
    """
    Extracts the pure Costco Item Number regardless of whether it was placed in 
    item_number or sku column, falling back to product_name.
    """
    item_num = row.get("item_number", "").strip()
    sku = row.get("sku", "").strip()

    # If sku is short (5-7 digits), it's actually an item_number from the old script
    if not item_num and sku:
        item_num = sku
    elif item_num and len(item_num) > 8 and not sku:
        # If item_number holds a 10-digit GRS SKU, treat as fallback
        pass

    canonical_id = item_num or sku

    if not canonical_id:
        # Fallback to normalized product title
        canonical_id = " ".join(row.get("product_name", "").lower().split())

    return canonical_id


def load_dataset(filename):
    items = {}
    with open(filename, mode="r", encoding="utf-8-sig") as f:
        reader = csv.DictReader(f)
        for row in reader:
            key = get_canonical_item_key(row)
            if key:
                items[key] = row
    return items


def main():
    print("[+] Loading datasets with canonical item key matching...")
    try:
        old_data = load_dataset(FILE_OLD)
        new_data = load_dataset(FILE_NEW)
        recovery_data = load_dataset(FILE_RECOVERY)
    except FileNotFoundError as e:
        print(f"[!] File missing: {e}")
        return

    print(f"Loaded {len(old_data)} unique items from OLD baseline.")
    print(f"Loaded {len(new_data)} unique items from NEW run.")
    print(f"Loaded {len(recovery_data)} unique items from RECOVERY run.\n")

    truly_recovered = {}
    brand_new = {}
    redundant = {}

    for key, row in recovery_data.items():
        in_old = key in old_data
        in_new = key in new_data

        if in_old and not in_new:
            truly_recovered[key] = row
        elif not in_old and not in_new:
            brand_new[key] = row
        elif in_new:
            redundant[key] = row

    print("=" * 70)
    print("RECOVERY RUN AUDIT BREAKDOWN (CANONICAL KEYS)")
    print("=" * 70)
    print(f"1. TRUE RECOVERIES (Lost in NEW run, now recovered):     {len(truly_recovered)}")
    print(f"2. BRAND NEW ITEMS (Never seen in OLD or NEW):           {len(brand_new)}")
    print(f"3. REDUNDANT ITEMS (Already existed in NEW run):         {len(redundant)}")
    print("=" * 70)

    # Build Master Combined Dataset
    master_combined = dict(new_data)
    master_combined.update(recovery_data)

    output_master = "warehouse_products_combined.csv"
    with open(output_master, mode="w", newline="", encoding="utf-8") as f:
        if master_combined:
            fieldnames = list(next(iter(master_combined.values())).keys())
            writer = csv.DictWriter(f, fieldnames=fieldnames)
            writer.writeheader()
            writer.writerows(master_combined.values())

    print(f"\n[+] Updated master file: '{output_master}' ({len(master_combined)} unique items).")

    still_missing = set(old_data.keys()) - set(master_combined.keys())
    print(f"[+] Total captured vs Baseline: {len(master_combined)} / {len(old_data)}")
    print(f"[!] Truly missing items remaining: {len(still_missing)}")


if __name__ == "__main__":
    main()