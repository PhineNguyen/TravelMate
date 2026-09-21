# Kiểm tra API TravelMate — 19/09/2026

Đối chiếu với bảng 38 endpoint được cung cấp trong yêu cầu. Phạm vi là API công khai của Java backend; các route nội bộ của Python AI service được giữ vì backend còn sử dụng.

## Kết luận

- Đã khớp đúng **38 method/path**. Test kiểm tra tập route thực tế của Spring, phát hiện cả endpoint thiếu và endpoint dư.
- Đã bỏ **22 method/path cũ ngoài bảng**, trong đó 4 đường dẫn được thay bằng đường dẫn theo chuyến đi/template. Không xóa các hàm service/repository nội bộ chỉ vì chúng không còn được expose qua HTTP.
- Có kiểm thử tích hợp MockMvc + Spring Security/JWT + database H2 thực; AI, email và OpenWeather được mock ở ranh giới dịch vụ ngoài.
- **Chưa thể kết luận sẵn sàng production**: còn các vấn đề Auth được liệt kê bên dưới. Đủ route không đồng nghĩa tất cả tích hợp ngoài đã được xác minh.

## Những thay đổi đã thực hiện

| Nhóm | Số API | Kết quả |
|---|---:|---|
| Auth | 6 | Giữ đủ route; logout thu hồi chính Bearer token trong header; các điểm còn thiếu nằm ở mục Auth bên dưới |
| User | 3 | Kiểm tra chủ tài khoản khi xóa; cascade dữ liệu chuyến đi khi xóa vĩnh viễn |
| User Preference | 3 | Giữ create/read/update và phân quyền sẵn có |
| Trip | 6 | Danh sách chỉ trả chuyến đi của người đăng nhập; sửa trạng thái soft-delete/restore; tạo itinerary theo AI hoặc template |
| Itinerary Item | 6 | Khai báo `reorder` còn thiếu trong interface; kiểm tra quyền sở hữu và dữ liệu reorder; chi tiết trả thêm `place` |
| Expense | 4 | Đổi danh sách sang `/trip/{tripId}`; kiểm tra quyền sở hữu; không cho đổi trip khi update |
| Place | 2 | Giữ GET/POST; GET hỗ trợ `?query=...` theo tên, chỉ trả địa điểm active |
| Trip Template / Template Item | 2 | Danh sách template; chi tiết theo template được sắp xếp ngày/vị trí |
| AI Assistant | 3 | Lịch sử theo trip trả danh sách conversation kèm `messages`; kiểm tra chủ sở hữu khi tạo/gửi/đọc |
| Trip Insight | 2 | Budget bỏ qua expense đã xóa; runtime thêm `nextItemId`, `googleMapsUrl` |
| Weather | 1 | Lấy tọa độ từ itinerary của trip, kiểm tra quyền trước khi gọi provider, không ghi thời tiết vào DB |

Các API ngoài 5 POST Auth công khai đều yêu cầu JWT. Swagger vẫn được truy cập công khai. Lỗi thiếu JWT trả 401; truy cập dữ liệu người khác trả 403; một số lỗi không tìm thấy cũ vẫn trả 400 theo service hiện tại.

## API cũ đã gỡ

| Nhóm | Method/path không còn được expose |
|---|---|
| Expense | `GET /api/expenses`, `GET /api/expenses/{id}`, `PUT /api/expenses/{id}/restore` |
| Place | `GET`, `PUT`, `DELETE /api/places/{id}` |
| Trip Template | `POST /api/trip-templates`; `GET`, `PUT`, `DELETE /api/trip-templates/{id}` |
| Template Item | `GET`, `POST /api/template-items`; `GET`, `PUT`, `DELETE /api/template-items/{id}` |
| AI Conversation | `GET /api/ai-conversations`; `GET`, `PUT`, `DELETE /api/ai-conversations/{id}` |
| AI Message | `GET /api/ai-messages`, `GET /api/ai-messages/{id}` |
| Weather | `GET /api/weather/current` |

Đường dẫn thay thế: `GET /api/expenses/trip/{tripId}`, `GET /api/template-items/template/{id}`, `GET /api/ai-conversations/trip/{tripId}`, `GET /api/weather/trip/{tripId}`. Các client đang dùng route cũ cần cập nhật.

## Quy ước request/response cần lưu ý

- Logout: `DELETE /api/auth/logout`, header `Authorization: Bearer <accessToken>`, không cần body `refreshToken`.
- Expense list vẫn là response phân trang Spring (`content`, `totalElements`, ...), hỗ trợ `category`, `page`, `size`, `sort`.
- `POST /api/trips`: `planningMode=MANUAL` tạo trip rỗng; `TEMPLATE` yêu cầu `templateId` và sao chép item; `AI` gọi AI service với trường tùy chọn `travelStyle`, `preferences`. Lỗi AI rollback việc tạo trip.
- AI history trả mảng conversation; mỗi conversation chứa mảng `messages` theo thời gian.
- Itinerary trả `place` gồm mô tả, tọa độ, rating/reviewCount và thông tin địa điểm. Database hiện không có nội dung từng review.
- Weather chọn địa điểm có tọa độ từ ngày hiện tại trở đi, fallback địa điểm hợp lệ đầu tiên trong trip. Trip chưa có tọa độ hợp lệ trả 400. Đây là thời tiết hiện tại, không phải dự báo cho toàn bộ ngày du lịch.
- Runtime chọn điểm có giờ bắt đầu chưa qua trong ngày; khi không còn điểm phù hợp, `nextItemId` và `googleMapsUrl` là null. Thời gian dựa vào timezone của server.

## Các vấn đề Auth còn tồn tại — chưa sửa trong đợt chuẩn hóa route

1. **OAuth chưa xác minh danh tính với provider.** `AuthServiceImpl.oauthLogin` dùng `providerUserId` và email do client gửi, có thể liên kết tới tài khoản đã tồn tại theo email rồi cấp JWT. Không được coi đây là đăng nhập Google/Facebook an toàn. Cần xác minh token/chữ ký, audience và định danh từ provider trước khi cấp JWT; chưa kiểm thử đăng nhập thực tế với hai provider.
2. **Quên mật khẩu trả reset token trong JSON.** `requestPasswordReset` đưa `resetToken` trực tiếp vào response; mail service còn ghi token ra log khi `app.mail.enabled=false`. Cần chỉ gửi token qua kênh email đã xác thực, bỏ token khỏi response/log và kiểm tra SMTP thực tế.
3. **Thu hồi toàn bộ token sau đổi mật khẩu bị sai.** `TokenRevocationServiceImpl.revokeAllForUser` đang gọi `accessTokenRevocationRepository.deleteAll()`, không vô hiệu hóa JWT đã phát hành của user và còn xóa blacklist toàn hệ thống. Cần cơ chế phiên bản token hoặc thời điểm thu hồi theo user. Test logout chỉ xác nhận thu hồi một JWT, không chứng minh reset-password đã thu hồi mọi phiên.

Các vấn đề trên được xác nhận bằng đọc code; test suite xanh không phủ nhận các phát hiện này.

## Phạm vi test và chạy lại

Kết quả chạy: **41 tests, 0 failures, 0 errors, 0 skipped — BUILD SUCCESS**. Trong đó có 19 ca integration (bao gồm 11 trường hợp GET route đã gỡ), 4 test WeatherController và 18 test hiện có khác. Một ca integration có thể gửi nhiều HTTP request để xác nhận toàn bộ vòng đời dữ liệu.

`backend/src/test/java/com/travelmate/backend/controller/ApiContractIntegrationTest.java` kiểm tra:

- Tập 38 route chính xác; cả 33 API không công khai từ chối request thiếu JWT.
- Register/login/profile/preferences, password reset một lần, logout và xóa user.
- CRUD trip/itinerary/expense, reorder, soft-delete/restore và số tiền trong budget.
- Tạo trip bằng template/AI; AI chat và tải lại tin nhắn đã lưu.
- Tìm địa điểm, nội dung place trong itinerary, runtime/Maps và weather theo trip.
- Không truy cập chéo tài khoản; dữ liệu sai; API GET dư trả 404/405.
- Xóa user có trip, itinerary, expense và conversation không lỗi khóa ngoại.

Giữ các unit test JWT, logout, token revocation, validation và OpenWeather client; cập nhật WeatherControllerTest theo route mới. OAuth hiện chỉ có test request không hợp lệ, chưa có test thành công với provider thật.

Lệnh chuẩn từ thư mục `backend`: `./mvnw.cmd test` (Java 21). Trong môi trường kiểm tra, wrapper gặp lỗi phát hiện cache Maven và cache ngoài workspace bị từ chối truy cập bởi Java. Đã dùng Maven 3.9.15 có sẵn, sao chép cache dependency vào `.m2-cache` trong workspace và chạy offline:

```powershell
& '<duong-dan-Maven-3.9.15>/bin/mvn.cmd' '-Dmaven.repo.local=D:/TravelMate/.m2-cache' -o test
```

`.m2-cache` được gitignore. Report tự động ở `backend/target/surefire-reports`; log ở `backend/api-test.log`.

Chưa chạy với PostgreSQL thật, SMTP thật, Google/Facebook thật, OpenWeather thật hoặc Python AI service đang chạy. Các test dùng H2 in-memory và không thay đổi dữ liệu PostgreSQL của dự án. Cấu hình có các khóa `SPRING_DATASOURCE_URL`, `AI_SERVICE_URL`, `OPENWEATHERMAP_API_URL`, `SPRING_MAIL_HOST`, `SPRING_MAIL_PORT`; việc có cấu hình không chứng minh các dịch vụ đó đang hoạt động.
