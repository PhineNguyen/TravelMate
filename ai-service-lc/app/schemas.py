from pydantic import BaseModel, Field
from typing import List, Optional

# --- SCHEMAS CHO RECOMMEND PLACES ---
class RecommendPlacesRequest(BaseModel):
    latitude: float = Field(..., example=16.0544)
    longitude: float = Field(..., example=108.2022)
    radius_km: float = Field(default=5.0, description="Bán kính (km)")
    category: str = Field(default="restaurant", description="restaurant | attraction | accommodation")
    preferences: Optional[List[str]] = Field(default=[], example=["seafood", "ngon rẻ"])

class PlaceItem(BaseModel):
    name: str
    category: str
    address: str
    latitude: float
    longitude: float
    reason: str
    google_maps_url: Optional[str] = None
    website: Optional[str] = None
    phone: Optional[str] = None
    opening_hours: Optional[str] = None

class RecommendPlacesResponse(BaseModel):
    total_found: int
    recommendations: List[PlaceItem]


# --- SCHEMAS CHO GENERATE ITINERARY ---
class GenerateItineraryRequest(BaseModel):
    destination: str = Field(..., example="Đà Nẵng")
    duration_days: int = Field(..., ge=1, le=14, example=3)
    budget: float = Field(..., example=5000000)
    travel_style: str = Field(default="Cân bằng", example="Văn hóa & Ẩm thực")
    traveler_count: int = Field(default=1, ge=1, example=2)

class ActivityItem(BaseModel):
    time: str = Field(..., example="08:00 - 10:00")
    place_name: str
    category: str = Field(..., example="restaurant / attraction / accommodation")
    estimated_cost: float
    description: str

class DayPlan(BaseModel):
    day: int
    theme: str
    activities: List[ActivityItem]

class GenerateItineraryResponse(BaseModel):
    destination: str
    duration_days: int
    estimated_total_cost: float
    summary: str
    itinerary: List[DayPlan]


# --- SCHEMAS CHO OPTIMIZE ROUTE ---
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


# --- SCHEMAS CHO ADJUST WEATHER ---
class WeatherAdjustmentRequest(BaseModel):
    weather_alert: str = Field(..., description="Bản tin cảnh báo thời tiết (ví dụ: Chiều mai có mưa bão)")
    budget_limit: float = Field(..., description="Ngân sách còn lại cho các hoạt động thay thế")
    current_activities: List[ActivityItem] = Field(..., description="Lịch trình của ngày đang bị ảnh hưởng")

class WeatherAdjustmentResponse(BaseModel):
    updated_activities: List[ActivityItem] = Field(..., description="Lịch trình mới đã được AI thay thế điểm đến")
    adjustment_reason: str = Field(..., description="Lời giải thích của AI về lý do thay đổi")


# --- SCHEMAS CHO AI CHAT ---
class ChatRequest(BaseModel):
    session_id: str = Field(..., description="ID định danh phiên chat (Ví dụ: trip_123_chat)")
    message: str = Field(..., description="Tin nhắn người dùng gửi cho AI")

class ChatResponse(BaseModel):
    reply: str = Field(..., description="Câu trả lời từ AI")