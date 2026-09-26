import csv
import os

FULL_RUN_CSV = "warehouse_products_full_run.csv"
TRIMMED_RUN_CSV = "warehouse_products_trimmed_run.csv"
MERGED_OUTPUT_CSV = "warehouse_products_master_merged.csv"

# Adjust if your unique identifier column name is different
KEY_COLUMN = "sku"


def merge_and_dedupe():
    merged_products = {}
    header = None

    for filepath in [FULL_RUN_CSV, TRIMMED_RUN_CSV]:
        if not os.path.exists(filepath):
            print(f"Warning: File '{filepath}' not found. Skipping.")
            continue

        with open(filepath, "r", encoding="utf-8-sig", errors="ignore") as f:
            reader = csv.DictReader(f)
            if not header:
                header = reader.fieldnames
            for row in reader:
                sku = row.get(KEY_COLUMN, "").strip()
                if sku and sku not in merged_products:
                    merged_products[sku] = row

    if not merged_products:
        print("Error: No products found in input CSV files.")
        return

    with open(MERGED_OUTPUT_CSV, "w", encoding="utf-8", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=header)
        writer.writeheader()
        for sku in sorted(merged_products.keys()):
            writer.writerow(merged_products[sku])

    print(
        f"Successfully merged CSVs! Total unique products: {len(merged_products)}"
    )
    print(f"Output saved to: {MERGED_OUTPUT_CSV}")


if __name__ == "__main__":
    merge_and_dedupe()