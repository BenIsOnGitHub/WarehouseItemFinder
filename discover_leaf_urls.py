import asyncio
import csv
import json
from playwright.async_api import async_playwright

# List of broad parent category URLs that dropped items
PARENT_URLS = [
    "https://www.costco.com/kirkland-signature-groceries.html",
    "https://www.costco.com/snacks.html",
    "https://www.costco.com/clothing.html",
    "https://www.costco.com/beverages.html",
    "https://www.costco.com/household-cleaning.html",
    "https://www.costco.com/deli.html",
    "https://www.costco.com/pantry.html",
    "https://www.costco.com/all-costco-grocery.html",
    "https://www.costco.com/health-beauty.html",
    "https://www.costco.com/costco-direct.html",
    "https://www.costco.com/laptops.html",
    "https://www.costco.com/small-kitchen-appliances.html",
    "https://www.costco.com/dairy-eggs-cheese.html",
    "https://www.costco.com/candy.html",
    "https://www.costco.com/skin-care.html"
]

OUTPUT_JSON = "leaf_category_urls.json"

async def main():
    leaf_urls = set()

    async with async_playwright() as p:
        print("[+] Launching Chrome to harvest leaf category links...")
        browser = await p.chromium.launch(headless=False)
        context = await browser.new_context(
            user_agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
        )
        page = await context.new_page()

        for parent_url in PARENT_URLS:
            print(f" -> Inspecting parent: {parent_url}")
            try:
                await page.goto(parent_url, wait_until="domcontentloaded", timeout=25000)
                await asyncio.sleep(2)

                # Extract subcategory links from left nav filters, category tiles, and sub-nav grids
                extracted_links = await page.evaluate("""() => {
                    const links = new Set();
                    
                    // 1. Target subcategory grid cards/tiles
                    document.querySelectorAll('a[href*=".html"]').forEach(a => {
                        const href = a.href.split('?')[0].split('#')[0];
                        if (href.startsWith('https://www.costco.com/') && 
                            !href.includes('/p/') && 
                            !href.includes('Logon') && 
                            !href.includes('Help') &&
                            !href.includes('UserRegistration')) {
                            links.add(href);
                        }
                    });
                    
                    return Array.from(links);
                }""")

                # Add specific leaf-node URLs found
                for link in extracted_links:
                    if link != parent_url and link not in leaf_urls:
                        leaf_urls.add(link)
                        
            except Exception as e:
                print(f"    [!] Error inspecting {parent_url}: {e}")

        await browser.close()

    print(f"\n[+] Discovered {len(leaf_urls)} unique child/leaf category URLs!")

    # Save to JSON for feeding directly into the main scraper
    with open(OUTPUT_JSON, "w", encoding="utf-8") as f:
        json.dump(sorted(list(leaf_urls)), f, indent=2)

    print(f"[+] Saved leaf URLs to '{OUTPUT_JSON}'.")

if __name__ == "__main__":
    asyncio.run(main())