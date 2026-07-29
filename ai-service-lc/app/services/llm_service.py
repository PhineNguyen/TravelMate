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


# Global memory storage for chat sessions
chat_sessions = {}

async def optimize_route_llm(locations: list) -> list:
    if not locations:
        return []

    # Map locations to a list of dicts for safety
    loc_list = []
    for loc in locations:
        if hasattr(loc, "dict"):
            loc_list.append(loc.dict())
        elif isinstance(loc, dict):
            loc_list.append(loc)
        else:
            loc_list.append({
                "location_name": getattr(loc, "location_name", ""),
                "current_sequence": getattr(loc, "current_sequence", 0)
            })

    prompt = f"""
    Bạn là chuyên gia tối ưu lộ trình du lịch.
    Dưới đây là danh sách toàn bộ {len(loc_list)} địa điểm cần tối ưu hóa thứ tự di chuyển để khoảng cách địa lý ngắn nhất, tránh đi vòng:
    {json.dumps(loc_list, ensure_ascii=False)}

    Hãy sắp xếp lại thứ tự di chuyển cho TOÀN BỘ {len(loc_list)} địa điểm trên. Giá trị "optimized_sequence" bắt đầu từ 1 cho địa điểm đầu tiên, tăng dần lên 2, 3... cho các địa điểm tiếp theo.
    Bạn bắt buộc phải trả về đầy đủ tất cả {len(loc_list)} địa điểm trong kết quả.
    Trả về ĐÚNG cấu trúc mảng JSON gồm các đối tượng có cấu trúc như mẫu sau, không kèm bất kỳ câu thoại nào:
    [
      {{
        "location_name": "Tên địa điểm",
        "optimized_sequence": 1
      }}
    ]
    """

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

            # Extract location_name and optimized_sequence
            optimized_route = []
            for item in items:
                if isinstance(item, dict) and "location_name" in item and "optimized_sequence" in item:
                    try:
                        optimized_route.append({
                            "location_name": item["location_name"],
                            "optimized_sequence": int(item["optimized_sequence"])
                        })
                    except (ValueError, TypeError):
                        continue
            
            if optimized_route:
                return optimized_route
            return [{"location_name": loc["location_name"], "optimized_sequence": idx + 1} for idx, loc in enumerate(loc_list)]

    except Exception as e:
        print(f"Error optimizing route: {ascii(e)}")
        if response_text:
            print(f"Raw response: {ascii(response_text)}")
        return [{"location_name": loc["location_name"], "optimized_sequence": idx + 1} for idx, loc in enumerate(loc_list)]


async def adjust_weather_llm(weather_alert: str, budget_limit: float, current_activities: list) -> dict:
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
                "place_name": getattr(act, "place_name", ""),
                "category": getattr(act, "category", ""),
                "estimated_cost": getattr(act, "estimated_cost", 0.0),
                "description": getattr(act, "description", "")
            })

    prompt = f"""
    Bạn là chuyên gia điều chỉnh lịch trình du lịch thông minh dựa trên thời tiết.
    - Cảnh báo thời tiết: {weather_alert}
    - Giới hạn ngân sách còn lại: {budget_limit} VNĐ
    - Lịch trình hiện tại của ngày bị ảnh hưởng:
    {json.dumps(activities_list, ensure_ascii=False)}

    Yêu cầu:
    1. Hãy quét qua lịch trình hiện tại, xác định các hoạt động ngoài trời (ví dụ: tham quan thác, bãi biển, leo núi) và thay thế bằng các hoạt động trong nhà phù hợp (ví dụ: bảo tàng, quán cà phê trong nhà, trung tâm thương mại, khu vui chơi trong nhà).
    2. Đảm bảo tổng chi phí của các hoạt động mới thay thế không vượt quá giới hạn ngân sách ({budget_limit} VNĐ).
    3. Giữ nguyên khung thời gian (time) của hoạt động cũ.
    4. Trả về giải thích ngắn gọn lý do điều chỉnh.

    Trả về ĐÚNG cấu trúc JSON sau, không kèm bất kỳ lời thoại nào:
    {{
      "updated_activities": [
        {{
          "time": "Khung giờ cũ",
          "place_name": "Tên địa điểm trong nhà mới",
          "category": "restaurant/attraction/accommodation/activity",
          "estimated_cost": 150000,
          "description": "Mô tả ngắn gọn về địa điểm mới thay thế và lưu ý thời tiết"
        }}
      ],
      "adjustment_reason": "Mô tả tóm tắt lý do thay đổi các hoạt động ngoài trời thành trong nhà..."
    }}
    """

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
                timeout=180.0
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


async def chat_with_ai_llm(session_id: str, message: str) -> str:
    if session_id not in chat_sessions:
        chat_sessions[session_id] = [
            {"role": "system", "content": "Bạn là trợ lý du lịch thông minh, thân thiện của TravelMate. Hãy trả lời các câu hỏi bằng tiếng Việt ngắn gọn, hữu ích và chính xác."}
        ]

    # Append user message
    chat_sessions[session_id].append({"role": "user", "content": message})

    # Keep context memory limited to last 11 messages (system prompt + 10 chat messages)
    if len(chat_sessions[session_id]) > 11:
        system_prompt = chat_sessions[session_id][0]
        chat_sessions[session_id] = [system_prompt] + chat_sessions[session_id][-10:]

    payload = {
        "model": settings.OLLAMA_MODEL,
        "messages": chat_sessions[session_id],
        "stream": False,
        "options": {
            "temperature": 0.7
        }
    }

    try:
        async with httpx.AsyncClient() as client:
            response = await client.post(
                f"{settings.OLLAMA_BASE_URL}/api/chat",
                json=payload,
                timeout=120.0
            )
            response.raise_for_status()
            assistant_message = response.json().get("message", {})
            content = assistant_message.get("content", "Trợ lý không phản hồi.")
            
            # Store assistant response in history
            chat_sessions[session_id].append({"role": "assistant", "content": content})
            return content
            
    except Exception as e:
        print(f"Error in chat session {session_id}: {ascii(e)}")
        return f"Xin lỗi, tôi gặp sự cố khi kết nối hệ thống AI: {str(e)}"