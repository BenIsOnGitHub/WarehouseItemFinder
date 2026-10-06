import pandas as pd

df = pd.read_csv('costco_warehouses_with_coords.csv')

# Manual coordinate overrides for the geocoder fallbacks
CORRECTIONS = {
    # Atlanta, GA
    631:  (33.8821, -84.4712),  # Cumberland Mall
    1084: (33.8562, -84.3394),  # Brookhaven
    
    # San Juan, PR
    335:  (18.3975, -65.9863),  # 65th Infanteria
}

for warehouse_id, (lat, lng) in CORRECTIONS.items():
    df.loc[df['warehouse_id'] == warehouse_id, ['lat', 'lng']] = [lat, lng]

# Save updated CSV
df.to_csv('costco_warehouses_with_coords.csv', index=False)
print("Updated coordinates for Atlanta & San Juan stores successfully!")