import asyncio
import csv
import json
import math
import random
import re
import urllib.parse
from playwright.async_api import async_playwright

CATEGORY_KEYWORDS = [
    "https://www.costco.com/grocery-household.html",
    "https://www.costco.com/appliances.html",
    "https://www.costco.com/small-space-appliances.html",
    "https://www.costco.com/small-refrigerators.html",
    "https://www.costco.com/compact-refrigerators.html",
    "https://www.costco.com/small-dishwashers.html",
    "https://www.costco.com/small-microwaves.html",
    "https://www.costco.com/small-washers-dryers.html",
    "https://www.costco.com/dishwashers.html",
    "https://www.costco.com/freezers-ice-makers.html",
    "https://www.costco.com/freezers.html",
    "https://www.costco.com/ice-makers.html",
    "https://www.costco.com/cooling-air-treatment-heating.html",
    "https://www.costco.com/microwaves.html",
    "https://www.costco.com/countertop-microwaves.html",
    "https://www.costco.com/over-the-range-microwaves.html",
    "https://www.costco.com/refrigerators.html",
    "https://www.costco.com/refrigerators-bottom-mount-door.html",
    "https://www.costco.com/four-door-refrigerators.html",
    "https://www.costco.com/freezerless-refrigerators.html",
    "https://www.costco.com/french-door-refrigerators.html",
    "https://www.costco.com/refrigerators-side-by-side.html",
    "https://www.costco.com/top-mount-refrigerators.html",
    "https://www.costco.com/small-kitchen-appliances.html",
    "https://www.costco.com/blenders-juicers.html",
    "https://www.costco.com/vacuums-floor-care.html",
    "https://www.costco.com/vacuums-floor-care-steam-deep-cleaners.html",
    "https://www.costco.com/commercial-garage-vacuums.html",
    "https://www.costco.com/dryers.html",
    "https://www.costco.com/washers.html",
    "https://www.costco.com/baby-monitors.html",
    "https://www.costco.com/beauty.html",
    "https://www.costco.com/bath-body.html",
    "https://www.costco.com/beauty-tools-accessories.html",
    "https://www.costco.com/hair-care.html",
    "https://www.costco.com/cosmetics.html",
    "https://www.costco.com/skin-care.html",
    "https://www.costco.com/black-friday-menu.html",
    "https://www.costco.com/black-friday.html",
    "https://www.costco.com/clothing.html",
    "https://www.costco.com/mens-clothing.html",
    "https://www.costco.com/accessories.html",
    "https://www.costco.com/womens-clothing.html",
    "https://www.costco.com/computers.html",
    "https://www.costco.com/computer-accessories.html",
    "https://www.costco.com/desktops-servers.html",
    "https://www.costco.com/hard-drives-memory.html",
    "https://www.costco.com/laptops.html",
    "https://www.costco.com/chromebooks.html",
    "https://www.costco.com/gaming-laptops.html",
    "https://www.costco.com/macbooks.html",
    "https://www.costco.com/pc-laptops.html",
    "https://www.costco.com/monitors.html",
    "https://www.costco.com/4k-monitors.html",
    "https://www.costco.com/curved-monitors.html",
    "https://www.costco.com/gaming-monitors.html",
    "https://www.costco.com/portable-monitors.html",
    "https://www.costco.com/smart-monitors.html",
    "https://www.costco.com/ultrawide-monitors.html",
    "https://www.costco.com/widescreen-monitors.html",
    "https://www.costco.com/pc-gaming.html",
    "https://www.costco.com/routers-networking.html",
    "https://www.costco.com/tablet-computers-accessories.html",
    "https://www.costco.com/costco-direct.html",
    "https://www.costco.com/costco-direct-appliances.html",
    "https://www.costco.com/costco-direct-fitness.html",
    "https://www.costco.com/costco-direct-furniture.html",
    "https://www.costco.com/costco-direct-home-upgrades.html",
    "https://www.costco.com/costco-direct-mattresses.html",
    "https://www.costco.com/costco-direct-patio-garden.html",
    "https://www.costco.com/costco-direct-tvs.html",
    "https://www.costco.com/costco-direct-toys.html",
    "https://www.costco.com/cyber-monday-offers-menu.html",
    "https://www.costco.com/cyber-monday-offers.html",
    "https://www.costco.com/airpods.html",
    "https://www.costco.com/apple-smart-watch.html",
    "https://www.costco.com/audio-video.html",
    "https://www.costco.com/batteries.html",
    "https://www.costco.com/cameras-camcorders.html",
    "https://www.costco.com/cell-phones.html",
    "https://www.costco.com/cell-phone-chargers-batteries.html",
    "https://www.costco.com/musical-instruments.html",
    "https://www.costco.com/home-alarm-systems-automation.html",
    "https://www.costco.com/smart-garage-door-openers.html",
    "https://www.costco.com/smart-lighting.html",
    "https://www.costco.com/smart-thermostats-energy-monitors.html",
    "https://www.costco.com/televisions.html",
    "https://www.costco.com/video-games.html",
    "https://www.costco.com/wearable-technology.html",
    "https://www.costco.com/holiday-gifts.html",
    "https://www.costco.com/furniture.html",
    "https://www.costco.com/bedroom-furniture.html",
    "https://www.costco.com/bedroom-furniture-beds.html",
    "https://www.costco.com/bedroom-furniture-chests-dressers.html",
    "https://www.costco.com/bedroom-furniture-nightstands.html",
    "https://www.costco.com/entryway-furniture.html",
    "https://www.costco.com/dining-kitchen.html",
    "https://www.costco.com/barstools.html",
    "https://www.costco.com/tables.html",
    "https://www.costco.com/dining-kitchen-sets.html",
    "https://www.costco.com/living-room.html",
    "https://www.costco.com/living-room-sets.html",
    "https://www.costco.com/office-furniture.html",
    "https://www.costco.com/office-furniture-bookcases.html",
    "https://www.costco.com/office-furniture-collections.html",
    "https://www.costco.com/all-costco-grocery.html",
    "https://www.costco.com/grocery-health-beauty.html",
    "https://www.costco.com/household.html",
    "https://www.costco.com/cakes-cookies.html",
    "https://www.costco.com/beverages.html",
    "https://www.costco.com/refrigerated-beverages.html",
    "https://www.costco.com/juice.html",
    "https://www.costco.com/milk.html",
    "https://www.costco.com/drink-mix.html",
    "https://www.costco.com/soft-drinks.html",
    "https://www.costco.com/energy-drinks.html",
    "https://www.costco.com/bottled-water.html",
    "https://www.costco.com/breakfast.html",
    "https://www.costco.com/breakfast-cereal.html",
    "https://www.costco.com/candy.html",
    "https://www.costco.com/hard-gummy-candy.html",
    "https://www.costco.com/dairy-eggs-cheese.html",
    "https://www.costco.com/cheese.html",
    "https://www.costco.com/household-cleaning.html",
    "https://www.costco.com/cleaning-supplies.html",
    "https://www.costco.com/dish-detergent.html",
    "https://www.costco.com/floor-bathroom-cleaners.html",
    "https://www.costco.com/laundry-supplies.html",
    "https://www.costco.com/trash-bags.html",
    "https://www.costco.com/coffee-sweeteners.html",
    "https://www.costco.com/deli.html",
    "https://www.costco.com/deli-meats.html",
    "https://www.costco.com/dips-spreads.html",
    "https://www.costco.com/prepared-food-soups-salads.html",
    "https://www.costco.com/prosciutto-smoked-cured-meats.html",
    "https://www.costco.com/frozen-appetizers-side-dishes.html",
    "https://www.costco.com/frozen-fruits-vegetables.html",
    "https://www.costco.com/frozen-meals.html",
    "https://www.costco.com/frozen-meat-seafood.html",
    "https://www.costco.com/ice-cream-frozen-desserts.html",
    "https://www.costco.com/kirkland-signature-groceries.html",
    "https://www.costco.com/meat.html",
    "https://www.costco.com/meat-substitutes.html",
    "https://www.costco.com/seafood.html",
    "https://www.costco.com/pantry.html",
    "https://www.costco.com/canned-goods.html",
    "https://www.costco.com/baking.html",
    "https://www.costco.com/honey.html",
    "https://www.costco.com/spreads.html",
    "https://www.costco.com/beans-grains-rice.html",
    "https://www.costco.com/condiments-sauces.html",
    "https://www.costco.com/soup.html",
    "https://www.costco.com/spices-seasonings.html",
    "https://www.costco.com/oils-balsamic.html",
    "https://www.costco.com/paper-products-food-storage.html",
    "https://www.costco.com/facial-tissue.html",
    "https://www.costco.com/food-storage.html",
    "https://www.costco.com/plastic-disposable-bowls.html",
    "https://www.costco.com/paper-towels-napkins.html",
    "https://www.costco.com/disposable-dinnerware.html",
    "https://www.costco.com/food-wrap.html",
    "https://www.costco.com/toilet-paper.html",
    "https://www.costco.com/produce.html",
    "https://www.costco.com/fresh-fruit.html",
    "https://www.costco.com/fresh-vegetables.html",
    "https://www.costco.com/snacks.html",
    "https://www.costco.com/chips-pretzels.html",
    "https://www.costco.com/cookies.html",
    "https://www.costco.com/crackers.html",
    "https://www.costco.com/fruit-snacks-applesauce.html",
    "https://www.costco.com/jerky.html",
    "https://www.costco.com/nuts.html",
    "https://www.costco.com/pastries.html",
    "https://www.costco.com/popcorn.html",
    "https://www.costco.com/snacks-bars.html",
    "https://www.costco.com/trail-snack-mix.html",
    "https://www.costco.com/health-beauty.html",
    "https://www.costco.com/non-prescription-remedies.html",
    "https://www.costco.com/home-health-care.html",
    "https://www.costco.com/blood-pressure-health-monitors.html",
    "https://www.costco.com/home-health-care-first-aid.html",
    "https://www.costco.com/massage-relaxation.html",
    "https://www.costco.com/diet-nutrition.html",
    "https://www.costco.com/healthy-snacks.html",
    "https://www.costco.com/personal-care.html",
    "https://www.costco.com/reading-glasses.html",
    "https://www.costco.com/health-beauty-spa-gifts.html",
    "https://www.costco.com/vitamins-herbals-dietary-supplements.html",
    "https://www.costco.com/dietary-supplements.html",
    "https://www.costco.com/energy.html",
    "https://www.costco.com/seasonal.html",
    "https://www.costco.com/seasonal-holiday-christmas.html",
    "https://www.costco.com/halloween.html",
    "https://www.costco.com/halloween-candy.html",
    "https://www.costco.com/halloween-decorations.html",
    "https://www.costco.com/party-supplies.html",
    "https://www.costco.com/carpet-hardwood-laminate-flooring.html",
    "https://www.costco.com/garage-doors.html",
    "https://www.costco.com/generac-home-standby-generators.html",
    "https://www.costco.com/standby-generators.html",
    "https://www.costco.com/bath.html",
    "https://www.costco.com/bathroom-accessories.html",
    "https://www.costco.com/hardware-bathroom.html",
    "https://www.costco.com/bakeware-cookware.html",
    "https://www.costco.com/bakeware.html",
    "https://www.costco.com/cookware.html",
    "https://www.costco.com/lighting-lamps.html",
    "https://www.costco.com/storage-organization-kitchen.html",
    "https://www.costco.com/kitchen-cabinet-pantry-organizers.html",
    "https://www.costco.com/kitchen-tools.html",
    "https://www.costco.com/sewing-garment-care.html",
    "https://www.costco.com/garment-care.html",
    "https://www.costco.com/dinnerware.html",
    "https://www.costco.com/hardware.html",
    "https://www.costco.com/fire-safety.html",
    "https://www.costco.com/flooring.html",
    "https://www.costco.com/engineered-wood-flooring.html",
    "https://www.costco.com/flooring-accessories.html",
    "https://www.costco.com/installed-flooring.html",
    "https://www.costco.com/garage.html",
    "https://www.costco.com/garage-storage-organization.html",
    "https://www.costco.com/generators.html",
    "https://www.costco.com/hardware-kitchen.html",
    "https://www.costco.com/lighting.html",
    "https://www.costco.com/outdoor-lighting.html",
    "https://www.costco.com/lighting-vanity-lighting.html",
    "https://www.costco.com/storage-organization.html",
    "https://www.costco.com/storage-organization-laundry.html",
    "https://www.costco.com/tools.html",
    "https://www.costco.com/tools-ladders-stools-accessories.html",
    "https://www.costco.com/power-tools.html",
    "https://www.costco.com/bracelets.html",
    "https://www.costco.com/diamond-bracelets.html",
    "https://www.costco.com/gold-bracelets.html",
    "https://www.costco.com/pearl-bracelets.html",
    "https://www.costco.com/earrings.html",
    "https://www.costco.com/gemstone-earrings.html",
    "https://www.costco.com/gold-earrings.html",
    "https://www.costco.com/pearl-earrings.html",
    "https://www.costco.com/necklaces.html",
    "https://www.costco.com/diamond-necklaces.html",
    "https://www.costco.com/gemstone-necklaces.html",
    "https://www.costco.com/gold-necklaces.html",
    "https://www.costco.com/pearl-necklaces.html",
    "https://www.costco.com/rings.html",
    "https://www.costco.com/diamond-rings.html",
    "https://www.costco.com/gemstone-rings.html",
    "https://www.costco.com/watches.html",
    "https://www.costco.com/luxury-watches.html",
    "https://www.costco.com/mattresses.html",
    "https://www.costco.com/full-mattresses.html",
    "https://www.costco.com/paper-towels.html",
    "https://www.costco.com/notebooks.html",
    "https://www.costco.com/grills-accessories.html",
    "https://www.costco.com/grills.html",
    "https://www.costco.com/garden-tools.html",
    "https://www.costco.com/tools-pressure-washers.html",
    "https://www.costco.com/bars-barstools.html",
    "https://www.costco.com/pet-grooming-waste-management.html",
    "https://www.costco.com/sports-fitness.html",
    "https://www.costco.com/beach.html",
    "https://www.costco.com/camping-chairs.html",
    "https://www.costco.com/beach-games-toys.html",
    "https://www.costco.com/beach-towels.html",
    "https://www.costco.com/beach-accessories.html",
    "https://www.costco.com/bikes-boards.html",
    "https://www.costco.com/camping.html",
    "https://www.costco.com/camping-accessories.html",
    "https://www.costco.com/camping-cots.html",
    "https://www.costco.com/camping-lanterns.html",
    "https://www.costco.com/hunting-gear.html",
    "https://www.costco.com/sports-fitness-golf.html",
    "https://www.costco.com/outdoor-games-sports-equipment.html",
    "https://www.costco.com/outdoor-games.html",
    "https://www.costco.com/saunas.html",
    "https://www.costco.com/automotive-garage.html",
    "https://www.costco.com/tools-equipment.html",
    "https://www.costco.com/garage-flooring.html",
    "https://www.costco.com/automotive-batteries.html",
    "https://www.costco.com/toys.html",
    "https://www.costco.com/books.html",
    "https://www.costco.com/toys-outdoor-play.html",
    "https://www.costco.com/trading-cards.html",
    "https://www.costco.com/easter.html",
]


DEFAULT_WAREHOUSE_ID = "102"
OUTPUT_CSV_FILE = "warehouse_products.csv"
ITEMS_PER_PAGE = 24


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
    """Traverses GDX API payload to extract valid SKUs, titles, and URLs."""
    new_items = []
    total_count = None

    if not isinstance(data, (dict, list)):
        return new_items, total_count

    def find_total_count(obj):
        nonlocal total_count
        if isinstance(obj, dict):
            for tc_key in ["totalCount", "totalNumRecs", "totalResults", "totalRecords", "recordCount"]:
                if tc_key in obj and isinstance(obj[tc_key], int) and obj[tc_key] > 0:
                    total_count = obj[tc_key]
                    return
            for v in obj.values():
                if isinstance(v, (dict, list)) and total_count is None:
                    find_total_count(v)

    find_total_count(data)

    def collect_product_dicts(obj, depth=0):
        if depth > 7:
            return []
        found_products = []

        if isinstance(obj, dict):
            keys_lower = [str(k).lower() for k in obj.keys()]
            has_id = any(k in keys_lower for k in ["sku", "itemnumber", "item_number", "id", "partnumber"])
            has_title_like = any(k in keys_lower for k in ["productname", "title", "name", "description", "itemtitle"])

            if has_id and has_title_like:
                found_products.append(obj)

            for v in obj.values():
                if isinstance(v, (dict, list)):
                    found_products.extend(collect_product_dicts(v, depth + 1))

        elif isinstance(obj, list):
            for elem in obj:
                if isinstance(elem, (dict, list)):
                    found_products.extend(collect_product_dicts(elem, depth + 1))

        return found_products

    candidate_records = collect_product_dicts(data)

    for item in candidate_records:
        if not isinstance(item, dict):
            continue

        raw_sku = str(
            item.get("itemNumber")
            or item.get("sku")
            or item.get("id")
            or item.get("partNumber")
            or ""
        ).strip()

        sku = raw_sku.split("/")[-1] if "/" in raw_sku else raw_sku

        raw_title = (
            item.get("productName")
            or item.get("title")
            or item.get("name")
            or item.get("description")
            or ""
        )

        if isinstance(raw_title, str) and raw_title.startswith("projects/"):
            title_obj = item.get("title") or item.get("productName")
            title = title_obj.get("value") or title_obj.get("text") or "" if isinstance(title_obj, dict) else ""
        else:
            title = str(raw_title)

        url = item.get("pdpUrl") or item.get("productUrl") or item.get("url") or ""
        if isinstance(url, str) and url.startswith("http"):
            product_url = url
        elif isinstance(url, str) and url:
            product_url = f"https://www.costco.com{url}"
        elif sku:
            product_url = f"https://www.costco.com/.product.{sku}.html"
        else:
            product_url = "N/A"

        if sku and title and not title.startswith("projects/"):
            new_items.append({
                "sku": sku,
                "title": title,
                "url": product_url
            })

    return new_items, total_count


async def extract_items_from_dom(page):
    """Broad DOM Fallback: Finds product links and extracts SKU and title directly."""
    return await page.evaluate("""
        () => {
            const items = [];
            const links = Array.from(document.querySelectorAll('a[href*=".product."], a[href*="/p/"]'));
            
            links.forEach(link => {
                const url = link.href;
                const skuMatch = url.match(/\\.product\\.(\\d+)\\.html/) || url.match(/\\/(\\d{5,9})(?:\\?|$)/);
                if (skuMatch) {
                    const sku = skuMatch[1];
                    const title = link.innerText.trim() || link.getAttribute('aria-label') || 'Costco Product';
                    if (sku && title.length > 3) {
                        items.push({ sku, title: title.replace(/\\n/g, ' '), url });
                    }
                }
            });
            return items;
        }
    """)


async def main():
    seen_skus = set()

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
        await page.goto("https://www.costco.com/s?keyword=cleaning")

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
            writer.writerow(["sku", "product_name", "warehouse_id", "category_url", "product_url"])

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
                    url = response.url.lower()

                    if "gdx-api.costco.com/catalog/search" in url and response.status == 200:
                        try:
                            content_type = response.headers.get("content-type", "")
                            if "json" in content_type:
                                data = await response.json()
                                extracted, total_count = extract_items_and_meta(data)

                                if total_count and max_pages is None:
                                    max_pages = math.ceil(total_count / ITEMS_PER_PAGE)
                                    print(f"      [+] API metadata: {total_count} total items (~{max_pages} pages).")

                                new_count = 0
                                for item in extracted:
                                    identifier = item["sku"] if item["sku"] else item["title"]
                                    if identifier and identifier not in seen_skus:
                                        seen_skus.add(identifier)
                                        writer.writerow([
    item["sku"],
    item["title"],
    active_warehouse_id,
    keyword,  # <--- Records the active category URL
    item["url"]
])
                                        new_count += 1

                                if new_count > 0:
                                    print(f"      [GDX API Intercept] Captured {new_count} new items (Total saved: {len(seen_skus)})")
                        except Exception:
                            pass

                response_listener = page.on("response", handle_response)

                while True:
                    target_url = (
                        f"{keyword}"
                        f"?refinement=buyInWarehouse%3Dtrue&currentPage={current_page}"
                    )

                    page_label = f"Page {current_page}" + (f"/{max_pages}" if max_pages else "")
                    print(f"\n[{page_label}] Navigating: {target_url}")

                    skus_before = len(seen_skus)

                    try:
                        # Full load wait to let client-side JS complete requests
                        await page.goto(target_url, wait_until="load", timeout=45000)
                        await asyncio.sleep(2.5)
                        await page.evaluate("window.scrollTo(0, document.body.scrollHeight / 2);")
                        await asyncio.sleep(1.0)

                    except Exception as e:
                        print(f"  [!] Navigation error on {page_label}: {e}")

                    new_items_on_page = len(seen_skus) - skus_before

                    # If API didn't catch anything, run DOM link extraction
                    if new_items_on_page == 0:
                        dom_items = await extract_items_from_dom(page)
                        dom_added = 0
                        for item in dom_items:
                            if item["sku"] not in seen_skus:
                                seen_skus.add(item["sku"])
                                writer.writerow([
    item["sku"],
    item["title"],
    active_warehouse_id,
    keyword,  # <--- Records the active category URL
    item["url"]
])
                                dom_added += 1

                        if dom_added > 0:
                            print(f"      [DOM Fallback] Captured {dom_added} items from HTML.")
                            new_items_on_page = dom_added

                    if new_items_on_page == 0:
                        consecutive_empty_pages += 1
                        if consecutive_empty_pages >= 2:
                            print(f"  [+] No new SKUs captured on 2 consecutive pages. Moving to next category.")
                            break
                    else:
                        consecutive_empty_pages = 0

                    if max_pages and current_page >= max_pages:
                        print(f"  [+] Reached target maximum page ({max_pages}). Moving to next category.")
                        break

                    current_page += 1
                    await asyncio.sleep(random.uniform(1.5, 2.5))

                # Remove using the exact function object passed to .on()
                page.remove_listener("response", handle_response)

        await context.close()

    print("\n" + "=" * 60)
    print(f"Scraping Complete! Captured {len(seen_skus)} total unique warehouse SKUs for Warehouse ID {active_warehouse_id}.")
    print(f"Data saved to: {OUTPUT_CSV_FILE}")
    print("=" * 60)


if __name__ == "__main__":
    asyncio.run(main())