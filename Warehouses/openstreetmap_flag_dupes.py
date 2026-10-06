# --- AUDIT: CHECK FOR DUPLICATE COORDINATES IN MULTI-STORE CITIES ---

# 1. Identify rows where lat/lng coordinates are exact duplicates
duplicates = df[df.duplicated(subset=['lat', 'lng'], keep=False)]

# 2. Filter for duplicates occurring in multi-store cities
multi_store_fallbacks = duplicates[duplicates.groupby(['state', 'city'])['city'].transform('count') > 1]

if not multi_store_fallbacks.empty:
    print(f"\n⚠️ WARNING: Found {len(multi_store_fallbacks)} stores with duplicate coordinates in multi-store cities:")
    print(multi_store_fallbacks[['warehouse_id', 'street_address', 'city', 'state', 'zip_code', 'lat', 'lng']].to_string())
    
    # Save affected rows to a CSV for manual review
    multi_store_fallbacks.to_csv('review_duplicate_coords.csv', index=False)
    print("\nSaved flagged stores to 'review_duplicate_coords.csv'")
else:
    print("\n Clean run! All multi-store locations received unique coordinates.")