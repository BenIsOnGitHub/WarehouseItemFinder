import csv

input_filename = "warehouse_products_notUploaded.csv"
output_filename = "warehouse_products_notUploaded_fixed.csv"

with open(input_filename, mode="r", encoding="utf-8") as f_in, \
     open(output_filename, mode="w", encoding="utf-8", newline="") as f_out:
    
    reader = csv.reader(f_in)
    writer = csv.writer(f_out)
    
    headers = next(reader)
    writer.writerow(headers)
    
    # Find the index for updated_at column (or default to last column)
    headers_lower = [h.lower().strip() for h in headers]
    updated_idx = headers_lower.index("updated_at") if "updated_at" in headers_lower else -1

    count = 0
    for row in reader:
        if not row:
            continue
        
        # Replace the updated_at field with the target date
        if updated_idx != -1 and len(row) > updated_idx:
            row[updated_idx] = "2026-09-27 00:00:00"
        else:
            row.append("2026-09-27 00:00:00")
            
        writer.writerow(row)
        count += 1

print(f"[+] Successfully updated {count} rows and saved to '{output_filename}'")