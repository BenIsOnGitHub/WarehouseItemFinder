import asyncio
from playwright.async_api import async_playwright

async def run_probe():
    async with async_playwright() as p:
        context = await p.chromium.launch_persistent_context(
            user_data_dir="./chrome_user_data",
            channel="chrome",
            headless=False,
            args=["--start-maximized"]
        )
        page = await context.new_page()

        # Log ALL outgoing network responses
        page.on("response", lambda res: print(f"[NET] {res.status} | {res.url[:120]}"))

        print("\nNavigating to category page...")
        await page.goto("https://www.costco.com/appliances.html?refinement=buyInWarehouse%3Dtrue&currentPage=1", wait_until="domcontentloaded")
        await asyncio.sleep(5)

        # Inspect DOM elements
        sample_info = await page.evaluate("""
            () => {
                const links = Array.from(document.querySelectorAll('a')).map(a => a.href);
                const productLinks = links.filter(href => href.includes('.product.') || href.includes('/p/'));
                const pageTitle = document.title;
                return {
                    title: pageTitle,
                    totalLinks: links.length,
                    productLinksCount: productLinks.length,
                    sampleProductLinks: productLinks.slice(0, 3)
                };
            }
        """)

        print("\n" + "=" * 60)
        print("DIAGNOSTIC RESULTS:")
        print(f"Page Title: {sample_info['title']}")
        print(f"Total Links Found: {sample_info['totalLinks']}")
        print(f"Product Links Found: {sample_info['productLinksCount']}")
        print(f"Sample Product Links: {sample_info['sampleProductLinks']}")
        print("=" * 60 + "\n")

        await context.close()

if __name__ == "__main__":
    asyncio.run(run_probe())