from pydantic import BaseModel, Field
from typing import List, Optional, Any, Union

class ChatRequest(BaseModel):
    session_id: str = Field(..., description="ID định danh phiên chat (Ví dụ: trip_123_chat)")
    message: str = Field(..., description="Tin nhắn người dùng gửi cho AI")
    destination: Optional[str] = Field(default=None, description="Địa điểm của chuyến đi hiện tại (nếu có)")
    preferences: Optional[Union[str, List[str]]] = Field(default=None, description="Sở thích và phong cách của người dùng (nếu có)")
    language: Optional[str] = Field(default="vi", description="Ngôn ngữ phản hồi: vi (Tiếng Việt) | en (English)")

class ChatResponse(BaseModel):
    reply: str = Field(..., description="Câu trả lời văn bản từ AI")
    intent: Optional[str] = Field(default=None, description="Intent được phân loại: food | budget | place_recommendation | weather | transport | accommodation | trip_preparation | general_travel | out_of_scope")
    structured_data: Optional[Any] = Field(default=None, description="Dữ liệu có cấu trúc bổ sung (danh sách món ăn, bảng chi phí, danh sách địa điểm...) tùy theo intent")

class ChatMessageItem(BaseModel):
    role: str = Field(..., description="Role of the message author: system | user | assistant")
    content: str = Field(..., description="Message text content")

class ChatHistoryResponse(BaseModel):
    session_id: str = Field(..., description="Session ID of the conversation")
    messages: List[ChatMessageItem] = Field(..., description="Chronological list of all chat messages in the session")
