import re
import csv
import time
import requests
import xml.etree.ElementTree as ET

SITEMAP_INDEX_URL = "https://www.costco.com/sitemap_index.xml"

HEADERS = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36',
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
    'Accept-Language': 'en-US,en;q=0.9',
}

def parse_zip_code(raw_zip):
    digits = re.sub(r'\D', '', raw_zip or '')
    if len(digits) == 9:
        return f"{digits[:5]}-{digits[5:]}"
    elif len(digits) == 5:
        return digits
    return raw_zip.strip() if raw_zip else ''

def get_warehouse_urls_from_xml():
    session = requests.Session()
    session.headers.update(HEADERS)

    print(f"Fetching XML sitemap index: {SITEMAP_INDEX_URL}")
    res = session.get(SITEMAP_INDEX_URL)
    if not res.ok:
        print(f"Failed to fetch sitemap index: {res.status_code}")
        return []

    # Parse sitemap index XML
    root = ET.fromstring(res.text)
    namespace = {'ns': 'http://www.sitemaps.org/schemas/sitemap/0.9'}
    
    # Find sitemap files that contain warehouse locations
    sitemap_urls = [loc.text for loc in root.findall('.//ns:loc', namespace) if 'warehouse' in loc.text]

    if not sitemap_urls:
        # Fallback: check all sub-sitemaps in index
        sitemap_urls = [loc.text for loc in root.findall('.//ns:loc', namespace)]

    warehouse_page_urls = []

    for s_url in sitemap_urls:
        print(f"Checking sub-sitemap: {s_url}")
        r = session.get(s_url)
        if not r.ok:
            continue
        try:
            sub_root = ET.fromstring(r.text)
            for loc in sub_root.findall('.//ns:loc', namespace):
                url = loc.text or ''
                if '/warehouse-locations/' in url and url not in warehouse_page_urls:
                    warehouse_page_urls.append(url)
        except Exception as e:
            print(f"Error parsing {s_url}: {e}")

    return warehouse_page_urls

def scrape_warehouses():
    session = requests.Session()
    session.headers.update(HEADERS)

    warehouse_urls = get_warehouse_urls_from_xml()
    print(f"Found {len(warehouse_urls)} individual warehouse page URLs.")

    warehouses = []
    seen_ids = set()

    for index, url in enumerate(warehouse_urls, 1):
        print(f"[{index}/{len(warehouse_urls)}] Scraping: {url}")
        try:
            r = session.get(url)
            if not r.ok:
                continue

            # Extract JSON-LD script blocks from warehouse page
            json_blocks = re.findall(r'<script[^>]*type=["\']application/ld\+json["\'][^>]*>(.*?)</script>', r.text, re.DOTALL)
            
            for block in json_blocks:
                try:
                    import json
                    data = json.loads(block.strip())
                    items = data if isinstance(data, list) else [data]

                    for item in items:
                        if item.get('@type') in ['Store', 'FastFoodRestaurant', 'LocalBusiness', 'Organization']:
                            wh_id = str(item.get('branchCode') or item.get('identifier') or '').strip()
                            
                            # Fallback ID extraction from URL if missing in JSON
                            if not wh_id:
                                id_match = re.search(r'-(\d+)\.html', url)
                                if id_match:
                                    wh_id = id_match.group(1)

                            wh_name = item.get('name', '').strip()
                            addr = item.get('address', {})

                            if isinstance(addr, dict):
                                street = addr.get('streetAddress', '').strip()
                                city = addr.get('addressLocality', '').strip()
                                state = (addr.get('addressRegion') or '')[:2].upper()
                                zip_code = parse_zip_code(addr.get('postalCode', ''))
                            else:
                                street = city = state = zip_code = ''

                            if wh_id and wh_id not in seen_ids:
                                seen_ids.add(wh_id)
                                warehouses.append({
                                    'warehouse_id': wh_id,
                                    'warehouse_name': wh_name,
                                    'street_address': street,
                                    'city': city,
                                    'state': state,
                                    'zip_code': zip_code
                                })
                except Exception:
                    pass

            time.sleep(0.3)

        except Exception as e:
            print(f"Error scraping {url}: {e}")

    return warehouses

if __name__ == '__main__':
    data = scrape_warehouses()
    print(f"\nSuccessfully scraped {len(data)} warehouses.")

    output_filename = "costco_warehouses.csv"
    with open(output_filename, 'w', newline='', encoding='utf-8') as f:
        writer = csv.DictWriter(f, fieldnames=['warehouse_id', 'warehouse_name', 'street_address', 'city', 'state', 'zip_code'])
        writer.writeheader()
        writer.writerows(data)

    print(f"Saved results to {output_filename}")