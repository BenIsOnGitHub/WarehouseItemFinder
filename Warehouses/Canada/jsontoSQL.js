import fs from 'fs';
import path from 'path';

// Load scraped JSON
const jsonPath = path.join(process.cwd(), 'quebec_warehouses.json');
const sqlPath = path.join(process.cwd(), 'seed_quebec.sql');

if (!fs.existsSync(jsonPath)) {
  console.error(`Error: ${jsonPath} not found.`);
  process.exit(1);
}

const warehouses = JSON.parse(fs.readFileSync(jsonPath, 'utf-8'));

const sqlStatements = warehouses.map(w => {
  const id = (w.warehouse_id || '').replace(/'/g, "''");
  const name = (w.warehouse_name || '').replace(/'/g, "''");
  const street = (w.street || '').replace(/'/g, "''");
  const city = (w.city || '').replace(/'/g, "''");
  const state = (w.state || 'QC').replace(/'/g, "''");
  const zip = (w.zip || '').replace(/'/g, "''");
  const country = (w.country || 'Canada').replace(/'/g, "''");
  const lat = w.lat !== null && w.lat !== undefined ? w.lat : 'NULL';
  const lng = w.lng !== null && w.lng !== undefined ? w.lng : 'NULL';

  return `INSERT INTO warehouses (warehouse_id, warehouse_name, street_address, city, state, zip_code, lat, lng, country) VALUES ('${id}', '${name}', '${street}', '${city}', '${state}', '${zip}', ${lat}, ${lng}, '${country}') ON CONFLICT(warehouse_id) DO UPDATE SET warehouse_name=excluded.warehouse_name, street_address=excluded.street_address, city=excluded.city, state=excluded.state, zip_code=excluded.zip_code, country=excluded.country;`;
});

fs.writeFileSync(sqlPath, sqlStatements.join('\n'), 'utf-8');
console.log(`\n🎉 Successfully generated ${sqlStatements.length} SQL statements in ${sqlPath}`);