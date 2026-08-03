from fastapi import APIRouter, HTTPException
from app.features.chat.schemas import ChatRequest, ChatResponse, ChatMessageItem, ChatHistoryResponse
from app.features.chat.service import chat_with_ai_llm, get_chat_history_llm, clear_chat_history_llm

router = APIRouter(prefix="/ai", tags=["Assistant Chat"])

@router.post("/chat", response_model=ChatResponse)
async def chat(payload: ChatRequest):
    try:
        reply = await chat_with_ai_llm(payload.session_id, payload.message)
        return ChatResponse(reply=reply)
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"Lỗi khi chat với AI: {str(e)}"
        )

@router.get("/chat/{session_id}", response_model=ChatHistoryResponse)
async def get_chat_history(session_id: str):
    try:
        history = await get_chat_history_llm(session_id)
        messages = [ChatMessageItem(role=msg["role"], content=msg["content"]) for msg in history]
        return ChatHistoryResponse(session_id=session_id, messages=messages)
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"Lỗi khi lấy lịch sử chat: {str(e)}"
        )

@router.delete("/chat/{session_id}")
async def delete_chat_history(session_id: str):
    try:
        await clear_chat_history_llm(session_id)
        return {"status": "success", "message": f"Đã xóa lịch sử chat của session {session_id} thành công!"}
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"Lỗi khi xóa lịch sử chat: {str(e)}"
        )
