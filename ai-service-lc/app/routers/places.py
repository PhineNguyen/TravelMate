from fastapi import APIRouter, HTTPException
from app.schemas import RecommendPlacesRequest, RecommendPlacesResponse
from app.services.geoapify_service import fetch_places_from_geoapify
from app.services.llm_service import rank_and_explain_places

router = APIRouter(prefix="/ai", tags=["Places & Recommendations"])

@router.post("/recommend-places", response_model=RecommendPlacesResponse)
async def recommend_places(payload: RecommendPlacesRequest):
    try:
        # Step 1: Lấy địa điểm thực tế từ Geoapify
        raw_places = await fetch_places_from_geoapify(
            lat=payload.latitude,
            lon=payload.longitude,
            radius_km=payload.radius_km,
            category=payload.category
        )
        
        if not raw_places:
            return RecommendPlacesResponse(total_found=0, recommendations=[])

        # Step 2: Dùng LLM lọc và tạo lý do gợi ý
        ranked_places = await rank_and_explain_places(
            user_preferences=payload.preferences,
            raw_places=raw_places,
            category=payload.category
        )

        return RecommendPlacesResponse(
            total_found=len(ranked_places),
            recommendations=ranked_places
        )

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"AI Service Error: {str(e)}")