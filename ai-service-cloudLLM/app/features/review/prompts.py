import json

def get_trip_review_prompt(
    destination: str,
    budget: float,
    traveler_count: int,
    travel_style: str,
    preferences: list,
    itinerary_json: str
) -> str:
    pref_str = f"\n    - Sở thích: {', '.join(preferences)}" if preferences else ""
    return f"""
    Bạn là chuyên gia tư vấn du lịch cao cấp với hơn 15 năm kinh nghiệm. Hãy phân tích và đánh giá toàn diện lịch trình dưới đây:

    Thông tin chuyến đi:
    - Điểm đến: {destination}
    - Tổng ngân sách: {budget:,.0f} VNĐ
    - Số người: {traveler_count} người
    - Phong cách du lịch: {travel_style}{pref_str}

    Lịch trình cần đánh giá:
    {itinerary_json}

    Yêu cầu đánh giá (hãy đọc kỹ toàn bộ lịch trình trước khi chấm điểm):

    1. `overall_score` (0-10): Điểm tổng thể.
    2. `verdict`: Nhận xét tổng quát ngắn gọn 1-2 câu, thẳng thắn và chuyên nghiệp.
    3. `scores`: Chấm điểm chi tiết 5 tiêu chí (mỗi tiêu chí 0-10):
       - `balance`: Cân bằng hoạt động trong ngày (phân bổ sáng/trưa/chiều/tối hợp lý, không quá tải một khung giờ)
       - `diversity`: Đa dạng trải nghiệm (mix tham quan, ăn uống, nghỉ ngơi, hoạt động)
       - `budget_efficiency`: Hiệu quả chi tiêu (giá trị nhận được so với tiền bỏ ra)
       - `pacing`: Nhịp độ (không quá dày đặc gây mệt mỏi, không quá nhàn gây lãng phí thời gian)
       - `local_authenticity`: Tính địa phương (trải nghiệm thực tế local vs tourist trap)
    4. `strengths`: 2-4 điểm mạnh cụ thể của lịch trình.
    5. `weaknesses`: 2-3 điểm yếu hoặc vấn đề cụ thể phát hiện.
    6. `suggestions`: 2-4 gợi ý cải thiện CỤ THỂ (đề cập đúng tên hoạt động và ngày), format:
       {{
         "day": <số thứ tự ngày>,
         "activity": "<tên hoạt động cụ thể trong lịch trình>",
         "issue": "<vấn đề phát hiện>",
         "suggestion": "<gợi ý thay thế hoặc cải thiện cụ thể>"
       }}
    7. `budget_analysis`: Phân tích ngân sách (tổng chi phí ước tính, phân bổ %, nhận xét có vượt ngân sách không, mức độ hợp lý).
    8. `optimized_tip`: 1 mẹo tối ưu nhất (thực sự có giá trị) để nâng cấp toàn bộ lịch trình.

    Trả về ĐÚNG cấu trúc JSON sau (không kèm bất kỳ text nào ngoài JSON):
    {{
      "destination": "{destination}",
      "overall_score": 8.5,
      "verdict": "Lịch trình có nền tảng tốt, nhưng cần điều chỉnh nhịp độ ngày 2...",
      "scores": {{
        "balance": 8.0,
        "diversity": 9.0,
        "budget_efficiency": 7.5,
        "pacing": 8.5,
        "local_authenticity": 8.0
      }},
      "strengths": ["Điểm mạnh 1...", "Điểm mạnh 2..."],
      "weaknesses": ["Điểm yếu 1...", "Điểm yếu 2..."],
      "suggestions": [
        {{
          "day": 1,
          "activity": "Tên hoạt động cụ thể",
          "issue": "Vấn đề...",
          "suggestion": "Gợi ý cụ thể..."
        }}
      ],
      "budget_analysis": "Tổng chi phí ước tính: X VNĐ...",
      "optimized_tip": "Mẹo tối ưu nhất..."
    }}
    """
