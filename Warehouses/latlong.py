import pandas as pd

# Load CSV
df = pd.read_csv('costco.Locations.csv')

# Multi-store city location lookup by CSV row index
STORE_DESCRIPTORS = {
    # Alaska
    5: "Anchorage (South / Dimond)",
    6: "Anchorage (Spenard / DeBarr)",
    9: "Anchorage (Northeast / Business Center)",

    # Arizona
    14: "Gilbert (North / Baseline Rd)",
    23: "Gilbert (South / Market St)",
    11: "Phoenix (North / Beardsley Rd)",
    17: "Phoenix (Northwest / 83rd Ave)",
    21: "Phoenix (Paradise Valley / Oak St)",
    27: "Phoenix (East / Thomas Rd)",
    18: "Tucson (North / Thornydale)",
    26: "Tucson (South / Marketplace)",
    28: "Tucson (East / Grant Rd)",

    # California
    34: "Bakersfield (North / Rosedale)",
    146: "Bakersfield (South / Panama Lane)",
    44: "Chula Vista (South / Broadway)",
    115: "Chula Vista (East / Otay Ranch)",
    63: "Fresno (West / Shaw Ave)",
    99: "Fresno (North / Blackstone)",
    78: "Laguna Niguel (West / Heather Ridge)",
    79: "Laguna Niguel (East / Cabot Rd)",
    121: "Roseville (East / Stanford Ranch)",
    158: "Roseville (West / Baseline)",
    37: "Sacramento (Central / Expo Blvd)",
    101: "Sacramento (North / Stockton Blvd)",
    123: "Sacramento (South / Mack Rd)",
    39: "San Diego (Poway / Carmel Mountain)",
    90: "San Diego (Mission Valley)",
    94: "San Diego (Morena Blvd)",
    140: "San Diego (Southeast / Gateway)",
    33: "San Jose (Almaden Expressway)",
    68: "San Jose (South / Great Oaks)",
    104: "San Jose (North / Automation Pkwy)",
    128: "San Jose (Senter Rd)",
    53: "South San Francisco (El Camino Real)",
    122: "South San Francisco (Airport Blvd)",
    150: "Tustin (El Camino Real)",
    151: "Tustin (The District / Park Ave)",
    98: "Visalia (North / Dinuba Blvd)",
    157: "Visalia (South / Cameron Ave)",

    # Colorado
    167: "Colorado Springs (East / Powers Blvd)",
    176: "Colorado Springs (North / Nevada Ave)",
    166: "Littleton (County Line Rd)",
    173: "Littleton (South / Wadsworth)",

    # Florida
    200: "Fort Myers (South / Gulf Coast Town Ctr)",
    202: "Fort Myers (North / Cypress Lake)",
    197: "Jacksonville (East / Town Center)",
    219: "Jacksonville (West / Argyle Forest)",
    199: "Miami (South / Kendall)",
    206: "Miami (West / Flagler St)",

    # Georgia
    226: "Atlanta (Perimeter / Dunwoody)",
    228: "Atlanta (Cumberland / Cobb Pkwy)",
    232: "Atlanta (Sandy Springs)",

    # Hawaii
    239: "Honolulu (Iwilei / Alakawa St)",
    241: "Honolulu (Hawaii Kai)",

    # Illinois
    256: "Chicago (Ashland Ave / South)",
    262: "Chicago (Clybourn Ave / Lincoln Park)",
    267: "Naperville (West / Route 59)",
    271: "Naperville (East / 75th St)",

    # Indiana
    278: "Indianapolis (Castleton / 86th St)",
    281: "Indianapolis (Northwest / Michigan Rd)",
    285: "Indianapolis (South / Stop 11 Rd)",

    # Kentucky
    293: "Louisville (Bardstown Rd)",
    296: "Louisville (East / Norton Commons)",

    # Michigan
    328: "Livonia (West / Middlebelt)",
    333: "Livonia (East / Haggerty Rd)",

    # Missouri
    351: "Kansas City (Linwood Blvd)",
    357: "Kansas City (North / Boardwalk Dr)",
    356: "Saint Louis (South / Rusty Rd)",
    359: "Saint Louis (North / Olive Blvd)",

    # Nebraska
    367: "Omaha (Dodge St)",
    368: "Omaha (South / Maple St)",

    # Nevada
    371: "Henderson (Marks St)",
    375: "Henderson (St Rose Pkwy)",
    370: "Las Vegas (Centennial Hills)",
    374: "Las Vegas (South / Decatur Blvd)",
    377: "Las Vegas (Summerlin / Charleston Blvd)",

    # New Mexico
    397: "Albuquerque (Central / Eubank)",
    399: "Albuquerque (North / Coors Blvd)",
    400: "Albuquerque (South / Montano)",

    # North Carolina
    426: "Raleigh (South / Garner)",
    427: "Raleigh (North / Six Forks)",

    # Ohio
    435: "Columbus (North / Polaris Pkwy)",
    437: "Columbus (East / Easton)",

    # Oklahoma
    445: "Tulsa (North / 46th St)",
    448: "Tulsa (South / Memorial Dr)",

    # Puerto Rico
    475: "Bayamon (West)",
    477: "Bayamon (East)",
    474: "San Juan (East / Carolina)",
    480: "San Juan (Correction required - verify coordinate)",

    # Texas
    499: "Austin (North / Research Blvd)",
    526: "Austin (South / William Cannon)",
    507: "Fort Worth (South / Overton Ridge)",
    519: "Fort Worth (North / Alliance)",
    497: "Houston (Bunker Hill / West)",
    509: "Houston (Galleria / Richmond Ave)",
    539: "Houston (North / Willowbrook)",
    504: "Plano (East / Coit Rd)",
    535: "Plano (West / Tollway)",
    520: "San Antonio (North / Loop 1604)",
    530: "San Antonio (Northeast / Sonterra)",
    536: "San Antonio (West / Westover Hills)",

    # Utah
    547: "Salt Lake City (Central / 300 West)",
    553: "Salt Lake City (West Valley)",

    # Washington
    591: "Spokane (North / Division St)",
    603: "Spokane (Valley / Sprague Ave)"
}

# Apply detailed descriptor or default city name
df['location_descriptor'] = df.index.map(lambda i: STORE_DESCRIPTORS.get(i, df.loc[i, 'city_name']))

# Export enriched CSV or JSON
df.to_csv('costco.Locations.Enriched.csv', index=False)
print("Enriched dataset successfully created!")