import json
from groq import AsyncGroq
from app.core.config import settings
from app.core.helpers import clean_json_response, try_repair_json
from app.features.packing.prompts import get_packing_list_prompt

client = AsyncGroq(api_key=settings.GROQ_API_KEY)


async def generate_packing_list(
    destination: str,
    duration_days: int,
    travel_style: str,
    season: str = None,
    activities: list = None,
    traveler_profile: str = "couple",
    special_needs: list = None
) -> dict:
    prompt = get_packing_list_prompt(
        destination=destination,
        duration_days=duration_days,
        travel_style=travel_style,
        season=season,
        activities=activities or [],
        traveler_profile=traveler_profile,
        special_needs=special_needs or []
    )

    response_text = ""
    try:
        response = await client.chat.completions.create(
            model=settings.GROQ_MODEL,
            messages=[{"role": "user", "content": prompt}],
            temperature=0.2,
            max_tokens=4096,
            response_format={"type": "json_object"}
        )
        response_text = response.choices[0].message.content or "{}"
        print(f"[Packing List] Generated for: {destination} ({duration_days} days)")

        cleaned = clean_json_response(response_text)
        repaired = try_repair_json(cleaned)
        data = json.loads(repaired)

        if isinstance(data, dict):
            # Calculate total_items from categories if not set correctly
            categories = data.get("categories", [])
            total = sum(len(cat.get("items", [])) for cat in categories)
            data["total_items"] = total

            data.setdefault("destination", destination)
            data.setdefault("duration_days", duration_days)
            data.setdefault("special_notes", f"Hành lý được tối ưu cho chuyến đi {duration_days} ngày tại {destination}.")
            data.setdefault("luggage_advice", "Ba lô du lịch 40-50L hoặc vali kéo cỡ cabin phù hợp cho chuyến đi này.")
            return data

        return {}
    except Exception as e:
        print(f"[Packing List] Error: {ascii(e)}")
        if response_text:
            print(f"Raw response: {ascii(response_text)}")
        return {}
