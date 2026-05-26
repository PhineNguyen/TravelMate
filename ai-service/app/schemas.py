from pydantic import BaseModel, Field
from typing import List, Optional

# --- DỮ LIỆU ĐẦU VÀO (REQUEST FROM SPRING BOOT) ---
class TripRequest(BaseModel):
    destination: str = Field(..., description="Điểm đến của chuyến đi, ví dụ: Đà Lạt, Nha Trang")
    total_days: int = Field(..., ge=1, description="Tổng số ngày di chuyển, phải lớn hơn hoặc bằng 1")
    budget: float = Field(..., gt=0, description="Ngân sách tối đa cấu hình cho chuyến đi")
    travel_style: str = Field(..., description="Phong cách du lịch, ví dụ: Budget, Luxury, Adventure")

# --- DỮ LIỆU ĐẦU RA (RESPONSE TO SPRING BOOT) ---
class ActivitySchema(BaseModel):
    sequence: int = Field(..., description="Thứ tự thực hiện hoạt động trong ngày (1, 2, 3...)")
    time_of_day: str = Field(..., description="Khung thời gian dự kiến, ví dụ: 08:00 - 10:00")
    location_name: str = Field(..., description="Tên địa điểm cụ thể")
    activity_type: str = Field(..., description="Phân loại hoạt động: Attraction, Restaurant, Accommodation, Activity")
    estimated_cost: float = Field(..., description="Chi phí dự kiến tại địa điểm này (VND)")
    description: str = Field(..., description="Mô tả tóm tắt trải nghiệm hoặc lưu ý từ AI")

class DayItinerarySchema(BaseModel):
    day: int = Field(..., description="Ngày thứ mấy của chuyến đi (1, 2, 3...)")
    date_title: str = Field(..., description="Tiêu đề gợi nhớ cho ngày đó, ví dụ: Khám phá Thác nước và rừng thông")
    activities: List[ActivitySchema] = Field(..., description="Danh sách các hoạt động trong ngày")

class FinalTripPlanSchema(BaseModel):
    destination: str = Field(..., description="Xác nhận lại tên điểm đến")
    total_days: int = Field(..., description="Xác nhận lại tổng số ngày")
    estimated_total_cost: float = Field(..., description="Tổng chi phí ước tính toàn bộ chuyến đi cộng dồn lại")
    itinerary: List[DayItinerarySchema] = Field(..., description="Chuỗi lịch trình chi tiết theo từng ngày")