# Gin Web + Vue 前后端项目启动指南

## 项目概述
这是一个基于 Gin 框架的后端 API 服务和 Vue3 前端的模组展示平台。

## 技术栈
### 后端 (backend/)
- **框架**: Gin (Go Web框架)  
- **数据库**: SQLite + GORM ORM
- **缓存**: Redis
- **消息队列**: RabbitMQ
- **认证**: JWT
- **日志**: Zap + Lumberjack
- **配置**: Viper

### 前端 (frontend/)
- **框架**: Vue 3 + Composition API
- **构建工具**: Vite
- **HTTP客户端**: Fetch API
- **样式**: 原生CSS

## 快速启动

### 1. 启动后端服务

```bash
cd backend
go mod tidy
go run main.go
```

后端服务将在 `http://localhost:8080` 启动

### 2. 启动前端服务

```bash
cd frontend
npm install
npm run dev
```

前端服务将在 `http://localhost:5173` 启动

## 访问地址
- **前端**: http://localhost:5173
- **后端API**: http://localhost:8080
- **API文档**: 通过前端代理访问 http://localhost:5173/api/*

## API 接口

### 游戏相关
- `GET /api/games` - 获取游戏列表

### 模组相关  
- `GET /api/mods` - 获取模组列表
  - 参数: `page`, `pageSize`, `gameId`, `search`
- `POST /api/mods/:id/download` - 增加下载次数

## 数据库

项目使用 SQLite 数据库，数据库文件为 `backend/mod_platform.db`。

### 数据表结构

#### games 表
- id: 游戏ID
- name: 游戏名称  
- description: 游戏描述
- image_url: 游戏图片URL

#### mods 表  
- id: 模组ID
- name: 模组名称
- description: 模组描述
- game_id: 关联游戏ID
- game: 游戏名称
- version: 版本号
- author: 作者
- downloads: 下载次数
- image_url: 模组图片URL
- tags: 标签(逗号分隔)
- created_at: 创建时间

## 故障排除

### 常见问题

1. **端口被占用**
   ```bash
   lsof -ti:8080 | xargs kill -9  # 杀死8080端口进程
   lsof -ti:5173 | xargs kill -9  # 杀死5173端口进程
   ```

2. **数据库初始化失败**
   ```bash
   rm backend/mod_platform.db  # 删除数据库文件重新初始化
   ```

3. **跨域问题**
   - 确保后端CORS中间件正确配置
   - 确保前端Vite代理配置正确

4. **API调用失败**
   - 检查后端服务是否正常启动
   - 查看浏览器Network面板检查请求详情
   - 检查API响应格式是否正确

## 联系信息
如有问题，请查看项目文档或提交Issue。 