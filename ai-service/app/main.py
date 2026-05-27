from fastapi import FastAPI, HTTPException, Depends
from sqlalchemy.orm import Session
from app.database import engine, Base, SessionLocal
from app.schemas import (
    TripRequest, PlaceRecommendationRequest, 
    RouteOptimizationRequest, WeatherAdjustmentRequest,
    ChatRequest
)
from app.ai_core import AICoreService

# Tự động tạo file aichat.db và bảng chat_messages nếu chưa tồn tại
Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="TravelMate AI Service",
    description="Dịch vụ xử lý AI độc lập cho dự án TravelMate",
    version="1.0.0"
)

# Dependency để lấy phiên kết nối Database
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# Khởi tạo instance của AICoreService khi ứng dụng chạy
def get_ai_service():
    return AICoreService()

@app.get("/health")
async def health_check():
    return {"status": "active", "message": "TravelMate AI Service is running"}

@app.post("/ai/generate-itinerary")
async def generate_itinerary(request: TripRequest, ai_service: AICoreService = Depends(get_ai_service)):
    """
    Endpoint tiếp nhận yêu cầu lập kế hoạch từ Java Spring Boot và trả về chuỗi JSON lịch trình sạch.
    """
    try:
        result = await ai_service.generate_itinerary(request)
        return {"status": "success", "data": result}
    except ValueError as ve:
        # Bắt lỗi cấu hình thiếu API Key
        raise HTTPException(status_code=500, detail=str(ve))
    except Exception as e:
        # Bắt các lỗi hệ thống hoặc lỗi kết nối từ phía Google API
        raise HTTPException(status_code=500, detail=f"Lỗi xử lý AI Service: {str(e)}")
    
@app.post("/ai/recommend-places")
async def recommend_places(request: PlaceRecommendationRequest, ai_service: AICoreService = Depends(get_ai_service)):
    try:
        result = await ai_service.recommend_places(request)
        return {"status": "success", "data": result}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Lỗi AI Service: {str(e)}")

@app.post("/ai/optimize-route")
async def optimize_route(request: RouteOptimizationRequest, ai_service: AICoreService = Depends(get_ai_service)):
    try:
        result = await ai_service.optimize_route(request)
        return {"status": "success", "data": result}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Lỗi AI Service: {str(e)}")

@app.post("/ai/adjust-weather")
async def adjust_weather(request: WeatherAdjustmentRequest, ai_service: AICoreService = Depends(get_ai_service)):
    try:
        result = await ai_service.adjust_weather(request)
        return {"status": "success", "data": result}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Lỗi AI Service: {str(e)}")
    
@app.post("/ai/chat")
async def chat_endpoint(
    request: ChatRequest, 
    db: Session = Depends(get_db), 
    ai_service: AICoreService = Depends(get_ai_service)
):
    try:
        result = await ai_service.chat_with_ai(request, db)
        return {"status": "success", "data": result}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Lỗi AI Chat: {str(e)}")