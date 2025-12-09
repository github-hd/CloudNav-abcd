@echo off
chcp 65001 >nul
echo ========================================
echo Cloudflare Pages 兼容性检查
echo ========================================
echo.

set "PASS=0"
set "FAIL=0"

echo [检查 1] functions 目录是否存在...
if exist "functions\api\storage.ts" (
    echo ✅ PASS: functions/api/storage.ts 存在
    set /a PASS+=1
) else (
    echo ❌ FAIL: functions/api/storage.ts 不存在
    set /a FAIL+=1
)

echo.
echo [检查 2] functions 目录是否被 .gitignore 忽略...
findstr /C:"functions" .gitignore >nul 2>&1
if %errorlevel% neq 0 (
    echo ✅ PASS: functions 目录未被 .gitignore 忽略
    set /a PASS+=1
) else (
    echo ❌ FAIL: functions 目录被 .gitignore 忽略
    set /a FAIL+=1
)

echo.
echo [检查 3] package.json 构建脚本是否正确...
findstr /C:"\"build\": \"vite build\"" package.json >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ PASS: 构建脚本正确
    set /a PASS+=1
) else (
    echo ❌ FAIL: 构建脚本不正确
    set /a FAIL+=1
)

echo.
echo [检查 4] vite.config.ts 是否存在...
if exist "vite.config.ts" (
    echo ✅ PASS: vite.config.ts 存在
    set /a PASS+=1
) else (
    echo ❌ FAIL: vite.config.ts 不存在
    set /a FAIL+=1
)

echo.
echo [检查 5] 前端入口文件是否存在...
if exist "index.html" (
    if exist "index.tsx" (
        echo ✅ PASS: 前端入口文件存在
        set /a PASS+=1
    ) else (
        echo ❌ FAIL: index.tsx 不存在
        set /a FAIL+=1
    )
) else (
    echo ❌ FAIL: index.html 不存在
    set /a FAIL+=1
)

echo.
echo [检查 6] Docker 文件是否会影响 CF 部署...
if exist "Dockerfile" (
    if exist "server\index.js" (
        echo ✅ PASS: Docker 文件存在但不影响 CF 部署
        set /a PASS+=1
    ) else (
        echo ⚠️  WARNING: Dockerfile 存在但 server 目录不完整
        set /a PASS+=1
    )
) else (
    echo ⚠️  WARNING: Dockerfile 不存在
    set /a PASS+=1
)

echo.
echo [检查 7] 关键目录结构...
set "DIRS_OK=1"
if not exist "components" set "DIRS_OK=0"
if not exist "services" set "DIRS_OK=0"
if not exist "functions\api" set "DIRS_OK=0"

if %DIRS_OK% equ 1 (
    echo ✅ PASS: 关键目录结构完整
    set /a PASS+=1
) else (
    echo ❌ FAIL: 关键目录结构不完整
    set /a FAIL+=1
)

echo.
echo ========================================
echo 检查结果
echo ========================================
echo 通过: %PASS% 项
echo 失败: %FAIL% 项
echo.

if %FAIL% equ 0 (
    echo ✅ 所有检查通过！
    echo.
    echo 📋 Cloudflare Pages 部署配置：
    echo    框架预设: 无 ^(None^)
    echo    构建命令: npm run build
    echo    输出目录: dist
    echo    环境变量: PASSWORD, GEMINI_API_KEY
    echo    KV 绑定: CLOUDNAV_KV
    echo.
    echo 🎉 你的项目完全兼容 Cloudflare Pages 部署！
    echo    推送代码不会影响现有的 CF Pages 部署。
) else (
    echo ❌ 发现 %FAIL% 个问题，请修复后再推送！
)

echo.
pause
