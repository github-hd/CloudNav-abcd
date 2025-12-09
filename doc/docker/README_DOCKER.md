# Docker 部署说明

## 本地测试

在推送到 GitHub 之前，可以先本地测试：

```bash
# 构建镜像
docker build -t cloudnav:test .

# 运行测试
docker run -d \
  --name cloudnav-test \
  -p 3000:3000 \
  -e PASSWORD="test123" \
  -v $(pwd)/data:/app/data \
  cloudnav:test

# 查看日志
docker logs -f cloudnav-test

# 测试完成后清理
docker stop cloudnav-test
docker rm cloudnav-test
```

## GitHub Actions 自动构建

推送代码到 GitHub 后，GitHub Actions 会自动：

1. 构建 Docker 镜像
2. 推送到 GitHub Container Registry (ghcr.io)
3. 支持多平台（amd64/arm64）

### 镜像标签规则

- `main` 分支推送 → `latest` 标签
- 创建 tag `v1.0.0` → `1.0.0`, `1.0`, `1` 标签
- Pull Request → `pr-123` 标签

## 使用已发布的镜像

```bash
# 创建 docker-compose.yml
cat > docker-compose.yml << 'EOF'
version: "3.8"

services:
  cloudnav:
    image: ghcr.io/你的用户名/仓库名:latest
    container_name: cloudnav
    restart: unless-stopped
    ports:
      - "3000:3000"
    environment:
      PASSWORD: "your_password_here"
      CLOUDNAV_KV_PATH: "/app/data"
    volumes:
      - ./data:/app/data
EOF

# 启动服务
docker-compose up -d
```

## 数据结构

数据存储在 `./data/kv.json` 文件中，格式如下：

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
  "search_config": {
    "value": "{...}",
    "expiresAt": null
  },
  "favicon:example.com": {
    "value": "https://...",
    "expiresAt": 1234567890000
  }
}
```

## 环境变量

- `PASSWORD`: 访问密码（必填）
- `CLOUDNAV_KV_PATH`: 数据存储目录，默认 `./data`
- `PORT`: 服务端口，默认 `3000`

## 注意事项

1. **首次运行**：会自动创建 `data` 目录和 `kv.json` 文件
2. **密码保护**：务必设置强密码
3. **数据备份**：定期备份 `./data/kv.json` 文件
4. **端口冲突**：确保 3000 端口未被占用
5. **权限问题**：确保 Docker 有权限访问数据目录
