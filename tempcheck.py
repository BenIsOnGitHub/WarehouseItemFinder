import os
import re

LOG_FILE = "scraper_log.txt"

if not os.path.exists(LOG_FILE):
    print(f"Error: {LOG_FILE} not found.")
    exit(1)

# Read binary and decode UTF-16
with open(LOG_FILE, "rb") as f:
    raw = f.read(50000)

if raw.startswith(b"\xff\xfe") or raw.startswith(b"\xfe\xff") or b"\x00" in raw:
    text = raw.decode("utf-16", errors="ignore").replace("\x00", "")
else:
    text = raw.decode("utf-8", errors="ignore")

print(f"Decoded {len(text)} characters from {LOG_FILE}\n")
print("--- LOG SAMPLE LINES ---")
lines = [l.strip() for l in text.splitlines() if l.strip()]
for line in lines[:15]:
    print(line[:120])