# 🚀 Gin-Web 全栈项目

> 嘿！这是一个现代化的全栈Web应用 ✨  
> 用 **Go + Gin** 做后端，**Vue 3 + Vite** 做前端，还有 **Cursor AI** 助力开发！

## 🎯 这个项目能做什么？

- ✅ 用户注册登录，JWT认证安全可靠
- ✅ RESTful API设计，前后端分离
- ✅ 响应式前端界面，移动端友好
- ✅ Docker一键部署，开发生产都轻松
- ✅ Cursor AI编程助手，让开发更智能

## 🚀 快速开始

### 方式一：Docker 一键启动（推荐新手）

```bash
# 1. 克隆项目
git clone <项目地址>
cd gin-web

# 2. 一键启动所有服务
docker-compose up -d

# 3. 打开浏览器访问
# 前端: http://localhost:3000
# 后端API: http://localhost:8081
```

### 方式二：本地开发（推荐开发者）

```bash
# 1. 启动数据库服务（MySQL + Redis）
# 请确保已安装并启动 MySQL 8.0+ 和 Redis 6.0+

# 2. 一键启动项目
chmod +x start.sh
./start.sh

# 3. 停止服务
./stop.sh
```

## 🛠️ 技术栈

### 后端 (Go + Gin)
- **Web框架**: Gin - 轻量高性能
- **数据库**: MySQL + GORM - 可靠的数据存储
- **缓存**: Redis - 提升响应速度
- **认证**: JWT - 安全的用户认证
- **日志**: Zap - 结构化日志管理

### 前端 (Vue 3 + Vite)
- **框架**: Vue 3 - 现代化前端框架
- **构建**: Vite - 极速开发体验
- **样式**: 响应式设计，移动端适配

### 开发工具
- **AI助手**: Cursor AI - 智能编程辅助
- **容器化**: Docker - 环境一致性
- **版本控制**: Git - 代码管理

## 📁 项目结构

```
gin-web/
├── 🚀 快速启动
│   ├── start.sh              # 一键启动脚本
│   ├── stop.sh               # 停止服务脚本
│   └── docker-compose.yml    # Docker编排配置
├── 🤖 AI助手配置
│   └── .cursor/rules/        # Cursor AI开发规则
├── 📚 项目文档
│   └── docs/                 # 详细文档（按开发维度组织）
├── ⚙️ 后端服务
│   └── backend/              # Go + Gin 后端代码
└── 🎨 前端应用
    └── frontend/             # Vue 3 + Vite 前端代码
```

## 🔌 API接口

### 用户认证
```bash
POST /api/auth/register    # 用户注册
POST /api/auth/login       # 用户登录
GET  /api/auth/info        # 获取用户信息（需登录）
POST /api/auth/logout      # 用户登出
```

### 系统接口
```bash
GET /api/ping              # 健康检查
GET /api/test              # 测试接口
```

## 🤖 Cursor AI 编程助手

这个项目专门为 **Cursor AI** 优化，让你的开发效率翻倍！

### 智能开发规则
我们准备了5套专业规则文件：

- **🔧 后端开发**: `@backend-guide.mdc` - Go+Gin MVC架构指导
- **🎨 前端开发**: `@frontend-guide.mdc` - Vue3响应式布局解决方案  
- **🧪 测试开发**: `@testing-guide.mdc` - 完整测试策略
- **💬 AI交流**: `@communication-guide.mdc` - 5种专业交流模式
- **📚 文档管理**: `@documentation-guide.mdc` - 文档规范

### 使用方法
```bash
# 后端开发时
@backend-guide.mdc 帮我实现用户登录API

# 前端开发时  
@frontend-guide.mdc 创建响应式用户界面

# 测试开发时
@testing-guide.mdc 为登录功能写测试用例
```

## 📚 详细文档

想了解更多？我们按开发维度整理了详细文档：

- **📋 [文档导航](docs/README.md)** - 5分钟快速上手指南
- **🎯 需求设计** - 产品需求、技术方案、API设计
- **🎨 前端开发** - Vue3规范、UI设计系统
- **⚙️ 后端开发** - Go规范、Gin框架、MVC架构
- **🧪 测试验证** - 测试策略、单元测试、集成测试

## 🔧 环境要求

### Docker部署（推荐）
- Docker 20.0+
- Docker Compose 2.0+

### 本地开发
- Go 1.22.3+
- Node.js 16.0+
- MySQL 8.0+
- Redis 6.0+

## 🐛 遇到问题？

1. **查看文档**: [详细安装指南](docs/README.md)
2. **检查日志**: `docker-compose logs -f`
3. **提交Issue**: 描述问题，我们会及时回复
4. **联系我们**: 随时欢迎交流讨论

## 🤝 参与贡献

欢迎你的参与！让这个项目变得更好：

1. Fork 项目
2. 创建特性分支 (`git checkout -b feature/amazing-feature`)
3. 提交代码 (`git commit -m 'Add amazing feature'`)
4. 推送分支 (`git push origin feature/amazing-feature`)
5. 创建 Pull Request

## 📄 开源协议

MIT License - 自由使用，欢迎贡献 ❤️

---

**Happy Coding! 🎉** 
*让我们一起用AI的力量，创造更好的代码！* 

## 🗓️ 最后更新

**2025-06-16** 