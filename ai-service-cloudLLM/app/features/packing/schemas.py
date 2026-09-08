from pydantic import BaseModel, Field
from typing import List, Optional
from enum import Enum

class PackingPriority(str, Enum):
    must_have = "must_have"
    recommended = "recommended"
    optional = "optional"

class PackingItem(BaseModel):
    name: str = Field(..., description="Tên đồ vật cần mang")
    quantity: Optional[int] = Field(default=1, description="Số lượng cần mang")
    priority: PackingPriority = Field(..., description="Mức độ ưu tiên: must_have | recommended | optional")
    note: Optional[str] = Field(default=None, description="Ghi chú đặc biệt về món đồ này")

class PackingCategory(BaseModel):
    name: str = Field(..., description="Tên danh mục")
    icon: str = Field(..., description="Emoji icon đại diện")
    items: List[PackingItem] = Field(..., description="Danh sách đồ vật trong danh mục")

class PackingListRequest(BaseModel):
    destination: str = Field(..., description="Điểm đến du lịch")
    duration_days: int = Field(..., description="Số ngày chuyến đi")
    travel_style: str = Field(..., description="Phong cách du lịch (budget, luxury, adventure, cultural, beach...)")
    season: Optional[str] = Field(default=None, description="Mùa/thời tiết dự kiến (summer/winter/rainy/dry)")
    activities: Optional[List[str]] = Field(default=[], description="Các hoạt động dự kiến (hiking, swimming, trekking, cycling...)")
    traveler_profile: Optional[str] = Field(default="couple", description="Đối tượng du khách (solo/couple/family/group)")
    special_needs: Optional[List[str]] = Field(default=[], description="Yêu cầu đặc biệt (baby, elderly, medical condition...)")

class PackingListResponse(BaseModel):
    destination: str = Field(..., description="Điểm đến")
    duration_days: int = Field(..., description="Số ngày")
    total_items: int = Field(..., description="Tổng số món đồ cần mang")
    categories: List[PackingCategory] = Field(..., description="Danh sách đồ dùng phân theo danh mục")
    special_notes: str = Field(..., description="Lưu ý đặc biệt cho chuyến đi này")
    luggage_advice: str = Field(..., description="Gợi ý về kích thước/loại hành lý phù hợp")
