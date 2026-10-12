with open("seed_global_products.sql", "r", encoding="utf-8") as f:
    lines = f.readlines()

chunk_size = 2000  # Number of lines per file
for i in range(0, len(lines), chunk_size):
    chunk_lines = lines[i : i + chunk_size]
    filename = f"seed_chunk_{i // chunk_size + 1}.sql"
    with open(filename, "w", encoding="utf-8") as f_out:
        f_out.writelines(chunk_lines)
    print(f"Created {filename}")

print("\n[+] Done splitting SQL file into chunks!")