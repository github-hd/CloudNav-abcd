# 🚀 CloudNav Docker 快速开始

## 一分钟部署

### 方式一：使用已构建的镜像（推荐）

```bash
# 1. 创建目录
mkdir cloudnav && cd cloudnav

# 2. 创建配置文件
cat > docker-compose.yml << 'EOF'
version: "3.8"
services:
  cloudnav:
    image: ghcr.io/你的GitHub用户名/cloudnav-abcd:latest
    container_name: cloudnav
    restart: unless-stopped
    ports:
      - "3000:3000"
    environment:
      PASSWORD: "修改为你的密码"
      CLOUDNAV_KV_PATH: "/app/data"
    volumes:
      - ./data:/app/data
EOF

# 3. 启动服务
docker-compose up -d

# 4. 访问
# 打开浏览器访问 http://localhost:3000
```

### 方式二：本地构建

```bash
# 1. 克隆项目
git clone https://github.com/你的用户名/CloudNav-abcd.git
cd CloudNav-abcd

# 2. 构建并启动
docker-compose -f docker-compose.dev.yml up -d

# 3. 访问
# 打开浏览器访问 http://localhost:3000
```

## 测试部署

### Windows

```cmd
test-docker.bat
```

### Linux/Mac

```bash
chmod +x test-docker.sh
./test-docker.sh
```

测试密码：`test123`

## 常用命令

```bash
# 查看状态
docker-compose ps

# 查看日志
docker-compose logs -f

# 重启服务
docker-compose restart

# 停止服务
docker-compose down

# 更新镜像
docker-compose pull && docker-compose up -d

# 备份数据
cp ./data/kv.json ./data/kv.json.backup
```

## 环境变量

| 变量 | 说明 | 示例 |
|------|------|------|
| PASSWORD | 访问密码（必填） | `my_secure_password` |
| CLOUDNAV_KV_PATH | 数据存储路径 | `/app/data` |
| PORT | 服务端口 | `3000` |

## 数据位置

所有数据存储在：`./data/kv.json`

## 端口配置

默认端口：`3000`

修改端口：编辑 `docker-compose.yml` 中的 `ports` 配置

```yaml
ports:
  - "8080:3000"  # 使用 8080 端口
```

## 反向代理

### Nginx

```nginx
server {
    listen 80;
    server_name nav.example.com;
    
    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

### Caddy

```
nav.example.com {
    reverse_proxy localhost:3000
}
```

## 故障排查

### 容器无法启动

```bash
# 查看日志
docker logs cloudnav

# 检查端口
netstat -tuln | grep 3000

# 检查权限
ls -la ./data
```

### 无法访问

1. 检查容器状态：`docker ps`
2. 检查防火墙：`sudo ufw allow 3000`
3. 检查端口映射：`docker port cloudnav`

### 忘记密码

编辑 `docker-compose.yml`，修改 `PASSWORD` 环境变量，然后重启：

```bash
docker-compose restart
```

## 下一步

- 📖 [完整部署文档](DOCKER_DEPLOYMENT.md)
- ✅ [部署检查清单](DEPLOYMENT_CHECKLIST.md)
- 🔄 [迁移指南](DOCKER_MIGRATION_GUIDE.md)
- 📝 [配置总结](DOCKER_SETUP_SUMMARY.md)

## 获取帮助

- GitHub Issues: 提交问题
- 查看日志: `docker-compose logs -f`
- 查看文档: 阅读上述文档

---

**🎉 享受你的私有导航站！**
