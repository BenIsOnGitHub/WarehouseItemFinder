import asyncio
import json
from playwright.async_api import async_playwright

async def inspect_full_page():
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

        # Step 1: Navigate to home page first to bypass bot triggers
        print("[+] Navigating to Costco Home Page...")
        await page.goto("https://www.costco.com", wait_until="domcontentloaded", timeout=45000)
        await asyncio.sleep(3)

        print("\n" + "=" * 60)
        print("ACTION REQUIRED IN BROWSER WINDOW:")
        print("1. Set your warehouse / delivery location if needed.")
        print("2. Type 'refrigerator' in the Costco search bar and hit Enter.")
        print("3. Check 'In-Warehouse' filter on the left if available.")
        print("4. Return here and press ENTER when search results are visible.")
        print("=" * 60 + "\n")

        input("Press ENTER once search results are loaded in Chrome...")

        # Take screenshot of what Chrome sees
        await page.screenshot(path="page_snapshot.png", full_page=True)
        print("[+] Saved page screenshot to 'page_snapshot.png'")

        # Dump DOM elements & product link structures
        inspection = await page.evaluate("""
            () => {
                const links = Array.from(document.querySelectorAll('a[href*="/p/"], a[href*="/product"], a[href*=".product."]'));
                const h3s = Array.from(document.querySelectorAll('h3, h2, [class*="title"], [class*="Title"]'));
                
                const sampleLinks = links.slice(0, 5).map(a => ({
                    text: a.innerText.replace(/\\s+/g, ' ').trim(),
                    href: a.href,
                    parentText: a.parentElement ? a.parentElement.innerText.replace(/\\s+/g, ' | ').trim().slice(0, 150) : ''
                }));

                const sampleHeaders = h3s.slice(0, 5).map(h => h.innerText.replace(/\\s+/g, ' ').trim());

                return {
                    pageTitle: document.title,
                    totalProductLinks: links.length,
                    sampleLinks: sampleLinks,
                    sampleHeaders: sampleHeaders
                };
            }
        """)

        print("\n" + "=" * 60)
        print("PAGE INSPECTION RESULTS:")
        print(json.dumps(inspection, indent=2))
        print("=" * 60 + "\n")

        await context.close()

if __name__ == "__main__":
    asyncio.run(inspect_full_page())