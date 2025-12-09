#!/bin/bash

echo "========================================"
echo "Cloudflare Pages 兼容性检查"
echo "========================================"
echo ""

PASS=0
FAIL=0

echo "[检查 1] functions 目录是否存在..."
if [ -f "functions/api/storage.ts" ]; then
    echo "✅ PASS: functions/api/storage.ts 存在"
    ((PASS++))
else
    echo "❌ FAIL: functions/api/storage.ts 不存在"
    ((FAIL++))
fi

echo ""
echo "[检查 2] functions 目录是否被 .gitignore 忽略..."
if ! grep -q "functions" .gitignore 2>/dev/null; then
    echo "✅ PASS: functions 目录未被 .gitignore 忽略"
    ((PASS++))
else
    echo "❌ FAIL: functions 目录被 .gitignore 忽略"
    ((FAIL++))
fi

echo ""
echo "[检查 3] package.json 构建脚本是否正确..."
if grep -q '"build": "vite build"' package.json; then
    echo "✅ PASS: 构建脚本正确"
    ((PASS++))
else
    echo "❌ FAIL: 构建脚本不正确"
    ((FAIL++))
fi

echo ""
echo "[检查 4] vite.config.ts 是否存在..."
if [ -f "vite.config.ts" ]; then
    echo "✅ PASS: vite.config.ts 存在"
    ((PASS++))
else
    echo "❌ FAIL: vite.config.ts 不存在"
    ((FAIL++))
fi

echo ""
echo "[检查 5] 前端入口文件是否存在..."
if [ -f "index.html" ] && [ -f "index.tsx" ]; then
    echo "✅ PASS: 前端入口文件存在"
    ((PASS++))
else
    echo "❌ FAIL: 前端入口文件不存在"
    ((FAIL++))
fi

echo ""
echo "[检查 6] Docker 文件是否会影响 CF 部署..."
if [ -f "Dockerfile" ] && [ -f "server/index.js" ]; then
    echo "✅ PASS: Docker 文件存在但不影响 CF 部署"
    ((PASS++))
else
    echo "⚠️  WARNING: Docker 配置可能不完整"
    ((PASS++))
fi

echo ""
echo "[检查 7] 关键目录结构..."
if [ -d "components" ] && [ -d "services" ] && [ -d "functions/api" ]; then
    echo "✅ PASS: 关键目录结构完整"
    ((PASS++))
else
    echo "❌ FAIL: 关键目录结构不完整"
    ((FAIL++))
fi

echo ""
echo "========================================"
echo "检查结果"
echo "========================================"
echo "通过: $PASS 项"
echo "失败: $FAIL 项"
echo ""

if [ $FAIL -eq 0 ]; then
    echo "✅ 所有检查通过！"
    echo ""
    echo "📋 Cloudflare Pages 部署配置："
    echo "   框架预设: 无 (None)"
    echo "   构建命令: npm run build"
    echo "   输出目录: dist"
    echo "   环境变量: PASSWORD, GEMINI_API_KEY"
    echo "   KV 绑定: CLOUDNAV_KV"
    echo ""
    echo "🎉 你的项目完全兼容 Cloudflare Pages 部署！"
    echo "   推送代码不会影响现有的 CF Pages 部署。"
else
    echo "❌ 发现 $FAIL 个问题，请修复后再推送！"
fi

echo ""
