import httpx
import json
from app.core.config import settings
from app.core.helpers import clean_json_response, try_repair_json
from app.features.itinerary.prompts import (
    get_itinerary_prompt, get_optimize_route_prompt, get_weather_adjustment_prompt
)

async def generate_itinerary_llm(
    destination: str,
    duration_days: int,
    budget: float,
    travel_style: str,
    traveler_count: int,
    preferences: list = None
) -> dict:
    prompt = get_itinerary_prompt(destination, duration_days, budget, travel_style, traveler_count, preferences)

    payload = {
        "model": settings.OLLAMA_MODEL,
        "prompt": prompt,
        "stream": False,
        "format": "json",
        "options": {
            "temperature": 0.1,
            "num_predict": 2048
        }
    }

    response_text = ""
    try:
        async with httpx.AsyncClient() as client:
            response = await client.post(
                f"{settings.OLLAMA_BASE_URL}/api/generate",
                json=payload,
                timeout=600.0
            )
            response.raise_for_status()
            response_text = response.json().get("response", "{}")
            
            cleaned = clean_json_response(response_text)
            repaired = try_repair_json(cleaned)
            data = json.loads(repaired)
            
            if isinstance(data, dict):
                return data
            return {}
            
    except Exception as e:
        print(f"Error generating itinerary or parsing: {ascii(e)}")
        if response_text:
            print(f"Raw response text: {ascii(response_text)}")
        return {}

async def optimize_route_llm(locations: list) -> list:
    if not locations:
        return []

    loc_list = []
    for loc in locations:
        if hasattr(loc, "dict"):
            loc_list.append(loc.dict())
        elif isinstance(loc, dict):
            loc_list.append(loc)
        else:
            loc_list.append({
                "location_name": getattr(loc, "location_name", ""),
                "current_sequence": getattr(loc, "current_sequence", 0),
                "place_id": getattr(loc, "place_id", None),
                "latitude": getattr(loc, "latitude", None),
                "longitude": getattr(loc, "longitude", None),
                "category": getattr(loc, "category", None)
            })

    prompt = get_optimize_route_prompt(loc_list)

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
                timeout=600.0
            )
            response.raise_for_status()
            response_text = response.json().get("response", "[]")
            print("--- Ollama Optimize Route Raw Response ---")
            print(ascii(response_text))
            print("------------------------------------------")

            cleaned = clean_json_response(response_text)
            repaired = try_repair_json(cleaned)
            data = json.loads(repaired)

            items = []
            if isinstance(data, dict):
                for key in ["optimized_route", "route", "data", "items"]:
                    if key in data and isinstance(data[key], list):
                        items = data[key]
                        break
            elif isinstance(data, list):
                items = data

            # Extract location_name, optimized_sequence, place_id, and description
            optimized_route = []
            for item in items:
                if isinstance(item, dict) and "location_name" in item and "optimized_sequence" in item:
                    try:
                        optimized_route.append({
                            "location_name": item["location_name"],
                            "optimized_sequence": int(item["optimized_sequence"]),
                            "place_id": item.get("place_id"),
                            "description": item.get("description")
                        })
                    except (ValueError, TypeError):
                        continue
            
            if optimized_route:
                return optimized_route
            return [{
                "location_name": loc["location_name"], 
                "optimized_sequence": idx + 1,
                "place_id": loc.get("place_id"),
                "description": None
            } for idx, loc in enumerate(loc_list)]

    except Exception as e:
        print(f"Error optimizing route: {ascii(e)}")
        if response_text:
            print(f"Raw response: {ascii(response_text)}")
        return [{
            "location_name": loc["location_name"], 
            "optimized_sequence": idx + 1,
            "place_id": loc.get("place_id"),
            "description": None
        } for idx, loc in enumerate(loc_list)]

async def adjust_weather_llm(
    weather_alert: str,
    budget_limit: float,
    current_activities: list,
    latitude: float,
    longitude: float,
    radius_km: float = 5.0
) -> dict:
    if not current_activities:
        return {"updated_activities": [], "adjustment_reason": "Không có hoạt động nào cần điều chỉnh."}

    activities_list = []
    for act in current_activities:
        if hasattr(act, "dict"):
            activities_list.append(act.dict())
        elif isinstance(act, dict):
            activities_list.append(act)
        else:
            activities_list.append({
                "time": getattr(act, "time", ""),
                "start_time": getattr(act, "start_time", ""),
                "duration_minutes": getattr(act, "duration_minutes", 0),
                "place_name": getattr(act, "place_name", ""),
                "category": getattr(act, "category", ""),
                "estimated_cost": getattr(act, "estimated_cost", 0.0),
                "description": getattr(act, "description", "")
            })

    # Fetch candidate places from Geoapify
    indoor_candidates = []
    try:
        from app.features.places.geoapify import fetch_places_from_geoapify
        from app.features.places.service import check_is_indoor
        
        # Fetch both attractions and restaurants
        attractions = await fetch_places_from_geoapify(latitude, longitude, radius_km, "attraction", limit=20)
        restaurants = await fetch_places_from_geoapify(latitude, longitude, radius_km, "restaurant", limit=15)
        
        raw_candidates = attractions + restaurants
        
        # Filter for indoor candidates only
        seen_names = set()
        for p in raw_candidates:
            if p["name"] not in seen_names and check_is_indoor(p.get("categories", [])):
                seen_names.add(p["name"])
                indoor_candidates.append({
                    "name": p["name"],
                    "address": p["address"],
                    "categories": p.get("categories", [])
                })
    except Exception as geo_err:
        print(f"Error fetching indoor candidates from Geoapify: {geo_err}")

    prompt = get_weather_adjustment_prompt(weather_alert, budget_limit, activities_list, indoor_candidates)

    payload = {
        "model": settings.OLLAMA_MODEL,
        "prompt": prompt,
        "stream": False,
        "format": "json",
        "options": {
            "temperature": 0.1,
            "num_predict": 2048
        }
    }

    response_text = ""
    try:
        async with httpx.AsyncClient() as client:
            response = await client.post(
                f"{settings.OLLAMA_BASE_URL}/api/generate",
                json=payload,
                timeout=600.0
            )
            response.raise_for_status()
            response_text = response.json().get("response", "{}")
            print("--- Ollama Adjust Weather Raw Response ---")
            print(ascii(response_text))
            print("------------------------------------------")

            cleaned = clean_json_response(response_text)
            repaired = try_repair_json(cleaned)
            data = json.loads(repaired)

            if isinstance(data, dict):
                return data
            return {"updated_activities": activities_list, "adjustment_reason": "Không thể điều chỉnh lịch trình do lỗi xử lý cấu trúc."}

    except Exception as e:
        print(f"Error adjusting weather: {ascii(e)}")
        if response_text:
            print(f"Raw response: {ascii(response_text)}")
        return {
            "updated_activities": activities_list,
            "adjustment_reason": f"Không thể điều chỉnh lịch trình do lỗi hệ thống: {str(e)}"
        }
