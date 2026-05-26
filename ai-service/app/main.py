from fastapi import FastAPI, HTTPException, Depends
from app.schemas import TripRequest
from app.ai_core import AICoreService

app = FastAPI(
    title="TravelMate AI Service",
    description="Dịch vụ xử lý AI độc lập cho dự án TravelMate",
    version="1.0.0"
)

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