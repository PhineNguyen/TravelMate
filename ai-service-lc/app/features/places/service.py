import httpx
import json
from app.core.config import settings
from app.core.helpers import clean_json_response, try_repair_json
from app.features.places.prompts import get_recommend_prompt

def check_is_indoor(categories: list) -> bool:
    if not categories:
        return False
    indoor_keywords = {
        "restaurant", "cafe", "fast_food", "bar", "food_court", "pub",
        "hotel", "hostel", "motel", "guest_house", "apartment", "chalet",
        "museum", "cinema", "theater", "mall", "shop", "supermarket",
        "place_of_worship", "church", "temple", "pagoda", "cathedral",
        "art_gallery", "library", "exhibition_centre"
    }
    outdoor_keywords = {
        "beach", "park", "garden", "nature_reserve", "forest", "mountain",
        "viewpoint", "waterfall", "lake", "river", "swimming_pool", "playground",
        "zoo", "theme_park", "amusement_park", "stadium"
    }
    is_indoor_match = False
    is_outdoor_match = False
    for cat in categories:
        cat_lower = cat.lower()
        if any(kw in cat_lower for kw in indoor_keywords):
            is_indoor_match = True
        if any(kw in cat_lower for kw in outdoor_keywords):
            is_outdoor_match = True
            
    if is_indoor_match and not is_outdoor_match:
        return True
    if is_outdoor_match:
        return False
    return False

async def rank_and_explain_places(user_preferences: list, raw_places: list, category: str) -> list:
    if not raw_places:
        return []

    simplified_places = []
    for idx, p in enumerate(raw_places):
        simplified_places.append({
            "id": idx,
            "name": p.get("name", ""),
            "categories": p.get("categories", [])
        })

    prompt = get_recommend_prompt(simplified_places, user_preferences, category)

    payload = {
        "model": settings.OLLAMA_MODEL,
        "prompt": prompt,
        "stream": False,
        "format": "json",
        "options": {
            "temperature": 0.1,
            "num_predict": 1024
        }
    }

    response_text = ""
    try:
        async with httpx.AsyncClient() as client:
            response = await client.post(
                f"{settings.OLLAMA_BASE_URL}/api/generate",
                json=payload,
                timeout=180.0
            )
            response.raise_for_status()
            response_text = response.json().get("response", "[]")
            print("--- Ollama Raw Response ---")
            print(ascii(response_text))
            print("---------------------------")
            
            cleaned = clean_json_response(response_text)
            repaired = try_repair_json(cleaned)
            data = json.loads(repaired)
            
            items = []
            if isinstance(data, dict):
                for key in ["recommendations", "places", "results", "items", "data"]:
                    if key in data and isinstance(data[key], list):
                        items = data[key]
                        break
            elif isinstance(data, list):
                items = data
            
            ranked_places = []
            for item in items:
                if not isinstance(item, dict):
                    continue
                matched_place = None
                
                if "id" in item:
                    try:
                        idx = int(item["id"])
                        if 0 <= idx < len(raw_places):
                            matched_place = raw_places[idx]
                    except (ValueError, TypeError):
                        pass
                
                if not matched_place and "name" in item:
                    name_lower = str(item["name"]).strip().lower()
                    for p in raw_places:
                        if p["name"].strip().lower() == name_lower:
                            matched_place = p
                            break
                            
                if matched_place:
                    lat = matched_place["latitude"]
                    lon = matched_place["longitude"]
                    google_maps_url = f"https://www.google.com/maps/search/?api=1&query={lat},{lon}"
                    is_indoor_flag = check_is_indoor(matched_place.get("categories", []))
                    ranked_places.append({
                        "name": matched_place["name"],
                        "category": category,
                        "address": matched_place["address"],
                        "latitude": lat,
                        "longitude": lon,
                        "reason": item.get("reason", "Địa điểm phù hợp với sở thích của bạn."),
                        "google_maps_url": google_maps_url,
                        "website_url": matched_place.get("website"),
                        "phone_number": matched_place.get("phone"),
                        "opening_hours": matched_place.get("opening_hours"),
                        "is_indoor": is_indoor_flag,
                        "city": matched_place.get("city"),
                        "country": matched_place.get("country"),
                        "image_url": matched_place.get("image_url"),
                        "source_provider": matched_place.get("source_provider")
                    })
            
            return ranked_places
            
    except Exception as e:
        print(f"Error calling Ollama or parsing response: {ascii(e)}")
        if response_text:
            print(f"Raw response text: {ascii(response_text)}")
        return []
