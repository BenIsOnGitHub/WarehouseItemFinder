# test_api.py
import urllib.request
import json
import time

def fetch_sameday_item_graphql(item_number: str, zip_code: str = "32162") -> dict | None:
    """
    Queries Instacart/Sameday GraphQL endpoint directly for warehouse items.
    Fast (~1s), reliable, and bypasses browser rendering issues.
    """
    url = "https://sameday.costco.com/graphql"
    
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36",
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Cookie": f"warehouse_zip={zip_code}; instacart_async_service_address=%7B%22postal_code%22%3A%22{zip_code}%22%7D",
        "x-client-identifier": "web"
    }

    # Instacart search query payload
    payload = {
        "operationName": "SearchItems",
        "variables": {
            "query": item_number,
            "postalCode": zip_code,
            "perPage": 5
        },
        "query": """
            query SearchItems($query: String!, $postalCode: String, $perPage: Int) {
              search(query: $query, postalCode: $postalCode, perPage: $perPage) {
                products {
                  id
                  name
                  slug
                }
              }
            }
        """
    }

    try:
        data_bytes = json.dumps(payload).encode('utf-8')
        req = urllib.request.Request(url, data=data_bytes, headers=headers, method="POST")
        
        with urllib.request.urlopen(req, timeout=10) as response:
            res_json = json.loads(response.read().decode('utf-8'))
            products = res_json.get("data", {}).get("search", {}).get("products", [])

            if products:
                first = products[0]
                product_id = first.get("id")
                slug = first.get("slug", "")
                title = first.get("name")

                full_path = f"{product_id}-{slug}" if slug else str(product_id)

                return {
                    "item_number": item_number,
                    "title": title,
                    "product_url": f"https://sameday.costco.com/store/costco/products/{full_path}",
                    "source": "sameday.costco.com",
                    "zip_code": zip_code
                }
    except Exception as e:
        print(f"GraphQL request error: {e}")

    return None

if __name__ == "__main__":
    start = time.time()
    result = fetch_sameday_item_graphql("1633654")
    elapsed = round(time.time() - start, 2)
    print(f"Pipeline Output ({elapsed}s):", result)