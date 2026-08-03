from fastapi import APIRouter, HTTPException
from app.schemas import (
    GenerateItineraryRequest, GenerateItineraryResponse,
    RouteOptimizationRequest, OptimizedRouteResponse,
    WeatherAdjustmentRequest, WeatherAdjustmentResponse,
    ChatRequest, ChatResponse, ChatMessageItem, ChatHistoryResponse
)
from app.services.llm_service import (
    generate_itinerary_llm, optimize_route_llm,
    adjust_weather_llm, chat_with_ai_llm, get_chat_history_llm
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

@router.post("/chat", response_model=ChatResponse)
async def chat(payload: ChatRequest):
    try:
        reply = await chat_with_ai_llm(payload.session_id, payload.message)
        return ChatResponse(reply=reply)
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"Lỗi khi chat với AI: {str(e)}"
        )

@router.get("/chat/{session_id}", response_model=ChatHistoryResponse)
async def get_chat_history(session_id: str):
    try:
        history = await get_chat_history_llm(session_id)
        messages = [ChatMessageItem(role=msg["role"], content=msg["content"]) for msg in history]
        return ChatHistoryResponse(session_id=session_id, messages=messages)
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"Lỗi khi lấy lịch sử chat: {str(e)}"
        )