@echo off
chcp 65001 >nul
echo 🚀 开始构建 CloudNav Docker 镜像...
echo.

docker build -t cloudnav:test .

if %errorlevel% neq 0 (
    echo ❌ 构建失败！
    pause
    exit /b 1
)

echo ✅ 构建成功！
echo.
echo 🔧 启动测试容器...

docker stop cloudnav-test 2>nul
docker rm cloudnav-test 2>nul

if not exist "test-data" mkdir test-data

docker run -d --name cloudnav-test -p 3000:3000 -e PASSWORD="test123" -e CLOUDNAV_KV_PATH="/app/data" -v "%cd%/test-data:/app/data" cloudnav:test

if %errorlevel% neq 0 (
    echo ❌ 启动失败！
    pause
    exit /b 1
)

echo ✅ 容器启动成功！
echo.
echo 📋 容器信息：
docker ps | findstr cloudnav-test
echo.
echo 📝 查看日志：
echo    docker logs -f cloudnav-test
echo.
echo 🌐 访问地址：
echo    http://localhost:3000
echo.
echo 🔑 测试密码：
echo    test123
echo.
echo 🛑 停止测试：
echo    docker stop cloudnav-test
echo    docker rm cloudnav-test
echo.
echo ⏳ 等待服务启动（约 5 秒）...
timeout /t 5 /nobreak >nul

curl -s http://localhost:3000 >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ 服务运行正常！
    echo.
    echo 🎉 测试完成！现在可以访问 http://localhost:3000
) else (
    echo ⚠️  服务可能还在启动中，请稍后访问
    echo    或运行: docker logs cloudnav-test 查看日志
)

echo.
pause
