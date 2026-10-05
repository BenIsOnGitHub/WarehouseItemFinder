# sameday_scraper.py
import time
from playwright.sync_api import sync_playwright

def fetch_sameday_item(item_number: str, user_zip: str = "32162") -> dict | None:
    """
    Looks up a raw item number on sameday.costco.com.
    Injects the user's local ZIP code cookie to fetch regional warehouse inventory.
    """
    clean_item = str(item_number).strip()
    direct_url = f"https://sameday.costco.com/store/costco/products/{clean_item}"
    search_url = f"https://sameday.costco.com/store/costco/s?k={clean_item}"

    with sync_playwright() as p:
        browser = p.chromium.launch(
            headless=True,
            args=[
                "--headless=new",
                "--disable-blink-features=AutomationControlled",
                "--no-sandbox",
                "--disable-setuid-sandbox",
                "--window-size=1280,800"
            ]
        )

        context = browser.new_context(
            viewport={"width": 1280, "height": 800},
            user_agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36",
            locale="en-US",
            timezone_id="America/New_York"
        )

        # Inject user's warehouse ZIP cookie into browser context before page load
        context.add_cookies([
            {
                "name": "warehouse_zip",
                "value": user_zip,
                "domain": ".costco.com",
                "path": "/"
            },
            {
                "name": "instacart_async_service_address",
                "value": f"%7B%22postal_code%22%3A%22{user_zip}%22%7D",
                "domain": ".costco.com",
                "path": "/"
            }
        ])

        page = context.new_page()

        # Mask navigator.webdriver signature
        page.add_init_script("""
            Object.defineProperty(navigator, 'webdriver', { get: () => undefined });
            window.chrome = { runtime: {} };
        """)

        try:
            print(f"1. Loading search page for raw item number: {clean_item} (ZIP: {user_zip})...")
            page.goto(search_url, wait_until="domcontentloaded", timeout=25000)
            page.wait_for_timeout(2000)

            # Clear guest gate modal if presented
            guest_btn = page.get_by_role("button", name="Browse as a guest")
            if guest_btn.count() > 0 and guest_btn.is_visible():
                print("2. Clearing guest modal...")
                guest_btn.click()
                page.wait_for_timeout(2500)

            # Handle delivery ZIP prompt if location cookie needs confirmation
            zip_input = page.locator('input[name="postal_code"], input[name="zipcode"], input[placeholder*="zip" i], input[type="text"]').first
            if zip_input.count() > 0 and zip_input.is_visible():
                print(f"3. Confirming ZIP code ({user_zip})...")
                zip_input.fill(user_zip)
                page.keyboard.press("Enter")
                page.wait_for_timeout(2500)

            # Ensure we are on the search query page
            if "s?k=" not in page.url:
                page.goto(search_url, wait_until="domcontentloaded", timeout=20000)
                page.wait_for_timeout(2500)

            print("4. Locating product cards in DOM...")
            page.wait_for_selector('a[href*="/products/"], a[href*="/item/"]', timeout=10000)

            product_links = page.locator('a[href*="/products/"], a[href*="/item/"]').all()
            print(f"5. Found {len(product_links)} candidate product link(s)")

            target_link = None

            # Priority 1: Find a link whose URL path explicitly contains the item SKU
            for link in product_links:
                href = link.get_attribute("href") or ""
                if clean_item in href:
                    target_link = link
                    print(f"   [Exact SKU Match] Found SKU {clean_item} in URL path.")
                    break

            # Priority 2: Fall back to first result if explicit SKU match isn't in URL
            if not target_link and product_links:
                target_link = product_links[0]
                print("   [First Result Match] Using primary search result card.")

            if target_link:
                href = target_link.get_attribute("href") or ""
                full_url = "https://sameday.costco.com" + href if href.startswith("/") else href

                # Extract title
                title = None
                img = target_link.locator("img").first
                if img.count() > 0:
                    title = img.get_attribute("alt")

                if not title:
                    title_el = target_link.locator('h3, h2, span').first
                    if title_el.count() > 0:
                        title = title_el.inner_text().strip()

                if not title or title.lower() in ["departments", "more", ""]:
                    slug = href.split("/")[-1].split("?")[0]
                    slug_text = "-".join(slug.split("-")[1:]) if "-" in slug else slug
                    title = slug_text.replace("-", " ").title()

                browser.close()
                return {
                    "item_number": clean_item,
                    "title": title,
                    "product_url": full_url,
                    "source": "sameday.costco.com",
                    "zip_code": user_zip
                }

        except Exception as e:
            print(f"Error during Sameday scrape: {e}")
        finally:
            browser.close()

    return None


if __name__ == "__main__":
    start = time.time()
    # Test with raw item number only and custom ZIP
    result = fetch_sameday_item("1633654", user_zip="32162")
    elapsed = round(time.time() - start, 2)
    print(f"\nPipeline Output ({elapsed}s):", result)