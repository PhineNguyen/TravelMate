import json
from groq import AsyncGroq
from app.core.config import settings
from app.core.helpers import clean_json_response, try_repair_json
from app.features.review.prompts import get_trip_review_prompt

client = AsyncGroq(api_key=settings.GROQ_API_KEY)


async def review_trip_itinerary(
    destination: str,
    budget: float,
    traveler_count: int,
    travel_style: str,
    preferences: list,
    itinerary: list
) -> dict:
    # Serialize the full itinerary to JSON (131K context handles this easily)
    itinerary_data = []
    for day in itinerary:
        if hasattr(day, "dict"):
            itinerary_data.append(day.dict())
        elif isinstance(day, dict):
            itinerary_data.append(day)
        else:
            itinerary_data.append(str(day))

    itinerary_json = json.dumps(itinerary_data, ensure_ascii=False, indent=2)

    prompt = get_trip_review_prompt(
        destination=destination,
        budget=budget,
        traveler_count=traveler_count,
        travel_style=travel_style,
        preferences=preferences or [],
        itinerary_json=itinerary_json
    )

    response_text = ""
    try:
        response = await client.chat.completions.create(
            model=settings.GROQ_MODEL,
            messages=[{"role": "user", "content": prompt}],
            temperature=0.2,
            max_tokens=3000,
            response_format={"type": "json_object"}
        )
        response_text = response.choices[0].message.content or "{}"
        print(f"[Trip Review] Reviewed itinerary for: {destination} ({len(itinerary)} days)")

        cleaned = clean_json_response(response_text)
        repaired = try_repair_json(cleaned)
        data = json.loads(repaired)

        if isinstance(data, dict):
            # Ensure scores field exists with all sub-fields
            if "scores" not in data:
                data["scores"] = {
                    "balance": 7.0,
                    "diversity": 7.0,
                    "budget_efficiency": 7.0,
                    "pacing": 7.0,
                    "local_authenticity": 7.0
                }
            # Compute overall_score from sub-scores if missing
            if "overall_score" not in data or not data["overall_score"]:
                scores = data["scores"]
                vals = [v for v in scores.values() if isinstance(v, (int, float))]
                data["overall_score"] = round(sum(vals) / len(vals), 1) if vals else 7.0

            data.setdefault("destination", destination)
            data.setdefault("verdict", "Lịch trình đã được phân tích.")
            data.setdefault("strengths", [])
            data.setdefault("weaknesses", [])
            data.setdefault("suggestions", [])
            data.setdefault("budget_analysis", f"Ngân sách {budget:,.0f} VNĐ cho {traveler_count} người.")
            data.setdefault("optimized_tip", "Hãy linh hoạt với lịch trình và tìm hiểu thêm về địa phương!")
            return data

        return {}
    except Exception as e:
        print(f"[Trip Review] Error: {ascii(e)}")
        if response_text:
            print(f"Raw response: {ascii(response_text)}")
        return {}
