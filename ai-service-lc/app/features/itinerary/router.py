from fastapi import APIRouter, HTTPException
from app.features.itinerary.schemas import (
    GenerateItineraryRequest, GenerateItineraryResponse,
    RouteOptimizationRequest, OptimizedRouteResponse,
    WeatherAdjustmentRequest, WeatherAdjustmentResponse
)
from app.features.itinerary.service import (
    generate_itinerary_llm, optimize_route_llm, adjust_weather_llm
)

router = APIRouter(prefix="/ai", tags=["Trip Planning & Assistant"])

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

@router.post("/optimize-route", response_model=OptimizedRouteResponse)
async def optimize_route(payload: RouteOptimizationRequest):
    try:
        optimized = await optimize_route_llm(payload.locations)
        return OptimizedRouteResponse(optimized_route=optimized)
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"Lỗi khi tối ưu lộ trình: {str(e)}"
        )

@router.post("/adjust-weather", response_model=WeatherAdjustmentResponse)
async def adjust_weather(payload: WeatherAdjustmentRequest):
    try:
        result = await adjust_weather_llm(
            weather_alert=payload.weather_alert,
            budget_limit=payload.budget_limit,
            current_activities=payload.current_activities
        )
        return result
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"Lỗi khi điều chỉnh thời tiết: {str(e)}"
        )
