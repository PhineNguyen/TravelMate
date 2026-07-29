import httpx
import json
from app.config import settings

def clean_json_response(raw_text: str) -> str:
    """
    Cleans markdown wrappers or backticks often returned by LLMs
    to extract a clean JSON string.
    """
    raw_text = raw_text.strip()
    if raw_text.startswith("```"):
        lines = raw_text.splitlines()
        if lines[0].startswith("```"):
            lines = lines[1:]
        if lines and lines[-1].startswith("```"):
            lines = lines[:-1]
        raw_text = "\n".join(lines).strip()
    return raw_text

def try_repair_json(json_str: str) -> str:
    """
    Attempts to repair incomplete or truncated JSON strings by closing
    any unclosed quotes, braces, or brackets, and removing trailing commas.
    """
    json_str = json_str.strip()
    if not json_str:
        return json_str

    # Clean trailing characters and commas
    while True:
        original_length = len(json_str)
        json_str = json_str.strip()
        if json_str.endswith(","):
            json_str = json_str[:-1]
        if len(json_str) == original_length:
            break

    open_brackets = []
    in_string = False
    escape = False

    for char in json_str:
        if escape:
            escape = False
            continue
        if char == '\\':
            escape = True
            continue
        if char == '"':
            in_string = not in_string
            continue
        if in_string:
            continue
        if char in ['{', '[']:
            open_brackets.append(char)
        elif char in ['}', ']']:
            if open_brackets:
                open_brackets.pop()

    if in_string:
        json_str += '"'

    for bracket in reversed(open_brackets):
        while True:
            json_str = json_str.strip()
            if json_str.endswith(","):
                json_str = json_str[:-1]
            else:
                break
        if bracket == '{':
            json_str += '}'
        elif bracket == '[':
            json_str += ']'

    return json_str

async def rank_and_explain_places(user_preferences: list, raw_places: list, category: str) -> list:
    if not raw_places:
        return []

    # Simplify places to reduce token count and speed up local inference
    simplified_places = []
    for idx, p in enumerate(raw_places):
        simplified_places.append({
            "id": idx,
            "name": p.get("name", ""),
            "categories": p.get("categories", [])
        })

    prompt = f"""
    Bạn là trợ lý du lịch AI thông minh.
    Danh sách địa điểm thực tế tìm được (định dạng: ID và Tên):
    {json.dumps(simplified_places, ensure_ascii=False)}
    
    Sở thích người dùng: {', '.join(user_preferences) if user_preferences else 'Không có'}
    Loại địa điểm: {category}

    Hãy chọn ra tối đa 5 địa điểm phù hợp nhất với sở thích của người dùng từ danh sách trên.
    Với mỗi địa điểm được chọn, đưa ra 1 lý do ngắn gọn (1-2 câu).
    
    Trả về ĐÚNG cấu trúc mảng JSON chứa các đối tượng có thuộc tính "id" và "reason" như sau:
    [
      {{
        "id": 0,
        "reason": "Lý do gợi ý địa điểm này..."
      }}
    ]
    """

    payload = {
        "model": settings.OLLAMA_MODEL,
        "prompt": prompt,
        "stream": False,
        "format": "json",
        "options": {
            "temperature": 0.1,      # Thấp để đảm bảo tuân thủ định dạng JSON tốt hơn
            "num_predict": 1024      # Đảm bảo đủ độ dài không bị cắt cụt
        }
    }

    response_text = ""
    try:
        async with httpx.AsyncClient() as client:
            response = await client.post(
                f"{settings.OLLAMA_BASE_URL}/api/generate",
                json=payload,
                timeout=180.0  # Tăng timeout lên 180 giây để chạy local ổn định
            )
            response.raise_for_status()
            response_text = response.json().get("response", "[]")
            print("--- Ollama Raw Response ---")
            print(ascii(response_text))
            print("---------------------------")
            
            cleaned = clean_json_response(response_text)
            repaired = try_repair_json(cleaned)
            data = json.loads(repaired)
            
            # Normalize list format
            items = []
            if isinstance(data, dict):
                for key in ["recommendations", "places", "results", "items", "data"]:
                    if key in data and isinstance(data[key], list):
                        items = data[key]
                        break
            elif isinstance(data, list):
                items = data
            
            # Map selected items back to original raw_places
            ranked_places = []
            for item in items:
                if not isinstance(item, dict):
                    continue
                matched_place = None
                
                # Try matching by ID first
                if "id" in item:
                    try:
                        idx = int(item["id"])
                        if 0 <= idx < len(raw_places):
                            matched_place = raw_places[idx]
                    except (ValueError, TypeError):
                        pass
                
                # Fallback to matching by Name if ID is missing or invalid
                if not matched_place and "name" in item:
                    name_lower = str(item["name"]).strip().lower()
                    for p in raw_places:
                        if p["name"].strip().lower() == name_lower:
                            matched_place = p
                            break
                            
                if matched_place:
                    ranked_places.append({
                        "name": matched_place["name"],
                        "category": category,
                        "address": matched_place["address"],
                        "latitude": matched_place["latitude"],
                        "longitude": matched_place["longitude"],
                        "reason": item.get("reason", "Địa điểm phù hợp với sở thích của bạn.")
                    })
            
            return ranked_places
            
    except Exception as e:
        print(f"Error calling Ollama or parsing response: {ascii(e)}")
        if response_text:
            print(f"Raw response text: {ascii(response_text)}")
        return []


async def generate_itinerary_llm(
    destination: str,
    duration_days: int,
    budget: float,
    travel_style: str,
    traveler_count: int
) -> dict:
    prompt = f"""
    Bạn là chuyên gia lập kế hoạch du lịch chuyên nghiệp. Hãy tạo lịch trình chi tiết:
    - Điểm đến: {destination}
    - Số ngày: {duration_days} ngày
    - Tổng ngân sách: {budget} VNĐ
    - Phong cách: {travel_style}
    - Số khách: {traveler_count} người

    Yêu cầu:
    1. Lập kế hoạch chi tiết cho từng ngày (Day 1, Day 2...).
    2. Phân bổ các hoạt động theo mốc thời gian hợp lý (Sáng, Trưa, Chiều, Tối).
    3. Ước tính chi phí chi tiết sao cho tổng chi phí gần bằng hoặc nhỏ hơn ngân sách.
    4. Gán category rõ ràng: "restaurant", "attraction", "accommodation", "activity".

    Trả về ĐÚNG cấu trúc JSON theo mẫu sau, không kèm bất kỳ câu thoại thừa nào:
    {{
      "destination": "{destination}",
      "duration_days": {duration_days},
      "estimated_total_cost": {budget},
      "summary": "Mô tả tóm tắt trải nghiệm chuyến đi...",
      "itinerary": [
        {{
          "day": 1,
          "theme": "Chủ đề ngày 1",
          "activities": [
            {{
              "time": "08:00 - 09:30",
              "place_name": "Tên địa điểm/Quán ăn",
              "category": "restaurant",
              "estimated_cost": 100000,
              "description": "Mô tả ngắn gọn hoạt động"
            }}
          ]
        }}
      ]
    }}
    """

    payload = {
        "model": settings.OLLAMA_MODEL,
        "prompt": prompt,
        "stream": False,
        "format": "json",
        "options": {
            "temperature": 0.1,      # Thấp để đảm bảo cấu trúc chặt chẽ
            "num_predict": 2048      # Cao hơn vì lịch trình dài hơn
        }
    }

    response_text = ""
    try:
        async with httpx.AsyncClient() as client:
            response = await client.post(
                f"{settings.OLLAMA_BASE_URL}/api/generate",
                json=payload,
                timeout=180.0  # Sinh lịch trình dài nên đặt timeout 180 giây
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