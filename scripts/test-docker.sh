#!/bin/bash

# CloudNav Docker 测试脚本

echo "🚀 开始构建 CloudNav Docker 镜像..."

# 构建镜像
docker build -t cloudnav:test .

if [ $? -ne 0 ]; then
    echo "❌ 构建失败！"
    exit 1
fi

echo "✅ 构建成功！"
echo ""
echo "🔧 启动测试容器..."

# 停止并删除旧容器（如果存在）
docker stop cloudnav-test 2>/dev/null
docker rm cloudnav-test 2>/dev/null

# 创建数据目录
mkdir -p ./test-data

# 启动容器
docker run -d \
  --name cloudnav-test \
  -p 3000:3000 \
  -e PASSWORD="test123" \
  -e CLOUDNAV_KV_PATH="/app/data" \
  -v $(pwd)/test-data:/app/data \
  cloudnav:test

if [ $? -ne 0 ]; then
    echo "❌ 启动失败！"
    exit 1
fi

echo "✅ 容器启动成功！"
echo ""
echo "📋 容器信息："
docker ps | grep cloudnav-test
echo ""
echo "📝 查看日志："
echo "   docker logs -f cloudnav-test"
echo ""
echo "🌐 访问地址："
echo "   http://localhost:3000"
echo ""
echo "🔑 测试密码："
echo "   test123"
echo ""
echo "🛑 停止测试："
echo "   docker stop cloudnav-test"
echo "   docker rm cloudnav-test"
echo ""
echo "⏳ 等待服务启动（约 5 秒）..."
sleep 5

# 检查服务是否正常
if curl -s http://localhost:3000 > /dev/null; then
    echo "✅ 服务运行正常！"
    echo ""
    echo "🎉 测试完成！现在可以访问 http://localhost:3000"
else
    echo "⚠️  服务可能还在启动中，请稍后访问"
    echo "   或运行: docker logs cloudnav-test 查看日志"
fi
