import asyncio
import csv
import json
import math
import random
import re
import urllib.parse
import uuid
from datetime import datetime, timezone
from playwright.async_api import async_playwright

CATEGORY_KEYWORDS = [
    "https://www.costco.com/appliances.html",
    "https://www.costco.com/baby-kids.html",
    "https://www.costco.com/beauty.html",
    "https://www.costco.com/black-friday-menu.html",
    "https://www.costco.com/clothing.html",
    "https://www.costco.com/computers.html",
    "https://www.costco.com/electronics.html",
    "https://www.costco.com/holiday-gifts.html",
    "https://www.costco.com/furniture.html",
    "https://www.costco.com/gift-cards-tickets.html",		
    "https://www.costco.com/grocery-household.html",
    "https://www.costco.com/health-beauty.html",
    "https://www.costco.com/seasonal.html",
    "https://www.costco.com/home-and-decor.html",
    "https://www.costco.com/hardware.html",
    "https://www.costco.com/jewelry.html",
    "https://www.costco.com/mattresses.html",
    "https://www.costco.com/office-products.html",
    "https://www.costco.com/patio-lawn-garden.html",
    "https://www.costco.com/pet-supplies.html",
    "https://www.costco.com/sports-fitness.html",
    "https://www.costco.com/auto-tires.html",
    "https://www.costco.com/toys.html",
    "https://www.costco.com/view-more.html"
]

DEFAULT_WAREHOUSE_ID = "102"
OUTPUT_CSV_FILE = "warehouse_products.csv"
ITEMS_PER_PAGE = 24

# Fixed UUID namespace for deterministic hashing
NAMESPACE_COSTCO = uuid.UUID('6ba7b810-9dad-11d1-80b4-00c04fd430c8')


def generate_product_id(warehouse_id: str, product_name: str) -> str:
    """
    Generates a deterministic UUIDv5 seeded on warehouse_id and normalized title.
    Guarantees matching primary keys across scraper runs.
    """
    clean_title = " ".join(product_name.lower().strip().split())
    seed = f"{warehouse_id}:{clean_title}"
    return str(uuid.uuid5(NAMESPACE_COSTCO, seed))


async def get_selected_warehouse_id(page, context):
    """Detects selected warehouse ID from cookies or LocalStorage."""
    cookies = await context.cookies()

    for cookie in cookies:
        name = cookie["name"].upper()
        if "WAREHOUSE" in name or "LOCATION" in name:
            try:
                raw_val = urllib.parse.unquote(cookie["value"])
                if "nearestWarehouse" in raw_val or "catalog" in raw_val:
                    data = json.loads(raw_val)
                    catalog_str = data.get("nearestWarehouse", {}).get("catalog", "")
                    match = re.search(r"(\d+)", catalog_str)
                    if match:
                        wh_id = match.group(1)
                        print(f"[+] Found Warehouse ID in cookie '{cookie['name']}': {wh_id}")
                        return wh_id

                match = re.search(r"(\d{3,4})-wh", raw_val) or re.search(r'"catalog":"(\d+)', raw_val)
                if match:
                    wh_id = match.group(1)
                    print(f"[+] Regex matched Warehouse ID in cookie '{cookie['name']}': {wh_id}")
                    return wh_id
            except Exception:
                pass

    try:
        wh_id = await page.evaluate("""
            () => {
                for (let i = 0; i < localStorage.length; i++) {
                    const key = localStorage.key(i);
                    const val = localStorage.getItem(key);
                    if (val && (val.includes('nearestWarehouse') || val.includes('warehouse'))) {
                        const match = val.match(/(\\d{3,4})-wh/) || val.match(/"catalog":"(\\d+)"/);
                        if (match) return match[1];
                    }
                }
                return null;
            }
        """)
        if wh_id:
            print(f"[+] Found Warehouse ID in LocalStorage: {wh_id}")
            return wh_id
    except Exception:
        pass

    print("[!] Auto-detection failed. Falling back to default.")
    return None


def extract_items_and_meta(data):
    """Parses GDX search API payload for top-level records and nested items."""
    new_items = []
    total_count = None

    if not isinstance(data, dict):
        return new_items, total_count

    total_count = data.get("totalSize") or data.get("totalCount")
    products = data.get("productData", [])
    if not isinstance(products, list):
        return new_items, total_count

    for product in products:
        if not isinstance(product, dict):
            continue

        # Top-level 'id' is the Web Catalog SKU (e.g., "4201019391")
        sku = str(product.get("id") or "").strip()

        # Extract Title
        title = ""
        descriptions = product.get("descriptions", [])
        if descriptions and isinstance(descriptions, list):
            obj = descriptions[0].get("object", {})
            title = str(obj.get("shortDescription") or "").strip()

        # Extract 5-7 digit Warehouse Item Number from childCatalogData
        item_number = ""
        child_data = product.get("childCatalogData", [])
        if child_data and isinstance(child_data, list):
            for child in child_data:
                child_id = str(child.get("id") or "").strip()
                if child_id and len(child_id) <= 7 and child_id.isdigit():
                    item_number = child_id
                    break

        # Fallback attribute check if childCatalogData is missing
        if not item_number:
            attrs = product.get("productAttributes", [])
            if attrs and isinstance(attrs, list):
                attr_list = attrs[0].get("object", [])
                for attr in attr_list:
                    if attr.get("key") == "Item Number":
                        item_number = str(attr.get("value") or "").strip()

        # Standardized direct product URL
        ref_id = item_number or sku
        product_url = f"https://www.costco.com/.product.{ref_id}.html" if ref_id else ""

        if title and (item_number or sku):
            new_items.append({
                "item_number": item_number,
                "sku": sku,
                "title": title,
                "url": product_url
            })

    return new_items, total_count


async def extract_items_from_dom(page):
    """
    DOM Fallback:
    Parses product tiles for visible Item Numbers ('Item #XXXXXX'),
    attributes, and product link URLs.
    """
    return await page.evaluate("""
        () => {
            const items = [];
            const tiles = Array.from(document.querySelectorAll(
                '.product-tile, .product-list-item, [data-sku], div[class*="product"]'
            ));

            tiles.forEach(tile => {
                const link = tile.querySelector('a[href*=".product."], a[href*="/p/"]');
                if (!link) return;

                const rawUrl = link.href;
                const title = (
                    tile.querySelector('.description, .product-title, [class*="title"]')?.innerText ||
                    link.innerText ||
                    link.getAttribute('aria-label') ||
                    ''
                ).trim().replace(/\\s+/g, ' ');

                if (title.length < 3) return;

                let item_number = "";
                let sku = "";

                # 1. Inspect tile text for 'Item #123456' or 'Item 123456'
                const tileText = tile.innerText || "";
                const itemMatch = tileText.match(/Item\\s*#?\\s*(\\d{5,7})\\b/i);
                if (itemMatch) {
                    item_number = itemMatch[1];
                }

                # 2. Inspect data attributes on tile
                if (!item_number) {
                    const dataNum = tile.getAttribute('data-itemnumber') || tile.getAttribute('data-item-id');
                    if (dataNum && dataNum.length >= 5 && dataNum.length <= 7) {
                        item_number = dataNum;
                    }
                }

                # 3. Extract SKU or Item Number from URL pattern
                const urlMatch = rawUrl.match(/\\.product\\.(\\d+)\\.html/) || rawUrl.match(/\\/(\\d{5,12})(?:\\?|$)/);
                if (urlMatch) {
                    const extractedNum = urlMatch[1];
                    if (extractedNum.length >= 5 && extractedNum.length <= 7) {
                        if (!item_number) item_number = extractedNum;
                    } else {
                        sku = extractedNum;
                    }
                }

                const refId = item_number || sku;
                const cleanUrl = refId ? `https://www.costco.com/.product.${refId}.html` : rawUrl;

                if (item_number || sku) {
                    items.push({
                        item_number: item_number,
                        sku: sku,
                        title: title,
                        url: cleanUrl
                    });
                }
            });

            return items;
        }
    """)


async def main():
    seen_identifiers = set()

    async with async_playwright() as p:
        print("\n[+] Launching Chrome Browser Session...")
        context = await p.chromium.launch_persistent_context(
            user_data_dir="./chrome_user_data",
            channel="chrome",
            headless=False,
            args=["--disable-blink-features=AutomationControlled", "--start-maximized"],
            viewport={"width": 1440, "height": 900},
        )

        page = await context.new_page()

        # Step 1: Initial Setup Prompt
        await page.goto("https://www.costco.com/s?keyword=pet+supplies")

        print("\n" + "=" * 60)
        print("ACTION REQUIRED IN BROWSER WINDOW:")
        print("1. Click 'Delivery Location' / 'My Warehouse' at top header.")
        print("2. Enter your zip code and select your target warehouse.")
        print("3. Check the 'In-Warehouse' (or 'Buy In Warehouse') checkbox.")
        print("4. Return to this terminal and press ENTER when finished.")
        print("=" * 60 + "\n")

        input("Press ENTER after setting location & filter in Chrome...")

        # Step 2: Auto-detect Warehouse ID
        detected_id = await get_selected_warehouse_id(page, context)
        active_warehouse_id = detected_id if detected_id else DEFAULT_WAREHOUSE_ID
        print(f"[*] Proceeding with Warehouse ID: {active_warehouse_id}\n")

        # Step 3: Global CSV Setup
        with open(OUTPUT_CSV_FILE, mode="w", newline="", encoding="utf-8") as csv_file:
            writer = csv.writer(csv_file)
            writer.writerow([
                "id",
                "warehouse_id",
                "sku",
                "item_number",
                "product_name",
                "product_url",
                "aisle",
                "bay",
                "is_wrong",
                "is_discontinued",
                "category_url",
                "updated_at"
            ])

            # Step 4: Category Loop
            for keyword in CATEGORY_KEYWORDS:
                print(f"\n" + "=" * 60)
                print(f"Starting Category: {keyword.upper()}")
                print("=" * 60)

                current_page = 1
                max_pages = None
                consecutive_empty_pages = 0

                async def handle_response(response):
                    nonlocal max_pages
                    try:
                        url = response.url.lower()

                        if ("gdx-api.costco.com" in url or "catalog/search" in url) and response.status == 200:
                            content_type = response.headers.get("content-type", "")
                            if "json" in content_type:
                                data = await response.json()

                                extracted, total_count = extract_items_and_meta(data)

                                if total_count and max_pages is None:
                                    max_pages = math.ceil(total_count / ITEMS_PER_PAGE)
                                    print(f"      [+] API metadata: {total_count} total items (~{max_pages} pages).")

                                new_count = 0
                                scrape_time = datetime.now(timezone.utc).isoformat()
                                for item in extracted:
                                    # Deduplicate across runs using title or available ID
                                    dedup_key = f"{active_warehouse_id}:{item['title'].lower().strip()}"
                                    if dedup_key not in seen_identifiers:
                                        seen_identifiers.add(dedup_key)

                                        product_id = generate_product_id(active_warehouse_id, item["title"])

                                        writer.writerow([
                                            product_id,               # id (UUIDv5)
                                            active_warehouse_id,      # warehouse_id
                                            item["sku"],              # sku
                                            item["item_number"],       # item_number
                                            item["title"],            # product_name
                                            item["url"],              # product_url
                                            "",                       # aisle
                                            "",                       # bay
                                            0,                        # is_wrong
                                            0,                        # is_discontinued
                                            keyword,                  # category_url
                                            scrape_time               # updated_at
                                        ])
                                        new_count += 1

                                if new_count > 0:
                                    print(f"      [GDX API Intercept] Captured {new_count} new items (Total saved: {len(seen_identifiers)})")
                    except Exception as e:
                        print(f"  [!] Error inside handle_response: {e}")

                response_listener = page.on("response", handle_response)

                while True:
                    target_url = (
                        f"{keyword}"
                        f"?refinement=buyInWarehouse%3Dtrue&currentPage={current_page}"
                    )

                    page_label = f"Page {current_page}" + (f"/{max_pages}" if max_pages else "")
                    print(f"\n[{page_label}] Navigating: {target_url}")

                    items_before = len(seen_identifiers)

                    try:
                        await page.goto(target_url, wait_until="load", timeout=45000)
                        await asyncio.sleep(2.5)
                        await page.evaluate("window.scrollTo(0, document.body.scrollHeight / 2);")
                        await asyncio.sleep(1.0)

                    except Exception as e:
                        print(f"  [!] Navigation error on {page_label}: {e}")

                    new_items_on_page = len(seen_identifiers) - items_before

                    # DOM Fallback execution
                    if new_items_on_page == 0:
                        dom_items = await extract_items_from_dom(page)
                        dom_added = 0
                        scrape_time = datetime.now(timezone.utc).isoformat()
                        for item in dom_items:
                            dedup_key = f"{active_warehouse_id}:{item['title'].lower().strip()}"
                            if dedup_key not in seen_identifiers:
                                seen_identifiers.add(dedup_key)

                                product_id = generate_product_id(active_warehouse_id, item["title"])

                                writer.writerow([
                                    product_id,
                                    active_warehouse_id,
                                    item["sku"],
                                    item["item_number"],
                                    item["title"],
                                    item["url"],
                                    "",
                                    "",
                                    0,
                                    0,
                                    keyword,
                                    scrape_time
                                ])
                                dom_added += 1

                        if dom_added > 0:
                            print(f"      [DOM Fallback] Captured {dom_added} items from HTML.")
                            new_items_on_page = dom_added

                    if new_items_on_page == 0:
                        consecutive_empty_pages += 1
                        if consecutive_empty_pages >= 2:
                            print(f"  [+] No new items captured on 2 consecutive pages. Moving to next category.")
                            break
                    else:
                        consecutive_empty_pages = 0

                    if max_pages and current_page >= max_pages:
                        print(f"  [+] Reached target maximum page ({max_pages}). Moving to next category.")
                        break

                    current_page += 1
                    await asyncio.sleep(random.uniform(1.5, 2.5))

                page.remove_listener("response", handle_response)

        await context.close()

    print("\n" + "=" * 60)
    print(f"Scraping Complete! Captured {len(seen_identifiers)} total unique warehouse products for Warehouse ID {active_warehouse_id}.")
    print(f"Data saved to: {OUTPUT_CSV_FILE}")
    print("=" * 60)


if __name__ == "__main__":
    asyncio.run(main())