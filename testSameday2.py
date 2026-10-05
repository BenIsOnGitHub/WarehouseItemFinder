from playwright.sync_api import sync_playwright

url = "https://sameday.costco.com/?next=%2Fstore%2Fcostco%2Fs%3Fk%3D1633654"

with sync_playwright() as p:
    browser = p.chromium.launch(headless=False, slow_mo=300)
    context = browser.new_context(
        viewport={"width": 1280, "height": 800},
        user_agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
    )
    page = context.new_page()

    print(f"Navigating to landing page: {url}")
    page.goto(url, wait_until="domcontentloaded")
    page.wait_for_timeout(3000)

    # Print all interactive buttons and links on the landing page
    print("\n--- Buttons on Landing Screen ---")
    buttons = page.locator('button, a[role="button"], a').all()
    for idx, b in enumerate(buttons):
        try:
            txt = b.inner_text().strip().replace('\n', ' ')
            if txt:
                print(f"[{idx}] Text: '{txt}'")
        except Exception:
            pass

    page.screenshot(path="landing_screen.png")
    print("\nSaved screenshot as landing_screen.png")

    input("\nPress Enter in console to close browser...")
    browser.close()