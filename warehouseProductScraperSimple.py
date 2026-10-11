import asyncio
import csv
import json
import random
import re
import urllib.parse
import uuid
from datetime import datetime, timezone
from playwright.async_api import async_playwright

CATEGORY_KEYWORDS = [
   "https://www.costco.com/acid-relief.html",
  "https://www.costco.com/adult-multi-letter-vitamins.html",
  "https://www.costco.com/aids-for-independent-living.html",
  "https://www.costco.com/air-fryers.html",
  "https://www.costco.com/allergy-sinus.html",
  "https://www.costco.com/appliances.html",
  "https://www.costco.com/babies-clothing.html",
  "https://www.costco.com/backpacks-bags.html",
  "https://www.costco.com/bakeware-cookware.html",
  "https://www.costco.com/baking.html",
  "https://www.costco.com/bath-body.html",
  "https://www.costco.com/beans-grains-rice.html",
  "https://www.costco.com/beauty-tools-accessories.html",
  "https://www.costco.com/beverages.html",
  "https://www.costco.com/blenders-juicers.html",
  "https://www.costco.com/bottled-water.html",
  "https://www.costco.com/breakfast.html",
  "https://www.costco.com/butter.html",
  "https://www.costco.com/buy-in-bulk.html",
  "https://www.costco.com/ca-social-compliance.html",
  "https://www.costco.com/cakes-cookies.html",
  "https://www.costco.com/candy.html",
  "https://www.costco.com/canned-goods.html",
  "https://www.costco.com/character-clothing.html",
  "https://www.costco.com/charitable-giving.html",
  "https://www.costco.com/cheese.html",
  "https://www.costco.com/chips-pretzels.html",
  "https://www.costco.com/chocolates.html",
  "https://www.costco.com/chromebooks.html",
  "https://www.costco.com/cleaning-supplies.html",
  "https://www.costco.com/coffee-espresso-makers.html",
  "https://www.costco.com/coffee-sweeteners.html",
  "https://www.costco.com/college-apparel.html",
  "https://www.costco.com/concierge.html",
  "https://www.costco.com/condiments-sauces.html",
  "https://www.costco.com/confidential-ethics-hotline-for-suppliers.html",
  "https://www.costco.com/consumer-health-data-privacy-policy.html",
  "https://www.costco.com/cookies.html",
  "https://www.costco.com/cosmetics.html",
  "https://www.costco.com/costco-app.html",
  "https://www.costco.com/costco-grocery-faq.html",
  "https://www.costco.com/cough-cold.html",
  "https://www.costco.com/countertop-microwaves.html",
  "https://www.costco.com/covid-test.html",
  "https://www.costco.com/crackers.html",
  "https://www.costco.com/deli-meats.html",
  "https://www.costco.com/deli.html",
  "https://www.costco.com/desktops-servers.html",
  "https://www.costco.com/diapers-wipes.html",
  "https://www.costco.com/diet-nutrition.html",
  "https://www.costco.com/dietary-supplements.html",
  "https://www.costco.com/dips-spreads.html",
  "https://www.costco.com/disclosure-regarding-human-trafficking-and-anti-slavery.html",
  "https://www.costco.com/dish-detergent.html",
  "https://www.costco.com/dresswear.html",
  "https://www.costco.com/dried-fruit.html",
  "https://www.costco.com/drink-mix.html",
  "https://www.costco.com/electric-grills-griddles.html",
  "https://www.costco.com/electronics.html",
  "https://www.costco.com/email-sign-up.html",
  "https://www.costco.com/employee-website.html",
  "https://www.costco.com/energy-drinks.html",
  "https://www.costco.com/espresso-machines.html",
  "https://www.costco.com/executive-rewards.html",
  "https://www.costco.com/eye-care.html",
  "https://www.costco.com/featured-brands.html",
  "https://www.costco.com/floor-bathroom-cleaners.html",
  "https://www.costco.com/food-preparation-and-preservation.html",
  "https://www.costco.com/food-processors-mixers.html",
  "https://www.costco.com/formula-feeding.html",
  "https://www.costco.com/frozen-treat-ice-cream-makers.html",
  "https://www.costco.com/fruit-snacks-applesauce.html",
  "https://www.costco.com/furniture.html",
  "https://www.costco.com/gaming-laptops.html",
  "https://www.costco.com/gasoline.html",
  "https://www.costco.com/gift-baskets.html",
  "https://www.costco.com/glucosamine-joint-supplements.html",
  "https://www.costco.com/gopaperless.html",
  "https://www.costco.com/grocery-health-beauty.html",
  "https://www.costco.com/grocery-household.html",
  "https://www.costco.com/grocery-program-faq.html",
  "https://www.costco.com/gum-mints.html",
  "https://www.costco.com/hair-care.html",
  "https://www.costco.com/handbags-wallets.html",
  "https://www.costco.com/hard-drives-memory.html",
  "https://www.costco.com/hard-gummy-candy.html",
  "https://www.costco.com/hardware-kitchen.html",
  "https://www.costco.com/hardware.html",
  "https://www.costco.com/headphones.html",
  "https://www.costco.com/health-beauty-spa-gifts.html",
  "https://www.costco.com/health-beauty.html",
  "https://www.costco.com/healthy-snacks.html",
  "https://www.costco.com/hearing-aid-center.html",
  "https://www.costco.com/hearing-care-products.html",
  "https://www.costco.com/holiday-clothing.html",
  "https://www.costco.com/home-health-care-first-aid.html",
  "https://www.costco.com/home-health-care.html",
  "https://www.costco.com/honey.html",
  "https://www.costco.com/hot-dogs-bacon-sausage.html",
  "https://www.costco.com/household-cleaning.html",
  "https://www.costco.com/household.html",
  "https://www.costco.com/hydration.html",
  "https://www.costco.com/ice-makers.html",
  "https://www.costco.com/immune-support.html",
  "https://www.costco.com/immunizations.html",
  "https://www.costco.com/janitorial-supplies.html",
  "https://www.costco.com/jerky.html",
  "https://www.costco.com/jobs.html",
  "https://www.costco.com/join-costco.html",
  "https://www.costco.com/juice.html",
  "https://www.costco.com/kettles.html",
  "https://www.costco.com/kids-clothing.html",
  "https://www.costco.com/kirkland-signature-groceries.html",
  "https://www.costco.com/kitchen-dining.html",
  "https://www.costco.com/laundry-supplies.html",
  "https://www.costco.com/luggage.html",
  "https://www.costco.com/macbooks.html",
  "https://www.costco.com/massage-relaxation.html",
  "https://www.costco.com/mattresses.html",
  "https://www.costco.com/member-privileges-conditions.html",
  "https://www.costco.com/membership-information.html",
  "https://www.costco.com/mens-clothing.html",
  "https://www.costco.com/microsoft-surface-laptops.html",
  "https://www.costco.com/microwaves.html",
  "https://www.costco.com/milk.html",
  "https://www.costco.com/moisturizers.html",
  "https://www.costco.com/new-locations.html",
  "https://www.costco.com/non-prescription-remedies.html",
  "https://www.costco.com/nuts.html",
  "https://www.costco.com/oils-balsamic.html",
  "https://www.costco.com/optical.html",
  "https://www.costco.com/organic-groceries.html",
  "https://www.costco.com/ovens-toasters.html",
  "https://www.costco.com/pain-fever.html",
  "https://www.costco.com/pantry.html",
  "https://www.costco.com/paper-products-food-storage.html",
  "https://www.costco.com/pastries.html",
  "https://www.costco.com/patio-lawn-garden.html",
  "https://www.costco.com/pc-laptops.html",
  "https://www.costco.com/personal-care.html",
  "https://www.costco.com/pet-supplies.html",
  "https://www.costco.com/photo.html",
  "https://www.costco.com/popcorn.html",
  "https://www.costco.com/premium-cleansers.html",
  "https://www.costco.com/prepared-food-soups-salads.html",
  "https://www.costco.com/prepared-food.html",
  "https://www.costco.com/pressure-slow-cookers.html",
  "https://www.costco.com/privacy-policy.html",
  "https://www.costco.com/prosciutto-smoked-cured-meats.html",
  "https://www.costco.com/protein.html",
  "https://www.costco.com/quick-and-easy-recipe-videos.html",
  "https://www.costco.com/reading-glasses.html",
  "https://www.costco.com/rebates.html",
  "https://www.costco.com/recalls.html",
  "https://www.costco.com/recommendations.html",
  "https://www.costco.com/rice-cookers.html",
  "https://www.costco.com/routers-networking.html",
  "https://www.costco.com/serums-skin-treatments.html",
  "https://www.costco.com/serveware.html",
  "https://www.costco.com/services.html",
  "https://www.costco.com/shoes.html",
  "https://www.costco.com/snacks-bars.html",
  "https://www.costco.com/snacks.html",
  "https://www.costco.com/soft-drinks.html",
  "https://www.costco.com/soup.html",
  "https://www.costco.com/special-events.html",
  "https://www.costco.com/specialty-kitchen-appliances.html",
  "https://www.costco.com/spices-seasonings.html",
  "https://www.costco.com/sports-fitness.html",
  "https://www.costco.com/spreads.html",
  "https://www.costco.com/sugar-sweeteners.html",
  "https://www.costco.com/sun-care.html",
  "https://www.costco.com/sunglasses.html",
  "https://www.costco.com/sustainability-introduction.html",
  "https://www.costco.com/tablet-computers-accessories.html",
  "https://www.costco.com/tea.html",
  "https://www.costco.com/terms-and-conditions-of-use.html",
  "https://www.costco.com/trail-snack-mix.html",
  "https://www.costco.com/trash-bags.html",
  "https://www.costco.com/upgrade-membership.html",
  "https://www.costco.com/vacuum-sealers.html",
  "https://www.costco.com/vacuums-floor-care.html",
  "https://www.costco.com/vendor-inquiries.html",
  "https://www.costco.com/vitamins-herbals-dietary-supplements.html",
  "https://www.costco.com/water-dispensers-filtration-water-coolers-dispensers.html",
  "https://www.costco.com/wearable-technology.html",
  "https://www.costco.com/windows-copilot-pcs.html",
  "https://www.costco.com/wine.html",
  "https://www.costco.com/womens-clothing.html",
  "https://www.costco.com/yogurt.html",
  "https://www.costco.com/youth-clothing.html"
]


OUTPUT_CSV_FILE = "warehouse_products.csv"
NAMESPACE_COSTCO = uuid.UUID('6ba7b810-9dad-11d1-80b4-00c04fd430c8')


def clean_product_name(title: str) -> str:
    if not title:
        return ""
    return " ".join(title.strip().split()).lower()


def generate_uuid(warehouse_id: str, product_name: str) -> str:
    clean_title = clean_product_name(product_name)
    seed = f"{warehouse_id}:{clean_title}"
    return str(uuid.uuid5(NAMESPACE_COSTCO, seed))


def extract_category_name(category_url: str, product_entry: dict = None) -> str:
    """Extracts human-readable category string from product metadata or URL slug."""
    if product_entry and isinstance(product_entry, dict):
        product = product_entry.get("product", {})
        
        # 1. Check GRS Breadcrumb List
        breadcrumbs = product.get("breadcrumbs") or product_entry.get("breadcrumbs", [])
        if isinstance(breadcrumbs, list) and breadcrumbs:
            crumbs = [
                b.get("name") if isinstance(b, dict) else str(b)
                for b in breadcrumbs if b
            ]
            crumbs = [c.strip() for c in crumbs if c and c.lower() not in ["home", "costco"]]
            if crumbs:
                return " > ".join(crumbs)

        # 2. Check Product Categories / Taxonomy attributes
        attributes = product.get("attributes", {})
        for cat_key in ["category", "category_name", "department", "department_name"]:
            if cat_key in attributes:
                val = attributes[cat_key].get("text", [None])[0] or attributes[cat_key].get("value")
                if val:
                    return str(val).strip()

    # 3. Fallback: Parse URL Slug (e.g. 'frozen-treat-ice-cream-makers.html' -> 'Frozen Treat Ice Cream Makers')
    if category_url:
        path = urllib.parse.urlparse(category_url).path.rstrip('/')
        slug = path.split('/')[-1].replace('.html', '')
        words = [w.capitalize() for w in slug.split('-') if w]
        if words:
            return " ".join(words)

    return "Uncategorized"


def extract_warehouse_products(data, active_warehouse_id, category_url):
    """Parses Costco GRS API payload using active warehouse ID."""
    items = []
    if not isinstance(data, dict):
        return items

    search_result = data.get("searchResult", {})
    results = search_result.get("results", [])

    for entry in results:
        if not isinstance(entry, dict):
            continue

        product = entry.get("product", {})
        if not isinstance(product, dict):
            continue

        attributes = product.get("attributes", {})

        pills = attributes.get("pills", {}).get("text", [])
        if "Online Only" in pills:
            continue

        rollup = entry.get("variantRollupValues", {})
        has_warehouse_inventory = any(
            f"inventory({active_warehouse_id}" in key for key in rollup.keys()
        )

        if not has_warehouse_inventory:
            continue

        title = str(product.get("title") or "").strip()

        raw_id = str(entry.get("id") or "").strip()
        product_id = ""
        item_number = ""

        # Any ID longer than 7 digits or > 9,999,999 is classified as product_id
        if raw_id and (len(raw_id) > 7 or (raw_id.isdigit() and int(raw_id) > 9999999)):
            product_id = raw_id
        else:
            item_number = raw_id

        prod_id = str(product.get("id") or "").strip()
        if prod_id:
            if len(prod_id) > 7 or (prod_id.isdigit() and int(prod_id) > 9999999):
                if not product_id:
                    product_id = prod_id
            elif not item_number:
                item_number = prod_id

        if not item_number and "variantId" in rollup:
            var_ids = rollup.get("variantId", [])
            if var_ids and isinstance(var_ids, list):
                val = str(var_ids[0]).strip()
                if len(val) <= 7 and val.isdigit() and int(val) <= 9999999:
                    item_number = val

        if not item_number and "uri" in product:
            uri_parts = str(product.get("uri", "")).rstrip("/").split("/")
            if uri_parts[-1].isdigit() and len(uri_parts[-1]) <= 7:
                item_number = uri_parts[-1]

        if not item_number:
            primary_img = attributes.get("primary_image", {}).get("text", [""])[0]
            if primary_img:
                img_match = re.search(r'/as/(?<!\d)(\d{3,7})-[^/]+$', primary_img)
                if img_match:
                    item_number = img_match.group(1)

        if not item_number:
            for attr_key in ["itemNumber", "item_number", "costcoItemNumber", "itemNo"]:
                if attr_key in attributes:
                    val = attributes[attr_key].get("text", [None])[0] or attributes[attr_key].get("value")
                    if val and str(val).isdigit() and len(str(val)) <= 7:
                        item_number = str(val).strip()
                        break

        category = extract_category_name(category_url, entry)

        if title:
            product_url = f"https://www.costco.com/p/-/{item_number}" if item_number else product.get("uri", "")
            items.append({
                "item_number": item_number,
                "product_id": product_id,
                "title": title,
                "url": product_url,
                "category": category,
                "category_url": category_url
            })

    return items


async def extract_warehouse_id_from_cookie(context) -> str:
    """Parses WAREHOUSEDELIVERY_WHS cookie for nearestWarehouse catalog ID."""
    cookies = await context.cookies()
    for cookie in cookies:
        if cookie["name"] == "WAREHOUSEDELIVERY_WHS":
            raw_val = cookie["value"]
            decoded_val = urllib.parse.unquote(raw_val)

            try:
                data = json.loads(decoded_val)
                catalog_val = data.get("nearestWarehouse", {}).get("catalog", "")
                if catalog_val:
                    wh_id = catalog_val.split("-")[0].strip()
                    if wh_id:
                        return wh_id
            except Exception:
                match = re.search(r'"nearestWarehouse"\s*:\s*\{[^}]*"catalog"\s*:\s*"(\d+)-wh"', decoded_val)
                if match:
                    return match.group(1)

    return None


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

        pages = context.pages
        page = pages[0] if pages else await context.new_page()

        intercepted_responses = []

        async def handle_response(response):
            try:
                if response.status == 200 and "json" in response.headers.get("content-type", ""):
                    data = await response.json()
                    if isinstance(data, dict) and ("searchResult" in data or data.get("searchResultProvider") == "GRS"):
                        intercepted_responses.append(data)
            except Exception:
                pass

        page.on("response", handle_response)

        first_category = CATEGORY_KEYWORDS[0]
        await page.goto(first_category, wait_until="domcontentloaded")

        print("\n" + "=" * 60)
        print("ACTION REQUIRED IN BROWSER WINDOW:")
        print("1. Confirm warehouse location in header.")
        print("2. Confirm 'In-Warehouse' filter is set on the page.")
        print("3. Return to this terminal and press ENTER when finished.")
        print("=" * 60 + "\n")

        input("Press ENTER after setting location & filter in Chrome...")

        active_warehouse_id = await extract_warehouse_id_from_cookie(context)

        if not active_warehouse_id:
            print("\n[!] ERROR: Could not parse nearestWarehouse catalog ID from 'WAREHOUSEDELIVERY_WHS' cookie.")
            await context.close()
            return

        print(f"[+] Active warehouse ID detected: {active_warehouse_id}")
        print(f"[+] Scraping strictly with Warehouse ID: {active_warehouse_id}\n")

        with open(OUTPUT_CSV_FILE, mode="w", newline="", encoding="utf-8") as csv_file:
            writer = csv.writer(csv_file)
            writer.writerow([
                "id", "warehouse_id", "product_id", "item_number", "product_name",
                "category", "category_url", "product_url", "aisle", "bay", 
                "is_wrong", "is_discontinued", "updated_at"
            ])
            csv_file.flush()

            for keyword in CATEGORY_KEYWORDS:
                current_category_url = keyword
                print(f"\n" + "=" * 60)
                print(f"Starting Category: {keyword.upper()}")
                print("=" * 60)

                current_page = 1
                MAX_SAFETY_PAGES = 5

                while current_page <= MAX_SAFETY_PAGES:
                    target_url = f"{keyword}?refinement=buyInWarehouse%3Dtrue&currentPage={current_page}"
                    print(f"\n[Page {current_page}] Navigating: {target_url}")

                    intercepted_responses.clear()

                    try:
                        await page.bring_to_front()
                        await page.goto(target_url, wait_until="domcontentloaded", timeout=30000)

                        await asyncio.sleep(1.5)
                        await page.evaluate("""() => {
                            window.focus();
                            window.scrollTo(0, document.body.scrollHeight / 2);
                        }""")
                        await asyncio.sleep(1.5)
                        await page.evaluate("""() => {
                            window.scrollTo(0, document.body.scrollHeight);
                        }""")
                        await asyncio.sleep(2.0)

                    except Exception as e:
                        print(f"  [!] Navigation warning: {e}")

                    added_count = 0
                    scrape_time = datetime.now(timezone.utc).isoformat()

                    for data in intercepted_responses:
                        extracted = extract_warehouse_products(data, active_warehouse_id, current_category_url)

                        for item in extracted:
                            title_key = clean_product_name(item["title"])
                            dedup_key = f"{active_warehouse_id}:{title_key}"

                            if dedup_key not in seen_identifiers:
                                seen_identifiers.add(dedup_key)
                                record_id = generate_uuid(active_warehouse_id, item["title"])

                                writer.writerow([
                                    record_id, active_warehouse_id, item["product_id"], item["item_number"],
                                    item["title"], item["category"], item["category_url"], item["url"], 
                                    "", "", 0, 0, scrape_time
                                ])
                                csv_file.flush()
                                added_count += 1

                    if added_count > 0:
                        print(f"      [GRS API Capture] Saved {added_count} products (Total recorded: {len(seen_identifiers)}).")

                    current_page += 1
                    await asyncio.sleep(random.uniform(1.5, 2.5))

        await context.close()


if __name__ == "__main__":
    asyncio.run(main())