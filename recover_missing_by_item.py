import asyncio
import csv
import re
from playwright.async_api import async_playwright

MISSING_FILE = "missing_1017_items.csv"
OUTPUT_RECOVERY = "direct_item_recoveries.csv"
FALLBACK_TEXT = "We're sorry. We were not able to find a match."

def classify_number(num_str):
    """Classifies digits: 3-7 digits -> item_number, 8-10 digits -> sku."""
    digits = re.sub(r"\D", "", str(num_str or ""))
    if 3 <= len(digits) <= 7:
        return "item_number", digits
    elif 8 <= len(digits) <= 10:
        return "sku", digits
    return None, ""


def load_missing_items():
    items = []
    with open(MISSING_FILE, mode="r", encoding="utf-8-sig") as f:
        reader = csv.DictReader(f)
        for row in reader:
            raw_item = row.get("item_number", "").strip()
            raw_sku = row.get("sku", "").strip()

            clean_item = re.sub(r"\D", "", raw_item)
            clean_sku = re.sub(r"\D", "", raw_sku)
            url = row.get("product_url", "").strip()
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
            target_url = f"{url}&refinement=buyInWarehouse%3Dtrue"
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

                # Extract title, price, body text, and current URL
                product_data = await page.evaluate("""() => {
                    const titleEl = document.querySelector('h1[data-title]') || document.querySelector('h1');
                    let title = titleEl ? titleEl.innerText.trim() : '';
                    if (title.toLowerCase() === 'loading') {
                        title = '';
                    }

                    const priceEl = document.querySelector('.price') || document.querySelector('[data-automation-id="productPrice"]');
                    const price = priceEl ? priceEl.innerText.trim() : '';

                    const bodyText = document.body ? document.body.innerText : '';

                    return { title, price, bodyText, currentUrl: window.location.href };
                }""")

                title = product_data.get("title", "")
                if title and title.lower() != "loading":
                    recovered_row = dict(original_row)
                    recovered_row["product_name"] = title

                    if "price" in original_row and product_data.get("price"):
                        recovered_row["price"] = product_data["price"]

                    final_item_number = ""
                    final_sku = ""

                    # 1. Preserve original missing_file values if valid
                    orig_item_type, orig_item_val = classify_number(original_row.get("item_number", ""))
                    if orig_item_type == "item_number":
                        final_item_number = orig_item_val
                    elif orig_item_type == "sku":
                        final_sku = orig_item_val

                    orig_sku_type, orig_sku_val = classify_number(original_row.get("sku", ""))
                    if orig_sku_type == "sku" and not final_sku:
                        final_sku = orig_sku_val
                    elif orig_sku_type == "item_number" and not final_item_number:
                        final_item_number = orig_sku_val

                    # 2. Extract explicitly printed "Item <number>" or "Item # <number>" from body text
                    body_text = product_data.get("bodyText", "")
                    item_matches = re.findall(r"Item\s*#?\s*(\d+)", body_text, flags=re.IGNORECASE)
                    for match_num in item_matches:
                        match_type, match_val = classify_number(match_num)
                        if match_type == "item_number" and not final_item_number:
                            final_item_number = match_val
                        elif match_type == "sku" and not final_sku:
                            final_sku = match_val

                    # 3. Fall back to current URL numbers if either field is still missing
                    current_url = product_data.get("currentUrl", target_url)
                    url_numbers = re.findall(r"\d+", current_url)
                    for num_str in url_numbers:
                        url_type, url_val = classify_number(num_str)
                        if url_type == "item_number" and not final_item_number:
                            final_item_number = url_val
                        elif url_type == "sku" and not final_sku:
                            final_sku = url_val

                    # Assign clean outputs
                    if "item_number" in recovered_row:
                        recovered_row["item_number"] = final_item_number
                    if "sku" in recovered_row:
                        recovered_row["sku"] = final_sku

                    rec_key = final_item_number or final_sku or lookup_id
                    if rec_key not in seen_keys:
                        seen_keys.add(rec_key)
                        recovered_rows.append(recovered_row)
                        print(f"   -> ID #{lookup_id}: RECOVERED! Item: '{final_item_number}', SKU: '{final_sku}' ({title[:30]}...)")

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