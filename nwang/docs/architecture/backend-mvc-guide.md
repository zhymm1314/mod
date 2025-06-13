# 后端MVC架构指南

这是一个基于Gin框架的Go语言后端项目，采用标准的MVC（Model-View-Controller）架构模式。

## 项目入口
项目的主入口文件是 [main.go](../../backend/main.go)，它负责初始化配置、日志、数据库、Redis、RabbitMQ等核心组件，并启动服务器。

## 核心架构

### 1. 路由层 (Routes)
- **主要文件**: [routes/api.go](../../backend/routes/api.go)
- **功能**: 定义API路由规则，将HTTP请求映射到对应的控制器方法
- **实例**:
  - `POST /auth/register` -> `app.Register` 用户注册
  - `POST /auth/login` -> `app.Login` 用户登录
  - 认证路由组使用JWT中间件保护

### 2. 控制器层 (Controllers)
位于 `app/controllers/` 目录，负责处理HTTP请求和响应

#### 认证控制器
- **文件**: [app/controllers/auth.go](../../backend/app/controllers/auth.go)
- **功能**: 处理用户认证相关业务
- **主要方法**:
  - `Login()` - 用户登录验证，接收JSON请求，调用UserService.Login进行验证
  - `Info()` - 获取用户信息，从JWT token中获取用户ID
  - `Logout()` - 用户登出，将token加入黑名单
  - `Register()` - 用户注册，调用UserService.Register处理注册逻辑

#### 用户控制器
- **文件**: [app/controllers/user.go](../../backend/app/controllers/user.go)
- **功能**: 处理用户管理相关业务

### 3. 服务层 (Services)
位于 `app/services/` 目录，包含业务逻辑处理

#### 用户服务
- **文件**: [app/services/user.go](../../backend/app/services/user.go)
- **功能**: 用户相关业务逻辑
- **主要方法**:
  - `Register()` - 用户注册逻辑，检查手机号唯一性，密码加密存储
  - `Login()` - 用户登录验证，验证手机号和密码
  - `GetUserInfo()` - 根据用户ID获取用户详细信息

#### JWT服务
- **文件**: [app/services/jwt.go](../../backend/app/services/jwt.go)
- **功能**: JWT令牌管理，包括创建、验证、黑名单管理
- **主要方法**:
  - `CreateToken()` - 创建JWT令牌
  - `JoinBlackList()` - 将令牌加入黑名单

### 4. 模型层 (Models)
位于 `app/models/` 目录，定义数据结构和数据库映射

#### 用户模型
- **文件**: [app/models/user.go](../../backend/app/models/user.go)
- **功能**: 用户数据模型定义
- **字段**:
  - `Name` - 用户名称，数据库字段`name1`
  - `Mobile` - 手机号，带索引，数据库字段`mobile2`
  - `Password` - 密码，不返回给前端，使用`json:"-"`标签
- **方法**:
  - `GetUid()` - 获取用户ID的字符串形式

#### 公共模型
- **文件**: [app/models/common.go](../../backend/app/models/common.go)
- **功能**: 定义公共字段结构体
- **包含**: ID、时间戳、软删除等公共字段

## 中间件 (Middleware)
位于 `app/middleware/` 目录

- **JWT中间件**: [app/middleware/jwt.go](../../backend/app/middleware/jwt.go) - JWT令牌验证，验证请求头中的Authorization字段
- **CORS中间件**: [app/middleware/cors.go](../../backend/app/middleware/cors.go) - 处理跨域请求
- **恢复中间件**: [app/middleware/recovery.go](../../backend/app/middleware/recovery.go) - 捕获panic异常并恢复

## 请求和响应处理
位于 `app/common/` 目录

- **请求验证**: `app/common/request/` - 定义请求参数结构和验证规则
  - 包含Register、Login等请求结构体
- **响应格式**: `app/common/response/` - 统一API响应格式
  - `Success()` - 成功响应
  - `BusinessFail()` - 业务失败响应
  - `ValidateFail()` - 验证失败响应

## 配置管理
位于 `config/` 目录，按功能模块分类配置

- **应用配置**: [config/app.go](../../backend/config/app.go) - 应用基本配置
- **数据库配置**: [config/database.go](../../backend/config/database.go) - 数据库连接配置
- **Redis配置**: [config/redis.go](../../backend/config/redis.go) - Redis连接配置
- **JWT配置**: [config/jwt.go](../../backend/config/jwt.go) - JWT相关配置
- **RabbitMQ配置**: [config/rabbitmq.go](../../backend/config/rabbitmq.go) - 消息队列配置
- **日志配置**: [config/log.go](../../backend/config/log.go) - 日志级别和输出配置
- **API URL配置**: [config/api_url.go](../../backend/config/api_url.go) - API地址配置
- **队列配置**: [config/queue.go](../../backend/config/queue.go) - 队列相关配置

## 引导程序 (Bootstrap)
位于 `bootstrap/` 目录，负责应用程序初始化

- **路由初始化**: [bootstrap/router.go](../../backend/bootstrap/router.go) - 设置Gin路由和中间件
- **数据库初始化**: [bootstrap/db.go](../../backend/bootstrap/db.go) - GORM数据库连接和迁移
- **日志初始化**: [bootstrap/log.go](../../backend/bootstrap/log.go) - 日志系统初始化
- **Redis初始化**: [bootstrap/redis.go](../../backend/bootstrap/redis.go) - Redis连接池初始化
- **配置初始化**: [bootstrap/config.go](../../backend/bootstrap/config.go) - 读取YAML配置文件
- **验证器初始化**: [bootstrap/validator.go](../../backend/bootstrap/validator.go) - 参数验证器设置
- **RabbitMQ初始化**: [bootstrap/rabbitmq.go](../../backend/bootstrap/rabbitmq.go) - 消息队列连接
- **RabbitMQ管理**: [bootstrap/rabbitmq_manager.go](../../backend/bootstrap/rabbitmq_manager.go) - 队列管理功能

## 工具函数 (Utils)
位于 `utils/` 目录，提供公共工具函数

- 密码加密验证
- 字符串处理
- 时间处理
- 其他通用工具

## 全局变量 (Global)
位于 `global/` 目录，定义全局共享变量

- 数据库连接实例
- Redis连接实例
- 日志实例
- 配置实例

## 存储 (Storage)
位于 `storage/` 目录

- 日志文件存储
- 上传文件存储
- 临时文件存储

## 配置文件
- **主配置**: [config.yaml](../../backend/config.yaml) - 生产环境配置
- **示例配置**: [example-config.yaml](../../backend/example-config.yaml) - 配置文件模板

## 开发规范

### MVC分层规范
1. **Controller层**: 只处理HTTP请求/响应，参数验证，调用Service层
2. **Service层**: 业务逻辑处理，数据库操作，调用Model层
3. **Model层**: 数据结构定义，数据库映射关系

### 文件命名规范
- 控制器: 直接以功能命名，如`auth.go`、`user.go`
- 服务: `xxxService` 结构体，全局变量实例
- 模型: 单数形式，首字母大写

### 错误处理
- 使用统一的响应格式（Success、BusinessFail、ValidateFail）
- 错误信息本地化处理
- 区分业务错误和系统错误

### 认证授权
- 使用JWT进行用户认证
- 支持令牌黑名单机制
- 中间件统一处理认证逻辑

### 数据库操作
- 使用GORM作为ORM框架
- 模型定义使用结构体标签指定数据库字段
- 支持软删除和时间戳自动管理

### 请求验证
- 使用Gin的数据绑定功能
- 统一的错误消息处理
- 支持JSON、表单等多种请求格式 