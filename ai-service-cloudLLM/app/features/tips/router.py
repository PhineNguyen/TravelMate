from fastapi import APIRouter, HTTPException
from app.features.tips.schemas import TravelTipsRequest, TravelTipsResponse
from app.features.tips.service import generate_travel_tips

router = APIRouter(prefix="/ai", tags=["Travel Tips & Guide"])

@router.post("/travel-tips", response_model=TravelTipsResponse)
async def travel_tips(payload: TravelTipsRequest):
    """
    Sinh cẩm nang du lịch toàn diện cho một điểm đến:
    - Tips về văn hóa, an toàn, di chuyển, ẩm thực, thời tiết, tiền tệ
    - Địa điểm ít người biết (hidden gems)
    - Lưu ý phong tục địa phương
    - Mẹo tiết kiệm thực tế
    """
    try:
        result = await generate_travel_tips(
            destination=payload.destination,
            duration_days=payload.duration_days,
            travel_style=payload.travel_style,
            traveler_count=payload.traveler_count,
            season=payload.season,
            preferences=payload.preferences
        )
        if not result:
            raise HTTPException(status_code=500, detail="AI không thể tạo tips du lịch cho điểm đến này.")
        return result
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"Lỗi khi tạo cẩm nang du lịch: {str(e)}"
        )
