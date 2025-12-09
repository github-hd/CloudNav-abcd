# 🚀 CloudNav Docker 部署检查清单

## ✅ 文件创建检查

- [x] **Dockerfile** - Docker 镜像构建配置
- [x] **docker-compose.yml** - 生产环境配置
- [x] **docker-compose.dev.yml** - 开发测试配置
- [x] **.dockerignore** - Docker 构建忽略文件
- [x] **.gitignore** - Git 忽略文件
- [x] **.env.example** - 环境变量示例
- [x] **server/index.js** - Express 后端服务
- [x] **server/kv-storage.js** - KV 存储实现
- [x] **server/package.json** - 服务端依赖
- [x] **.github/workflows/docker-build.yml** - GitHub Actions 工作流
- [x] **DOCKER_DEPLOYMENT.md** - 完整部署文档
- [x] **README_DOCKER.md** - Docker 快速指南
- [x] **test-docker.sh** - Linux/Mac 测试脚本
- [x] **test-docker.bat** - Windows 测试脚本

## 📝 部署前准备

### 1. 本地测试（必做）

```bash
# Windows 用户
test-docker.bat

# Linux/Mac 用户
chmod +x test-docker.sh
./test-docker.sh
```

**验证项：**
- [ ] 镜像构建成功
- [ ] 容器启动成功
- [ ] 可以访问 http://localhost:3000
- [ ] 可以使用密码 `test123` 登录
- [ ] 数据可以正常保存
- [ ] 刷新页面数据不丢失

### 2. 推送到 GitHub

```bash
git add .
git commit -m "Add Docker support with backend server"
git push origin main
```

**验证项：**
- [ ] 代码成功推送
- [ ] GitHub Actions 工作流开始运行
- [ ] 工作流构建成功（绿色勾）
- [ ] 镜像推送到 GHCR 成功

### 3. 检查 GitHub Container Registry

访问：`https://github.com/你的用户名?tab=packages`

**验证项：**
- [ ] 可以看到 `cloudnav-abcd` 包
- [ ] 包状态为 Public（或 Private）
- [ ] 有 `latest` 标签
- [ ] 支持 `linux/amd64` 和 `linux/arm64`

### 4. 服务器部署

#### 4.1 创建部署目录

```bash
mkdir -p ~/cloudnav
cd ~/cloudnav
```

#### 4.2 创建 docker-compose.yml

```bash
cat > docker-compose.yml << 'EOF'
version: "3.8"

services:
  cloudnav:
    image: ghcr.io/你的用户名/cloudnav-abcd:latest
    container_name: cloudnav
    restart: unless-stopped
    ports:
      - "3000:3000"
    environment:
      PASSWORD: "你的强密码"
      CLOUDNAV_KV_PATH: "/app/data"
      PORT: "3000"
    volumes:
      - ./data:/app/data
    healthcheck:
      test: ["CMD", "wget", "--quiet", "--tries=1", "--spider", "http://localhost:3000"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
EOF
```

**重要：记得修改：**
- [ ] 替换 `你的用户名` 为实际 GitHub 用户名
- [ ] 替换 `你的强密码` 为安全的密码

#### 4.3 启动服务

```bash
docker-compose up -d
```

#### 4.4 验证部署

```bash
# 查看容器状态
docker-compose ps

# 查看日志
docker-compose logs -f

# 测试访问
curl http://localhost:3000
```

**验证项：**
- [ ] 容器状态为 `Up`
- [ ] 日志显示 "CloudNav server running on port 3000"
- [ ] 日志显示 "Password protection: Enabled"
- [ ] 可以访问 http://服务器IP:3000
- [ ] 可以使用密码登录

## 🔧 配置检查

### 环境变量

- [ ] `PASSWORD` - 已设置强密码
- [ ] `CLOUDNAV_KV_PATH` - 设置为 `/app/data`
- [ ] `PORT` - 设置为 `3000`（或其他端口）

### 数据持久化

- [ ] Volume 映射正确：`./data:/app/data`
- [ ] 数据目录已创建
- [ ] 数据文件 `./data/kv.json` 可以正常读写

### 网络访问

- [ ] 端口映射正确
- [ ] 防火墙已开放端口
- [ ] 可以从外网访问（如需要）

## 🎯 功能测试

### 基础功能

- [ ] 登录功能正常
- [ ] 添加链接功能正常
- [ ] 编辑链接功能正常
- [ ] 删除链接功能正常
- [ ] 分类管理功能正常
- [ ] 搜索功能正常

### 数据持久化

- [ ] 添加数据后重启容器，数据不丢失
- [ ] 查看 `./data/kv.json` 文件，数据已保存

### 配置功能

- [ ] AI 配置可以保存
- [ ] 搜索配置可以保存
- [ ] 网站配置可以保存

## 🔒 安全检查

- [ ] 使用强密码（至少 12 位，包含大小写字母、数字、特殊字符）
- [ ] 数据目录权限正确（不要 777）
- [ ] 如果公网访问，考虑使用 HTTPS（Nginx/Caddy 反向代理）
- [ ] 定期备份 `./data/kv.json` 文件

## 📊 性能检查

- [ ] 容器内存使用正常（< 200MB）
- [ ] 容器 CPU 使用正常（< 5%）
- [ ] 响应速度正常（< 1s）
- [ ] 日志无异常错误

## 🔄 更新流程

### 更新镜像

```bash
# 拉取最新镜像
docker-compose pull

# 重启服务
docker-compose up -d
```

### 回滚版本

```bash
# 修改 docker-compose.yml 中的镜像标签
# image: ghcr.io/你的用户名/cloudnav-abcd:v1.0.0

# 重启服务
docker-compose up -d
```

## 💾 备份恢复

### 备份

```bash
# 备份数据文件
cp ./data/kv.json ./data/kv.json.backup.$(date +%Y%m%d)

# 或打包整个数据目录
tar -czf cloudnav-backup-$(date +%Y%m%d).tar.gz ./data
```

### 恢复

```bash
# 停止服务
docker-compose down

# 恢复数据
cp ./data/kv.json.backup.20241209 ./data/kv.json

# 重启服务
docker-compose up -d
```

## 🐛 常见问题

### 容器无法启动

1. 查看日志：`docker-compose logs`
2. 检查端口占用：`netstat -tuln | grep 3000`
3. 检查数据目录权限：`ls -la ./data`

### 无法访问

1. 检查容器状态：`docker-compose ps`
2. 检查防火墙：`sudo ufw status`
3. 检查端口映射：`docker port cloudnav`

### 数据丢失

1. 检查 volume 映射是否正确
2. 检查 `./data/kv.json` 文件是否存在
3. 恢复备份文件

### 密码错误

1. 检查 `docker-compose.yml` 中的 `PASSWORD` 环境变量
2. 重启容器：`docker-compose restart`
3. 查看日志确认密码已加载

## ✅ 部署完成

恭喜！如果以上所有检查项都通过，说明 CloudNav 已成功部署！

**访问地址：** http://你的服务器IP:3000

**下一步：**
1. 配置反向代理（Nginx/Caddy）实现 HTTPS
2. 设置定期备份任务
3. 配置 AI 功能（如需要）
4. 导入现有书签数据

## 📞 获取帮助

如遇到问题：
1. 查看 [DOCKER_DEPLOYMENT.md](DOCKER_DEPLOYMENT.md) 完整文档
2. 查看 [README_DOCKER.md](README_DOCKER.md) 快速指南
3. 在 GitHub 提交 Issue
4. 查看容器日志：`docker-compose logs -f`
