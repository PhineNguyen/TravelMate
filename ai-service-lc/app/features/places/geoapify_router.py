from fastapi import APIRouter, HTTPException
from pydantic import BaseModel, Field
import httpx
from app.core.config import settings

router = APIRouter(prefix="/ai/geoapify", tags=["Geoapify Raw Utility"])

CATEGORY_MAPPING = {
    "restaurant": "catering.restaurant,catering.fast_food,catering.cafe",
    "attraction": "tourism.sights,tourism.attraction,entertainment",
    "accommodation": "accommodation.hotel,accommodation.guest_house"
}

# --- Pydantic Schemas for Request Body ---

class GeocodeRawRequest(BaseModel):
    text: str = Field(..., description="Văn bản cần tìm kiếm (Ví dụ: 'Đồng Tháp')", example="Đồng Tháp")

class PlacesRawRequest(BaseModel):
    latitude: float = Field(..., description="Vĩ độ", example=10.425183)
    longitude: float = Field(..., description="Kinh độ", example=105.9271362)
    radius_km: float = Field(default=15.0, description="Bán kính quét (km)", example=15.0)
    category: str = Field(default="attraction", description="Danh mục (attraction, restaurant, accommodation)", example="attraction")
    limit: int = Field(default=20, description="Số lượng kết quả tối đa", example=5)

class RoutingRawRequest(BaseModel):
    waypoints: str = Field(..., description="Các điểm đi nối nhau bằng dấu gạch đứng | (Ví dụ: '10.4251,105.9271|10.4350,105.9350')", example="10.4251,105.9271|10.4350,105.9350")

# --- POST Endpoints (Swagger JSON Body only) ---

@router.post("/geocode")
async def post_raw_geocode(payload: GeocodeRawRequest):
    url = "https://api.geoapify.com/v1/geocode/search"
    params = {
        "text": payload.text,
        "limit": 5,
        "apiKey": settings.GEOAPIFY_API_KEY
    }
    try:
        async with httpx.AsyncClient() as client:
            response = await client.get(url, params=params, timeout=12.0)
            response.raise_for_status()
            return response.json()
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Lỗi gọi Geoapify Geocoding API: {str(e)}")

@router.post("/places")
async def post_raw_places(payload: PlacesRawRequest):
    url = "https://api.geoapify.com/v2/places"
    radius_meters = int(payload.radius_km * 1000)
    geo_category = CATEGORY_MAPPING.get(payload.category, "tourism.sights")
    params = {
        "categories": geo_category,
        "filter": f"circle:{payload.longitude},{payload.latitude},{radius_meters}",
        "bias": f"proximity:{payload.longitude},{payload.latitude}",
        "limit": payload.limit,
        "apiKey": settings.GEOAPIFY_API_KEY
    }
    try:
        async with httpx.AsyncClient() as client:
            response = await client.get(url, params=params, timeout=12.0)
            response.raise_for_status()
            return response.json()
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Lỗi gọi Geoapify Places API: {str(e)}")

@router.post("/routing")
async def post_raw_routing(payload: RoutingRawRequest):
    url = "https://api.geoapify.com/v1/routing"
    params = {
        "waypoints": payload.waypoints,
        "mode": "drive",
        "apiKey": settings.GEOAPIFY_API_KEY
    }
    try:
        async with httpx.AsyncClient() as client:
            response = await client.get(url, params=params, timeout=12.0)
            response.raise_for_status()
            return response.json()
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Lỗi gọi Geoapify Routing API: {str(e)}")
