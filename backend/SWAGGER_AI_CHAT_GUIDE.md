# Hướng Dẫn Từng Bước Chat Với AI Trên Swagger UI

Tài liệu này hướng dẫn bạn cách thực hiện các bước từ đăng ký/đăng nhập, tạo cuộc hội thoại mới, cho đến gửi tin nhắn chat và nhận phản hồi từ AI bằng cách sử dụng **Swagger UI** của Java Backend.

---

## Bước 1: Truy Cập Swagger UI
Khi backend đang chạy (qua cổng `8080`), hãy mở trình duyệt web và truy cập vào đường dẫn:
👉 **[http://localhost:8080/swagger-ui/index.html](http://localhost:8080/swagger-ui/index.html)** hoặc **[http://localhost:8080/swagger-ui.html](http://localhost:8080/swagger-ui.html)**

---

## Bước 2: Đăng Ký / Đăng Nhập Để Lấy Access Token

Vì các API AI yêu cầu phải xác thực người dùng (`isAuthenticated()`), bạn cần có một JWT Token hợp lệ.

### Cách A: Tạo Tài Khoản Mới (Nên Dùng)
1. Trên giao diện Swagger, tìm mục **`auth-controller`**.
2. Mở endpoint **`POST /api/auth/register`**.
3. Bấm nút **Try it out** và nhập thông tin đăng ký mẫu:
   ```json
   {
     "fullName": "Nguyen Thai Tuan",
     "email": "thaituan@gmail.com",
     "password": "Password123!"
   }
   ```
4. Bấm **Execute**.
5. Copy chuỗi **`accessToken`** trong kết quả phản hồi JSON trả về (Response body).

### Cách B: Đăng Nhập Với Tài Khoản Đã Có
Nếu bạn đã đăng ký tài khoản trước đó, hãy sử dụng endpoint **`POST /api/auth/login`**:
* Nhập Email và Password đã đăng ký rồi bấm **Execute** để nhận `accessToken`.

---

## Bước 3: Đưa Access Token vào Header Swagger
Để Swagger tự động đính kèm Token này vào tất cả các yêu cầu tiếp theo:
1. Kéo lên góc trên cùng bên phải giao diện Swagger, bấm nút **Authorize** (hình chiếc khóa).
2. Trong ô giá trị (Value), nhập chuỗi Token theo đúng định dạng sau:
   ```text
   Bearer <ACCESS_TOKEN_CỦA_BẠN_Ở_BƯỚC_2>
   ```
   *(Ví dụ: `Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`)*
3. Bấm nút **Authorize** để xác nhận, sau đó bấm **Close**.

---

## Bước 4: Lấy ID Người Dùng (userId)
Để tạo cuộc hội thoại, bạn cần truyền `userId` của chính bạn:
1. Tìm mục **`user-controller`** trên Swagger.
2. Mở endpoint **`GET /api/users/profile`** hoặc xem ID từ chính kết quả trả về của bước Đăng ký/Đăng nhập (thường là trường `id` của đối tượng User trong Response).
3. Ghi nhớ ID này (ví dụ: `6` hoặc `1`).

---

## Bước 5: Tạo Một Cuộc Hội Thoại Mới (AI Conversation)
1. Tìm mục **`ai-conversation-controller`**.
2. Mở endpoint **`POST /api/ai-conversations`**.
3. Bấm **Try it out** và nhập payload tạo hội thoại mới (đã được tối ưu hiển thị chỉ gồm các trường cần thiết):
   ```json
   {
     "userId": 6,
     "sessionTitle": "Hành trình khám phá Đà Nẵng 3 ngày"
   }
   ```
   *(Thay thế `userId` bằng ID thực tế của bạn có được từ Bước 4. Trường `tripId` là tùy chọn nếu chưa liên kết chuyến đi).*
4. Bấm **Execute**.
5. Ghi nhớ số **`id`** của cuộc hội thoại vừa tạo trong Response (đây chính là `conversationId`, ví dụ: `1`).

---

## Bước 6: Gửi Tin Nhắn Chat Và Nhận Phản Hồi Từ AI
1. Tìm mục **`ai-message-controller`**.
2. Mở endpoint **`POST /api/ai-messages/send`**.
3. Bấm **Try it out** và điền thông tin tin nhắn:
   ```json
   {
     "conversationId": 1,
     "content": "Tôi nên đi đâu vào buổi trưa ở Đà Nẵng để tránh nắng nóng?"
   }
   ```
   *(Thay thế `conversationId` bằng ID cuộc hội thoại ở Bước 5).*
4. Bấm **Execute**.
5. **Kết quả**:
   * Hệ thống sẽ gọi ngầm sang mô hình AI của `ai-service`.
   * AI sẽ tự động phân tích ngữ cảnh và trả về câu trả lời chi tiết hiển thị trong Response Body.
   * Đồng thời, bạn có thể kiểm tra console log của `ai-service` để thấy log debug raw JSON được in ra.

---

## Bước 7: Đổi Tên Tiêu Đề Cuộc Hội Thoại (Update Session Title)
Khi muốn đổi tên tiêu đề của cuộc trò chuyện (ví dụ: hiển thị trong danh sách lịch sử chat của App):
1. Tìm mục **`ai-conversation-controller`**.
2. Mở endpoint **`PUT /api/ai-conversations/{id}`**.
3. Bấm **Try it out**.
4. Nhập ID cuộc hội thoại cần sửa vào ô **`id`** (ví dụ: `1`).
5. Trong ô **RequestBody (JSON)**, nhập tiêu đề mới (đã được tối ưu chỉ hiển thị duy nhất trường cập nhật):
   ```json
   {
     "sessionTitle": "Lịch trình Đà Nẵng trốn nắng siêu vui"
   }
   ```
   *(Lưu ý: Không dùng dấu phẩy ở cuối dòng giá trị để tránh lỗi cú pháp JSON).*
6. Bấm **Execute**.
7. Hệ thống trả về thông tin cuộc hội thoại sau khi cập nhật với mã trạng thái `200 OK`.
