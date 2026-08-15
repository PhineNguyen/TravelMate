# Hướng Dẫn Sinh Lịch Trình Chuyến Đi Tự Động Bằng AI

Tài liệu này hướng dẫn chi tiết từng bước cách tạo một chuyến đi (`Trip`) cơ bản, sử dụng AI để tự động sinh lịch trình hoạt động chi tiết (`Itinerary`), và cách xem lại lịch trình chuyến đi của bạn trên **Swagger UI**.

---

## 🏗️ Quy Trình Tóm Tắt

```mermaid
graph TD
    A[Đăng nhập / Xác thực Token] --> B[POST /api/trips: Tạo chuyến đi cơ bản]
    B --> C[Lấy Trip ID vừa tạo]
    C --> D[POST /api/trips/{id}/generate-itinerary: Gọi AI tạo lịch trình]
    D --> E[Xem lại lịch trình chuyến đi của bạn]
```

---

## Bước 1: Chuẩn Bị Access Token & Xác Thực
Trước khi thực hiện các yêu cầu, bạn cần đăng nhập để lấy JWT Token và cấu hình trên Swagger UI:
1. Tham khảo **Bước 2** và **Bước 3** trong tài liệu [Hướng Dẫn Chat AI Swagger](file:///d:/TravelMate%20-%20mobile%20app%20project/TravelMate/backend/SWAGGER_AI_CHAT_GUIDE.md) để lấy `accessToken` và dán vào nút **Authorize** ở góc trên cùng bên phải giao diện Swagger UI.

---

## Bước 2: Tạo Bản Ghi Chuyến Đi Cơ Bản (Trip)
Chuyến đi cần được tạo trước trong CSDL để xác định các tham số nền tảng (Điểm đến, thời gian đi, ngân sách, số người đi).

1. Trên Swagger, tìm mục **`trip-controller`**.
2. Mở endpoint **`POST /api/trips`**.
3. Bấm **Try it out** và nhập thông tin chuyến đi của bạn.
   * *Ví dụ payload mẫu du lịch Đà Nẵng 3 ngày, ngân sách 5 triệu cho 2 người:*
   ```json
   {
     "destination": "Đà Nẵng",
     "startDate": "2026-08-20",
     "duration": 3,
     "travelerCount": 2,
     "totalBudget": 5000000.0,
     "planningMode": "AI",
     "ownerId": 6
   }
   ```
   *(Lưu ý: Đổi `ownerId` thành ID người dùng thực tế của bạn).*
4. Bấm **Execute**.
5. Trong phần Response Body trả về, hãy lưu lại giá trị **`id`** của chuyến đi (ví dụ: `12`).

---

## Bước 3: Kích Hoạt AI Tự Động Thiết Kế Lịch Trình
Ở bước này, hệ thống sẽ tự động ghép thông tin chuyến đi đã tạo ở Bước 2 cùng với các sở thích bạn truyền thêm để yêu cầu `ai-service` lên lịch trình chi tiết.

1. Tìm mục **`trip-controller`**.
2. Mở endpoint **`POST /api/trips/{id}/generate-itinerary`**.
3. Bấm **Try it out**.
4. Nhập ID chuyến đi ở Bước 2 vào ô **`id`** (ví dụ: `12`).
5. Trong ô **RequestBody (JSON)**, nhập phong cách và các sở thích cá nhân:
   ```json
   {
     "travelStyle": "ngon rẻ, trải nghiệm địa phương",
     "preferences": [
       "ẩm thực hải sản",
       "chụp ảnh check-in",
       "thích thiên nhiên"
     ]
   }
   ```
6. Bấm **Execute**.
7. **Kết quả**: Hệ thống xử lý mất khoảng 5-15 giây (tùy thuộc vào tốc độ phản hồi của mô hình Gemma2 trên máy của bạn) và trả về mã phản hồi **`200 OK`**. Lúc này, toàn bộ lịch trình chi tiết đã được AI tự sinh và lưu trực tiếp vào CSDL Java Backend.

---

## Bước 4: Xem Lại Thông Tin & Lịch Trình Chuyến Đi

Để xem lại chuyến đi và lịch trình do AI tạo ra, bạn thực hiện qua hai bước truy vấn sau:

### 1. Xem Thông Tin Tổng Quan Chuyến Đi
* Mở endpoint **`GET /api/trips/{id}`** trong **`trip-controller`**.
* Nhập ID chuyến đi của bạn (ví dụ: `12`) và bấm **Execute**.
* Response sẽ hiển thị thông tin tổng quan của chuyến đi: điểm đến, ngân sách, số ngày đi, trạng thái.

### 2. Xem Chi Tiết Lịch Trình Hoạt Động (Danh sách địa điểm & mốc thời gian)
Hiện tại, để xem danh sách hoạt động chi tiết của chuyến đi:
* Mở mục **`itinerary-item-controller`**.
* Mở endpoint **`GET /api/itinerary-items`** và bấm **Execute** (API này lấy toàn bộ các hoạt động lịch trình).
* Tìm các bản ghi có giá trị **`tripId`** khớp với ID chuyến đi của bạn (ví dụ: `12`). 
* Mỗi hoạt động lịch trình sẽ chứa:
  * `dayNumber`: Ngày thứ mấy trong hành trình (1, 2, 3).
  * `startTime`: Giờ bắt đầu hoạt động (ví dụ: `"08:00:00"`).
  * `duration`: Thời gian kéo dài bằng phút (ví dụ: `90`).
  * `note`: Mô tả chi tiết hoạt động do AI viết.
  * `costEstimate`: Ước tính chi phí của hoạt động đó (VNĐ).
  * `sourceType`: Được đánh dấu rõ là `"AI"`.
  * `placeId`: Liên kết tới thông tin địa điểm chi tiết trong bảng `places`.
