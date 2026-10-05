import json
import urllib.parse

raw_cookie = '%7B%22storeLocation%22%3A%7B%22city%22%3A%22The%20Villages%22%2C%22zip%22%3A%2232162-7199%22%7D%7D'

def get_zip_from_cookie(cookie_str):
    decoded = urllib.parse.unquote(cookie_str)
    data = json.loads(decoded)
    full_zip = data.get("storeLocation", {}).get("zip", "")
    return full_zip.split("-")[0]

print("Extracted ZIP:", get_zip_from_cookie(raw_cookie))  # Expected: 32162