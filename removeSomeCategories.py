import os
import re

INPUT_URLS_FILE = "subcategorylist_withquotes.txt"
LOG_FILE = "scraper_log.txt"
OUTPUT_FILE = "filtered_subcategorylist.txt"

if not os.path.exists(INPUT_URLS_FILE) or not os.path.exists(LOG_FILE):
    print(f"Error: Missing required files in {os.getcwd()}")
    exit(1)


def read_file_clean(filepath):
    """Safely reads UTF-16 or UTF-8 encoded files and strips null bytes."""
    try:
        with open(filepath, "rb") as f:
            raw_bytes = f.read()

        # Explicitly check for UTF-16 BOM or decode as utf-16
        if raw_bytes.startswith(b"\xff\xfe") or raw_bytes.startswith(
            b"\xfe\xff"
        ):
            content = raw_bytes.decode("utf-16", errors="ignore")
        else:
            try:
                # Try UTF-16 first if null bytes exist in the raw buffer
                if b"\x00" in raw_bytes:
                    content = raw_bytes.decode("utf-16", errors="ignore")
                else:
                    content = raw_bytes.decode("utf-8")
            except UnicodeDecodeError:
                content = raw_bytes.decode("utf-16", errors="ignore")
    except Exception as e:
        print(f"Error reading {filepath}: {e}")
        exit(1)

    return content.replace("\x00", "")


def extract_stem(url_str):
    """Extracts base keyword stem from URL for matching (e.g., 'vacuums')."""
    if not url_str:
        return ""
    clean = url_str.strip().strip('"\',[] \t\r\n')
    clean = clean.split("?")[0].split("#")[0]
    filename = clean.split("/")[-1].lower()
    return filename.replace(".html", "").strip()


# 1. Load input URLs
raw_input = read_file_clean(INPUT_URLS_FILE)
all_entries = []

# Split on all possible newline variations (\r\n, \n, \r)
lines = re.split(r"\r?\n|\r", raw_input)

for line in lines:
    clean_line = line.strip().strip('"\',[] \t\r\n')
    if clean_line.startswith("http") or clean_line.endswith(".html"):
        stem = extract_stem(clean_line)
        if stem:
            all_entries.append((clean_line, stem))

print(f"Loaded {len(all_entries)} target URLs from {INPUT_URLS_FILE}")

# 2. Load scraper log
log_content = read_file_clean(LOG_FILE)

# 3. Collect active and evaluated subcategory slugs from log
log_blocks = re.split(
    r"(?=https?://|---|Starting Category:|Processing URL:)", log_content
)

all_logged_slugs = set()
active_logged_slugs = set()

for block in log_blocks:
    urls_found = re.findall(
        r"(?:https?://[^\s\"',\]\)]+|/[a-zA-Z0-9-_\.]+\.html)", block
    )
    if not urls_found:
        continue

    counts = re.findall(r"Captured\s+(\d+)\s+items", block, re.IGNORECASE)
    total_items = sum(int(c) for c in counts)

    for raw_url in urls_found:
        stem = extract_stem(raw_url)
        if stem:
            all_logged_slugs.add(stem)
            if total_items > 0:
                active_logged_slugs.add(stem)

print(f"Total subcategories found in log: {len(all_logged_slugs)}")
print(f"Active subcategories (>0 SKUs) in log: {len(active_logged_slugs)}")

# 4. Keyword and containment matching
filtered_urls = []
removed_urls = []
kept_active = 0
kept_unprocessed = 0

for original_url, target_stem in all_entries:
    # Match target stem against logged subcategories
    matches_in_log = [
        s for s in all_logged_slugs if target_stem in s or s in target_stem
    ]

    if not matches_in_log:
        # Never evaluated in log -> Keep intact
        filtered_urls.append(original_url)
        kept_unprocessed += 1
    else:
        # Check if any related subcategory yielded items
        active_matches = [
            s for s in matches_in_log if s in active_logged_slugs
        ]
        if active_matches:
            filtered_urls.append(original_url)
            kept_active += 1
        else:
            removed_urls.append(original_url)

# 5. Save output file
with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
    f.write("CATEGORY_KEYWORDS = [\n")
    for url in filtered_urls:
        f.write(f'    "{url}",\n')
    f.write("]\n")

print("-" * 50)
print(f"Original total URLs: {len(all_entries)}")
print(f"Active categories kept (>0 child SKUs): {kept_active}")
print(f"Unprocessed URLs kept (not in log): {kept_unprocessed}")
print(f"Total kept: {len(filtered_urls)}")
print(f"Zero-SKU categories removed: {len(removed_urls)}")
print(f"Filtered list saved to: {OUTPUT_FILE}")