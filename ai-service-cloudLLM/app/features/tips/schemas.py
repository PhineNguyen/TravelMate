from pydantic import BaseModel, Field
from typing import List, Optional

class TravelTipsRequest(BaseModel):
    destination: str = Field(..., description="Điểm đến du lịch (ví dụ: Đà Nẵng, Phú Quốc...)")
    duration_days: int = Field(..., description="Số ngày chuyến đi")
    travel_style: str = Field(..., description="Phong cách du lịch (budget, luxury, adventure, cultural...)")
    traveler_count: int = Field(default=1, description="Số người đi cùng")
    season: Optional[str] = Field(default=None, description="Mùa du lịch (spring/summer/autumn/winter hoặc rainy/dry)")
    preferences: Optional[List[str]] = Field(default=[], description="Sở thích đặc biệt (beach, food, history, outdoor...)")

class TipItem(BaseModel):
    category: str = Field(..., description="Danh mục tip: culture | safety | transport | food | weather | money | etiquette")
    icon: str = Field(..., description="Emoji icon đại diện cho danh mục")
    title: str = Field(..., description="Tiêu đề ngắn gọn của tip")
    content: str = Field(..., description="Nội dung chi tiết của tip")

class TravelTipsResponse(BaseModel):
    destination: str = Field(..., description="Điểm đến")
    overview: str = Field(..., description="Tổng quan ngắn về điểm đến (2-3 câu)")
    best_time_to_visit: str = Field(..., description="Thời điểm lý tưởng nhất để đến thăm")
    tips: List[TipItem] = Field(..., description="Danh sách các tips du lịch chi tiết")
    local_etiquette: List[str] = Field(..., description="Những điều cần lưu ý về văn hóa, phong tục địa phương")
    safety_tips: List[str] = Field(..., description="Các lưu ý về an toàn")
    money_saving_tips: List[str] = Field(..., description="Mẹo tiết kiệm chi phí")
    hidden_gems: List[str] = Field(..., description="Những địa điểm hoặc trải nghiệm ít người biết nhưng thú vị")
    useful_phrases: Optional[List[str]] = Field(default=[], description="Những câu tiếng địa phương hoặc lưu ý ngôn ngữ hữu ích")
