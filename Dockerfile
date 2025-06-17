# 使用官方 Golang 1.24.3 的 Alpine 版作为构建镜像
FROM golang:1.24.3-alpine AS builder

# 设置工作目录为 /app
WORKDIR /app

# 设置 Go 模块代理（加速国内依赖下载）
ENV GOPROXY=https://goproxy.cn,direct

# 只复制 go.mod 和 go.sum，先行拉取依赖（利用 Docker 构建缓存）
COPY go.mod go.sum ./
RUN go mod download

# 复制所有源代码到工作目录
COPY . .

# 编译 Go 程序，生成名为 app 的二进制文件
RUN go build -o app main.go

# 使用更小的 Alpine 镜像作为最终运行环境，减小体积
FROM alpine:latest

# 设置运行时工作目录为 /app
WORKDIR /app

# 从 builder 阶段拷贝编译好的二进制文件到运行环境
COPY --from=builder /app/app .

# 声明容器运行时需要暴露的 8083 端口
EXPOSE 8083

# 设置容器启动时默认执行的命令
CMD ["./app"]