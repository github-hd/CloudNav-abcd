# CloudNav Docker 配置完成总结

## ✅ 已创建的文件

### 核心文件
1. **Dockerfile** - Docker 镜像构建配置
   - 多阶段构建（前端 + 后端）
   - 基于 Node.js 20 Alpine
   - 自动创建数据目录

2. **docker-compose.yml** - 生产环境配置
   - 使用 GitHub Container Registry 镜像
   - 数据持久化配置
   - 健康检查

3. **docker-compose.dev.yml** - 开发环境配置
   - 本地构建镜像
   - 用于测试

### 后端服务
4. **server/index.js** - Express 服务器
   - 替代 Cloudflare Functions
   - 实现所有 API 端点
   - 静态文件服务

5. **server/kv-storage.js** - KV 存储实现
   - 使用文件系统替代 Cloudflare KV
   - 支持过期时间
   - JSON 格式存储

6. **server/package.json** - 服务端依赖

### GitHub Actions
7. **.github/workflows/docker-build.yml** - 自动构建工作流
   - 自动构建并推送到 GHCR
   - 多平台支持（amd64/arm64）
   - 自动标签管理

### 配置文件
8. **.dockerignore** - Docker 构建忽略文件
9. **.gitignore** - Git 忽略文件
10. **.env.example** - 环境变量示例

### 文档
11. **DOCKER_DEPLOYMENT.md** - 完整部署文档
12. **README_DOCKER.md** - Docker 快速指南
13. **README.md** - 更新了 Docker 部署说明

### 测试脚本
14. **test-docker.sh** - Linux/Mac 测试脚本
15. **test-docker.bat** - Windows 测试脚本

## 🚀 使用流程

### 1. 本地测试（推荐先测试）

**Windows:**
```cmd
test-docker.bat
```

**Linux/Mac:**
```bash
chmod +x test-docker.sh
./test-docker.sh
```

### 2. 推送到 GitHub

```bash
git add .
git commit -m "Add Docker support"
git push origin main
```

### 3. GitHub Actions 自动构建

推送后，GitHub Actions 会自动：
- 构建 Docker 镜像
- 推送到 `ghcr.io/你的用户名/仓库名:latest`
- 支持 amd64 和 arm64 架构

### 4. 部署使用

在服务器上创建 `docker-compose.yml`：

```yaml
version: "3.8"

services:
  cloudnav:
    image: ghcr.io/你的用户名/仓库名:latest
    container_name: cloudnav
    restart: unless-stopped
    ports:
      - "3000:3000"
    environment:
      PASSWORD: "你的密码"
      CLOUDNAV_KV_PATH: "/app/data"
    volumes:
      - ./data:/app/data
```

启动：
```bash
docker-compose up -d
```

## 📋 环境变量说明

| 变量 | 说明 | 必填 | 默认值 |
|------|------|------|--------|
| PASSWORD | 访问密码 | ✅ | 无 |
| CLOUDNAV_KV_PATH | 数据存储路径 | ❌ | ./data |
| PORT | 服务端口 | ❌ | 3000 |

## 🔧 数据存储

所有数据存储在 `./data/kv.json` 文件中，格式：

```json
{
  "app_data": {
    "value": "{\"links\":[...],\"categories\":[...]}",
    "expiresAt": null
  },
  "ai_config": {
    "value": "{...}",
    "expiresAt": null
  },
  "search_config": {
    "value": "{...}",
    "expiresAt": null
  },
  "favicon:domain.com": {
    "value": "https://...",
    "expiresAt": 1234567890000
  }
}
```

## 🎯 与 Cloudflare Pages 的区别

| 特性 | Cloudflare Pages | Docker 部署 |
|------|------------------|-------------|
| 成本 | 免费 | 需要服务器 |
| 数据控制 | Cloudflare KV | 完全自主 |
| 部署难度 | 中等 | 简单 |
| 内网访问 | ❌ | ✅ |
| 自定义 | 有限 | 完全自由 |
| 备份 | 需要 WebDAV | 直接文件备份 |

## 🐛 故障排查

### 查看日志
```bash
docker logs -f cloudnav
```

### 重启服务
```bash
docker-compose restart
```

### 重新构建
```bash
docker-compose down
docker-compose pull
docker-compose up -d
```

### 数据备份
```bash
# 备份
cp ./data/kv.json ./data/kv.json.backup

# 恢复
docker-compose down
cp ./data/kv.json.backup ./data/kv.json
docker-compose up -d
```

## ✨ 下一步

1. ✅ 推送代码到 GitHub
2. ✅ 等待 GitHub Actions 构建完成
3. ✅ 在服务器上部署
4. ✅ 访问 http://你的服务器:3000
5. ✅ 使用设置的密码登录

## 📞 支持

如有问题，请在 GitHub 提交 Issue。
