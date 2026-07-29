from fastapi import APIRouter, HTTPException
from app.schemas import GenerateItineraryRequest, GenerateItineraryResponse
from app.services.llm_service import generate_itinerary_llm

router = APIRouter(prefix="/ai", tags=["Trip Planning"])

@router.post("/generate-itinerary", response_model=GenerateItineraryResponse)
async def generate_itinerary(payload: GenerateItineraryRequest):
    try:
        result = await generate_itinerary_llm(
            destination=payload.destination,
            duration_days=payload.duration_days,
            budget=payload.budget,
            travel_style=payload.travel_style,
            traveler_count=payload.traveler_count
        )
        return result
    except Exception as e:
        raise HTTPException(
            status_code=500, 
            detail=f"Lỗi khi AI sinh lịch trình: {str(e)}"
        )