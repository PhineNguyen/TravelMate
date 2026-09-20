# Phan cong cong viec Backend TravelMate

Tai lieu nay chia cong viec backend cho hai partner. Partner 2 da phu trach AI service, vi vay giu ownership cua toan bo `ai-service-lc` va khong nhan them cac file core de tranh conflict.

## Nguyen tac lam viec

- Moi file chi co mot owner chinh.
- Khong sua chung `TripServiceImpl.java`, `SecurityConfig.java`, `pom.xml` hoac file cau hinh trong cung thoi diem.
- Hai partner thong nhat API contract truoc khi viet frontend.
- Khong commit file `.env`, API key, password hoac JWT secret.
- Moi thay doi phai co test hoac lenh kiem tra tuong ung.
- Backend build bang Docker, su dung Java 21 trong `Dockerfile`.

## Partner 1: Core Backend, Authentication, Trip va Security

### Pham vi chinh

Partner 1 phu trach cac requirement:

- `FR-AUTH-01` Register Account
- `FR-AUTH-02` Login
- `FR-AUTH-03` OAuth Login backend
- `FR-AUTH-04` Profile & Preferences backend
- `FR-AUTH-05` Forgot Password
- `FR-AUTH-06` Setup Travel Preferences backend
- `FR-TRIP-01` Create Trip
- `FR-TRIP-06` Adjust Itinerary
- `FR-TRIP-07` Save Trip
- `FR-TRIP-08` View Trip
- `FR-TRIP-09` Delete Trip
- `FR-TRIP-10` View My Trips
- `FR-TRIP-11` Trip Lifecycle
- `BR-SEC-01` den `BR-SEC-06`
- `BR-TRIP-01`, `BR-TRIP-03`, `BR-TRIP-06`
- `BR-LIFE-01` den `BR-LIFE-04`

### File ownership

```text
backend/src/main/java/com/travelmate/backend/controller/AuthController.java
backend/src/main/java/com/travelmate/backend/controller/TripController.java
backend/src/main/java/com/travelmate/backend/controller/UserController.java
backend/src/main/java/com/travelmate/backend/controller/UserPreferenceController.java
backend/src/main/java/com/travelmate/backend/service/AuthService.java
backend/src/main/java/com/travelmate/backend/service/TripService.java
backend/src/main/java/com/travelmate/backend/service/impl/AuthServiceImpl.java
backend/src/main/java/com/travelmate/backend/service/impl/TripServiceImpl.java
backend/src/main/java/com/travelmate/backend/service/impl/UserServiceImpl.java
backend/src/main/java/com/travelmate/backend/entity/User.java
backend/src/main/java/com/travelmate/backend/entity/UserPreference.java
backend/src/main/java/com/travelmate/backend/entity/OAuthAccount.java
backend/src/main/java/com/travelmate/backend/entity/PasswordResetToken.java
backend/src/main/java/com/travelmate/backend/entity/Trip.java
backend/src/main/java/com/travelmate/backend/security/**
backend/src/main/java/com/travelmate/backend/config/SecurityConfig.java
backend/src/main/java/com/travelmate/backend/dto/request/TripRequest.java
backend/src/main/java/com/travelmate/backend/dto/request/TripUpdateRequest.java
backend/src/main/java/com/travelmate/backend/dto/response/TripResponse.java
backend/src/main/java/com/travelmate/backend/repository/TripRepository.java
```

### Cong viec cu the

1. Hoan thien register/login/logout va password reset.
2. Kiem tra password policy: it nhat 8 ky tu, 1 chu hoa, 1 chu so.
3. Dam bao email unique va password duoc hash bang BCrypt.
4. Kiem tra inactive/locked account.
5. Kiem tra JWT invalid, expired va revoked.
6. Hoan thien owner/collaborator authorization cho trip.
7. Bo sung validation `startDate`, `endDate` hoac quy uoc ro `duration`.
8. Dam bao `End Date >= Start Date` va traveler count `> 0`.
9. Hoan thien soft delete, khong tra trip da bi xoa trong active views.
10. Hoan thien cac transition trip lifecycle.
11. Dam bao `COMPLETED` va `CANCELLED` la read-only.
12. Viet test cho auth, JWT, ownership, lifecycle va soft delete.

### Khong sua

Partner 1 khong sua cac file do Partner 2 lam owner, tru khi da thong bao va thong nhat:

```text
WeatherApiClientServiceImpl.java
WeatherSnapshotServiceimpl.java
WeatherController.java
WeatherSnapshotController.java
WeatherAlertController.java
ExpenseServiceImpl.java
NotificationServiceImpl.java
SharedTripInviteServiceImpl.java
TripInsightServiceImpl.java
ai-service-lc/**
```

## Partner 2: AI Service, Weather, Budget, Collaboration, Notification va Runtime

Partner 2 giu ownership cua AI service da lam va phu trach cac module backend doc lap con lai.

### Pham vi chinh

- `FR-TRIP-03` AI Planning
- `FR-TRIP-04` Route Optimization
- `FR-TRIP-05` Weather-Aware Planning
- `FR-BUDGET-01` den `FR-BUDGET-04`
- `FR-COLLAB-01` den `FR-COLLAB-06`
- `FR-RUNTIME-01` den `FR-RUNTIME-04`
- `FR-NOTIF-01` den `FR-NOTIF-04`
- `FR-RUNTIME-05` Offline data contract backend neu can

### File ownership: AI service

```text
ai-service-lc/app/**
ai-service-lc/requirements.txt
ai-service-lc/Dockerfile
ai-service-lc/docker-compose.yml
```

Partner 2 phu trach:

- `POST /ai/generate-itinerary`
- `POST /ai/optimize-route`
- `POST /ai/adjust-weather`
- Validate input.
- Timeout va fallback.
- Xu ly AI unavailable.
- Xu ly empty result.
- Response schema on dinh.

### File ownership: Weather

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

Cong viec:

1. Goi OpenWeatherMap bang city hoac latitude/longitude.
2. Group forecast theo ngay.
3. Luu `temperatureHigh`, `temperatureLow`, humidity, wind speed va rain probability.
4. Luu rain probability theo quy uoc `0 - 100`.
5. Tao endpoint current GPS va forecast theo trip.
6. Tao weather alert, tranh duplicate alert chua resolve.
7. Khong de Weather API failure lam application crash.
8. Viet test cho mapping, forecast aggregation, alert threshold va provider failure.

### File ownership: Budget va Analytics

```text
backend/src/main/java/com/travelmate/backend/controller/ExpenseController.java
backend/src/main/java/com/travelmate/backend/controller/TripInsightController.java
backend/src/main/java/com/travelmate/backend/service/impl/ExpenseServiceImpl.java
backend/src/main/java/com/travelmate/backend/service/impl/TripInsightServiceImpl.java
backend/src/main/java/com/travelmate/backend/entity/Expense.java
backend/src/main/java/com/travelmate/backend/entity/AnalyticsSnapshot.java
backend/src/main/java/com/travelmate/backend/repository/ExpenseRepository.java
```

Cong viec:

- Amount phai `> 0`.
- Expense chi duoc tao cho trip user co quyen truy cap.
- Tinh estimated cost va actual spending.
- Tao warning khi vuot budget hoac dat 90% budget.
- Warning khong block planning, expense creation hoac trip continuation.
- Tra analytics dung total trips, total spent, average budget, category va duration.

### File ownership: Collaboration va Chat

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

Cong viec:

- Invite code dung secure random.
- Invitation het han sau 72 gio.
- Chi co mot invitation `PENDING` cho mot user/trip.
- Validate state transition.
- Owner duoc remove collaborator.
- Collaborator duoc leave, owner khong duoc leave trip cua minh.
- Chat chi cho user thuoc trip.
- Empty message bi tu choi.
- Remove/leave phai revoke chat access.

### File ownership: Notification

```text
backend/src/main/java/com/travelmate/backend/controller/NotificationController.java
backend/src/main/java/com/travelmate/backend/service/impl/NotificationServiceImpl.java
backend/src/main/java/com/travelmate/backend/entity/Notification.java
backend/src/main/java/com/travelmate/backend/repository/NotificationRepository.java
```

Cong viec:

- Tao notification cho `BUDGET_WARNING`.
- Tao notification cho `WEATHER_ALERT`.
- Tao notification cho invitation/collaboration update.
- User chi xem, sua, xoa notification cua minh.
- Ho tro mark single, mark all va delete read notifications.
- Sap xep theo `createdAt DESC`.

### File ownership: Runtime va Route

```text
backend/src/main/java/com/travelmate/backend/service/impl/TripInsightServiceImpl.java
backend/src/main/java/com/travelmate/backend/controller/TripInsightController.java
backend/src/main/java/com/travelmate/backend/entity/RoutePlan.java
backend/src/main/java/com/travelmate/backend/entity/RouteNode.java
backend/src/main/java/com/travelmate/backend/repository/RoutePlanRepository.java
backend/src/main/java/com/travelmate/backend/repository/RouteNodeRepository.java
```

Cong viec:

- Chi cho runtime khi trip `ACTIVE`.
- Tinh current destination, completed items va upcoming items.
- Tra next destination.
- Tra route recommendation.
- Khong dung text progress hard-code.

## File dung chung va cach tranh conflict

### `TripServiceImpl.java`

Partner 1 la owner duy nhat. Neu Partner 2 can weather khi tao/cap nhat trip:

1. Partner 2 tao interface/service method rieng va ghi ro API can goi.
2. Partner 1 tu them mot dong integration vao `TripServiceImpl.java`.
3. Khong tu sua cung file tren hai branch.

### `SecurityConfig.java`

Partner 1 la owner. Partner 2 gui danh sach endpoint can `permitAll` hoac authenticated. Partner 1 la nguoi them rule.

### `TripInsightServiceImpl.java`

Partner 2 la owner. Neu Partner 1 can them du lieu trip, dung cac repository/service method hien co va khong sua truc tiep file nay.

### `pom.xml` va cau hinh

Chi thay doi sau khi thong bao partner con lai. Moi dependency phai ghi ro ly do trong commit.

## API contract can thong nhat

### Weather current GPS

```text
GET /api/weather/current?latitude=10.8231&longitude=106.6297
```

### Weather forecast

```text
GET /api/weather-snapshots/trip/{tripId}/forecast
```

Response field:

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

### AI

```text
POST /ai/generate-itinerary
POST /ai/optimize-route
POST /ai/adjust-weather
```

Moi endpoint can ghi ro:

- Request body.
- Response body.
- Status code.
- Error body.
- Yeu cau JWT hay khong.

## Quy trinh branch va merge

```text
partner1/core-auth-trip
partner2/ai-weather-budget-collab
```

Commit mau:

```text
feat(auth): enforce password policy
feat(trip): validate lifecycle transition
feat(weather): aggregate daily forecast
feat(budget): add budget warning
feat(collab): enforce invitation expiration
feat(notification): deliver weather alert
```

Thu tu merge:

1. Partner 1 merge model User/Trip va API contract chung.
2. Partner 2 merge AI service doc lap.
3. Partner 2 merge Weather, Budget, Collaboration, Notification va Runtime.
4. Partner 1 review authorization tren endpoint Partner 2.
5. Hai partner build Docker va chay integration tests.
6. Chay frontend voi API that.

## Checklist truoc khi merge

### Partner 1

- [ ] Auth test pass.
- [ ] Password policy pass.
- [ ] JWT/revocation test pass.
- [ ] Owner/collaborator permission pass.
- [ ] Trip date/traveler validation pass.
- [ ] Lifecycle transition pass.
- [ ] Soft delete pass.

### Partner 2

- [ ] AI endpoint co timeout/fallback.
- [ ] Weather forecast co high/low theo ngay.
- [ ] GPS weather khong lam lo API key.
- [ ] Weather failure graceful.
- [ ] Budget warning dung nguong.
- [ ] Invitation expire sau 72 gio.
- [ ] Chat check membership.
- [ ] Notification check ownership.
- [ ] Runtime khong con hard-code.

### Ca hai

- [ ] Khong commit `.env`.
- [ ] `docker compose build` pass.
- [ ] API contract khong bi doi ngam.
- [ ] Khong co conflict trong file dung chung.
- [ ] Integration test pass.
