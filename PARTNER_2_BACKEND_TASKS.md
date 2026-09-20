# Công việc Partner 2: AI Service, Weather, Budget, Collaboration, Notification và Runtime

## Mục tiêu bàn giao

Partner 2 chịu trách nhiệm toàn bộ AI service hiện có và các module backend còn lại. Mục tiêu là cung cấp API ổn định cho frontend, xử lý lỗi của dịch vụ bên ngoài an toàn và không làm thay đổi trái phép phần Authentication/Trip core của Partner 1.

## Phạm vi phụ trách

Partner 2 đã phụ trách AI service, tiếp tục giữ ownership của AI service và phụ trách các module backend còn lại. Partner 2 không tự ý sửa `TripServiceImpl.java`, `SecurityConfig.java`, entity Trip hoặc các API authentication.

Requirement:

- `FR-TRIP-03` AI Planning
- `FR-TRIP-04` Route Optimization
- `FR-TRIP-05` Weather-Aware Planning
- `FR-BUDGET-01` den `FR-BUDGET-04`
- `FR-COLLAB-01` den `FR-COLLAB-06`
- `FR-RUNTIME-01` den `FR-RUNTIME-04`
- `FR-NOTIF-01` den `FR-NOTIF-04`
- `FR-RUNTIME-05` offline data contract backend neu can

## File ownership

### AI service

```text
ai-service-lc/app/**
ai-service-lc/requirements.txt
ai-service-lc/Dockerfile
ai-service-lc/docker-compose.yml
```

### Weather

```text
backend/src/main/java/com/travelmate/backend/controller/WeatherController.java
backend/src/main/java/com/travelmate/backend/controller/WeatherSnapshotController.java
backend/src/main/java/com/travelmate/backend/controller/WeatherAlertController.java
backend/src/main/java/com/travelmate/backend/service/WeatherApiClientService.java
backend/src/main/java/com/travelmate/backend/service/WeatherSnapshotService.java
backend/src/main/java/com/travelmate/backend/service/WeatherAlertService.java
backend/src/main/java/com/travelmate/backend/service/impl/WeatherApiClientServiceImpl.java
backend/src/main/java/com/travelmate/backend/service/impl/WeatherSnapshotServiceimpl.java
backend/src/main/java/com/travelmate/backend/service/impl/WeatherAlertServiceImpl.java
backend/src/main/java/com/travelmate/backend/entity/WeatherSnapshot.java
backend/src/main/java/com/travelmate/backend/entity/WeatherAlert.java
backend/src/main/java/com/travelmate/backend/dto/WeatherSnapshotDTO.java
backend/src/main/java/com/travelmate/backend/dto/WeatherForecastDTO.java
backend/src/main/java/com/travelmate/backend/dto/CurrentWeatherDTO.java
backend/src/main/java/com/travelmate/backend/repository/WeatherSnapshotRepository.java
backend/src/main/java/com/travelmate/backend/repository/WeatherAlertRepository.java
```

### Budget va Analytics

```text
backend/src/main/java/com/travelmate/backend/controller/ExpenseController.java
backend/src/main/java/com/travelmate/backend/controller/TripInsightController.java
backend/src/main/java/com/travelmate/backend/service/impl/ExpenseServiceImpl.java
backend/src/main/java/com/travelmate/backend/service/impl/TripInsightServiceImpl.java
backend/src/main/java/com/travelmate/backend/entity/Expense.java
backend/src/main/java/com/travelmate/backend/entity/AnalyticsSnapshot.java
backend/src/main/java/com/travelmate/backend/repository/ExpenseRepository.java
```

### Collaboration va Chat

```text
backend/src/main/java/com/travelmate/backend/controller/SharedTripInviteController.java
backend/src/main/java/com/travelmate/backend/controller/TripParticipantController.java
backend/src/main/java/com/travelmate/backend/controller/ChatRoomController.java
backend/src/main/java/com/travelmate/backend/controller/MessageController.java
backend/src/main/java/com/travelmate/backend/service/impl/SharedTripInviteServiceImpl.java
backend/src/main/java/com/travelmate/backend/service/impl/TripParticipantServiceImpl.java
backend/src/main/java/com/travelmate/backend/service/impl/ChatRoomServiceImpl.java
backend/src/main/java/com/travelmate/backend/service/impl/MessageServiceImpl.java
backend/src/main/java/com/travelmate/backend/entity/SharedTripInvite.java
backend/src/main/java/com/travelmate/backend/entity/TripParticipant.java
backend/src/main/java/com/travelmate/backend/entity/ChatRoom.java
backend/src/main/java/com/travelmate/backend/entity/Message.java
```

### Notification

```text
backend/src/main/java/com/travelmate/backend/controller/NotificationController.java
backend/src/main/java/com/travelmate/backend/service/impl/NotificationServiceImpl.java
backend/src/main/java/com/travelmate/backend/entity/Notification.java
backend/src/main/java/com/travelmate/backend/repository/NotificationRepository.java
```

### Runtime va Route

```text
backend/src/main/java/com/travelmate/backend/service/impl/TripInsightServiceImpl.java
backend/src/main/java/com/travelmate/backend/controller/TripInsightController.java
backend/src/main/java/com/travelmate/backend/entity/RoutePlan.java
backend/src/main/java/com/travelmate/backend/entity/RouteNode.java
backend/src/main/java/com/travelmate/backend/repository/RoutePlanRepository.java
backend/src/main/java/com/travelmate/backend/repository/RouteNodeRepository.java
```

## Cong viec can lam

### AI service

- Duy tri va hoan thien `POST /ai/generate-itinerary`.
- Hoan thien `POST /ai/optimize-route`.
- Hoan thien `POST /ai/adjust-weather`.
- Validate input thieu destination/duration.
- Xu ly timeout tren 10 giay.
- Xu ly AI unavailable.
- Xu ly empty result.
- Tra response schema on dinh.
- Khong de AI failure lam backend crash.

### Weather

- Goi OpenWeatherMap bang city hoac latitude/longitude.
- Tao endpoint current GPS.
- Group forecast theo ngay.
- Luu `temperatureHigh`, `temperatureLow`, humidity, wind speed.
- Luu `rainProbability` theo quy uoc `0 - 100`.
- Tra forecast theo `tripId`.
- Tao weather alert khi vuot nguong.
- Tranh duplicate alert chua resolve.
- Xu ly provider timeout/error graceful.
- Hoan thien weather-aware planning:
  - Lay forecast theo ngay itinerary.
  - Xac dinh activity outdoor.
  - Danh gia rain/wind/condition.
  - Tao adjustment suggestion.
  - Cho phep frontend hien thi suggestion.

### Budget va Analytics

- Expense amount phai > 0.
- Expense chi duoc tao cho trip user co quyen.
- Hoan thien add/edit/delete expense.
- Tinh estimated cost tu accommodation, food, transportation, activity.
- Tinh actual spending.
- Tao warning khi estimated cost vuot configured budget.
- Tao warning khi actual spending >= 90% budget.
- Warning khong block planning, expense creation hoac trip continuation.
- Tra analytics: total trips, total spent, average budget, category, duration.

### Collaboration va Chat

- Share trip bang link/invite code.
- Invite code dung secure random.
- Invitation het han sau 72 gio.
- Chi co mot invitation PENDING cho mot user/trip.
- Validate invitation state transitions.
- Owner duoc xem va remove collaborator.
- Collaborator duoc leave trip.
- Owner khong duoc leave trip cua minh.
- Remove/leave phai revoke trip access va chat access.
- Chat chi cho thanh vien cua trip.
- Empty message bi tu choi.
- MVP chi ho tro text message.

### Notification

- Tao notification cho `BUDGET_WARNING`.
- Tao notification cho `WEATHER_ALERT`.
- Tao notification cho invitation update.
- Tao notification cho collaboration change.
- User chi xem/update/delete notification cua minh.
- Ho tro mark single va mark all as read.
- Ho tro delete single va delete read notifications.
- Sap xep theo `createdAt DESC`.

### Runtime va route

- Chi cho runtime khi trip `ACTIVE`.
- Tinh current destination.
- Tinh completed items va upcoming items.
- Tra next destination.
- Tra route recommendation.
- Khong dung progress hard-code.
- Google Maps handoff dung external navigation, khong implement internal navigation engine.

## File khong duoc tu y sua

Partner 2 khong sua cac file sau neu chua thong bao Partner 1:

```text
backend/src/main/java/com/travelmate/backend/service/impl/TripServiceImpl.java
backend/src/main/java/com/travelmate/backend/config/SecurityConfig.java
backend/src/main/java/com/travelmate/backend/security/**
backend/src/main/java/com/travelmate/backend/entity/Trip.java
backend/src/main/java/com/travelmate/backend/dto/request/TripRequest.java
backend/src/main/java/com/travelmate/backend/dto/request/TripUpdateRequest.java
backend/src/main/java/com/travelmate/backend/dto/response/TripResponse.java
backend/src/main/java/com/travelmate/backend/repository/TripRepository.java
backend/src/main/java/com/travelmate/backend/service/impl/AuthServiceImpl.java
```

## File dung chung

### `TripServiceImpl.java`

Partner 1 la owner duy nhat. Neu can trigger weather sau khi tao/cap nhat trip:

1. Partner 2 ghi ro method `fetchAndProcessWeatherData(...)` can goi.
2. Partner 1 them integration vao `TripServiceImpl.java`.
3. Partner 2 khong sua truc tiep file nay tren branch cua minh.

### `SecurityConfig.java`

Partner 2 gui danh sach endpoint can public/authenticated cho Partner 1. Partner 1 la nguoi cap nhat security rule.

### `pom.xml`

Khong tu y them dependency. Thong bao Partner 1 truoc khi thay doi.

## API contract can duy tri

```text
GET /api/weather/current?latitude={lat}&longitude={lon}
GET /api/weather-snapshots/trip/{tripId}
GET /api/weather-snapshots/trip/{tripId}/forecast
GET /api/weather-alerts/trip/{tripId}
POST /ai/generate-itinerary
POST /ai/optimize-route
POST /ai/adjust-weather
```

Weather forecast response can co:

```text
date
temperatureHigh
temperatureLow
condition
humidity
windSpeed
rainProbability
isOutdoorSafe
```

## Test bat buoc

- AI timeout/unavailable/empty result.
- Forecast aggregation theo ngay.
- Temperature high/low.
- Humidity/wind/rain mapping.
- GPS latitude/longitude validation.
- Weather provider failure.
- Weather alert threshold.
- Khong tao duplicate unresolved alert.
- Expense amount > 0.
- Expense ownership.
- Budget warning 90%.
- Invitation expiration 72 gio.
- Invitation state transition.
- Chat membership va empty message.
- Notification ownership/read/delete.
- Runtime chi cho ACTIVE trip.
- Next destination.

## Hướng dẫn thực hiện chi tiết

### Thứ tự triển khai

1. Ổn định AI service và ghi rõ request/response.
2. Hoàn thiện Weather snapshot, forecast và GPS.
3. Hoàn thiện Expense, Budget và Analytics.
4. Hoàn thiện Share Trip, Invitation và Chat.
5. Hoàn thiện Notification.
6. Hoàn thiện Runtime và Route summary.
7. Viết test cho từng module.
8. Bàn giao API cho frontend và Partner 1 review security.

### AI Service

- Giữ nguyên các endpoint đã có nếu không cần thay đổi contract.
- Validate destination, duration và các trường bắt buộc trước khi gọi model.
- Đặt timeout rõ ràng, xử lý timeout, provider unavailable và kết quả rỗng.
- Response phải có schema ổn định để backend/frontend parse được.
- Không đưa API key của model vào response hoặc log.

### Weather

- Current weather GPS nhận `latitude` trong khoảng `-90..90` và `longitude` trong khoảng `-180..180`.
- API key OpenWeatherMap chỉ nằm ở backend hoặc Docker environment.
- Forecast 3 giờ phải được nhóm theo `LocalDate`.
- Mỗi ngày lưu `temperatureHigh`, `temperatureLow`, humidity, wind speed và rain probability.
- Quy ước `rainProbability` trong database và response là `0..100`; OpenWeatherMap `pop` dạng `0..1` phải nhân 100 trước khi lưu.
- Khi cập nhật forecast cùng trip/ngày, phải update bản ghi cũ thay vì tạo duplicate.
- Weather provider lỗi phải trả lỗi có kiểm soát hoặc dùng dữ liệu cache; không làm request tạo trip bị crash ngoài chủ ý.
- Alert mưa/bão phải chống duplicate khi alert cũ chưa resolve.

### Budget và Analytics

- Expense amount phải lớn hơn 0.
- Kiểm tra quyền user trên trip trước khi tạo, sửa hoặc xóa expense.
- Warning được tạo khi estimated cost vượt budget hoặc actual spending đạt từ 90% budget.
- Warning chỉ thông báo, không được chặn việc thêm expense hoặc tiếp tục trip.
- Analytics phải tính từ database, không dùng số liệu hard-code.

### Collaboration và Chat

- Invitation mặc định hết hạn sau 72 giờ.
- Invite code phải tạo bằng nguồn random an toàn, không dùng mã dễ đoán từ title.
- Chỉ cho phép một invitation `PENDING` cho cùng user/trip.
- Kiểm tra transition `PENDING -> ACCEPTED/REJECTED/REVOKED/EXPIRED`.
- Owner được quản lý collaborator; collaborator được leave nhưng owner không được leave trip của mình.
- Chat phải kiểm tra user thuộc trip trước khi đọc hoặc gửi message.
- Từ chối message rỗng và chỉ nhận text trong phạm vi MVP.

### Notification

- Tạo notification cho budget warning, weather alert, invitation update và collaboration change.
- Notification phải gắn với đúng user nhận.
- User chỉ được xem, mark as read hoặc xóa notification của chính mình.
- Hỗ trợ mark một notification, mark tất cả và xóa notification đã đọc.
- Danh sách trả về theo `createdAt DESC`.
- Không tạo notification trùng khi cùng một weather alert được refresh nhiều lần.

### Runtime và Route

- Chỉ trả runtime summary khi trip ở trạng thái `ACTIVE`.
- Tính current destination, completed items, upcoming items và next destination từ itinerary thật.
- Route summary phải lấy từ route plan/node đã lưu.
- Không trả các giá trị demo như `Day 8 of 22` hoặc progress cố định.
- Google Maps là external handoff; backend chỉ cung cấp destination/route data cần thiết.

### Tiêu chí hoàn thành

- AI endpoint có validation, timeout và fallback.
- Weather endpoint có current GPS và forecast theo ngày.
- Forecast trả đúng high/low và không còn phụ thuộc dữ liệu mock.
- Budget, collaboration, notification và runtime lấy dữ liệu database thật.
- API ngoài lỗi không làm ứng dụng crash.
- Mọi API thao tác dữ liệu riêng tư đều được Partner 1 review authorization.
- Docker build, test module và API smoke test chạy thành công.

### Bàn giao cho frontend

Với mỗi endpoint, ghi rõ:

- URL và HTTP method.
- Request parameters/body.
- Response JSON.
- Status code.
- Error response.
- Có cần JWT hay không.
- Quy ước đơn vị: Celsius, `m/s`, phần trăm `0..100`.

Khi thay đổi response, phải cập nhật model Flutter và thông báo trước cho người phụ trách frontend.

## Lenh kiem tra

```cmd
cd /d A:\TravelMate\backend
docker compose up -d --build backend
docker compose logs --tail=200 backend
```

Neu test AI service:

```cmd
cd /d A:\TravelMate\ai-service-lc
python -m uvicorn app.main:app --reload --port 8000
```

## Checklist truoc khi merge

- [ ] AI endpoint co validation, timeout va fallback.
- [ ] Weather forecast co high/low theo ngay.
- [ ] GPS weather khong lam lo API key.
- [ ] Weather failure graceful.
- [ ] Budget warning dung nguong.
- [ ] Invitation expire sau 72 gio.
- [ ] Chat check membership.
- [ ] Notification check ownership.
- [ ] Runtime khong con hard-code.
- [ ] Test pass.
- [ ] Docker build pass.
- [ ] Khong sua file ownership cua Partner 1.
- [ ] Khong commit `.env` hoac secret.
