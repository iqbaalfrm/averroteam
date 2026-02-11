# ==========================================
# Stage 1: Build
# ==========================================
FROM golang:1.24-alpine AS builder

RUN apk add --no-cache gcc musl-dev sqlite-dev

WORKDIR /app

# Cache dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy source
COPY . .

# Build binary (CGO enabled for SQLite)
RUN CGO_ENABLED=1 GOOS=linux go build \
    -ldflags="-s -w" \
    -o /app/server \
    ./cmd/api

# ==========================================
# Stage 2: Runtime
# ==========================================
FROM alpine:3.21

RUN apk add --no-cache ca-certificates sqlite-libs tzdata

# Set timezone ke WIB
ENV TZ=Asia/Jakarta

WORKDIR /app

# Copy binary dari builder
COPY --from=builder /app/server .
COPY --from=builder /app/docs ./docs

# Buat direktori data untuk SQLite
RUN mkdir -p /app/data

# Environment variables default
ENV APP_PORT=8080
ENV DB_PATH=/app/data/averroes.db
ENV SCREENER_CSV_PATH=/app/docs/CSV_Averroes.csv
ENV GIN_MODE=release

EXPOSE 8080

CMD ["./server"]
