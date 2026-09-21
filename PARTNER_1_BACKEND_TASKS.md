# Công việc Partner 1: Backend lõi, xác thực, Trip và Security

## Mục tiêu bàn giao

Partner 1 chịu trách nhiệm để người dùng có thể đăng ký, đăng nhập, tạo và quản lý chuyến đi một cách an toàn. Khi bàn giao, các API phải chạy được trong Docker, có kiểm tra quyền owner/collaborator và có test cho các business rule quan trọng.

## Phạm vi phụ trách

Partner 1 là owner duy nhất của backend core, authentication, trip management và security. Partner 1 không phụ trách AI, Weather, Budget, Collaboration, Notification hoặc Runtime.

Requirement:

- `FR-AUTH-01` Register Account
- `FR-AUTH-02` Logi
- `FR-AUTH-03` OAuth Login backend
- `FR-AUTH-04` Manage Profile & Preferences backend
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

## File ownership

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

## Cong viec can lam

### Authentication

- Register account.
- Kiem tra email unique.
- Kiem tra password policy: toi thieu 8 ky tu, 1 chu hoa, 1 chu so.
- Hash password bang BCrypt.
- Login bang email/password.
- Tu choi account inactive/locked.
- OAuth backend: Google/Facebook identity association, khong tao duplicate user.
- Forgot password.
- Reset token het han sau 30 phut va chi dung mot lan.
- Gioi han toi da 3 password reset request trong 1 gio.
- Password moi khong duoc trung password hien tai.
- Invalidate active session/refresh token sau khi reset password.
- Chuyen user sang onboarding sau register.

### Profile va preferences

- Cap nhat full name.
- Cap nhat avatar.
- Cap nhat budget range.
- Cap nhat preferred style.
- Cap nhat favorite categories.
- Cap nhat preferred region.
- Cho phep skip onboarding preferences neu requirement cho phep.

### Trip management

- Tao trip voi destination, start date, end date/duration, planning mode va traveler count.
- Validate end date >= start date.
- Validate traveler count > 0.
- Validate budget khong am.
- Chi co mot owner cho moi trip.
- Owner duoc create/edit/delete/manage collaboration.
- Collaborator chi duoc view/chat/runtime/navigation.
- Collaborator khong duoc sua itinerary, xoa trip hoac sua permission.
- Hoan thien view my trips theo owner/joined/completed.
- Hoan thien soft delete.
- Trip da xoa khong xuat hien trong active views.

### Trip lifecycle

Implement cac transition:

```text
DRAFT -> PLANNED / CANCELLED
PLANNED -> DRAFT / ACTIVE / CANCELLED
ACTIVE -> COMPLETED / CANCELLED
COMPLETED -> ARCHIVED
```

Can dam bao:

- Transition khong hop le bi tu choi.
- Auto transition theo start date/end date neu co.
- `COMPLETED` va `CANCELLED` la read-only.
- Khi CANCELLED, active invitation bi revoke va collaboration access bi khoa.

### Security

- Protected API yeu cau JWT hop le.
- JWT invalid, expired, revoked khong lam ung dung tra HTTP 500.
- Authorization phai kiem tra ca authentication va ownership/membership.
- User khong duoc xem private trip cua user khac.
- Password khong duoc luu plaintext.
- Khong commit `.env`, API key, password hoac JWT secret.

## File khong duoc tu y sua

Partner 1 khong sua cac file sau neu chua thong bao Partner 2:

```text
backend/src/main/java/com/travelmate/backend/service/impl/WeatherApiClientServiceImpl.java
backend/src/main/java/com/travelmate/backend/service/impl/WeatherSnapshotServiceimpl.java
backend/src/main/java/com/travelmate/backend/controller/WeatherController.java
backend/src/main/java/com/travelmate/backend/controller/WeatherSnapshotController.java
backend/src/main/java/com/travelmate/backend/controller/WeatherAlertController.java
backend/src/main/java/com/travelmate/backend/service/impl/ExpenseServiceImpl.java
backend/src/main/java/com/travelmate/backend/service/impl/NotificationServiceImpl.java
backend/src/main/java/com/travelmate/backend/service/impl/SharedTripInviteServiceImpl.java
backend/src/main/java/com/travelmate/backend/service/impl/TripInsightServiceImpl.java
ai-service-lc/**
```

## File dung chung

### `TripServiceImpl.java`

Partner 1 la owner duy nhat. Neu Partner 2 can hook weather hoac module khac khi tao/cap nhat trip:

1. Partner 2 ghi ro method/API can goi.
2. Partner 1 them integration vao file nay.
3. Hai nguoi khong sua file nay dong thoi.

### `SecurityConfig.java`

Partner 1 la owner. Partner 2 gui danh sach endpoint va yeu cau access; Partner 1 la nguoi them rule security.

### `pom.xml`

Chi thay doi sau khi thong bao Partner 2. Moi dependency phai co ly do ro rang.

## Test bat buoc

- Register thanh cong.
- Duplicate email bi tu choi.
- Password sai policy bi tu choi.
- Login sai credential bi tu choi.
- Login account inactive bi tu choi.
- JWT invalid/expired/revoked.
- Forgot/reset password.
- Reset token expired/used twice.
- Reset password rate limit.
- Owner/collaborator permission.
- End date/start date validation.
- Traveler count validation.
- Invalid lifecycle transition.
- Completed/Cancelled read-only.
- Soft delete trip.

## Hướng dẫn thực hiện chi tiết

### Thứ tự triển khai

1. Kiểm tra entity, repository và DTO hiện có.
2. Hoàn thiện register/login/logout và JWT.
3. Hoàn thiện profile và travel preferences.
4. Hoàn thiện create/update/view/delete trip.
5. Hoàn thiện kiểm tra owner/collaborator.
6. Hoàn thiện trip lifecycle.
7. Viết unit test và integration test.
8. Bàn giao API contract cho Partner 2.

### Register và Login

- Chuẩn hóa email trước khi kiểm tra trùng, tối thiểu phải trim và xử lý nhất quán chữ hoa/chữ thường.
- Không trả password hoặc password hash trong response.
- Password phải có tối thiểu 8 ký tự, ít nhất 1 chữ hoa và 1 chữ số.
- Email đã tồn tại phải trả lỗi rõ ràng, không tạo user thứ hai.
- Account inactive hoặc locked không được phát hành JWT.
- JWT phải chứa subject/user id cần thiết và có thời hạn.

### Forgot Password

- Hash reset token trước khi lưu database.
- Token hết hạn sau 30 phút và chỉ được sử dụng một lần.
- Giới hạn tối đa 3 yêu cầu trong một giờ cho cùng user.
- Không cho password mới trùng password hiện tại.
- Sau khi reset thành công, revoke các session/token đang hoạt động.

### Trip và quyền truy cập

- Mỗi trip chỉ có một owner là người tạo.
- Mọi thao tác update/delete phải lấy user hiện tại từ SecurityContext, không tin `ownerId` do client gửi lên.
- Collaborator chỉ được xem trip, chat và runtime; không được sửa itinerary, xóa trip hoặc quản lý permission.
- Trip đã soft-delete không được trả trong danh sách active và không được truy cập bởi user thông thường.
- Các API đọc private trip phải kiểm tra membership, không chỉ kiểm tra JWT.

### Trip lifecycle

Chỉ cho phép các chuyển trạng thái sau:

```text
DRAFT -> PLANNED / CANCELLED
PLANNED -> DRAFT / ACTIVE / CANCELLED
ACTIVE -> COMPLETED / CANCELLED
COMPLETED -> ARCHIVED
```

Transition không nằm trong danh sách phải bị từ chối. Trip `COMPLETED` và `CANCELLED` phải read-only. Khi chuyển sang `CANCELLED`, cần gọi cơ chế revoke invitation/collaboration do Partner 2 phụ trách thông qua interface hoặc service contract, không tự sửa file của Partner 2.

### Tiêu chí hoàn thành

- API register/login trả đúng status code và response contract.
- Không thể đăng ký email trùng.
- Password sai policy bị từ chối.
- User ngoài trip không đọc được dữ liệu private.
- Collaborator không thể thực hiện thao tác của owner.
- Invalid lifecycle transition bị từ chối.
- Soft delete không làm mất dữ liệu persistence.
- Docker build và test backend chạy thành công.

### Bàn giao cho Partner 2

Gửi cho Partner 2 một danh sách gồm:

- Endpoint và HTTP method.
- Request/response JSON.
- Status code thành công và lỗi.
- API nào yêu cầu JWT.
- Cách truyền `userId`, `tripId` và owner/collaborator.
- Các thay đổi entity hoặc database mà Partner 2 cần biết.

Không tự ý đổi tên field hoặc endpoint sau khi đã bàn giao contract. Nếu bắt buộc đổi, phải thông báo trước và cập nhật tài liệu API.

## Lenh kiem tra

```cmd
cd /d A:\TravelMate\backend
docker compose up -d --build backend
docker compose logs --tail=200 backend
```

Khong dung JDK 25 de compile truc tiep neu Lombok khong tuong thich. Dockerfile cua project dung Java 21.

## Checklist truoc khi merge

- [ ] Auth test pass.
- [ ] Password policy pass.
- [ ] JWT/revocation test pass.
- [ ] Owner/collaborator authorization pass.
- [ ] Trip validation pass.
- [ ] Lifecycle transition pass.
- [ ] Soft delete pass.
- [ ] Docker build pass.
- [ ] Khong sua file ownership cua Partner 2.
- [ ] Khong commit `.env` hoac secret.
