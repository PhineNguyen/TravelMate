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
    google_maps_url: Optional[str] = Field(None, description="Đường dẫn Google Maps chính thức của địa điểm")

class DayItinerarySchema(BaseModel):
    day: int = Field(..., description="Ngày thứ mấy của chuyến đi (1, 2, 3...)")
    date_title: str = Field(..., description="Tiêu đề gợi nhớ cho ngày đó, ví dụ: Khám phá Thác nước và rừng thông")
    activities: List[ActivitySchema] = Field(..., description="Danh sách các hoạt động trong ngày")

class FinalTripPlanSchema(BaseModel):
    destination: str = Field(..., description="Xác nhận lại tên điểm đến")
    total_days: int = Field(..., description="Xác nhận lại tổng số ngày")
    estimated_total_cost: float = Field(..., description="Tổng chi phí ước tính toàn bộ chuyến đi cộng dồn lại")
    itinerary: List[DayItinerarySchema] = Field(..., description="Chuỗi lịch trình chi tiết theo từng ngày")
    
# --- SCHEMAS CHO GỢI Ý ĐỊA ĐIỂM (RECOMMEND PLACES) ---
class PlaceRecommendationRequest(BaseModel):
    destination: str = Field(..., description="Vị trí hiện tại hoặc điểm đến")
    radius_km: float = Field(..., description="Bán kính tìm kiếm (km)")
    place_type: str = Field(..., description="Loại địa điểm (ví dụ: Quán ăn, Khu vui chơi, Cà phê)")
    preferences: Optional[str] = Field(None, description="Sở thích của người dùng (ví dụ: Ăn chay, Không ồn ào)")

class PlaceSuggestionSchema(BaseModel):
    location_name: str = Field(..., description="Tên địa điểm")
    estimated_cost: float = Field(..., description="Chi phí dự kiến (VND)")
    description: str = Field(..., description="Review hoặc lý do AI gợi ý địa điểm này")
    activity_type: str = Field(..., description="Phân loại (Attraction, Restaurant...)")
    google_maps_url: Optional[str] = Field(None, description="Đường dẫn Google Maps chính thức của địa điểm")

class PlaceRecommendationResponse(BaseModel):
    recommendations: List[PlaceSuggestionSchema] = Field(..., description="Danh sách các địa điểm được gợi ý")


# --- SCHEMAS CHO ĐƯỜNG ĐI TỐI ƯU (OPTIMIZE ROUTE) ---
class RouteLocationInput(BaseModel):
    location_name: str = Field(..., description="Tên địa điểm")
    current_sequence: int = Field(..., description="Thứ tự hiện tại người dùng đang sắp xếp")

class RouteOptimizationRequest(BaseModel):
    locations: List[RouteLocationInput] = Field(..., description="Danh sách các địa điểm cần tối ưu thứ tự")

class OptimizedLocationOutput(BaseModel):
    location_name: str = Field(..., description="Tên địa điểm")
    optimized_sequence: int = Field(..., description="Thứ tự đã được AI sắp xếp lại cho tối ưu quãng đường")

class OptimizedRouteResponse(BaseModel):
    optimized_route: List[OptimizedLocationOutput] = Field(..., description="Lộ trình đã được tối ưu")


# --- SCHEMAS CHO ĐỔI LỊCH THEO THỜI TIẾT (ADJUST WEATHER) ---
class WeatherAdjustmentRequest(BaseModel):
    weather_alert: str = Field(..., description="Bản tin cảnh báo thời tiết (ví dụ: Chiều mai có mưa bão)")
    budget_limit: float = Field(..., description="Ngân sách còn lại cho các hoạt động thay thế")
    current_activities: List[ActivitySchema] = Field(..., description="Lịch trình của ngày đang bị ảnh hưởng")

class WeatherAdjustmentResponse(BaseModel):
    updated_activities: List[ActivitySchema] = Field(..., description="Lịch trình mới đã được AI thay thế điểm đến")
    adjustment_reason: str = Field(..., description="Lời giải thích của AI về lý do thay đổi")
    
# --- SCHEMAS CHO TÍNH NĂNG CHAT VỚI AI ---
class ChatRequest(BaseModel):
    session_id: str = Field(..., description="ID định danh phiên chat (Ví dụ: trip_123_chat)")
    message: str = Field(..., description="Tin nhắn người dùng gửi cho AI")

class ChatResponse(BaseModel):
    reply: str = Field(..., description="Câu trả lời từ AI")