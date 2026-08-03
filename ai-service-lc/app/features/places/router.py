from fastapi import APIRouter, HTTPException
from app.features.places.schemas import RecommendPlacesRequest, RecommendPlacesResponse
from app.features.places.geoapify import fetch_places_from_geoapify
from app.features.places.service import rank_and_explain_places

router = APIRouter(prefix="/ai", tags=["Place Recommendations"])

@router.post("/recommend-places", response_model=RecommendPlacesResponse)
async def recommend_places(payload: RecommendPlacesRequest):
    try:
        # 1. Fetch raw places from Geoapify
        raw_places = await fetch_places_from_geoapify(
            lat=payload.latitude,
            lon=payload.longitude,
            radius_km=payload.radius_km,
            category=payload.category,
            limit=20
        )
        
        # 2. Rank and explain matching places using LLM
        recommended = await rank_and_explain_places(
            user_preferences=payload.preferences,
            raw_places=raw_places,
            category=payload.category
        )
        
        return RecommendPlacesResponse(
            total_found=len(recommended),
            recommendations=recommended
        )
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"Lỗi hệ thống khi tìm kiếm địa điểm: {str(e)}"
        )
