from pydantic import BaseModel, Field
from typing import List, Optional

class ActivityItem(BaseModel):
    time: str = Field(..., description="Khung giờ hoạt động (ví dụ: '08:00 - 09:30')")
    start_time: Optional[str] = Field(None, description="Mốc giờ bắt đầu hoạt động (ví dụ: '08:00')")
    duration_minutes: Optional[int] = Field(None, description="Khoảng thời gian hoạt động kéo dài bao nhiêu phút")
    place_name: str = Field(..., description="Tên địa điểm")
    address: Optional[str] = Field(None, description="Địa chỉ hoặc khu vực cụ thể của địa điểm")
    latitude: Optional[float] = Field(None, description="Vĩ độ của địa điểm")
    longitude: Optional[float] = Field(None, description="Kinh độ của địa điểm")
    category: str = Field(..., description="Phân loại: restaurant | attraction | accommodation | activity")
    estimated_cost: float = Field(..., description="Chi phí ước tính của hoạt động (VNĐ)")
    description: str = Field(..., description="Mô tả chi tiết hoạt động")
    transport_to_next: Optional[str] = Field(None, description="Phương tiện di chuyển đến hoạt động tiếp theo (ví dụ: 'xe máy thuê', 'taxi', 'đi bộ 5 phút')")
    transport_duration_minutes: Optional[int] = Field(None, description="Thời gian di chuyển đến điểm tiếp theo (phút)")
    local_tip: Optional[str] = Field(None, description="Mẹo nhỏ từ local: giờ nên đến, món nên gọi, điều nên tránh...")

class DayItinerary(BaseModel):
    day: int = Field(..., description="Số thứ tự ngày (ví dụ: 1)")
    theme: str = Field(..., description="Chủ đề chính của ngày")
    activities: List[ActivityItem] = Field(..., description="Danh sách hoạt động trong ngày")

class GenerateItineraryRequest(BaseModel):
    destination: str = Field(..., description="Điểm đến du lịch (ví dụ: Đà Nẵng, Hà Nội...)")
    duration_days: int = Field(..., description="Số ngày của chuyến đi")
    budget: float = Field(..., description="Tổng ngân sách dự kiến (VNĐ)")
    travel_style: str = Field(..., description="Phong cách chuyến đi (ngon rẻ, sang chảnh, khám phá...)")
    traveler_count: int = Field(..., description="Số lượng người tham gia chuyến đi")
    preferences: Optional[List[str]] = Field(default=[], description="Danh sách sở thích, yêu cầu đặc biệt của người dùng (ví dụ: hải sản, check-in, yên tĩnh...)")

class GenerateItineraryResponse(BaseModel):
    destination: str = Field(..., description="Điểm đến")
    duration_days: int = Field(..., description="Số ngày")
    estimated_total_cost: float = Field(..., description="Tổng chi phí ước tính (VNĐ)")
    summary: str = Field(..., description="Tóm tắt chung hành trình du lịch")
    highlights: Optional[List[str]] = Field(default=[], description="Top 3-5 điểm nổi bật nhất của chuyến đi này")
    travel_warnings: Optional[List[str]] = Field(default=[], description="Lưu ý quan trọng: mùa cao điểm, giờ cao điểm, khu vực cần cẩn thận...")
    itinerary: List[DayItinerary] = Field(..., description="Chi tiết lịch trình từng ngày")

class RouteLocationItem(BaseModel):
    location_name: str = Field(..., description="Tên địa điểm")
    current_sequence: int = Field(..., description="Thứ tự hiện tại trong danh sách")
    place_id: Optional[int] = Field(None, description="ID địa điểm từ CSDL backend")
    latitude: Optional[float] = Field(None, description="Vĩ độ")
    longitude: Optional[float] = Field(None, description="Kinh độ")
    category: Optional[str] = Field(None, description="Phân loại địa điểm: restaurant | attraction | accommodation | activity")

class RouteLocationOptimized(BaseModel):
    location_name: str = Field(..., description="Tên địa điểm")
    optimized_sequence: int = Field(..., description="Thứ tự tối ưu sau khi sắp xếp")
    place_id: Optional[int] = Field(None, description="ID địa điểm từ CSDL backend")
    description: Optional[str] = Field(None, description="Lời giới thiệu/giải thích ngắn gọn về địa điểm và lý do xếp vào thứ tự di chuyển này (1-2 câu)")

class RouteOptimizationRequest(BaseModel):
    locations: List[RouteLocationItem] = Field(..., description="Danh sách các địa điểm cần tối ưu hóa")

class OptimizedRouteResponse(BaseModel):
    optimized_route: List[RouteLocationOptimized] = Field(..., description="Danh sách địa điểm đã được tối ưu sắp xếp thứ tự")

class WeatherAdjustmentRequest(BaseModel):
    weather_alert: str = Field(..., description="Bản tin cảnh báo thời tiết (ví dụ: Chiều mai có mưa bão)")
    budget_limit: float = Field(..., description="Ngân sách còn lại cho các hoạt động thay thế")
    current_activities: List[ActivityItem] = Field(..., description="Lịch trình của ngày đang bị ảnh hưởng")
    latitude: float = Field(..., description="Vĩ độ hiện tại của du khách")
    longitude: float = Field(..., description="Kinh độ hiện tại của du khách")
    radius_km: Optional[float] = Field(5.0, description="Bán kính tìm kiếm các điểm trong nhà thay thế (km)")

class WeatherAdjustmentResponse(BaseModel):
    updated_activities: List[ActivityItem] = Field(..., description="Lịch trình mới đã được AI thay thế điểm đến")
    adjustment_reason: str = Field(..., description="Lời giải thích của AI về lý do thay đổi")
