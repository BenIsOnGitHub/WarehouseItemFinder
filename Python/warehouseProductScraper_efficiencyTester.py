import csv
# Import CATEGORY_KEYWORDS directly from your scraper script
from warehouseProductScraper import CATEGORY_KEYWORDS

CSV_FILE = "warehouse_products.csv"

def analyze_category_coverage():
    # 1. Count products per category_url in the CSV
    category_counts = {}
    total_products = 0

    try:
        with open(CSV_FILE, mode="r", encoding="utf-8") as f:
            reader = csv.DictReader(f)
            for row in reader:
                total_products += 1
                cat_url = row.get("category_url", "").strip()
                if cat_url:
                    category_counts[cat_url] = category_counts.get(cat_url, 0) + 1
    except FileNotFoundError:
        print(f"Error: Could not find '{CSV_FILE}'. Make sure the file path is correct.")
        return

    # 2. Compare against CATEGORY_KEYWORDS
    keywords_set = set(CATEGORY_KEYWORDS)
    scraped_set = set(category_counts.keys())

    used_categories = keywords_set.intersection(scraped_set)
    unused_categories = keywords_set - scraped_set
    unexpected_categories = scraped_set - keywords_set

    # 3. Print Results
    print("=" * 70)
    print(" CATEGORY COVERAGE & PRODUCT COUNT REPORT")
    print("=" * 70)
    print(f"Total Products in CSV: {total_products}")
    print(f"Total Configured Keywords: {len(CATEGORY_KEYWORDS)}")
    print(f"Categories with Products Found: {len(used_categories)}")
    print(f"Unused / Empty Categories: {len(unused_categories)}")
    print("-" * 70)

    # Breakdown of Active Categories
    print("\n[+] PRODUCTS PER CATEGORY (USED CATEGORIES):")
    sorted_counts = sorted(category_counts.items(), key=lambda x: x[1], reverse=True)
    for cat_url, count in sorted_counts:
        status = "[Configured]" if cat_url in keywords_set else "[Unmapped]"
        print(f"  - {count:>4} items | {status} {cat_url}")

    # Unused Categories Breakdown
    if unused_categories:
        print("\n[-] UNUSED CATEGORIES (0 items captured):")
        for cat_url in sorted(unused_categories):
            print(f"  - {cat_url}")
    else:
        print("\n[+] All configured CATEGORY_KEYWORDS produced at least 1 product!")

    print("=" * 70)

if __name__ == "__main__":
    analyze_category_coverage()