import asyncio
import json
from playwright.async_api import async_playwright

async def debug_dom():
    async with async_playwright() as p:
        print("\n[+] Launching Chrome Session for Debugging...")
        context = await p.chromium.launch_persistent_context(
            user_data_dir="./chrome_user_data",
            channel="chrome",
            headless=False,
            args=["--disable-blink-features=AutomationControlled", "--start-maximized"],
            viewport={"width": 1440, "height": 900},
        )
        page = await context.new_page()

        url = "https://www.costco.com/fresh-vegetables.html?refinement=buyInWarehouse%3Dtrue"
        print(f"[+] Navigating to: {url}")
        await page.goto(url, wait_until="networkidle", timeout=60000)
        await asyncio.sleep(3)

        # Scroll down to hydrate lazy-loaded grids
        await page.evaluate("window.scrollTo(0, document.body.scrollHeight / 2);")
        await asyncio.sleep(2)

        debug_info = await page.evaluate("""
            () => {
                const allLinks = Array.from(document.querySelectorAll('a'));
                const productLinks = allLinks.filter(a => a.href.includes('/p/') || a.href.includes('.product.') || a.href.includes('/fresh-vegetables'));
                
                return {
                    totalLinksOnPage: allLinks.length,
                    productCandidateLinksCount: productLinks.length,
                    sampleCandidateLinks: productLinks.slice(0, 10).map(a => ({
                        innerText: a.innerText,
                        textContent: a.textContent,
                        href: a.href,
                        parentClasses: a.parentElement ? a.parentElement.className : '',
                        closestTileClass: a.closest('[class*="product"], [class*="card"], [class*="tile"], [data-testid]')?.className || 'None'
                    }))
                };
            }
        """)

        print("\n" + "=" * 60)
        print("DOM DEBUG RESULTS:")
        print(json.dumps(debug_info, indent=2))
        print("=" * 60 + "\n")

        await context.close()

if __name__ == "__main__":
    asyncio.run(debug_dom())