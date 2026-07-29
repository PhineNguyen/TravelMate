import httpx
from app.config import settings

CATEGORY_MAPPING = {
    "restaurant": "catering.restaurant,catering.fast_food,catering.cafe",
    "attraction": "tourism.sights,tourism.attraction,entertainment",
    "accommodation": "accommodation.hotel,accommodation.guest_house"
}

async def fetch_places_from_geoapify(lat: float, lon: float, radius_km: float, category: str, limit: int = 20):
    geo_category = CATEGORY_MAPPING.get(category, "tourism.sights")
    radius_meters = int(radius_km * 1000)
    
    url = "https://api.geoapify.com/v2/places"
    params = {
        "categories": geo_category,
        "filter": f"circle:{lon},{lat},{radius_meters}",
        "bias": f"proximity:{lon},{lat}",
        "limit": limit,
        "apiKey": settings.GEOAPIFY_API_KEY
    }
    
    try:
        async with httpx.AsyncClient() as client:
            response = await client.get(url, params=params, timeout=10.0)
            response.raise_for_status()
            data = response.json()
    except Exception as e:
        print(f"Error calling Geoapify API: {e}")
        return []
        
    places = []
    for feature in data.get("features", []):
        props = feature.get("properties", {})
        contact = props.get("contact") or {}
        places.append({
            "name": props.get("name") or props.get("formatted", "Địa điểm không tên"),
            "address": props.get("formatted", ""),
            "latitude": props.get("lat"),
            "longitude": props.get("lon"),
            "categories": props.get("categories", []),
            "website": props.get("website"),
            "phone": contact.get("phone") or props.get("phone"),
            "opening_hours": props.get("opening_hours")
        })
    return places