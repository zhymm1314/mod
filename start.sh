#!/bin/bash

echo "🚀 启动 Gin Web + Vue 项目"
echo "=========================="

# 检查Go环境
if ! command -v go &> /dev/null; then
    echo "❌ Go 未安装，请先安装 Go 环境"
    exit 1
fi

# 检查Node环境
if ! command -v npm &> /dev/null; then
    echo "❌ Node.js/npm 未安装，请先安装 Node.js 环境"
    exit 1
fi

echo "✅ 环境检查通过"

# 启动后端服务
echo "🔧 启动后端服务..."
cd backend
go mod tidy
nohup go run main.go > backend.log 2>&1 &
BACKEND_PID=$!
echo "后端服务已启动，PID: $BACKEND_PID"
cd ..

# 等待后端启动
echo "⏳ 等待后端服务启动..."
sleep 3

# 检查后端是否启动成功
if curl -s http://localhost:8080/api/games > /dev/null; then
    echo "✅ 后端服务启动成功"
else
    echo "❌ 后端服务启动失败"
    kill $BACKEND_PID 2>/dev/null
    exit 1
fi

# 启动前端服务
echo "🎨 启动前端服务..."
cd frontend
npm install
npm run dev &
FRONTEND_PID=$!
echo "前端服务已启动，PID: $FRONTEND_PID"
cd ..

echo ""
echo "🎉 启动完成！"
echo "=========================="
echo "前端地址: http://localhost:5173"
echo "后端地址: http://localhost:8080"
echo ""
echo "📝 日志文件: backend/backend.log"
echo ""
echo "🛑 停止服务:"
echo "   kill $BACKEND_PID  # 停止后端"
echo "   kill $FRONTEND_PID # 停止前端"
echo ""
echo "或者运行: ./stop.sh"

# 保存PID到文件
echo "$BACKEND_PID" > .backend.pid
echo "$FRONTEND_PID" > .frontend.pid 