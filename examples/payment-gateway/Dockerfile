# FinServ Digital illustrative multi-stage Dockerfile
# Replace module metadata with the real application source before building.

FROM golang:1.24-alpine AS build

WORKDIR /src

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -trimpath -ldflags="-s -w" -o /out/payment-gateway ./cmd/payment-gateway

FROM gcr.io/distroless/static-debian12:nonroot

WORKDIR /app

COPY --from=build /out/payment-gateway /app/payment-gateway

USER nonroot:nonroot

EXPOSE 8443

ENTRYPOINT ["/app/payment-gateway"]
