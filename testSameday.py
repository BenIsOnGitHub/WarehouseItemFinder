from playwright.sync_api import sync_playwright

item_number = "1633654"
target_zip = "32162"  # Use zip extracted from costco.com STORELOCATION cookie

with sync_playwright() as p:
    browser = p.chromium.launch(headless=False, slow_mo=300)
    context = browser.new_context(
        viewport={"width": 1280, "height": 800},
        user_agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
    )
    page = context.new_page()

    print("1. Navigating to Sameday home page...")
    page.goto("https://sameday.costco.com/", wait_until="domcontentloaded")
    page.wait_for_timeout(2000)

    # Establish store session if landing prompt exists
    warehouse_btn = page.locator('text="Costco Warehouse"')
    if warehouse_btn.count() > 0:
        print("Clicking 'Costco Warehouse'...")
        warehouse_btn.first.click()
        page.wait_for_timeout(2000)

    # 2. Check and set Zip Code if location selector/modal exists
    zip_btn = page.locator('button:has-text("ZIP"), button[aria-label*="zip" i], div:has-text("Deliver to")')
    if zip_btn.count() > 0:
        print("Opening location selector...")
        zip_btn.first.click()
        page.wait_for_timeout(1000)
        
        zip_input = page.locator('input[name="zipcode"], input[placeholder*="zip" i], input[type="text"]')
        if zip_input.count() > 0:
            print(f"Entering ZIP code {target_zip}...")
            zip_input.first.fill(target_zip)
            page.keyboard.press("Enter")
            page.wait_for_timeout(2000)

    # 3. Perform search using the search input field
    search_input = page.locator('input[type="search"], input[placeholder*="Search" i], input[aria-label*="Search" i]')
    if search_input.count() > 0:
        print(f"3. Searching for item {item_number} via search box...")
        search_input.first.fill(item_number)
        page.keyboard.press("Enter")
        page.wait_for_timeout(4000)
    else:
        print("Search box not found, navigating via URL fallback...")
        page.goto(f"https://sameday.costco.com/store/costco/s?k={item_number}", wait_until="domcontentloaded")
        page.wait_for_timeout(4000)

    print(f"Current Page URL: {page.url}")

    # 4. Extract product results
    extracted_items = []
    product_links = page.locator('a[href*="/products/"]').all()

    for link in product_links:
        try:
            href = link.get_attribute("href")
            if not href:
                continue

            full_url = "https://sameday.costco.com" + href if href.startswith("/") else href

            # Extract clean product title from image alt attribute or heading inside the link
            title = None
            img = link.locator("img").first
            if img.count() > 0:
                title = img.get_attribute("alt")

            if not title:
                # Fallback to heading / text elements inside or adjacent to the link
                title_el = link.locator('h3, h2, span[aria-hidden="true"]').first
                if title_el.count() > 0:
                    title = title_el.inner_text().strip()

            if not title or title.lower() in ["departments", "more", ""]:
                # Slug fallback from URL (e.g., "pick-d-organic-mango-chunks-5-lb" -> "Pick D Organic Mango Chunks 5 Lb")
                slug = href.split("/products/")[1].split("?")[0]
                slug_text = "-".join(slug.split("-")[1:])  # remove numeric ID
                title = slug_text.replace("-", " ").title()

            if full_url not in [item["url"] for item in extracted_items]:
                extracted_items.append({
                    "title": title,
                    "url": full_url,
                    "item_number": item_number,
                    "source": "costco_sameday"
                })
        except Exception:
            pass

    print(f"\n--- Extracted {len(extracted_items)} Product(s) ---")
    for idx, prod in enumerate(extracted_items):
        print(f"\nResult #{idx + 1}:")
        print(f"  Title:  {prod['title']}")
        print(f"  URL:    {prod['url']}")
        print(f"  Source: {prod['source']}")

    input("\nPress Enter to close browser...")
    browser.close()