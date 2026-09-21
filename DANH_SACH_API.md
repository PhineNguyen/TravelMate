# Danh Sach API TravelMate

Tai lieu nay liet ke cac endpoint REST dang duoc khai bao trong source code vao ngay 03/09/2026.

## Base URL

| Dich vu | Base URL mac dinh | Ghi chu |
| --- | --- | --- |
| Backend Spring Boot | `http://localhost:8080` | Port co the thay doi theo cau hinh khi chay. |
| AI Service FastAPI | `http://localhost:8001` | Gia tri `AI_SERVICE_URL` cua backend mac dinh tro den dia chi nay. |

## Quy uoc

- `{id}`, `{tripId}`, `{userId}` va `{session_id}` la path parameter.
- Cac endpoint `POST` va `PUT` thong thuong nhan JSON body theo DTO cua controller tuong ung.
- Cac endpoint can dang nhap duoc bao ve boi cau hinh Spring Security/JWT cua backend.

## Backend API

### Xac thuc

| Method | Endpoint | Chuc nang |
| --- | --- | --- |
| POST | `/api/auth/register` | Dang ky tai khoan. |
| POST | `/api/auth/login` | Dang nhap. |
| POST | `/api/auth/oauth` | Dang nhap bang OAuth. |
| POST | `/api/auth/forgot-password` | Gui yeu cau quen mat khau. |
| POST | `/api/auth/reset-password` | Dat lai mat khau. |
| DELETE | `/api/auth/logout` | Dang xuat. |

### Nguoi dung va tuy chon

| Method | Endpoint | Chuc nang |
| --- | --- | --- |
| POST | `/api/users` | Tao nguoi dung. |
| PUT | `/api/users/{id}` | Cap nhat nguoi dung. |
| PUT | `/api/users/{id}/onboarding/complete` | Hoan tat onboarding. |
| GET | `/api/users/{id}` | Lay nguoi dung theo ID. |
| DELETE | `/api/users/{id}` | Xoa nguoi dung. |
| POST | `/api/user-preferences` | Tao tuy chon nguoi dung. |
| PUT | `/api/user-preferences/{id}` | Cap nhat tuy chon. |
| GET | `/api/user-preferences/user/{userId}` | Lay tuy chon cua nguoi dung. |
| DELETE | `/api/user-preferences/{id}` | Xoa tuy chon. |

### Chuyen di va lich trinh

| Method | Endpoint | Chuc nang |
| --- | --- | --- |
| POST | `/api/trips` | Tao chuyen di. |
| PUT | `/api/trips/{id}` | Cap nhat chuyen di. |
| GET | `/api/trips/{id}` | Lay chuyen di theo ID. |
| GET | `/api/trips/my` | Lay danh sach chuyen di cua nguoi dung hien tai. |
| DELETE | `/api/trips/{id}` | Xoa mem chuyen di. |
| PUT | `/api/trips/{id}/restore` | Khoi phuc chuyen di da xoa. |
| POST | `/api/trips/{id}/generate-itinerary` | Tao lich trinh cho chuyen di. |
| POST | `/api/itinerary-items` | Tao muc lich trinh. |
| PUT | `/api/itinerary-items/{id}` | Cap nhat muc lich trinh. |
| GET | `/api/itinerary-items/{id}` | Lay muc lich trinh theo ID. |
| GET | `/api/itinerary-items` | Lay danh sach muc lich trinh. |
| DELETE | `/api/itinerary-items/{id}` | Xoa muc lich trinh. |
| POST | `/api/route-plans` | Tao ke hoach tuyen duong. |
| PUT | `/api/route-plans/{id}` | Cap nhat ke hoach tuyen duong. |
| GET | `/api/route-plans/{id}` | Lay ke hoach tuyen duong theo ID. |
| GET | `/api/route-plans` | Lay danh sach ke hoach tuyen duong. |
| DELETE | `/api/route-plans/{id}` | Xoa ke hoach tuyen duong. |
| POST | `/api/route-nodes` | Tao diem trong tuyen duong. |
| PUT | `/api/route-nodes/{id}` | Cap nhat diem trong tuyen duong. |
| GET | `/api/route-nodes/{id}` | Lay diem trong tuyen duong theo ID. |
| GET | `/api/route-nodes` | Lay danh sach diem trong tuyen duong. |
| DELETE | `/api/route-nodes/{id}` | Xoa diem trong tuyen duong. |

### Thanh vien va loi moi chuyen di

| Method | Endpoint | Chuc nang |
| --- | --- | --- |
| POST | `/api/trip-participants` | Them thanh vien chuyen di. |
| PUT | `/api/trip-participants/{id}` | Cap nhat thanh vien chuyen di. |
| GET | `/api/trip-participants/{id}` | Lay thanh vien theo ID. |
| GET | `/api/trip-participants` | Lay danh sach thanh vien. |
| DELETE | `/api/trip-participants/{id}` | Xoa thanh vien. |
| POST | `/api/shared-trip-invites` | Tao loi moi chia se chuyen di. |
| PUT | `/api/shared-trip-invites/{id}` | Cap nhat loi moi. |
| GET | `/api/shared-trip-invites/{id}` | Lay loi moi theo ID. |
| GET | `/api/shared-trip-invites` | Lay danh sach loi moi. |
| PUT | `/api/shared-trip-invites/{id}/accept` | Chap nhan loi moi. |
| PUT | `/api/shared-trip-invites/{id}/reject` | Tu choi loi moi. |
| PUT | `/api/shared-trip-invites/{id}/revoke` | Thu hoi loi moi. |
| DELETE | `/api/shared-trip-invites/{id}` | Xoa loi moi. |

### Chi phi, dia diem va template

| Method | Endpoint | Chuc nang |
| --- | --- | --- |
| POST | `/api/expenses` | Tao khoan chi phi. |
| PUT | `/api/expenses/{id}` | Cap nhat khoan chi phi. |
| GET | `/api/expenses/{id}` | Lay chi phi theo ID. |
| GET | `/api/expenses` | Lay danh sach chi phi. |
| DELETE | `/api/expenses/{id}` | Xoa mem khoan chi phi. |
| PUT | `/api/expenses/{id}/restore` | Khoi phuc khoan chi phi. |
| POST | `/api/places` | Tao dia diem. |
| PUT | `/api/places/{id}` | Cap nhat dia diem. |
| GET | `/api/places/{id}` | Lay dia diem theo ID. |
| GET | `/api/places` | Lay danh sach dia diem. |
| DELETE | `/api/places/{id}` | Xoa dia diem. |
| POST | `/api/trip-templates` | Tao mau chuyen di. |
| PUT | `/api/trip-templates/{id}` | Cap nhat mau chuyen di. |
| GET | `/api/trip-templates/{id}` | Lay mau theo ID. |
| GET | `/api/trip-templates` | Lay danh sach mau chuyen di. |
| DELETE | `/api/trip-templates/{id}` | Xoa mau chuyen di. |
| POST | `/api/template-items` | Tao muc cua mau chuyen di. |
| PUT | `/api/template-items/{id}` | Cap nhat muc mau. |
| GET | `/api/template-items/{id}` | Lay muc mau theo ID. |
| GET | `/api/template-items` | Lay danh sach muc mau. |
| DELETE | `/api/template-items/{id}` | Xoa muc mau. |

### Chat, AI va thong bao

| Method | Endpoint | Chuc nang |
| --- | --- | --- |
| POST | `/api/chat-rooms` | Tao phong chat. |
| PUT | `/api/chat-rooms/{id}` | Cap nhat phong chat. |
| GET | `/api/chat-rooms/{id}` | Lay phong chat theo ID. |
| GET | `/api/chat-rooms` | Lay danh sach phong chat. |
| DELETE | `/api/chat-rooms/{id}` | Xoa phong chat. |
| POST | `/api/messages` | Tao tin nhan. |
| PUT | `/api/messages/{id}` | Cap nhat tin nhan. |
| GET | `/api/messages/{id}` | Lay tin nhan theo ID. |
| GET | `/api/messages` | Lay danh sach tin nhan. |
| DELETE | `/api/messages/{id}` | Xoa tin nhan. |
| POST | `/api/ai-conversations` | Tao hoi thoai AI. |
| PUT | `/api/ai-conversations/{id}` | Cap nhat hoi thoai AI. |
| GET | `/api/ai-conversations/{id}` | Lay hoi thoai AI theo ID. |
| GET | `/api/ai-conversations` | Lay danh sach hoi thoai AI. |
| DELETE | `/api/ai-conversations/{id}` | Xoa hoi thoai AI. |
| POST | `/api/ai-messages/send` | Gui tin nhan AI. |
| GET | `/api/ai-messages/{id}` | Lay tin nhan AI theo ID. |
| GET | `/api/ai-messages` | Lay danh sach tin nhan AI. |
| POST | `/api/notifications` | Tao thong bao. |
| PUT | `/api/notifications/{id}` | Cap nhat thong bao. |
| GET | `/api/notifications/{id}` | Lay thong bao theo ID. |
| GET | `/api/notifications` | Lay danh sach thong bao. |
| PUT | `/api/notifications/{id}/read` | Danh dau da doc. |
| PUT | `/api/notifications/read-all` | Danh dau tat ca da doc. |
| DELETE | `/api/notifications/{id}` | Xoa thong bao. |
| POST | `/api/recommendation-histories` | Tao lich su de xuat. |
| PUT | `/api/recommendation-histories/{id}` | Cap nhat lich su de xuat. |
| GET | `/api/recommendation-histories/{id}` | Lay lich su de xuat theo ID. |
| GET | `/api/recommendation-histories` | Lay danh sach lich su de xuat. |
| DELETE | `/api/recommendation-histories/{id}` | Xoa lich su de xuat. |

### Thoi tiet va phan tich

| Method | Endpoint | Chuc nang |
| --- | --- | --- |
| GET | `/api/weather/current` | Lay thoi tiet hien tai. |
| GET | `/api/weather-alerts/trip/{tripId}/unresolved` | Lay canh bao chua xu ly cua chuyen di. |
| GET | `/api/weather-alerts/trip/{tripId}` | Lay canh bao thoi tiet cua chuyen di. |
| PUT | `/api/weather-alerts/{id}/resolve` | Danh dau canh bao da xu ly. |
| GET | `/api/weather-alerts/{id}` | Lay canh bao theo ID. |
| GET | `/api/weather-alerts` | Lay danh sach canh bao. |
| POST | `/api/weather-alerts` | Tao canh bao thoi tiet. |
| PUT | `/api/weather-alerts/{id}` | Cap nhat canh bao thoi tiet. |
| DELETE | `/api/weather-alerts/{id}` | Xoa canh bao thoi tiet. |
| GET | `/api/weather-snapshots/trip/{tripId}/forecast` | Lay du bao thoi tiet cua chuyen di. |
| GET | `/api/weather-snapshots/trip/{tripId}` | Lay cac snapshot thoi tiet cua chuyen di. |
| GET | `/api/weather-snapshots/{id}` | Lay snapshot thoi tiet theo ID. |
| GET | `/api/weather-snapshots` | Lay danh sach snapshot thoi tiet. |
| POST | `/api/weather-snapshots` | Tao snapshot thoi tiet. |
| PUT | `/api/weather-snapshots/{id}` | Cap nhat snapshot thoi tiet. |
| DELETE | `/api/weather-snapshots/{id}` | Xoa snapshot thoi tiet. |
| POST | `/api/analytics-snapshots` | Tao snapshot phan tich. |
| PUT | `/api/analytics-snapshots/{id}` | Cap nhat snapshot phan tich. |
| GET | `/api/analytics-snapshots/{id}` | Lay snapshot phan tich theo ID. |
| GET | `/api/analytics-snapshots` | Lay danh sach snapshot phan tich. |
| DELETE | `/api/analytics-snapshots/{id}` | Xoa snapshot phan tich. |
| GET | `/api/insights/dashboard` | Lay du lieu dashboard. |
| GET | `/api/insights/trips/{tripId}/budget` | Lay phan tich ngan sach cua chuyen di. |
| GET | `/api/insights/trips/{tripId}/route` | Lay phan tich tuyen duong cua chuyen di. |
| GET | `/api/insights/trips/{tripId}/runtime` | Lay phan tich thoi gian thuc cua chuyen di. |
| POST | `/api/manual-action-logs` | Tao nhat ky thao tac thu cong. |
| PUT | `/api/manual-action-logs/{id}` | Cap nhat nhat ky thao tac. |
| GET | `/api/manual-action-logs/{id}` | Lay nhat ky theo ID. |
| GET | `/api/manual-action-logs` | Lay danh sach nhat ky thao tac. |
| DELETE | `/api/manual-action-logs/{id}` | Xoa nhat ky thao tac. |

## AI Service API

| Method | Endpoint | Chuc nang |
| --- | --- | --- |
| GET | `/` | Kiem tra trang thai AI service va model dang dung. |
| POST | `/ai/chat` | Gui tin nhan cho tro ly AI. |
| POST | `/ai/chat/stream` | Gui tin nhan va nhan phan hoi dang stream. |
| GET | `/ai/chat/{session_id}` | Lay lich su chat cua phien. |
| DELETE | `/ai/chat/{session_id}` | Xoa lich su chat cua phien. |
| POST | `/ai/generate-itinerary` | Tao lich trinh du lich bang AI. |
| POST | `/ai/optimize-route` | Toi uu thu tu tuyen duong. |
| POST | `/ai/adjust-weather` | Dieu chinh lich trinh theo thoi tiet. |
| POST | `/ai/recommend-places` | De xuat dia diem theo toa do va so thich. |
| POST | `/ai/geoapify/geocode` | Chuyen doi dia chi/toa do qua Geoapify. |
| POST | `/ai/geoapify/places` | Tim dia diem thong qua Geoapify. |
| POST | `/ai/geoapify/routing` | Truy van lo trinh thong qua Geoapify. |

## Tai lieu chi tiet AI

Request body va response mau cho cac API AI chinh duoc mo ta tai [ai-service-lc/API_DOCS.md](ai-service-lc/API_DOCS.md).