import pandas as pd
import math

# Load both CSVs
coords_df = pd.read_csv('costco.Locations.csv')
cleaned_df = pd.read_csv('costco_warehouses_cleaned.csv')

# Pre-clean string fields for exact matching
coords_df['city_clean'] = coords_df['city_name'].str.strip().str.lower()
coords_df['state_clean'] = coords_df['state_id'].str.strip().str.upper()

cleaned_df['city_clean'] = cleaned_df['city'].str.strip().str.lower()
cleaned_df['state_clean'] = cleaned_df['state'].str.strip().str.upper()

# Merge on City and State
merged_df = pd.merge(
    cleaned_df,
    coords_df[['city_clean', 'state_clean', 'lat', 'lng']],
    on=['city_clean', 'state_clean'],
    how='left'
)

# For multi-store cities, duplicate rows will appear — you can filter/dedupe or zip-code match here!

# Drop clean helper columns and save output
merged_df = merged_df.drop(columns=['city_clean', 'state_clean'])
merged_df.to_csv('costco_warehouses_final.csv', index=False)

print("Saved costco_warehouses_final.csv successfully!")