# Giai đoạn 1: Build
FROM maven:3.9.9-eclipse-temurin-21 AS build
WORKDIR /app

# Chỉ copy pom.xml trước để tải dependencies
COPY pom.xml .
# Lệnh này tải sẵn tất cả thư viện cần thiết và lưu vào cache
RUN mvn dependency:go-offline -B 

# Sau đó mới copy source code
COPY src ./src
RUN mvn -B -DskipTests package

# Giai đoạn 2: Runtime
FROM eclipse-temurin:21-jre
WORKDIR /app
# Chỉ lấy file jar đã build
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/app.jar"]