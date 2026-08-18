# Bo du lieu mau cho frontend

File `seed_frontend_demo.sql` bo sung du lieu mau cho cac man hinh frontend:

- `trip_template`: 10 template du lich
- `users` va `user_preferences`: tai khoan va du lieu onboarding mau
- `places`: dia diem cho itinerary/map
- `trips`: cac chuyen di cho Home va All Trips
- `trip_participants`: owner cua trip
- `itinerary_item`: lich trinh mau
- `expenses`: khoan chi tieu mau
- `shared_trip_invites`: loi moi chia se trip
- `notifications`: thong bao budget, weather va invite
- `weather_snapshot`: du lieu thoi tiet
- `analytics_snapshot`: du lieu Travel Insights

Script khong xoa du lieu cu. Co the chay lai nhieu lan; cac ban ghi mau trung email, title, trip hoac noi dung se duoc bo qua.

## Cach 1: Chay vao PostgreSQL trong Docker

Mo terminal tai thu muc `backend`:

```powershell
cd A:\TravelMate\backend
```

Dam bao PostgreSQL dang chay:

```powershell
docker compose up -d postgres
```

Chay script:

```powershell
Get-Content .\database\seed_frontend_demo.sql | docker exec -i travelmate-postgres psql -U postgres -d travelmate
```

Neu file `.env` cua ban dung username khac `postgres`, thay `-U postgres` bang gia tri `SPRING_DATASOURCE_USERNAME` trong file `.env`.

## Cach 2: Chay bang pgAdmin/DBeaver

1. Ket noi database `travelmate`.
2. Dung host `localhost` va port `5433`.
3. Mo file `database/seed_frontend_demo.sql`.
4. Chay toan bo script.
5. Xem bang ket qua o cuoi file de kiem tra so luong ban ghi.

## Kiem tra API sau khi seed

Khoi dong backend:

```powershell
docker compose up -d --build backend
```

Kiem tra template:

```powershell
curl http://localhost:8080/api/trip-templates
```

Kiem tra trips:

```powershell
curl http://localhost:8080/api/trips
```

## Chay frontend

- Android Emulator: `ApiClient` dung `http://10.0.2.2:8080`.
- Flutter Web/Desktop: `ApiClient` dung `http://localhost:8080`.

Sau khi seed xong, trong Android Studio chay **Hot Restart** frontend. Neu backend vua build lai, hay cho container khoi dong xong roi moi mo man hinh Trip Templates.

## Tai khoan mau

Script tao tai khoan:

```text
demo@travelmate.local
minhanh@travelmate.local
giabao@travelmate.local
```

Mat khau hash trong script duoc dung cho du lieu demo. Khi test dang nhap, nen dang ky tai khoan moi qua API auth neu policy mat khau cua backend thay doi.
