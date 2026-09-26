CREATE TABLE IF NOT EXISTS products (
    sku TEXT NOT NULL,
    warehouse_id TEXT NOT NULL,
    product_name TEXT NOT NULL,
    product_url TEXT,
    aisle TEXT,
    bay TEXT,
    is_wrong INTEGER NOT NULL DEFAULT 0,
    is_discontinued INTEGER NOT NULL DEFAULT 0,
    updated_at TEXT DEFAULT (datetime('now')),
    PRIMARY KEY (sku, warehouse_id)
);

CREATE INDEX IF NOT EXISTS idx_products_sku ON products(sku);
CREATE INDEX IF NOT EXISTS idx_products_flagged ON products(warehouse_id, is_wrong);

INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1169418', '1738', 'Kirkland Signature Cabernet Sauvignon, 3 L', 'https://www.costco.com/.product.1169418.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1952509', '1738', 'Kirkland Signature Straight Bourbon Whiskey, Kentucky, 1.75 L', 'https://www.costco.com/.product.1952509.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('514007', '1738', 'Kirkland Signature Chardonnay, Sonoma County, 750 ml', 'https://www.costco.com/.product.514007.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1299062', '1738', 'Coca-Cola Mini, 7.5 fl oz, 30-count', 'https://www.costco.com/.product.1299062.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1579880', '1738', 'Coca-Cola Mini, Variety Pack, 7.5 fl oz, 30-count', 'https://www.costco.com/.product.1579880.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1779098', '1738', 'BODYARMOR Lyte Sports Drink, Variety Pack, 20 fl oz, 18-count', 'https://www.costco.com/.product.1779098.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1394201', '1738', 'Kirkland Signature, Organic Coconut Water, 11.1 fl oz, 12-count', 'https://www.costco.com/.product.1394201.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1218891', '1738', 'Vita Coco, Coconut Water, 11.1 fl oz, 18-count', 'https://www.costco.com/.product.1218891.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1833411', '1738', 'Alani Nu Energy Drink, Variety Pack, 12 fl oz, 18-count', 'https://www.costco.com/.product.1833411.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1924266', '1738', 'San Pellegrino Ciao! Sparkling Water, Variety Pack, 11.15 fl oz, 24-count', 'https://www.costco.com/.product.1924266.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2048159', '1738', 'Celsius Vibe Energy Drink, Variety Pack, 12 fl oz, 18-count', 'https://www.costco.com/.product.2048159.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('975416', '1738', 'San Pellegrino Sparkling Natural Mineral Water, 16.9 fl oz, 24-count', 'https://www.costco.com/.product.975416.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1925833', '1738', 'Kirkland Signature Sparkling Energy Drink, Variety Pack, 12 fl oz, 24-count', 'https://www.costco.com/.product.1925833.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1532150', '1738', 'La Croix Sparkling Water, Beach Plum, Guava Sao Paulo and Black Razz Berry Variety Pack, 12 fl oz, 24-count', 'https://www.costco.com/.product.1532150.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2990', '1738', 'Honest Kids, Organic Juice Drink, Variety Pack, 6 fl oz, 40-count', 'https://www.costco.com/.product.2990.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2056753', '1738', 'Bloom Sparkling Energy Drink, Flavor Obsessions, Variety Pack, 12 fl oz, 18-count', 'https://www.costco.com/.product.2056753.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1780981', '1738', 'Joyburst Hydration Drink, Variety Pack, 16.9 fl oz, 18-count', 'https://www.costco.com/.product.1780981.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1795394', '1738', 'IZZE, Sparkling Juice Beverage, Variety Pack, 8.4 fl oz, 24-Count', 'https://www.costco.com/.product.1795394.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1594596', '1738', 'Gatorade Thirst Quencher, Turf Variety Pack, 12 fl oz, 28-count', 'https://www.costco.com/.product.1594596.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2040251', '1738', 'Maison Perrier French Kiss Sparkling Juice Beverage, Variety Pack, 11.15 fl oz, 20-count', 'https://www.costco.com/.product.2040251.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2051862', '1738', 'LMNT Sparkling Electrolyte Drink, Variety Pack, 12 fl oz, 15-count', 'https://www.costco.com/.product.2051862.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1850863', '1738', 'Kirkland Signature  Flavored Sparkling Water, 17 fl oz, 24-count', 'https://www.costco.com/.product.1850863.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1792368', '1738', 'Maison Perrier Sparkling Water, 16.9 fl oz, 24-count', 'https://www.costco.com/.product.1792368.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2052182', '1738', 'Liquid Death Soda-Flavored Sparkling Water, Variety Pack, 24-count', 'https://www.costco.com/.product.2052182.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2043159', '1738', 'Poppi Soda, Juicy Hits Variety Pack, 12 fl oz, 18-count', 'https://www.costco.com/.product.2043159.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1495250', '1738', 'Kirkland Signature, Organic Coconut Water, 33.8 fl oz, 9-count', 'https://www.costco.com/.product.1495250.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1937492', '1738', 'Alani Nu Energy Drink, Witch''s Brew, 12 fl oz, 18-count', 'https://www.costco.com/.product.1937492.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1498286', '1738', 'Gatorade Thirst Quencher, Core Variety Pack, 12 fl oz, 28-count', 'https://www.costco.com/.product.1498286.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('854344', '1738', 'Sprite Lemon-Lime Caffeine Free Soda Soft Drink Cans, 12 fl oz, 35-count', 'https://www.costco.com/.product.854344.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2009964', '1738', 'Gatorade Lower Sugar Variety Pack, 12 fl oz, 24-count', 'https://www.costco.com/.product.2009964.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1608549', '1738', 'Ocean Spray, Cranberry Juice, Variety Pack, 10 fl oz, 24-Count', 'https://www.costco.com/.product.1608549.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2041444', '1738', 'Olipop Mini Soda, Variety Pack, 7.5 fl oz, 15-count', 'https://www.costco.com/.product.2041444.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('736083', '1738', 'Kirkland Signature, Organic Lemonade, 96 fl oz, 2-count', 'https://www.costco.com/.product.736083.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1966529', '1738', 'Celsius Sparkling Energy Drink, Core Variety Pack, 12 fl oz, 18-count', 'https://www.costco.com/.product.1966529.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1002373', '1738', 'Kirkland Signature, Organic Almond Beverage, Vanilla, 32 fl oz, 6-Count', 'https://www.costco.com/.product.1002373.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1415519', '1738', 'Propel Fitness Water Variety Pack, 16.9 fl oz, 24-count', 'https://www.costco.com/.product.1415519.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1913302', '1738', 'Olipop Soda, Variety Pack, 12 fl oz, 15-count', 'https://www.costco.com/.product.1913302.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1977124', '1738', 'Bai Antioxidant Beverage, Fruit Variety Pack, 18 fl oz, 15-count', 'https://www.costco.com/.product.1977124.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1743030', '1738', 'Kirkland Signature Organic Whole Milk, 8 fl oz, 18-count', 'https://www.costco.com/.product.1743030.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('179571', '1738', 'Coca-Cola de Mexico Soda Soft Drink Glass Bottles, 335 mL, 24-count', 'https://www.costco.com/.product.179571.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('118652', '1738', 'Carnation, Evaporated Milk, 12 fl oz, 12-Count', 'https://www.costco.com/.product.118652.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2051490', '1738', 'Saint James Organic Brewed Tea, Variety Pack, 16 fl oz, 15-count', 'https://www.costco.com/.product.2051490.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1272413', '1738', 'Kirkland Signature, Organic Non-Dairy Oat Beverage, 32 oz, 6-count', 'https://www.costco.com/.product.1272413.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1174811', '1738', 'Sunny D Citrus Punch, Tangy Original, 11.3 fl oz, 30-Count', 'https://www.costco.com/.product.1174811.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1242342', '1738', 'Kirkland Signature, Almond Milk, 1 qt, 12-count', 'https://www.costco.com/.product.1242342.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1939979', '1738', 'Celsius Sparkling Energy Drink, Vibe Variety Pack, 12 fl oz, 18-count', 'https://www.costco.com/.product.1939979.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('711509', '1738', 'Red Bull Energy Drink, Sugar Free, 8.4 fl oz, 24-count', 'https://www.costco.com/.product.711509.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1462714', '1738', 'Kirkland Signature Organic A2 Whole Milk, Half Gallon, 3-count', 'https://www.costco.com/.product.1462714.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('701249', '1738', 'Welch''s 100% Juice Drink, Variety Pack, 10 fl oz, 24-count', 'https://www.costco.com/.product.701249.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('438851', '1738', 'Capri Sun, 100% Juice, Variety Pack, 6 fl oz, 40-count', 'https://www.costco.com/.product.438851.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('790652', '1738', 'SO Delicious, Organic Coconut Milk, 32 oz, 6-Count', 'https://www.costco.com/.product.790652.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2044023', '1738', 'Ghost Energy Drink, Variety Pack, 16 fl oz, 18-count', 'https://www.costco.com/.product.2044023.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('242668', '1738', 'Red Bull Energy Drink, 8.4 fl oz, 24 count', 'https://www.costco.com/.product.242668.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2037327', '1738', 'Alani Nu Energy Drink, Cotton Candy Variety Pack, 12 fl oz, 18-count', 'https://www.costco.com/.product.2037327.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('316629', '1738', 'Welch’s, 100% Grape Juice Blend, Concord Grape, 96 fl oz, 2-Count', 'https://www.costco.com/.product.316629.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1820893', '1738', 'Kirkland Signature A2 Chocolate Milk, 8 fl oz, 24-count', 'https://www.costco.com/.product.1820893.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('473505', '1738', 'Apple & Eve, 100% Juice, Variety Pack, 6.75 fl oz, 36-count', 'https://www.costco.com/.product.473505.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1845080', '1738', 'Kirkland Signature Sport Drink, Variety Pack, 12 fl oz, 24-count', 'https://www.costco.com/.product.1845080.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1242231', '1738', 'Swiss Miss, Hot Cocoa Mix, 1.38 oz, 50-Count', 'https://www.costco.com/.product.1242231.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1032767', '1738', 'Mott''s Organic 100% Apple Juice, 1 Gal, 2-count', 'https://www.costco.com/.product.1032767.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('854330', '1738', 'Coca-Cola Classic, 12 fl oz, 35-count', 'https://www.costco.com/.product.854330.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1936264', '1738', 'Gatorade Zero Variety Pack, 20 fl oz, 24-count', 'https://www.costco.com/.product.1936264.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('607373', '1738', 'San Pellegrino Sparkling Natural Mineral Water, 25.3 fl oz, 15-count', 'https://www.costco.com/.product.607373.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('325112', '1738', 'Lipton, Iced Tea Mix, Lemon, 5 lbs', 'https://www.costco.com/.product.325112.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1975527', '1738', 'Kirkland Signature Ultra Filtered 2% Lactose Free Milk, Half Gallon, 3-count', 'https://www.costco.com/.product.1975527.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2045189', '1738', 'Monster Energy Drink, Ultra Variety Pack, 12 fl oz, 24-count', 'https://www.costco.com/.product.2045189.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1917654', '1738', 'AG1 Daily Foundational Nutrition, 40-count', 'https://www.costco.com/.product.1917654.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1243287', '1738', 'Kirkland Signaure Organic Raw Kombucha, 16 fl oz, 8-count', 'https://www.costco.com/.product.1243287.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1105983', '1738', 'Glacéau Smartwater, 1 L, 15-count', 'https://www.costco.com/.product.1105983.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('239600', '1738', 'FIJI Natural Artesian Water, 16.9 fl oz, 24-count', 'https://www.costco.com/.product.239600.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2076416', '1738', 'Health-Ade Organic Fruity Fusion Kombucha Variety Pack, 16 fl oz, 6-count', 'https://www.costco.com/.product.2076416.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1169942', '1738', 'Fever Tree Ginger Beer, 9.3 fl oz, 12 count', 'https://www.costco.com/.product.1169942.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1530604', '1738', 'Sambazon Organic Dragon Fruit Blend, 64 fl oz', 'https://www.costco.com/.product.1530604.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1792879', '1738', 'POM Wonderful 100% Pomegranate Juice, 64 fl oz', 'https://www.costco.com/.product.1792879.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('31801', '1738', 'Morey''s Seasoned Wild Alaskan Salmon, 6-Count', 'https://www.costco.com/.product.31801.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('47735', '1738', 'Kirkland Signature "Air-Chilled" Fresh Boneless Skinless Chicken Breasts', 'https://www.costco.com/.product.47735.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('29755', '1738', 'Kirkland Signature Boneless Lamb Leg Roast, Australian', 'https://www.costco.com/.product.29755.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('6262016', '1738', 'Kirkland Signature Bath Tissue, 2-Ply, 380 Sheets, 30 Rolls', 'https://www.costco.com/.product.6262016.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('512599', '1738', 'Kirkland Signature Paper Towels, 2-Ply, 160 Sheets, 12 Individually Wrapped Rolls', 'https://www.costco.com/.product.512599.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1919326', '1738', 'Bounty Advanced Paper Towels, 2-Ply, 103 Sheets, 12-count', 'https://www.costco.com/.product.1919326.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1111161', '1738', 'Dixie Ultra 10-1/16" Paper Plate, 186-count', 'https://www.costco.com/.product.1111161.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('723675', '1738', 'Kleenex Trusted Care Facial Tissue, 2-Ply, 230-count, 10-pack', 'https://www.costco.com/.product.723675.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1725952', '1738', 'Kirkland Signature Ultra Soft Bath Tissue, 2-Ply, 231 Sheets, 36 Rolls', 'https://www.costco.com/.product.1725952.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1668599', '1738', 'Dixie Ultra 8-1/2" Paper Plate, 240-count', 'https://www.costco.com/.product.1668599.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('221663', '1738', 'Kleenex Ultra Soft Facial Tissue, 3-Ply, 85-count, 12-pack', 'https://www.costco.com/.product.221663.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('4165769', '1738', 'Kirkland Signature Facial Tissue, 3-Ply, 84-count, 12-pack', 'https://www.costco.com/.product.4165769.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1585373', '1738', 'Kirkland Signature Napkins, 1-Ply, 280-count, 4-pack', 'https://www.costco.com/.product.1585373.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('912796', '1738', 'Scott Bath Tissue, 1-Ply, 1100 Sheets, 36 Rolls', 'https://www.costco.com/.product.912796.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1897229', '1738', 'Ziploc Seal Top Bag, Variety Pack, 322-count', 'https://www.costco.com/.product.1897229.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('785094', '1738', 'Vanity Fair Everyday Napkin, 2-Ply, 110-count, 6-pack', 'https://www.costco.com/.product.785094.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1843108', '1738', 'Kirkland Signature Gallon Plus Freezer Bags, 192-count', 'https://www.costco.com/.product.1843108.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1843112', '1738', 'Kirkland Signature Freezer Quart Plus Bags, 264-count', 'https://www.costco.com/.product.1843112.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1323118', '1738', 'Kirkland Signature Parchment Paper, 15 in x 164 ft, 2 count', 'https://www.costco.com/.product.1323118.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1205611', '1738', 'Cottonelle Fresh Care Flushable Wipes, 560 Wipes', 'https://www.costco.com/.product.1205611.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1897217', '1738', 'Ziploc Seal Top Freezer Bag, Gallon, 136-count', 'https://www.costco.com/.product.1897217.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('12648', '1738', 'Kirkland Signature Cutlery, Clear, 360-count', 'https://www.costco.com/.product.12648.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1897232', '1738', 'Ziploc Seal Top Bag, Sandwich, 480-count', 'https://www.costco.com/.product.1897232.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1193444', '1738', 'Kirkland Signature Chinet 18 oz Plastic Cup, Red, 240-count', 'https://www.costco.com/.product.1193444.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('296917', '1738', 'Dixie Ultra 20 oz Paper Bowl, 135-count', 'https://www.costco.com/.product.296917.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1115', '1738', 'Dixie 12 oz Paper Bowl, 175-count', 'https://www.costco.com/.product.1115.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('4165671', '1738', 'Kleenex Soothing Lotion Facial Tissue, 3-Ply, 85-count, 12-pack', 'https://www.costco.com/.product.4165671.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1770137', '1738', 'DUDE Wipes Fragrance-Free + Moisturizing XL Flushable Wipes, 480 Wipes', 'https://www.costco.com/.product.1770137.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('127509', '1738', 'Solo Heavyweight Plastic Fork, White, 500-count', 'https://www.costco.com/.product.127509.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('32711', '1738', 'Chinet Classic Dinner 10-3/8" Paper Plate, 165-count', 'https://www.costco.com/.product.32711.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('18695', '1738', 'Chinet Classic Lunch 8-3/4" Paper Plate, 225-count', 'https://www.costco.com/.product.18695.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('720', '1738', 'Reynolds Wrap Aluminum Foil, 12" x 83.33 yd, 2-count', 'https://www.costco.com/.product.720.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('127489', '1738', 'Solo Heavyweight Plastic Spoon, White, 500 count', 'https://www.costco.com/.product.127489.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('975', '1738', 'Reynolds Wrap Heavy Duty Aluminum Foil, 18" x 33.33 yd, 2-count', 'https://www.costco.com/.product.975.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1343253', '1738', 'Kirkland Signature Elegant Plastic Plates, Variety Pack, White, 50-count', 'https://www.costco.com/.product.1343253.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('519964', '1738', 'Chinet Crystal 10 oz Plastic Cup, Clear, 150-count', 'https://www.costco.com/.product.519964.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('404609', '1738', 'Eco-Foil Half Size Deep Steam Table Pan, 30-count', 'https://www.costco.com/.product.404609.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1840900', '1738', 'Dixie Ultra Deep Dish Paper Plate, 115-count', 'https://www.costco.com/.product.1840900.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('26757', '1738', 'Kirkland Signature 12" Plastic Food Wrap, 750 ft, 2 count', 'https://www.costco.com/.product.26757.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1186080', '1738', 'Dixie To Go 12 oz Insulated Cup & Lid, 100-count', 'https://www.costco.com/.product.1186080.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1895187', '1738', 'Glad Take-Aways Food Storage Containers with Lids, 38 oz Rectangle, 35-sets', 'https://www.costco.com/.product.1895187.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('31680', '1738', 'Kirkland Signature Aluminum Foil, 12"W x 1000''L', 'https://www.costco.com/.product.31680.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('3451400', '1738', 'Marathon Jumbo Roll Bath Tissue, 2-Ply, 900 ft Rolls, 6 Rolls', 'https://www.costco.com/.product.3451400.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('979669', '1738', 'USPS First-Class Forever Stamp, 100-Count', 'https://www.costco.com/.product.979669.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('598784', '1738', 'USPS First-Class Spring Stamps, 100 Count', 'https://www.costco.com/.product.598784.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('956696', '1738', 'Kirkland Signature Extra-Large Absorbent Pads, 30 in L X 23 in W, 100-count', 'https://www.costco.com/.product.956696.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('971832', '1738', 'Kirkland Signature Dental Chews, 72-count', 'https://www.costco.com/.product.971832.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1007880', '1738', 'Top Chews Chicken & Apple Sausage Bites, 40 oz', 'https://www.costco.com/.product.1007880.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('52296', '1738', 'Kirkland Signature Chicken and Rice Cat Food, 25 lbs', 'https://www.costco.com/.product.52296.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('895073', '1738', 'Kirkland Signature Nature''s Domain Canned Dog Food, Turkey & Pea Stew, 13.2 oz, 24-count', 'https://www.costco.com/.product.895073.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('570940', '1738', 'Kirkland Signature Nature''s Domain Cat Food, 18 lbs', 'https://www.costco.com/.product.570940.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2035569', '1738', 'Purina Friskies Pate Wet Cat Food Variety Pack, 5.5 oz, 60-count', 'https://www.costco.com/.product.2035569.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1734859', '1738', 'Kirkland Signature Chunks in Gravy, Canned Cat Food Variety Pack, 3 oz, 48-count', 'https://www.costco.com/.product.1734859.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1567724', '1738', 'Kirkland Signature Canned Dog Food, 13.2 oz, 24-count', 'https://www.costco.com/.product.1567724.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1729162', '1738', 'BARK Winter Wooferland Toy and Treat Dog Advent Calendar', 'https://www.costco.com/.product.1729162.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1647381', '1738', 'Kirkland Signature Pate Cat Food Variety Pack, 3.5 oz, 45-count', 'https://www.costco.com/.product.1647381.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1780093', '1738', 'Freshpet Deli Fresh Dog Food, Chicken Recipe, 1.5 lbs, 6-rolls', 'https://www.costco.com/.product.1780093.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1744538', '1738', 'Kirkland Signature Pate Wet Dog Food Variety Pack, 3.5 oz, 45-count', 'https://www.costco.com/.product.1744538.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1250582', '1738', 'Blue Buffalo Top Chews Pork & Chicken Sausage Dog Treats, 36 oz', 'https://www.costco.com/.product.1250582.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1101794', '1738', 'Kirkland Signature Nature''s Domain Puppy Formula Chicken & Pea Dog Food 20 lb.', 'https://www.costco.com/.product.1101794.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1899232', '1738', 'Temptations Cat Treats Variety Pack, 16 oz, 3-count', 'https://www.costco.com/.product.1899232.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1491066', '1738', 'Frontline Plus Flea and Tick Dog Treatment 45-88 lb, 7+1 Doses', 'https://www.costco.com/.product.1491066.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1344105', '1738', 'Blue Buffalo Life Protection Formula Chicken and Brown Rice Recipe Dog Food, 38 lbs', 'https://www.costco.com/.product.1344105.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1491063', '1738', 'Frontline Plus Flea and Tick Dog Treatment 23-44 lb, 7+1 Doses', 'https://www.costco.com/.product.1491063.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1491038', '1738', 'Frontline Plus Flea and Tick Dog Treatment 5-22 lb, 7+1 Doses', 'https://www.costco.com/.product.1491038.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('137423', '1738', 'Freshpet Deli Fresh Dog Food, Chicken Recipe, 6 lbs', 'https://www.costco.com/.product.137423.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1676442', '1738', 'Herodog Outer Armor Durable Dog Toys, 3-pack', 'https://www.costco.com/.product.1676442.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1491069', '1738', 'Frontline Plus Flea and Tick Dog Treatment 89-132 lb, 7+1 Doses', 'https://www.costco.com/.product.1491069.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1481907', '1738', 'Kirkland Signature Funhouse Treats, Variety Pack, 92 oz', 'https://www.costco.com/.product.1481907.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('705876', '1738', 'M&M''s, Snickers and More Chocolate Candy Bars, Variety Pack, 30-count', 'https://www.costco.com/.product.705876.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('320888', '1738', 'Hershey''s Assorted Bar Variety Pack, 30-count', 'https://www.costco.com/.product.320888.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1185317', '1738', 'Kellogg''s Rice Krispies Treats, 0.78 oz, 60-count', 'https://www.costco.com/.product.1185317.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2043945', '1738', 'Haribo Gummi Candy Happy Mix Variety Pack, 120-count', 'https://www.costco.com/.product.2043945.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('401621', '1738', 'Hershey''s Nuggets Assortment, Variety Pack, 145-count', 'https://www.costco.com/.product.401621.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1199479', '1738', 'M&M''s Chocolate Peanut, 62 oz', 'https://www.costco.com/.product.1199479.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('835671', '1738', 'Kirkland Signature Raisins, Milk Chocolate, 3.4 lbs', 'https://www.costco.com/.product.835671.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1700118', '1738', 'Skinny Dipped Cups, Dark Chocolate Peanut Butter, 30-count', 'https://www.costco.com/.product.1700118.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1685616', '1738', 'Kirkland Signature Milk Chocolate Covered Almonds, 48 oz', 'https://www.costco.com/.product.1685616.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1925186', '1738', 'Jojo''s Dark Chocolate Pistachio Almond Cranberry Bites, 14.4 oz', 'https://www.costco.com/.product.1925186.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1552446', '1738', 'Fruit By The Foot, Variety, 0.75 oz, 48-count', 'https://www.costco.com/.product.1552446.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('461', '1738', 'Toblerone Swiss Milk Chocolate Bar, 3.52 oz, 6-Count', 'https://www.costco.com/.product.461.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('401993', '1738', 'Hershey''s Kisses, Milk Chocolate, 56 oz, 330-count', 'https://www.costco.com/.product.401993.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1746847', '1738', 'Extra Sugar Free Chewing Gum, Mint Variety Pack, 15 Sticks, 18-Count', 'https://www.costco.com/.product.1746847.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('521658', '1738', 'Ferrero Rocher, Milk Chocolate Hazelnut Candy, 21.2 oz, 48 Count', 'https://www.costco.com/.product.521658.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1394792', '1738', 'Kinder Bueno Bars, 1.5 oz, 20-count', 'https://www.costco.com/.product.1394792.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2021527', '1738', 'Skinny Dipped Dark Chocolate Coconut Almond Bites, 30-count', 'https://www.costco.com/.product.2021527.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1644605', '1738', 'Lindt Lindor Chocolate Truffles, Assorted Flavors, 21.2 oz', 'https://www.costco.com/.product.1644605.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1053793', '1738', 'Healthy Choice Organic Fudge Bars, 3 fl oz, 18-count', 'https://www.costco.com/.product.1053793.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1415808', '1738', 'WestEnd Cuisine Grilled Chicken Skewers, Mediterranean Style, 2 oz, 14-count', 'https://www.costco.com/.product.1415808.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('447180', '1738', 'Kirkland Signature Beef Hot Dogs, 12 Links, 1.5 lbs, 3-count', 'https://www.costco.com/.product.447180.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('947880', '1738', 'Hillshire Farm Slow Roasted Turkey Breast, 16.5 oz, 2-count', 'https://www.costco.com/.product.947880.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1327763', '1738', 'Amylu Organic Chicken Burger with Caramelized Onion and Aged White Cheddar, 8-count', 'https://www.costco.com/.product.1327763.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('4860002', '1738', 'Kirkland Signature Uncured Black Forest Ham, 28 oz', 'https://www.costco.com/.product.4860002.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2079404', '1738', 'Bolder Foods Loaded Baked Potato Soup, 24 oz, 2-count', 'https://www.costco.com/.product.2079404.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('327081', '1738', 'Don Miguel Chipotle Chicken Mini Tacos, 35 oz', 'https://www.costco.com/.product.327081.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1380296', '1738', 'Amylu, Chicken Breakfast Sausage Links, 2.5 lbs', 'https://www.costco.com/.product.1380296.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1615853', '1738', 'Boulder Organic Chicken Wild Rice Soup, 24 oz, 2-count', 'https://www.costco.com/.product.1615853.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1231893', '1738', 'Greenridge Naturals Beef Snack Sticks, 3 oz, 12-count', 'https://www.costco.com/.product.1231893.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('337754', '1738', 'Royal Asia Vegetable Spring Rolls with Soy Ginger Sauce, 50-count', 'https://www.costco.com/.product.337754.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('990551', '1738', 'Kirkland Signature Imported Basil Pesto, 22 oz', 'https://www.costco.com/.product.990551.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1280819', '1738', 'Kirkland Signature Organic Hummus, 2.5 oz, 20-count', 'https://www.costco.com/.product.1280819.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('50550', '1738', 'Hebrew National 100% Kosher Beef Franks, 12 oz, 4-count, 28 Beef Franks Total', 'https://www.costco.com/.product.50550.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1603075', '1738', 'Perfect Bar Refrigerated Organic Protein Bar, Variety, 12-count', 'https://www.costco.com/.product.1603075.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1098785', '1738', 'Wildbrine Raw Organic Sauerkraut, 50 oz', 'https://www.costco.com/.product.1098785.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('222464', '1738', 'Petite Cuisine Mozzarella Sticks in a Crispy Seasoned Breading, 5 lb', 'https://www.costco.com/.product.222464.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1561556', '1738', 'Amylu Teriyaki Pineapple Chicken Meatballs, 46 oz', 'https://www.costco.com/.product.1561556.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1141000', '1738', 'Kirkland Signature Original Bratwurst, 14-count, 3.5 lbs', 'https://www.costco.com/.product.1141000.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1302599', '1738', 'Sabatino''s Paleo Organic Basil and Cracked Black Pepper Chicken Sausages, 36 oz', 'https://www.costco.com/.product.1302599.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2251987', '1738', 'Kirkland Signature Organic Roasted Pine Nut Hummus, 34 oz', 'https://www.costco.com/.product.2251987.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1433996', '1738', 'Stonefire Authentic Flatbreads Naan Dippers, 19.4 oz', 'https://www.costco.com/.product.1433996.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1735359', '1738', 'Kirkland Signature Mild Italian Sausage, 3.5 lbs', 'https://www.costco.com/.product.1735359.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('40532', '1738', 'Philadelphia Original Cream Cheese Spread, 48 oz', 'https://www.costco.com/.product.40532.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('6101960', '1738', 'Kirkland Signature Organic Spinach & Cheese Ravioli, 22 oz, 2-count', 'https://www.costco.com/.product.6101960.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1096018', '1738', 'Sabatasso''s Gluten-free Four-cheese Pizza, 17.5 oz, 3-count', 'https://www.costco.com/.product.1096018.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('951691', '1738', 'Sukhi''s Indian Chicken Tikka Masala Prepared Meal, 18 oz, 2-count', 'https://www.costco.com/.product.951691.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1644309', '1738', 'Kirkland Signature Wild Smoked Sockeye Salmon, 8 oz, 2-count', 'https://www.costco.com/.product.1644309.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1981743', '1738', 'Kirkland Signature Five Cheese Tortelloni, 24 oz, 2-count', 'https://www.costco.com/.product.1981743.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('7172015', '1738', 'Kirkland Signature Reduced Sodium Dry Salame, 16 oz, 2-count', 'https://www.costco.com/.product.7172015.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1775302', '1738', 'Kirkland Signature Parmesan Black Pepper & Parmesan Chicken Sausage, 3 lbs', 'https://www.costco.com/.product.1775302.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1624490', '1738', 'Giovanni Rana Beef and Short Rib Lasagna, 42 oz', 'https://www.costco.com/.product.1624490.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1365562', '1738', 'Fresh Additions Fully Cooked Chicken Breast Bites, 3.2 oz, 10-count', 'https://www.costco.com/.product.1365562.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1830081', '1738', 'Kirkland Signature Uncured Bacon and Gouda Egg Bites, 10-count', 'https://www.costco.com/.product.1830081.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1124028', '1738', 'Teton Waters Ranch Polish Sausage, 2.25 lbs', 'https://www.costco.com/.product.1124028.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1611040', '1738', 'Kirkland Signature Smoked Pulled Pork, Rubbed with Seasonings, 2 lbs', 'https://www.costco.com/.product.1611040.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1285362', '1738', 'Kirkland Signature Chunky Guacamole, Organic, 2.5 oz, 16-count', 'https://www.costco.com/.product.1285362.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1006856', '1738', 'Mama Mancini''s Jumbo Beef Meatballs, 48 oz', 'https://www.costco.com/.product.1006856.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1263833', '1738', 'Dietz & Watson Organic Roasted Turkey Breast, 9 oz, 3-count', 'https://www.costco.com/.product.1263833.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1239636', '1738', 'Good Foods Organic Avocado Mash, Sea Salt and Black Pepper, 2 oz, 16-count', 'https://www.costco.com/.product.1239636.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1777022', '1738', 'Pulmuone Teriyaki Stir-Fry Udon, 29.4 oz', 'https://www.costco.com/.product.1777022.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1830083', '1738', 'Kirkland Signature Egg White with Cheese Trio and Peppers Egg Bites, 10-count', 'https://www.costco.com/.product.1830083.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1845747', '1738', 'Sabatino''s Tuscan Style Chicken Piccata, 32 oz', 'https://www.costco.com/.product.1845747.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1793017', '1738', 'Jongga Sliced Napa Cabbage Kimchi, 52.9 oz', 'https://www.costco.com/.product.1793017.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('4054232', '1738', 'Kirkland Signature Coffee Organic Pacific Bold K-Cup Pod, 120-count', 'https://www.costco.com/.product.4054232.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('17767', '1738', 'Kirkland Signature Colombian Coffee, Dark Roast, 3 lbs', 'https://www.costco.com/.product.17767.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('4054238', '1738', 'Kirkland Signature Coffee Organic Breakfast Blend K-Cup Pod, 120-count', 'https://www.costco.com/.product.4054238.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('4054210', '1738', 'Kirkland Signature Coffee Organic Summit Roast K-Cup Pod, 120 count', 'https://www.costco.com/.product.4054210.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1660437', '1738', 'Folgers Classic Roast Ground Coffee, Medium, 43.5 oz', 'https://www.costco.com/.product.1660437.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('756053', '1738', 'Kirkland Signature Medium Roast Coffee, 40 oz', 'https://www.costco.com/.product.756053.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('3123235', '1738', 'Starbucks Pike Place Medium Roast Single Cup Coffee K-Cup Pod, 72-count', 'https://www.costco.com/.product.3123235.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('3123239', '1738', 'Starbucks French Roast Coffee, Dark, Keurig K-Cup Pods, 72 count', 'https://www.costco.com/.product.3123239.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('670441', '1738', 'Peet''s Coffee Major Dickason''s Blend Coffee, Dark Roast, Whole Bean, 2 lbs', 'https://www.costco.com/.product.670441.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1471986', '1738', 'Peet''s Organic Dark French Roast Ground Coffee, 32 oz', 'https://www.costco.com/.product.1471986.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('3818035', '1738', 'The Original Donut Shop Coffee K-Cup Pod, 80-count', 'https://www.costco.com/.product.3818035.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1726089', '1738', 'Kirkland Signature House Blend Whole Bean Coffee, Medium Roast, 2.5 lbs', 'https://www.costco.com/.product.1726089.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('46242', '1738', 'Kirkland Signature Decaffeinated Coffee, Dark Roast, 3 lbs', 'https://www.costco.com/.product.46242.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('120296', '1738', 'Kirkland Signature Colombian Supremo Coffee, Whole Bean, 3 lbs', 'https://www.costco.com/.product.120296.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1244454', '1738', 'NESCAFE Taster''s Choice Instant Coffee, House Blend, Light-Medium Roast, 14 oz', 'https://www.costco.com/.product.1244454.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('3365592', '1738', 'Caribou Coffee Caribou Blend K-Cup Pod, 80-count', 'https://www.costco.com/.product.3365592.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('3882772', '1738', 'Starbucks K-Cup Coffee Pods 72ct, Limited Edition Holiday Blend Medium Roast Coffee, 100% Arabica', 'https://www.costco.com/.product.3882772.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1956337', '1738', 'Nescafé Blonde Gold Instant Espresso, 7 oz', 'https://www.costco.com/.product.1956337.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('4054220', '1738', 'Kirkland Signature Coffee Organic French Roast K-Cup Pod, 120-count', 'https://www.costco.com/.product.4054220.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('437484', '1738', 'Lavazza Caffé Espresso 100% Premium Arabica Coffee, Whole Bean, 2.2 lbs', 'https://www.costco.com/.product.437484.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1528787', '1738', 'Kirkland Signature Whole Bean Coffee, French Roast, 2.5 lbs', 'https://www.costco.com/.product.1528787.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('541334', '1738', 'Nestlé Coffee-mate Powdered Creamer, Original, 56 oz', 'https://www.costco.com/.product.541334.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('8984865', '1738', 'Crafted Classics Coffee K-Cup Pod Variety Pack, 72ct K-Cup Pods', 'https://www.costco.com/.product.8984865.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1841924', '1738', 'La Colombe Draft Latte Cold Brew Coffee, Variety Pack, 9 fl oz, 12-count', 'https://www.costco.com/.product.1841924.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('6992988', '1738', 'Starbucks Coffee and Espresso Capsules for Nespresso Vertuo Machines 60-count Variety Pack, 100% Arabica Coffee', 'https://www.costco.com/.product.6992988.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2899021', '1738', 'Peet''s Coffee Major Dickason’s K-Cup Coffee Pods, 80-count', 'https://www.costco.com/.product.2899021.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('264266', '1738', 'Starbucks Mocha Frappuccino Chilled Coffee, 9.5 fl oz, 15-count', 'https://www.costco.com/.product.264266.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1191845', '1738', 'Stevia in the Raw Organic Stevia Blend, 22.57 oz', 'https://www.costco.com/.product.1191845.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1946730', '1738', 'Lavazza Dolcevita Classico 80-count K-Cup Pods', 'https://www.costco.com/.product.1946730.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1538864', '1738', 'Starbucks Caramel Macchiato Creamer, 58 fl oz', 'https://www.costco.com/.product.1538864.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1239519', '1738', 'Kirkland Signature Ultra Clean Free & Clear HE Liquid Laundry Detergent, 146 loads, 194 fl oz', 'https://www.costco.com/.product.1239519.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1239521', '1738', 'Kirkland Signature Ultra Clean HE Liquid Laundry Detergent, 146 loads, 194 fl oz', 'https://www.costco.com/.product.1239521.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2725160', '1738', 'Tide Pods Laundry Detergent Pods, Spring Meadow, 156-count', 'https://www.costco.com/.product.2725160.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1709318', '1738', 'Tide Ultra Concentrated Liquid Laundry Detergent, Original, 152 Loads, 170 fl oz', 'https://www.costco.com/.product.1709318.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('5247022', '1738', 'Tide Pods with Ultra Oxi Laundry Detergent Pods, 100-count', 'https://www.costco.com/.product.5247022.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1840548', '1738', 'Downy Soft Liquid Fabric Softener, April Fresh, 257 Loads, 150 fl oz', 'https://www.costco.com/.product.1840548.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2626431', '1738', 'Arm & Hammer Plus OxiClean Max HE Liquid Laundry Detergent, Fresh, 200 Loads, 200 fl oz', 'https://www.costco.com/.product.2626431.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('4873222', '1738', 'All Free & Clear Plus+ Liquid Laundry Detergent, 160 Loads, 200 fl oz', 'https://www.costco.com/.product.4873222.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('4160644', '1738', 'Gain +Oxi Liquid Laundry Detergent, Original, 159 Loads, 170 fl oz', 'https://www.costco.com/.product.4160644.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('3006152', '1738', 'Bounce Select a Size Fabric Softener Dryer Sheets, Outdoor Fresh, 400-count', 'https://www.costco.com/.product.3006152.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('5161251', '1738', 'Downy Unstopables In-wash Scent Booster Beads, Fresh, 39.9 oz', 'https://www.costco.com/.product.5161251.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2700048', '1738', 'Tide Pods Laundry Detergent Pods, Free & Gentle, 152-count', 'https://www.costco.com/.product.2700048.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1054838', '1738', 'Kirkland Signature Ultra Clean HE Laundry Detergent Pacs, 152-count', 'https://www.costco.com/.product.1054838.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1725830', '1738', 'Kirkland Signature Fabric Softener Sheets, 250 Sheets, 2-count', 'https://www.costco.com/.product.1725830.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1800219', '1738', 'Downy Ultimate Infusions In-Wash Scent Booster Beads, Whimsical Wonder, 24.5 oz', 'https://www.costco.com/.product.1800219.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('3160440', '1738', 'Tide Plus Advanced Power with Oxi Liquid Laundry Detergent, Original, 78 Loads, 138 fl oz', 'https://www.costco.com/.product.3160440.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('4160408', '1738', 'Tide Plus with Ultra Downy Liquid Laundry Detergent, April Fresh, 100 Loads, 128 fl oz', 'https://www.costco.com/.product.4160408.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('9675389', '1738', 'Tide Plus Ultra Oxi Powder Laundry Detergent, Original, 143 Loads, 225 oz', 'https://www.costco.com/.product.9675389.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2203187', '1738', 'Lysol Laundry Sanitizer, Crisp Linen, 150 fl oz', 'https://www.costco.com/.product.2203187.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2049492', '1738', 'All Free & Clear Plus+ Laundry Detergent Mighty Pacs, 118-count', 'https://www.costco.com/.product.2049492.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1889510', '1738', 'Kirkland Signature Powder Laundry Detergent, 200 Loads, 348.8 oz', 'https://www.costco.com/.product.1889510.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2045021', '1738', 'Kirkland Signature Ultra Soft Fabric Softener, 257 Loads, 150 fl oz', 'https://www.costco.com/.product.2045021.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1145682', '1738', 'Scotch-Brite Lint Roller, 95-count, 5-pack', 'https://www.costco.com/.product.1145682.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('4223955', '1738', 'Tide Advanced Care Liquid Laundry Detergent, Free & Gentle, 125 Loads, 154 fl oz', 'https://www.costco.com/.product.4223955.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2067029', '1738', 'Tide Pods Unstopables Laundry Detergent Pods, Fresh, 80-count', 'https://www.costco.com/.product.2067029.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1938239', '1738', 'Kevin''s Natural Foods Hawaiian Style Chicken, 32 oz', 'https://www.costco.com/.product.1938239.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1674070', '1738', 'Emergen-C 1000 mg Vitamin C Daily Immune Support Variety Pack Drink Mix, 120 Packets', 'https://www.costco.com/.product.1674070.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2025322', '1738', 'Grüns Adult Greens Gummies, 35 Daily Packs', 'https://www.costco.com/.product.2025322.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1485984', '1738', 'Fairlife Nutrition Plan, 30g Protein Shake, Chocolate, 11.5 fl oz, 18-pack', 'https://www.costco.com/.product.1485984.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('7161149', '1738', 'Philips Norelco All-in-One Electric Shaver and Trimmer with 24 Attachments', 'https://www.costco.com/.product.7161149.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1814790', '1738', 'Zena USDA Organic Supergreens Fruits & Vegetables Powder, 45 Stick Packets', 'https://www.costco.com/.product.1814790.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2007587', '1738', 'Harry''s Chrome Edition Razor Set 16 Cartridges + 1 Handle', 'https://www.costco.com/.product.2007587.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('135576', '1738', 'Zipfizz Multi-Vitamin Energy Hydration Drink Mix, Variety Pack, 30-count', 'https://www.costco.com/.product.135576.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1837002', '1738', 'Crest 3D Whitestrips 20 Professional Treatments with 10 Bonus Brightening Treatments', 'https://www.costco.com/.product.1837002.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1927215', '1738', 'Orgain, Micronized Creatine Monohydrate, Unflavored, 1.48lbs', 'https://www.costco.com/.product.1927215.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1303463', '1738', 'Vital Proteins Collagen Peptides, Unflavored, 1.5 lbs', 'https://www.costco.com/.product.1303463.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2032156', '1738', 'SmartyPants Kids Plus Multivitamin & Omegas, 180 Gummies', 'https://www.costco.com/.product.2032156.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('617686', '1738', 'Softsoap Advanced Clean Liquid Hand Soap Refill, 80 oz, 2-pack', 'https://www.costco.com/.product.617686.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1561475', '1738', 'CeraVe Moisturizing Cream Interchangeable Multi-Pack, 16 oz Jar with Pump + 16 oz Jar', 'https://www.costco.com/.product.1561475.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1446055', '1738', 'Nature''s Truth Organic Apple Cider Vinegar 500 mg., 120 Gummies', 'https://www.costco.com/.product.1446055.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2837566', '1738', 'Braun Series 9 Sport + Electric Shaver with Clean and Charge Station and Travel Case', 'https://www.costco.com/.product.2837566.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1985130', '1738', 'youtheory Concentrated Effect Verisol Collagen with Biotin, 345 Count', 'https://www.costco.com/.product.1985130.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1863995', '1738', 'TheraBreath Icy Mint Oral Rinse, 1 Liter, 2-pack', 'https://www.costco.com/.product.1863995.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1996641', '1738', 'Mrs. Meyer''s Hand Soap Clean Day Assortment, 16 fl oz, 4-pack', 'https://www.costco.com/.product.1996641.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2011581', '1738', 'Sharper Image Power Percussion Duo Max Deep Tissue Massager', 'https://www.costco.com/.product.2011581.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('3907391', '1738', 'Oral-B iO Series 2 Complete Clean Rechargeable Electric Toothbrush, 2-pack', 'https://www.costco.com/.product.3907391.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('667448', '1738', 'NeilMed Sinus Rinse Kit', 'https://www.costco.com/.product.667448.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1195611', '1738', 'Orgain Organic Protein and Superfoods Plant Based Protein Powder, Vanilla Bean, 2.7 lbs', 'https://www.costco.com/.product.1195611.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1060126', '1738', 'Terra Kai USDA Organic Juce Super Fruit & Veggie Powder, 12.2 oz', 'https://www.costco.com/.product.1060126.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1820576', '1738', 'eos Natural USDA Organic Lip Balm, 9 Sticks', 'https://www.costco.com/.product.1820576.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1702153', '1738', 'Crest Pro Health Advanced Toothpaste, 5.9 oz, 5-pack', 'https://www.costco.com/.product.1702153.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2021189', '1738', 'Olay Essential Botanical Body Wash, 23.6 fl oz, 3-pack', 'https://www.costco.com/.product.2021189.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2075676', '1738', 'Celsius Sparkling Energy Drink, Variety Pack, 12 fl oz, 18-count', 'https://www.costco.com/.product.2075676.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1742398', '1738', 'youtheory Ashwagandha 1000 mg, 180 Vegetarian Capsules', 'https://www.costco.com/.product.1742398.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2033364', '1738', 'OFF! Clean Feel Mosquito Repellent Picaridin DEET-free Bug Spray Set', 'https://www.costco.com/.product.2033364.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1252365', '1738', 'Ensure Original Nutrition Shake, Vanilla, 8 fl oz, 30-count', 'https://www.costco.com/.product.1252365.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1995727', '1738', 'Nello Supercalm Drink Mix, Variety Pack, 26-ct', 'https://www.costco.com/.product.1995727.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('886740', '1738', 'Weider Prime Testosterone Support, 120 Capsules', 'https://www.costco.com/.product.886740.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('778152', '1738', 'Kirkland Signature Hair Regrowth Treatment Minoxidil Foam for Men, 2.11 oz, 6-count', 'https://www.costco.com/.product.778152.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2049358', '1738', 'Liquid I.V. Hydration Multiplier, 30 Individual Serving Stick Packs in Resealable Pouch, Sugar Free, Variety Pack', 'https://www.costco.com/.product.2049358.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1654375', '1738', 'Neutrogena Rainbath Shower Gel, Original, 40 fl oz', 'https://www.costco.com/.product.1654375.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1121864', '1738', 'Neutrogena Rainbath Shower Gel, Ocean Mist, 40 fl oz', 'https://www.costco.com/.product.1121864.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('311676', '1738', 'Kirkland Signature Aller-Tec 10 mg Tablets, 365 count', 'https://www.costco.com/.product.311676.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1800413', '1738', 'Dove Advanced Care Invisible+ Deodorant, 2.6 oz, 4-pack', 'https://www.costco.com/.product.1800413.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1945057', '1738', 'Oikos 30g Protein Shake, Vanilla, 12 fl oz, 18-pack', 'https://www.costco.com/.product.1945057.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1243880', '1738', 'Optimum Nutrition Gold Standard 100% Whey Protein Powder, 5.64 lbs, Chocolate', 'https://www.costco.com/.product.1243880.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1324595', '1738', 'Lubriderm Daily Moisture Lotion, Fragrance Free 24 fl oz, 2-count + 6 fl oz Travel Size', 'https://www.costco.com/.product.1324595.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1243864', '1738', 'Optimum Nutrition Gold Standard 100% Whey Protein Powder, Vanilla Ice Cream, 5.47 lbs', 'https://www.costco.com/.product.1243864.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1932071', '1738', 'Liquid I.V. Hydration Multiplier, 30 Individual Serving Stick Packs in Resealable Pouch, Variety Pack', 'https://www.costco.com/.product.1932071.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2027490', '1738', 'Orgain 30g Ultra Filtered A2 Milk Protein Shake, Chocolate 11 fl oz, 15-count', 'https://www.costco.com/.product.2027490.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('897980', '1738', 'Kirkland Signature Children''s Multivitamin, 320 Gummies', 'https://www.costco.com/.product.897980.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('249375', '1738', 'Kirkland Signature Extra Strength Glucosamine with MSM, 375 Tablets', 'https://www.costco.com/.product.249375.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2017037', '1738', 'Orgain 35g Dairy Free Protein Shake, Creamy Chocolate 14 fl oz, 12-count', 'https://www.costco.com/.product.2017037.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1502205', '1738', 'Orgain Organic Protein and Superfoods Plant Based Protein Powder, Creamy Chocolate Fudge, 2.64 lbs', 'https://www.costco.com/.product.1502205.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('40310', '1738', 'Refresh Plus Lubricant Eye Drops', 'https://www.costco.com/.product.40310.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2054350', '1738', 'Crest 3D White Brilliant Mint Whitening Toothpaste, 5.2 oz, 5-pack', 'https://www.costco.com/.product.2054350.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1355176', '1738', 'Lumify Redness Reliever Eye Drops, 15 ml.', 'https://www.costco.com/.product.1355176.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1281762', '1738', 'Kirkland Signature Moisture Shampoo, 33.8 fl oz, 1-count', 'https://www.costco.com/.product.1281762.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1896208', '1738', 'Q-tips Cotton Swabs, 1875-count', 'https://www.costco.com/.product.1896208.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('536970', '1738', 'Natrol JuiceFestiv, 240 Capsules', 'https://www.costco.com/.product.536970.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1043487', '1738', 'Neosporin + Max Strength Pain Relief Dual Action Topical Antibiotic Ointment, 2 Ounces', 'https://www.costco.com/.product.1043487.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1711799', '1738', 'Kirkland Signature Extra Strength Energy Shot, 2 fl oz, 48-count', 'https://www.costco.com/.product.1711799.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('887498', '1738', 'Kirkland Signature Wild Alaskan Fish Oil 1400 mg, 230 Softgels', 'https://www.costco.com/.product.887498.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1017650', '1738', 'Kirkland Signature Triple Action Joint Health, 110 Coated Tablets', 'https://www.costco.com/.product.1017650.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2043904', '1738', 'Nello Superfocus Drink Mix, 26-ct, Variety Pack', 'https://www.costco.com/.product.2043904.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1148964', '1738', 'PreserVision AREDS2 Formula, 210 Soft Gels', 'https://www.costco.com/.product.1148964.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1226620', '1738', 'Pure Alaska Omega Wild Salmon Oil 1000 mg, 210 Softgels', 'https://www.costco.com/.product.1226620.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1810858', '1738', 'SENSODYNE Pronamel Gentle Whitening Advanced Toothpaste, 6.5 oz, 4-pack', 'https://www.costco.com/.product.1810858.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1940909', '1738', 'Kirkland Signature Daily Dry Facial Towels, 200-count', 'https://www.costco.com/.product.1940909.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1687275', '1738', 'Qunol Ultra CoQ10 100 mg, 180 Softgels', 'https://www.costco.com/.product.1687275.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2049359', '1738', 'Liquid I.V. Hydration Multiplier, 30 Individual Serving Stick Packs in Resealable Pouch, Sugar Free, Ring Pop Cherry', 'https://www.costco.com/.product.2049359.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('3399074', '1738', 'Oral-B iO Series 5 All-in-One Clean Rechargeable Electric Toothbrush, 2-pack', 'https://www.costco.com/.product.3399074.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('870735', '1738', 'Kirkland Signature Adult Multivitamin, 320 Gummies', 'https://www.costco.com/.product.870735.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1418060', '1738', 'Kirkland Signature Moisture Conditioner, 33.8 fl oz, 1-count', 'https://www.costco.com/.product.1418060.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2009618', '1738', 'MaryRuth''s Morning Multivitamin + Hair Growth, Peach Mango, 22 fl. oz., 2-pack', 'https://www.costco.com/.product.2009618.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('588153', '1738', 'Kirkland Signature Calcium Citrate, Magnesium and Zinc, 500 Tablets', 'https://www.costco.com/.product.588153.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1252372', '1738', 'Ensure Plus Nutrition Shake, Vanilla, 8 fl. oz, 30-pack', 'https://www.costco.com/.product.1252372.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1607417', '1738', 'Qunol Turmeric Plus Ginger, 200 Gummies, Tangerine', 'https://www.costco.com/.product.1607417.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1938952', '1738', 'Olay Regenerist 10 Niacinamide Moisturizer, 1.7 oz, 2-pack', 'https://www.costco.com/.product.1938952.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2076005', '1738', 'FEELGOOD Magnesium Glycinate, 180 Vegan Capsules', 'https://www.costco.com/.product.2076005.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('393914', '1738', 'Kirkland Signature Vitamin D3, 2000 IU, 600-count', 'https://www.costco.com/.product.393914.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2043018', '1738', 'Olay Daily Radiance Lotion Vitamin C + Niacinamide, 1.7 fl oz, 2-pack', 'https://www.costco.com/.product.2043018.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('926628', '1738', 'Kirkland Signature Omega-3 Fish Oil Concentrate 1000 mg, 400 Softgels', 'https://www.costco.com/.product.926628.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1816515', '1738', 'Osaki OS-3D Aspire Massage Chair, Brown', 'https://www.costco.com/.product.1816515.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1695152', '1738', 'Cetaphil Gentle Skin Cleanser, Dry to Normal Sensitive Skin, 20 fl oz, 2-count', 'https://www.costco.com/.product.1695152.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2049977', '1738', 'youtheory Total Body Turmeric, 90 Vegetarian Capsules', 'https://www.costco.com/.product.2049977.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2069070', '1738', 'Physician''s Choice Advanced 60 Billion Probiotic, 75 Capsules', 'https://www.costco.com/.product.2069070.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1998494', '1738', 'SuperBeets Heart Gummies, Strawberry, 150ct', 'https://www.costco.com/.product.1998494.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1968803', '1738', 'GUM Professional Clean Floss Picks, 150-count, 3-pack', 'https://www.costco.com/.product.1968803.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1397147', '1738', 'Kirkland Signature Bar Soap with Shea Butter, 15 Bars', 'https://www.costco.com/.product.1397147.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2068077', '1738', 'Fairlife Nutrition Plan, 30g Protein Shake, Vanilla, 11.5 fl oz, 18-pack', 'https://www.costco.com/.product.2068077.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1504495', '1738', 'Crest + Scope Cavity Protection Toothpaste, 8.2 oz, 5-pack', 'https://www.costco.com/.product.1504495.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('855643', '1738', 'Advil Liqui-Gels Ibuprofen 200 mg., Pain Reliever, Fever Reducer, 240 Liqui-Gel Capsules', 'https://www.costco.com/.product.855643.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1957813', '1738', 'Sports Research Multi Collagen, 180 Capsules', 'https://www.costco.com/.product.1957813.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2067452', '1738', 'Olay Advanced Repair Serum Body Wash, 35 fl oz, 2-pack', 'https://www.costco.com/.product.2067452.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1908287', '1738', 'Design Optics by Foster Grant, +2.00, #666 Classic Plastic Rectangle Reading Glasses, 3-pack', 'https://www.costco.com/.product.1908287.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1908284', '1738', 'Design Optics by Foster Grant, +1.25, #666 Classic Plastic Rectangle Reading Glasses, 3-pack', 'https://www.costco.com/.product.1908284.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1908286', '1738', 'Design Optics by Foster Grant, +1.75, #666 Classic Plastic Rectangle Reading Glasses, 3-pack', 'https://www.costco.com/.product.1908286.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1908290', '1738', 'Design Optics by Foster Grant, +3.00, #666 Classic Plastic Rectangle Reading Glasses, 3-pack', 'https://www.costco.com/.product.1908290.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1908288', '1738', 'Design Optics by Foster Grant, +2.50, #666 Classic Plastic Rectangle Reading Glasses, 3-pack', 'https://www.costco.com/.product.1908288.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1996833', '1738', 'Metamucil Fiber Gummies, 150 Gummies', 'https://www.costco.com/.product.1996833.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1089847', '1738', 'Metamucil Fiber Supplement, Orange Sugar Free, 260 Servings', 'https://www.costco.com/.product.1089847.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1069850', '1738', 'Salonpas Pain Relieving Patch, 140 Patches', 'https://www.costco.com/.product.1069850.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1366250', '1738', 'Kirkland Signature Liquid Body Wash, Natural Citrus, 27 fl oz, 2-count', 'https://www.costco.com/.product.1366250.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1698212', '1738', 'Nature Made Fish Oil, 1200mg, 300 Softgels', 'https://www.costco.com/.product.1698212.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1349614', '1738', 'Kirkland Signature OPTIFIBER, 26.8 Ounces, 190 Servings', 'https://www.costco.com/.product.1349614.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1692715', '1738', 'Qunol Magnesium Extra Strength 250 mg, 150 Gummies', 'https://www.costco.com/.product.1692715.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('864070', '1738', 'Nature Made Vitamin B12 1000 mcg, 400 Softgels', 'https://www.costco.com/.product.864070.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1674847', '1738', 'Sports Research Plant-Based D3 + K2, 160-count', 'https://www.costco.com/.product.1674847.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2063186', '1738', 'Kids Grüns Superfood Greens Strawberry Burst Flavored Gummies, 35 Daily Packs', 'https://www.costco.com/.product.2063186.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2067295', '1738', 'Native Body Wash Coconut & Vanilla, 34 fl oz, 2-pack', 'https://www.costco.com/.product.2067295.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2037453', '1738', 'Nurri 30g Protein Shake, Chocolate, 11 fl oz , 15-pack', 'https://www.costco.com/.product.2037453.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1810859', '1738', 'SENSODYNE Advanced Whitening Toothpaste, 6.5 oz, 4-pack', 'https://www.costco.com/.product.1810859.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1181284', '1738', 'Weider Red Yeast Rice Plus 1200 mg, 240 count', 'https://www.costco.com/.product.1181284.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2047386', '1738', 'Lume Whole Body Soft Powder Deodorant Set', 'https://www.costco.com/.product.2047386.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2007062', '1738', 'Premier Protein High Protein Chocolate Shake, 11 fl oz, 18-count', 'https://www.costco.com/.product.2007062.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1129909', '1738', 'Kirkland Signature LaxaClear, 100 Doses', 'https://www.costco.com/.product.1129909.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1014328', '1738', 'MiraLAX Powder Laxative, 68 Doses', 'https://www.costco.com/.product.1014328.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1931211', '1738', 'Kirkland Signature Micellar Facial Cleansing Wipes 180-count', 'https://www.costco.com/.product.1931211.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1972488', '1738', 'Oats Overnight Variety Pack, 30g Protein Shake, Fudge Brownie, Cookies & Cream, 14-pack', 'https://www.costco.com/.product.1972488.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('657187', '1738', 'Amlactin Moisturizing Body Lotion with 12% Lactic Acid, 20 oz', 'https://www.costco.com/.product.657187.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1408247', '1738', 'Trunature Ginkgo Biloba 120mg, 340 Softgels', 'https://www.costco.com/.product.1408247.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1106007', '1738', 'Nature''s Bounty Vitamin D3 125 mcg, 400 Softgels', 'https://www.costco.com/.product.1106007.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('383241', '1738', 'Kirkland Signature Extra Strength Acetaminophen 500 mg., 1000 Caplets', 'https://www.costco.com/.product.383241.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1516973', '1738', 'Gillette Ultimate Protection 6-in-1 Antiperspirant, 3.8 oz, 5-pack', 'https://www.costco.com/.product.1516973.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1694426', '1738', 'Orgain Collagen Peptides + Probiotics, Unflavored, 1.6 lbs', 'https://www.costco.com/.product.1694426.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1051972', '1738', 'Kirkland Signature Calcium 500 mg with D3 & Zinc, 240 Adult Gummies', 'https://www.costco.com/.product.1051972.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2052615', '1738', 'Zena Creatine + D3/K2 Gummies 180ct, Variety Pack', 'https://www.costco.com/.product.2052615.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1908880', '1738', 'Gillette Venus Ultra Smooth Razor, 11-count', 'https://www.costco.com/.product.1908880.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1737189', '1738', 'Neutrogena Hydro Boost Water Cream, 1.7 fl oz, 2-pack', 'https://www.costco.com/.product.1737189.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('529688', '1738', 'Kirkland Signature NonDrowsy AllerClear Antihistamine 10 mg., 365 Tablets', 'https://www.costco.com/.product.529688.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('9022010', '1738', 'Orgain USDA Organic Kids Nutritional Protein Shake, Chocolate, 8 fl oz, 24-pack', 'https://www.costco.com/.product.9022010.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('580664', '1738', 'Nature Made Prenatal Folic Acid + DHA, 150 Softgels', 'https://www.costco.com/.product.580664.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1820336', '1738', 'Kirkland Signature Turmeric 1000 mg, 320 Vegetarian Capsules', 'https://www.costco.com/.product.1820336.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1811598', '1738', 'Head & Shoulders 2-in-1 Dandruff Shampoo and Conditioner Advanced Scalp Care, 40 fl oz', 'https://www.costco.com/.product.1811598.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1667705', '1738', 'Ascent 100% Whey, Native Whey Protein Blend, Vanilla Bean, 4.25 lbs', 'https://www.costco.com/.product.1667705.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1174112', '1738', 'Kirkland Signature USDA Organic Multivitamin, 80 Coated Tablets', 'https://www.costco.com/.product.1174112.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1798586', '1738', 'eos Super Balm 24 Hour Moisture, 5 Tubes', 'https://www.costco.com/.product.1798586.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('685586', '1738', 'Listerine UltraClean Coolmint Mouthwash, 1.5 Liter, 2-count', 'https://www.costco.com/.product.685586.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1421932', '1738', 'Dove Moisturizing Beauty Bar Soap Original, 3.75 oz, 16-count', 'https://www.costco.com/.product.1421932.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('690843', '1738', 'Kirkland Signature Quick Dissolve B-12 5000 mcg, 300 Tablets', 'https://www.costco.com/.product.690843.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1991771', '1738', 'Sports Research Advanced Multivitamin, 180 Veggie Capsules', 'https://www.costco.com/.product.1991771.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2037515', '1738', 'Nurri 30g Protein Shake, Vanilla, 11 fl oz, 15-pack', 'https://www.costco.com/.product.2037515.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2075999', '1738', 'FEELGOOD NAD+ NMN, 120 Vegan Capsules', 'https://www.costco.com/.product.2075999.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1731104', '1738', 'Crest Pro-Health Advanced Mouthwash, 33.8 fl oz, 3-pack', 'https://www.costco.com/.product.1731104.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('529110', '1738', 'Refresh Tears Lubricant Eye Drops Multi-Pack, 65 ml.', 'https://www.costco.com/.product.529110.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1953411', '1738', 'Old Spice Swagger Scent Boosted Aluminum Free Deodorant, 3 oz, 4-pack', 'https://www.costco.com/.product.1953411.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2036501', '1738', 'Nordic Naturals Omega Mini Fish Oil, 110 Mini Softgels, Lemon Flavor', 'https://www.costco.com/.product.2036501.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1962753', '1738', 'Qunol Brain Health Memory Plus, 100 Count', 'https://www.costco.com/.product.1962753.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2048096', '1738', 'Genius Gourmet Sparkling Clear 30g Protein Variety Pack, 12 fl oz, 15-pack', 'https://www.costco.com/.product.2048096.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('4640862', '1738', 'Philips Norelco Shaver 9000, Wet & Dry Electric Shaver, with SenseIQ', 'https://www.costco.com/.product.4640862.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('664635', '1738', 'Swisspers Premium Hypoallergenic Cotton Rounds, 900-count', 'https://www.costco.com/.product.664635.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1763447', '1738', 'Emergen-C Immune+ 1000 mg Vitamin C + Vitamin D & Zinc, 90 Packets', 'https://www.costco.com/.product.1763447.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1966263', '1738', 'Olay Every Night Retinol, 1.7 oz, 2-pack', 'https://www.costco.com/.product.1966263.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2007063', '1738', 'Premier Protein Vanilla High Protein Shake, 11 fl oz, 18-count', 'https://www.costco.com/.product.2007063.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1308590', '1738', 'Nature Made Extra Strength Magnesium 400 mg, 180 Softgels', 'https://www.costco.com/.product.1308590.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2037748', '1738', 'Icy Hot Lidocaine Roll On, 3 pack, 6.5 fl oz Total', 'https://www.costco.com/.product.2037748.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1316229', '1738', 'Biotrue Multi-Purpose Solution, 34 Ounces', 'https://www.costco.com/.product.1316229.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2037470', '1738', 'Nurri 30g Protein Shake, Coffee, 11 fl oz, 15-pack', 'https://www.costco.com/.product.2037470.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2032153', '1738', 'Tree Hut Body Scrub, Vanilla and Coco Colada, 21 fl oz, 2-pack', 'https://www.costco.com/.product.2032153.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('987677', '1738', 'Kirkland Signature Aller-Fex 180mg, 180 Tablets', 'https://www.costco.com/.product.987677.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1699741', '1738', 'Gillette Venus ComfortGlide Essential Botanicals, 1 Razor + 12 Cartridges Gel', 'https://www.costco.com/.product.1699741.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1481822', '1738', 'Allegra Allergy Non-Drowsy, 110 Tablets', 'https://www.costco.com/.product.1481822.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2070165', '1738', 'Native Moisturizing Lotion Coconut & Vanilla, 23 fl oz, 2-pack', 'https://www.costco.com/.product.2070165.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1695130', '1738', 'Cetaphil Moisturizing Lotion, Dry to Normal Sensitive Skin, 20 fl oz, 2-count', 'https://www.costco.com/.product.1695130.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('98501', '1738', 'Kirkland Signature Chewable Vitamin C 500 mg, 500 Tablets', 'https://www.costco.com/.product.98501.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1421933', '1738', 'Dove Moisturizing Beauty Bar Soap Sensitive Skin, 3.75 oz, 16 Bars', 'https://www.costco.com/.product.1421933.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1928295', '1738', 'Dove Deep Moisture Body Wash, 23 fl oz, 3-pack', 'https://www.costco.com/.product.1928295.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('864024', '1738', 'Nature Made CoQ10 200 mg, 140 Softgels', 'https://www.costco.com/.product.864024.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2007064', '1738', 'Premier Protein High Protein Café Latte Shake, 11 fl oz, 18-count', 'https://www.costco.com/.product.2007064.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1492769', '1738', 'Gillette Venus Sensitive Plus Disposable Razor, 15-count', 'https://www.costco.com/.product.1492769.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1458438', '1738', 'GUM Soft-Picks Advanced Mint, 180-count', 'https://www.costco.com/.product.1458438.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1140422', '1738', 'Kirkland Signature Esomeprazole 20 mg, 42 count', 'https://www.costco.com/.product.1140422.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1102928', '1738', 'Centrum Silver Adults 50+, 325 Tablets', 'https://www.costco.com/.product.1102928.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1875033', '1738', 'ROC Advanced Hydration + Water Cream, 1.7 oz, 2-pack', 'https://www.costco.com/.product.1875033.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1587186', '1738', 'Gillette Proglide Plus Razor Cartridge Refills, 16-count', 'https://www.costco.com/.product.1587186.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1796097', '1738', 'FEELGOOD Berberine Phytosome, 120 Vegan Capsules', 'https://www.costco.com/.product.1796097.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2027551', '1738', 'Muscle Milk 33g Protein Ultra-Filtered Milk Shake, Cookies ''N Crème, 11 fl oz, 18-pack', 'https://www.costco.com/.product.2027551.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1888647', '1738', 'Sports Research L-Theanine Suntheanine 200 mg, 150 Softgels', 'https://www.costco.com/.product.1888647.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1562786', '1738', 'Children''s Tylenol Liquid Pain Relief & Fever Medicine, Dye-Free Cherry Flavor, 12 Fluid Ounces', 'https://www.costco.com/.product.1562786.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2077790', '1738', 'Grüns Immün Daily Defense 13-in-1 Sour Pineapple Gummies, 35 Daily Packs', 'https://www.costco.com/.product.2077790.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1209115', '1738', 'Qunol Liquid Turmeric 1000 mg, 30.4 fl oz', 'https://www.costco.com/.product.1209115.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1968128', '1738', 'youtheory Ashwagandha, 180 Gummies, Mixed Berry Flavor', 'https://www.costco.com/.product.1968128.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1561942', '1738', 'Nasacort Allergy 24 HR, 480 Metered Sprays', 'https://www.costco.com/.product.1561942.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1729692', '1738', 'Nature''s Bounty Optimal Solutions Hair Growth, 90 Capsules', 'https://www.costco.com/.product.1729692.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1753490', '1738', 'Aveeno Daily Moisture Lotion, 24 fl oz, 2-pack', 'https://www.costco.com/.product.1753490.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('355476', '1738', 'Kirkland Signature Extra Strength Acetaminophen 500 mg., 400 Gelcaps', 'https://www.costco.com/.product.355476.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1683859', '1738', 'Sports Research Triple Strength Omega-3 Fish Oil, 150 Fish Softgels', 'https://www.costco.com/.product.1683859.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1285702', '1738', 'Colgate Total Active Prevention Plus Advanced Whitening Toothpaste, 6.4 oz, 5-pack', 'https://www.costco.com/.product.1285702.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('402146', '1738', 'Nature''s Way Joint Movement Glucosamine Extra Strength, 33.8 Fluid Ounces', 'https://www.costco.com/.product.402146.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2007065', '1738', 'Premier Protein High Protein Strawberries & Cream Shake, 11 fl oz, 18-count', 'https://www.costco.com/.product.2007065.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1548657', '1738', 'Florastor Daily Probiotic with Vitamin D3, 120 Vegetarian Capsules', 'https://www.costco.com/.product.1548657.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1806584', '1738', 'Gillette Custom Plus3 Disposable Razors Sensitive, 30-count', 'https://www.costco.com/.product.1806584.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1886106', '1738', 'Oral-B Glide Advanced Deep Clean Floss, 6-pack', 'https://www.costco.com/.product.1886106.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1082839', '1738', 'FITCRUNCH Protein Bars, 16g Protein, Chocolate Peanut Butter, 1.62 oz, 18-count', 'https://www.costco.com/.product.1082839.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1086592', '1738', 'Kirkland Signature Acid Controller 20 mg, 250-count', 'https://www.costco.com/.product.1086592.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1351728', '1738', 'trunature Cinnamon Concentrate Cinsulin 500mg, 200 Vegetarian Capsules', 'https://www.costco.com/.product.1351728.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('370945', '1738', 'Ocuvite Eye Vitamin Adult 50+ Formula, 150 Soft Gels', 'https://www.costco.com/.product.370945.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('536672', '1738', 'Nature''s Bounty Fish Oil 1,400 mg, 130 Coated Softgels', 'https://www.costco.com/.product.536672.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1975676', '1738', 'Dove Sensitive Body Wash, 23 fl oz, 3-pack', 'https://www.costco.com/.product.1975676.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1116624', '1738', 'Schiff Move Free Advanced Joint Supplement, 200 Tablets', 'https://www.costco.com/.product.1116624.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('654260', '1738', 'Natrol Melatonin 5 mg Fast Dissolve Tablets, 250 Tablets', 'https://www.costco.com/.product.654260.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('389194', '1738', 'Kirkland Signature Calcium 600 mg + D3, 500-count', 'https://www.costco.com/.product.389194.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1274751', '1738', 'One A Day Men''s 50+ Multivitamin Tablets, 300 count', 'https://www.costco.com/.product.1274751.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1369089', '1738', 'Voltaren Arthritis Pain Gel, 12.34 Ounces', 'https://www.costco.com/.product.1369089.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('989874', '1738', 'Caltrate 600 + D3 Plus Minerals Tablets, 320-count', 'https://www.costco.com/.product.989874.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2076158', '1738', 'FEELGOOD Glutathione Phytosome 120 Vegan Capsules', 'https://www.costco.com/.product.2076158.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1665191', '1738', 'Kirkland Signature Glucosamine & Chondroitin, 280 Tablets', 'https://www.costco.com/.product.1665191.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1957823', '1738', 'Sports Research Vitamin B Complex, 180 Veggie Soft Gels', 'https://www.costco.com/.product.1957823.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2007527', '1738', 'Vital Proteins Collagen Gummies, Raspberry 256 Count', 'https://www.costco.com/.product.2007527.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1089974', '1738', 'Xyzal Allergy 24 Hour Antihistamine 5 mg, 110 Tablets', 'https://www.costco.com/.product.1089974.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1320303', '1738', 'Centrum Silver Men 50+ Immune Support Multivitamin, 275 Tablets', 'https://www.costco.com/.product.1320303.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1563168', '1738', 'Children''s Motrin Dye-Free Berry Flavor Suspension, Fever Reducer & Pain Relief, 12 Fluid Ounces', 'https://www.costco.com/.product.1563168.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('4748527', '1738', 'Homedics SereneScent Ceramic Diffuser Set', 'https://www.costco.com/.product.4748527.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2040581', '1738', 'OSAKI 3D QUEST BEIGE MODEL EC-1616 PLT1', 'https://www.costco.com/.product.2040581.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2028787', '1738', 'Poise Advanced Ultimate Absorbency Incontinence and Postpartum Long Pads, 108-Count', 'https://www.costco.com/.product.2028787.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1197931', '1738', 'Osteo Bi-Flex Triple Strength, 200 Tablets', 'https://www.costco.com/.product.1197931.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2056983', '1738', 'Force Factor Hair Growth Accelerator, 90-count', 'https://www.costco.com/.product.2056983.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2032764', '1738', 'Dove Men +Care Body & Face Wash, 32 fl oz, 2-pack', 'https://www.costco.com/.product.2032764.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1719200', '1738', 'Country Farms Fiber Care Gummies, 240 Gummies', 'https://www.costco.com/.product.1719200.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1875027', '1738', 'Refresh Optive MEGA-3 Preservative-Free Lubricating Eye Drop, 70 Vials', 'https://www.costco.com/.product.1875027.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1886852', '1738', 'Sports Research Magtein Magnesium L-Threonate, 2000 mg, 135 Veggie Capsules', 'https://www.costco.com/.product.1886852.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1105926', '1738', 'Nature''s Bounty B-12 2500 mcg, 300 Quick Dissolve Tablets', 'https://www.costco.com/.product.1105926.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('555744', '1738', 'Glucerna Original Diabetic Nutrition Shake, 8 fl oz, 24-pack, Vanilla', 'https://www.costco.com/.product.555744.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1906773', '1738', 'OLLY Women''s Multivitamin Gummy, 200 Gummies', 'https://www.costco.com/.product.1906773.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2077334', '1738', 'Mucinex 12HR Cold & Fever Multi-Symptom, 50 Extended Release Tablets', 'https://www.costco.com/.product.2077334.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2025437', '1738', 'Force Factor Total Beets Chews, 90 Soft Chews', 'https://www.costco.com/.product.2025437.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('691740', '1738', 'Ricola Sugar Free Lemon Mint Cough Drops, 210 Drops', 'https://www.costco.com/.product.691740.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2038523', '1738', 'Garden of Life Advanced Women''s Daily Probiotic, 60 Capsules', 'https://www.costco.com/.product.2038523.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1274752', '1738', 'One A Day Women''s 50+ Multivitamin Tablets, 300-count', 'https://www.costco.com/.product.1274752.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('853467', '1738', 'One A Day Men''s Multivitamin, 300 Tablets', 'https://www.costco.com/.product.853467.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('83829', '1738', 'Tylenol 8 Hour Arthritis & Joint Pain Extended-Release Acetaminophen 650 mg, 290 Caplets', 'https://www.costco.com/.product.83829.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1241036', '1738', 'Nature''s Truth Apple Cider Vinegar 1200 mg, 180 Capsules', 'https://www.costco.com/.product.1241036.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1199824', '1738', 'Nature Made CholestOFF Plus, 210 Softgels', 'https://www.costco.com/.product.1199824.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1917880', '1738', 'Salonpas LIDOCAINE 4% Pain Relieving Gel-Patch, 30 Patches', 'https://www.costco.com/.product.1917880.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1233864', '1738', 'Nature Made Magnesium Citrate 250 mg., 180 Softgels', 'https://www.costco.com/.product.1233864.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1176584', '1738', 'Qunol Liquid CoQ10 100 mg., 30.4 Fluid Ounces', 'https://www.costco.com/.product.1176584.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1813019', '1738', 'Neuriva Brain Supplement Original, 50 Capsules', 'https://www.costco.com/.product.1813019.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1965989', '1738', 'Aveeno Skin Relief Body Wash, 18 fl oz, 3-pack', 'https://www.costco.com/.product.1965989.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1616284', '1738', 'Irish Spring Bar Soap, 4.5 oz, 20-count', 'https://www.costco.com/.product.1616284.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('869100', '1738', 'vitafusion Women''s Multivitamin, 220 Gummies', 'https://www.costco.com/.product.869100.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('808620', '1738', 'Citracal Maximum Plus Calcium Citrate + D3, 280 Caplets', 'https://www.costco.com/.product.808620.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('935195', '1738', 'Ultra Strength BENGAY, Non-Greasy Topical Pain Relieving Cream, 8 Ounces', 'https://www.costco.com/.product.935195.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('238120', '1738', 'Kirkland Signature Super B-Complex with Electrolytes, 500 Tablets', 'https://www.costco.com/.product.238120.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('553486', '1738', 'Nature''s Bounty Optimal Solutions Hair, Skin and Nails, 250 Softgels', 'https://www.costco.com/.product.553486.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('561532', '1738', 'Kirkland Signature Fast Acting Lactase, 180 Caplets', 'https://www.costco.com/.product.561532.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1830585', '1738', 'Airborne Gummy Immune Support Supplement, 90 Gummies', 'https://www.costco.com/.product.1830585.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1998559', '1738', 'Natrol Melatonin 10mg Gummies, 200ct', 'https://www.costco.com/.product.1998559.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1644223', '1738', 'Nature''s Bounty Magnesium Glycinate 240 mg, 180 Capsules', 'https://www.costco.com/.product.1644223.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2036982', '1738', 'MiraFAST Soft Chews Pouch, 100 Soft Chews', 'https://www.costco.com/.product.2036982.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1428912', '1738', 'Zyrtec 24 Hour Allergy Relief Antihistamine Cetirizine HCl 10 mg, 120 Tablets', 'https://www.costco.com/.product.1428912.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1578895', '1738', 'Band-Aid Adhesive Bandages, Assorted, 198-count', 'https://www.costco.com/.product.1578895.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1327667', '1738', 'Nature Made CoQ10 400 mg, 90 Softgels', 'https://www.costco.com/.product.1327667.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1169865', '1738', 'Nature Made Super C with Vitamin D3 and Zinc, 200 Tablets', 'https://www.costco.com/.product.1169865.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1842854', '1738', 'Tampax Pearl Advanced Duopack, 87-count', 'https://www.costco.com/.product.1842854.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('561527', '1738', 'Kirkland Signature Psyllium Fiber Sugar-Free Powder, 2x180 Teaspoons', 'https://www.costco.com/.product.561527.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1987193', '1738', 'Aleve Naproxen Sodium 220 mg Pain Reliever, Fever Reducer, 180 Liquid Gel Capsules', 'https://www.costco.com/.product.1987193.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('594518', '1738', 'Culturelle Digestive Health Probiotic, 80 Vegetarian Capsules', 'https://www.costco.com/.product.594518.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1816477', '1738', 'Schiff Digestive Advantage Probiotic, 120 Gummies', 'https://www.costco.com/.product.1816477.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('572310', '1738', 'Nature Made Vitamin D3 25 mcg, 650 Softgels', 'https://www.costco.com/.product.572310.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1398241', '1738', 'Nature''s Way Sambucus Elderberry with Vitamin C and Zinc, 120 Gummies', 'https://www.costco.com/.product.1398241.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1811669', '1738', 'Benefiber Fiber Supplement Powder, 410 Teaspoons', 'https://www.costco.com/.product.1811669.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1478260', '1738', 'Nature''s Bounty Hair, Skin and Nails Advanced, 230 Gummies', 'https://www.costco.com/.product.1478260.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1987084', '1738', 'Chirp Contour Decompression and Massage Roller Table with Additional Roller Set', 'https://www.costco.com/.product.1987084.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1332345', '1738', 'Natural Vitality Calm Magnesium Citrate Powder, 20 Ounces', 'https://www.costco.com/.product.1332345.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1991797', '1738', 'Sports Research Vitamin C Liposomal, 1000 mg, 180 Veggie Capsules', 'https://www.costco.com/.product.1991797.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1003144', '1738', 'Schiff Move Free Ultra Triple Action Joint Supplement, 75 Tablets', 'https://www.costco.com/.product.1003144.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1613181', '1738', 'Degree Men UltraClear+ Antiperspirant Deodorant, Black & White, 2.7 oz, 5-pack', 'https://www.costco.com/.product.1613181.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1747557', '1738', 'Systane Complete Preservative Free Lubricant Drops, 30ml', 'https://www.costco.com/.product.1747557.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1187500', '1738', 'trunature Advanced Digestive Probiotic, 100 Capsules', 'https://www.costco.com/.product.1187500.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1697407', '1738', 'TUMS Chewy Bites, 108ct', 'https://www.costco.com/.product.1697407.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('98268', '1738', 'Kirkland Signature Vitamin C 1000 mg, 500 Tablets', 'https://www.costco.com/.product.98268.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1991633', '1738', 'Sports Research CoQ10 200mg, 150ct', 'https://www.costco.com/.product.1991633.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1347960', '1738', 'Claritin RediTabs 10 mg 24 Hour Non-Drowsy, 70 Disintegrating Tablets', 'https://www.costco.com/.product.1347960.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1812167', '1738', 'Qunol Turmeric 1,500 mg., 220 Capsules', 'https://www.costco.com/.product.1812167.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2059615', '1738', 'Neuro Energy & Focus Gum, Peppermint and Spearmint, 12-packs, 72 Total Pieces', 'https://www.costco.com/.product.2059615.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1486041', '1738', 'Estroven Complete Multi-Symptom Menopause Relief, 84 Caplets', 'https://www.costco.com/.product.1486041.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1992278', '1738', 'Sports Research Omega-3 Krill Oil Superba2 1000mg, 90ct Softgels', 'https://www.costco.com/.product.1992278.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1908250', '1738', 'Design Optics by Foster Grant, +1.25, #668 Metal Square Reading Glasses, 3-pack', 'https://www.costco.com/.product.1908250.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1908251', '1738', 'Design Optics by Foster Grant, +1.50, #668 Metal Square Reading Glasses, 3-pack', 'https://www.costco.com/.product.1908251.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1908254', '1738', 'Design Optics by Foster Grant, +2.50, #668 Metal Square Reading Glasses, 3-pack', 'https://www.costco.com/.product.1908254.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1908252', '1738', 'Design Optics by Foster Grant, +1.75, #668 Metal Square Reading Glasses, 3-pack', 'https://www.costco.com/.product.1908252.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1908253', '1738', 'Design Optics by Foster Grant, +2.00, #668 Metal Square Reading Glasses, 3-pack', 'https://www.costco.com/.product.1908253.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('598848', '1738', 'Kirkland Signature Psyllium Fiber, 720 Capsules', 'https://www.costco.com/.product.598848.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1368591', '1738', 'Always Ultra Thin Advanced Overnight Pads, 76-count', 'https://www.costco.com/.product.1368591.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('644585', '1738', 'trunature Prostate Plus Health Complex, 250 Softgels', 'https://www.costco.com/.product.644585.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1392697', '1738', 'Nature''s Bounty Sleep3 10 mg. Melatonin, 120 Tablets', 'https://www.costco.com/.product.1392697.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('681272', '1738', 'trunature Vision Complex Lutein & Zeaxanthin, 140 Softgels', 'https://www.costco.com/.product.681272.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('853472', '1738', 'One A Day Women''s Multivitamin, 300 Tablets', 'https://www.costco.com/.product.853472.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('901165', '1738', 'Arm & Hammer Simply Saline Nasal Mist, 13.5 Ounces', 'https://www.costco.com/.product.901165.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1476391', '1738', 'Nature''s Bounty Immune 24 Hour +, 120 Softgels', 'https://www.costco.com/.product.1476391.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1320304', '1738', 'Centrum Silver Women 50+ Immune Support Multivitamin, 275 Tablets', 'https://www.costco.com/.product.1320304.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1930184', '1738', 'Flents Wipe ''N Clear Lens Wipes, 4 Boxes, 75 Wipes Each', 'https://www.costco.com/.product.1930184.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('580655', '1738', 'Nature Made Super B-Complex, 460 Tablets', 'https://www.costco.com/.product.580655.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1590808', '1738', 'Pataday Extra Strength Once Daily Antihistamine Eye Drops, 7.5 ml', 'https://www.costco.com/.product.1590808.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2023727', '1738', 'Once Upon a Farm Organic Immunity Blends Variety Pack, 3.2 fl oz, 12-count', 'https://www.costco.com/.product.2023727.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1586629', '1738', 'Kirkland Signature Aller-Flo 50 mcg Allergy Spray, 720 Metered Sprays', 'https://www.costco.com/.product.1586629.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('572220', '1738', 'Nature Made Iron, 65 mg, 365 Tablets', 'https://www.costco.com/.product.572220.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('720393', '1738', 'Excedrin Migraine for Migraine Relief, 300 Caplets', 'https://www.costco.com/.product.720393.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1235761', '1738', 'trunature Cranberry 650 mg, 140 Vegetarian Capsules', 'https://www.costco.com/.product.1235761.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1214224', '1738', 'Clear Care Plus Cleaning & Disinfecting Solution, 32 Fluid Ounces', 'https://www.costco.com/.product.1214224.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1669785', '1738', 'Kirkland Signature Omeprazole 20 mg., 42 Tablets', 'https://www.costco.com/.product.1669785.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('942620', '1738', 'vitafusion Men''s Multivitamin Gummies, 220 Gummies', 'https://www.costco.com/.product.942620.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('504882', '1738', 'Tylenol Extra Strength Acetaminophen 500 mg, Pain & Fever Relief, 290 Rapid Release Gelcap Tablets', 'https://www.costco.com/.product.504882.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('573854', '1738', 'Qunol Mega CoQ10 100 mg., 120 Softgels', 'https://www.costco.com/.product.573854.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2008132', '1738', 'Always Infinity FlexFoam Pads, 72-count', 'https://www.costco.com/.product.2008132.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('851753', '1738', 'Nexium 24HR Acid Reducer 20 mg., 42 Capsules', 'https://www.costco.com/.product.851753.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1908257', '1738', 'Design Optics by Foster Grant, +1.25, #811 Fashion Cateye Reading Glasses, 3-pack', 'https://www.costco.com/.product.1908257.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1908267', '1738', 'Design Optics by Foster Grant, +2.50, #811 Fashion Cateye Reading Glasses, 3-pack', 'https://www.costco.com/.product.1908267.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1908258', '1738', 'Design Optics by Foster Grant, +1.50, #811 Fashion Cateye Reading Glasses, 3-pack', 'https://www.costco.com/.product.1908258.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1908259', '1738', 'Design Optics by Foster Grant, +1.75, #811 Fashion Cateye Reading Glasses, 3-pack', 'https://www.costco.com/.product.1908259.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1908260', '1738', 'Design Optics by Foster Grant, +2.00, #811 Fashion Cateye Reading Glasses, 3-pack', 'https://www.costco.com/.product.1908260.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1585071', '1738', 'Claritin 10 mg Non-Drowsy 24 Hour, 115 Tablets', 'https://www.costco.com/.product.1585071.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1231411', '1738', 'Pepto Bismol Ultra, 5 Symptom Digestive Relief Liquid, 36 Fluid Ounces', 'https://www.costco.com/.product.1231411.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1469910', '1738', 'Biofreeze Pain Reliever, 6 Fluid Ounce Pack', 'https://www.costco.com/.product.1469910.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1423302', '1738', 'trunature Women''s Daily Probiotic, 90 Vegetarian Capsules', 'https://www.costco.com/.product.1423302.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1259303', '1738', 'Vicks Severe DayQuil and NyQuil Cough, Cold & Flu Relief, 72 LiquiCaps', 'https://www.costco.com/.product.1259303.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2080753', '1738', 'TUMS CHEWY BITES ASSORTED WNTRMNT VNL CRM T9H6MPK20', 'https://www.costco.com/.product.2080753.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('502046', '1738', 'Zyrtec 24 Hour Allergy Relief Antihistamine Cetirizine HCl 10 mg, 65 Liquid Gels', 'https://www.costco.com/.product.502046.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1220987', '1738', 'Breathe Right Extra Strength Nasal Strips, Clear, 72 count', 'https://www.costco.com/.product.1220987.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1220988', '1738', 'Breathe Right Extra Strength Nasal Strips, Tan, 72 count', 'https://www.costco.com/.product.1220988.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2001199', '1738', 'Ritual Prenatal Multivitamin, 120 Capsules', 'https://www.costco.com/.product.2001199.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1882051', '1738', 'Kirkland Signature Mini Ibuprofen, 200 mg, 500 Liquid-Filled Capsules', 'https://www.costco.com/.product.1882051.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1813892', '1738', 'Nature Made Extra Strength Vitamin D3 125 mcg, 200 Gummies', 'https://www.costco.com/.product.1813892.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1566060', '1738', 'Mucinex Children''s Multi-Symptom Day/Nighttime, 12 oz', 'https://www.costco.com/.product.1566060.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1904353', '1738', 'Colgate Bluey Toothbrush, 6-count', 'https://www.costco.com/.product.1904353.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2052093', '1738', 'FeelGood Creatine+, 120 Capsules', 'https://www.costco.com/.product.2052093.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('352457', '1738', 'MedMassager Body Massager', 'https://www.costco.com/.product.352457.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2034508', '1738', 'Bayer Aspirin Regimen Low Dose 81 mg., 365 Enteric Coated Tablets', 'https://www.costco.com/.product.2034508.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('482358', '1738', 'Tylenol PM Extra Strength Acetaminophen 500 mg Pain Reliever, Sleep Aid, 225 Caplets', 'https://www.costco.com/.product.482358.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1862992', '1738', 'Pepto Bismol Chews, Berry Mint Flavor, 70 Chewable Tablets', 'https://www.costco.com/.product.1862992.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1416181', '1738', 'Zena Liquid Collagen + Biotin, 30 Fluid Ounces', 'https://www.costco.com/.product.1416181.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('681421', '1738', 'Dulcolax Laxative, 200 Tablets', 'https://www.costco.com/.product.681421.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1908270', '1738', 'Design Optics by Foster Grant, +1.25, #815 Classic Plastic Square Reading Glasses, 3-pack', 'https://www.costco.com/.product.1908270.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1908271', '1738', 'Design Optics by Foster Grant, +1.50, #815 Classic Plastic Square Reading Glasses, 3-pack', 'https://www.costco.com/.product.1908271.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1908272', '1738', 'Design Optics by Foster Grant, +1.75, #815 Classic Plastic Square Reading Glasses, 3-pack', 'https://www.costco.com/.product.1908272.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1908273', '1738', 'Design Optics by Foster Grant, +2.00, #815 Classic Plastic Square Reading Glasses, 3-pack', 'https://www.costco.com/.product.1908273.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1908274', '1738', 'Design Optics by Foster Grant, +2.50, #815 Classic Plastic Square Reading Glasses, 3-pack', 'https://www.costco.com/.product.1908274.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1969480', '1738', 'OLLY Sleep Gummy, 110 Gummies', 'https://www.costco.com/.product.1969480.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2051218', '1738', 'Tylenol Extra Strength Caplets, Fever Reducer & Pain Reliever, 500 mg, 320 ct.', 'https://www.costco.com/.product.2051218.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('947272', '1738', 'Advil PM, Pain Reliever / Nighttime Sleep Aid, 200 Caplets', 'https://www.costco.com/.product.947272.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('805287', '1738', 'Kirkland Signature Lansoprazole 15 mg. Acid Reducer, 42 Capsules', 'https://www.costco.com/.product.805287.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('72147', '1738', 'TUMS Antacid Ultra Strength, 265 Chewable Tablets', 'https://www.costco.com/.product.72147.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1794121', '1738', 'Children''s Zyrtec Allergy Cetirizine HCl 10 mg Dye-Free Grape Flavored Chewables, 72 Tablets', 'https://www.costco.com/.product.1794121.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1459734', '1738', 'Nature''s Bounty Ultra Strength Probiotic 10, 70 Capsules', 'https://www.costco.com/.product.1459734.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('573015', '1738', 'Advil Ibuprofen 200 mg., Pain Reliever/Fever Reducer 360 Tablets', 'https://www.costco.com/.product.573015.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1144335', '1738', 'Flonase Non-Drowsy 24 Hour Allergy Relief Nasal Spray, 432 Metered Sprays', 'https://www.costco.com/.product.1144335.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('596759', '1738', 'Kirkland Signature Acetaminophen PM, 500 mg, 375 Capsules', 'https://www.costco.com/.product.596759.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1969459', '1738', 'OLLY Kids Multivitamin & Probiotic, 160 Gummies', 'https://www.costco.com/.product.1969459.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1856902', '1738', 'Theraflu Severe Cold Relief Medicine Powder, 24 Packets', 'https://www.costco.com/.product.1856902.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1458383', '1738', 'Nature''s Bounty Zinc 50 mg, 400 Caplets', 'https://www.costco.com/.product.1458383.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('261574', '1738', 'Kirkland Signature Aller-Tec D 12 Hour, 24 Extended Release Tablets', 'https://www.costco.com/.product.261574.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('402463', '1738', 'Systane ULTRA Lubricant Eye Drops, 30 ml', 'https://www.costco.com/.product.402463.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1050777', '1738', 'Kirkland Signature Vitamin C 250 mg, 360 Adult Gummies', 'https://www.costco.com/.product.1050777.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1700279', '1738', 'Zarbee''s Children''s Cough Daytime / Nighttime, Two 4 Ounce Daytime + One 4 Ounce Nighttime', 'https://www.costco.com/.product.1700279.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1566153', '1738', 'Mucinex Maximum Strength 1200 mg Tablets, 56-count', 'https://www.costco.com/.product.1566153.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('301341', '1738', 'Gas-X Extra Strength, 120 Softgels', 'https://www.costco.com/.product.301341.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1594459', '1738', 'Vicks VapoInhaler Soothing Vapors, 4 Scented Sticks', 'https://www.costco.com/.product.1594459.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('98211', '1738', 'Kirkland Signature Vitamin E 400 IU, 500 Softgels', 'https://www.costco.com/.product.98211.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('699770', '1738', 'Kirkland Signature Allerclear-D 12 Hour, 30 Extended Release Tablets', 'https://www.costco.com/.product.699770.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('547204', '1738', 'Zyrtec-D 12 Hour Allergy & Sinus Medicine & Nasal Decongestant, 24 Tablets', 'https://www.costco.com/.product.547204.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1076988', '1738', 'Robitussin DM Day & Night Cough Relief', 'https://www.costco.com/.product.1076988.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1734412', '1738', 'Nature Made Extra Strength Vitamin C 500 mg, 180 Gummies', 'https://www.costco.com/.product.1734412.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1908277', '1738', 'Design Optics by Foster Grant, +1.25, #809 Classic Plastic Round Reading Glasses, 3-pack', 'https://www.costco.com/.product.1908277.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1908278', '1738', 'Design Optics by Foster Grant, +1.50, #809 Classic Plastic Round Reading Glasses, 3-pack', 'https://www.costco.com/.product.1908278.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1908279', '1738', 'Design Optics by Foster Grant, +1.75, #809 Classic Plastic Round Reading Glasses, 3-pack', 'https://www.costco.com/.product.1908279.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1908280', '1738', 'Design Optics by Foster Grant, +2.00, #809 Classic Plastic Round Reading Glasses, 3-pack', 'https://www.costco.com/.product.1908280.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1908281', '1738', 'Design Optics by Foster Grant, +2.50, #809 Classic Plastic Round Reading Glasses, 3-pack', 'https://www.costco.com/.product.1908281.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1561932', '1738', 'Vicks Dayquil/Nyquil Severe Cold & Flu, 12 fl oz, 3 Count', 'https://www.costco.com/.product.1561932.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1095721', '1738', 'Flonase Sensimist Allergy Relief, 360 Sprays', 'https://www.costco.com/.product.1095721.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1648450', '1738', 'Afrin No Drip Severe Congestion 12 Hour Nasal Pump Mist, 60 ml', 'https://www.costco.com/.product.1648450.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1991395', '1738', 'OLLY Men''s Multivitamin Gummy, 200 Gummies', 'https://www.costco.com/.product.1991395.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1487435', '1738', 'Kirkland Signature Arthritis Pain Relief Gel, Diclofenac Sodium Topical Gel 1%, 15.87 Ounces', 'https://www.costco.com/.product.1487435.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1820338', '1738', 'Kirkland Signature Krill Oil 500mg, 180 Softgels', 'https://www.costco.com/.product.1820338.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('427053', '1738', 'Delsym 12 Hour Cough Relief', 'https://www.costco.com/.product.427053.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('197197', '1738', 'Kirkland Signature Naproxen Sodium, 220 mg, 400 Caplets', 'https://www.costco.com/.product.197197.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1562581', '1738', 'Mucinex DM Maximum Strength, 56 Tablets', 'https://www.costco.com/.product.1562581.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2027845', '1738', 'Design Optics by Foster Grant +1.25 #669 Upsweep Cateye Reading Glasses, 3- pack', 'https://www.costco.com/.product.2027845.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2027848', '1738', 'Design Optics by Foster Grant +1.75 #669 Upsweep Cateye Reading Glasses, 3- pack', 'https://www.costco.com/.product.2027848.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2027849', '1738', 'Design Optics by Foster Grant +2.00 #669 Upsweep Cateye Reading Glasses, 3- pack', 'https://www.costco.com/.product.2027849.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2027851', '1738', 'Design Optics by Foster Grant +2.50 #669 Upsweep Cateye Reading Glasses, 3- pack', 'https://www.costco.com/.product.2027851.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('719940', '1738', 'Kirkland Signature Nighttime Sleep Aid, 192 Tablets', 'https://www.costco.com/.product.719940.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('837291', '1738', 'Pepcid Complete Dual Action Acid Reducer + Antacid, 100 Chewable Berry Tablets', 'https://www.costco.com/.product.837291.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('638603', '1738', 'Kirkland Signature Multi-Purpose Disinfecting Solution, 48 Ounces', 'https://www.costco.com/.product.638603.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('629240', '1738', 'Kirkland Signature Stool Softener, 100 mg, 400 Softgels', 'https://www.costco.com/.product.629240.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('650377', '1738', 'Kirkland Signature Quit Original Gum, 2 mg, 380 Pieces', 'https://www.costco.com/.product.650377.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('650382', '1738', 'Kirkland Signature Quit Gum 4 mg., 380-pieces', 'https://www.costco.com/.product.650382.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('906492', '1738', 'Kirkland Signature Quit4 Mint 4 mg. Lozenge, 270-pieces', 'https://www.costco.com/.product.906492.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('906476', '1738', 'Kirkland Signature Quit Lozenges 2mg. or 4mg., Mint, 270 Pieces', 'https://www.costco.com/.product.906476.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1140951', '1738', 'Kirkland Signature Quit Coated Gum, 2 mg., 300-pieces', 'https://www.costco.com/.product.1140951.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1140957', '1738', 'Kirkland Signature Quit Coated Gum, 4 mg., 300-pieces', 'https://www.costco.com/.product.1140957.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1089787', '1738', 'Kirkland Signature Flex-Tech 13-Gallon Kitchen Trash Bag, 200-count', 'https://www.costco.com/.product.1089787.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('692731', '1738', 'Kirkland Signature, Organic Extra Virgin Olive Oil, 2 L', 'https://www.costco.com/.product.692731.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1300658', '1738', 'Kirkland Signature Flex-Tech 13-Gallon Scented Kitchen Trash Bags, 200-count', 'https://www.costco.com/.product.1300658.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('516822', '1738', 'Kirkland Signature, Organic Chicken Stock, 32 fl oz, 6-Count', 'https://www.costco.com/.product.516822.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('51070', '1738', 'Kirkland Signature, Chicken Breast, 12.5 oz, 6-Count', 'https://www.costco.com/.product.51070.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('679131', '1738', 'Kirkland Signature Organic Pure Maple Syrup, 33.8 oz', 'https://www.costco.com/.product.679131.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('897971', '1738', 'Kirkland Signature, Organic Applesauce, 3.17 oz, 24-Count', 'https://www.costco.com/.product.897971.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('555000', '1738', 'Kirkland Signature Organic Peanut Butter, 28 oz, 2-count', 'https://www.costco.com/.product.555000.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1331846', '1738', 'Kirkland Signature Semi-Sweet Chocolate Chips, 4.5 lbs', 'https://www.costco.com/.product.1331846.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1755436', '1738', 'Kirkland Signature 18-Gallon Compactor & Kitchen Trash Bag, 70-count', 'https://www.costco.com/.product.1755436.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1050557', '1738', 'Kirkland Signature Peanut Butter Filled Pretzel Nuggets, 55 oz', 'https://www.costco.com/.product.1050557.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1755441', '1738', 'Kirkland Signature Flex-Tech 33-Gallon Trash Bag, 90-count', 'https://www.costco.com/.product.1755441.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1212860', '1738', 'Kirkland Signature Soft & Chewy Granola Bars, 0.85 oz, 64-count', 'https://www.costco.com/.product.1212860.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('36285', '1738', 'Kirkland Signature Walnut Halves, 3 lbs', 'https://www.costco.com/.product.36285.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('633561', '1738', 'Kirkland Signature, Organic Diced Tomatoes, 14.5 oz, 8-Count', 'https://www.costco.com/.product.633561.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1789130', '1738', 'Kirkland Signature Ultra Shine Liquid Dish Soap, Fresh, 90 fl. oz.', 'https://www.costco.com/.product.1789130.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1390413', '1738', 'Kirkland Signature Fancy Whole Cashews, 2.5lbs', 'https://www.costco.com/.product.1390413.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1473917', '1738', 'Kirkland Signature Trail Mix Snack Packs, 2 oz, 28-count', 'https://www.costco.com/.product.1473917.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('901991', '1738', 'Kirkland Signature, Organic Sugar, 10 lbs', 'https://www.costco.com/.product.901991.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1377067', '1738', 'Kirkland Signature Chewy Protein Bar, Peanut Butter & Semisweet Chocolate Chip, 1.41 oz, 42-Count', 'https://www.costco.com/.product.1377067.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('203444', '1738', 'Kirkland Signature Pecan Halves, 2 lbs', 'https://www.costco.com/.product.203444.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('222490', '1738', 'Kirkland Signature Super Extra-Large Peanuts, 2.5 lbs', 'https://www.costco.com/.product.222490.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1347776', '1738', 'Kirkland Signature Wild Flower Honey, 5 lbs', 'https://www.costco.com/.product.1347776.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('545345', '1738', 'Kirkland Signature In-Shell Pistachios, Salted, 3 lbs', 'https://www.costco.com/.product.545345.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1193197', '1738', 'Kirkland Signature Organic Roasted Seaweed, 0.6 oz, 10-count', 'https://www.costco.com/.product.1193197.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1474436', '1738', 'Kirkland Signature Trail Mix, 4 lbs', 'https://www.costco.com/.product.1474436.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('9555', '1738', 'Kirkland Signature Microwave Popcorn, 3.3 oz, 44-count', 'https://www.costco.com/.product.9555.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1001368', '1738', 'Kirkland Signature, Organic Quinoa, 4.5 lbs', 'https://www.costco.com/.product.1001368.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1300509', '1738', 'Kirkland Signature Nut Bars, 1.41 oz, 30 count', 'https://www.costco.com/.product.1300509.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('440493', '1738', 'Kirkland Signature Cashew Clusters, 2 lbs', 'https://www.costco.com/.product.440493.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('384732', '1738', 'Kirkland Signature, Pure Sea Salt, 30 oz', 'https://www.costco.com/.product.384732.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('87507', '1738', 'Kirkland Signature 10-Gallon Wastebasket Liner, Clear, 500-count', 'https://www.costco.com/.product.87507.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('279783', '1738', 'Kirkland Signature, Bacon Crumbles, 20 oz', 'https://www.costco.com/.product.279783.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('633563', '1738', 'Kirkland Signature, Organic Tomato Sauce, 15 oz, 12-Count', 'https://www.costco.com/.product.633563.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('890181', '1738', 'Kirkland Signature, Wild Alaskan Pink Salmon, 6 oz, 6-Count', 'https://www.costco.com/.product.890181.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('633564', '1738', 'Kirkland Signature, Organic Tomato Paste, 6 oz, 12-Count', 'https://www.costco.com/.product.633564.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('6406', '1738', 'Kirkland Signature Premium Extra Thick Steak Strips, 12 oz', 'https://www.costco.com/.product.6406.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1032932', '1738', 'Kirkland Signature Organic Raw Honey, 24 oz, 3-count', 'https://www.costco.com/.product.1032932.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('164950', '1738', 'Kirkland Signature, Whole Black Peppercorn, 14.1 oz', 'https://www.costco.com/.product.164950.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('284601', '1738', 'Kirkland Signature Supreme Whole Almonds, 3 lbs', 'https://www.costco.com/.product.284601.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1755444', '1738', 'Kirkland Signature 50-Gallon Outdoor Trash Bag, 70-count', 'https://www.costco.com/.product.1755444.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('859695', '1738', 'Kirkland Signature Creamy Almond Butter, 27 oz', 'https://www.costco.com/.product.859695.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1789247', '1738', 'Kirkland Signature Olive Oil, 3 L', 'https://www.costco.com/.product.1789247.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('71003', '1738', 'Kirkland Signature, Extra Virgin Italian Olive Oil, 2 L', 'https://www.costco.com/.product.71003.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('581871', '1738', 'Kirkland Signature, Minced California Garlic, 48 oz', 'https://www.costco.com/.product.581871.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1209607', '1738', 'Kirkland Signature Praline Pecans, 2.5 lbs', 'https://www.costco.com/.product.1209607.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('553499', '1738', 'Kirkland Signature, Sunsweet Whole Dried Plums, 3.5 lbs', 'https://www.costco.com/.product.553499.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('957330', '1738', 'Kirkland Signature Snacking Nuts, Variety Pack, 1.6 oz, 30-count', 'https://www.costco.com/.product.957330.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1045706', '1738', 'Kirkland Signature, Organic Virgin Coconut Oil, 84 fl oz', 'https://www.costco.com/.product.1045706.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('596444', '1738', 'Kirkland Signature, Ocean Spray Cranberry Premium 100% Juice, 96 fl oz, 2-Count', 'https://www.costco.com/.product.596444.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('164981', '1738', 'Kirkland Signature Fine Ground Black Pepper, 12.3 oz', 'https://www.costco.com/.product.164981.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1195303', '1738', 'Kirkland Signature Dry Roasted Macadamia Nuts, 1.5 lbs', 'https://www.costco.com/.product.1195303.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('3330816', '1738', 'Kirkland Signature Popcorn, Sea Salt, 0.65 oz, 36-count', 'https://www.costco.com/.product.3330816.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('906410', '1738', 'Kirkland Signature, Canola Oil, 3 qt, 2-count', 'https://www.costco.com/.product.906410.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1014809', '1738', 'Kirkland Signature Protein Bar, Variety Pack, 2.12 oz, 20-count', 'https://www.costco.com/.product.1014809.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('4165758', '1738', 'Kirkland Signature Colombian Cold Brew Coffee, 11 fl oz, 12-count', 'https://www.costco.com/.product.4165758.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('941275', '1738', 'Kirkland Signature Organic Pine Nuts, 1.5 lbs', 'https://www.costco.com/.product.941275.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1178969', '1738', 'Kirkland Signature, Almond Flour, 3 lbs', 'https://www.costco.com/.product.1178969.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('522779', '1738', 'Kirkland Signature, Crushed Red Pepper, 10 oz', 'https://www.costco.com/.product.522779.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1147377', '1738', 'Kirkland Signature Organic Blue Agave, 36 oz, 2-count', 'https://www.costco.com/.product.1147377.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('165041', '1738', 'Kirkland Signature Organic No-Salt Seasoning, 14.5 oz', 'https://www.costco.com/.product.165041.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1424237', '1738', 'Kirkland Signature Grass-Fed Butter, 8 oz, 4-count', 'https://www.costco.com/.product.1424237.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1055599', '1738', 'Kirkland Signature Thin Sliced Chicken Breasts, Boneless Skinless, 10 lbs', 'https://www.costco.com/.product.1055599.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('904984', '1738', 'Kirkland Signature Organic Strawberries, 4 lbs', 'https://www.costco.com/.product.904984.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1748763', '1738', 'Kirkland Signature Breakfast Sandwich, 4.82 oz, 8-count', 'https://www.costco.com/.product.1748763.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('221177', '1738', 'Kirkland Signature Wild Alaskan Sockeye Salmon, 5 oz - 7 oz Portion, 3 lbs', 'https://www.costco.com/.product.221177.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('815544', '1738', 'Kirkland Signature Organic Blueberries, 3 lbs', 'https://www.costco.com/.product.815544.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1925804', '1738', 'Kirkland Signature Artisan Crust Pepperoni Pizza, 21.52 oz, 4-count', 'https://www.costco.com/.product.1925804.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('9820887', '1738', 'Kirkland Signature Cheese Pizza, 18.25 oz, 4-count', 'https://www.costco.com/.product.9820887.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('88744', '1738', 'Kirkland Signature Meatballs, 6 lbs', 'https://www.costco.com/.product.88744.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1048072', '1738', 'Kirkland Signature Organic Greek Yogurt, 48 oz', 'https://www.costco.com/.product.1048072.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1304236', '1738', 'Kirkland Signature Grass-Fed Beef Patties, 1/3 lb Patty, 15-count', 'https://www.costco.com/.product.1304236.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1189000', '1738', 'Kirkland Signature Fresh Mozzarella, 18 oz, 2-count', 'https://www.costco.com/.product.1189000.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('7186561', '1738', 'Kirkland Signature Organic Greek Feta, 28.2 oz', 'https://www.costco.com/.product.7186561.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1462040', '1738', 'Kirkland Signature Wild Argentine Raw Shrimp, 2 lb', 'https://www.costco.com/.product.1462040.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1217608', '1738', 'Kirkland Signature Organic Broccoli Florets, 1 lb, 4-count', 'https://www.costco.com/.product.1217608.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1200200', '1738', 'Kirkland Signature Garlic Butter Shrimp, 2 lbs', 'https://www.costco.com/.product.1200200.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1294443', '1738', 'Kirkland Signature Chicken Tenderloins, Boneless Skinless, 6 lbs', 'https://www.costco.com/.product.1294443.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1321637', '1738', 'Kirkland Signature Italian Sausage and Beef Lasagna, 3 lbs, 2-count', 'https://www.costco.com/.product.1321637.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1116038', '1738', 'Kirkland Signature Shredded Mozzarella Cheese, 2.5 lbs, 2-count', 'https://www.costco.com/.product.1116038.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1524380', '1738', 'Kirkland Signature Cauliflower Crust Pizza, Supreme, 2-count', 'https://www.costco.com/.product.1524380.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1015237', '1738', 'Kirkland Signature Stir-Fry Vegetable Blend, 5.5 lbs', 'https://www.costco.com/.product.1015237.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1165284', '1738', 'Kirkland Signature Shredded Mexican Style Blend Cheese, 2.5 lbs, 2-count', 'https://www.costco.com/.product.1165284.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1294446', '1738', 'Kirkland Signature Chicken Wings, First and Second Sections, 10 lbs', 'https://www.costco.com/.product.1294446.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1305092', '1738', 'Kirkland Signature Ground Beef Patties, 1/3 lb Patty, 18-count', 'https://www.costco.com/.product.1305092.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1233570', '1738', 'Kirkland Signature Breaded Panko Shrimp, 2.5 lbs', 'https://www.costco.com/.product.1233570.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('9999699', '1738', 'Kirkland Signature Extra Crispy French Fries, 5 lbs', 'https://www.costco.com/.product.9999699.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1251702', '1738', 'Kirkland Signature Tempura Shrimp, 2.35 lbs, 30-count', 'https://www.costco.com/.product.1251702.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('948400', '1738', 'Kirkland Signature Super Premium Vanilla Ice Cream, 1/2 Gallon, 2-count', 'https://www.costco.com/.product.948400.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1010598', '1738', 'Kirkland Signature Three Berry Blend, 4 lbs', 'https://www.costco.com/.product.1010598.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('77009', '1738', 'Kirkland Signature Farm-Raised Cooked Shrimp, Tail-Off, 50-70-count per Pound, 2 lbs', 'https://www.costco.com/.product.77009.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1956136', '1738', 'Kirkland Signature Crispy Wings with Classic Buffalo Sauce, 64 oz', 'https://www.costco.com/.product.1956136.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('25551', '1738', 'Kirkland Signature Farm-Raised Raw Shrimp, Tail-On, 21-25-count per Pound, 2 lbs', 'https://www.costco.com/.product.25551.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('186626', '1738', 'Kirkland Signature Aged Parmigiano Reggiano Cheese, Shredded, 1 lb', 'https://www.costco.com/.product.186626.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('9090', '1738', 'Kirkland Signature Fresh Goat Cheese, 10 oz, 2-count', 'https://www.costco.com/.product.9090.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('3133113', '1738', 'Kirkland Signature, Black Pepper with Grinder, 6.3 oz, 2-Count', 'https://www.costco.com/.product.3133113.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1736931', '1738', 'Kirkland Signature Lightly Breaded Chicken Breast Chunks, 4 lbs', 'https://www.costco.com/.product.1736931.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1782177', '1738', 'Kirkland Signature Lightly Breaded Chicken Breast Fillet, 3 lbs', 'https://www.costco.com/.product.1782177.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('446586', '1738', 'Quaker Oats Old Fashioned Rolled Oats, 10 lbs', 'https://www.costco.com/.product.446586.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1560969', '1738', 'MadeGood Organic Granola Minis, Variety Pack, 0.85 oz, 24-count', 'https://www.costco.com/.product.1560969.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('834603', '1738', 'Kodiak Cakes Power Cakes Flapjack and Waffle Mix, 4.5 lbs', 'https://www.costco.com/.product.834603.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('734786', '1738', 'General Mills, Cheerios Cereal, Honey Nut, 27.5 oz, 2-count', 'https://www.costco.com/.product.734786.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2222019', '1738', 'Kirkland Signature Organic Ancient Grain Granola, 35.3 oz', 'https://www.costco.com/.product.2222019.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1462402', '1738', 'Post, Honey Bunches of Oats with Almonds Cereal, 50 oz', 'https://www.costco.com/.product.1462402.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2049779', '1738', 'Nature''s Path Organic Pumpkin Seed Flax Granola, 35.3 oz', 'https://www.costco.com/.product.2049779.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1974794', '1738', 'Kellogg''s Special K Extra Red Berries Cereal, 21.5 oz, 2-count', 'https://www.costco.com/.product.1974794.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('664927', '1738', 'Cinnamon Toast Crunch Cereal, 49.5 oz', 'https://www.costco.com/.product.664927.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('522107', '1738', 'General Mills, Cheerios Cereal, 20.35 oz, 2-count', 'https://www.costco.com/.product.522107.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1856165', '1738', 'Sunny Fruit Dried Apricots, 32 oz', 'https://www.costco.com/.product.1856165.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1282504', '1738', 'General Mills Morning Summit Cereal, 38 oz', 'https://www.costco.com/.product.1282504.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1449725', '1738', 'NuTrail Nut Granola, Blueberry Cinnamon, 22 oz', 'https://www.costco.com/.product.1449725.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1492456', '1738', 'Kirkland Signature, Albacore Solid White Tuna in Water, 7 oz, 8-Count', 'https://www.costco.com/.product.1492456.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('841930', '1738', 'Kirkland Signature, Thai Hom Mali Jasmine Rice, 25 lbs', 'https://www.costco.com/.product.841930.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('993449', '1738', 'Garofalo, Organic Pasta, Variety Pack, 17.6 oz, 6-Count', 'https://www.costco.com/.product.993449.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1485523', '1738', 'Kirkland Signature Organic Unbleached All Purpose Flour, 10 lbs, 2-count', 'https://www.costco.com/.product.1485523.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('477403', '1738', 'Del Monte, Canned Cut Green Beans, 14.5 oz, 12-Count', 'https://www.costco.com/.product.477403.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('425349', '1738', 'Del Monte, Canned Corn-Whole Kernel, 15.25 oz, 12-Count', 'https://www.costco.com/.product.425349.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1572002', '1738', 'Campbell''s, Simply Chicken Noodle Soup, 18.6 oz, 8-Count', 'https://www.costco.com/.product.1572002.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1685578', '1738', 'Bibigo, Cooked Sticky White Rice Bowls, Medium Grain, 7.4 oz, 12-Count', 'https://www.costco.com/.product.1685578.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('7552', '1738', 'Wild Planet, Albacore Wild Tuna, 5 oz, 6-count', 'https://www.costco.com/.product.7552.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('162274', '1738', 'Chicken of the Sea, Chunk Light Premium Tuna in Water, 7 oz, 12-Count', 'https://www.costco.com/.product.162274.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('32911', '1738', 'Kirkland Signature Pure Vanilla, 16 fl oz', 'https://www.costco.com/.product.32911.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('761486', '1738', 'Garofalo, Organic Spaghetti Noodles, 17.6 oz, 8-Count', 'https://www.costco.com/.product.761486.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('847909', '1738', 'Ghirardelli, Triple Chocolate Premium Brownie Mix, 6-count', 'https://www.costco.com/.product.847909.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('426292', '1738', 'Arm & Hammer, Pure Baking Soda, 13.5 lbs', 'https://www.costco.com/.product.426292.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2038055', '1738', 'Seeds of Change Organic Quinoa & Brown Rice with Garlic & Lentils, 6-count', 'https://www.costco.com/.product.2038055.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('132666', '1738', 'Royal, Basmati Rice, 20 lbs', 'https://www.costco.com/.product.132666.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1392843', '1738', 'Chosen Foods Avocado Oil Spray, 13.5 oz, 2-count', 'https://www.costco.com/.product.1392843.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('443298', '1738', 'Kraft, Macaroni & Cheese Dinner Cup, 2.05 oz, 12-Count', 'https://www.costco.com/.product.443298.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('118677', '1738', 'Nestlé Toll House, Semi-Sweet Chocolate Chip Morsels, 72 oz', 'https://www.costco.com/.product.118677.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('9440', '1738', 'Thai Kitchen Organic Coconut Milk, Unsweetened, 13.66 fl oz, 6-count', 'https://www.costco.com/.product.9440.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('316689', '1738', 'Lotus Foods, Organic Millet & Brown Rice Ramen, 2.5 oz, 12-Count', 'https://www.costco.com/.product.316689.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1407434', '1738', 'Nongshim, Tonkotsu Ramen Bowl, 3.56 oz, 6-Count', 'https://www.costco.com/.product.1407434.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2043170', '1738', 'Tasty Bite Organic Madras Lentils, 10 oz, 8-count', 'https://www.costco.com/.product.2043170.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('5354', '1738', 'Hidden Valley Original Ranch Homestyle Dressing, 40 fl oz, 2-count', 'https://www.costco.com/.product.5354.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('917546', '1738', 'Jif Creamy Peanut Butter 48 oz, 2-Count', 'https://www.costco.com/.product.917546.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('980978', '1738', 'Nissin Cup Noodles, Chicken, 2.5 oz, 24-count', 'https://www.costco.com/.product.980978.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('981859', '1738', 'Hellmann''s Real Mayonnaise, Squeeze Bottle, 25 fl oz, 2-count', 'https://www.costco.com/.product.981859.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1374083', '1738', 'Rao''s Homemade Alfredo Sauce, 15 oz, 2-count', 'https://www.costco.com/.product.1374083.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('879520', '1738', 'Nutella Hazelnut Spread with Cocoa, 33.5 oz, 2-count', 'https://www.costco.com/.product.879520.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1986173', '1738', 'Snapdragon Foods Vietnamese Pho Bowls, Beef, 3.1 oz, 9-count', 'https://www.costco.com/.product.1986173.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('202195', '1738', 'SPAM Canned Meat, 25% Less Sodium, 12 oz, 8-Count', 'https://www.costco.com/.product.202195.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1566350', '1738', 'Bachan''s Japanese Barbecue Sauce, 34 oz', 'https://www.costco.com/.product.1566350.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1694269', '1738', 'Nutella B-Ready Crispy Wafers Filled with Nutella, 0.7 oz, 36-count', 'https://www.costco.com/.product.1694269.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('744361', '1738', 'Genova, Yellowfin Tuna, 7 oz, 6-Count', 'https://www.costco.com/.product.744361.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('414', '1738', 'Hellmann''s, Real Mayonnaise, 64 oz', 'https://www.costco.com/.product.414.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('383456', '1738', 'Sweet Baby Ray''s, Barbecue Sauce, 40 oz, 2-Count', 'https://www.costco.com/.product.383456.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('207', '1738', 'Homai California Calrose Rice, 25 lbs', 'https://www.costco.com/.product.207.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('262838', '1738', 'Cholula, Hot Sauce Original, 12 fl oz, 2-Count', 'https://www.costco.com/.product.262838.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1424057', '1738', 'Hidden Valley Ranch Homestyle Seasoning, Dip and Salad Dressing Mix, 20 oz', 'https://www.costco.com/.product.1424057.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2751', '1738', 'Red Star, Active Dry Yeast, 32 oz', 'https://www.costco.com/.product.2751.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('704329', '1738', 'Libby''s, Vienna Sausage, 4.6 oz, 18-count', 'https://www.costco.com/.product.704329.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('111894', '1738', 'Lawry''s Coarse Ground Garlic Salt with Parsley, 33 oz', 'https://www.costco.com/.product.111894.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('906420', '1738', 'Kirkland Signature, Vegetable Oil, 3 qt, 2-count', 'https://www.costco.com/.product.906420.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2040272', '1738', 'Kinder''s Organic Signature Grill Variety Pack, 54.4 oz', 'https://www.costco.com/.product.2040272.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1746909', '1738', 'Samyang Buldak Ramen Carbonara, Spicy Chicken, 3.7 oz, 6-count', 'https://www.costco.com/.product.1746909.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('433677', '1738', 'McCormick, Grill Mates, Montreal Steak Seasoning, 29 oz', 'https://www.costco.com/.product.433677.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1978580', '1738', 'Kirkland Signature Tonkotsu Pork Ramen Broth, 32 fl oz, 4-count', 'https://www.costco.com/.product.1978580.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2023427', '1738', 'Rao''s Homemade Marinara Sauce Made with Italian Tomatoes, 31.7 oz, 2-count', 'https://www.costco.com/.product.2023427.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2070826', '1738', 'Nutella Peanut Spread with Cocoa, 26.5 oz, 2-count', 'https://www.costco.com/.product.2070826.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('5331', '1738', 'Classico Organic Pasta Sauce, 32 oz, 3-count', 'https://www.costco.com/.product.5331.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('819413', '1738', 'Giorgia Organic Mushrooms Sliced, 4 oz, 12-count', 'https://www.costco.com/.product.819413.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('985695', '1738', 'Annie''s Organic Macaroni & Cheese Variety Pack, 6 oz, 12-count', 'https://www.costco.com/.product.985695.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('831454', '1738', 'Paesana Organic Tomato & Basil Pasta Sauce, 25 oz, 2-count', 'https://www.costco.com/.product.831454.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1292488', '1738', 'Safe Catch Ahi Wild Yellowfin Tuna Steaks, 5 oz, 6-count', 'https://www.costco.com/.product.1292488.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2057644', '1738', 'Kinder''s The Flavor Rack Signature Organic Seasoning Variety Pack, 12-count', 'https://www.costco.com/.product.2057644.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('559608', '1738', 'Mateo''s Gourmet Salsa, Medium, 32 oz', 'https://www.costco.com/.product.559608.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('549721', '1738', 'Heinz Simply Tomato Ketchup, 44 oz, 3-count', 'https://www.costco.com/.product.549721.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1357244', '1738', 'Kirkland Signature Cranberry Walnut Round Bread', 'https://www.costco.com/.product.1357244.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('699251', '1738', 'Victoria White Linen Marinara Sauce, 40 oz, 2-count', 'https://www.costco.com/.product.699251.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1948305', '1738', 'Comvita Manuka Honey UMF 12+, 17.6 oz', 'https://www.costco.com/.product.1948305.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1529345', '1738', 'Siete Almond Flour Tortilla, 20-count', 'https://www.costco.com/.product.1529345.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('112266', '1738', 'Madi Gran Panettone Italian Traditional Oven Baked Cake, 2.2 lbs', 'https://www.costco.com/.product.112266.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1172471', '1738', 'Kerrygold Pure Irish Butter, Salted, 8 oz, 4-count', 'https://www.costco.com/.product.1172471.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1484855', '1738', 'Cello Variety Pack, Cracker Cut, Premium Sliced Cheeses, 2 lbs', 'https://www.costco.com/.product.1484855.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1271446', '1738', 'Oikos Triple Zero Greek Nonfat Yogurt, Variety Pack, 5.3 oz, 18-count', 'https://www.costco.com/.product.1271446.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1005641', '1738', 'Chobani Greek Yogurt Variety Pack, 5.3 oz, 20-count', 'https://www.costco.com/.product.1005641.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('967892', '1738', 'BelGioioso Fresh Mozzarella Snacking Cheese, 1 oz, 24-count', 'https://www.costco.com/.product.967892.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1920008', '1738', 'Chobani Protein Lowfat Greek Yogurt, 6.7 oz, 16-count', 'https://www.costco.com/.product.1920008.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('96928', '1738', 'Kraft Singles American Cheese, 96 Slices, 4 lbs', 'https://www.costco.com/.product.96928.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1719185', '1738', 'Babybel Mini Snack Cheese, Original, 0.71 oz, 36-count', 'https://www.costco.com/.product.1719185.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1207907', '1738', 'Kerrygold Pure Unsalted Irish Butter, 8 oz, 4-count', 'https://www.costco.com/.product.1207907.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2059712', '1738', 'Chobani 20g Protein Lowfat Plain Greek Yogurt, 40 oz', 'https://www.costco.com/.product.2059712.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1239452', '1738', 'Busseto California Snackin'' Bite Size Salami & Provolone Cheese, 8-count', 'https://www.costco.com/.product.1239452.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('388467', '1738', 'Boursin Garlic & Fine Herbs + Shallot & Chive, Gourmet Cheese, 5.3 oz, 3-count', 'https://www.costco.com/.product.388467.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('303285', '1738', 'Finlandia Premium Cheese Slices, 2 lbs', 'https://www.costco.com/.product.303285.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('26802', '1738', 'President Crumbled Feta Cheese, 1.5 lbs', 'https://www.costco.com/.product.26802.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('41181', '1738', 'Emmi Le Gruyere AOP Cheese, 1 lb', 'https://www.costco.com/.product.41181.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1847677', '1738', 'Noosa Yoghurt Variety Pack, 4 oz, 12-count', 'https://www.costco.com/.product.1847677.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1538359', '1738', 'Kirkland Signature, Organic Fruit and Vegetable Pouches, Variety Pack, 3.17 oz, 24-count', 'https://www.costco.com/.product.1538359.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('951243', '1738', 'Mott''s, Organic Apple Sauce, 3.9 oz, 36-Count', 'https://www.costco.com/.product.951243.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2727590', '1738', 'Cascade Platinum Plus Dishwasher Detergent ActionPacs, Fresh, 82-count', 'https://www.costco.com/.product.2727590.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2990929', '1738', 'Dawn Platimum Advanced Power Dishwashing Liquid, 90 fl oz', 'https://www.costco.com/.product.2990929.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2189436', '1738', 'Clorox Disinfecting Wipes, Variety Pack, 85-count, 5-pack', 'https://www.costco.com/.product.2189436.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1920495', '1738', 'Lysol Disinfecting Wipes, Variety Pack, 95-count, 4-pack', 'https://www.costco.com/.product.1920495.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('3797974', '1738', 'Dawn Platinum Plus Powerwash Dish Soap Spray, Fresh Clean, 1 Starter Kit + 2 Refills', 'https://www.costco.com/.product.3797974.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('7609681', '1738', 'Cascade Platinum Liquid Dishwasher Detergent, Fresh, 125 fl oz', 'https://www.costco.com/.product.7609681.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2662877', '1738', 'Lysol Advanced Toilet Bowl Cleaner, 32 fl oz, 4-count', 'https://www.costco.com/.product.2662877.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2848101', '1738', 'Cascade Complete Shine Boost Dishwasher Detergent ActionPacs, Fresh, 92-count', 'https://www.costco.com/.product.2848101.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2218587', '1738', 'Swiffer Duster Heavy Duty Dusting Kit, 1 Handle + 17 Refills', 'https://www.costco.com/.product.2218587.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2312000', '1738', 'Finish Jet-Dry Ultra Dishwasher Rinse Aid, 38 fl oz', 'https://www.costco.com/.product.2312000.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1456660', '1738', 'Swiffer Sweeper Heavy Duty Dry Sweeping Cloth Refills, 50-count', 'https://www.costco.com/.product.1456660.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1717856', '1738', 'Scotch-Brite Zero Scratch Sponge, 24-count', 'https://www.costco.com/.product.1717856.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('625994', '1738', 'Clorox ToiletWand Disposable Toilet Cleaning System, Rainforest Rush, 1 Wand & 36 Refills', 'https://www.costco.com/.product.625994.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('913437', '1738', 'Clorox Clean-Up All Purpose Cleaner with Bleach, Original, 32 fl oz Spray & 180 fl oz Refill', 'https://www.costco.com/.product.913437.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2533324', '1738', 'Lysol Disinfectant Spray, Crisp Linen, 19 oz, 3-count', 'https://www.costco.com/.product.2533324.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1805039', '1738', 'Pine-Sol Multi-Surface Cleaner, Original, 60 fl oz, 2-count', 'https://www.costco.com/.product.1805039.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1717853', '1738', 'Scotch-Brite Heavy Duty Sponge, 24-count', 'https://www.costco.com/.product.1717853.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1988113', '1738', 'Fabuloso Multi-Purpose Cleaner, Lavender, 210 fl oz', 'https://www.costco.com/.product.1988113.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1991335', '1738', 'Mr. Clean Magic Eraser, Whole Home Extra Durable, 18-count', 'https://www.costco.com/.product.1991335.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1907127', '1738', 'Swiffer Sweep + Mop Deluxe Sweeping Kit', 'https://www.costco.com/.product.1907127.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1032422', '1738', 'Palmolive Ultra Strength Liquid Dish Soap, 102 fl oz', 'https://www.costco.com/.product.1032422.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2308572', '1738', 'Mrs Meyers Multi-Surface Variety, 24 fl oz, 3-count', 'https://www.costco.com/.product.2308572.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1963239', '1738', 'Airwick Scented Oils, 1 Plug-in + 9 Refills, Variety Pack, Assorted Scents', 'https://www.costco.com/.product.1963239.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1509965', '1738', 'Scott Shop Towels, Original Multi-Purpose, Blue, 10-count', 'https://www.costco.com/.product.1509965.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('8816886', '1738', 'Finish Powerball Ultimate Quantum Dish Detergent Tabs, 90-count', 'https://www.costco.com/.product.8816886.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2218574', '1738', 'Swiffer Heavy Duty Wet Mopping Cloths, Lavender, 54-count', 'https://www.costco.com/.product.2218574.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('986654', '1738', 'Unitex 100% Cotton Towel, White, 14 in x 17 in, 52-count', 'https://www.costco.com/.product.986654.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2345775', '1738', 'Poo-Pourri Toilet Spray, Variety Pack, 3.4 fl oz, 3-count', 'https://www.costco.com/.product.2345775.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('100070491', '1738', 'Kirkland Signature Chardonnay, Sonoma County, 750 ml', 'https://www.costco.com/kirkland-signature-chardonnay-sonoma-county-750-ml.product.100070491.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('100456493', '1738', 'Kirkland Signature Cabernet Sauvignon, 3 L', 'https://www.costco.com/kirkland-signature-cabernet-sauvignon-3-l.product.100456493.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('4201013674', '1738', 'Kirkland Signature Straight Bourbon Whiskey, Kentucky, 1.75 L', 'https://www.costco.com/kirkland-signature-straight-bourbon-whiskey-kentucky-175-l.product.4201013674.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('509768', '1738', '3M Scotch Precision Ultra Edge 8" Scissor, 3-count', 'https://www.costco.com/.product.509768.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('415022', '1738', 'Scotch Heavy Duty Shipping Tape, 8-pack', 'https://www.costco.com/.product.415022.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1806357', '1738', 'Duracell 9V Alkaline Batteries, 8-count', 'https://www.costco.com/.product.1806357.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1750832', '1738', 'Zevo Flying Insect Trap Starter Kit, 2 Devices + 6 Refills', 'https://www.costco.com/.product.1750832.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1395061', '1738', 'Advantage Premium Bright Ink Jet and Laser Paper, 8.5"x11" Letter, White, 24lb, 97 Bright, 1 Ream of 800 Sheets', 'https://www.costco.com/.product.1395061.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1806386', '1738', 'Duracell D Alkaline Batteries, 14-count', 'https://www.costco.com/.product.1806386.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1806373', '1738', 'Duracell Power Boost C Alkaline Batteries, 14-count', 'https://www.costco.com/.product.1806373.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1913150', '1738', 'Frito Lay Simply Variety Pack, 30-count', 'https://www.costco.com/.product.1913150.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1450796', '1738', 'Just Bare Lightly Breaded Chicken Breast Chunks, Boneless Skinless, 4 lbs', 'https://www.costco.com/.product.1450796.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('464292', '1738', 'Ajinomoto Yakisoba with Vegetables, 9 oz, 6-count', 'https://www.costco.com/.product.464292.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1338984', '1738', 'Foster Farms Take Out Crispy Chicken Wings, Classic Buffalo, 4 lbs', 'https://www.costco.com/.product.1338984.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('624842', '1738', 'Sabatasso''s Pizza Singles, Variety Pack, 12-count', 'https://www.costco.com/.product.624842.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('21272', '1738', 'Smucker''s Uncrustables, Peanut Butter & Grape Jelly Sandwich, 18-count', 'https://www.costco.com/.product.21272.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1312297', '1738', 'Jimmy Dean Delights English Muffins, 5.1 oz, 12-count', 'https://www.costco.com/.product.1312297.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('18668', '1738', 'El Monterey Mexican Grill Taquitos, Chicken & Cheese, 30-count', 'https://www.costco.com/.product.18668.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('107699', '1738', 'CJ Bibigo Steamed Dumplings, Chicken & Vegetable, 36-count', 'https://www.costco.com/.product.107699.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1339035', '1738', 'Foster Farms Take Out Crispy Chicken Wings, Sweet Chipotle BBQ, 4 lbs', 'https://www.costco.com/.product.1339035.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('749182', '1738', 'Ajinomoto Yakitori Chicken Fried Rice, 9 oz, 6-count', 'https://www.costco.com/.product.749182.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1312303', '1738', 'Jimmy Dean Croissant Sausage Egg & Cheese, 4.5 oz, 12-count', 'https://www.costco.com/.product.1312303.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1320289', '1738', 'Perdue, Panko Breaded Chicken Breast Nuggets, 5 lbs', 'https://www.costco.com/.product.1320289.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1448891', '1738', 'Tyson Chicken Breast Strips, Rotisserie Seasoned, 48 oz', 'https://www.costco.com/.product.1448891.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('7416', '1738', 'Tyson Panko Breaded Chicken Breast Tenderloins, 5 lbs', 'https://www.costco.com/.product.7416.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1953371', '1738', 'Beyond Meat Plant-Based Patties, 4 oz, 10-count', 'https://www.costco.com/.product.1953371.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1550486', '1738', 'Bibigo Steamed Soup Dumplings, Beef Pho Flavor, 36-count', 'https://www.costco.com/.product.1550486.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1139689', '1738', 'Kirkland Signature Tilapia Loins, 3 lbs', 'https://www.costco.com/.product.1139689.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1284156', '1738', 'Veggies Made Great Spinach Egg White Frittatas, 20-count', 'https://www.costco.com/.product.1284156.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('16594', '1738', 'Trident Seafoods Alaskan Salmon Burgers, 4 oz, 12-count', 'https://www.costco.com/.product.16594.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1143205', '1738', 'Crazy Cuizine Mandarin Orange Chicken, 66 oz', 'https://www.costco.com/.product.1143205.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('2062082', '1738', 'Pulmuone Teriyaki Stir-fry Udon, 30.9 oz', 'https://www.costco.com/.product.2062082.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1440704', '1738', 'Authentic Motor City Pizza Co Detroit-Style Deep Dish Pizza, Double Pepperoni, 2-count', 'https://www.costco.com/.product.1440704.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1018790', '1738', 'Brazi Bites Brazilian Cheddar & Parmesan Cheese Bread, 62-count', 'https://www.costco.com/.product.1018790.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1763967', '1738', 'Ajinomoto Japanese Style Gyoza, Pork And Chicken, 60-count', 'https://www.costco.com/.product.1763967.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1560758', '1738', 'Yummy Dino Buddies Dinosaur Chicken Breast Nuggets, 5 lbs', 'https://www.costco.com/.product.1560758.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1194639', '1738', 'Milton''s Cauliflower Crust Pizza, Roasted Vegetable, 17.8 oz, 2-count', 'https://www.costco.com/.product.1194639.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1847476', '1738', 'Ling Ling Potstickers, Chicken and Vegetable, 4.2 lbs', 'https://www.costco.com/.product.1847476.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('806230', '1738', 'Trident Seafoods Wild Alaskan Beer Battered Cod, 2.5 lbs', 'https://www.costco.com/.product.806230.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1645630', '1738', 'PuraVida Fire Roasted Primavera Mistura, 64 oz', 'https://www.costco.com/.product.1645630.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('755383', '1738', 'Tyson Crispy Chicken Strips, 48 oz', 'https://www.costco.com/.product.755383.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('638854', '1738', 'Bibigo Chicken and Cilantro Mini Wontons, 3 lbs', 'https://www.costco.com/.product.638854.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('1854959', '1738', 'Kirkland Signature Atlantic Blackened Salmon, 6-count', 'https://www.costco.com/.product.1854959.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
INSERT INTO products (sku, warehouse_id, product_name, product_url) 
VALUES ('112218', '1738', 'Haagen Dazs Vanilla Milk Chocolate Almond Ice Cream Bars, 3 fl oz, 15-count', 'https://www.costco.com/.product.112218.html')
ON CONFLICT(sku, warehouse_id) DO UPDATE SET 
    product_name = excluded.product_name,
    product_url = excluded.product_url,
    updated_at = datetime('now');
