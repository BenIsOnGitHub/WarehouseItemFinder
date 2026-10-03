import json

with open("attributes_dump.json", "r", encoding="utf-8") as f:
    data = json.load(f)

for result in data.get("searchResult", {}).get("results", []):
    prod = result.get("product", {})
    print("Title:", prod.get("title"))
    print("Keys in product:", list(prod.keys()))
    print("Attributes dictionary:", json.dumps(prod.get("attributes", {}), indent=2))
    print("=" * 60)