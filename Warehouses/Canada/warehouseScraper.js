import puppeteer from 'puppeteer';
import fs from 'fs';
import path from 'path';

async function scrapeWarehouses() {
  const browser = await puppeteer.launch({ headless: true });
  const page = await browser.newPage();
  
  // 1. Go to the sitemap page
  await page.goto('https://www.costco.ca/sitemaps/warehouses-by-state/QC', { waitUntil: 'networkidle2' });

  // 2. Extract all valid warehouse location links
  const warehouseLinks = await page.evaluate(() => {
    return Array.from(document.querySelectorAll('a'))
      .map(a => ({ 
        text: (a.innerText || a.textContent || '').trim(), 
        href: a.href 
      }))
      .filter(l => l.href && l.href.includes('/w/-/qc/'));
  });

  console.log(`Found ${warehouseLinks.length} warehouses to scrape. Fetching details...`);
  const warehousesData = [];

  // 3. Loop through each warehouse page
  for (const item of warehouseLinks) {
    try {
      await page.goto(item.href, { waitUntil: 'networkidle0' });
      await new Promise(r => setTimeout(r, 2000)); // Allow dynamic content to render
      
      const details = await page.evaluate(() => {
        // Target specific warehouse detail containers to avoid header banners
        const container = document.querySelector('.warehouse-details') || 
                          document.querySelector('.warehouse-info') || 
                          document.querySelector('main');

        const textToParse = container ? container.innerText : document.body.innerText;
        let lines = textToParse.split('\n').map(l => l.trim()).filter(Boolean);

        // Filter out global delivery banner text and operational status text
        lines = lines.filter(l => 
          !l.includes('Delivery Location') && 
          !l.toLowerCase().includes('open') && 
          !l.toLowerCase().includes('closed') &&
          !l.includes('Sign In')
        );

        let street = '';
        let city = '';
        let zip = '';

        for (let i = 0; i < lines.length; i++) {
          const line = lines[i];
          const zipMatch = line.match(/[A-Z]\d[A-Z]\s?\d[A-Z]\d/);
          if (zipMatch) {
            zip = zipMatch[0];
            
            // Extract city and street based on line layout
            if (i > 0) {
              const cityLine = lines[i - 1];
              city = cityLine.split(',')[0].trim();
            }
            if (i > 1) {
              street = lines[i - 2];
            }
            break;
          }
        }

        return {
          street: street,
          city: city,
          state: 'QC',
          zip: zip,
          lat: null,
          lng: null
        };
      });

      const urlParts = item.href.split('/');
      const warehouseId = urlParts[urlParts.length - 1];
      const citySlug = urlParts[urlParts.length - 2];
      const fallbackName = citySlug.charAt(0).toUpperCase() + citySlug.slice(1).replace('-', ' ');
      const warehouseName = item.text || fallbackName;

      warehousesData.push({
        warehouse_id: warehouseId,
        warehouse_name: warehouseName,
        ...details,
        country: 'Canada'
      });

      console.log(`[Success] Scraped: ${warehouseName} | ${details.street}, ${details.city} QC ${details.zip}`);

      await new Promise(r => setTimeout(r, 1000));
    } catch (err) {
      console.error(`[Error] Failed to scrape URL ${item.href}:`, err.message);
    }
  }

  await browser.close();

  const outputPath = path.join(process.cwd(), 'quebec_warehouses.json');
  fs.writeFileSync(outputPath, JSON.stringify(warehousesData, null, 2), 'utf-8');
  console.log(`\n🎉 Successfully saved ${warehousesData.length} records to ${outputPath}`);
}

scrapeWarehouses();