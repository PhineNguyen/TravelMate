from pydantic import BaseModel, Field
from typing import List

class ChatRequest(BaseModel):
    session_id: str = Field(..., description="ID định danh phiên chat (Ví dụ: trip_123_chat)")
    message: str = Field(..., description="Tin nhắn người dùng gửi cho AI")

class ChatResponse(BaseModel):
    reply: str = Field(..., description="Câu trả lời từ AI")

class ChatMessageItem(BaseModel):
    role: str = Field(..., description="Role of the message author: system | user | assistant")
    content: str = Field(..., description="Message text content")

class ChatHistoryResponse(BaseModel):
    session_id: str = Field(..., description="Session ID of the conversation")
    messages: List[ChatMessageItem] = Field(..., description="Chronological list of all chat messages in the session")
