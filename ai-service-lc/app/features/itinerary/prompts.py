import json

def get_itinerary_prompt(destination: str, duration_days: int, budget: float, travel_style: str, traveler_count: int) -> str:
    return f"""
    Bạn là chuyên gia lập kế hoạch du lịch chuyên nghiệp. Hãy tạo lịch trình chi tiết:
    - Điểm đến: {destination}
    - Số ngày: {duration_days} ngày
    - Tổng ngân sách: {budget} VNĐ
    - Phong cách: {travel_style}
    - Số khách: {traveler_count} người

    Yêu cầu:
    1. Lập kế hoạch chi tiết cho từng ngày (Day 1, Day 2...).
    2. Phân bổ các hoạt động theo mốc thời gian hợp lý (Sáng, Trưa, Chiều, Tối).
    3. Ước tính chi phí chi tiết sao cho tổng chi phí gần bằng hoặc nhỏ hơn ngân sách.
    4. Gán category rõ ràng: "restaurant", "attraction", "accommodation", "activity".
    5. Hãy tính toán chính xác và điền các trường `start_time` (mốc giờ bắt đầu hoạt động, ví dụ "08:00") và `duration_minutes` (khoảng thời gian hoạt động kéo dài bao nhiêu phút, dạng số nguyên).

    Trả về ĐÚNG cấu trúc JSON theo mẫu sau, không kèm bất kỳ câu thoại thừa nào:
    {{
      "destination": "{destination}",
      "duration_days": {duration_days},
      "estimated_total_cost": {budget},
      "summary": "Mô tả tóm tắt trải nghiệm chuyến đi...",
      "itinerary": [
        {{
          "day": 1,
          "theme": "Chủ đề ngày 1",
          "activities": [
            {{
              "time": "08:00 - 09:30",
              "start_time": "08:00",
              "duration_minutes": 90,
              "place_name": "Tên địa điểm/Quán ăn",
              "category": "restaurant",
              "estimated_cost": 100000,
              "description": "Mô tả ngắn gọn hoạt động"
            }}
          ]
        }}
      ]
    }}
    """

def get_optimize_route_prompt(loc_list: list) -> str:
    return f"""
    Bạn là chuyên gia tối ưu lộ trình du lịch.
    Dưới đây là danh sách toàn bộ {len(loc_list)} địa điểm cần tối ưu hóa thứ tự di chuyển để khoảng cách địa lý ngắn nhất, tránh đi vòng:
    {json.dumps(loc_list, ensure_ascii=False)}

    Hãy sắp xếp lại thứ tự di chuyển cho TOÀN BỘ {len(loc_list)} địa điểm trên. Giá trị "optimized_sequence" bắt đầu từ 1 cho địa điểm đầu tiên, tăng dần lên 2, 3... cho các địa điểm tiếp theo.
    Bạn bắt buộc phải trả về đầy đủ tất cả {len(loc_list)} địa điểm trong kết quả.
    Trả về ĐÚNG cấu trúc mảng JSON gồm các đối tượng có cấu trúc như mẫu sau, không kèm bất kỳ câu thoại nào:
    [
      {{
        "location_name": "Tên địa điểm",
        "optimized_sequence": 1
      }}
    ]
    """

def get_weather_adjustment_prompt(weather_alert: str, budget_limit: float, activities_list: list) -> str:
    return f"""
    Bạn là chuyên gia điều chỉnh lịch trình du lịch thông minh dựa trên thời tiết.
    - Cảnh báo thời tiết: {weather_alert}
    - Giới hạn ngân sách còn lại: {budget_limit} VNĐ
    - Lịch trình hiện tại của ngày bị ảnh hưởng:
    {json.dumps(activities_list, ensure_ascii=False)}

    Yêu cầu:
    1. Hãy quét qua lịch trình hiện tại, xác định các hoạt động ngoài trời (ví dụ: tham quan thác, bãi biển, leo núi) và thay thế bằng các hoạt động trong nhà phù hợp (ví dụ: bảo tàng, quán cà phê trong nhà, trung tâm thương mại, khu vui chơi trong nhà).
    2. Đảm bảo tổng chi phí của các hoạt động mới thay thế không vượt quá giới hạn ngân sách ({budget_limit} VNĐ).
    3. Giữ nguyên khung thời gian (`time`), mốc giờ bắt đầu (`start_time`), và thời gian kéo dài (`duration_minutes`) của hoạt động cũ.
    4. Trả về giải thích ngắn gọn lý do điều chỉnh.

    Trả về ĐÚNG cấu trúc JSON sau, không kèm bất kỳ lời thoại nào:
    {{
      "updated_activities": [
        {{
          "time": "Khung giờ cũ",
          "start_time": "Mốc giờ bắt đầu cũ",
          "duration_minutes": 90,
          "place_name": "Tên địa điểm trong nhà mới",
          "category": "restaurant/attraction/accommodation/activity",
          "estimated_cost": 150000,
          "description": "Mô tả ngắn gọn về địa điểm mới thay thế và lưu ý thời tiết"
        }}
      ],
      "adjustment_reason": "Mô tả tóm tắt lý do thay đổi các hoạt động ngoài trời thành trong nhà..."
    }}
    """
