import pandas as pd
from geopy.geocoders import Nominatim
from geopy.extra.rate_limiter import RateLimiter
import time

# 1. Load your cleaned CSV
df = pd.read_csv('costco_warehouses_cleaned.csv')

# 2. Set up OpenStreetMap Geocoder (Free, no API key required)
geolocator = Nominatim(user_agent="costco_warehouse_geocoder")

# Add 1 second delay between requests to comply with OSM usage policy
geocode = RateLimiter(geolocator.geocode, min_delay_seconds=1.0)

# Create lat/lng columns if they don't exist
if 'lat' not in df.columns:
    df['lat'] = None
if 'lng' not in df.columns:
    df['lng'] = None

print(f"Starting geocoding for {len(df)} warehouses...")

for idx, row in df.iterrows():
    # Construct full address string
    full_address = f"{row['street_address']}, {row['city']}, {row['state']} {row['zip_code']}"
    
    try:
        location = geocode(full_address)
        if location:
            df.at[idx, 'lat'] = location.latitude
            df.at[idx, 'lng'] = location.longitude
            print(f"[{idx+1}/{len(df)}] Matched: {row['city']}, {row['state']} -> ({location.latitude}, {location.longitude})")
        else:
            # Fallback: try geocoding without street address (City, State Zip)
            fallback_address = f"{row['city']}, {row['state']} {row['zip_code']}"
            loc_fallback = geocode(fallback_address)
            if loc_fallback:
                df.at[idx, 'lat'] = loc_fallback.latitude
                df.at[idx, 'lng'] = loc_fallback.longitude
                print(f"[{idx+1}/{len(df)}] Fallback matched: {fallback_address}")
            else:
                print(f"[{idx+1}/{len(df)}] Could not geocode: {full_address}")
    except Exception as e:
        print(f"Error on row {idx}: {e}")

# 3. Export to final CSV
df.to_csv('costco_warehouses_with_coords.csv', index=False)
print("\nDone! Saved to costco_warehouses_with_coords.csv")