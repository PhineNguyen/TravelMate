import json

def get_itinerary_prompt(destination: str, duration_days: int, budget: float, travel_style: str, traveler_count: int, preferences: list = None) -> str:
    return f"""
    Bạn là chuyên gia lập kế hoạch du lịch chuyên nghiệp. Hãy tạo lịch trình chi tiết:
    - Điểm đến: {destination}
    - Số ngày: {duration_days} ngày
    - Tổng ngân sách: {budget} VNĐ
    - Phong cách: {travel_style}
    - Số khách: {traveler_count} người
    - Sở thích/yêu cầu đặc biệt của khách du lịch: {', '.join(preferences) if preferences else 'Không có'}

    Yêu cầu:
    1. Lập kế hoạch chi tiết cho từng ngày (Day 1, Day 2...). Hãy lựa chọn các địa điểm (nhà hàng, điểm tham quan, hoạt động) và phân bổ thời gian sao cho tối ưu, phù hợp nhất với sở thích/yêu cầu đặc biệt được liệt kê ở trên.
    2. Phân bổ các hoạt động theo mốc thời gian hợp lý (Sáng, Trưa, Chiều, Tối).
    3. Ước tính chi phí chi tiết sao cho tổng chi phí gần bằng hoặc nhỏ hơn ngân sách.
    4. Gán category rõ ràng: "restaurant", "attraction", "accommodation", "activity".
    5. Hãy tính toán chính xác và điền các trường `start_time` (mốc giờ bắt đầu hoạt động, ví dụ "08:00") và `duration_minutes` (khoảng thời gian hoạt động kéo dài bao nhiêu phút, dạng số nguyên).
    6. TỐI ƯU TỐC ĐỘ: Trường `summary` và `description` của từng hoạt động phải viết ngắn gọn và cô đọng (Mỗi description tối đa 30 từ). Tuyệt đối không viết quá dài dòng.

    Trả về ĐÚNG cấu trúc JSON theo mẫu sau, không kèm bất kỳ câu thoại thừa nào:
    {{
      "destination": "{destination}",
      "duration_days": {duration_days},
      "estimated_total_cost": {budget},
      "summary": "Tóm tắt chuyến đi dưới 15 từ...",
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
              "description": "Mô tả ngắn dưới 30 từ"
            }}
          ]
        }}
      ]
    }}
    """

def get_optimize_route_prompt(loc_list: list) -> str:
    return f"""
    Bạn là chuyên gia tối ưu lộ trình du lịch và thiết kế trải nghiệm hành trình cho du khách.
    Dưới đây là danh sách toàn bộ {len(loc_list)} địa điểm cần sắp xếp tối ưu thứ tự di chuyển:
    {json.dumps(loc_list, ensure_ascii=False)}

    Yêu cầu sắp xếp:
    1. Hãy sử dụng tọa độ địa lý (vĩ độ và kinh độ - nếu có cung cấp) để tính toán khoảng cách thực tế giữa các điểm tham quan để sắp xếp lộ trình di chuyển tối ưu địa lý ngắn nhất, tránh đi vòng chéo nhau.
    2. Đồng thời, kết hợp logic hành vi thực tế của con người và tính chất thời điểm trong ngày (Morning/Noon/Afternoon/Evening) dựa trên tên địa điểm hoặc phân loại ("category"):
       - Buổi sáng (Morning): Ưu tiên các hoạt động ngoài trời, tham quan tự nhiên, vận động dạo mát (ví dụ: bãi biển, bán đảo, danh lam thắng cảnh).
       - Buổi trưa (Noon): Ưu tiên các địa điểm ẩm thực ("category": "restaurant" hoặc quán ăn, quán cafe) để nghỉ chân ăn trưa tránh nắng nóng.
       - Buổi chiều (Afternoon): Ưu tiên các địa điểm văn hóa, lịch sử, bảo tàng, không gian trong nhà hoặc quán cà phê, đi bộ nhẹ nhàng.
       - Buổi tối (Evening): Ưu tiên các địa điểm vui chơi giải trí về đêm, cầu đi bộ, chợ đêm, xem biểu diễn nghệ thuật, bar hoặc ăn tối lãng mạn.
    3. Tìm điểm cân bằng tối ưu nhất giữa khoảng cách địa lý ngắn nhất và thứ tự thời gian sinh hoạt tự nhiên hợp lý của con người.
    4. Sắp xếp lại thứ tự di chuyển cho TOÀN BỘ {len(loc_list)} địa điểm trên. Giá trị "optimized_sequence" bắt đầu từ 1 cho địa điểm đầu tiên, tăng dần lên 2, 3... cho các địa điểm tiếp theo.
    5. Bạn bắt buộc phải trả về đầy đủ tất cả {len(loc_list)} địa điểm trong kết quả. Giữ nguyên giá trị "place_id" (nếu có) tương ứng của địa điểm đó.
    6. TỐI ƯU TỐC ĐỘ: Với mỗi địa điểm, hãy viết 1 câu giải thích lý do sắp xếp cực kỳ ngắn gọn, cô đọng (Dưới 10 từ), lưu vào trường "description".

    Trả về ĐÚNG cấu trúc đối tượng JSON chứa mảng như mẫu sau, không kèm bất kỳ câu thoại nào ngoài JSON:
    {{
      "optimized_route": [
        {{
          "place_id": 1,
          "location_name": "Tên địa điểm",
          "optimized_sequence": 1,
          "description": "Lý do sắp xếp siêu ngắn dưới 10 từ..."
        }}
      ]
    }}
    """

def get_weather_adjustment_prompt(weather_alert: str, budget_limit: float, activities_list: list, candidates: list) -> str:
    return f"""
    Bạn là chuyên gia điều chỉnh lịch trình du lịch thông minh dựa trên thời tiết.
    - Cảnh báo thời tiết: {weather_alert}
    - Giới hạn ngân sách còn lại: {budget_limit} VNĐ
    - Lịch trình hiện tại của ngày bị ảnh hưởng:
    {json.dumps(activities_list, ensure_ascii=False)}

    - Danh sách các địa điểm trong nhà thực tế xung quanh du khách (Lấy từ Geoapify):
    {json.dumps(candidates, ensure_ascii=False)}

    Yêu cầu:
    1. Hãy quét qua lịch trình hiện tại, xác định các hoạt động ngoài trời (ví dụ: bãi biển, công viên, đỉnh núi) bị ảnh hưởng bởi thời tiết xấu.
    2. Thay thế các hoạt động ngoài trời bị ảnh hưởng đó bằng các địa điểm trong nhà phù hợp. Bạn bắt buộc phải lựa chọn địa điểm thay thế từ "Danh sách các địa điểm trong nhà thực tế" được cung cấp ở trên (so khớp tên địa điểm để đảm bảo tính xác thực địa lý).
    3. Đảm bảo tổng chi phí của các hoạt động mới thay thế không vượt quá giới hạn ngân sách ({budget_limit} VNĐ).
    4. Giữ nguyên khung thời gian (`time`), mốc giờ bắt đầu (`start_time`), và thời gian kéo dài (`duration_minutes`) của hoạt động cũ.
    5. Trả về giải thích ngắn gọn lý do điều chỉnh.

    Trả về ĐÚNG cấu trúc JSON sau, không kèm bất kỳ lời thoại nào ngoài JSON:
    {{
      "updated_activities": [
        {{
          "time": "Khung giờ cũ",
          "start_time": "Mốc giờ bắt đầu cũ",
          "duration_minutes": 90,
          "place_name": "Tên địa điểm trong nhà chọn từ danh sách thực tế",
          "category": "restaurant/attraction/accommodation/activity",
          "estimated_cost": 150000,
          "description": "Mô tả ngắn gọn về địa điểm mới thay thế và lưu ý thời tiết"
        }}
      ],
      "adjustment_reason": "Giải thích chi tiết lý do và tính hợp lý của sự thay đổi lịch trình theo thời tiết."
    }}
    """

def get_hybrid_itinerary_prompt(destination: str, travel_style: str, preferences: list, activities: list) -> str:
    return f"""
    Bạn là chuyên gia viết lời giới thiệu du lịch.
    Hãy viết mô tả ngắn gọn cho các địa điểm tham quan/ăn uống dưới đây của chuyến đi {destination} với phong cách {travel_style} và sở thích {', '.join(preferences) if preferences else 'Không có'}:

    Danh sách địa điểm:
    {json.dumps(activities, ensure_ascii=False, indent=2)}

    Yêu cầu:
    1. Trả về một đối tượng JSON có trường `summary` (tóm tắt chuyến đi dưới 15 từ) và trường `descriptions` (là mảng chứa đúng {len(activities)} chuỗi mô tả tương ứng theo thứ tự của danh sách trên).
    2. Mỗi chuỗi mô tả phải cực kỳ ngắn gọn và cô đọng (Dưới 10 từ).
    3. Định dạng trả về bắt buộc là JSON như sau:
    {{
      "summary": "Tóm tắt chuyến đi...",
      "descriptions": [
        "Mô tả địa điểm 1",
        "Mô tả địa điểm 2"
      ]
    }}
    """
