# Tài Liệu Hướng Dẫn Sử Dụng API - TravelMate AI Service

Dịch vụ AI cục bộ (Local AI Service) sử dụng **FastAPI** kết hợp với **Ollama (Gemma2:2b)** để xử lý trí tuệ nhân tạo và **Geoapify** để truy xuất địa điểm thực tế trên bản đồ.

---

## 1. Đề Xuất Địa Điểm (`POST /ai/recommend-places`)

### Mô tả
Tìm kiếm các địa điểm thực tế quanh tọa độ của người dùng bằng API Geoapify, sau đó dùng mô hình AI để so khớp, xếp hạng và viết lý do đề xuất dựa trên sở thích cá nhân.

### Cấu Trúc Request Body (JSON)
* `latitude` (float, Bắt buộc): Vĩ độ của vị trí trung tâm.
* `longitude` (float, Bắt buộc): Kinh độ của vị trí trung tâm.
* `radius_km` (float, Mặc định: 5.0): Bán kính quét tìm kiếm địa điểm (đơn vị km).
* `category` (string, Bắt buộc): Phân loại cần tìm. Chỉ nhận một trong ba giá trị: `"restaurant"` | `"attraction"` | `"accommodation"`.
* `preferences` (array of strings, Tùy chọn): Danh sách các từ khóa sở thích của người dùng để lọc (ví dụ: món ăn, không gian, mức giá...).

### Nội dung Request mẫu để test
```json
{
  "latitude": 16.0544,
  "longitude": 108.2022,
  "radius_km": 3.0,
  "category": "restaurant",
  "preferences": [
    "hải sản",
    "ngon rẻ",
    "quán cà phê yên tĩnh"
  ]
}
```

### Lệnh cURL để test nhanh
```bash
curl -X POST "http://127.0.0.1:8000/ai/recommend-places" \
     -H "Content-Type: application/json" \
     -d "{\"latitude\": 16.0544, \"longitude\": 108.2022, \"radius_km\": 3.0, \"category\": \"restaurant\", \"preferences\": [\"hải sản\", \"ngon rẻ\"]}"
```

---

## 2. Trò Chuyện Trợ Lý Ảo (`POST /ai/chat`)

### Mô tả
Gửi tin nhắn hỏi đáp trợ lý ảo thông minh. Dữ liệu tin nhắn sẽ được ghi nhận và lưu trữ vĩnh viễn trong CSDL PostgreSQL. Lịch sử trò chuyện sẽ được tự động tích hợp làm ngữ cảnh (context) khi gửi yêu cầu tới LLM để đảm bảo khả năng nhớ ngữ cảnh các câu hỏi trước.

### Cấu Trúc Request Body (JSON)
* `session_id` (string, Bắt buộc): ID định danh phiên chat (ví dụ: ID của chuyến đi để gom nhóm cuộc hội thoại, dạng `trip_123_chat`).
* `message` (string, Bắt buộc): Câu hỏi hoặc nội dung tin nhắn người dùng gửi cho AI.

### Nội dung Request mẫu để test
```json
{
  "session_id": "trip_da_nang_2026",
  "message": "Tôi đang lên kế hoạch đi du lịch Đà Nẵng 3 ngày, hãy gợi ý cho tôi lộ trình ngày đầu tiên."
}
```

### Lệnh cURL để test nhanh
```bash
curl -X POST "http://127.0.0.1:8000/ai/chat" \
     -H "Content-Type: application/json" \
     -d "{\"session_id\": \"trip_da_nang_2026\", \"message\": \"Xin chào! Bạn là ai?\"}"
```

---

## 3. Lấy Lịch Sử Chat (`GET /ai/chat/{session_id}`)

### Mô tả
Truy xuất lịch sử toàn bộ các tin nhắn đã trao đổi của một phiên chat từ PostgreSQL để hiển thị lên giao diện ứng dụng.

### Tham Số Trên Đường Dẫn (Path Parameter)
* `session_id` (string, Bắt buộc): ID định danh phiên chat cần lấy lịch sử.

### Lệnh cURL để test nhanh
```bash
curl -X GET "http://127.0.0.1:8000/ai/chat/trip_da_nang_2026"
```

---

## 4. Xóa Lịch Sử Chat (`DELETE /ai/chat/{session_id}`)

### Mô tả
Xóa sạch toàn bộ lịch sử các tin nhắn của một phiên chat từ PostgreSQL (dùng để reset cuộc hội thoại hoặc bắt đầu lại phiên chat mới).

### Tham Số Trên Đường Dẫn (Path Parameter)
* `session_id` (string, Bắt buộc): ID định danh phiên chat cần xóa lịch sử.

### Lệnh cURL để test nhanh
```bash
curl -X DELETE "http://127.0.0.1:8000/ai/chat/trip_da_nang_2026"
```

---

## 5. Tối Ưu Lộ Trình Di Chuyển (`POST /ai/optimize-route`)

### Mô tả
Sắp xếp lại thứ tự ghé thăm các địa điểm trong ngày sao cho tuyến đường di chuyển là ngắn nhất, tránh việc đi vòng hoặc lặp lại đường đi.

### Cấu Trúc Request Body (JSON)
* `locations` (array of objects, Bắt buộc): Danh sách địa điểm cần tối ưu. Mỗi đối tượng gồm:
  * `location_name` (string, Bắt buộc): Tên địa điểm.
  * `current_sequence` (int, Bắt buộc): Thứ tự hiện tại (1, 2, 3...).
  * `place_id` (int, Tùy chọn): ID địa điểm tương ứng từ CSDL backend.
  * `latitude` (float, Tùy chọn): Vĩ độ của địa điểm.
  * `longitude` (float, Tùy chọn): Kinh độ của địa điểm.
  * `category` (string, Tùy chọn): Phân loại địa điểm (`restaurant` | `attraction` | `accommodation` | `activity`).

### Nội dung Request mẫu để test
```json
{
  "locations": [
    {
      "place_id": 101,
      "location_name": "Bán đảo Sơn Trà",
      "current_sequence": 1,
      "latitude": 16.0984,
      "longitude": 108.2721,
      "category": "attraction"
    },
    {
      "place_id": 102,
      "location_name": "Chùa Linh Ứng",
      "current_sequence": 2,
      "latitude": 16.1008,
      "longitude": 108.2778,
      "category": "attraction"
    },
    {
      "place_id": 104,
      "location_name": "Nhà hàng hải sản Bé Mặn",
      "current_sequence": 3,
      "latitude": 16.0825,
      "longitude": 108.2492,
      "category": "restaurant"
    },
    {
      "place_id": 103,
      "location_name": "Cầu Rồng",
      "current_sequence": 4,
      "latitude": 16.0612,
      "longitude": 108.2268,
      "category": "attraction"
    }
  ]
}
```

### Cấu Trúc Response Trả Về (JSON)
* `optimized_route` (array of objects): Danh sách các địa điểm đã sắp xếp tối ưu. Mỗi đối tượng gồm:
  * `place_id` (int): ID địa điểm từ backend CSDL.
  * `location_name` (string): Tên địa điểm.
  * `optimized_sequence` (int): Thứ tự di chuyển tối ưu mới (1, 2, 3...).
  * `description` (string): Lời giới thiệu/giải thích lý do AI xếp địa điểm vào thứ tự này trong ngày.

### Lệnh cURL để test nhanh
```bash
curl -X POST "http://127.0.0.1:8000/ai/optimize-route" \
     -H "Content-Type: application/json" \
     -d "{\"locations\": [{\"place_id\": 101, \"location_name\": \"Bán đảo Sơn Trà\", \"current_sequence\": 1, \"latitude\": 16.0984, \"longitude\": 108.2721, \"category\": \"attraction\"}, {\"place_id\": 104, \"location_name\": \"Nhà hàng hải sản Bé Mặn\", \"current_sequence\": 2, \"latitude\": 16.0825, \"longitude\": 108.2492, \"category\": \"restaurant\"}]}"
```

---

## 6. Điều Chỉnh Thời Tiết Xấu (`POST /ai/adjust-weather`)

### Mô tả
Khi thời tiết thay đổi đột ngột (mưa, bão), AI sẽ tự động phân tích lịch trình hiện tại của người dùng, lọc các điểm ngoài trời gặp thời tiết xấu và thay thế bằng các điểm trong nhà phù hợp với cùng khung giờ và trong giới hạn ngân sách.

### Cấu Trúc Request Body (JSON)
* `weather_alert` (string, Bắt buộc): Bản tin cảnh báo thời tiết xấu (ví dụ: mưa to, bão giật).
* `budget_limit` (float, Bắt buộc): Ngân sách còn lại của ngày hôm đó (VNĐ).
* `current_activities` (array of objects, Bắt buộc): Danh sách các hoạt động hiện tại cần lọc chỉnh sửa.

### Nội dung Request mẫu để test
```json
{
  "weather_alert": "Thời tiết ngày mai tại Đà Nẵng có mưa rất lớn kèm dông sét từ trưa đến chiều tối.",
  "budget_limit": 500000.0,
  "current_activities": [
    {
      "time": "14:00 - 17:00",
      "start_time": "14:00",
      "duration_minutes": 180,
      "place_name": "Tắm biển và chơi thể thao tại Bãi biển Mỹ Khê",
      "category": "activity",
      "estimated_cost": 50000.0,
      "description": "Tham gia các trò chơi vận động bãi biển ngoài trời."
    }
  ]
}
```

### Lệnh cURL để test nhanh
```bash
curl -X POST "http://127.0.0.1:8000/ai/adjust-weather" \
     -H "Content-Type: application/json" \
     -d "{\"weather_alert\": \"mưa lớn\", \"budget_limit\": 300000, \"current_activities\": [{\"time\": \"14:00 - 15:30\", \"start_time\": \"14:00\", \"duration_minutes\": 90, \"place_name\": \"Bãi biển Mỹ Khê\", \"category\": \"activity\", \"estimated_cost\": 0, \"description\": \"tắm biển\"}]}"
```

---

## 7. Tự Động Thiết Kế Lịch Trình (`POST /ai/generate-itinerary`)

### Mô tả
Tự động thiết lập lịch trình du lịch trọn gói chi tiết từng ngày bao gồm: Khung giờ di chuyển, tên địa điểm tham quan/ăn uống, phân loại danh mục, ước lượng chi phí và mô tả hoạt động.

### Cấu Trúc Request Body (JSON)
* `destination` (string, Bắt buộc): Điểm đến du lịch (ví dụ: Đà Nẵng, Phú Quốc...).
* `duration_days` (int, Bắt buộc): Số lượng ngày của kỳ nghỉ.
* `budget` (float, Bắt buộc): Tổng ngân sách dự kiến cho chuyến đi (VNĐ).
* `travel_style` (string, Bắt buộc): Phong cách du lịch (ví dụ: nghỉ dưỡng, ngon rẻ, khám phá mạo hiểm...).
* `traveler_count` (int, Bắt buộc): Số lượng người tham gia hành trình.
* `preferences` (array of strings, Tùy chọn): Danh sách sở thích, yêu cầu đặc biệt của khách du lịch (ví dụ: hải sản, check-in, yên tĩnh...).

### Nội dung Request mẫu để test
```json
{
  "destination": "Đà Nẵng",
  "duration_days": 2,
  "budget": 2500000.0,
  "travel_style": "ngon rẻ, trải nghiệm địa phương",
  "traveler_count": 2,
  "preferences": [
    "ẩm thực hải sản",
    "chụp ảnh check-in",
    "yêu thích thiên nhiên"
  ]
}
```

### Lệnh cURL để test nhanh
```bash
curl -X POST "http://127.0.0.1:8000/ai/generate-itinerary" \
     -H "Content-Type: application/json" \
     -d "{\"destination\": \"Nha Trang\", \"duration_days\": 2, \"budget\": 3000000, \"travel_style\": \"khám phá\", \"traveler_count\": 2, \"preferences\": [\"hải sản\"]}"
```
