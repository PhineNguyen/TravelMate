# TravelMate Mobile

## Chạy bằng Docker, không cần cài Node/Expo

Tại thư mục gốc repository, chạy `docker compose up --build -d`, rồi mở **http://localhost:3000**. Docker build bản React Native Web và khởi động backend cùng PostgreSQL. Nginx chuyển tiếp `/api/` đến backend; frontend tự dùng origin đang truy cập, không cần sửa IP API. Xem [hướng dẫn Docker](../README.md#chạy-bằng-docker) để truy cập từ điện thoại, đổi cổng và cấu hình dịch vụ ngoài.

Dockerfile chạy typecheck, tests và Expo web export trước khi tạo image Nginx. File `.env`, `node_modules` và output build trên máy được loại khỏi Docker context. Bản này chạy trong trình duyệt; chạy native Android/iOS vẫn theo hướng dẫn bên dưới.

Ứng dụng Expo React Native + TypeScript cho backend TravelMate. Giao diện tiếng Việt, tông kem/xanh rừng, font đóng gói cùng app, hỗ trợ Android, iOS và preview web.

## Chạy ứng dụng

Yêu cầu Node.js 22.13+; dự án dùng Expo SDK 57. Cài đúng phiên bản Expo Go tương thích nếu chạy trên điện thoại. Tham khảo [tài liệu Expo SDK 57](https://docs.expo.dev/versions/v57.0.0/).

```powershell
cd mobile
npm ci
npm start
```

- Android/iOS: mở bằng Expo Go theo hướng dẫn trong terminal.
- Web: `npm run web`.
- Chưa có backend: chọn **Khám phá bản trải nghiệm** tại màn chào. Banner luôn ghi rõ dữ liệu mẫu. Các chỉnh sửa mẫu lưu trên thiết bị, không gửi sang backend.

## Kết nối backend

Sao chép `.env.example` thành `.env`, cấu hình `EXPO_PUBLIC_API_URL` rồi khởi động lại Metro. Hoặc dùng nút Cài đặt kết nối ở màn chào / Cá nhân → Kết nối máy chủ. Địa chỉ lưu trong app được ưu tiên hơn biến môi trường.

| Thiết bị | Địa chỉ backend |
|---|---|
| Android emulator | `http://10.0.2.2:8080` |
| Web/iOS simulator trên máy backend | `http://localhost:8080` |
| Điện thoại thật | `http://<IP-LAN-máy-backend>:8080` |

Chỉ nhập origin, **không thêm `/api`**. Khi đổi máy chủ, app đăng xuất để tránh gửi JWT sang máy chủ khác. Điện thoại và máy backend cần kết nối được qua mạng. Với build phân phối, dùng backend HTTPS.

JWT lưu bằng Expo SecureStore trên native; web dùng sessionStorage của tab. Không lưu mật khẩu. Mọi request 401 trong phiên đăng nhập sẽ đưa người dùng về màn xác thực. Không tự chuyển sang dữ liệu mẫu khi API lỗi.

## Các màn hình và thao tác

- Chào mừng, đăng ký, đăng nhập, yêu cầu email và nhập mã đặt lại mật khẩu.
- Khám phá điểm đến, tìm theo tên, lọc chủ đề, xem lịch trình mẫu.
- Danh sách chuyến đi với bộ lọc; kéo xuống để tải lại.
- Tạo chuyến đi bằng AI, thủ công hoặc template; chọn ngày bằng lịch, ngân sách và số người.
- Chi tiết chuyến đi: timeline theo ngày, tìm/tạo địa điểm, chỉnh giờ và ghi chú, đổi thứ tự bằng nút lên/xuống, xóa điểm và mở Google Maps.
- Ngân sách: đọc tổng hợp từ backend, xem toàn bộ các trang expense, thêm/sửa/xóa khoản chi theo danh mục.
- Chỉnh tên điểm đến/ngân sách; chuyển trạng thái Draft → Planned → Active → Completed; xóa mềm và khôi phục ngay trong màn xác nhận.
- Chat AI theo từng chuyến đi, tải lịch sử, phản hồi lỗi và trạng thái đang trả lời.
- Hồ sơ, sở thích du lịch, cấu hình máy chủ, đăng xuất, xóa tài khoản với xác nhận email.

OAuth không được expose trên UI vì backend chưa xác minh provider an toàn. Các vấn đề Auth hiện có của backend được ghi trong [báo cáo API](../BAO_CAO_KIEM_TRA_API.md). Frontend không sửa những vấn đề này. Email thật cần SMTP được bật; mã đặt lại mật khẩu được nhập từ email, không lấy ngầm từ response để tự điền.

Ảnh điểm đến được tải từ Unsplash; khi tải lỗi app hiển thị nền dự phòng. Thời tiết được đọc theo trip; dữ liệu fallback từ backend không được hiển thị như số đo thật. Chat demo là phản hồi minh họa, không phải model AI.

## Kiểm tra và build

```powershell
npm run typecheck
npm test
npm run format:check
npm run build:web
npm run build:bundles
```

`npm test` dùng TypeScript + Node test runner, kiểm tra request JWT/HTTP, lỗi API, validation ngày/ngân sách, lọc trạng thái, demo CRUD, khôi phục, reorder, lưu sở thích và ghi đồng thời. Đây là test logic, chưa thay thế kiểm thử thao tác trên thiết bị.

`build:web` xuất `dist/`. `build:bundles` kiểm tra Metro bundle của web, Android và iOS; **không tạo APK/IPA**. Build và chạy native trên simulator/thiết bị cần môi trường Android/Xcode hoặc EAS riêng.

## Cấu trúc

```text
App.tsx                  App shell, tab navigation, Android back handling
src/ui.tsx               Components và design tokens dùng chung
src/components/          DatePicker
src/screens/             Các màn hình và form
src/api/client.ts        REST client, JWT, timeout, xử lý lỗi
src/api/demo-client.ts   Sandbox dữ liệu mẫu, tách khỏi request thật
src/store.tsx            Session, kết nối, tải dữ liệu
src/types.ts             Model TypeScript theo DTO backend
tests/                   Test logic/API client
```

Source, `package-lock.json`, tài liệu, SQL/XML và `.env.example` được giữ trong Git. Dependencies, cache, Expo state, output build/test, log, `.env` và signing credentials được ignore. Thay đổi `.gitignore` không tự bỏ theo dõi những file đã commit từ trước.
