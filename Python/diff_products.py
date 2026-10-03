import csv
import os

# Update these filenames to match your actual CSV output files
FULL_RUN_CSV = "warehouse_products_full_run.csv"      # The 3777 products file
TRIMMED_RUN_CSV = "warehouse_products_trimmed_run.csv"  # The 3636 products file
DIFF_OUTPUT_CSV = "skipped_products.csv"

# Column name representing the unique item identifier (e.g., 'Item_Number', 'SKU', 'URL')
KEY_COLUMN = "sku"


def read_products(filepath):
    """Reads CSV and returns header and a dict mapping KEY_COLUMN -> row dict."""
    if not os.path.exists(filepath):
        print(f"Error: File '{filepath}' not found.")
        exit(1)

    products = {}
    with open(filepath, "r", encoding="utf-8-sig", errors="ignore") as f:
        reader = csv.DictReader(f)
        header = reader.fieldnames
        for row in reader:
            key = row.get(KEY_COLUMN, "").strip()
            if key:
                products[key] = row
    return header, products


# Load both product sets
header, full_products = read_products(FULL_RUN_CSV)
_, trimmed_products = read_products(TRIMMED_RUN_CSV)

# Identify missing keys
full_keys = set(full_products.keys())
trimmed_keys = set(trimmed_products.keys())

missing_keys = full_keys - trimmed_keys

print(f"Total products in Full Run: {len(full_keys)}")
print(f"Total products in Trimmed Run: {len(trimmed_keys)}")
print(f"Products skipped in Trimmed Run: {len(missing_keys)}")

# Save skipped products to a new CSV
if missing_keys and header:
    with open(DIFF_OUTPUT_CSV, "w", encoding="utf-8", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=header)
        writer.writeheader()
        for key in sorted(missing_keys):
            writer.writerow(full_products[key])

    print(f"\nSkipped products saved to: {DIFF_OUTPUT_CSV}")