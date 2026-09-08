from pydantic import BaseModel, Field
from typing import List, Optional, Union
from app.features.itinerary.schemas import DayItinerary

class TripReviewRequest(BaseModel):
    destination: str = Field(..., description="Điểm đến chuyến đi")
    budget: Union[float, int, str] = Field(..., description="Tổng ngân sách dự kiến (VNĐ hoặc mức ngân sách)")
    traveler_count: int = Field(default=1, description="Số người tham gia")
    travel_style: Optional[str] = Field(default="general", description="Phong cách du lịch")
    preferences: Optional[List[str]] = Field(default=[], description="Sở thích đặc biệt")
    itinerary: List[DayItinerary] = Field(..., description="Lịch trình cần đánh giá (danh sách các ngày)")

class ImprovementSuggestion(BaseModel):
    day: int = Field(..., description="Ngày có vấn đề (số thứ tự)")
    activity: str = Field(..., description="Tên hoạt động cụ thể cần cải thiện")
    issue: str = Field(..., description="Vấn đề phát hiện")
    suggestion: str = Field(..., description="Gợi ý cải thiện cụ thể")

class ScoreBreakdown(BaseModel):
    balance: float = Field(..., description="Điểm cân bằng hoạt động (0-10): sáng/trưa/chiều/tối hợp lý")
    diversity: float = Field(..., description="Điểm đa dạng (0-10): variety of attraction/food/activity")
    budget_efficiency: float = Field(..., description="Điểm hiệu quả ngân sách (0-10): chi phí phân bổ hợp lý")
    pacing: float = Field(..., description="Điểm nhịp độ (0-10): không quá dày hoặc quá nhàn")
    local_authenticity: float = Field(..., description="Điểm trải nghiệm địa phương (0-10): local experience vs tourist trap")

class TripReviewResponse(BaseModel):
    destination: str = Field(..., description="Điểm đến")
    overall_score: float = Field(..., description="Điểm tổng thể (0-10)")
    verdict: str = Field(..., description="Nhận xét tổng quát ngắn gọn (1-2 câu)")
    scores: ScoreBreakdown = Field(..., description="Điểm chi tiết từng tiêu chí")
    strengths: List[str] = Field(..., description="Điểm mạnh của lịch trình")
    weaknesses: List[str] = Field(..., description="Điểm yếu cần cải thiện")
    suggestions: List[ImprovementSuggestion] = Field(..., description="Gợi ý cải thiện cụ thể theo từng ngày/hoạt động")
    budget_analysis: str = Field(..., description="Phân tích ngân sách: tổng chi phí, phân bổ theo danh mục, nhận xét")
    optimized_tip: str = Field(..., description="1 mẹo tối ưu nhất để nâng cấp toàn bộ lịch trình này")
