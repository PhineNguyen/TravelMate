import httpx
import json
from app.core.config import settings
from app.features.chat.store import PostgresChatStore

chat_store = PostgresChatStore()

def get_classification_prompt(message: str) -> str:
    return f"""
    Bạn là một chuyên gia phân tích ý định câu hỏi du lịch.
    Hãy phân tích câu hỏi sau đây của người dùng:
    "{message}"

    Hãy phân loại câu hỏi vào một trong các nhãn (intent) sau:
    - `out_of_scope`: Câu hỏi hoàn toàn không liên quan đến du lịch, du hành, hành trình, danh lam thắng cảnh, ẩm thực hay di chuyển (ví dụ: học lập trình python, viết code máy tính, học toán học, tìm việc làm thêm, tin tức thời sự chính trị, hướng dẫn làm bài tập...).
    - `trip_preparation`: Chuẩn bị hành lý, đồ đạc cần mang theo, giấy tờ.
    - `weather`: Hỏi về thời tiết, nhiệt độ, khí hậu.
    - `food`: Hỏi về món ăn ngon, ẩm thực, đặc sản, quán ăn, quán nước.
    - `transportation`: Hỏi về cách đi lại, phương tiện di chuyển.
    - `budget`: Hỏi về chi phí, ngân sách, giá cả.
    - `accommodation`: Hỏi về nơi ở, khách sạn, homestay.
    - `place_recommendation`: Hỏi về địa điểm tham quan, vui chơi, check-in, giải trí.
    - `general_travel`: Hỏi đáp hoặc trò chuyện du lịch chung (như hỏi kinh nghiệm đi du lịch, lưu ý khi đi một mình...).

    Đồng thời, hãy trích xuất tên địa danh (thành phố/tỉnh thành) được đề cập trong câu hỏi nếu có (ví dụ: "Đà Lạt", "HCM", "Nha Trang"). Nếu không có địa danh nào được nhắc tới, hãy trả về null.

    Trả về kết quả dưới dạng JSON có cấu trúc sau, không kèm bất kỳ lời thoại nào khác ngoài JSON:
    {{
      "intent": "tên_intent",
      "destination": "tên_địa_danh_hoặc_null"
    }}
    """

def build_dynamic_system_prompt(intent: str, destination: str, preferences: str) -> str:
    dest_str = f" tại '{destination}'" if destination else ""
    pref_str = f", sở thích/phong cách du lịch của người dùng: {preferences}" if preferences else ""
    
    base_prompt = (
        "Bạn là một blogger du lịch bản địa người Việt thân thiện của TravelMate. "
        "Hãy chia sẻ kinh nghiệm du lịch thực tế bằng tiếng Việt với giọng văn tự nhiên, trôi chảy và thân thiện. "
        "Tuyệt đối tránh viết theo cấu trúc robot chia mục cứng nhắc dịch từ tiếng Anh (như Giáo dục, Lịch sử, Nâng cấp trải nghiệm, Quá trình đi). "
        "Hãy viết dưới dạng một đoạn văn ngắn gọn chia sẻ trực tiếp và chỉ dùng tối đa 3-5 gạch đầu dòng cho các vật dụng, địa điểm cụ thể. "
        "Tuyệt đối không dùng ký tự ngoặc vuông [] chứa lời hướng dẫn hoặc ví dụ trống."
    )
    
    if intent == "trip_preparation":
        return base_prompt + f" Người dùng đang hỏi về chuẩn bị hành lý cho chuyến đi{dest_str}{pref_str}. Hãy tư vấn các vật dụng cá nhân, trang phục phù hợp thời tiết và thuốc men/giấy tờ cần thiết. Tập trung hoàn toàn vào chuẩn bị hành lý, KHÔNG đề xuất địa điểm tham quan hay ăn uống."
    elif intent == "weather":
        return base_prompt + f" Người dùng đang hỏi về thời tiết{dest_str}. Hãy chia sẻ thông tin thời tiết thực tế của địa phương này và khuyên trang phục phù hợp."
    elif intent == "food":
        return base_prompt + f" Người dùng đang hỏi về món ăn/ẩm thực{dest_str}{pref_str}. Hãy giới thiệu các món ăn đặc sản nổi tiếng nhất và gợi ý một số quán ăn cụ thể có thật."
    elif intent == "transportation":
        return base_prompt + f" Người dùng đang hỏi về phương tiện đi lại{dest_str}. Hãy hướng dẫn cách di chuyển tiện lợi nhất (như thuê xe máy, taxi, xe khách...)."
    elif intent == "budget":
        return base_prompt + f" Người dùng đang hỏi về chi phí/ngân sách{dest_str}. Hãy chia sẻ mức chi phí ước lượng trung bình mỗi ngày (tiền phòng, ăn uống, đi lại)."
    elif intent == "accommodation":
        return base_prompt + f" Người dùng đang hỏi về nơi ở/khách sạn{dest_str}{pref_str}. Hãy gợi ý các khu vực thuận tiện nhất để lưu trú và một vài khách sạn cụ thể."
    elif intent == "place_recommendation":
        return base_prompt + f" Người dùng đang hỏi về địa điểm chơi/tham quan{dest_str}{pref_str}. Hãy gợi ý các danh lam thắng cảnh nổi tiếng nhất kèm lý do thú vị để ghé thăm."
    
    return base_prompt + f" Hiện tại bạn đang hỗ trợ thông tin du lịch{dest_str}{pref_str}. Hãy giải đáp câu hỏi của họ một cách tự nhiên, hữu ích nhất."

async def chat_with_ai_llm(session_id: str, message: str, destination: str = None, preferences: str = None) -> str:
    # 1. Fetch current history from PostgreSQL
    history = chat_store.get_history(session_id)
    
    # 2. Classify intent and destination using LLM
    intent = "general_travel"
    active_destination = destination
    try:
        class_prompt = get_classification_prompt(message)
        payload = {
            "model": settings.OLLAMA_MODEL,
            "prompt": class_prompt,
            "stream": False,
            "format": "json",
            "options": {
                "temperature": 0.1,
                "num_predict": 128
            }
        }
        async with httpx.AsyncClient() as client:
            response = await client.post(
                f"{settings.OLLAMA_BASE_URL}/api/generate",
                json=payload,
                timeout=15.0
            )
            response.raise_for_status()
            response_text = response.json().get("response", "{}")
            from app.core.helpers import clean_json_response, try_repair_json
            cleaned = clean_json_response(response_text)
            repaired = try_repair_json(cleaned)
            class_data = json.loads(repaired)
            
            intent = class_data.get("intent", "general_travel")
            extracted_dest = class_data.get("destination")
            if extracted_dest and str(extracted_dest).lower() != "null":
                active_destination = extracted_dest
    except Exception as class_err:
        print(f"[Chat Classifier] Error in session {session_id}: {class_err}")

    print(f"[Chat AI] Session: {session_id} | Intent: {intent} | Destination: {active_destination}")

    # Check for out of scope query
    if intent == "out_of_scope":
        reply = "Xin lỗi, tôi là trợ lý du lịch của TravelMate và chỉ có thể hỗ trợ các thông tin liên quan đến du lịch, hành trình, ẩm thực, thời tiết hoặc chuẩn bị chuyến đi. Bạn vui lòng đặt câu hỏi liên quan đến du lịch nhé! 😊"
        chat_store.add_message(session_id, "user", message)
        chat_store.add_message(session_id, "assistant", reply)
        return reply

    system_content = build_dynamic_system_prompt(intent, active_destination, preferences)

    # 3. If empty, initialize session with system prompt
    if not history:
        chat_store.add_message(session_id, "system", system_content)
        history = [{"role": "system", "content": system_content}]

    # 4. Add user message to PostgreSQL
    chat_store.add_message(session_id, "user", message)
    history.append({"role": "user", "content": message})

    # 5. Limit the messages sent to Ollama to (dynamic system prompt + last 10 messages)
    system_prompt = {"role": "system", "content": system_content}
    messages_payload = [system_prompt]
    if len(history) > 1:
        messages_payload += history[1:][-10:]

    payload = {
        "model": settings.OLLAMA_MODEL,
        "messages": messages_payload,
        "stream": False,
        "options": {
            "temperature": 0.2
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
            
            # 6. Store assistant response in PostgreSQL
            chat_store.add_message(session_id, "assistant", content)
            return content
            
    except Exception as e:
        print(f"Error in chat session {session_id}: {ascii(e)}")
        return f"Xin lỗi, tôi gặp sự cố khi kết nối hệ thống AI: {str(e)}"

async def get_chat_history_llm(session_id: str) -> list:
    return chat_store.get_history(session_id)

async def clear_chat_history_llm(session_id: str):
    chat_store.clear_history(session_id)

async def chat_with_ai_stream(session_id: str, message: str, destination: str = None, preferences: str = None):
    history = chat_store.get_history(session_id)
    
    # Classify intent and destination using LLM
    intent = "general_travel"
    active_destination = destination
    try:
        class_prompt = get_classification_prompt(message)
        payload = {
            "model": settings.OLLAMA_MODEL,
            "prompt": class_prompt,
            "stream": False,
            "format": "json",
            "options": {
                "temperature": 0.1,
                "num_predict": 128
            }
        }
        async with httpx.AsyncClient() as client:
            response = await client.post(
                f"{settings.OLLAMA_BASE_URL}/api/generate",
                json=payload,
                timeout=15.0
            )
            response.raise_for_status()
            response_text = response.json().get("response", "{}")
            from app.core.helpers import clean_json_response, try_repair_json
            cleaned = clean_json_response(response_text)
            repaired = try_repair_json(cleaned)
            class_data = json.loads(repaired)
            
            intent = class_data.get("intent", "general_travel")
            extracted_dest = class_data.get("destination")
            if extracted_dest and str(extracted_dest).lower() != "null":
                active_destination = extracted_dest
    except Exception as class_err:
        print(f"[Chat Stream Classifier] Error in session {session_id}: {class_err}")

    print(f"[Chat AI Stream] Session: {session_id} | Intent: {intent} | Destination: {active_destination}")

    # Check for out of scope query
    if intent == "out_of_scope":
        reply = "Xin lỗi, tôi là trợ lý du lịch của TravelMate và chỉ có thể hỗ trợ các thông tin liên quan đến du lịch, hành trình, ẩm thực, thời tiết hoặc chuẩn bị chuyến đi. Bạn vui lòng đặt câu hỏi liên quan đến du lịch nhé! 😊"
        chat_store.add_message(session_id, "user", message)
        chat_store.add_message(session_id, "assistant", reply)
        yield f"data: {json.dumps({'content': reply}, ensure_ascii=False)}\n\n"
        return

    system_content = build_dynamic_system_prompt(intent, active_destination, preferences)

    if not history:
        chat_store.add_message(session_id, "system", system_content)
        history = [{"role": "system", "content": system_content}]

    chat_store.add_message(session_id, "user", message)
    history.append({"role": "user", "content": message})

    system_prompt = {"role": "system", "content": system_content}
    messages_payload = [system_prompt]
    if len(history) > 1:
        messages_payload += history[1:][-10:]

    payload = {
        "model": settings.OLLAMA_MODEL,
        "messages": messages_payload,
        "stream": True,
        "options": {
            "temperature": 0.2
        }
    }

    full_response = []
    try:
        async with httpx.AsyncClient() as client:
            async with client.stream(
                "POST",
                f"{settings.OLLAMA_BASE_URL}/api/chat",
                json=payload,
                timeout=120.0
            ) as response:
                response.raise_for_status()
                async for line in response.aiter_lines():
                    if line:
                        chunk = json.loads(line)
                        content = chunk.get("message", {}).get("content", "")
                        if content:
                            full_response.append(content)
                            yield f"data: {json.dumps({'content': content}, ensure_ascii=False)}\n\n"
        
        assistant_content = "".join(full_response)
        chat_store.add_message(session_id, "assistant", assistant_content)
    except Exception as e:
        print(f"Error streaming chat: {e}")
        yield f"data: {json.dumps({'error': str(e)}, ensure_ascii=False)}\n\n"
