import fs from 'fs';
import path from 'path';

async function geocodeWarehouses() {
  const jsonPath = path.join(process.cwd(), 'quebec_warehouses.json');
  
  if (!fs.existsSync(jsonPath)) {
    console.error(`Error: ${jsonPath} not found. Run your scraper first!`);
    process.exit(1);
  }

  const warehouses = JSON.parse(fs.readFileSync(jsonPath, 'utf-8'));
  console.log(`Starting geocoding for ${warehouses.length} warehouses via OpenStreetMap...`);

  for (let i = 0; i < warehouses.length; i++) {
    const w = warehouses[i];
    
    // Skip if coordinates already exist
    if (w.lat && w.lng) {
      console.log(`[Skipped] ${w.warehouse_name} already has coordinates.`);
      continue;
    }

    try {
      const query = encodeURIComponent(`${w.street}, ${w.city}, QC ${w.zip}, Canada`);
      const url = `https://nominatim.openstreetmap.org/search?q=${query}&format=json&limit=1`;
      
      const response = await fetch(url, { 
        headers: { 'User-Agent': 'AisleHeroWarehouseGeocoder/1.0 (internal-tool)' } 
      });
      const data = await response.json();

      if (data && data.length > 0) {
        w.lat = parseFloat(data[0].lat);
        w.lng = parseFloat(data[0].lon);
        console.log(`[Success] ${w.warehouse_name} -> Lat: ${w.lat}, Lng: ${w.lng}`);
      } else {
        console.warn(`[Warning] No coordinates found for ${w.warehouse_name}`);
      }

      // OpenStreetMap Nominatim Usage Policy requires a polite delay of at least 1 second between requests
      await new Promise(r => setTimeout(r, 1100));
    } catch (err) {
      console.error(`[Error] Failed to geocode ${w.warehouse_name}:`, err.message);
    }
  }

  // Save the updated JSON back out
  fs.writeFileSync(jsonPath, JSON.stringify(warehouses, null, 2), 'utf-8');
  console.log(`\n🎉 Geocoding complete! Updated JSON saved to ${jsonPath}`);
}

geocodeWarehouses();