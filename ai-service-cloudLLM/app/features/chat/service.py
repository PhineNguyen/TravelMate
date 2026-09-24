import json
import re
import asyncio
from typing import Optional, Tuple, Dict, Any, List
from groq import AsyncGroq
from app.core.config import settings
from app.features.chat.store import PostgresChatStore
from app.core.helpers import clean_json_response, try_repair_json

chat_store = PostgresChatStore()
client = AsyncGroq(api_key=settings.GROQ_API_KEY)


def build_single_pass_system_prompt(destination: Optional[str] = None, preferences: Optional[str] = None) -> str:
    """
    Build a unified system prompt instructing the LLM to classify intent,
    generate the conversational reply, and extract structured data in ONE single pass.
    """
    dest_str = f" tại '{destination}'" if destination else ""
    pref_str = f", sở thích/phong cách của người dùng: {preferences}" if preferences else ""

    return f"""
Bạn là TravelMate - trợ lý du lịch AI thông minh, am hiểu và tinh tế, có phong cách trình bày khoa học, hiện đại và chuẩn mực như ChatGPT.
Hãy trả lời hoàn toàn bằng TIẾNG VIỆT tự nhiên, mạch lạc, dễ đọc và giàu thông tin hữu ích.

THÔNG TIN CHUYẾN ĐI (ƯU TIÊN ÁP DỤNG KHI TƯ VẤN):
- Địa điểm: {destination or "Chưa xác định (xác định linh hoạt qua ngữ cảnh)"}
- Sở thích/Phong cách: {preferences or "Chung, thích trải nghiệm bản địa chân thực"}

PHẠM VI ĐƯỢC HỖ TRỢ VÀ QUY TẮC PHÂN LOẠI INTENT:
1. Các chủ đề thuộc phạm vi hỗ trợ (In-Scope):
   - Địa điểm & Tham quan (`place_recommendation`): Danh lam thắng cảnh, bãi biển, di tích, vui chơi giải trí.
   - Ẩm thực & Quán ăn (`food`): Đặc sản bản địa, món ngon vùng miền, quán ăn uy tín có thật.
   - Lập kế hoạch & Lịch trình (`general_travel` hoặc `trip_preparation`): Lộ trình theo ngày, chuẩn bị hành lý, đồ dùng cần mang, lưu ý an toàn.
   - Ngân sách & Chi phí (`budget`): Dự toán chi tiêu, mẹo tiết kiệm thông minh, so sánh giá cả.
   - Di chuyển (`transportation`): Máy bay, tàu hỏa, xe khách, thuê xe máy, phương tiện nội địa.
   - Lưu trú (`accommodation`): Khách sạn, homestay, resort, khu vực nên ở.
   - Thời tiết & Mùa du lịch (`weather`): Khí hậu, mùa đẹp nhất, cảnh báo thời tiết.
   - Chào hỏi & Xã giao (`general_travel`): Chào hỏi, cảm ơn, hỏi thăm dịch vụ TravelMate.

2. Quy tắc xử lý câu hỏi ngoài phạm vi (`out_of_scope`):
   - Áp dụng khi người dùng hỏi các chủ đề KHÔNG liên quan đến du lịch, văn hóa, ẩm thực hay trải nghiệm chuyến đi (ví dụ: viết mã code/lập trình, giải toán học, chính trị, đầu tư chứng khoán, y tế bệnh học phức tạp, việc đời tư cá nhân...).
   - Cách trả lời: Lịch sự từ chối ngắn gọn trong 1-2 câu, nêu rõ TravelMate là trợ lý chuyên sâu về du lịch & văn hóa ẩm thực, và thân thiện gợi ý người dùng quay lại chủ đề du lịch (ví dụ: "Mình là trợ lý du lịch TravelMate nên chỉ hỗ trợ các thông tin về điểm đến, ẩm thực và lịch trình khám phá thôi. Nếu bạn đang lên kế hoạch cho chuyến đi sắp tới, hãy chia sẻ để mình hỗ trợ nhé!").
   - Gán `intent: "out_of_scope"`.
   - TUYỆT ĐỐI KHÔNG áp dụng cấu trúc 3-5 mục cho câu hỏi out_of_scope hoặc chào hỏi xã giao.

TIÊU CHUẨN TRÌNH BÀY DỄ ĐỌC (CHO CÂU HỎI TƯ VẤN DU LỊCH):
1. Bố cục phân đoạn thông thoáng (TUYỆT ĐỐI KHÔNG VIẾT MỘT KHỐI VĂN BẢN ĐẶC QUẮNH):
   - Mở đầu bằng một câu dẫn dắt ngắn gọn, thân thiện.
   - Chia nội dung thành các mục rõ ràng (3 đến 5 mục trọng tâm). Giữa mỗi mục PHẢI CÓ một dòng trống (xuống dòng 2 lần) để tạo khoảng thở, giúp mắt dễ theo dõi trên màn hình di động.
   - Đầu mỗi mục PHẢI CÓ tiêu đề in đậm ngắn gọn mô tả ý chính (ví dụ: 1. **Tiêu đề**: hoặc - **Tên món/địa danh**:).
   - Với câu hỏi tra cứu nhanh (giá vé cụ thể, thời tiết 1 ngày): Trả lời thẳng vào trọng tâm trong 1 đoạn văn súc tích, không cần chia 3-5 mục.

2. Nội dung súc tích & Giàu kinh nghiệm thực tế:
   - Mỗi mục viết từ 2 đến 3 câu diễn giải gãy gọn, nêu bật cốt lõi vấn đề và mẹo thực tế (không viết cụt ngủn 1 dòng, cũng không lan man dài dòng).
   - Khi tư vấn ăn uống/địa điểm, luôn nêu đúng đặc sản bản địa kèm **tên quán/địa chỉ uy tín có thật** (không bịa món lạ).
   - In đậm các từ khóa quan trọng bằng cú pháp **tên**. Không dùng ngoặc vuông [].

3. Giọng văn:
   - Xưng "mình" và gọi người dùng là "bạn".
   - Lịch thiệp, thông minh, gần gũi, kết thúc bằng một câu tương tác hoặc chúc chuyến đi ấm áp.

VÍ DỤ BỐ CỤC CHUẨN KHI TRẢ LỜI:
Đi du lịch một mình là trải nghiệm rất tuyệt vời để tự do khám phá! Dưới đây là những lưu ý quan trọng giúp chuyến đi của bạn an toàn và trọn vẹn:

1. **Lên kế hoạch & Giữ liên lạc**:
Hãy chia sẻ lịch trình chi tiết và định vị với một người thân đáng tin cậy. Luôn lưu sẵn số điện thoại khẩn cấp và tải bản đồ offline phòng khi mất sóng.

2. **Quản lý tài chính & Giấy tờ**:
Chia tiền mặt và thẻ ở 2-3 nơi khác nhau, không cất chung một chỗ. Hãy chụp ảnh hộ chiếu/CCCD lưu trên điện thoại và mang theo một khoản tiền mặt nhỏ trong ngăn bí mật của balo.

3. **Lưu trú & Di chuyển**:
Nên chọn khách sạn hoặc homestay ở khu vực trung tâm có đánh giá an ninh tốt. Khi di chuyển vào buổi tối, ưu tiên dùng ứng dụng đặt xe công nghệ thay vì bắt xe dọc đường.

NHIỆM VỤ ĐẦU RA:
Trả về duy nhất một JSON object theo đúng schema sau, không kèm bất kỳ ký tự nào ngoài JSON:
{{
  "intent": "food | budget | place_recommendation | weather | transportation | accommodation | trip_preparation | general_travel | out_of_scope",
  "destination": "tên_địa_danh_hoặc_null",
  "reply": "Nội dung phản hồi được định dạng theo đúng bố cục phân đoạn thông thoáng và dễ đọc ở trên",
  "structured_data": null
}}
"""


def build_streaming_system_prompt(destination: Optional[str] = None, preferences: Optional[str] = None) -> str:
    """
    Tailored dynamic prompt for text streaming with clear, readable ChatGPT style.
    """
    dest_str = f" tại '{destination}'" if destination else ""
    pref_str = f", sở thích/phong cách du lịch: {preferences}" if preferences else ""

    return f"""
Bạn là TravelMate - trợ lý du lịch AI thông minh, am hiểu và tinh tế, có phong cách trình bày khoa học, hiện đại và chuẩn mực như ChatGPT.
Hãy trả lời hoàn toàn bằng TIẾNG VIỆT tự nhiên, mạch lạc, dễ đọc và giàu thông tin hữu ích.

THÔNG TIN CHUYẾN ĐI (ƯU TIÊN ÁP DỤNG KHI TƯ VẤN):
- Địa điểm: {destination or "Chưa xác định (xác định linh hoạt qua ngữ cảnh)"}
- Sở thích/Phong cách: {preferences or "Chung, thích trải nghiệm bản địa chân thực"}

PHẠM VI HỖ TRỢ & XỬ LÝ NGOẠI LỆ:
- Trong phạm vi: Điểm đến, ẩm thực, lịch trình, chi phí, di chuyển, khách sạn, thời tiết, chuẩn bị hành lý.
- Ngoài phạm vi (code, toán, chính trị, việc riêng...): Lịch sự từ chối trong 1-2 câu, nêu rõ chỉ hỗ trợ du lịch và khéo léo dẫn dắt quay lại chuyến đi. TUYỆT ĐỐI KHÔNG chia 3-5 mục cho câu ngoài phạm vi.

TIÊU CHUẨN TRÌNH BÀY DỄ ĐỌC:
1. Phân đoạn thông thoáng:
   - TUYỆT ĐỐI KHÔNG viết thành một khối chữ đặc dính liền.
   - Chia thành 3-5 mục rõ ràng. Giữa các mục phải có dòng trống cách đoạn.
   - Mỗi mục bắt đầu bằng tiêu đề in đậm (ví dụ: 1. **Tiêu đề**: ... hoặc - **Tên món**: ...).
   - Với câu hỏi tra cứu ngắn: Trả lời thẳng vào trọng tâm trong 1 đoạn văn.
2. Nội dung vừa vặn, súc tích:
   - Mỗi mục diễn giải 2-3 câu sắc bén, nêu kinh nghiệm/quán ăn thực tế. In đậm **tên** điểm nhấn.
3. Xưng "mình" - "bạn", giọng văn lịch thiệp, thông minh, dễ chịu.
"""


def build_conversation_context(history: List[Dict[str, str]], system_prompt: str) -> List[Dict[str, str]]:
    """
    Context preservation strategy:
    1. System prompt (contains persistent Trip Profile).
    2. If history is long (> 10 messages), preserve the initial turn (first user query & answer)
       to retain foundational constraints, plus the 8 most recent messages.
    """
    messages_payload = [{"role": "system", "content": system_prompt}]

    if not history:
        return messages_payload

    # Filter out any old system messages from history
    user_assistant_msgs = [m for m in history if m.get("role") in ["user", "assistant"]]

    if len(user_assistant_msgs) <= 10:
        messages_payload.extend(user_assistant_msgs)
    else:
        # Keep the foundational exchange (first 2 messages) + recent 8 messages
        foundational = user_assistant_msgs[:2]
        recent = user_assistant_msgs[-8:]
        messages_payload.extend(foundational)
        messages_payload.append({
            "role": "system",
            "content": "(Lưu ý: Các tin nhắn trò chuyện trung gian đã được rút gọn để tập trung vào ngữ cảnh gần nhất)."
        })
        messages_payload.extend(recent)

    return messages_payload


async def chat_with_ai_llm(
    session_id: str,
    message: str,
    destination: Optional[str] = None,
    preferences: Optional[str | list] = None
) -> Dict[str, Any]:
    """
    Single-pass chat handler:
    Performs classification, reply generation, and structured data extraction
    in ONE single LLM inference call, cutting latency by over 60%.
    """
    if isinstance(preferences, list):
        preferences = ", ".join(str(p) for p in preferences)

    # 1. Fetch history asynchronously with Connection Pool
    history = await chat_store.get_history(session_id)

    # 2. Add user message to DB asynchronously
    await chat_store.add_message(session_id, "user", message)
    history.append({"role": "user", "content": message})

    # 3. Build single-pass system prompt & context window
    system_prompt = build_single_pass_system_prompt(destination, preferences)
    messages_payload = build_conversation_context(history, system_prompt)

    # 4. Call Groq ONCE with JSON mode (with automatic retry for 429 rate-limit)
    max_retries = 3
    for attempt in range(max_retries):
        try:
            response = await client.chat.completions.create(
                model=settings.GROQ_MODEL,
                messages=messages_payload,
                temperature=0.65,
                top_p=0.9,
                response_format={"type": "json_object"}
            )
            raw_text = response.choices[0].message.content or "{}"
            cleaned = clean_json_response(raw_text)
            repaired = try_repair_json(cleaned)
            result_data = json.loads(repaired)

            intent = result_data.get("intent", "general_travel")
            reply = result_data.get("reply", "Tôi chưa có phản hồi cụ thể cho câu hỏi này.")
            structured_data = result_data.get("structured_data")

            # 5. Save assistant response to DB asynchronously
            await chat_store.add_message(session_id, "assistant", reply)

            print(f"[Chat AI Single-Pass] Session: {session_id} | Intent: {intent}")
            return {
                "reply": reply,
                "intent": intent,
                "structured_data": structured_data
            }

        except Exception as e:
            err_str = str(e)
            if "429" in err_str and attempt < max_retries - 1:
                wait_time = 1.0 * (attempt + 1)
                print(f"[Chat AI Rate Limit] Retrying in {wait_time}s (attempt {attempt + 1}/{max_retries})...")
                await asyncio.sleep(wait_time)
                continue

            # Handle safety refusal where model returned raw text instead of JSON
            if "json_validate_failed" in err_str or "failed_generation" in err_str:
                print(f"[Chat AI Safety Refusal Handled] Intercepted non-JSON refusal from safety filter.")
                safe_refusal = (
                    "Xin lỗi bạn, tôi là trợ lý du lịch của TravelMate và chỉ có thể tư vấn các thông tin "
                    "liên quan đến du lịch, hành trình, ẩm thực, thời tiết hoặc chuẩn bị chuyến đi. "
                    "Tôi không thể cung cấp thông tin hệ thống hay bỏ qua các chỉ dẫn an toàn! 😊"
                )
                await chat_store.add_message(session_id, "assistant", safe_refusal)
                return {
                    "reply": safe_refusal,
                    "intent": "out_of_scope",
                    "structured_data": None
                }

            print(f"[Chat AI Single-Pass Error] {e}")
            fallback_reply = "Xin lỗi bạn, hệ thống AI đang gặp sự cố kết nối tạm thời. Bạn vui lòng thử lại sau giây lát nhé!"
            await chat_store.add_message(session_id, "assistant", fallback_reply)
            return {
                "reply": fallback_reply,
                "intent": "error",
                "structured_data": None
            }


async def get_chat_history_llm(session_id: str) -> list:
    return await chat_store.get_history(session_id)


async def clear_chat_history_llm(session_id: str):
    await chat_store.clear_history(session_id)


async def chat_with_ai_stream(
    session_id: str,
    message: str,
    destination: Optional[str] = None,
    preferences: Optional[str | list] = None
):
    """
    Streaming chat using Groq streaming API.
    """
    if isinstance(preferences, list):
        preferences = ", ".join(str(p) for p in preferences)

    # 1. Retrieve history and record user message
    history = await chat_store.get_history(session_id)
    await chat_store.add_message(session_id, "user", message)
    history.append({"role": "user", "content": message})

    # 2. Build tailored dynamic prompt and context payload
    system_prompt = build_streaming_system_prompt(destination, preferences)
    messages_payload = build_conversation_context(history, system_prompt)

    # 5. Stream from Groq directly
    full_response = []
    try:
        stream = await client.chat.completions.create(
            model=settings.GROQ_MODEL,
            messages=messages_payload,
            temperature=0.65,
            top_p=0.9,
            stream=True
        )
        async for chunk in stream:
            delta = chunk.choices[0].delta if chunk.choices else None
            if delta and delta.content:
                content = delta.content
                full_response.append(content)
                yield f"data: {json.dumps({'content': content}, ensure_ascii=False)}\n\n"

        # 6. Save full response asynchronously when streaming finishes
        assistant_content = "".join(full_response)
        if assistant_content:
            await chat_store.add_message(session_id, "assistant", assistant_content)

    except Exception as e:
        print(f"[Chat Stream Error] {e}")
        yield f"data: {json.dumps({'error': str(e)}, ensure_ascii=False)}\n\n"
