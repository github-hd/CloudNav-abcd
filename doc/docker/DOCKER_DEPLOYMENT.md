# CloudNav Docker 部署指南

本项目已支持 Docker 和 Docker Compose 部署，可以轻松地在任何支持 Docker 的环境中运行。

## 快速开始

### 使用 Docker Compose（推荐）

1. 创建 `docker-compose.yml` 文件：

```yaml
version: "3.8"

services:
  cloudnav:
    image: ghcr.io/github-hd/cloudnav-abcd:latest
    container_name: cloudnav
    restart: unless-stopped
    ports:
      - "3000:3000"
    environment:
      PASSWORD: "your_password_here"  # 修改为你的密码
      CLOUDNAV_KV_PATH: "/app/data"
      PORT: "3000"
    volumes:
      - ./data:/app/data
```

2. 启动服务：

```bash
docker-compose up -d
```

3. 访问应用：

打开浏览器访问 `http://localhost:3000`

### 使用 Docker 命令

```bash
# 拉取镜像
docker pull ghcr.io/github-hd/cloudnav-abcd:latest

# 运行容器
docker run -d \
  --name cloudnav \
  -p 3000:3000 \
  -e PASSWORD="your_password_here" \
  -e CLOUDNAV_KV_PATH="/app/data" \
  -v $(pwd)/data:/app/data \
  --restart unless-stopped \
  ghcr.io/github-hd/cloudnav-abcd:latest
```

## 环境变量说明

| 变量名 | 说明 | 默认值 | 必填 |
|--------|------|--------|------|
| `PASSWORD` | 访问密码，用于保护数据 | 无 | 是 |
| `CLOUDNAV_KV_PATH` | 数据存储路径 | `./data` | 否 |
| `PORT` | 服务端口 | `3000` | 否 |

## 数据持久化

所有数据（包括链接、分类、配置等）都存储在 `/app/data/kv.json` 文件中。通过 Docker volume 映射，数据会持久化到宿主机的 `./data` 目录。

### 备份数据

```bash
# 备份
cp ./data/kv.json ./data/kv.json.backup

# 或使用 tar 打包
tar -czf cloudnav-backup-$(date +%Y%m%d).tar.gz ./data
```

### 恢复数据

```bash
# 停止容器
docker-compose down

# 恢复数据
cp ./data/kv.json.backup ./data/kv.json

# 重启容器
docker-compose up -d
```

## 从 Cloudflare Pages 迁移

如果你之前使用 Cloudflare Pages 部署，可以按以下步骤迁移：

1. 从 Cloudflare KV 导出数据（如果有）
2. 将数据整理成 JSON 格式
3. 将数据放入 `./data/kv.json` 文件
4. 启动 Docker 容器

## 更新镜像

```bash
# 拉取最新镜像
docker-compose pull

# 重启服务
docker-compose up -d
```

## 故障排查

### 查看日志

```bash
docker-compose logs -f cloudnav
```

### 容器无法启动

1. 检查端口是否被占用：`netstat -tuln | grep 3000`
2. 检查数据目录权限：`ls -la ./data`
3. 查看容器日志：`docker logs cloudnav`

### 数据丢失

确保 volume 映射正确，数据目录应该在宿主机上持久化。

## 自定义端口

如果需要使用其他端口，修改 `docker-compose.yml`：

```yaml
ports:
  - "8080:3000"  # 宿主机端口:容器端口
```

## 反向代理配置

### Nginx

```nginx
server {
    listen 80;
    server_name your-domain.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### Caddy

```
your-domain.com {
    reverse_proxy localhost:3000
}
```

## 构建自己的镜像

如果需要自定义构建：

```bash
# 克隆仓库
git clone https://github.com/your-username/cloudnav.git
cd cloudnav

# 构建镜像
docker build -t cloudnav:custom .

# 运行
docker run -d -p 3000:3000 -e PASSWORD="your_password" -v $(pwd)/data:/app/data cloudnav:custom
```

## 技术架构

- **前端**: React + Vite + TailwindCSS
- **后端**: Node.js + Express
- **存储**: 文件系统（JSON）替代 Cloudflare KV
- **容器**: Alpine Linux（轻量级）

## 支持与反馈

如有问题，请在 GitHub 提交 Issue。
