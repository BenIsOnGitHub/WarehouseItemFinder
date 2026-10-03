import asyncio
import json
from playwright.async_api import async_playwright

async def inspect():
    async with async_playwright() as p:
        # Launch using persistent context so your active session/location loads
        context = await p.chromium.launch_persistent_context(
            user_data_dir="./chrome_user_data",
            channel="chrome",
            headless=False,
            args=["--disable-blink-features=AutomationControlled", "--start-maximized"],
            viewport={"width": 1440, "height": 900},
        )

        pages = context.pages
        page = pages[0] if pages else await context.new_page()

        captured = False

        async def handle_response(res):
            nonlocal captured
            if captured:
                return

            try:
                url = res.url.lower()
                # Intercept any API / catalog / search JSON response
                if res.status == 200 and ("json" in res.headers.get("content-type", "") or "api" in url or "search" in url):
                    data = await res.json()
                    raw_text = json.dumps(data)

                    # Look for product search payloads
                    if "searchResult" in raw_text or "productData" in raw_text or "Midea" in raw_text:
                        with open("attributes_dump.json", "w", encoding="utf-8") as f:
                            json.dump(data, f, indent=2)

                        print("\n[+] SUCCESS! Captured payload and saved to attributes_dump.json")
                        captured = True
            except Exception:
                pass

        page.on("response", handle_response)

        print("\nNavigating to category page...")
        await page.goto("https://www.costco.com/refrigerators.html?refinement=buyInWarehouse%3Dtrue", wait_until="domcontentloaded")

        # Scroll down slightly to trigger lazy-loaded network requests
        await asyncio.sleep(2)
        await page.evaluate("window.scrollTo(0, document.body.scrollHeight * 0.5);")

        print("Waiting for network requests (up to 15 seconds)...")
        for _ in range(15):
            if captured:
                break
            await asyncio.sleep(1)

        if not captured:
            print("\n[!] No matching payload captured in 15 seconds. Please check browser window.")

        await context.close()

if __name__ == "__main__":
    asyncio.run(inspect())