import asyncio
import csv
import re
from playwright.async_api import async_playwright

MISSING_FILE = "missing_1017_items.csv"
OUTPUT_RECOVERY = "direct_item_recoveries.csv"


def load_missing_items():
    items = []
    with open(MISSING_FILE, mode="r", encoding="utf-8-sig") as f:
        reader = csv.DictReader(f)
        for row in reader:
            raw_item = row.get("item_number", "").strip()
            raw_sku = row.get("sku", "").strip()

            clean_item = re.sub(r"\D", "", raw_item)
            clean_sku = re.sub(r"\D", "", raw_sku)

            # Use whichever numeric string exists as the search query key
            lookup_id = clean_item or clean_sku
            if lookup_id:
                items.append((lookup_id, row))
    return items


async def main():
    missing_items = load_missing_items()
    print(f"[+] Loaded {len(missing_items)} missing items for direct verification.")

    recovered_rows = []
    seen_keys = set()

    async with async_playwright() as p:
        browser = await p.chromium.launch(headless=False)
        context = await browser.new_context(
            user_agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
        )
        page = await context.new_page()

        for idx, (lookup_id, original_row) in enumerate(missing_items, start=1):
            target_url = f"https://www.costco.com/CatalogSearch?keyword={lookup_id}&refinement=buyInWarehouse%3Dtrue"
            print(f"[{idx}/{len(missing_items)}] Direct lookup for ID #{lookup_id}...")

            try:
                await page.goto(target_url, wait_until="domcontentloaded", timeout=25000)

                # Wait up to 8 seconds for client-side JS to replace "Loading..." in <h1>
                try:
                    await page.wait_for_function(
                        """() => {
                            const h1 = document.querySelector('h1');
                            return h1 && h1.innerText.trim().length > 0 && !h1.innerText.toLowerCase().includes('loading');
                        }""",
                        timeout=8000
                    )
                except Exception:
                    pass

                no_results = await page.get_by_text("No products found").is_visible()
                if no_results:
                    print(f"   -> ID #{lookup_id}: Confirmed Out of Stock / Not Found.")
                    continue

                product_data = await page.evaluate("""() => {
                    const titleEl = document.querySelector('h1[data-title]') || document.querySelector('h1');
                    let title = titleEl ? titleEl.innerText.trim() : '';
                    if (title.toLowerCase() === 'loading') {
                        title = '';
                    }

                    const priceEl = document.querySelector('.price') || document.querySelector('[data-automation-id="productPrice"]');
                    const price = priceEl ? priceEl.innerText.trim() : '';

                    const itemNumEl = document.querySelector('#product-body-item-number') || document.querySelector('.item-number');
                    const itemNum = itemNumEl ? itemNumEl.innerText.replace(/[^0-9]/g, '') : '';

                    return { title, price, itemNum };
                }""")

                title = product_data.get("title", "")
                if title and title.lower() != "loading":
                    recovered_row = dict(original_row)

                    # Update product name
                    recovered_row["product_name"] = title

                    # Optional price update if present in schema
                    if "price" in original_row and product_data.get("price"):
                        recovered_row["price"] = product_data["price"]

                    # Explicitly update item_number ONLY if found in page DOM
                    scraped_item_num = product_data.get("itemNum", "")
                    if "item_number" in recovered_row:
                        recovered_row["item_number"] = scraped_item_num if scraped_item_num else ""

                    # Leave SKU blank unless explicitly present or scraped
                    if "sku" in recovered_row:
                        scraped_sku = product_data.get("sku", "")
                        recovered_row["sku"] = scraped_sku if scraped_sku else ""

                    rec_key = scraped_item_num or lookup_id
                    if rec_key not in seen_keys:
                        seen_keys.add(rec_key)
                        recovered_rows.append(recovered_row)
                        print(f"   -> ID #{lookup_id}: RECOVERED! ({title[:40]}...)")

            except Exception as e:
                print(f"   [!] Error/Timeout on ID #{lookup_id}: {e}")

        await browser.close()

    # Save recovered items
    if recovered_rows:
        fieldnames = list(recovered_rows[0].keys())
        with open(OUTPUT_RECOVERY, mode="w", newline="", encoding="utf-8-sig") as f:
            writer = csv.DictWriter(f, fieldnames=fieldnames, extrasaction="ignore")
            writer.writeheader()
            writer.writerows(recovered_rows)
        print(f"\n[+] SUCCESS! Wrote '{OUTPUT_RECOVERY}' with {len(recovered_rows)} verified items.")
    else:
        print("\n[!] No active items were recovered from this run.")


if __name__ == "__main__":
    asyncio.run(main())