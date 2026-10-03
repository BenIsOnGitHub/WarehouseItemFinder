import asyncio
from playwright.async_api import async_playwright

async def inspect_product_list():
    async with async_playwright() as p:
        context = await p.chromium.launch_persistent_context(
            user_data_dir="./chrome_user_data",
            channel="chrome",
            headless=False,
            args=["--start-maximized"],
        )
        page = await context.new_page()

        target_url = "https://www.costco.com/s?keyword=refrigerator&refinement=buyInWarehouse%3Dtrue"
        print(f"Navigating to: {target_url}")
        await page.goto(target_url, wait_until="domcontentloaded")
        await asyncio.sleep(4)

        # Scroll to load tiles into viewport
        await page.evaluate("window.scrollTo(0, 800);")
        await asyncio.sleep(2)

        cards_data = await page.evaluate("""
            () => {
                const results = [];
                // Target the product list container specifically
                const listContainer = document.querySelector('#productList, [data-testid="productList"]');
                if (!listContainer) return { error: "productList container not found in DOM" };

                // Grab all product links inside the container
                const links = Array.from(listContainer.querySelectorAll('a[href*="/p/"], a[href*="/product"]'));
                
                // Group by tile container or sample the first 5 unique product cards
                const tiles = Array.from(listContainer.children);

                links.slice(0, 5).forEach((link, idx) => {
                    const card = link.closest('[class*="MuiGrid"], [class*="Card"], [data-testid]') || link.parentElement;
                    results.push({
                        index: idx,
                        href: link.href,
                        linkText: link.innerText.replace(/\\s+/g, ' ').trim(),
                        cardText: card ? card.innerText.replace(/\\s+/g, ' | ').trim() : '',
                        cardHTML: card ? card.outerHTML.slice(0, 400) : ''
                    });
                });

                return { totalLinksFound: links.length, samples: results };
            }
        """)

        print("\n" + "=" * 60)
        print("DIAGNOSTIC RESULTS:")
        print(json.dumps(cards_data, indent=2))
        print("=" * 60 + "\n")

        await context.close()

if __name__ == "__main__":
    import json
    asyncio.run(inspect_product_list())