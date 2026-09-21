# TravelMate

## Chạy bằng Docker

Cài Docker Desktop (Linux containers) với Docker Compose 2.24 trở lên, rồi chạy tại thư mục gốc:

```sh
docker compose up --build -d
```

Mở **http://localhost:3000** sau khi backend khởi động. Docker tự cài dependencies, kiểm tra và build frontend Expo React Native Web, chạy Nginx, Spring Boot và PostgreSQL. Không cần cài Node.js, Java hay cấu hình React Native trên máy. Lần build đầu cần Internet và có thể mất vài phút.

- `docker compose logs -f backend frontend`: xem trạng thái khởi động.
- `docker compose down`: dừng stack, giữ dữ liệu PostgreSQL trong volume.
- Chạy lại `docker compose up --build -d` sau khi cập nhật source.
- `backend/.env` là tùy chọn cho stack này. AI cần service riêng tại `host.docker.internal:8000` (hoặc đặt `AI_SERVICE_URL` trong `.env` ở thư mục gốc); email và thời tiết thật cần cấu hình nhà cung cấp. Stack không khởi chạy AI service.
- Cấu hình mặc định dành cho chạy local. Stack `travelmate-local` dùng database riêng, không dùng lại database của Compose trong `backend/`.

Để mở bằng trình duyệt điện thoại cùng mạng, đặt `WEB_BIND_ADDRESS=0.0.0.0` trong `.env` ở thư mục gốc, chạy lại lệnh trên và truy cập `http://<IP-LAN-máy-chạy-Docker>:3000` (cho phép cổng 3000 qua firewall). Có thể đổi cổng bằng `WEB_PORT=3001`. API tự đi qua cùng địa chỉ web; nếu trước đó đã lưu máy chủ thủ công trong app, cập nhật cài đặt kết nối về địa chỉ web đang truy cập.

Đây là **bản web của ứng dụng React Native**. Docker không thay thế thiết bị Android/iOS: chạy native vẫn cần Expo Go hoặc bản APK/IPA đã cài. Xem [hướng dẫn mobile](mobile/README.md).

Nếu đang dùng stack cũ trong `backend/`, chạy `docker compose up --build -d` tại thư mục đó cũng khởi động frontend ở cổng 3000, dùng database hiện có. Chỉ chọn một stack để tránh trùng cổng frontend.

TravelMate is an intelligent mobile travel planning platform designed to simplify personalized trip organization through artificial intelligence.

The system automatically generates optimized travel itineraries based on user preferences, budget constraints, trip duration, destination context, and real-time weather conditions. By integrating large language models from Hugging Face with a scalable microservice architecture, TravelMate AI provides dynamic travel recommendations and adaptive schedule generation for a smarter travel experience.

## Key Features

- AI-powered personalized itinerary generation
- Smart trip planning based on budget and travel preferences
- Real-time weather-aware schedule adjustment
- Budget estimation and expense tracking
- User preference learning and adaptive recommendations
- Secure authentication with JWT
- RESTful backend architecture with Spring Boot
- AI orchestration through FastAPI and Hugging Face models
- Dockerized multi-service deployment

## Architecture

TravelMate AI follows a distributed service architecture:

- **Backend API:** Spring Boot (Spring Security, JWT, JPA, Hibernate)
- **AI Service:** FastAPI + Hugging Face Inference API
- **Database:** PostgreSQL
- **Caching:** Redis (optional future enhancement)
- **Deployment:** Docker & Docker Compose

## Core Workflow

1. User creates a trip plan
2. Backend validates trip constraints
3. AI service generates optimized itinerary
4. Weather context enriches schedule recommendations
5. Mobile client renders dynamic trip timeline
6. User tracks expenses and trip analytics

## Project Goals

TravelMate AI aims to:

- Reduce manual trip planning time
- Deliver highly personalized travel experiences
- Optimize travel cost efficiency
- Adapt itineraries dynamically to environmental changes
- Demonstrate practical AI integration in mobile software systems

## Technical Highlights

- Clean Architecture
- Object-Oriented Design Principles
- JWT Authentication & Authorization
- Prompt Engineering for Structured AI Output
- API-driven Service Communication
- Dockerized Microservice Deployment
- Scalable System Design

## Status

Currently under active development as an AI-integrated mobile system engineering project focused on demonstrating full-stack mobile development, backend architecture, and applied AI orchestration.
