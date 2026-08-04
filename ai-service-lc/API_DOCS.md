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

### Cấu Trúc Response Trả Về (JSON)
* `total_found` (int): Tổng số địa điểm được AI gợi ý thành công.
* `recommendations` (array of objects): Danh sách các địa điểm được xếp hạng. Mỗi đối tượng gồm:
  * `name` (string): Tên địa điểm.
  * `category` (string): Phân loại nhóm địa điểm.
  * `address` (string): Địa chỉ chi tiết.
  * `latitude` (float): Vĩ độ.
  * `longitude` (float): Kinh độ.
  * `reason` (string): Lý do AI đề xuất địa điểm này dựa trên sở thích của người dùng.
  * `google_maps_url` (string/null): Link điều hướng Google Maps trực tiếp.
  * `website_url` (string/null): Địa chỉ trang web của địa điểm.
  * `phone_number` (string/null): Số điện thoại liên hệ.
  * `opening_hours` (string/null): Giờ hoạt động mở cửa.
  * `is_indoor` (boolean/null): Gán nhãn địa điểm trong nhà (`true`) hoặc ngoài trời (`false`).
  * `city` (string/null): Thành phố.
  * `country` (string/null): Quốc gia.
  * `image_url` (string/null): Link ảnh đại diện địa điểm (nếu có từ wiki/media).
  * `source_provider` (string/null): Nguồn dữ liệu bản đồ (ví dụ: `"openstreetmap"`).
  * `rating` (float/null): Điểm đánh giá (Mặc định: null).
  * `review_count` (int/null): Số lượng đánh giá (Mặc định: null).
  * `avg_cost` (float/null): Chi phí trung bình (Mặc định: null).
  * `currency` (string/null): Đơn vị tiền tệ (Mặc định: null).
  * `is_active` (boolean): Trạng thái hoạt động của địa điểm (Mặc định: true).

#### Ví dụ Response mẫu thành công:
```json
{
  "total_found": 1,
  "recommendations": [
    {
      "name": "Nhà hàng hải sản Bé Mặn",
      "category": "restaurant",
      "address": "Lô 11 Võ Nguyên Giáp, Mân Thái, Sơn Trà, Đà Nẵng, Việt Nam",
      "latitude": 16.0825,
      "longitude": 108.2492,
      "reason": "Nhà hàng hải sản Bé Mặn nổi tiếng với nguồn hải sản tươi sống phong phú, chế biến ngon miệng và giá cả bình dân, cực kỳ phù hợp với yêu cầu 'hải sản ngon rẻ' của bạn.",
      "google_maps_url": "https://www.google.com/maps/search/?api=1&query=16.0825,108.2492",
      "website_url": "http://haisanbeman.com",
      "phone_number": "0905207848",
      "opening_hours": "09:00 - 23:00",
      "is_indoor": false,
      "city": "Đà Nẵng",
      "country": "Vietnam",
      "image_url": "https://example.com/beman.jpg",
      "source_provider": "openstreetmap",
      "rating": null,
      "review_count": null,
      "avg_cost": null,
      "currency": null,
      "is_active": true
    }
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

### Cấu Trúc Response Trả Về (JSON)
* `reply` (string): Câu trả lời hoặc phản hồi tương ứng từ trợ lý ảo AI.

#### Ví dụ Response mẫu thành công:
```json
{
  "reply": "Chào bạn! Với ngày đầu tiên ở Đà Nẵng, bạn nên khám phá Bán đảo Sơn Trà vào buổi sáng và check-in Cầu Rồng vào buổi tối nhé."
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

### Cấu Trúc Response Trả Về (JSON)
* `session_id` (string): ID định danh phiên chat.
* `messages` (array of objects): Danh sách các tin nhắn sắp xếp theo dòng thời gian tăng dần. Mỗi đối tượng gồm:
  * `role` (string): Vai trò gửi tin nhắn (`"system"` | `"user"` | `"assistant"`).
  * `content` (string): Nội dung văn bản tin nhắn.

#### Ví dụ Response mẫu thành công:
```json
{
  "session_id": "trip_da_nang_2026",
  "messages": [
    {
      "role": "user",
      "content": "Tôi đang lên kế hoạch đi du lịch Đà Nẵng 3 ngày, hãy gợi ý cho tôi lộ trình ngày đầu tiên."
    },
    {
      "role": "assistant",
      "content": "Chào bạn! Với ngày đầu tiên ở Đà Nẵng, bạn nên khám phá Bán đảo Sơn Trà..."
    }
  ]
}
```

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

### Cấu Trúc Response Trả Về (JSON)
* `status` (string): Trạng thái xóa (`"success"`).
* `message` (string): Lời nhắn thông báo thành công.

#### Ví dụ Response mẫu thành công:
```json
{
  "status": "success",
  "message": "Đã xóa lịch sử chat của session trip_da_nang_2026 thành công!"
}
```

### Lệnh cURL để test nhanh
```bash
curl -X DELETE "http://127.0.0.1:8000/ai/chat/trip_da_nang_2026"
```

---

## 5. Tối Ưu Lộ Trình Di Chuyển (`POST /ai/optimize-route`)

### Mô tả
Sắp xếp lại thứ tự ghé thăm các địa điểm trong ngày sao cho tuyến đường di chuyển là ngắn nhất, tránh việc đi vòng hoặc lặp lại đường đi, kết hợp với tính chất thời gian trong ngày (Morning/Noon/Evening) và các phân loại danh mục địa điểm phù hợp thói quen sinh hoạt.

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
  * `place_id` (int/null): ID địa điểm gốc từ backend CSDL.
  * `location_name` (string): Tên địa điểm.
  * `optimized_sequence` (int): Thứ tự di chuyển tối ưu mới (1, 2, 3...).
  * `description` (string/null): Lời giới thiệu/giải thích lý do AI xếp địa điểm vào thứ tự này trong ngày (ví dụ: gợi ý ăn trưa hay ngắm hoàng hôn).

#### Ví dụ Response mẫu thành công:
```json
{
  "optimized_route": [
    {
      "location_name": "Bán đảo Sơn Trà",
      "optimized_sequence": 1,
      "place_id": 101,
      "description": "Khám phá vẻ đẹp thiên nhiên hoang sơ của Sơn Trà vào buổi sáng mát mẻ."
    },
    {
      "location_name": "Chùa Linh Ứng",
      "optimized_sequence": 2,
      "place_id": 102,
      "description": "Thăm chùa tâm linh ngay gần bán đảo Sơn Trà trước khi trời nắng gắt."
    },
    {
      "location_name": "Nhà hàng hải sản Bé Mặn",
      "optimized_sequence": 3,
      "place_id": 104,
      "description": "Dừng chân nghỉ ngơi và ăn bữa trưa hải sản tươi sống ngon rẻ lý tưởng."
    },
    {
      "location_name": "Cầu Rồng",
      "optimized_sequence": 4,
      "place_id": 103,
      "description": "Ngắm hoàng hôn thơ mộng trên sông Hàn và check-in Cầu Rồng buổi chiều tối."
    }
  ]
}
```

### Lệnh cURL để test nhanh
```bash
curl -X POST "http://127.0.0.1:8000/ai/optimize-route" \
     -H "Content-Type: application/json" \
     -d "{\"locations\": [{\"place_id\": 101, \"location_name\": \"Bán đảo Sơn Trà\", \"current_sequence\": 1, \"latitude\": 16.0984, \"longitude\": 108.2721, \"category\": \"attraction\"}, {\"place_id\": 104, \"location_name\": \"Nhà hàng hải sản Bé Mặn\", \"current_sequence\": 2, \"latitude\": 16.0825, \"longitude\": 108.2492, \"category\": \"restaurant\"}]}"
```

---

## 6. Điều Chỉnh Thời Tiết Xấu (`POST /ai/adjust-weather`)

### Mô tả
Khi thời tiết thay đổi đột ngột (mưa, bão), AI sẽ tự động quét qua các hoạt động ngoài trời bị ảnh hưởng trong lịch trình hiện tại của du khách. Hệ thống tự động truy vấn danh sách các địa điểm trong nhà thực tế (như quán cafe, bảo tàng, trung tâm thương mại...) xung quanh tọa độ (`latitude`, `longitude`) của du khách từ dữ liệu bản đồ Geoapify, sau đó dùng AI để chọn địa điểm thực tế thay thế phù hợp nhất về thời gian và giới hạn ngân sách.

### Cấu Trúc Request Body (JSON)
* `weather_alert` (string, Bắt buộc): Bản tin cảnh báo thời tiết xấu (ví dụ: mưa to, bão giật).
* `budget_limit` (float, Bắt buộc): Ngân sách còn lại của ngày hôm đó (VNĐ).
* `latitude` (float, Bắt buộc): Vĩ độ vị trí hiện tại của du khách để tìm kiếm điểm xung quanh.
* `longitude` (float, Bắt buộc): Kinh độ vị trí hiện tại của du khách để tìm kiếm điểm xung quanh.
* `radius_km` (float, Tùy chọn, Mặc định: 5.0): Bán kính quét tìm kiếm địa điểm trong nhà thay thế (km).
* `current_activities` (array of objects, Bắt buộc): Danh sách các hoạt động hiện tại cần lọc chỉnh sửa.

### Nội dung Request mẫu để test
```json
{
  "weather_alert": "Thời tiết ngày mai tại Đà Nẵng có mưa rất lớn kèm dông sét từ trưa đến chiều tối.",
  "budget_limit": 500000.0,
  "latitude": 16.0544,
  "longitude": 108.2022,
  "radius_km": 5.0,
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

### Cấu Trúc Response Trả Về (JSON)
* `updated_activities` (array of objects): Danh sách các hoạt động mới thay thế. Mỗi đối tượng gồm:
  * `time` (string): Khung giờ hoạt động.
  * `start_time` (string): Mốc giờ bắt đầu.
  * `duration_minutes` (int): Khoảng thời gian hoạt động kéo dài (phút).
  * `place_name` (string): Tên địa điểm trong nhà mới.
  * `category` (string): Phân loại danh mục.
  * `estimated_cost` (float): Chi phí dự kiến của điểm mới.
  * `description` (string): Mô tả ngắn về hoạt động thay thế trong nhà.
* `adjustment_reason` (string): Lý do và nhận xét của AI về sự thay thế này dựa trên thời tiết.

#### Ví dụ Response mẫu thành công:
```json
{
  "updated_activities": [
    {
      "time": "14:00 - 17:00",
      "start_time": "14:00",
      "duration_minutes": 180,
      "place_name": "Bảo tàng Điêu khắc Chăm Đà Nẵng",
      "category": "attraction",
      "estimated_cost": 60000.0,
      "description": "Tránh mưa bão ngoài trời bằng cách ghé thăm bảo tàng điêu khắc Chăm trong nhà độc đáo."
    }
  ],
  "adjustment_reason": "Bản tin dự báo mưa to dông sét chiều tối nên hoạt động tắm biển ngoài trời tại Mỹ Khê được thay thế bằng tham quan bảo tàng trong nhà để đảm bảo an toàn tuyệt đối và chi phí 60.000 VNĐ nằm trong ngân sách cho phép."
}
```

### Lệnh cURL để test nhanh
```bash
curl -X POST "http://127.0.0.1:8000/ai/adjust-weather" \
     -H "Content-Type: application/json" \
     -d "{\"weather_alert\": \"mưa lớn\", \"budget_limit\": 300000, \"latitude\": 16.0544, \"longitude\": 108.2022, \"radius_km\": 5.0, \"current_activities\": [{\"time\": \"14:00 - 15:30\", \"start_time\": \"14:00\", \"duration_minutes\": 90, \"place_name\": \"Bãi biển Mỹ Khê\", \"category\": \"activity\", \"estimated_cost\": 0, \"description\": \"tắm biển\"}]}"
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

### Cấu Trúc Response Trả Về (JSON)
* `destination` (string): Điểm đến của chuyến đi.
* `duration_days` (int): Tổng số ngày đi.
* `estimated_total_cost` (float): Tổng chi phí ước tính thực tế (VNĐ).
* `summary` (string): Tóm tắt trải nghiệm chung chuyến đi.
* `itinerary` (array of DayItinerary): Danh sách lịch trình chi tiết từng ngày. Mỗi ngày gồm:
  * `day` (int): Số thứ tự ngày (1, 2...).
  * `theme` (string): Chủ đề chính của ngày du lịch.
  * `activities` (array of objects): Các hoạt động chi tiết trong ngày, gồm các trường:
    * `time` (string): Khung giờ hoạt động.
    * `start_time` (string): Giờ bắt đầu hoạt động.
    * `duration_minutes` (int): Khoảng thời gian kéo dài (phút).
    * `place_name` (string): Tên địa điểm tham quan/ăn uống.
    * `category` (string): Phân loại danh mục (`restaurant` | `attraction` | `accommodation` | `activity`).
    * `estimated_cost` (float): Chi phí dự kiến của hoạt động (VNĐ).
    * `description` (string): Mô tả trải nghiệm chi tiết.

#### Ví dụ Response mẫu thành công:
```json
{
  "destination": "Đà Nẵng",
  "duration_days": 1,
  "estimated_total_cost": 800000.0,
  "summary": "Hành trình khám phá thiên nhiên và thưởng thức ẩm thực đặc trưng Đà Nẵng.",
  "itinerary": [
    {
      "day": 1,
      "theme": "Khám phá Sơn Trà và Ẩm thực Biển",
      "activities": [
        {
          "time": "08:00 - 09:30",
          "start_time": "08:00",
          "duration_minutes": 90,
          "place_name": "Bán đảo Sơn Trà",
          "category": "attraction",
          "estimated_cost": 0.0,
          "description": "Tham quan ngắm cảnh buổi sáng mát mẻ tại đỉnh Sơn Trà."
        },
        {
          "time": "12:00 - 13:30",
          "start_time": "12:00",
          "duration_minutes": 90,
          "place_name": "Nhà hàng hải sản Bé Mặn",
          "category": "restaurant",
          "estimated_cost": 500000.0,
          "description": "Ăn trưa hải sản ngon rẻ bên bờ biển."
        }
      ]
    }
  ]
}
```

### Lệnh cURL để test nhanh
```bash
curl -X POST "http://127.0.0.1:8000/ai/generate-itinerary" \
     -H "Content-Type: application/json" \
     -d "{\"destination\": \"Nha Trang\", \"duration_days\": 2, \"budget\": 3000000, \"travel_style\": \"khám phá\", \"traveler_count\": 2, \"preferences\": [\"hải sản\"]}"
```
