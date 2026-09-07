from pydantic import BaseModel, Field
from typing import List, Optional

class RecommendPlacesRequest(BaseModel):
    latitude: float = Field(..., description="Vĩ độ (Ví dụ: 16.047079)")
    longitude: float = Field(..., description="Kinh độ (Ví dụ: 108.206230)")
    radius_km: float = Field(default=5.0, description="Bán kính tìm kiếm quanh vị trí (km)")
    category: str = Field(..., description="Phân loại: restaurant | attraction | accommodation")
    preferences: Optional[List[str]] = Field(default=[], example=["seafood", "ngon rẻ"])

class PlaceItem(BaseModel):
    name: str
    category: str
    address: str
    latitude: float
    longitude: float
    reason: str
    google_maps_url: Optional[str] = None
    website_url: Optional[str] = None
    phone_number: Optional[str] = None
    opening_hours: Optional[str] = None
    is_indoor: Optional[bool] = None
    city: Optional[str] = None
    country: Optional[str] = None
    image_url: Optional[str] = None
    source_provider: Optional[str] = None
    rating: Optional[float] = None
    review_count: Optional[int] = None
    avg_cost: Optional[float] = None
    currency: Optional[str] = None
    is_active: Optional[bool] = True

class RecommendPlacesResponse(BaseModel):
    total_found: int
    recommendations: List[PlaceItem]
