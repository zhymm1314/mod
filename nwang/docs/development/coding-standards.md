# 编码规范

## 后端开发规范 (Go)

### 1. 项目结构规范
```
backend/
├── app/
│   ├── controllers/     # 控制器层 - 只处理HTTP请求响应
│   ├── services/        # 服务层 - 处理业务逻辑
│   ├── models/          # 数据模型层 - 数据结构定义
│   ├── middleware/      # 中间件
│   └── common/          # 公共模块
```

### 2. 分层架构规范

#### Controller层
```go
// ✅ 正确示例
func (ctrl *AuthController) Login(c *gin.Context) {
    var req request.LoginRequest
    if err := c.ShouldBindJSON(&req); err != nil {
        response.ValidateFail(c, request.GetErrorMsg(req, err))
        return
    }
    
    // 调用服务层处理业务逻辑
    user, err := services.UserService.Login(req)
    if err != nil {
        response.BusinessFail(c, err.Error())
        return
    }
    
    response.Success(c, user)
}
```

#### Service层
```go
// ✅ 正确示例
func (userService *userService) Login(params request.LoginRequest) (User, error) {
    var user User
    err := global.App.DB.Where("mobile = ?", params.Mobile).First(&user).Error
    if err != nil {
        return user, errors.New("用户不存在")
    }
    
    // 验证密码
    if !utils.BcryptMakeCheck([]byte(params.Password), []byte(user.Password)) {
        return user, errors.New("密码错误")
    }
    
    return user, nil
}
```

### 3. 命名规范

#### 文件命名
- 使用小写字母和下划线：`user_service.go`
- 控制器文件：`auth.go`, `user.go`
- 服务文件：`user.go`, `jwt.go`

#### 变量命名
```go
// ✅ 正确
var userService *userService
var userInfo models.User
var phoneNumber string

// ❌ 错误
var us *userservice
var ui models.User
var phone_number string
```

#### 结构体命名
```go
// ✅ 正确
type UserService struct {
    db *gorm.DB
}

type LoginRequest struct {
    Mobile   string `json:"mobile" binding:"required"`
    Password string `json:"password" binding:"required"`
}
```

### 4. 错误处理规范

#### 统一错误响应
```go
// ✅ 正确
if err != nil {
    response.BusinessFail(c, "操作失败")
    return
}

// 验证错误
if err := c.ShouldBindJSON(&req); err != nil {
    response.ValidateFail(c, request.GetErrorMsg(req, err))
    return
}
```

#### 错误日志记录
```go
// ✅ 正确
global.App.Log.Error("用户登录失败", zap.Error(err), zap.String("mobile", params.Mobile))
```

### 5. 数据库操作规范

#### 模型定义
```go
// ✅ 正确
type User struct {
    ID
    Name     string `json:"name" gorm:"not null;comment:用户名称"`
    Mobile   string `json:"mobile" gorm:"not null;index;comment:用户手机号"`
    Password string `json:"-" gorm:"not null;comment:用户密码"`
    Timestamps
    SoftDeletes
}
```

#### 查询操作
```go
// ✅ 正确 - 使用事务
tx := global.App.DB.Begin()
defer func() {
    if r := recover(); r != nil {
        tx.Rollback()
    }
}()

if err := tx.Create(&user).Error; err != nil {
    tx.Rollback()
    return err
}

tx.Commit()
```

## 前端开发规范 (Vue 3)

### 1. 项目结构规范
```
frontend/
├── src/
│   ├── components/      # 组件目录
│   ├── views/           # 页面组件
│   ├── assets/          # 静态资源
│   ├── utils/           # 工具函数
│   └── api/             # API接口
```

### 2. 组件规范

#### 单文件组件结构
```vue
<!-- ✅ 正确示例 -->
<template>
  <div class="user-list">
    <h2>{{ title }}</h2>
    <div v-for="user in users" :key="user.id" class="user-item">
      {{ user.name }}
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue'
import { getUserList } from '@/api/user'

export default {
  name: 'UserList',
  setup() {
    const title = ref('用户列表')
    const users = ref([])
    
    const fetchUsers = async () => {
      try {
        const response = await getUserList()
        users.value = response.data
      } catch (error) {
        console.error('获取用户列表失败:', error)
      }
    }
    
    onMounted(() => {
      fetchUsers()
    })
    
    return {
      title,
      users,
      fetchUsers
    }
  }
}
</script>

<style scoped>
.user-list {
  padding: 20px;
}

.user-item {
  padding: 10px;
  border-bottom: 1px solid #eee;
}
</style>
```

### 3. API调用规范

#### API函数定义
```javascript
// ✅ 正确示例 - api/user.js
export const getUserList = (params = {}) => {
  return fetch('/api/users', {
    method: 'GET',
    headers: {
      'Content-Type': 'application/json'
    }
  }).then(response => response.json())
}

export const createUser = (userData) => {
  return fetch('/api/users', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(userData)
  }).then(response => response.json())
}
```

### 4. 样式规范

#### CSS命名规范
```css
/* ✅ 正确 - 使用BEM命名规范 */
.user-list {}
.user-list__item {}
.user-list__item--active {}
.user-list__title {}

/* ❌ 错误 */
.userlist {}
.item {}
.active {}
```

#### 响应式设计
```css
/* ✅ 正确 */
.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
}

@media (max-width: 768px) {
  .container {
    padding: 0 10px;
  }
}
```

## 通用规范

### 1. 代码注释规范

#### Go代码注释
```go
// UserService 用户服务结构体
type UserService struct {
    db *gorm.DB
}

// Login 用户登录
// @param params 登录参数
// @return User 用户信息
// @return error 错误信息
func (s *UserService) Login(params request.LoginRequest) (User, error) {
    // 查询用户
    var user User
    // ...
}
```

#### JavaScript代码注释
```javascript
/**
 * 获取用户列表
 * @param {Object} params - 查询参数
 * @param {number} params.page - 页码
 * @param {number} params.pageSize - 每页数量
 * @returns {Promise} API响应
 */
export const getUserList = (params = {}) => {
  // 实现代码
}
```

### 2. Git提交规范

#### 提交信息格式
```bash
# 格式：<type>(<scope>): <subject>

# 类型说明
feat: 新功能
fix: 修复bug
docs: 文档更新
style: 代码格式调整
refactor: 代码重构
test: 测试相关
chore: 构建过程或辅助工具的变动

# 示例
feat(auth): 添加用户登录功能
fix(user): 修复用户信息更新bug
docs(readme): 更新项目说明文档
```

### 3. 环境配置规范

#### 配置文件管理
```yaml
# ✅ 正确 - config.yaml
app:
  name: "gin-web"
  port: "8080"
  mode: "debug"  # debug, release, test

database:
  driver: "mysql"
  host: "${DB_HOST:localhost}"
  port: ${DB_PORT:3306}
  database: "${DB_NAME:gin_web}"
```

#### 环境变量
```bash
# ✅ 正确 - .env
DB_HOST=localhost
DB_PORT=3306
DB_NAME=gin_web
JWT_SECRET=your-secret-key
```

### 4. 安全规范

#### 密码处理
```go
// ✅ 正确
hashedPassword, _ := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)

// 验证密码
err := bcrypt.CompareHashAndPassword([]byte(hashedPassword), []byte(password))
```

#### JWT处理
```go
// ✅ 正确
token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
    "user_id": user.ID,
    "exp":     time.Now().Add(time.Hour * 24).Unix(),
})

tokenString, err := token.SignedString([]byte(config.JWTSecret))
```

### 5. 测试规范

#### 单元测试
```go
// ✅ 正确示例
func TestUserService_Login(t *testing.T) {
    // 准备测试数据
    user := &User{
        Mobile:   "13800138000",
        Password: "hashedpassword",
    }
    
    // 执行测试
    result, err := userService.Login(request.LoginRequest{
        Mobile:   "13800138000",
        Password: "password",
    })
    
    // 断言结果
    assert.NoError(t, err)
    assert.Equal(t, user.Mobile, result.Mobile)
}
```

### 6. 性能规范

#### 数据库查询优化
```go
// ✅ 正确 - 使用索引
type User struct {
    Mobile string `gorm:"index"`
}

// ✅ 正确 - 分页查询
func GetUsers(page, pageSize int) ([]User, error) {
    var users []User
    offset := (page - 1) * pageSize
    
    err := db.Offset(offset).Limit(pageSize).Find(&users).Error
    return users, err
}
```

#### 前端性能优化
```javascript
// ✅ 正确 - 使用防抖
import { debounce } from 'lodash'

const searchUsers = debounce(async (keyword) => {
  const users = await getUserList({ search: keyword })
  // 处理结果
}, 300)
``` 