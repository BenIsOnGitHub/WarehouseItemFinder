import pandas as pd

# Load yesterday's generated CSV
df = pd.read_csv("warehouse_products_notUploaded.csv")

# Overwrite 'id' column with the standard composite format
# Adjust 'item_number' if your column name differs (e.g., 'sku')
df['id'] = df['warehouse_id'].astype(str) + "-item-" + df['item_number'].astype(str)

# Save standardized file ready for merge testing
df.to_csv("warehouse_products_ready_for_merge.csv", index=False)