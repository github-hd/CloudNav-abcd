# 测试脚本说明

本目录包含 CloudNav 项目的测试和验证脚本。

## 📜 脚本列表

### Docker 测试脚本

#### test-docker.sh (Linux/Mac)
```bash
chmod +x test-docker.sh
./test-docker.sh
```

**功能：**
- 构建 Docker 镜像
- 启动测试容器
- 自动健康检查
- 显示访问信息

**测试配置：**
- 端口：3000
- 密码：test123
- 数据目录：./test-data

#### test-docker.bat (Windows)
```cmd
test-docker.bat
```

**功能：** 与 test-docker.sh 相同

### Cloudflare Pages 兼容性验证脚本

#### verify-cloudflare-compatibility.sh (Linux/Mac)
```bash
chmod +x verify-cloudflare-compatibility.sh
./verify-cloudflare-compatibility.sh
```

**功能：**
- 检查 functions 目录完整性
- 检查 Git 配置
- 检查构建脚本
- 检查前端文件
- 检查目录结构
- 生成兼容性报告

#### verify-cloudflare-compatibility.bat (Windows)
```cmd
verify-cloudflare-compatibility.bat
```

**功能：** 与 verify-cloudflare-compatibility.sh 相同

## 🎯 使用场景

### 场景 1：本地测试 Docker 部署

```bash
# 1. 运行 Docker 测试脚本
./scripts/test-docker.sh

# 2. 访问测试环境
# 浏览器打开 http://localhost:3000
# 使用密码 test123 登录

# 3. 测试完成后清理
docker stop cloudnav-test
docker rm cloudnav-test
```

### 场景 2：推送前验证兼容性

```bash
# 1. 运行兼容性验证脚本
./scripts/verify-cloudflare-compatibility.sh

# 2. 确认所有检查通过
# 应该看到 7/7 项通过

# 3. 安全推送代码
git add .
git commit -m "Your commit message"
git push origin main
```

### 场景 3：CI/CD 集成

可以将这些脚本集成到 CI/CD 流程中：

```yaml
# .github/workflows/test.yml
- name: Run Docker test
  run: ./scripts/test-docker.sh

- name: Verify Cloudflare compatibility
  run: ./scripts/verify-cloudflare-compatibility.sh
```

## 📋 检查项说明

### Docker 测试检查项
1. ✅ Docker 镜像构建成功
2. ✅ 容器启动成功
3. ✅ 服务端口可访问
4. ✅ 健康检查通过
5. ✅ 数据目录创建成功

### Cloudflare 兼容性检查项
1. ✅ functions 目录存在
2. ✅ functions 未被 .gitignore 忽略
3. ✅ package.json 构建脚本正确
4. ✅ vite.config.ts 存在
5. ✅ 前端入口文件存在
6. ✅ Docker 文件不影响 CF 部署
7. ✅ 关键目录结构完整

## 🔧 故障排查

### Docker 测试失败

**问题：构建失败**
```bash
# 检查 Docker 是否运行
docker ps

# 检查 Dockerfile 语法
docker build -t test .
```

**问题：容器无法启动**
```bash
# 查看容器日志
docker logs cloudnav-test

# 检查端口占用
netstat -tuln | grep 3000
```

### 兼容性验证失败

**问题：functions 目录不存在**
```bash
# 检查目录
ls -la functions/api/

# 恢复文件（如果误删）
git checkout functions/
```

**问题：构建脚本不正确**
```bash
# 检查 package.json
cat package.json | grep "build"

# 应该看到: "build": "vite build"
```

## 📖 相关文档

- [快速开始](../doc/docker/QUICK_START.md)
- [部署检查清单](../doc/docker/DEPLOYMENT_CHECKLIST.md)
- [兼容性保证](../doc/docker/COMPATIBILITY_GUARANTEE.md)

## 💡 提示

1. **首次使用**：先运行兼容性验证脚本，确保项目结构正确
2. **推送前**：运行 Docker 测试脚本，确保构建成功
3. **定期检查**：在修改项目结构后，重新运行验证脚本
4. **权限问题**：Linux/Mac 用户记得添加执行权限 `chmod +x *.sh`

## 🎉 快速命令

```bash
# 一键测试（Linux/Mac）
cd scripts && chmod +x *.sh && ./verify-cloudflare-compatibility.sh && ./test-docker.sh

# 一键测试（Windows）
cd scripts && verify-cloudflare-compatibility.bat && test-docker.bat
```
