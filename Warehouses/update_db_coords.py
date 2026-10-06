import pandas as pd
import sqlite3
import os

# --- CONFIGURATION ---
CSV_FILE = 'costco_warehouses_with_coords.csv'
DB_FILE = 'product-inventory.db'  # <--- Change this to your database filename/path

# Check if CSV exists
if not os.path.exists(CSV_FILE):
    print(f"Error: '{CSV_FILE}' not found. Please run the geocoding script first.")
    exit(1)

# 1. Load the geocoded CSV
df = pd.read_csv(CSV_FILE)

# Filter out rows missing lat or lng
valid_updates = df.dropna(subset=['lat', 'lng'])
print(f"Loaded {len(valid_updates)} warehouse coordinate records from CSV.\n")

# 2. Connect to SQLite Database
try:
    conn = sqlite3.connect(DB_FILE)
    cursor = conn.cursor()

    # Ensure lat and lng columns exist (adds them if they don't already)
    try:
        cursor.execute("ALTER TABLE warehouses ADD COLUMN lat DECIMAL(9,6)")
        cursor.execute("ALTER TABLE warehouses ADD COLUMN lng DECIMAL(9,6)")
        print("Added 'lat' and 'lng' columns to 'warehouses' table.")
    except sqlite3.OperationalError:
        # Columns already exist, move on
        pass

    # 3. Perform Bulk Update using executemany for maximum speed
    update_data = [
        (row['lat'], row['lng'], row['warehouse_id']) 
        for _, row in valid_updates.iterrows()
    ]

    update_query = """
        UPDATE warehouses 
        SET lat = ?, lng = ? 
        WHERE warehouse_id = ?
    """

    cursor.executemany(update_query, update_data)
    conn.commit()

    print(f" Successfully updated coordinates for {cursor.rowcount} warehouses in the database!")

    # 4. Optional: Create index on lat and lng after the update for fast spatial queries
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_warehouses_coords ON warehouses (lat, lng)")
    conn.commit()
    print(" Verified index 'idx_warehouses_coords' on (lat, lng).")

except Exception as e:
    print(f" Database Update Failed: {e}")
    if 'conn' in locals():
        conn.rollback()

finally:
    if 'conn' in locals():
        conn.close()