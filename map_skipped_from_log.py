import csv
import os
import re
from collections import Counter, defaultdict

FULL_RUN_CSV = "warehouse_products_full_run.csv"
TRIMMED_RUN_CSV = "warehouse_products_trimmed_run.csv"
LOG_FILE = "scraper_log.txt"  # Log from the full 952 run
OUTPUT_REPORT = "skipped_categories_from_log.csv"

# Adjust to match your product unique identifier column (e.g., 'Item_Number', 'SKU', 'Item #', 'ID')
ITEM_KEY_COLUMN = "sku"


def read_product_keys(filepath):
    """Reads product keys from a CSV file."""
    if not os.path.exists(filepath):
        print(f"Error: File '{filepath}' not found in {os.getcwd()}")
        exit(1)

    keys = set()
    with open(filepath, "r", encoding="utf-8-sig", errors="ignore") as f:
        reader = csv.DictReader(f)
        for row in reader:
            key = row.get(ITEM_KEY_COLUMN, "").strip()
            if key:
                keys.add(key)
    return keys


# 1. Identify the 334 skipped item IDs
full_keys = read_product_keys(FULL_RUN_CSV)
trimmed_keys = read_product_keys(TRIMMED_RUN_CSV)
skipped_keys = full_keys - trimmed_keys

print(f"Loaded {len(full_keys)} products from full run.")
print(f"Loaded {len(trimmed_keys)} products from trimmed run.")
print(f"Identified {len(skipped_keys)} skipped products.")
print("-" * 55)

if not os.path.exists(LOG_FILE):
    print(f"Error: Log file '{LOG_FILE}' not found.")
    exit(1)

# 2. Read log file safely (UTF-8 or UTF-16)
try:
    with open(LOG_FILE, "rb") as f:
        raw = f.read()
    if raw.startswith(b"\xff\xfe") or raw.startswith(b"\xfe\xff"):
        log_text = raw.decode("utf-16", errors="ignore")
    else:
        try:
            log_text = raw.decode("utf-8")
        except UnicodeDecodeError:
            log_text = raw.decode("utf-16", errors="ignore")
except Exception as e:
    print(f"Error reading log: {e}")
    exit(1)

log_text = log_text.replace("\x00", "")

# 3. Split log into processing blocks/sections
blocks = re.split(
    r"(?=https?://|---|Starting Category:|Processing URL:)", log_text
)

# Map category URL -> list of skipped items found in that block
cat_to_skipped = defaultdict(set)
found_skipped_count = set()

for block in blocks:
    # Find category URL in this log block
    urls = re.findall(
        r"(?:https?://[^\s\"',\]\)]+|/[a-zA-Z0-9-_\.]+\.html)", block
    )
    if not urls:
        continue

    cat_url = urls[0].split("?")[0]  # Clean query parameters

    # Check if any skipped item IDs appear in this block text
    for item_id in skipped_keys:
        if item_id in block:
            cat_to_skipped[cat_url].add(item_id)
            found_skipped_count.add(item_id)

# 4. Display results
print(f"Successfully mapped {len(found_skipped_count)} of {len(skipped_keys)} skipped items back to log categories.\n")
print(f"{'Category URL':<60} | {'Skipped Items'}")
print("-" * 75)

sorted_cats = sorted(
    cat_to_skipped.items(), key=lambda x: len(x[1]), reverse=True
)

for cat_url, items in sorted_cats:
    print(f"{cat_url[:59]:<60} | {len(items)}")

# 5. Export report to CSV
with open(OUTPUT_REPORT, "w", encoding="utf-8", newline="") as f:
    writer = csv.writer(f)
    writer.writerow(
        ["Category_URL", "Skipped_Product_Count", "Sample_Item_Numbers"]
    )
    for cat_url, items in sorted_cats:
        sample_items = ", ".join(list(items)[:5])
        writer.writerow([cat_url, len(items), sample_items])

print("-" * 55)
print(f"Breakdown saved to: {OUTPUT_REPORT}")