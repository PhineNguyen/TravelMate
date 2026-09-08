import json
from groq import AsyncGroq
from app.core.config import settings
from app.core.helpers import clean_json_response, try_repair_json
from app.features.tips.prompts import get_travel_tips_prompt

client = AsyncGroq(api_key=settings.GROQ_API_KEY)


async def generate_travel_tips(
    destination: str,
    duration_days: int,
    travel_style: str,
    traveler_count: int,
    season: str = None,
    preferences: list = None
) -> dict:
    prompt = get_travel_tips_prompt(
        destination=destination,
        duration_days=duration_days,
        travel_style=travel_style,
        traveler_count=traveler_count,
        season=season,
        preferences=preferences or []
    )

    response_text = ""
    try:
        response = await client.chat.completions.create(
            model=settings.GROQ_MODEL,
            messages=[{"role": "user", "content": prompt}],
            temperature=0.3,
            max_tokens=4096,
            response_format={"type": "json_object"}
        )
        response_text = response.choices[0].message.content or "{}"
        print(f"[Travel Tips] Generated tips for: {destination}")

        cleaned = clean_json_response(response_text)
        repaired = try_repair_json(cleaned)
        data = json.loads(repaired)

        if isinstance(data, dict):
            # Ensure required fields exist
            data.setdefault("destination", destination)
            data.setdefault("overview", f"Khám phá {destination} - điểm đến hấp dẫn của Việt Nam.")
            data.setdefault("best_time_to_visit", "Tham khảo thêm thông tin thời tiết địa phương.")
            data.setdefault("tips", [])
            data.setdefault("local_etiquette", [])
            data.setdefault("safety_tips", [])
            data.setdefault("money_saving_tips", [])
            data.setdefault("hidden_gems", [])
            data.setdefault("useful_phrases", [])
            return data

        return {}
    except Exception as e:
        print(f"[Travel Tips] Error: {ascii(e)}")
        if response_text:
            print(f"Raw response: {ascii(response_text)}")
        return {}
