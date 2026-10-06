import pandas as pd

# 1. Load your geocoded CSV file
CSV_FILE = 'costco_warehouses_with_coords.csv'

try:
    df = pd.read_csv(CSV_FILE)
    print(f"Successfully loaded '{CSV_FILE}' with {len(df)} rows.\n")
except FileNotFoundError:
    print(f"Error: Could not find '{CSV_FILE}'. Make sure the file name and path are correct.")
    exit(1)

# 2. Identify rows where lat/lng coordinates are exact duplicates (ignoring empty/missing coordinates)
valid_coords = df.dropna(subset=['lat', 'lng'])
duplicates = valid_coords[valid_coords.duplicated(subset=['lat', 'lng'], keep=False)]

# 3. Filter for duplicate coordinates that occur in multi-store cities/states
multi_store_fallbacks = duplicates[duplicates.groupby(['state', 'city'])['city'].transform('count') > 1]

# 4. Report results
if not multi_store_fallbacks.empty:
    affected_cities = multi_store_fallbacks[['city', 'state']].drop_duplicates()
    
    print(f"⚠️️ WARNING: Found {len(multi_store_fallbacks)} stores sharing identical coordinates across {len(affected_cities)} multi-store city locations:\n")
    
    # Sort for easy reading
    sorted_report = multi_store_fallbacks.sort_values(by=['state', 'city', 'warehouse_id'])
    
    # Print summary to terminal
    print(sorted_report[['warehouse_id', 'street_address', 'city', 'state', 'zip_code', 'lat', 'lng']].to_string(index=False))
    
    # Save flagged duplicates to a separate CSV for easy manual review
    OUTPUT_FILE = 'review_duplicate_coords.csv'
    sorted_report.to_csv(OUTPUT_FILE, index=False)
    print(f"\nSaved affected rows to '{OUTPUT_FILE}' for manual fixing.")

else:
    print("✅ Clean run! All multi-store locations received unique coordinates.")