import pandas as pd

df = pd.read_csv('costco_warehouses_with_coords.csv')
valid_updates = df.dropna(subset=['lat', 'lng'])

with open('update_coords.sql', 'w') as f:
    # 1. Add columns if they don't exist yet
    f.write("ALTER TABLE warehouses ADD COLUMN lat DECIMAL(9,6);\n")
    f.write("ALTER TABLE warehouses ADD COLUMN lng DECIMAL(9,6);\n\n")
    
    # 2. Write UPDATE statements
    for _, row in valid_updates.iterrows():
        f.write(f"UPDATE warehouses SET lat = {row['lat']}, lng = {row['lng']} WHERE warehouse_id = {int(row['warehouse_id'])};\n")
        
    # 3. Create index for fast spatial lookup
    f.write("\nCREATE INDEX IF NOT EXISTS idx_warehouses_coords ON warehouses (lat, lng);\n")

print("Generated update_coords.sql successfully!")