# 从 Cloudflare Pages 到 Docker 的迁移指南

## 🎯 改造概述

本项目原本设计为 Cloudflare Pages 部署，使用 Cloudflare KV 作为数据存储。现已完成 Docker 化改造，支持自托管部署。

## 🔄 主要变化

### 架构变化

| 组件 | Cloudflare Pages | Docker 部署 |
|------|------------------|-------------|
| **前端** | Vite 构建静态文件 | Vite 构建静态文件（相同） |
| **后端** | Cloudflare Functions | Node.js + Express |
| **存储** | Cloudflare KV | 文件系统（JSON） |
| **服务器** | Cloudflare Edge | Nginx / Node.js |
| **部署** | Git Push 自动部署 | Docker Compose |

### 技术栈

**原架构：**
- 前端：React + Vite + TailwindCSS
- 后端：Cloudflare Functions (Serverless)
- 存储：Cloudflare KV (边缘存储)
- 部署：Cloudflare Pages

**新架构：**
- 前端：React + Vite + TailwindCSS（不变）
- 后端：Node.js + Express
- 存储：文件系统（JSON 格式）
- 部署：Docker + Docker Compose

## 📁 新增文件说明

### 1. 后端服务（server/）

#### server/index.js
Express 服务器，实现了所有原 Cloudflare Functions 的功能：

- `/api/storage` - 数据存储 API
  - GET: 获取应用数据、配置、图标缓存
  - POST: 保存数据、配置、图标
  
- `/api/link` - 链接管理 API
  - POST: 添加新链接

- 静态文件服务：服务前端构建文件
- SPA 路由支持：处理前端路由

#### server/kv-storage.js
KV 存储适配器，使用文件系统模拟 Cloudflare KV：

```javascript
// Cloudflare KV API
await env.CLOUDNAV_KV.get('key')
await env.CLOUDNAV_KV.put('key', 'value', { expirationTtl: 3600 })

// 文件系统实现
await kvStorage.get('key')
await kvStorage.put('key', 'value', { expirationTtl: 3600 })
```

**特性：**
- 支持过期时间（expirationTtl）
- 自动清理过期数据
- JSON 格式存储
- 线程安全的读写

#### server/package.json
服务端依赖：
- express: Web 框架
- cors: 跨域支持

### 2. Docker 配置

#### Dockerfile
多阶段构建：

**阶段 1 - 构建前端：**
```dockerfile
FROM node:20-alpine AS builder
# 安装依赖
# 构建前端（npm run build）
```

**阶段 2 - 运行时：**
```dockerfile
FROM node:20-alpine
# 复制后端代码
# 复制前端构建文件
# 启动 Express 服务器
```

#### docker-compose.yml
生产环境配置：
- 使用 GHCR 镜像
- 数据持久化
- 健康检查
- 自动重启

#### docker-compose.dev.yml
开发环境配置：
- 本地构建镜像
- 用于测试

### 3. GitHub Actions

#### .github/workflows/docker-build.yml
自动化 CI/CD：
- 触发条件：push 到 main/master 分支，或创建 tag
- 构建多平台镜像（amd64/arm64）
- 推送到 GitHub Container Registry
- 自动标签管理（latest, v1.0.0 等）

### 4. 配置文件

#### .dockerignore
排除不必要的文件，减小镜像体积：
- node_modules
- 文档和截图
- Git 文件
- 开发配置

#### .gitignore
忽略本地文件：
- 数据目录（data/）
- 环境变量（.env）
- 构建产物（dist/）

#### .env.example
环境变量模板：
- PASSWORD: 访问密码
- CLOUDNAV_KV_PATH: 数据存储路径
- PORT: 服务端口

### 5. 文档

#### DOCKER_DEPLOYMENT.md
完整的 Docker 部署文档：
- 快速开始
- 环境变量说明
- 数据持久化
- 故障排查
- 反向代理配置

#### README_DOCKER.md
Docker 快速指南：
- 本地测试
- GitHub Actions 说明
- 数据结构
- 注意事项

#### DEPLOYMENT_CHECKLIST.md
部署检查清单：
- 文件创建检查
- 部署前准备
- 功能测试
- 安全检查
- 常见问题

### 6. 测试脚本

#### test-docker.sh / test-docker.bat
一键测试脚本：
- 构建镜像
- 启动容器
- 健康检查
- 显示访问信息

## 🔧 API 兼容性

所有 API 端点保持与 Cloudflare Functions 完全兼容，前端代码无需修改。

### 存储 API

```javascript
// GET /api/storage?checkAuth=true
// 检查是否需要密码

// GET /api/storage?getConfig=ai
// 获取 AI 配置

// GET /api/storage?getConfig=search
// 获取搜索配置

// GET /api/storage?getConfig=website
// 获取网站配置

// GET /api/storage?getConfig=favicon&domain=example.com
// 获取图标缓存

// POST /api/storage
// 保存数据
{
  "authOnly": true,  // 仅验证密码
  "saveConfig": "ai",  // 保存 AI 配置
  "saveConfig": "search",  // 保存搜索配置
  "saveConfig": "website",  // 保存网站配置
  "saveConfig": "favicon",  // 保存图标
  // 或直接保存应用数据
  "links": [...],
  "categories": [...]
}
```

### 链接 API

```javascript
// POST /api/link
// 添加新链接
{
  "id": "uuid",
  "title": "标题",
  "url": "https://...",
  "icon": "https://...",
  "category": "分类ID"
}
```

## 💾 数据格式

### Cloudflare KV
```
Key: app_data
Value: {"links":[...],"categories":[...]}

Key: ai_config
Value: {"apiKey":"..."}

Key: favicon:example.com
Value: "https://..."
```

### 文件系统（kv.json）
```json
{
  "app_data": {
    "value": "{\"links\":[...],\"categories\":[...]}",
    "expiresAt": null
  },
  "ai_config": {
    "value": "{\"apiKey\":\"...\"}",
    "expiresAt": null
  },
  "favicon:example.com": {
    "value": "https://...",
    "expiresAt": 1234567890000
  }
}
```

## 🚀 部署流程

### Cloudflare Pages 部署
1. Fork 项目
2. 连接到 Cloudflare Pages
3. 创建 KV 命名空间
4. 绑定环境变量
5. 部署

### Docker 部署
1. 推送代码到 GitHub
2. GitHub Actions 自动构建镜像
3. 在服务器上运行 `docker-compose up -d`
4. 访问 http://服务器IP:3000

## 🔄 数据迁移

### 从 Cloudflare KV 导出

如果你之前使用 Cloudflare Pages，可以通过以下方式迁移数据：

1. **使用 Wrangler CLI 导出：**
```bash
wrangler kv:key list --namespace-id=你的KV命名空间ID
wrangler kv:key get "app_data" --namespace-id=你的KV命名空间ID
```

2. **手动导出：**
在 Cloudflare Dashboard 中查看 KV 数据，复制到本地

3. **转换格式：**
```javascript
// Cloudflare KV 格式
const appData = '{"links":[...],"categories":[...]}';

// 转换为文件系统格式
const kvData = {
  "app_data": {
    "value": appData,
    "expiresAt": null
  }
};

// 保存到 ./data/kv.json
```

### 导入到 Docker

1. 创建 `./data/kv.json` 文件
2. 粘贴转换后的数据
3. 启动 Docker 容器

## ⚖️ 优缺点对比

### Cloudflare Pages

**优点：**
- ✅ 完全免费
- ✅ 全球 CDN 加速
- ✅ 自动 HTTPS
- ✅ 无需维护服务器
- ✅ 自动扩展

**缺点：**
- ❌ 依赖第三方服务
- ❌ 数据不在本地
- ❌ 无法内网部署
- ❌ 受限于 Cloudflare 政策

### Docker 部署

**优点：**
- ✅ 数据完全自主掌控
- ✅ 可以内网部署
- ✅ 不依赖第三方服务
- ✅ 灵活的备份方案
- ✅ 可以自定义修改

**缺点：**
- ❌ 需要服务器
- ❌ 需要维护
- ❌ 需要配置 HTTPS
- ❌ 无全球 CDN

## 🎯 选择建议

### 选择 Cloudflare Pages 如果：
- 没有服务器
- 需要全球访问
- 不想维护服务器
- 数据量不大

### 选择 Docker 部署如果：
- 有自己的服务器或 NAS
- 需要内网访问
- 重视数据隐私
- 需要完全控制

## 🔮 未来计划

- [ ] 支持 SQLite 数据库
- [ ] 支持 Redis 缓存
- [ ] 支持多用户
- [ ] 支持 S3 对象存储
- [ ] 支持 PostgreSQL/MySQL

## 📞 技术支持

如有问题，请：
1. 查看相关文档
2. 查看容器日志：`docker-compose logs -f`
3. 在 GitHub 提交 Issue
4. 参考 [DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md)
