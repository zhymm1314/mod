# Gin 框架开发指南

## 🏗️ MVC 架构实现

### 架构概览
```
gin-web/backend/
├── app/
│   ├── controllers/     # 控制器层 - 处理HTTP请求
│   ├── services/        # 服务层 - 业务逻辑处理  
│   ├── models/          # 模型层 - 数据结构定义
│   ├── middleware/      # 中间件 - 请求处理管道
│   └── common/          # 公共组件
├── routes/              # 路由定义
├── config/              # 配置管理
├── bootstrap/           # 应用启动
└── global/              # 全局变量
```

### 请求流程
```
HTTP请求 → 路由匹配 → 中间件链 → 控制器 → 服务层 → 模型层 → 数据库
                                     ↓
HTTP响应 ← 响应格式化 ← 业务处理 ← 数据操作 ← 数据返回
```

## 🎮 控制器层 (Controllers)

### 控制器规范
```go
// app/controllers/auth.go
package controllers

import (
    "gin-web/app/common/request"
    "gin-web/app/common/response"
    "gin-web/app/services"
    "github.com/gin-gonic/gin"
    "net/http"
)

type AuthController struct{}

// Login 用户登录
func (ac AuthController) Login(c *gin.Context) {
    // 1. 参数绑定和验证
    var form request.Login
    if err := c.ShouldBindJSON(&form); err != nil {
        response.ValidateFail(c, request.GetErrorMsg(form, err))
        return
    }

    // 2. 调用服务层
    userService := services.UserService{}
    token, user, err := userService.Login(form)
    if err != nil {
        response.BusinessFail(c, err.Error())
        return
    }

    // 3. 返回成功响应
    response.Success(c, gin.H{
        "token": token,
        "user":  user,
    })
}

// Register 用户注册
func (ac AuthController) Register(c *gin.Context) {
    var form request.Register
    if err := c.ShouldBindJSON(&form); err != nil {
        response.ValidateFail(c, request.GetErrorMsg(form, err))
        return
    }

    userService := services.UserService{}
    user, err := userService.Register(form)
    if err != nil {
        response.BusinessFail(c, err.Error())
        return
    }

    response.Success(c, user)
}

// Info 获取用户信息
func (ac AuthController) Info(c *gin.Context) {
    // 从JWT中间件获取用户ID
    userId := c.GetUint("user_id")
    
    userService := services.UserService{}
    user, err := userService.GetUserInfo(userId)
    if err != nil {
        response.BusinessFail(c, err.Error())
        return
    }

    response.Success(c, user)
}

// Logout 用户登出
func (ac AuthController) Logout(c *gin.Context) {
    // 获取JWT Token
    token := c.GetHeader("Authorization")
    if token == "" {
        response.BusinessFail(c, "Token不存在")
        return
    }

    // 将Token加入黑名单
    jwtService := services.JwtService{}
    if err := jwtService.JoinBlackList(token); err != nil {
        response.BusinessFail(c, "登出失败")
        return
    }

    response.Success(c, nil)
}
```

### 控制器最佳实践
```go
// 控制器职责清单
type BaseController struct{}

// 1. 参数验证
func (bc BaseController) validateRequest(c *gin.Context, form interface{}) bool {
    if err := c.ShouldBindJSON(form); err != nil {
        response.ValidateFail(c, request.GetErrorMsg(form, err))
        return false
    }
    return true
}

// 2. 获取当前用户
func (bc BaseController) getCurrentUser(c *gin.Context) *models.User {
    if userId, exists := c.Get("user_id"); exists {
        userService := services.UserService{}
        user, _ := userService.GetUserInfo(userId.(uint))
        return user
    }
    return nil
}

// 3. 分页参数处理
func (bc BaseController) getPageParams(c *gin.Context) (int, int) {
    page := c.DefaultQuery("page", "1")
    pageSize := c.DefaultQuery("page_size", "20")
    
    pageInt, _ := strconv.Atoi(page)
    pageSizeInt, _ := strconv.Atoi(pageSize)
    
    if pageInt < 1 {
        pageInt = 1
    }
    if pageSizeInt < 1 || pageSizeInt > 100 {
        pageSizeInt = 20
    }
    
    return pageInt, pageSizeInt
}
```

## 🔧 服务层 (Services)

### 服务层规范
```go
// app/services/user.go
package services

import (
    "errors"
    "gin-web/app/common/request"
    "gin-web/app/models"
    "gin-web/global"
    "golang.org/x/crypto/bcrypt"
    "gorm.io/gorm"
)

type UserService struct{}

// Register 用户注册
func (userService UserService) Register(params request.Register) (models.User, error) {
    var user models.User
    
    // 1. 检查手机号是否已存在
    err := global.App.DB.Where("mobile = ?", params.Mobile).First(&user).Error
    if err == nil {
        return user, errors.New("手机号已存在")
    }
    
    // 2. 密码加密
    hashedPassword, err := bcrypt.GenerateFromPassword([]byte(params.Password), bcrypt.DefaultCost)
    if err != nil {
        return user, errors.New("密码加密失败")
    }
    
    // 3. 创建用户
    user = models.User{
        Name:     params.Name,
        Mobile:   params.Mobile,
        Password: string(hashedPassword),
    }
    
    err = global.App.DB.Create(&user).Error
    if err != nil {
        return user, errors.New("用户创建失败")
    }
    
    return user, nil
}

// Login 用户登录
func (userService UserService) Login(params request.Login) (string, models.User, error) {
    var user models.User
    
    // 1. 查找用户
    err := global.App.DB.Where("mobile = ?", params.Mobile).First(&user).Error
    if err != nil {
        if errors.Is(err, gorm.ErrRecordNotFound) {
            return "", user, errors.New("手机号或密码错误")
        }
        return "", user, errors.New("登录失败")
    }
    
    // 2. 验证密码
    err = bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(params.Password))
    if err != nil {
        return "", user, errors.New("手机号或密码错误")
    }
    
    // 3. 生成JWT Token
    jwtService := JwtService{}
    token, err := jwtService.CreateToken(AppClaims{
        UserId: user.ID,
        Mobile: user.Mobile,
    })
    if err != nil {
        return "", user, errors.New("Token生成失败")
    }
    
    return token, user, nil
}

// GetUserInfo 获取用户信息
func (userService UserService) GetUserInfo(id uint) (*models.User, error) {
    var user models.User
    err := global.App.DB.First(&user, id).Error
    if err != nil {
        if errors.Is(err, gorm.ErrRecordNotFound) {
            return nil, errors.New("用户不存在")
        }
        return nil, errors.New("获取用户信息失败")
    }
    return &user, nil
}

// UpdateUserInfo 更新用户信息
func (userService UserService) UpdateUserInfo(id uint, params request.UpdateUser) (*models.User, error) {
    var user models.User
    
    // 查找用户
    err := global.App.DB.First(&user, id).Error
    if err != nil {
        return nil, errors.New("用户不存在")
    }
    
    // 更新字段
    if params.Name != "" {
        user.Name = params.Name
    }
    
    // 保存更新
    err = global.App.DB.Save(&user).Error
    if err != nil {
        return nil, errors.New("更新失败")
    }
    
    return &user, nil
}
```

### JWT服务实现
```go
// app/services/jwt.go
package services

import (
    "errors"
    "gin-web/global"
    "github.com/dgrijalva/jwt-go"
    "strconv"
    "time"
)

type JwtService struct{}

type AppClaims struct {
    UserId uint   `json:"user_id"`
    Mobile string `json:"mobile"`
    jwt.StandardClaims
}

// CreateToken 生成Token
func (jwtService *JwtService) CreateToken(appClaims AppClaims) (string, error) {
    // 设置过期时间
    appClaims.ExpiresAt = time.Now().Add(24 * time.Hour).Unix()
    appClaims.Issuer = "gin-web"
    
    // 生成Token
    token := jwt.NewWithClaims(jwt.SigningMethodHS256, appClaims)
    
    // 签名
    return token.SignedString([]byte(global.App.Config.Jwt.Secret))
}

// ParseToken 解析Token
func (jwtService *JwtService) ParseToken(tokenString string) (*AppClaims, error) {
    token, err := jwt.ParseWithClaims(tokenString, &AppClaims{}, func(token *jwt.Token) (interface{}, error) {
        return []byte(global.App.Config.Jwt.Secret), nil
    })
    
    if err != nil {
        return nil, err
    }
    
    if claims, ok := token.Claims.(*AppClaims); ok && token.Valid {
        return claims, nil
    }
    
    return nil, errors.New("Token无效")
}

// JoinBlackList 加入黑名单
func (jwtService *JwtService) JoinBlackList(tokenString string) error {
    // 解析Token获取过期时间
    claims, err := jwtService.ParseToken(tokenString)
    if err != nil {
        return err
    }
    
    // 计算剩余过期时间
    expTime := time.Unix(claims.ExpiresAt, 0)
    now := time.Now()
    if expTime.Before(now) {
        return errors.New("Token已过期")
    }
    
    // 存入Redis黑名单
    duration := expTime.Sub(now)
    key := "jwt_blacklist:" + tokenString
    
    return global.App.Redis.Set(key, "1", duration).Err()
}

// IsInBlackList 检查是否在黑名单
func (jwtService *JwtService) IsInBlackList(tokenString string) bool {
    key := "jwt_blacklist:" + tokenString
    result := global.App.Redis.Get(key)
    return result.Err() == nil
}
```

## 📊 模型层 (Models)

### 模型定义规范
```go
// app/models/common.go
package models

import (
    "gorm.io/gorm"
    "time"
)

// Common 公共字段
type Common struct {
    ID        uint           `gorm:"primarykey" json:"id"`
    CreatedAt time.Time      `json:"created_at"`
    UpdatedAt time.Time      `json:"updated_at"`
    DeletedAt gorm.DeletedAt `gorm:"index" json:"-"`
}

// app/models/user.go
package models

import "strconv"

type User struct {
    Common
    Name     string `gorm:"type:varchar(255);not null;comment:用户名称" json:"name"`
    Mobile   string `gorm:"type:varchar(11);uniqueIndex;not null;comment:手机号" json:"mobile"`
    Password string `gorm:"type:varchar(255);not null;comment:密码" json:"-"`
    Avatar   string `gorm:"type:varchar(500);comment:头像" json:"avatar"`
    Status   int    `gorm:"type:tinyint;default:1;comment:状态 1正常 0禁用" json:"status"`
}

// TableName 指定表名
func (User) TableName() string {
    return "users"
}

// GetUid 获取字符串类型的用户ID
func (user User) GetUid() string {
    return strconv.Itoa(int(user.ID))
}

// IsActive 检查用户是否激活
func (user User) IsActive() bool {
    return user.Status == 1
}
```

### 模型关联关系
```go
// 一对多关系示例
type User struct {
    Common
    Name     string    `json:"name"`
    Posts    []Post    `gorm:"foreignKey:UserID" json:"posts,omitempty"`
    Profile  *Profile  `gorm:"foreignKey:UserID" json:"profile,omitempty"`
}

type Post struct {
    Common
    Title   string `json:"title"`
    Content string `json:"content"`
    UserID  uint   `json:"user_id"`
    User    *User  `gorm:"foreignKey:UserID" json:"user,omitempty"`
}

type Profile struct {
    Common
    Bio    string `json:"bio"`
    UserID uint   `gorm:"uniqueIndex" json:"user_id"`
}
```

## 🛡️ 中间件开发

### JWT认证中间件
```go
// app/middleware/jwt.go
package middleware

import (
    "gin-web/app/common/response"
    "gin-web/app/services"
    "gin-web/global"
    "github.com/gin-gonic/gin"
    "strings"
)

func JWTAuth() gin.HandlerFunc {
    return func(c *gin.Context) {
        // 1. 获取Token
        tokenString := c.GetHeader("Authorization")
        if tokenString == "" {
            response.TokenFail(c)
            c.Abort()
            return
        }
        
        // 移除"Bearer "前缀
        tokenString = strings.TrimPrefix(tokenString, "Bearer ")
        
        // 2. 检查黑名单
        jwtService := services.JwtService{}
        if jwtService.IsInBlackList(tokenString) {
            response.TokenFail(c)
            c.Abort()
            return
        }
        
        // 3. 解析Token
        claims, err := jwtService.ParseToken(tokenString)
        if err != nil {
            response.TokenFail(c)
            c.Abort()
            return
        }
        
        // 4. 设置用户信息到上下文
        c.Set("user_id", claims.UserId)
        c.Set("mobile", claims.Mobile)
        
        c.Next()
    }
}
```

### CORS跨域中间件
```go
// app/middleware/cors.go
package middleware

import (
    "github.com/gin-contrib/cors"
    "github.com/gin-gonic/gin"
    "time"
)

func Cors() gin.HandlerFunc {
    return cors.New(cors.Config{
        AllowOrigins:     []string{"http://localhost:3000", "http://127.0.0.1:3000"},
        AllowMethods:     []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
        AllowHeaders:     []string{"Origin", "Content-Type", "Accept", "Authorization"},
        ExposeHeaders:    []string{"Content-Length"},
        AllowCredentials: true,
        MaxAge:           12 * time.Hour,
    })
}
```

### 日志中间件
```go
// app/middleware/logging.go
package middleware

import (
    "gin-web/global"
    "github.com/gin-gonic/gin"
    "time"
)

func Logging() gin.HandlerFunc {
    return gin.LoggerWithFormatter(func(param gin.LogFormatterParams) string {
        // 自定义日志格式
        global.App.Log.Info("HTTP Request",
            zap.String("method", param.Method),
            zap.String("path", param.Path),
            zap.Int("status", param.StatusCode),
            zap.Duration("latency", param.Latency),
            zap.String("ip", param.ClientIP),
            zap.String("user_agent", param.Request.UserAgent()),
        )
        return ""
    })
}
```

## 🛣️ 路由设计模式

### 路由组织结构
```go
// routes/api.go
package routes

import (
    "gin-web/app/controllers"
    "gin-web/app/middleware"
    "github.com/gin-gonic/gin"
)

func SetApiGroupRoutes(router *gin.RouterGroup) {
    // 公共路由（无需认证）
    publicRoutes(router)
    
    // 认证路由（需要JWT认证）
    authRoutes(router)
}

// 公共路由
func publicRoutes(r *gin.RouterGroup) {
    authController := controllers.AuthController{}
    
    authGroup := r.Group("/auth")
    {
        authGroup.POST("/register", authController.Register)
        authGroup.POST("/login", authController.Login)
    }
    
    // 测试路由
    r.GET("/ping", controllers.Ping)
    r.GET("/test", controllers.Test)
}

// 认证路由
func authRoutes(r *gin.RouterGroup) {
    authController := controllers.AuthController{}
    
    // 应用JWT中间件
    authGroup := r.Group("/auth").Use(middleware.JWTAuth())
    {
        authGroup.POST("/info", authController.Info)
        authGroup.POST("/logout", authController.Logout)
    }
    
    // 用户管理路由
    userController := controllers.UserController{}
    userGroup := r.Group("/users").Use(middleware.JWTAuth())
    {
        userGroup.GET("/", userController.List)
        userGroup.GET("/:id", userController.Detail)
        userGroup.PUT("/:id", userController.Update)
        userGroup.DELETE("/:id", userController.Delete)
    }
}
```

### RESTful路由规范
```go
// RESTful资源路由示例
func setupResourceRoutes(r *gin.RouterGroup, controller interface{}) {
    switch ctrl := controller.(type) {
    case controllers.UserController:
        users := r.Group("/users")
        {
            users.GET("/", ctrl.Index)      // GET /users - 获取用户列表
            users.POST("/", ctrl.Store)     // POST /users - 创建用户
            users.GET("/:id", ctrl.Show)    // GET /users/1 - 获取单个用户
            users.PUT("/:id", ctrl.Update)  // PUT /users/1 - 更新用户
            users.DELETE("/:id", ctrl.Delete) // DELETE /users/1 - 删除用户
        }
    }
}
```

## 🔧 请求验证和响应处理

### 请求结构体定义
```go
// app/common/request/auth.go
package request

type Register struct {
    Name     string `json:"name" binding:"required,min=2,max=20" label:"用户名"`
    Mobile   string `json:"mobile" binding:"required,mobile" label:"手机号"`
    Password string `json:"password" binding:"required,min=6,max=20" label:"密码"`
}

type Login struct {
    Mobile   string `json:"mobile" binding:"required,mobile" label:"手机号"`
    Password string `json:"password" binding:"required" label:"密码"`
}

// 自定义验证器
func (r Register) GetMessages() ValidatorMessages {
    return ValidatorMessages{
        "name.required":     "用户名不能为空",
        "name.min":          "用户名长度不能少于2位",
        "mobile.required":   "手机号不能为空",
        "mobile.mobile":     "手机号格式不正确",
        "password.required": "密码不能为空",
        "password.min":      "密码长度不能少于6位",
    }
}
```

### 统一响应格式
```go
// app/common/response/response.go
package response

import (
    "github.com/gin-gonic/gin"
    "net/http"
)

type Response struct {
    Code    int         `json:"code"`
    Message string      `json:"message"`
    Data    interface{} `json:"data"`
}

// Success 成功响应
func Success(c *gin.Context, data interface{}) {
    c.JSON(http.StatusOK, Response{
        Code:    200,
        Message: "操作成功",
        Data:    data,
    })
}

// BusinessFail 业务失败
func BusinessFail(c *gin.Context, message string) {
    c.JSON(http.StatusOK, Response{
        Code:    4001,
        Message: message,
        Data:    nil,
    })
}

// ValidateFail 验证失败
func ValidateFail(c *gin.Context, message string) {
    c.JSON(http.StatusBadRequest, Response{
        Code:    4000,
        Message: message,
        Data:    nil,
    })
}

// TokenFail 认证失败
func TokenFail(c *gin.Context) {
    c.JSON(http.StatusUnauthorized, Response{
        Code:    4010,
        Message: "请先登录",
        Data:    nil,
    })
}

// ServerFail 服务器错误
func ServerFail(c *gin.Context, message string) {
    c.JSON(http.StatusInternalServerError, Response{
        Code:    5000,
        Message: message,
        Data:    nil,
    })
}
```

---

**文档版本**: v1.0  
**最后更新**: 2024-12-19  
**负责人**: 后端开发工程师  
**审核人**: 技术负责人 