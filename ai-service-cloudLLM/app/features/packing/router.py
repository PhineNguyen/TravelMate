from fastapi import APIRouter, HTTPException
from app.features.packing.schemas import PackingListRequest, PackingListResponse
from app.features.packing.service import generate_packing_list

router = APIRouter(prefix="/ai", tags=["Packing List"])

@router.post("/packing-list", response_model=PackingListResponse)
async def packing_list(payload: PackingListRequest):
    """
    Tạo danh sách hành lý thông minh, cá nhân hóa theo:
    - Điểm đến & thời tiết/mùa
    - Phong cách & hoạt động dự kiến
    - Đối tượng du khách
    - Phân loại theo danh mục + mức độ ưu tiên (must_have / recommended / optional)
    """
    try:
        result = await generate_packing_list(
            destination=payload.destination,
            duration_days=payload.duration_days,
            travel_style=payload.travel_style,
            season=payload.season,
            activities=payload.activities,
            traveler_profile=payload.traveler_profile,
            special_needs=payload.special_needs
        )
        if not result:
            raise HTTPException(status_code=500, detail="AI không thể tạo danh sách hành lý cho chuyến đi này.")
        return result
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"Lỗi khi tạo danh sách hành lý: {str(e)}"
        )
