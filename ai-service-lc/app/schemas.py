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