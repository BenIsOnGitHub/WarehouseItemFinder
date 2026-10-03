import asyncio
import json
from playwright.async_api import async_playwright

async def inspect_category_page():
    async with async_playwright() as p:
        print("\n[+] Launching Chrome Session...")
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
        await page.goto(url, wait_until="domcontentloaded", timeout=45000)
        await asyncio.sleep(4)

        # Scroll to ensure images/lazy-loaded grid elements hydrate
        await page.evaluate("window.scrollTo(0, document.body.scrollHeight / 3);")
        await asyncio.sleep(2)

        # Extract grid and item structure
        grid_data = await page.evaluate("""
            () => {
                const results = [];
                // Look for all anchor links containing product indicators
                const links = Array.from(document.querySelectorAll('a[href*=".product."], a[href*="/p/"]'));
                
                links.forEach((link, idx) => {
                    const href = link.href;
                    // Ignore header navigation or promo banners if possible
                    if (href.includes('uber') || href.includes('gift-card')) return;

                    const card = link.closest('[data-testid] , [class*="MuiGrid"], [class*="product-tile"], [class*="card"]') || link.parentElement;
                    const cardText = card ? card.innerText.replace(/\\s+/g, ' ').trim() : '';

                    // Check for item number regex patterns anywhere in card text
                    const itemMatch = cardText.match(/Item\\s*#?\\s*(\\d{5,7})/i) || cardText.match(/Art\\.\\s*(\\d{5,7})/i) || cardText.match(/\\b(\\d{5,7})\\b/);

                    results.push({
                        index: idx,
                        title: link.innerText.replace(/\\s+/g, ' ').trim() || 'No title text',
                        href: href,
                        extractedItemNumber: itemMatch ? itemMatch[1] : 'Not Found',
                        snippet: cardText.slice(0, 150)
                    });
                });

                return {
                    totalLinksFound: links.length,
                    products: results
                };
            }
        """)

        print("\n" + "=" * 60)
        print("CATEGORY PAGE DIAGNOSTIC:")
        print(json.dumps(grid_data, indent=2))
        print("=" * 60 + "\n")

        await context.close()

if __name__ == "__main__":
    asyncio.run(inspect_category_page())