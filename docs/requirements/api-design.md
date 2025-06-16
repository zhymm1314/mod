# API设计文档

## 📡 RESTful API设计规范

### 基础规范
- **协议**: HTTPS (生产环境)
- **域名**: api.example.com
- **版本**: URL路径版本控制 `/api/v1/`
- **数据格式**: JSON
- **字符编码**: UTF-8

### URL设计规范
- **资源导向**: URL表示资源，动词表示操作
- **小写字母**: 全部使用小写字母
- **连字符**: 使用连字符 `-` 而非下划线 `_`
- **复数形式**: 集合资源使用复数名词

```
✅ 正确示例:
GET /api/v1/users          # 获取用户列表
GET /api/v1/users/123      # 获取特定用户
POST /api/v1/users         # 创建用户
PUT /api/v1/users/123      # 更新用户
DELETE /api/v1/users/123   # 删除用户

❌ 错误示例:
GET /api/v1/getUsers       # 动词不应出现在URL中
GET /api/v1/user_list      # 使用下划线
```

## 🔑 认证系统API

### 用户注册
```http
POST /api/auth/register
Content-Type: application/json

# 请求体
{
  "name": "张三",
  "mobile": "13800138000",
  "password": "password123"
}

# 响应 - 成功 (201)
{
  "code": 200,
  "message": "注册成功",
  "data": {
    "id": 1,
    "name": "张三",
    "mobile": "13800138000",
    "created_at": "2024-12-19T10:00:00Z"
  }
}

# 响应 - 失败 (400)
{
  "code": 4001,
  "message": "手机号已存在",
  "data": null
}
```

### 用户登录
```http
POST /api/auth/login
Content-Type: application/json

# 请求体
{
  "mobile": "13800138000",
  "password": "password123"
}

# 响应 - 成功 (200)
{
  "code": 200,
  "message": "登录成功",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": {
      "id": 1,
      "name": "张三",
      "mobile": "13800138000"
    },
    "expires_at": "2024-12-20T10:00:00Z"
  }
}

# 响应 - 失败 (401)
{
  "code": 4011,
  "message": "手机号或密码错误",
  "data": null
}
```

### 获取用户信息
```http
GET /api/auth/info
Authorization: Bearer {token}

# 响应 - 成功 (200)
{
  "code": 200,
  "message": "获取成功",
  "data": {
    "id": 1,
    "name": "张三",
    "mobile": "13800138000",
    "created_at": "2024-12-19T10:00:00Z",
    "updated_at": "2024-12-19T10:00:00Z"
  }
}

# 响应 - 未认证 (401)
{
  "code": 4010,
  "message": "请先登录",
  "data": null
}
```

### 用户登出
```http
POST /api/auth/logout
Authorization: Bearer {token}

# 响应 - 成功 (200)
{
  "code": 200,
  "message": "登出成功",
  "data": null
}
```

## 🧪 测试接口

### 健康检查
```http
GET /api/ping

# 响应 (200)
{
  "code": 200,
  "message": "pong",
  "data": {
    "timestamp": "2024-12-19T10:00:00Z",
    "version": "1.0.0"
  }
}
```

### 测试接口
```http
GET /api/test

# 响应 (200)
{
  "code": 200,
  "message": "测试接口正常",
  "data": {
    "server_time": "2024-12-19T10:00:00Z",
    "environment": "development"
  }
}
```

## 📋 统一响应格式

### 成功响应
```json
{
  "code": 200,
  "message": "操作成功",
  "data": {
    // 具体业务数据
  }
}
```

### 错误响应
```json
{
  "code": 4001,
  "message": "详细错误信息",
  "data": null
}
```

### 分页响应
```json
{
  "code": 200,
  "message": "获取成功",
  "data": {
    "list": [
      // 数据列表
    ],
    "pagination": {
      "page": 1,
      "page_size": 20,
      "total": 100,
      "total_pages": 5
    }
  }
}
```

## 🚨 错误码定义

### 成功状态码
| 状态码 | HTTP状态 | 说明 |
|--------|----------|------|
| 200 | 200 | 请求成功 |
| 201 | 201 | 创建成功 |

### 客户端错误 (4xxx)
| 错误码 | HTTP状态 | 错误信息 | 说明 |
|--------|----------|----------|------|
| 4000 | 400 | 请求参数错误 | 请求参数格式不正确 |
| 4001 | 400 | 手机号已存在 | 注册时手机号重复 |
| 4002 | 400 | 密码格式不正确 | 密码不符合安全要求 |
| 4010 | 401 | 请先登录 | 未提供认证信息 |
| 4011 | 401 | 手机号或密码错误 | 登录凭据错误 |
| 4012 | 401 | Token已过期 | JWT Token过期 |
| 4013 | 401 | Token无效 | JWT Token格式错误或已撤销 |
| 4030 | 403 | 无权限访问 | 权限不足 |
| 4040 | 404 | 资源不存在 | 请求的资源未找到 |
| 4290 | 429 | 请求过于频繁 | 触发限流 |

### 服务器错误 (5xxx)
| 错误码 | HTTP状态 | 错误信息 | 说明 |
|--------|----------|----------|------|
| 5000 | 500 | 服务器内部错误 | 服务器异常 |
| 5001 | 500 | 数据库错误 | 数据库操作失败 |
| 5002 | 500 | 缓存服务错误 | Redis操作失败 |
| 5030 | 503 | 服务暂时不可用 | 服务维护中 |

## 🔒 认证授权规范

### JWT Token规范
- **算法**: HS256
- **过期时间**: 24小时
- **刷新策略**: 客户端自动刷新
- **存储位置**: HTTP Header Authorization

### Token格式
```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### Token载荷
```json
{
  "user_id": 1,
  "mobile": "13800138000",
  "iat": 1703145600,
  "exp": 1703232000
}
```

## 📝 请求验证规范

### 参数验证规则
| 字段 | 类型 | 必填 | 长度限制 | 格式要求 |
|------|------|------|----------|----------|
| name | string | 是 | 2-20字符 | 中英文数字 |
| mobile | string | 是 | 11位 | 手机号格式 |
| password | string | 是 | 8-20字符 | 包含字母数字 |

### 验证错误响应
```json
{
  "code": 4000,
  "message": "请求参数错误",
  "data": {
    "errors": [
      {
        "field": "mobile",
        "message": "手机号格式不正确"
      },
      {
        "field": "password",
        "message": "密码长度至少8位"
      }
    ]
  }
}
```

## 🌐 CORS跨域配置

### 允许的域名
```
# 开发环境
http://localhost:3000
http://127.0.0.1:3000

# 生产环境
https://yourdomain.com
```

### CORS头设置
```
Access-Control-Allow-Origin: http://localhost:3000
Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS
Access-Control-Allow-Headers: Content-Type, Authorization
Access-Control-Max-Age: 86400
```

## 📈 接口版本管理

### 版本策略
- **URL版本**: `/api/v1/`, `/api/v2/`
- **向后兼容**: 至少支持2个版本
- **废弃策略**: 提前3个月通知
- **文档维护**: 每个版本独立文档

### 版本示例
```
# 当前版本
GET /api/v1/users

# 新版本
GET /api/v2/users

# 废弃版本响应
{
  "code": 4003,
  "message": "API版本已废弃，请升级到v2",
  "data": {
    "current_version": "v1",
    "latest_version": "v2",
    "deprecation_date": "2025-03-01"
  }
}
```

## 🔍 API测试示例

### cURL测试命令
```bash
# 用户注册
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"name":"测试用户","mobile":"13800138000","password":"123456"}'

# 用户登录
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"mobile":"13800138000","password":"123456"}'

# 获取用户信息
curl -X GET http://localhost:8080/api/auth/info \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"

# 健康检查
curl -X GET http://localhost:8080/api/ping
```

---

**文档版本**: v1.0  
**最后更新**: 2024-12-19  
**API负责人**: 后端开发工程师  
**审核人**: 技术负责人 