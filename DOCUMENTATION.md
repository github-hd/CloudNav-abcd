# 📚 CloudNav 文档中心

## 📖 文档结构

```
CloudNav-abcd/
├── README.md                          # 项目主文档
├── DOCUMENTATION.md                   # 本文档（文档索引）
├── doc/
│   ├── docker/                        # Docker 部署文档
│   │   ├── README.md                  # Docker 文档索引
│   │   ├── QUICK_START.md             # 快速开始 ⭐
│   │   ├── DOCKER_DEPLOYMENT.md       # 完整部署指南
│   │   ├── DEPLOYMENT_CHECKLIST.md    # 部署检查清单
│   │   ├── DOCKER_MIGRATION_GUIDE.md  # 迁移指南
│   │   ├── DOCKER_SETUP_SUMMARY.md    # 配置总结
│   │   ├── README_DOCKER.md           # 技术参考
│   │   ├── CLOUDFLARE_COMPATIBILITY.md # 兼容性分析 ⭐
│   │   └── COMPATIBILITY_GUARANTEE.md  # 兼容性保证 ⭐
│   └── 图文教程.docx                   # Cloudflare Pages 部署教程
└── scripts/                           # 测试脚本
    ├── README.md                      # 脚本说明
    ├── test-docker.sh                 # Docker 测试（Linux/Mac）
    ├── test-docker.bat                # Docker 测试（Windows）
    ├── verify-cloudflare-compatibility.sh  # 兼容性验证（Linux/Mac）
    └── verify-cloudflare-compatibility.bat # 兼容性验证（Windows）
```

## 🎯 快速导航

### 🚀 部署相关

#### Cloudflare Pages 部署
- **[图文教程](doc/图文教程.docx)** - 保姆级部署教程
- **[README.md](README.md#-部署教程)** - 简明部署步骤

#### Docker 部署
- **[快速开始](doc/docker/QUICK_START.md)** ⭐ 一分钟部署
- **[完整部署指南](doc/docker/DOCKER_DEPLOYMENT.md)** - 详细步骤
- **[部署检查清单](doc/docker/DEPLOYMENT_CHECKLIST.md)** - 验证部署

### 🔄 迁移相关

- **[迁移指南](doc/docker/DOCKER_MIGRATION_GUIDE.md)** - 从 CF Pages 到 Docker
- **[兼容性保证](doc/docker/COMPATIBILITY_GUARANTEE.md)** ⭐ 不影响现有部署
- **[兼容性分析](doc/docker/CLOUDFLARE_COMPATIBILITY.md)** - 技术细节

### 🔧 开发相关

- **[测试脚本说明](scripts/README.md)** - 脚本使用指南
- **[配置总结](doc/docker/DOCKER_SETUP_SUMMARY.md)** - 技术架构
- **[技术参考](doc/docker/README_DOCKER.md)** - 数据结构

## 📋 按场景查找文档

### 场景 1：首次部署（无服务器）

**推荐：Cloudflare Pages 部署**

1. 阅读 [图文教程](doc/图文教程.docx)
2. 按照 [README 部署步骤](README.md#-部署教程) 操作
3. 配置 KV 和环境变量
4. 完成部署

### 场景 2：首次部署（有服务器/NAS）

**推荐：Docker 部署**

1. 阅读 [快速开始](doc/docker/QUICK_START.md)
2. 运行测试脚本验证：`./scripts/test-docker.sh`
3. 按照 [完整部署指南](doc/docker/DOCKER_DEPLOYMENT.md) 操作
4. 使用 [部署检查清单](doc/docker/DEPLOYMENT_CHECKLIST.md) 验证

### 场景 3：已有 CF Pages 部署，想添加 Docker 支持

**关注：兼容性保证**

1. 阅读 [兼容性保证](doc/docker/COMPATIBILITY_GUARANTEE.md) ⭐
2. 运行兼容性验证：`./scripts/verify-cloudflare-compatibility.sh`
3. 确认所有检查通过
4. 安全推送代码
5. CF Pages 继续正常工作，同时获得 Docker 部署能力

### 场景 4：从 CF Pages 迁移到 Docker

**关注：数据迁移**

1. 阅读 [迁移指南](doc/docker/DOCKER_MIGRATION_GUIDE.md)
2. 导出 CF KV 数据
3. 转换数据格式
4. 部署 Docker 版本
5. 导入数据

### 场景 5：开发和测试

**关注：测试脚本**

1. 阅读 [测试脚本说明](scripts/README.md)
2. 运行 Docker 测试：`./scripts/test-docker.sh`
3. 运行兼容性验证：`./scripts/verify-cloudflare-compatibility.sh`
4. 查看 [技术参考](doc/docker/README_DOCKER.md)

## 🎓 推荐学习路径

### 新手用户

```
1. README.md（了解项目）
   ↓
2. 图文教程.docx 或 QUICK_START.md（选择部署方式）
   ↓
3. DEPLOYMENT_CHECKLIST.md（验证部署）
   ↓
4. 开始使用
```

### 进阶用户

```
1. DOCKER_DEPLOYMENT.md（深入了解）
   ↓
2. DOCKER_MIGRATION_GUIDE.md（理解架构）
   ↓
3. CLOUDFLARE_COMPATIBILITY.md（技术细节）
   ↓
4. 自定义配置
```

### 开发者

```
1. DOCKER_SETUP_SUMMARY.md（技术架构）
   ↓
2. README_DOCKER.md（数据结构）
   ↓
3. scripts/README.md（测试方法）
   ↓
4. 贡献代码
```

## 🔍 按关键词查找

### 部署
- [Cloudflare Pages 部署](doc/图文教程.docx)
- [Docker 快速部署](doc/docker/QUICK_START.md)
- [完整部署指南](doc/docker/DOCKER_DEPLOYMENT.md)
- [部署检查清单](doc/docker/DEPLOYMENT_CHECKLIST.md)

### 兼容性
- [兼容性保证](doc/docker/COMPATIBILITY_GUARANTEE.md) ⭐
- [兼容性分析](doc/docker/CLOUDFLARE_COMPATIBILITY.md)
- [兼容性验证脚本](scripts/verify-cloudflare-compatibility.sh)

### 迁移
- [迁移指南](doc/docker/DOCKER_MIGRATION_GUIDE.md)
- [数据格式转换](doc/docker/DOCKER_MIGRATION_GUIDE.md#-数据格式)

### 测试
- [Docker 测试脚本](scripts/test-docker.sh)
- [兼容性验证脚本](scripts/verify-cloudflare-compatibility.sh)
- [测试脚本说明](scripts/README.md)

### 配置
- [环境变量配置](doc/docker/DOCKER_DEPLOYMENT.md#-环境变量说明)
- [Docker Compose 配置](docker-compose.yml)
- [配置总结](doc/docker/DOCKER_SETUP_SUMMARY.md)

### 故障排查
- [常见问题](doc/docker/QUICK_START.md#-故障排查)
- [部署问题](doc/docker/DEPLOYMENT_CHECKLIST.md#-常见问题)
- [兼容性问题](doc/docker/COMPATIBILITY_GUARANTEE.md#-常见问题)

## 📞 获取帮助

### 文档相关
1. 查看本文档索引
2. 阅读相关文档
3. 运行测试脚本

### 技术问题
1. 查看 [故障排查](#故障排查) 部分
2. 查看容器日志：`docker-compose logs -f`
3. 在 GitHub 提交 Issue

### 部署问题
1. 使用 [部署检查清单](doc/docker/DEPLOYMENT_CHECKLIST.md)
2. 运行验证脚本
3. 查看相关文档

## 🎉 快速命令

```bash
# 查看所有文档
ls -la doc/docker/

# 查看所有脚本
ls -la scripts/

# 运行 Docker 测试
./scripts/test-docker.sh

# 验证兼容性
./scripts/verify-cloudflare-compatibility.sh

# 查看容器日志
docker-compose logs -f

# 重启服务
docker-compose restart
```

## 🔗 外部资源

- [Cloudflare Pages 文档](https://developers.cloudflare.com/pages/)
- [Docker 官方文档](https://docs.docker.com/)
- [Docker Compose 文档](https://docs.docker.com/compose/)
- [GitHub Actions 文档](https://docs.github.com/actions)

## 📝 文档维护

- 所有 Docker 相关文档位于 `doc/docker/`
- 所有测试脚本位于 `scripts/`
- 主文档为 `README.md`
- 本索引文档为 `DOCUMENTATION.md`

---

**最后更新：** 2024-12-09  
**文档版本：** 1.0  
**项目版本：** v1.6 + Docker Support
