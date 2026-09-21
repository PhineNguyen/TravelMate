FROM node:24-alpine AS build
WORKDIR /app
ENV CI=1 EXPO_NO_TELEMETRY=1 EXPO_OFFLINE=1
COPY package.json package-lock.json ./
RUN npm ci --no-audit --no-fund
COPY . .
# Exported web code discovers the browser origin; no machine-specific IP is baked in.
ENV EXPO_PUBLIC_API_URL=same-origin
RUN npm run typecheck && npm test && npm run build:web

FROM nginx:1.28-alpine AS runtime
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 8080
HEALTHCHECK --interval=15s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -q -O /dev/null http://127.0.0.1:8080/healthz || exit 1
