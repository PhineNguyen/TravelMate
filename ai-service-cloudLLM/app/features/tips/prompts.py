import json

def get_travel_tips_prompt(
    destination: str,
    duration_days: int,
    travel_style: str,
    traveler_count: int,
    season: str,
    preferences: list
) -> str:
    season_str = f" vào mùa {season}" if season else ""
    pref_str = f"\n    - Sở thích đặc biệt: {', '.join(preferences)}" if preferences else ""
    traveler_str = f"{traveler_count} người" if traveler_count > 1 else "du khách solo"

    return f"""
    Bạn là một chuyên gia du lịch Việt Nam với nhiều năm kinh nghiệm thực tế. Hãy tạo một bộ cẩm nang du lịch toàn diện và thực tế nhất:

    Thông tin chuyến đi:
    - Điểm đến: {destination}
    - Thời gian: {duration_days} ngày
    - Phong cách: {travel_style}
    - Số người: {traveler_str}{season_str}{pref_str}

    Yêu cầu:
    1. `overview`: Viết 2-3 câu tổng quan đặc sắc về {destination}, tại sao nơi này đặc biệt.
    2. `best_time_to_visit`: Thời điểm lý tưởng nhất (tháng/mùa) và lý do cụ thể.
    3. `tips`: Tạo tối thiểu 8 tips chi tiết, thực tế, chia đều theo các category sau (mỗi tip phải là trải nghiệm thực tế, không chung chung):
       - "culture" 🏛️ (văn hóa, lịch sử)
       - "safety" 🛡️ (an toàn, cảnh giác)
       - "transport" 🚗 (di chuyển, phương tiện)
       - "food" 🍜 (ẩm thực, nơi ăn)
       - "weather" ☀️ (thời tiết, trang phục)
       - "money" 💰 (tiền tệ, mặc cả, tránh bị chặt chém)
       - "etiquette" 🙏 (phong tục, lễ nghĩa)
       - "accommodation" 🏨 (nơi ở, khu vực)
    4. `local_etiquette`: 3-5 điều quan trọng về văn hóa/phong tục cần tôn trọng.
    5. `safety_tips`: 3-5 mẹo an toàn thiết thực nhất.
    6. `money_saving_tips`: 4-6 mẹo tiết kiệm tiền thực sự hữu ích (không nói chung chung).
    7. `hidden_gems`: 3-4 điểm/trải nghiệm ít du khách biết đến nhưng cực kỳ đáng thử.
    8. `useful_phrases`: 3-5 câu/từ tiếng địa phương hoặc lưu ý giao tiếp hữu ích (nếu là điểm đến nước ngoài) hoặc lưu ý ngôn ngữ vùng miền.

    Trả về ĐÚNG cấu trúc JSON sau (không kèm bất kỳ text nào ngoài JSON):
    {{
      "destination": "{destination}",
      "overview": "...",
      "best_time_to_visit": "...",
      "tips": [
        {{
          "category": "culture",
          "icon": "🏛️",
          "title": "Tiêu đề tip ngắn gọn",
          "content": "Nội dung chi tiết và thực tế..."
        }}
      ],
      "local_etiquette": ["Điều 1...", "Điều 2..."],
      "safety_tips": ["An toàn 1...", "An toàn 2..."],
      "money_saving_tips": ["Mẹo 1...", "Mẹo 2..."],
      "hidden_gems": ["Gem 1...", "Gem 2..."],
      "useful_phrases": ["Câu/từ hữu ích 1...", "Câu/từ hữu ích 2..."]
    }}
    """
