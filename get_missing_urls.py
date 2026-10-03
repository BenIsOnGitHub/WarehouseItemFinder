import csv

FILE_OLD = "warehouse_products_old.csv"
FILE_COMBINED = "warehouse_products_combined.csv"


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
    combined_keys = set()
    with open(FILE_COMBINED, mode="r", encoding="utf-8-sig") as f:
        for row in csv.DictReader(f):
            key = get_canonical_item_key(row)
            if key:
                combined_keys.add(key)

    missing_urls = {}
    total_missing_items = 0

    with open(FILE_OLD, mode="r", encoding="utf-8-sig") as f:
        for row in csv.DictReader(f):
            key = get_canonical_item_key(row)
            if key and key not in combined_keys:
                cat_url = row.get("category_url", "").strip()
                if cat_url:
                    missing_urls[cat_url] = missing_urls.get(cat_url, 0) + 1
                    total_missing_items += 1

    print(f"[+] Found {total_missing_items} missing items across {len(missing_urls)} category URLs.\n")
    print("=" * 70)
    print("TOP CATEGORY URLS WITH MISSING ITEMS")
    print("=" * 70)

    # Sort categories by highest count of missing items
    sorted_cats = sorted(missing_urls.items(), key=lambda x: x[1], reverse=True)

    for url, count in sorted_cats:
        print(f"  - [{count} missing items] {url}")

    # Output Python array ready for scraper
    print("\n" + "=" * 70)
    print("RECOVERY_CATEGORY_KEYWORDS = [")
    for url, _ in sorted_cats:
        print(f'    "{url}",')
    print("]")


if __name__ == "__main__":
    main()