#!/bin/bash

echo "🛑 停止 Gin Web + Vue 项目"
echo "=========================="

# 读取PID文件并停止服务
if [ -f .backend.pid ]; then
    BACKEND_PID=$(cat .backend.pid)
    if kill -0 $BACKEND_PID 2>/dev/null; then
        kill $BACKEND_PID
        echo "✅ 后端服务已停止 (PID: $BACKEND_PID)"
    else
        echo "⚠️  后端服务未运行"
    fi
    rm .backend.pid
else
    echo "⚠️  未找到后端PID文件"
fi

if [ -f .frontend.pid ]; then
    FRONTEND_PID=$(cat .frontend.pid)
    if kill -0 $FRONTEND_PID 2>/dev/null; then
        kill $FRONTEND_PID
        echo "✅ 前端服务已停止 (PID: $FRONTEND_PID)"
    else
        echo "⚠️  前端服务未运行"
    fi
    rm .frontend.pid
else
    echo "⚠️  未找到前端PID文件"
fi

# 清理可能残留的进程
echo "🧹 清理残留进程..."
pkill -f "go run main.go" 2>/dev/null
pkill -f "vite" 2>/dev/null

echo "🎉 项目已停止" 