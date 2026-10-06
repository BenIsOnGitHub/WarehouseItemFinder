import pandas as pd
import sqlite3
import math

# 1. Load the CSV coordinates
csv_df = pd.read_csv('costco.Locations.csv')

# 2. Haversine distance function (in miles)
def distance_miles(lat1, lon1, lat2, lon2):
    R = 3958.8
    dlat = math.radians(lat2 - lat1)
    dlon = math.radians(lon2 - lon1)
    a = (math.sin(dlat / 2)**2 + 
         math.cos(math.radians(lat1)) * math.cos(math.radians(lat2)) * math.sin(dlon / 2)**2)
    return R * (2 * math.atan2(math.sqrt(a), math.sqrt(1 - a)))

# 3. Connect to your database
conn = sqlite3.connect('product-inventory.db')
cursor = conn.cursor()

# Fetch all warehouses from your DB
cursor.execute("SELECT warehouse_id, address, city, state, zip_code FROM warehouses")
db_warehouses = cursor.fetchall()

for warehouse_id, address, city, state, zip_code in db_warehouses:
    # Filter CSV for stores in the same city and state
    city_matches = csv_df[
        (csv_df['city_name'].str.lower() == city.strip().lower()) & 
        (csv_df['state_id'].str.upper() == state.strip().upper())
    ]
    
    if len(city_matches) == 1:
        # Single store in city -> Direct match!
        matched_row = city_matches.iloc[0]
        cursor.execute(
            "UPDATE warehouses SET lat = ?, lng = ? WHERE warehouse_id = ?",
            (matched_row['lat'], matched_row['lng'], warehouse_id)
        )
    elif len(city_matches) > 1:
        # Multiple stores in city (e.g. Anchorage)
        # You can use geocoding on `address + zip_code` to pick the closest coordinate match:
        # Example pseudo-code for geocoding lookup:
        # db_lat, db_lng = geocode_address(f"{address}, {city}, {state} {zip_code}")
        # best_match = min(city_matches.iterrows(), key=lambda r: distance_miles(db_lat, db_lng, r[1]['lat'], r[1]['lng']))
        pass

conn.commit()
conn.close()