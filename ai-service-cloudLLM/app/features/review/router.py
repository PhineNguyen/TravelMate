from fastapi import APIRouter, HTTPException
from app.features.review.schemas import TripReviewRequest, TripReviewResponse
from app.features.review.service import review_trip_itinerary

router = APIRouter(prefix="/ai", tags=["Trip Review & Analysis"])

@router.post("/trip-review", response_model=TripReviewResponse)
async def trip_review(payload: TripReviewRequest):
    """
    AI đọc toàn bộ lịch trình (tận dụng 131K context) và:
    - Chấm điểm tổng thể (0-10)
    - Chấm 5 tiêu chí chi tiết: cân bằng, đa dạng, ngân sách, nhịp độ, tính địa phương
    - Liệt kê điểm mạnh / điểm yếu
    - Đề xuất cải thiện cụ thể theo từng ngày/hoạt động
    - Phân tích ngân sách
    - Đưa ra 1 mẹo tối ưu nhất cho cả chuyến đi
    """
    try:
        result = await review_trip_itinerary(
            destination=payload.destination,
            budget=payload.budget,
            traveler_count=payload.traveler_count,
            travel_style=payload.travel_style or "general",
            preferences=payload.preferences or [],
            itinerary=payload.itinerary
        )
        if not result:
            raise HTTPException(status_code=500, detail="AI không thể đánh giá lịch trình này.")
        return result
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"Lỗi khi đánh giá lịch trình: {str(e)}"
        )
