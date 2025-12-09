# Docker 部署文档索引

本目录包含 CloudNav Docker 部署的完整文档。

## 📚 文档列表

### 🚀 快速开始
- **[QUICK_START.md](QUICK_START.md)** ⭐ 推荐首先阅读
  - 一分钟快速部署
  - 常用命令
  - 故障排查

### 📖 完整指南
- **[DOCKER_DEPLOYMENT.md](DOCKER_DEPLOYMENT.md)**
  - 详细部署步骤
  - 环境变量说明
  - 数据持久化
  - 反向代理配置
  - 从 Cloudflare Pages 迁移

### ✅ 部署检查
- **[DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md)**
  - 部署前检查清单
  - 功能测试清单
  - 安全检查清单
  - 常见问题排查

### 🔄 迁移指南
- **[DOCKER_MIGRATION_GUIDE.md](DOCKER_MIGRATION_GUIDE.md)**
  - 从 Cloudflare Pages 到 Docker 的迁移
  - 架构变化说明
  - API 兼容性说明
  - 数据格式转换

### 📋 配置总结
- **[DOCKER_SETUP_SUMMARY.md](DOCKER_SETUP_SUMMARY.md)**
  - 已创建文件列表
  - 使用流程
  - 技术架构
  - 下一步操作

### 🔧 技术参考
- **[README_DOCKER.md](README_DOCKER.md)**
  - 本地测试方法
  - GitHub Actions 说明
  - 数据结构说明
  - 注意事项

### 🛡️ 兼容性保证
- **[CLOUDFLARE_COMPATIBILITY.md](CLOUDFLARE_COMPATIBILITY.md)** ⭐ 重要
  - 详细兼容性分析
  - 文件结构对比
  - 验证测试方法
  - 技术原理说明

- **[COMPATIBILITY_GUARANTEE.md](COMPATIBILITY_GUARANTEE.md)** ⭐ 重要
  - 官方兼容性声明
  - 验证结果
  - 关键保证
  - 常见问题

## 🎯 推荐阅读顺序

### 新手用户
1. [QUICK_START.md](QUICK_START.md) - 快速开始
2. [COMPATIBILITY_GUARANTEE.md](COMPATIBILITY_GUARANTEE.md) - 了解兼容性
3. [DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md) - 部署检查

### 进阶用户
1. [DOCKER_DEPLOYMENT.md](DOCKER_DEPLOYMENT.md) - 完整部署
2. [DOCKER_MIGRATION_GUIDE.md](DOCKER_MIGRATION_GUIDE.md) - 迁移指南
3. [CLOUDFLARE_COMPATIBILITY.md](CLOUDFLARE_COMPATIBILITY.md) - 技术细节

### 从 Cloudflare Pages 迁移
1. [COMPATIBILITY_GUARANTEE.md](COMPATIBILITY_GUARANTEE.md) - 确认兼容性
2. [DOCKER_MIGRATION_GUIDE.md](DOCKER_MIGRATION_GUIDE.md) - 迁移步骤
3. [DOCKER_DEPLOYMENT.md](DOCKER_DEPLOYMENT.md) - 部署实施

## 🔧 测试脚本

测试脚本位于 `../../scripts/` 目录：

- `test-docker.sh` / `test-docker.bat` - Docker 构建和运行测试
- `verify-cloudflare-compatibility.sh` / `verify-cloudflare-compatibility.bat` - Cloudflare Pages 兼容性验证

## 📞 获取帮助

- 查看相关文档
- 运行测试脚本
- 查看容器日志：`docker-compose logs -f`
- 在 GitHub 提交 Issue

## 🔗 相关链接

- [项目主 README](../../README.md)
- [Docker Compose 配置](../../docker-compose.yml)
- [Dockerfile](../../Dockerfile)
- [GitHub Actions 工作流](../../.github/workflows/docker-build.yml)
