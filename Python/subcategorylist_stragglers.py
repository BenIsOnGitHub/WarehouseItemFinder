import re

def extract_urls(file_path):
    """Extracts valid costco.com URLs from a file, handling UTF-8, UTF-16, and BOM encodings."""
    urls = set()
    url_pattern = re.compile(r'https?://[^\s",]+')
    
    try:
        with open(file_path, 'r', encoding='utf-8-sig') as f:
            content = f.read()
    except UnicodeDecodeError:
        with open(file_path, 'r', encoding='utf-16') as f:
            content = f.read()

    for match in url_pattern.finditer(content):
        urls.add(match.group(0).rstrip('"'))

    return urls

def main():
    full_file = "subcategorylist_full.txt"
    found_file = "subcategorylist_productsFound.txt"
    not_found_file = "subcategorylist_noProductsFound.txt"

    full_urls = extract_urls(full_file)
    found_urls = extract_urls(found_file)
    not_found_urls = extract_urls(not_found_file)

    unvisited_urls = full_urls - found_urls - not_found_urls

    print("=" * 60)
    print(" SUBCATEGORY URL SUBTRACTION REPORT")
    print("=" * 60)
    print(f"Total Full URLs:                 {len(full_urls):>4}")
    print(f"URLs with Products Found:       -{len(found_urls):>4}")
    print(f"URLs with No Products Found:    -{len(not_found_urls):>4}")
    print("-" * 60)
    print(f"Remaining / Unvisited URLs:      {len(unvisited_urls):>4}")
    print("=" * 60)

    output_filename = "subcategorylist_remaining.txt"
    with open(output_filename, "w", encoding="utf-8") as f:
        for url in sorted(unvisited_urls):
            f.write(f'    "{url}",\n')

    print(f"\n[+] Saved {len(unvisited_urls)} formatted URLs to '{output_filename}'")

if __name__ == "__main__":
    main()