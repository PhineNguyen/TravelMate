# BAO CAO LOI VA CACH SUA

Tai lieu nay tong hop cac loi da gap trong backend TravelMate, nguyen nhan, cach xu ly, va cac lenh terminal co the chay lai neu can.

## 1. Loi khong ket noi duoc PostgreSQL

### Bieu hien
- Ung dung khong khoi dong duoc khi dung datasource PostgreSQL.
- Thuong do sai user, password, host, port, hoac database chua san sang.

### Cach sua
- Chuan hoa cau hinh datasource trong `application.properties`.
- Dung Docker PostgreSQL cho moi truong local.
- Dung thong tin mac dinh: `root / 21052026 / travelmate`.

### Lenh terminal
```powershell
cd /d E:\TravelMate\backend
.\mvnw.cmd spring-boot:run
```

```powershell
cd /d E:\TravelMate\backend
.\mvnw.cmd spring-boot:run -Dspring-boot.run.arguments="--spring.profiles.active=dev"
```

```powershell
docker compose up -d
```

```powershell
docker ps
```

## 2. Loi Swagger khong hien endpoint

### Bieu hien
- Swagger UI mo duoc nhung khong co API de hien thi.

### Cach sua
- Them day du REST controllers cho cac service.
- Dat lai duong dan Swagger thanh `/swagger-ui.html`.
- Cau hinh security cho phep truy cap trong dev mode.

### Lenh terminal
```powershell
cd /d E:\TravelMate\backend
.\mvnw.cmd -DskipTests package
```

```powershell
cd /d E:\TravelMate\backend
.\mvnw.cmd spring-boot:run -Dspring-boot.run.arguments="--spring.profiles.active=dev"
```

Sau do mo trinh duyet:

```text
http://localhost:8080/swagger-ui.html
```

## 3. Loi repository do ten method sai

### Bieu hien
- Spring Data khong tao duoc repository bean.
- Loi kieu `PropertyReferenceException` hoac method nhu `findByTripIdId...`.

### Cach sua
- Doi cac method `...IdId...` thanh `...Id...` cho dung voi field relation.

### Lenh terminal
```powershell
cd /d E:\TravelMate\backend
.\mvnw.cmd -DskipTests package
```

## 4. Loi thieu PasswordEncoder

### Bieu hien
- App fail khi khoi dong vi service can `PasswordEncoder` nhung khong co bean.

### Cach sua
- Them `SecurityConfig` de cung cap `BCryptPasswordEncoder`.
- Mo quyen truy cap cho API va Swagger khi dev.

### Lenh terminal
```powershell
cd /d E:\TravelMate\backend
.\mvnw.cmd -DskipTests package
```

## 5. Loi H2 trong profile dev

### Bieu hien
- Chay `dev` profile bi loi vi chua co H2 runtime dependency.
- Sau do Hibernate/H2 gay loi schema generation khi khoi tao database.

### Cach sua
- Them dependency H2 vao `pom.xml`.
- Chuyen `application-dev.yml` sang H2 PostgreSQL mode.
- Tat `ddl-auto` trong dev de tranh tao schema gay loi.

### Lenh terminal
```powershell
cd /d E:\TravelMate\backend
.\mvnw.cmd -DskipTests package
```

```powershell
cd /d E:\TravelMate\backend
.\mvnw.cmd spring-boot:run -Dspring-boot.run.arguments="--spring.profiles.active=dev"
```

## 6. Loi port 8080 bi chiem

### Bieu hien
- App fail voi thong bao `Port 8080 was already in use`.

### Cach sua
- Tim PID dang listen tren port 8080.
- Kill process do roi chay lai ung dung.

### Lenh terminal
```powershell
netstat -ano | findstr :8080
```netstat -ano | findstr :8080

```powershell
taskkill /PID 32776 /F
```

```powershell
cd /d E:\TravelMate\backend
.\mvnw.cmd spring-boot:run -Dspring-boot.run.arguments="--spring.profiles.active=dev"
```

## 7. Thu tu cac buoc da thuc hien

1. Them REST controllers cho cac service.
2. Them `SecurityConfig` va `PasswordEncoder`.
3. Sua ten repository method bi sai.
4. Them H2 dependency va cau hinh profile `dev`.
5. Tat schema generation trong `dev` profile.
6. Giai phong port 8080.
7. Chay lai ung dung va mo Swagger.

## 8. Ket qua cuoi cung

- Backend da khoi dong thanh cong.
- Swagger UI da mo duoc.
- Duong dan:

```text
http://localhost:8080/swagger-ui.html
```



`````Đoạn mã được sử dụng để kiểm tra biên dịch
cd /d E:\TravelMate\backend && mvnw.cmd -DskipTests compile