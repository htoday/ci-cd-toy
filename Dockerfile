# 使用官方 Golang 镜像作为构建环境
FROM golang:1.24.3-alpine AS builder

WORKDIR /app

# 复制 go.mod 和 go.sum 并下载依赖
COPY go.mod go.sum ./
RUN go mod download

# 复制源代码
COPY . .

# 构建可执行文件
RUN go build -o app main.go

# 使用更小的基础镜像运行应用
FROM alpine:latest
WORKDIR /root/

# 拷贝构建好的二进制文件
COPY --from=builder /app/app .

# 设置容器启动时执行的命令
CMD ["./app"]

