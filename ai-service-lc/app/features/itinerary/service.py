import httpx
import json
import math
import random
from app.core.config import settings
from app.core.helpers import clean_json_response, try_repair_json
from app.features.itinerary.prompts import (
    get_itinerary_prompt, get_optimize_route_prompt, get_weather_adjustment_prompt, get_hybrid_itinerary_prompt
)

async def generate_itinerary_llm(
    destination: str,
    duration_days: int,
    budget: float,
    travel_style: str,
    traveler_count: int,
    preferences: list = None
) -> dict:
    # 1. Try Hybrid Pipeline (Deterministic Geocoding, Clustering & Routing + LLM Synthesis)
    try:
        from app.features.places.geoapify import geocode_destination, fetch_places_from_geoapify
        
        print(f"[Hybrid Pipeline] Geocoding destination: {destination}")
        lat, lon = await geocode_destination(destination)
        if lat is not None and lon is not None:
            print(f"[Hybrid Pipeline] Found coords: ({lat}, {lon}). Fetching candidates from Geoapify...")
            attractions = await fetch_places_from_geoapify(lat, lon, radius_km=15, category="attraction", limit=25)
            restaurants = await fetch_places_from_geoapify(lat, lon, radius_km=15, category="restaurant", limit=20)
            accommodations = await fetch_places_from_geoapify(lat, lon, radius_km=15, category="accommodation", limit=5)
            
            print(f"[Hybrid Pipeline] Candidates found - Attractions: {len(attractions)}, Restaurants: {len(restaurants)}, Hotels: {len(accommodations)}")
            
            if len(attractions) >= duration_days and len(restaurants) >= 2:
                # K-Means Clustering on Attractions
                coords = [(p["latitude"], p["longitude"]) for p in attractions]
                k = duration_days
                centroids = random.sample(coords, min(k, len(coords)))
                while len(centroids) < k:
                    centroids.append(coords[0] if coords else (0, 0))
                
                clusters = [[] for _ in range(k)]
                for _ in range(10):  # 10 iterations
                    clusters = [[] for _ in range(k)]
                    for p in attractions:
                        plat, plon = p["latitude"], p["longitude"]
                        min_dist = float("inf")
                        best_c = 0
                        for c_idx, (clat, clon) in enumerate(centroids):
                            d = math.sqrt((plat - clat)**2 + (plon - clon)**2)
                            if d < min_dist:
                                min_dist = d
                                best_c = c_idx
                        clusters[best_c].append(p)
                    # Update centroids
                    for c_idx in range(k):
                        if clusters[c_idx]:
                            avg_lat = sum(p["latitude"] for p in clusters[c_idx]) / len(clusters[c_idx])
                            avg_lon = sum(p["longitude"] for p in clusters[c_idx]) / len(clusters[c_idx])
                            centroids[c_idx] = (avg_lat, avg_lon)
                
                # TSP (Nearest Neighbor) Sorting Helper
                def sort_by_tsp(places):
                    if len(places) <= 1:
                        return places
                    sorted_places = [places[0]]
                    remaining = places[1:]
                    while remaining:
                        last = sorted_places[-1]
                        min_dist = float("inf")
                        best_idx = 0
                        for idx, p in enumerate(remaining):
                            d = math.sqrt((last["latitude"] - p["latitude"])**2 + (last["longitude"] - p["longitude"])**2)
                            if d < min_dist:
                                min_dist = d
                                best_idx = idx
                        sorted_places.append(remaining.pop(best_idx))
                    return sorted_places

                # Build Skeleton Itinerary
                itinerary_list = []
                default_hotel = accommodations[0]["name"] if accommodations else "Khách sạn địa phương"
                daily_budget = budget / duration_days
                used_restaurants = set()
                
                for day_idx in range(duration_days):
                    day_num = day_idx + 1
                    day_attractions = clusters[day_idx]
                    day_attractions = sort_by_tsp(day_attractions)
                    
                    day_activities = []
                    
                    def find_nearest_restaurant(lat_bias, lon_bias):
                        best_rest = None
                        min_dist = float("inf")
                        for r in restaurants:
                            r_name = r["name"]
                            if r_name in used_restaurants:
                                continue
                            d = math.sqrt((lat_bias - r["latitude"])**2 + (lon_bias - r["longitude"])**2)
                            if d < min_dist:
                                min_dist = d
                                best_rest = r
                        if best_rest:
                            used_restaurants.add(best_rest["name"])
                            return best_rest["name"]
                        if restaurants:
                            return random.choice(restaurants)["name"]
                        return "Quán ăn địa phương"

                    # Morning Attraction (Ticket ~10% day budget)
                    m_att = day_attractions[0] if len(day_attractions) > 0 else None
                    if m_att:
                        day_activities.append({
                            "time": "08:30 - 11:30",
                            "start_time": "08:30",
                            "duration_minutes": 180,
                            "place_name": m_att["name"],
                            "category": "attraction",
                            "estimated_cost": int(daily_budget * 0.1),
                            "description": ""
                        })
                    
                    # Lunch Restaurant (~15% day budget)
                    lunch_bias_lat = m_att["latitude"] if m_att else lat
                    lunch_bias_lon = m_att["longitude"] if m_att else lon
                    lunch_name = find_nearest_restaurant(lunch_bias_lat, lunch_bias_lon)
                    day_activities.append({
                        "time": "12:00 - 13:30",
                        "start_time": "12:00",
                        "duration_minutes": 90,
                        "place_name": lunch_name,
                        "category": "restaurant",
                        "estimated_cost": int(daily_budget * 0.15),
                        "description": ""
                    })
                    
                    # Afternoon Attraction (~10% day budget)
                    a_att = day_attractions[1] if len(day_attractions) > 1 else (day_attractions[0] if len(day_attractions) > 0 and len(day_activities) == 1 else None)
                    if a_att:
                        day_activities.append({
                            "time": "14:00 - 17:00",
                            "start_time": "14:00",
                            "duration_minutes": 180,
                            "place_name": a_att["name"],
                            "category": "attraction",
                            "estimated_cost": int(daily_budget * 0.1),
                            "description": ""
                        })
                    
                    # Dinner Restaurant (~15% day budget)
                    dinner_bias_lat = a_att["latitude"] if a_att else lunch_bias_lat
                    dinner_bias_lon = a_att["longitude"] if a_att else lunch_bias_lon
                    dinner_name = find_nearest_restaurant(dinner_bias_lat, dinner_bias_lon)
                    day_activities.append({
                        "time": "18:30 - 20:00",
                        "start_time": "18:30",
                        "duration_minutes": 90,
                        "place_name": dinner_name,
                        "category": "restaurant",
                        "estimated_cost": int(daily_budget * 0.15),
                        "description": ""
                    })

                    # Evening Hotel Stay (~30% day budget)
                    day_activities.append({
                        "time": "20:30 - 22:00",
                        "start_time": "20:30",
                        "duration_minutes": 90,
                        "place_name": default_hotel,
                        "category": "accommodation",
                        "estimated_cost": int(daily_budget * 0.3),
                        "description": ""
                    })

                    itinerary_list.append({
                        "day": day_num,
                        "theme": f"Khám phá ẩm thực & danh thắng ngày {day_num}",
                        "activities": day_activities
                    })

                # Flatten activities to simplify for LLM
                simplified_activities = []
                idx = 0
                for day in itinerary_list:
                    for act in day["activities"]:
                        simplified_activities.append({
                            "index": idx,
                            "place_name": act["place_name"],
                            "category": act["category"]
                        })
                        idx += 1

                # Construct prompt for the LLM to fill descriptions
                hybrid_prompt = get_hybrid_itinerary_prompt(destination, travel_style, preferences, simplified_activities)

                payload = {
                    "model": settings.OLLAMA_MODEL,
                    "prompt": hybrid_prompt,
                    "stream": False,
                    "format": "json",
                    "options": {
                        "temperature": 0.1,
                        "num_predict": 1024
                    }
                }

                print("[Hybrid Pipeline] Sending simplified activities to LLM for description synthesis...")
                async with httpx.AsyncClient() as client:
                    response = await client.post(
                        f"{settings.OLLAMA_BASE_URL}/api/generate",
                        json=payload,
                        timeout=180.0
                    )
                    response.raise_for_status()
                    response_text = response.json().get("response", "{}")
                    
                    cleaned = clean_json_response(response_text)
                    repaired = try_repair_json(cleaned)
                    data = json.loads(repaired)
                    if isinstance(data, dict) and "descriptions" in data:
                        desc_list = data.get("descriptions", [])
                        idx = 0
                        for day in itinerary_list:
                            for act in day["activities"]:
                                if idx < len(desc_list):
                                    act["description"] = desc_list[idx]
                                else:
                                    act["description"] = f"Khám phá {act['place_name']}."
                                idx += 1
                        
                        skeleton = {
                            "destination": destination,
                            "duration_days": duration_days,
                            "estimated_total_cost": budget,
                            "summary": data.get("summary", f"Chuyến đi khám phá {destination}."),
                            "itinerary": itinerary_list
                        }
                        print("[Hybrid Pipeline] Success!")
                        return skeleton
    except Exception as hybrid_err:
        print(f"[Hybrid Pipeline] Failed, falling back to LLM-only: {hybrid_err}")

    # 2. Fallback: Old LLM-only Generation Flow
    print("[Fallback] Running LLM-only itinerary generation...")
    prompt = get_itinerary_prompt(destination, duration_days, budget, travel_style, traveler_count, preferences)
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
            response_text = response.json().get("response", "{}")
            
            cleaned = clean_json_response(response_text)
            repaired = try_repair_json(cleaned)
            data = json.loads(repaired)
            
            if isinstance(data, dict):
                return data
            return {}
    except Exception as e:
        print(f"Error in LLM fallback flow: {ascii(e)}")
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

    # Sort locations deterministically based on coordinates (Nearest Neighbor TSP)
    with_coords = [loc for loc in loc_list if loc.get("latitude") is not None and loc.get("longitude") is not None]
    no_coords = [loc for loc in loc_list if loc.get("latitude") is None or loc.get("longitude") is None]

    sorted_list = []
    if with_coords:
        current = with_coords.pop(0)
        sorted_list.append(current)
        while with_coords:
            last = sorted_list[-1]
            min_dist = float("inf")
            best_idx = 0
            for idx, loc in enumerate(with_coords):
                d = math.sqrt((last["latitude"] - loc["latitude"])**2 + (last["longitude"] - loc["longitude"])**2)
                if d < min_dist:
                    min_dist = d
                    best_idx = idx
            sorted_list.append(with_coords.pop(best_idx))
    
    sorted_list.extend(no_coords)

    optimized_route = []
    for idx, loc in enumerate(sorted_list):
        category = loc.get("category") or ""
        desc = "Thư giãn, nghỉ ngơi sau thời gian di chuyển." if "accommodation" in category.lower() or "hotel" in category.lower() else (
            "Dùng bữa ẩm thực, phục hồi năng lượng." if "restaurant" in category.lower() or "cafe" in category.lower() else "Tham quan trải nghiệm địa phương."
        )
        optimized_route.append({
            "location_name": loc["location_name"],
            "optimized_sequence": idx + 1,
            "place_id": loc.get("place_id"),
            "description": desc
        })

    return optimized_route

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
