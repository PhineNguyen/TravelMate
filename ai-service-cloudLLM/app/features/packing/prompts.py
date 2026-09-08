def get_packing_list_prompt(
    destination: str,
    duration_days: int,
    travel_style: str,
    season: str,
    activities: list,
    traveler_profile: str,
    special_needs: list
) -> str:
    season_str = f" - Thời tiết/Mùa: {season}" if season else ""
    activities_str = f"\n    - Hoạt động dự kiến: {', '.join(activities)}" if activities else ""
    needs_str = f"\n    - Yêu cầu đặc biệt: {', '.join(special_needs)}" if special_needs else ""

    return f"""
    Bạn là chuyên gia tư vấn hành lý du lịch chuyên nghiệp. Hãy tạo danh sách đồ cần mang hoàn chỉnh, thực tế và được cá nhân hóa:

    Thông tin chuyến đi:
    - Điểm đến: {destination}
    - Số ngày: {duration_days} ngày{season_str}
    - Phong cách: {travel_style}
    - Đối tượng: {traveler_profile}{activities_str}{needs_str}

    Yêu cầu tạo danh sách:
    1. Phân loại đồ vật theo các danh mục sau (chỉ bao gồm danh mục phù hợp):
       - "Quần áo & Giày dép" (👕)
       - "Giấy tờ & Tài chính" (📄)
       - "Điện tử & Công nghệ" (📱)
       - "Vệ sinh & Làm đẹp" (🧴)
       - "Y tế & Sức khỏe" (💊)
       - "Đồ dùng chuyến đi" (🎒)
       - "Thức ăn & Đồ uống" (🍱) - nếu phù hợp
       - "Thiết bị hoạt động" (🏕️) - nếu có outdoor/adventure activities

    2. Với mỗi item, xác định:
       - `priority`: "must_have" (bắt buộc), "recommended" (nên có), "optional" (tuỳ chọn)
       - `quantity`: số lượng cụ thể
       - `note`: ghi chú đặc biệt liên quan đến {destination} hoặc hoạt động (để trống nếu không cần)

    3. `special_notes`: Lưu ý quan trọng riêng cho chuyến đi {destination} (thời tiết, quy định, văn hóa ảnh hưởng đến hành lý...)
    4. `luggage_advice`: Khuyến nghị về loại túi/vali (ba lô, vali kéo, dung tích...) phù hợp nhất cho chuyến đi này.

    Trả về ĐÚNG cấu trúc JSON sau (không kèm bất kỳ text nào ngoài JSON):
    {{
      "destination": "{destination}",
      "duration_days": {duration_days},
      "total_items": <tổng số items>,
      "categories": [
        {{
          "name": "Quần áo & Giày dép",
          "icon": "👕",
          "items": [
            {{
              "name": "Tên đồ vật",
              "quantity": 2,
              "priority": "must_have",
              "note": "Ghi chú nếu cần, null nếu không"
            }}
          ]
        }}
      ],
      "special_notes": "...",
      "luggage_advice": "..."
    }}
    """
