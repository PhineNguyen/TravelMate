import httpx
from app.config import settings
from app.services.chat_store import PostgresChatStore

chat_store = PostgresChatStore()

async def chat_with_ai_llm(session_id: str, message: str) -> str:
    # 1. Fetch current history from PostgreSQL
    history = chat_store.get_history(session_id)
    
    # 2. If empty, initialize session with system prompt
    if not history:
        system_content = "Bạn là trợ lý du lịch thông minh, thân thiện của TravelMate. Hãy trả lời các câu hỏi bằng tiếng Việt ngắn gọn, hữu ích và chính xác."
        chat_store.add_message(session_id, "system", system_content)
        history = [{"role": "system", "content": system_content}]

    # 3. Add user message to PostgreSQL
    chat_store.add_message(session_id, "user", message)
    history.append({"role": "user", "content": message})

    # 4. Limit the messages sent to Ollama to (system prompt + last 10 messages)
    system_prompt = history[0]
    messages_payload = [system_prompt]
    if len(history) > 1:
        messages_payload += history[1:][-10:]

    payload = {
        "model": settings.OLLAMA_MODEL,
        "messages": messages_payload,
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
            
            # 5. Store assistant response in PostgreSQL
            chat_store.add_message(session_id, "assistant", content)
            return content
            
    except Exception as e:
        print(f"Error in chat session {session_id}: {ascii(e)}")
        return f"Xin lỗi, tôi gặp sự cố khi kết nối hệ thống AI: {str(e)}"

async def get_chat_history_llm(session_id: str) -> list:
    return chat_store.get_history(session_id)
