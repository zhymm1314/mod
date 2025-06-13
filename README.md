# Gin-Web 全栈项目

一个基于 **Go + Gin** 后端和 **Vue 3 + Vite** 前端的全栈Web应用项目，采用前后端分离架构。

## 🚀 技术栈

### 后端技术栈
- **框架**: Gin (Go语言Web框架)
- **数据库**: MySQL 8.0+
- **ORM**: GORM
- **缓存**: Redis
- **消息队列**: RabbitMQ
- **认证**: JWT (JSON Web Token)
- **配置管理**: Viper
- **日志**: Zap + Lumberjack
- **API文档**: 基于注释生成
- **部署**: Docker + Docker Compose

### 前端技术栈
- **框架**: Vue 3
- **构建工具**: Vite
- **开发工具**: Vue DevTools
- **模块系统**: ES Modules
- **包管理**: npm

### 开发工具
- **容器化**: Docker
- **进程管理**: Shell脚本
- **代码编辑**: 支持VSCode + Cursor

## 📋 功能特性

- ✅ 用户注册/登录/认证
- ✅ JWT token管理和黑名单机制
- ✅ RESTful API设计
- ✅ 统一错误处理和响应格式
- ✅ 请求参数验证
- ✅ 跨域支持
- ✅ 日志管理和轮转
- ✅ 配置文件管理
- ✅ 数据库迁移
- ✅ Redis缓存
- ✅ RabbitMQ消息队列
- ✅ Docker容器化部署

## 📁 项目目录结构

```
├── README.md                 # 项目说明文档
├── docker-compose.yml        # Docker编排配置
├── start.sh                  # 项目启动脚本
├── stop.sh                   # 项目停止脚本
├── 项目启动指南.md           # 详细启动指南
├── 项目状态报告.md           # 项目状态报告
├── mysql/                    # MySQL数据库相关文件
├── backend/                  # 后端Go项目
│   ├── main.go              # 项目入口文件
│   ├── go.mod               # Go模块依赖
│   ├── config.yaml          # 配置文件
│   ├── Dockerfile           # Docker构建文件
│   ├── app/                 # 应用核心代码
│   │   ├── controllers/     # 控制器层
│   │   ├── services/        # 服务层
│   │   ├── models/          # 数据模型层
│   │   ├── middleware/      # 中间件
│   │   ├── common/          # 公共模块
│   │   ├── api/             # API相关
│   │   └── ampq/            # 消息队列处理
│   ├── bootstrap/           # 应用启动引导
│   ├── config/              # 配置管理
│   ├── global/              # 全局变量
│   ├── routes/              # 路由定义
│   ├── storage/             # 存储目录
│   └── utils/               # 工具函数
└── frontend/                # 前端Vue项目
    ├── package.json         # 前端依赖配置
    ├── vite.config.js       # Vite配置
    ├── Dockerfile           # Docker构建文件
    ├── src/                 # 源码目录
    │   ├── App.vue          # 根组件
    │   ├── main.js          # 入口文件
    │   ├── components/      # 组件目录
    │   └── assets/          # 静态资源
    └── public/              # 公共文件
```

## 🛠️ 安装教程

### 部署方式选择

| 部署方式 | 适用场景 | 优点 | 缺点 |
|---------|----------|------|------|
| **Docker部署** | 生产环境、快速体验 | 环境一致、一键启动、包含所有依赖 | 需要Docker环境 |
| **本地脚本部署** | 本地开发、调试 | 启动快速、便于调试 | 需要手动安装依赖 |
| **手动分步部署** | 学习理解、自定义配置 | 完全控制、便于学习 | 步骤繁琐 |

### 环境要求

#### Docker部署环境
- **Docker**: 20.0+
- **Docker Compose**: 2.0+

#### 本地开发环境  
- **Go**: 1.22.3+
- **Node.js**: 16.0+
- **MySQL**: 8.0+
- **Redis**: 6.0+
- **RabbitMQ**: 3.8+ (可选)

### 方式一：Docker 一键部署（推荐）

1. **克隆项目**
```bash
git clone <项目地址>
cd gin-web
```

2. **启动所有服务**
```bash
# 使用Docker Compose启动所有服务（包括后端、前端、数据库等）
docker-compose up -d
```

3. **访问应用**
- 前端地址: http://localhost:3000
- 后端API: http://localhost:8081

4. **停止服务**
```bash
# 停止并删除所有容器
docker-compose down
```

5. **查看服务状态**
```bash
# 查看运行中的容器
docker-compose ps

# 查看服务日志
docker-compose logs -f
```

### 方式二：本地开发部署

#### 使用一键脚本（推荐本地开发）

1. **确保环境依赖**
   - Go 1.22.3+
   - Node.js 16.0+
   - MySQL 8.0+（需要预先启动）
   - Redis 6.0+（需要预先启动）

2. **启动所有服务**
```bash
# 给脚本执行权限
chmod +x start.sh stop.sh

# 一键启动后端和前端服务
./start.sh
```

3. **停止服务**
```bash
./stop.sh
```

#### 手动分步部署

##### 后端部署

1. **进入后端目录**
```bash
cd backend
```

2. **安装Go依赖**
```bash
go mod tidy
```

3. **配置文件**
```bash
# 复制配置文件模板（如果存在）
cp example-config.yaml config.yaml
# 根据实际环境修改配置
vim config.yaml
```

4. **启动MySQL和Redis服务**
```bash
# MySQL (请根据你的系统选择)
brew services start mysql     # macOS
sudo systemctl start mysql   # Linux

# Redis
brew services start redis     # macOS  
sudo systemctl start redis    # Linux
```

5. **运行后端服务**
```bash
go run main.go
```

##### 前端部署

1. **进入前端目录**
```bash
cd frontend
```

2. **安装npm依赖**
```bash
npm install
```

3. **启动开发服务器**
```bash
npm run dev
```

4. **构建生产版本**
```bash
npm run build
```

## ⚙️ 依赖管理

### 后端主要依赖

```go
// 核心框架
github.com/gin-gonic/gin v1.10.0           // Web框架
gorm.io/gorm v1.25.12                       // ORM框架
gorm.io/driver/mysql v1.5.7                 // MySQL驱动

// 认证和安全
github.com/dgrijalva/jwt-go v3.2.0          // JWT认证
golang.org/x/crypto v0.30.0                 // 加密库

// 数据库和缓存
github.com/go-redis/redis/v8 v8.11.5        // Redis客户端

// 消息队列
github.com/rabbitmq/amqp091-go v1.10.0      // RabbitMQ客户端

// 配置和日志
github.com/spf13/viper v1.19.0              // 配置管理
go.uber.org/zap v1.27.0                     // 日志框架
gopkg.in/natefinch/lumberjack.v2 v2.2.1     // 日志轮转

// 中间件和工具
github.com/gin-contrib/cors v1.7.2          // 跨域中间件
github.com/go-playground/validator/v10 v10.23.0  // 参数验证
```

### 前端主要依赖

```json
{
  "dependencies": {
    "vue": "^3.5.13"                        // Vue3框架
  },
  "devDependencies": {
    "@vitejs/plugin-vue": "^5.2.3",         // Vite Vue插件
    "vite": "^6.2.4",                       // 构建工具
    "vite-plugin-vue-devtools": "^7.7.2"    // Vue开发工具
  }
}
```

## 🔧 配置说明

### 后端配置文件 (config.yaml)

```yaml
# 应用配置
app:
  name: "gin-web"
  port: "8080"
  mode: "debug"

# 数据库配置  
database:
  driver: "mysql"
  host: "localhost"
  port: 3306
  database: "gin_web"
  username: "root"
  password: "password"

# Redis配置
redis:
  host: "localhost"
  port: 6379
  password: ""
  db: 0

# JWT配置
jwt:
  secret: "your-secret-key"
  expire_time: 86400
```

## 🚦 API接口

### 认证相关
- `POST /api/auth/register` - 用户注册
- `POST /api/auth/login` - 用户登录  
- `POST /api/auth/info` - 获取用户信息 (需认证)
- `POST /api/auth/logout` - 用户登出 (需认证)

### 测试接口
- `GET /api/ping` - 健康检查
- `GET /api/test` - 测试接口

## 🐛 开发调试

### 查看日志
```bash
# 后端日志
tail -f backend/storage/logs/app.log

# 查看容器日志
docker-compose logs -f backend
docker-compose logs -f frontend
```

### 数据库操作
```bash
# 连接数据库
mysql -u root -p gin_web

# 查看表结构
DESCRIBE users;
```

## 📖 开发指南

1. **遵循MVC架构模式**
   - Model: 数据模型定义
   - View: API响应格式  
   - Controller: 业务逻辑处理

2. **代码规范**
   - 使用Go官方代码规范
   - 前端遵循Vue 3风格指南
   - 统一错误处理和响应格式

3. **Git提交规范**
   - feat: 新功能
   - fix: bug修复
   - docs: 文档更新
   - style: 代码格式调整

## 🤝 贡献指南

1. Fork 本项目
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

## 📄 许可证

本项目采用 MIT 许可证。详情请见 [LICENSE](LICENSE) 文件。

## 🙋‍♂️ 支持

如果您在使用过程中遇到问题，请：

1. 查看 [安装指南](docs/setup/installation-guide.md)
2. 检查 [项目报告](docs/development/project-reports.md)  
3. 提交 Issue
4. 联系维护者

## 📖 项目文档

### 🚀 快速开始
- [**安装指南**](docs/setup/installation-guide.md) - 详细的安装和启动步骤
- [**项目结构**](docs/architecture/project-structure.md) - 完整的目录结构说明

### 🏗️ 架构设计
- [**后端MVC架构**](docs/architecture/backend-mvc-guide.md) - 后端架构详细说明
- [**编码规范**](docs/development/coding-standards.md) - 开发规范和最佳实践

### 📊 项目状态
- [**项目报告**](docs/development/project-reports.md) - 当前状态和功能清单

---

**Happy Coding! 🎉** 