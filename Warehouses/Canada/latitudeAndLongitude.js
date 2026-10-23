async function getCoordsFromOSM(street, city, postalCode) {
  const query = encodeURIComponent(`${street}, ${city}, ON ${postalCode}, Canada`);
  const url = `https://nominatim.openstreetmap.org/search?q=${query}&format=json&limit=1`;
  
  const response = await fetch(url, { headers: { 'User-Agent': 'AisleHeroWarehouseGeocoder/1.0' } });
  const data = await response.json();
  
  if (data && data.length > 0) {
    return { lat: parseFloat(data[0].lat), lng: parseFloat(data[0].lon) };
  }
  return { lat: null, lng: null };
}