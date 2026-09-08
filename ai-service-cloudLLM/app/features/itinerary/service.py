import json
import math
import random
from groq import AsyncGroq
from app.core.config import settings
from app.core.helpers import clean_json_response, try_repair_json
from app.features.itinerary.prompts import (
    get_itinerary_prompt, get_optimize_route_prompt, get_weather_adjustment_prompt, get_hybrid_itinerary_prompt
)

client = AsyncGroq(api_key=settings.GROQ_API_KEY)


async def generate_itinerary_llm(
    destination: str,
    duration_days: int,
    budget: float,
    travel_style: str,
    traveler_count: int,
    preferences: list = None
) -> dict:
    print(f"[Itinerary Planner] Generating realistic itinerary for '{destination}' ({duration_days} days, budget: {budget:,.0f} VND)...")
    prompt = get_itinerary_prompt(destination, duration_days, budget, travel_style, traveler_count, preferences)

    response_text = ""
    try:
        try:
            response = await client.chat.completions.create(
                model=settings.GROQ_MODEL,
                messages=[
                    {"role": "system", "content": "You are a professional travel planner in Vietnam. You must output a valid JSON object matching the requested schema."},
                    {"role": "user", "content": prompt}
                ],
                temperature=0.2,
                max_tokens=4000,
                reasoning_effort="low",
                response_format={"type": "json_object"}
            )
            response_text = response.choices[0].message.content or "{}"
        except Exception as groq_err:
            print(f"[Itinerary Planner] First attempt with json_object failed: {groq_err}. Retrying without format constraint...")
            response = await client.chat.completions.create(
                model=settings.GROQ_MODEL,
                messages=[
                    {"role": "system", "content": "You are a professional travel planner in Vietnam. Output strictly a valid JSON object without markdown or conversational text."},
                    {"role": "user", "content": prompt}
                ],
                temperature=0.2,
                max_tokens=4000,
                reasoning_effort="low"
            )
            response_text = response.choices[0].message.content or "{}"

        cleaned = clean_json_response(response_text)
        repaired = try_repair_json(cleaned)
        data = json.loads(repaired)

        if not isinstance(data, dict):
            raise ValueError("Phản hồi từ AI không phải định dạng JSON hợp lệ.")

        # Chuẩn hóa các trường cốt lõi
        data["destination"] = data.get("destination") or destination
        data["duration_days"] = int(data.get("duration_days") or duration_days)
        data["estimated_total_cost"] = float(data.get("estimated_total_cost") or budget)
        data["summary"] = data.get("summary") or f"Chuyến đi khám phá {destination} {duration_days} ngày đáng nhớ."
        data["highlights"] = data.get("highlights") or []
        data["travel_warnings"] = data.get("travel_warnings") or []

        # Chuẩn hóa chi tiết từng ngày và từng hoạt động
        raw_itinerary = data.get("itinerary", [])
        if isinstance(raw_itinerary, dict):
            itinerary_days = list(raw_itinerary.values())
        elif isinstance(raw_itinerary, list):
            itinerary_days = raw_itinerary
        else:
            itinerary_days = []

        normalized_days = []
        calculated_total_cost = 0.0

        for day_idx, day_obj in enumerate(itinerary_days):
            if not isinstance(day_obj, dict):
                continue

            day_num = day_obj.get("day", day_idx + 1)
            try:
                day_num = int(day_num)
            except Exception:
                day_num = day_idx + 1
            day_obj["day"] = day_num
            day_obj["theme"] = day_obj.get("theme") or f"Khám phá {destination} ngày {day_num}"

            raw_activities = day_obj.get("activities", [])
            if isinstance(raw_activities, dict):
                raw_activities = list(raw_activities.values())
            elif not isinstance(raw_activities, list):
                raw_activities = []

            normalized_activities = []
            for act in raw_activities:
                if isinstance(act, str):
                    act = {"place_name": act, "description": act}
                elif not isinstance(act, dict):
                    continue

                try:
                    cost = float(act.get("estimated_cost", 0.0))
                except (ValueError, TypeError):
                    cost = 0.0
                calculated_total_cost += cost
                act["estimated_cost"] = cost

                # Đảm bảo start_time và duration_minutes
                if not act.get("start_time") and act.get("time"):
                    parts = str(act["time"]).split("-")
                    act["start_time"] = parts[0].strip() if parts else "08:00"

                if not act.get("duration_minutes"):
                    act["duration_minutes"] = 90
                else:
                    try:
                        act["duration_minutes"] = int(act["duration_minutes"])
                    except Exception:
                        act["duration_minutes"] = 90

                # Chuẩn hóa phương tiện di chuyển & mẹo bản địa
                if not act.get("transport_to_next"):
                    act["transport_to_next"] = "Di chuyển bằng xe máy hoặc taxi"
                if not act.get("local_tip"):
                    act["local_tip"] = f"Nên đến sớm và thưởng thức trọn vẹn trải nghiệm tại {act.get('place_name', 'địa điểm này')}."

                normalized_activities.append(act)

            day_obj["activities"] = normalized_activities
            normalized_days.append(day_obj)

        data["itinerary"] = normalized_days

        # Cập nhật lại tổng chi phí nếu AI tính toán chênh lệch
        if calculated_total_cost > 0 and abs(calculated_total_cost - budget) < budget * 0.5:
            data["estimated_total_cost"] = calculated_total_cost

        print(f"[Itinerary Planner] Successfully generated {len(normalized_days)} days for {destination}!")
        return data

    except Exception as e:
        print(f"[Itinerary Planner] Error generating itinerary: {e}")
        if response_text:
            print(f"[Itinerary Planner] Raw response: {response_text[:300]}...")
        raise e


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

    response_text = ""
    try:
        response = await client.chat.completions.create(
            model=settings.GROQ_MODEL,
            messages=[{"role": "user", "content": prompt}],
            temperature=0.1,
            max_tokens=4096,
            response_format={"type": "json_object"}
        )
        response_text = response.choices[0].message.content or "{}"
        print("--- Groq Adjust Weather Raw Response ---")
        print(ascii(response_text))
        print("---------------------------------------")

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
