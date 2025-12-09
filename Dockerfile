# 构建阶段
FROM node:20-alpine AS builder

WORKDIR /app

# 复制前端 package 文件
COPY package*.json ./

# 安装前端依赖
RUN npm ci

# 复制源代码
COPY . .

# 构建前端应用
RUN npm run build

# 生产阶段
FROM node:20-alpine

WORKDIR /app

# 复制服务端代码和依赖
COPY server/package.json ./server/
WORKDIR /app/server
RUN npm install --production

# 复制服务端源码
COPY server/ ./

# 复制构建好的前端文件
COPY --from=builder /app/dist /app/dist

# 创建数据目录
RUN mkdir -p /app/data

# 暴露端口
EXPOSE 3000

# 设置工作目录
WORKDIR /app/server

# 启动服务
CMD ["node", "index.js"]
