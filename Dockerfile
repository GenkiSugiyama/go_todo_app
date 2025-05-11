# ビルドするためのイメージ ここでローカルのコードコピー、ビルドなどしている
FROM golang.1.23.5-bullseye as deploy-builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN go build -trimpath -ldflags "-w -s" -o app

# デプロイ用のイメージ
# ここでビルドしたバイナリをコピーしている
FROM debian:bullseye-slim as deploy

RUN apt-get update

COPY --from=deploy-builder /app/app .

CMD ["./app"]

# 開発用のイメージ
# ここでローカルのコードコピー、ビルドなどしている
FROM golang:1.23.5 as dev
WORKDIR /app
RUN go install github.com/air-verse/air@latest
CMD ["air"]