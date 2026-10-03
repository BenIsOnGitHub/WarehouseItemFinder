import csv
from collections import defaultdict

# Update filenames if needed
OLD_CSV = "warehouse_products_old.csv"  # File with ~2,300 items
NEW_CSV = "warehouse_products_new.csv"  # File with 1,589 items


def load_category_counts(filename):
    cat_counts = defaultdict(set)
    total_rows = 0

    with open(filename, mode="r", encoding="utf-8-sig") as f:
        reader = csv.DictReader(f)
        for row in reader:
            total_rows += 1
            cat_url = row.get("category_url", "").strip()
            item_num = row.get("item_number", "").strip() or row.get("sku", "").strip() or row.get("id", "").strip()

            if cat_url:
                cat_counts[cat_url].add(item_num)

    return cat_counts, total_rows


def main():
    print("[+] Loading CSV files...")
    old_counts, old_total = load_category_counts(OLD_CSV)
    new_counts, new_total = load_category_counts(NEW_CSV)

    print(f"Old CSV Total Rows: {old_total} | Unique Categories: {len(old_counts)}")
    print(f"New CSV Total Rows: {new_total} | Unique Categories: {len(new_counts)}\n")

    all_categories = set(old_counts.keys()).union(set(new_counts.keys()))

    completely_missing = []
    dropped_products = []
    gained_products = []

    for cat in sorted(all_categories):
        old_cnt = len(old_counts.get(cat, set()))
        new_cnt = len(new_counts.get(cat, set()))

        diff = new_cnt - old_cnt

        if old_cnt > 0 and new_cnt == 0:
            completely_missing.append((cat, old_cnt))
        elif diff < 0:
            dropped_products.append((cat, old_cnt, new_cnt, diff))
        elif diff > 0:
            gained_products.append((cat, old_cnt, new_cnt, diff))

    print("=" * 80)
    print(f"1. CATEGORIES THAT FAILED COMPLETELY (Had items previously, now 0 items): {len(completely_missing)}")
    print("=" * 80)
    for cat, old_cnt in completely_missing:
        print(f"  - [{old_cnt} -> 0] {cat}")

    print("\n" + "=" * 80)
    print(f"2. CATEGORIES WITH DROPPED PRODUCTS: {len(dropped_products)}")
    print("=" * 80)
    for cat, old_cnt, new_cnt, diff in sorted(dropped_products, key=lambda x: x[3]):
        print(f"  - [{old_cnt} -> {new_cnt} | Loss: {diff}] {cat}")

    # Summary Report Output
    with open("category_diff_report.csv", mode="w", newline="", encoding="utf-8") as out:
        writer = csv.writer(out)
        writer.writerow(["category_url", "old_count", "new_count", "difference", "status"])

        for cat in sorted(all_categories):
            old_c = len(old_counts.get(cat, set()))
            new_c = len(new_counts.get(cat, set()))
            diff = new_c - old_c

            if old_c > 0 and new_c == 0:
                status = "FAILED_ZERO"
            elif diff < 0:
                status = "PARTIAL_LOSS"
            elif diff > 0:
                status = "GAINED"
            else:
                status = "MATCH"

            writer.writerow([cat, old_c, new_c, diff, status])

    print("\n[+] Full breakdown exported to 'category_diff_report.csv'")


if __name__ == "__main__":
    main()