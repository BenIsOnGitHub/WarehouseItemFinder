    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('6e76f9c5-b33f-5b4c-8c99-62cf3d0f2d9f', '1229285', 'BelVita Breakfast Biscuit, Cinnamon Brown Sugar, 1.76 oz, 30-count', 'Snacks Bars', 'https://www.costco.com/snacks-bars.html', 'https://www.costco.com/p/-/1229285', 0, '2026-10-11T05:00:03.045510+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('b0681273-a4e9-5964-b28e-8e92156728cd', '1761722', 'RXBAR Protein Bars, Variety Pack, 14-count', 'Snacks Bars', 'https://www.costco.com/snacks-bars.html', 'https://www.costco.com/p/-/1761722', 0, '2026-10-11T05:00:03.045510+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('05f75dd0-aedc-5f2a-9ed8-8c0d1afba7cb', '2068507', 'ONE Protein Bar, Variety Pack, 2.12 oz, 16-count', 'Snacks Bars', 'https://www.costco.com/snacks-bars.html', 'https://www.costco.com/p/-/2068507', 0, '2026-10-11T05:00:03.045510+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('24441771-6815-5dab-b25a-a53b60a2474b', '1672091', 'Simply Fuel Protein Balls, 14.4 oz', 'Snacks Bars', 'https://www.costco.com/snacks-bars.html', 'https://www.costco.com/p/-/1672091', 0, '2026-10-11T05:00:03.045510+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('a1aca761-4548-58c5-a370-a6d9a4cf1dff', '1956465', 'Kize Life Changing Bars, Variety Pack, 12-count', 'Snacks Bars', 'https://www.costco.com/snacks-bars.html', 'https://www.costco.com/p/-/1956465', 0, '2026-10-11T05:00:03.045510+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('7c383cfb-387b-5f41-a1bc-2e03e05f751d', '1824668', 'Simply Protein Crispy Bar Variety Pack, 15-count', 'Snacks Bars', 'https://www.costco.com/snacks-bars.html', 'https://www.costco.com/p/-/1824668', 0, '2026-10-11T05:00:03.045510+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('05791dfa-d680-563c-a5ce-6bb179d46c27', '1036671', 'Nature Valley Biscuits with Almond Butter, 1.35 oz, 30-count', 'Snacks Bars', 'https://www.costco.com/snacks-bars.html', 'https://www.costco.com/p/-/1036671', 0, '2026-10-11T05:00:03.045510+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('35517ace-4428-5e3e-a40b-d0427e87711c', '1229303', 'BelVita Breakfast Biscuits, Blueberry, 1.76 oz, 30-count', 'Snacks Bars', 'https://www.costco.com/snacks-bars.html', 'https://www.costco.com/p/-/1229303', 0, '2026-10-11T05:00:03.045510+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('ded3d3ad-e546-5522-becf-8925c15f37a6', '846156', 'Nature Valley Crunchy Granola Bar, Oats ''n Honey, 1.49 oz, 49-count', 'Snacks Bars', 'https://www.costco.com/snacks-bars.html', 'https://www.costco.com/p/-/846156', 0, '2026-10-11T05:00:03.045510+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('bca94b73-3e21-570d-86c0-ccffd2bdf2f4', '2003097', 'Quest Protein Bar Variety Pack, 2.12 oz, 16-count', 'Snacks Bars', 'https://www.costco.com/snacks-bars.html', 'https://www.costco.com/p/-/2003097', 0, '2026-10-11T05:00:11.153897+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('74d01403-e53b-5153-8b2f-a74683a19729', '1483585', 'OREO Sandwich Cookies, Variety Pack, 60-count', 'Snacks', 'https://www.costco.com/snacks.html', 'https://www.costco.com/p/-/1483585', 0, '2026-10-11T05:00:48.437555+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('bc619ae0-6e8e-542f-9e15-09e9a2c8535e', '1816483', 'Nabisco Cookies & Crackers, Variety Pack, 1 oz, 40-count', 'Snacks', 'https://www.costco.com/snacks.html', 'https://www.costco.com/p/-/1816483', 0, '2026-10-11T05:00:48.437555+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('02c9cf30-2292-51bb-8151-65d394ab27af', '1343983', 'Donsuemor, Traditional Madeleines Cake, 1 oz, 28-Count', 'Snacks', 'https://www.costco.com/snacks.html', 'https://www.costco.com/p/-/1343983', 0, '2026-10-11T05:00:48.437555+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('bafb1563-eed5-5598-bcf7-e0745845ed9f', '1707643', 'Milano Cookies, Double Dark Chocolate, 0.98 oz, 30-count', 'Snacks', 'https://www.costco.com/snacks.html', 'https://www.costco.com/p/-/1707643', 0, '2026-10-11T05:00:48.437555+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('522c867d-c591-508a-8981-fc02cbb399d6', '1426611', 'Loacker Minis Wafer Cookie Variety, 28.22 oz', 'Snacks', 'https://www.costco.com/snacks.html', 'https://www.costco.com/p/-/1426611', 0, '2026-10-11T05:00:56.123079+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('5c7a63f5-e876-5cbc-a1bb-baa4ee20da81', '1675745', 'Nonni''s Biscotti, Almond Dark Chocolate, 1.34 oz, 25-count', 'Snacks', 'https://www.costco.com/snacks.html', 'https://www.costco.com/p/-/1675745', 0, '2026-10-11T05:00:56.123079+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('0de5433c-f8dc-5d27-bc7d-ca6154078376', '1812863', 'Nutella Biscuits, 9.7 oz, 4-count', 'Snacks', 'https://www.costco.com/snacks.html', 'https://www.costco.com/p/-/1812863', 0, '2026-10-11T05:01:03.523930+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('f1255489-e446-5b6e-82e2-adc6217459a6', '587289', 'Joy Luck Palace Double Egg Yolk and Lotus Seed Paste Moon Cakes, 24.7 oz, 4-Count', 'Snacks', 'https://www.costco.com/snacks.html', 'https://www.costco.com/p/-/587289', 0, '2026-10-11T05:01:03.523930+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('bdb8eacb-612d-5a59-bc03-415a2bd30633', '1010656', 'Gourmet Nut Power Up Trail Mix, Mega Omega, 26 oz', 'Snacks', 'https://www.costco.com/snacks.html', 'https://www.costco.com/p/-/1010656', 0, '2026-10-11T05:01:03.523930+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('c2d7c066-bf41-5146-871a-b5b339a21107', '1388332', 'Tropical Fields Organic Coconut Rolls, 11 oz', 'Snacks', 'https://www.costco.com/snacks.html', 'https://www.costco.com/p/-/1388332', 0, '2026-10-11T05:01:03.523930+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('3c28b83e-6aad-5276-a727-03ecaa38b3bd', '1740556', 'Kirkland Signature 7-piece Players Iron Set, Right Handed', 'Sports Fitness', 'https://www.costco.com/sports-fitness.html', 'https://www.costco.com/p/-/1740556', 0, '2026-10-11T05:04:29.164081+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('9144503c-b1fb-5062-8a51-2044fd969462', '2066550', 'Dynamic Tuscany Elite 2-Person Ultra Low EMF Infrared Sauna', 'Sports Fitness', 'https://www.costco.com/sports-fitness.html', 'https://www.costco.com/p/-/2066550', 0, '2026-10-11T05:04:29.164081+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('06d8b22f-f348-5656-8afc-bb5b596079b6', '2028780', 'Almost Heaven Arcadia 2-person Outdoor Barrel Sauna', 'Sports Fitness', 'https://www.costco.com/sports-fitness.html', 'https://www.costco.com/p/-/2028780', 0, '2026-10-11T05:04:29.164081+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('66e3f3e7-6f20-5e1b-a48f-4ffb12f45253', '1819400', 'Phantom A10 Smart Electric Scooter', 'Sports Fitness', 'https://www.costco.com/sports-fitness.html', 'https://www.costco.com/p/-/1819400', 0, '2026-10-11T05:04:29.164081+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('c337bcac-8605-51e9-9dad-1890cb66ab0d', '1896109', 'Hiboy C1 Electric Bike', 'Sports Fitness', 'https://www.costco.com/sports-fitness.html', 'https://www.costco.com/p/-/1896109', 0, '2026-10-11T05:04:29.164081+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('6488511e-7656-5d82-ad2d-deea8ad3e88f', '1819487', 'Tetris Tumble XL', 'Sports Fitness', 'https://www.costco.com/sports-fitness.html', 'https://www.costco.com/p/-/1819487', 0, '2026-10-11T05:04:29.164081+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('fad2910a-c556-58b5-8007-436d36a050cd', '1819440', 'Kirkland Signature V3.0 Golf Ball, 2-dozen', 'Sports Fitness', 'https://www.costco.com/sports-fitness.html', 'https://www.costco.com/p/-/1819440', 0, '2026-10-11T05:04:29.164081+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('0cf212ef-d4be-5292-8afa-ce18179cc8d7', '1872142', 'Sealy Air Mattress Queen with Built-in Headboard', 'Sports Fitness', 'https://www.costco.com/sports-fitness.html', 'https://www.costco.com/p/-/1872142', 0, '2026-10-11T05:04:29.164081+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('db522615-b6ad-568e-b3f1-1bd4e6e31ffe', '1985364', 'Stern Pokémon Pinball Machine', 'Sports Fitness', 'https://www.costco.com/sports-fitness.html', 'https://www.costco.com/p/-/1985364', 0, '2026-10-11T05:04:29.164081+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('31189b12-401b-5d5b-9a6e-7fc924d720b6', '1987067', 'Aigo E3 Rainbow Kids Electric Scooter', 'Sports Fitness', 'https://www.costco.com/sports-fitness.html', 'https://www.costco.com/p/-/1987067', 0, '2026-10-11T05:04:29.164081+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('067a4940-5254-5982-9a92-28c7f5dc1b49', '1985324', 'Duracell 5000L Tri-Powered Lantern', 'Sports Fitness', 'https://www.costco.com/sports-fitness.html', 'https://www.costco.com/p/-/1985324', 0, '2026-10-11T05:04:29.164081+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('694471de-25a3-537e-b6a7-d0d7af500bfe', '1954413', 'Nautilus Vibratone Fitness Vibration Board', 'Sports Fitness', 'https://www.costco.com/sports-fitness.html', 'https://www.costco.com/p/-/1954413', 0, '2026-10-11T05:04:29.164081+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('f5eac0f6-cce5-53d1-bc05-be4883266f54', '1819441', 'Kirkland Signature V3.0 Yellow Golf Ball, 2-dozen', 'Sports Fitness', 'https://www.costco.com/sports-fitness.html', 'https://www.costco.com/p/-/1819441', 0, '2026-10-11T05:04:29.164081+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('bc1ef2c2-8188-5d8c-ab2d-8c825a20d3e8', '2088417', 'AXIL XCOR PRO II SE Hearing Protection with Bluetooth Audio', 'Sports Fitness', 'https://www.costco.com/sports-fitness.html', 'https://www.costco.com/p/-/2088417', 0, '2026-10-11T05:04:29.164081+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('71ce9317-f026-505c-b080-a1f07dab5c8a', '2049073', 'Axil MX II Pro SE + X30i Earplug Bundle', 'Sports Fitness', 'https://www.costco.com/sports-fitness.html', 'https://www.costco.com/p/-/2049073', 0, '2026-10-11T05:04:29.164081+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('91927910-213f-54ba-8803-504bb0fa1473', '1825280', 'Selkirk Pro S1 Pickleball Ball, 24-pack', 'Sports Fitness', 'https://www.costco.com/sports-fitness.html', 'https://www.costco.com/p/-/1825280', 0, '2026-10-11T05:04:29.164081+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('8445a2bd-6da1-5ad5-bcb2-700e40255ef4', '1982330', 'Hawaiian Tropic Sheer Touch Lotion Sunscreen SPF 30, 10.8 fl oz, 2-pack', 'Sports Fitness', 'https://www.costco.com/sports-fitness.html', 'https://www.costco.com/p/-/1982330', 0, '2026-10-11T05:04:29.164081+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('baaa5edf-35c4-50c3-b176-a3d1559472ed', '1877320', 'Vacation Classic Sunscreen Lotion, SPF 50, 6 fl oz Duo', 'Sports Fitness', 'https://www.costco.com/sports-fitness.html', 'https://www.costco.com/p/-/1877320', 0, '2026-10-11T05:04:29.164081+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('7cd0861b-a4e6-5940-b0c4-78195759bacb', '1696849', 'Neutrogena Beach Defense Sunscreen Spray SPF 60+, 8.5 oz, 2-pack', 'Sports Fitness', 'https://www.costco.com/sports-fitness.html', 'https://www.costco.com/p/-/1696849', 0, '2026-10-11T05:04:29.164081+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('cd057cdc-a6f2-581e-83d4-179987e35116', '2022550', 'Samsung Galaxy Tab A11+ 11.0" Wi-Fi Tablet 128GB - Includes Book Cover', 'Tablet Computers Accessories', 'https://www.costco.com/tablet-computers-accessories.html', 'https://www.costco.com/p/-/2022550', 0, '2026-10-11T05:08:17.426817+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('4c2b8aa1-8854-5517-bea1-30b161fd0adc', '1947788', 'Samsung Galaxy Tab S10 FE 10.9” Wi-Fi Tablet 128GB – Includes S Pen and Book Cover Keyboard', 'Tablet Computers Accessories', 'https://www.costco.com/tablet-computers-accessories.html', 'https://www.costco.com/p/-/1947788', 0, '2026-10-11T05:08:17.426817+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('ec9ad95f-4219-58b9-b943-d1d97acd3de0', '2014569', 'Logitech Combo Touch SE for iPad (10th gen & A16)', 'Tablet Computers Accessories', 'https://www.costco.com/tablet-computers-accessories.html', 'https://www.costco.com/p/-/2014569', 0, '2026-10-11T05:08:17.426817+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('c8f2bc7b-f154-57da-8baf-2601ad7e9370', '1881000', 'Magic Keyboard — White iPad Air 11-inch', 'Tablet Computers Accessories', 'https://www.costco.com/tablet-computers-accessories.html', 'https://www.costco.com/p/-/1881000', 0, '2026-10-11T05:08:17.426817+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('249e8afb-56f0-5782-a2f8-5e1b3e7eb93f', '1778000', 'Magic Keyboard for iPad Pro 13‑inch - US English', 'Tablet Computers Accessories', 'https://www.costco.com/tablet-computers-accessories.html', 'https://www.costco.com/p/-/1778000', 0, '2026-10-11T05:08:17.426817+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('f1b36714-422b-539b-a43b-1f2af1db9e58', '1882000', 'Magic Keyboard — White iPad Air 13-inch', 'Tablet Computers Accessories', 'https://www.costco.com/tablet-computers-accessories.html', 'https://www.costco.com/p/-/1882000', 0, '2026-10-11T05:08:17.426817+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('d850d880-6ebe-5ad9-9d83-26132edc13f6', '1774000', 'Magic Keyboard for iPad Pro 11‑inch - US English', 'Tablet Computers Accessories', 'https://www.costco.com/tablet-computers-accessories.html', 'https://www.costco.com/p/-/1774000', 0, '2026-10-11T05:08:17.426817+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('31c0e1c8-9b61-5d8e-8ffa-24a688c95126', '6264351', 'Dyson V10 Konical Cordless Stick Vacuum with Car Cleaning Kit', 'Vacuums Floor Care', 'https://www.costco.com/vacuums-floor-care.html', 'https://www.costco.com/p/-/6264351', 0, '2026-10-11T05:12:43.795300+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('1b537eaa-2c69-5bba-be47-dc4c2c130c19', '648220', 'Kirkland Signature CoQ10 300 mg., 100 Softgels', 'Vitamins Herbals Dietary Supplements', 'https://www.costco.com/vitamins-herbals-dietary-supplements.html', 'https://www.costco.com/p/-/648220', 0, '2026-10-11T05:13:58.784086+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('cada3af6-c71c-5dca-a1e1-6c7788c23172', '1187500', 'trunature Advanced Digestive Probiotic, 100 Capsules', 'Vitamins Herbals Dietary Supplements', 'https://www.costco.com/vitamins-herbals-dietary-supplements.html', 'https://www.costco.com/p/-/1187500', 0, '2026-10-11T05:13:58.784086+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('5df4b811-b0df-5199-98b6-8b341cd47678', '2069070', 'Physician''s Choice Advanced 60 Billion Probiotic, 75 Capsules', 'Vitamins Herbals Dietary Supplements', 'https://www.costco.com/vitamins-herbals-dietary-supplements.html', 'https://www.costco.com/p/-/2069070', 0, '2026-10-11T05:13:58.784086+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('e348e851-c286-5b05-b7b7-294ddf78bdd2', '1233864', 'Nature Made Magnesium Citrate 250 mg., 180 Softgels', 'Vitamins Herbals Dietary Supplements', 'https://www.costco.com/vitamins-herbals-dietary-supplements.html', 'https://www.costco.com/p/-/1233864', 0, '2026-10-11T05:13:58.784086+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('f5b94de1-8171-59db-bb9d-badfde3b4dea', '1742398', 'youtheory Ashwagandha 1000 mg, 180 Vegetarian Capsules', 'Vitamins Herbals Dietary Supplements', 'https://www.costco.com/vitamins-herbals-dietary-supplements.html', 'https://www.costco.com/p/-/1742398', 0, '2026-10-11T05:13:58.784086+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('afedd6b5-5da8-5a7e-95b2-9cbefae55a6c', '1423302', 'trunature Women''s Daily Probiotic, 90 Vegetarian Capsules', 'Vitamins Herbals Dietary Supplements', 'https://www.costco.com/vitamins-herbals-dietary-supplements.html', 'https://www.costco.com/p/-/1423302', 0, '2026-10-11T05:14:06.568139+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('813f7be3-00c8-5b9a-bdf7-7bee5fa740d7', '926628', 'Kirkland Signature Fish Oil 1000 mg, 400 Softgels', 'Vitamins Herbals Dietary Supplements', 'https://www.costco.com/vitamins-herbals-dietary-supplements.html', 'https://www.costco.com/p/-/926628', 0, '2026-10-11T05:14:06.568139+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('3d570fc9-a29b-5f14-bdaa-e2c0d0d46d72', '1998494', 'SuperBeets Heart Gummies, Strawberry, 150ct', 'Vitamins Herbals Dietary Supplements', 'https://www.costco.com/vitamins-herbals-dietary-supplements.html', 'https://www.costco.com/p/-/1998494', 0, '2026-10-11T05:14:06.568139+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('b1e8d72d-ea0a-5b75-b880-fc1a436b7e32', '1308590', 'Nature Made Extra Strength Magnesium 400 mg., 180 Softgels', 'Vitamins Herbals Dietary Supplements', 'https://www.costco.com/vitamins-herbals-dietary-supplements.html', 'https://www.costco.com/p/-/1308590', 0, '2026-10-11T05:14:06.568139+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('db12f16c-632e-59e4-b7ba-2c2d73bfa7d4', '1968128', 'youtheory Ashwagandha, 180 Gummies, Mixed Berry Flavor', 'Vitamins Herbals Dietary Supplements', 'https://www.costco.com/vitamins-herbals-dietary-supplements.html', 'https://www.costco.com/p/-/1968128', 0, '2026-10-11T05:14:06.568139+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('2754dabf-b242-50d6-b564-2872154b27fc', '572220', 'Nature Made Iron, 65 mg, 365 Tablets', 'Vitamins Herbals Dietary Supplements', 'https://www.costco.com/vitamins-herbals-dietary-supplements.html', 'https://www.costco.com/p/-/572220', 0, '2026-10-11T05:14:06.568139+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('53baebf1-e924-530c-8318-df1786936d08', '1796097', 'FEELGOOD Berberine Phytosome, 120 Vegan Capsules', 'Vitamins Herbals Dietary Supplements', 'https://www.costco.com/vitamins-herbals-dietary-supplements.html', 'https://www.costco.com/p/-/1796097', 0, '2026-10-11T05:14:06.568139+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('dc4aee8c-e649-58b5-8f35-a0b8511dc79f', '1327667', 'Nature Made CoQ10 400 mg., 90 Softgels', 'Vitamins Herbals Dietary Supplements', 'https://www.costco.com/vitamins-herbals-dietary-supplements.html', 'https://www.costco.com/p/-/1327667', 0, '2026-10-11T05:14:06.568139+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('71d15bc5-6754-5c25-9997-44017274ae30', '1181284', 'Weider Red Yeast Rice Plus 1200 mg, 240 Tablets', 'Vitamins Herbals Dietary Supplements', 'https://www.costco.com/vitamins-herbals-dietary-supplements.html', 'https://www.costco.com/p/-/1181284', 0, '2026-10-11T05:14:06.568139+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('311d0b96-72af-5ea7-90ad-f0aac5b5048d', '2052093', 'FEELGOOD Creatine+, 120 Vegan Capsules', 'Vitamins Herbals Dietary Supplements', 'https://www.costco.com/vitamins-herbals-dietary-supplements.html', 'https://www.costco.com/p/-/2052093', 0, '2026-10-11T05:14:06.568139+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('f41bf018-9248-5bf7-a58d-bf50e184125f', '887498', 'Kirkland Signature Wild Alaskan Fish Oil 1400 mg, 230 Softgels', 'Vitamins Herbals Dietary Supplements', 'https://www.costco.com/vitamins-herbals-dietary-supplements.html', 'https://www.costco.com/p/-/887498', 0, '2026-10-11T05:14:06.568139+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('5bdf02cf-a0dc-52ee-8d05-7840f22bd5cf', '1607417', 'Qunol Turmeric Plus Ginger, 200 Gummies, Tangerine', 'Vitamins Herbals Dietary Supplements', 'https://www.costco.com/vitamins-herbals-dietary-supplements.html', 'https://www.costco.com/p/-/1607417', 0, '2026-10-11T05:14:06.568139+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('2a339770-1407-59ef-8ee4-339bdb20642f', '1820338', 'Kirkland Signature Krill Oil 500mg, 180 Softgels', 'Vitamins Herbals Dietary Supplements', 'https://www.costco.com/vitamins-herbals-dietary-supplements.html', 'https://www.costco.com/p/-/1820338', 0, '2026-10-11T05:14:06.568139+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('7f103d4f-ee2c-5c98-b0c6-6b1d910d40af', '2076158', 'FEELGOOD Glutathione Phystosome, 120 Vegan Capsules', 'Vitamins Herbals Dietary Supplements', 'https://www.costco.com/vitamins-herbals-dietary-supplements.html', 'https://www.costco.com/p/-/2076158', 0, '2026-10-11T05:14:14.496863+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('0079a8a7-dec4-5934-9240-3cca8ad58266', '1486041', 'Estroven Complete Multi-Symptom Menopause Relief, 84 Caplets', 'Vitamins Herbals Dietary Supplements', 'https://www.costco.com/vitamins-herbals-dietary-supplements.html', 'https://www.costco.com/p/-/1486041', 0, '2026-10-11T05:14:14.496863+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('f02cc486-9eca-5d8a-b37b-fb1685e7e05b', '1687275', 'Qunol Ultra CoQ10 100 mg., 180 Softgels', 'Vitamins Herbals Dietary Supplements', 'https://www.costco.com/vitamins-herbals-dietary-supplements.html', 'https://www.costco.com/p/-/1687275', 0, '2026-10-11T05:14:14.496863+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('e9934a08-8bbc-59fe-8428-049b5f6fa687', '1969459', 'OLLY Kids Multivitamin & Probiotic, 160 Gummies', 'Vitamins Herbals Dietary Supplements', 'https://www.costco.com/vitamins-herbals-dietary-supplements.html', 'https://www.costco.com/p/-/1969459', 0, '2026-10-11T05:14:14.496863+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('62ddb81c-856f-5723-bba3-27e1368c33e1', '1985130', 'youtheory Concentrated Effect Verisol Collagen with Biotin, 345 Count', 'Vitamins Herbals Dietary Supplements', 'https://www.costco.com/vitamins-herbals-dietary-supplements.html', 'https://www.costco.com/p/-/1985130', 0, '2026-10-11T05:14:14.496863+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('1bb4bfe4-083a-5407-a5a6-c3b75fc1408c', '1199824', 'Nature Made CholestOFF Plus, 210 Softgels', 'Vitamins Herbals Dietary Supplements', 'https://www.costco.com/vitamins-herbals-dietary-supplements.html', 'https://www.costco.com/p/-/1199824', 0, '2026-10-11T05:14:14.496863+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('4eaccf09-84c8-5c72-90c6-9a23796ef5f6', '681272', 'trunature Vision Complex Lutein & Zeaxanthin, 140 Softgels', 'Vitamins Herbals Dietary Supplements', 'https://www.costco.com/vitamins-herbals-dietary-supplements.html', 'https://www.costco.com/p/-/681272', 0, '2026-10-11T05:14:14.496863+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('dff6497e-f926-5451-a5c1-4f30fd66dfaf', '1969480', 'OLLY Sleep Gummy, 110 Gummies', 'Vitamins Herbals Dietary Supplements', 'https://www.costco.com/vitamins-herbals-dietary-supplements.html', 'https://www.costco.com/p/-/1969480', 0, '2026-10-11T05:14:14.496863+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('737e9347-a6f4-556b-86d8-cc1254f93a3f', '588153', 'Kirkland Signature Calcium Citrate, Magnesium and Zinc, 500 Tablets', 'Vitamins Herbals Dietary Supplements', 'https://www.costco.com/vitamins-herbals-dietary-supplements.html', 'https://www.costco.com/p/-/588153', 0, '2026-10-11T05:14:22.880640+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('c8d1d98f-4277-5a2c-827a-77f76e71e648', '2052615', 'Zena Creatine Gummies + D3/K2, Variety Pack', 'Vitamins Herbals Dietary Supplements', 'https://www.costco.com/vitamins-herbals-dietary-supplements.html', 'https://www.costco.com/p/-/2052615', 0, '2026-10-11T05:14:22.880640+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('fd7976db-a37c-5270-b959-315c123a7341', '1683859', 'Sports Research Triple Strength Omega-3 Fish Oil, 150 Fish Softgels', 'Vitamins Herbals Dietary Supplements', 'https://www.costco.com/vitamins-herbals-dietary-supplements.html', 'https://www.costco.com/p/-/1683859', 0, '2026-10-11T05:14:22.880640+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('5db6959b-6759-5975-a460-2c125be76e65', '536672', 'Nature''s Bounty Fish Oil 1400 mg, 130 Coated Softgels', 'Vitamins Herbals Dietary Supplements', 'https://www.costco.com/vitamins-herbals-dietary-supplements.html', 'https://www.costco.com/p/-/536672', 0, '2026-10-11T05:14:22.880640+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('128b2853-465b-542b-8104-d6daf08ae4b7', '1209115', 'Qunol Liquid Turmeric 1000 mg, 30.4 fl oz', 'Vitamins Herbals Dietary Supplements', 'https://www.costco.com/vitamins-herbals-dietary-supplements.html', 'https://www.costco.com/p/-/1209115', 0, '2026-10-11T05:14:22.880640+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('832523b6-08d7-54bf-bdfb-151b2926dd5e', '1051972', 'Kirkland Signature Calcium 500 mg with D3 & Zinc, 240 Adult Gummies', 'Vitamins Herbals Dietary Supplements', 'https://www.costco.com/vitamins-herbals-dietary-supplements.html', 'https://www.costco.com/p/-/1051972', 0, '2026-10-11T05:14:22.880640+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('24420839-313f-56f1-99be-24edcdd7e75d', '1351728', 'trunature Cinnamon Concentrate Cinsulin 500mg, 200 Vegetarian Capsules', 'Vitamins Herbals Dietary Supplements', 'https://www.costco.com/vitamins-herbals-dietary-supplements.html', 'https://www.costco.com/p/-/1351728', 0, '2026-10-11T05:14:22.880640+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('77e209d3-c055-5369-bfcf-5fd68f30e83b', '1692715', 'Qunol Magnesium Extra Strength 250 mg, 150 Gummies', 'Vitamins Herbals Dietary Supplements', 'https://www.costco.com/vitamins-herbals-dietary-supplements.html', 'https://www.costco.com/p/-/1692715', 0, '2026-10-11T05:14:22.880640+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('87a06e62-0741-56e1-a175-ec54d92c4260', '2025437', 'Force Factor Total Beets, 90 Soft Chews, Berry Flavor', 'Vitamins Herbals Dietary Supplements', 'https://www.costco.com/vitamins-herbals-dietary-supplements.html', 'https://www.costco.com/p/-/2025437', 0, '2026-10-11T05:14:22.880640+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('78fc94a8-f4a3-5c87-aa27-65a8c2385fbe', '1888647', 'Sports Research L-Theanine Suntheanine 200 mg, 150 Softgels', 'Vitamins Herbals Dietary Supplements', 'https://www.costco.com/vitamins-herbals-dietary-supplements.html', 'https://www.costco.com/p/-/1888647', 0, '2026-10-11T05:14:22.880640+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('23fb94d1-0fdb-5fd5-a43a-c7135a80dca0', '1176584', 'Qunol Liquid CoQ10 100 mg., 30.4 Fluid Ounces', 'Vitamins Herbals Dietary Supplements', 'https://www.costco.com/vitamins-herbals-dietary-supplements.html', 'https://www.costco.com/p/-/1176584', 0, '2026-10-11T05:14:31.547146+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('66c5b300-bd6b-5ed3-8c8b-4621ee32698f', '1478260', 'Nature''s Bounty Hair, Skin and Nails Advanced, 230 Gummies', 'Vitamins Herbals Dietary Supplements', 'https://www.costco.com/vitamins-herbals-dietary-supplements.html', 'https://www.costco.com/p/-/1478260', 0, '2026-10-11T05:14:31.547146+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('0efa6935-d9cc-57cd-9385-38a39e6e1b1c', '864024', 'Nature Made CoQ10 200 mg., 140 Softgels', 'Vitamins Herbals Dietary Supplements', 'https://www.costco.com/vitamins-herbals-dietary-supplements.html', 'https://www.costco.com/p/-/864024', 0, '2026-10-11T05:14:31.547146+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('61526f80-484a-5255-8f35-18299ab98286', '1812167', 'Qunol Turmeric 1500 mg, 220 Capsules', 'Vitamins Herbals Dietary Supplements', 'https://www.costco.com/vitamins-herbals-dietary-supplements.html', 'https://www.costco.com/p/-/1812167', 0, '2026-10-11T05:14:31.547146+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('8015e2d0-1d91-5085-a3ea-e2ee93724e3d', '389194', 'Kirkland Signature Calcium 600 mg. with Vitamin D3, 500 Tablets', 'Vitamins Herbals Dietary Supplements', 'https://www.costco.com/vitamins-herbals-dietary-supplements.html', 'https://www.costco.com/p/-/389194', 0, '2026-10-11T05:14:31.547146+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('68bf6f26-8b2c-5878-aa30-595cc5218504', '2069480', 'Samsung Galaxy Watch9 40mm Smartwatch with Two Wireless Fast Chargers', 'Wearable Technology', 'https://www.costco.com/wearable-technology.html', 'https://www.costco.com/p/-/2069480', 0, '2026-10-11T05:15:17.090481+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('3c2eed84-7d7c-5cda-894f-5a80c9f3cea1', '2052212', 'Oura Ring 5 Silver Smart Ring, Exclusive Bundle, Ring + Additional Charger + Additional Year of Manufacturer’s Warranty', 'Wearable Technology', 'https://www.costco.com/wearable-technology.html', 'https://www.costco.com/p/-/2052212', 0, '2026-10-11T05:15:17.090481+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('4c43dce8-c888-5a6e-96d6-07fdf2989a28', '1920008', 'Chobani Protein Lowfat Greek Yogurt, 6.7 oz, 16-count', 'Yogurt', 'https://www.costco.com/yogurt.html', 'https://www.costco.com/p/-/1920008', 0, '2026-10-11T05:17:49.036816+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('c98e88f9-8379-5c5e-9a3f-c67932e22f59', '1005641', 'Chobani Greek Yogurt Variety Pack, 5.3 oz, 20-count', 'Yogurt', 'https://www.costco.com/yogurt.html', 'https://www.costco.com/p/-/1005641', 0, '2026-10-11T05:17:49.036816+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
INSERT INTO global_products (id, item_number, product_name, category, category_url, product_url, is_discontinued, updated_at) 
VALUES ('fe9c00d5-3584-595e-87d8-0e7f9af85a4e', '1271446', 'Oikos Triple Zero Greek Nonfat Yogurt, Variety Pack, 5.3 oz, 18-count', 'Yogurt', 'https://www.costco.com/yogurt.html', 'https://www.costco.com/p/-/1271446', 0, '2026-10-11T05:17:49.036816+00:00')
ON CONFLICT(id) DO UPDATE SET 
    item_number = COALESCE(NULLIF(excluded.item_number, ''), global_products.item_number),
    product_name = excluded.product_name,
    category = excluded.category,
    category_url = excluded.category_url,
    product_url = excluded.product_url,
    is_discontinued = excluded.is_discontinued,
    updated_at = excluded.updated_at;
