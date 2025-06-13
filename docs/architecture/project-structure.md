# 项目结构说明

## 项目概览

本项目采用前后端分离架构，包含Go后端API服务和Vue3前端应用。

## 整体目录结构

```
nwang/
├── README.md                    # 项目说明文档
├── docker-compose.yml           # Docker编排配置
├── start.sh                     # 项目启动脚本
├── stop.sh                      # 项目停止脚本
├── docs/                        # 项目文档目录
│   ├── setup/                   # 安装配置文档
│   │   └── installation-guide.md
│   ├── architecture/            # 架构说明文档
│   │   ├── backend-mvc-guide.md
│   │   └── project-structure.md
│   ├── development/             # 开发指南文档
│   └── deployment/              # 部署相关文档
├── mysql/                       # MySQL数据库相关文件
├── backend/                     # 后端Go项目
│   ├── main.go                 # 项目入口文件
│   ├── go.mod                  # Go模块依赖
│   ├── config.yaml             # 配置文件
│   ├── Dockerfile              # Docker构建文件
│   ├── app/                    # 应用核心代码
│   │   ├── controllers/        # 控制器层
│   │   ├── services/           # 服务层
│   │   ├── models/             # 数据模型层
│   │   ├── middleware/         # 中间件
│   │   ├── common/             # 公共模块
│   │   ├── api/                # API相关
│   │   └── ampq/               # 消息队列处理
│   ├── bootstrap/              # 应用启动引导
│   ├── config/                 # 配置管理
│   ├── global/                 # 全局变量
│   ├── routes/                 # 路由定义
│   ├── storage/                # 存储目录
│   └── utils/                  # 工具函数
└── frontend/                   # 前端Vue项目
    ├── package.json            # 前端依赖配置
    ├── vite.config.js          # Vite配置
    ├── Dockerfile              # Docker构建文件
    ├── src/                    # 源码目录
    │   ├── App.vue            # 根组件
    │   ├── main.js            # 入口文件
    │   ├── components/        # 组件目录
    │   └── assets/            # 静态资源
    └── public/                # 公共文件
```

## 后端结构详解 (backend/)

### 核心目录

#### app/ - 应用核心代码
```
app/
├── controllers/        # 控制器层 - 处理HTTP请求响应
│   ├── auth.go        # 认证相关控制器
│   └── user.go        # 用户管理控制器
├── services/          # 服务层 - 业务逻辑处理
│   ├── user.go        # 用户服务
│   └── jwt.go         # JWT令牌服务
├── models/            # 数据模型层 - 数据结构定义
│   ├── common.go      # 公共字段模型
│   └── user.go        # 用户数据模型
├── middleware/        # 中间件 - 请求处理中间层
│   ├── jwt.go         # JWT验证中间件
│   ├── cors.go        # 跨域处理中间件
│   └── recovery.go    # 异常恢复中间件
├── common/            # 公共模块
│   ├── request/       # 请求参数验证
│   └── response/      # 统一响应格式
├── api/               # API相关处理
└── ampq/              # 消息队列处理
```

#### bootstrap/ - 应用启动引导
```
bootstrap/
├── config.go          # 配置初始化
├── db.go              # 数据库初始化
├── log.go             # 日志系统初始化
├── redis.go           # Redis初始化
├── router.go          # 路由初始化
├── validator.go       # 验证器初始化
├── rabbitmq.go        # RabbitMQ连接初始化
└── rabbitmq_manager.go # RabbitMQ管理功能
```

#### config/ - 配置管理
```
config/
├── app.go             # 应用基本配置
├── database.go        # 数据库配置
├── redis.go           # Redis配置
├── jwt.go             # JWT配置
├── rabbitmq.go        # RabbitMQ配置
├── log.go             # 日志配置
├── api_url.go         # API地址配置
└── queue.go           # 队列配置
```

### 支持目录

- **global/** - 全局变量定义（数据库连接、Redis连接、日志实例等）
- **routes/** - 路由定义和分组
- **storage/** - 存储目录（日志文件、上传文件、临时文件）
- **utils/** - 工具函数（密码加密、字符串处理、时间处理等）

### 配置文件
- **config.yaml** - 生产环境配置
- **example-config.yaml** - 配置文件模板

## 前端结构详解 (frontend/)

### 核心文件
- **src/App.vue** - 根组件，应用的主要入口
- **src/main.js** - JavaScript入口文件，初始化Vue应用
- **vite.config.js** - Vite构建工具配置
- **package.json** - 项目依赖和脚本配置

### 目录结构
```
frontend/
├── src/
│   ├── App.vue            # 主应用组件
│   ├── main.js            # 应用入口
│   ├── components/        # Vue组件目录
│   └── assets/            # 静态资源（样式、图片等）
├── public/                # 公共静态文件
├── dist/                  # 构建输出目录
├── node_modules/          # npm依赖包
├── package.json           # 项目配置和依赖
├── package-lock.json      # 依赖版本锁定
└── vite.config.js         # Vite配置文件
```

## 文档结构 (docs/)

### 目录组织
```
docs/
├── setup/                 # 安装配置文档
│   └── installation-guide.md  # 安装指南
├── architecture/          # 架构说明文档  
│   ├── backend-mvc-guide.md   # 后端MVC架构指南
│   └── project-structure.md   # 项目结构说明
├── development/           # 开发指南文档
│   ├── coding-standards.md    # 编码规范
│   ├── api-documentation.md   # API文档
│   └── testing-guide.md       # 测试指南
└── deployment/            # 部署相关文档
    ├── docker-deployment.md  # Docker部署
    └── production-setup.md   # 生产环境配置
```

## 架构特点

### 分层架构
1. **表现层** - Controllers（控制器）处理HTTP请求和响应
2. **业务层** - Services（服务）处理业务逻辑
3. **数据层** - Models（模型）处理数据访问和存储

### 模块化设计
- 按功能模块划分代码结构
- 清晰的依赖关系和接口定义
- 易于扩展和维护

### 配置化管理
- 统一的配置文件管理
- 环境配置分离
- 支持热重载和动态配置

### 中间件模式
- 请求处理管道
- 可插拔的功能模块
- 统一的错误处理和日志记录 