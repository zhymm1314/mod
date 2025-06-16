# 测试策略文档

## 🎯 测试金字塔

### 测试层级结构
```
     /\
    /  \     E2E测试 (少量)
   /____\    - 端到端测试
  /      \   - UI自动化测试
 /        \  
/__________\  集成测试 (适量)
|          |  - API集成测试
|          |  - 数据库集成测试
|__________|  
|          |  单元测试 (大量)
|          |  - 函数级测试
|          |  - 组件级测试
|__________|  
```

### 测试覆盖率目标
- **单元测试覆盖率**: ≥ 80%
- **集成测试覆盖率**: ≥ 60%
- **E2E测试覆盖率**: 核心业务流程 100%
- **总体代码覆盖率**: ≥ 75%

## 🧪 单元测试规范

### Go后端单元测试

#### 测试文件组织
```
backend/
├── app/
│   ├── services/
│   │   ├── user.go
│   │   └── user_test.go        # 服务层测试
│   ├── models/
│   │   ├── user.go
│   │   └── user_test.go        # 模型层测试
│   └── controllers/
│       ├── auth.go
│       └── auth_test.go        # 控制器测试
└── tests/
    ├── setup_test.go           # 测试环境配置
    └── helpers/
        └── test_helper.go      # 测试辅助函数
```

#### 服务层测试示例
```go
// app/services/user_test.go
package services_test

import (
    "gin-web/app/common/request"
    "gin-web/app/models"
    "gin-web/app/services"
    "gin-web/tests"
    "github.com/stretchr/testify/assert"
    "github.com/stretchr/testify/suite"
    "testing"
)

type UserServiceTestSuite struct {
    suite.Suite
    userService services.UserService
}

func (suite *UserServiceTestSuite) SetupSuite() {
    // 测试环境初始化
    tests.SetupTestDB()
    suite.userService = services.UserService{}
}

func (suite *UserServiceTestSuite) TearDownSuite() {
    // 测试环境清理
    tests.CleanTestDB()
}

func (suite *UserServiceTestSuite) SetupTest() {
    // 每个测试前的准备
    tests.CleanTables("users")
}

// 测试用户注册 - 成功场景
func (suite *UserServiceTestSuite) TestRegister_Success() {
    // Arrange (准备)
    registerForm := request.Register{
        Name:     "测试用户",
        Mobile:   "13800138000",
        Password: "123456",
    }

    // Act (执行)
    user, err := suite.userService.Register(registerForm)

    // Assert (断言)
    assert.NoError(suite.T(), err)
    assert.Equal(suite.T(), "测试用户", user.Name)
    assert.Equal(suite.T(), "13800138000", user.Mobile)
    assert.NotEmpty(suite.T(), user.Password)
    assert.NotEqual(suite.T(), "123456", user.Password) // 密码应该被加密
}

// 测试用户注册 - 手机号重复
func (suite *UserServiceTestSuite) TestRegister_DuplicateMobile() {
    // Arrange
    existingUser := models.User{
        Name:     "已存在用户",
        Mobile:   "13800138000",
        Password: "hashedpassword",
    }
    tests.CreateTestUser(existingUser)

    registerForm := request.Register{
        Name:     "新用户",
        Mobile:   "13800138000", // 重复的手机号
        Password: "123456",
    }

    // Act
    _, err := suite.userService.Register(registerForm)

    // Assert
    assert.Error(suite.T(), err)
    assert.Contains(suite.T(), err.Error(), "手机号已存在")
}

// 测试用户登录 - 成功场景
func (suite *UserServiceTestSuite) TestLogin_Success() {
    // Arrange
    password := "123456"
    user := tests.CreateTestUserWithPassword("13800138000", password)

    loginForm := request.Login{
        Mobile:   "13800138000",
        Password: password,
    }

    // Act
    token, loginUser, err := suite.userService.Login(loginForm)

    // Assert
    assert.NoError(suite.T(), err)
    assert.NotEmpty(suite.T(), token)
    assert.Equal(suite.T(), user.ID, loginUser.ID)
    assert.Equal(suite.T(), user.Mobile, loginUser.Mobile)
}

// 测试用户登录 - 密码错误
func (suite *UserServiceTestSuite) TestLogin_WrongPassword() {
    // Arrange
    tests.CreateTestUserWithPassword("13800138000", "correctpassword")

    loginForm := request.Login{
        Mobile:   "13800138000",
        Password: "wrongpassword",
    }

    // Act
    _, _, err := suite.userService.Login(loginForm)

    // Assert
    assert.Error(suite.T(), err)
    assert.Contains(suite.T(), err.Error(), "手机号或密码错误")
}

func TestUserServiceTestSuite(t *testing.T) {
    suite.Run(t, new(UserServiceTestSuite))
}
```

#### 测试辅助函数
```go
// tests/helpers/test_helper.go
package tests

import (
    "gin-web/app/models"
    "gin-web/global"
    "golang.org/x/crypto/bcrypt"
    "gorm.io/driver/sqlite"
    "gorm.io/gorm"
)

// SetupTestDB 设置测试数据库
func SetupTestDB() {
    db, err := gorm.Open(sqlite.Open(":memory:"), &gorm.Config{})
    if err != nil {
        panic("测试数据库连接失败: " + err.Error())
    }

    // 自动迁移表结构
    db.AutoMigrate(&models.User{})

    global.App.DB = db
}

// CleanTestDB 清理测试数据库
func CleanTestDB() {
    if global.App.DB != nil {
        sqlDB, _ := global.App.DB.DB()
        sqlDB.Close()
    }
}

// CleanTables 清理指定表数据
func CleanTables(tables ...string) {
    for _, table := range tables {
        global.App.DB.Exec("DELETE FROM " + table)
    }
}

// CreateTestUser 创建测试用户
func CreateTestUser(user models.User) models.User {
    global.App.DB.Create(&user)
    return user
}

// CreateTestUserWithPassword 创建带密码的测试用户
func CreateTestUserWithPassword(mobile, password string) models.User {
    hashedPassword, _ := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
    
    user := models.User{
        Name:     "测试用户",
        Mobile:   mobile,
        Password: string(hashedPassword),
    }
    
    return CreateTestUser(user)
}
```

### Vue前端单元测试

#### 测试文件组织
```
frontend/
├── src/
│   ├── components/
│   │   ├── UserProfile.vue
│   │   └── __tests__/
│   │       └── UserProfile.test.js
│   ├── composables/
│   │   ├── useUser.js
│   │   └── __tests__/
│   │       └── useUser.test.js
│   └── stores/
│       ├── user.js
│       └── __tests__/
│           └── user.test.js
└── tests/
    ├── setup.js              # 测试环境配置
    └── helpers/
        └── test-utils.js     # 测试工具函数
```

#### 组件测试示例
```javascript
// src/components/__tests__/UserProfile.test.js
import { mount } from '@vue/test-utils'
import { createPinia, setActivePinia } from 'pinia'
import UserProfile from '../UserProfile.vue'
import { useUserStore } from '@/stores/user'

describe('UserProfile.vue', () => {
  let wrapper
  let userStore

  beforeEach(() => {
    // 设置 Pinia
    setActivePinia(createPinia())
    userStore = useUserStore()
    
    // 模拟用户数据
    userStore.userInfo = {
      id: 1,
      name: '测试用户',
      mobile: '13800138000'
    }

    wrapper = mount(UserProfile, {
      global: {
        stubs: ['router-link']
      }
    })
  })

  afterEach(() => {
    wrapper.unmount()
  })

  it('应该正确渲染用户信息', () => {
    // 断言用户名显示正确
    expect(wrapper.find('h2').text()).toBe('测试用户')
    expect(wrapper.find('.mobile').text()).toBe('13800138000')
  })

  it('应该在点击编辑按钮时调用更新函数', async () => {
    // 模拟 store 方法
    const mockUpdateProfile = vi.fn()
    userStore.updateProfile = mockUpdateProfile

    // 点击编辑按钮
    const editButton = wrapper.find('button')
    await editButton.trigger('click')

    // 断言方法被调用
    expect(mockUpdateProfile).toHaveBeenCalled()
  })

  it('应该在加载时显示加载状态', async () => {
    // 设置加载状态
    await wrapper.setData({ loading: true })

    // 断言按钮显示加载文本
    const button = wrapper.find('button')
    expect(button.text()).toBe('保存中...')
    expect(button.attributes('disabled')).toBeDefined()
  })

  it('应该正确处理登出操作', async () => {
    // 模拟 store 方法和路由
    const mockLogout = vi.fn()
    const mockPush = vi.fn()
    userStore.logout = mockLogout

    wrapper.vm.$router = { push: mockPush }

    // 点击登出按钮
    const logoutButton = wrapper.find('.logout-btn')
    await logoutButton.trigger('click')

    // 断言方法被调用
    expect(mockLogout).toHaveBeenCalled()
  })
})
```

#### Composables测试示例
```javascript
// src/composables/__tests__/useUser.test.js
import { useUser } from '../useUser'
import { createPinia, setActivePinia } from 'pinia'
import { vi } from 'vitest'

// 模拟API
vi.mock('@/api/user', () => ({
  userApi: {
    getInfo: vi.fn(),
    update: vi.fn(),
    logout: vi.fn()
  }
}))

describe('useUser', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
  })

  it('应该正确获取用户信息', async () => {
    const { userApi } = await import('@/api/user')
    
    // 模拟API响应
    userApi.getInfo.mockResolvedValue({
      code: 200,
      data: {
        id: 1,
        name: '测试用户',
        mobile: '13800138000'
      }
    })

    const { userInfo, fetchUserInfo } = useUser()
    
    // 执行获取用户信息
    await fetchUserInfo()

    // 断言用户信息正确设置
    expect(userInfo.id).toBe(1)
    expect(userInfo.name).toBe('测试用户')
    expect(userInfo.mobile).toBe('13800138000')
  })

  it('应该正确处理更新用户信息', async () => {
    const { userApi } = await import('@/api/user')
    
    // 模拟API响应
    userApi.update.mockResolvedValue({
      code: 200,
      data: { success: true }
    })

    const { updateUserInfo } = useUser()
    
    // 执行更新操作
    const result = await updateUserInfo({ name: '新名称' })

    // 断言更新成功
    expect(result).toBe(true)
    expect(userApi.update).toHaveBeenCalledWith({ name: '新名称' })
  })

  it('应该正确处理API错误', async () => {
    const { userApi } = await import('@/api/user')
    
    // 模拟API错误
    userApi.getInfo.mockRejectedValue(new Error('网络错误'))

    const { fetchUserInfo } = useUser()
    
    // 执行操作
    await fetchUserInfo()

    // 断言错误被正确处理（根据实际错误处理逻辑）
    expect(userApi.getInfo).toHaveBeenCalled()
  })
})
```

## 🔗 集成测试

### 后端API集成测试
```go
// tests/integration/auth_test.go
package integration_test

import (
    "bytes"
    "encoding/json"
    "gin-web/app/common/request"
    "gin-web/bootstrap"
    "gin-web/tests"
    "github.com/stretchr/testify/assert"
    "github.com/stretchr/testify/suite"
    "net/http"
    "net/http/httptest"
    "testing"
)

type AuthIntegrationTestSuite struct {
    suite.Suite
    router *gin.Engine
}

func (suite *AuthIntegrationTestSuite) SetupSuite() {
    // 初始化测试环境
    tests.SetupTestDB()
    suite.router = bootstrap.SetupRouter()
}

func (suite *AuthIntegrationTestSuite) TearDownSuite() {
    tests.CleanTestDB()
}

func (suite *AuthIntegrationTestSuite) SetupTest() {
    tests.CleanTables("users")
}

// 测试用户注册API
func (suite *AuthIntegrationTestSuite) TestRegisterAPI() {
    // 准备请求数据
    registerData := request.Register{
        Name:     "测试用户",
        Mobile:   "13800138000",
        Password: "123456",
    }
    
    jsonData, _ := json.Marshal(registerData)
    
    // 创建HTTP请求
    req, _ := http.NewRequest("POST", "/api/auth/register", bytes.NewBuffer(jsonData))
    req.Header.Set("Content-Type", "application/json")
    
    // 执行请求
    w := httptest.NewRecorder()
    suite.router.ServeHTTP(w, req)
    
    // 断言响应
    assert.Equal(suite.T(), http.StatusOK, w.Code)
    
    var response map[string]interface{}
    json.Unmarshal(w.Body.Bytes(), &response)
    
    assert.Equal(suite.T(), float64(200), response["code"])
    assert.Equal(suite.T(), "操作成功", response["message"])
    
    userData := response["data"].(map[string]interface{})
    assert.Equal(suite.T(), "测试用户", userData["name"])
    assert.Equal(suite.T(), "13800138000", userData["mobile"])
}

// 测试登录API完整流程
func (suite *AuthIntegrationTestSuite) TestLoginFlow() {
    // 1. 先注册用户
    registerData := request.Register{
        Name:     "测试用户",
        Mobile:   "13800138000",
        Password: "123456",
    }
    suite.registerUser(registerData)
    
    // 2. 登录获取Token
    loginData := request.Login{
        Mobile:   "13800138000",
        Password: "123456",
    }
    
    jsonData, _ := json.Marshal(loginData)
    req, _ := http.NewRequest("POST", "/api/auth/login", bytes.NewBuffer(jsonData))
    req.Header.Set("Content-Type", "application/json")
    
    w := httptest.NewRecorder()
    suite.router.ServeHTTP(w, req)
    
    // 断言登录响应
    assert.Equal(suite.T(), http.StatusOK, w.Code)
    
    var loginResponse map[string]interface{}
    json.Unmarshal(w.Body.Bytes(), &loginResponse)
    
    data := loginResponse["data"].(map[string]interface{})
    token := data["token"].(string)
    assert.NotEmpty(suite.T(), token)
    
    // 3. 使用Token获取用户信息
    req, _ = http.NewRequest("GET", "/api/auth/info", nil)
    req.Header.Set("Authorization", "Bearer "+token)
    
    w = httptest.NewRecorder()
    suite.router.ServeHTTP(w, req)
    
    // 断言用户信息响应
    assert.Equal(suite.T(), http.StatusOK, w.Code)
    
    var infoResponse map[string]interface{}
    json.Unmarshal(w.Body.Bytes(), &infoResponse)
    
    userData := infoResponse["data"].(map[string]interface{})
    assert.Equal(suite.T(), "测试用户", userData["name"])
}

// 辅助方法：注册用户
func (suite *AuthIntegrationTestSuite) registerUser(data request.Register) {
    jsonData, _ := json.Marshal(data)
    req, _ := http.NewRequest("POST", "/api/auth/register", bytes.NewBuffer(jsonData))
    req.Header.Set("Content-Type", "application/json")
    
    w := httptest.NewRecorder()
    suite.router.ServeHTTP(w, req)
}

func TestAuthIntegrationTestSuite(t *testing.T) {
    suite.Run(t, new(AuthIntegrationTestSuite))
}
```

### 前端集成测试
```javascript
// tests/integration/auth.test.js
import { mount } from '@vue/test-utils'
import { createPinia, setActivePinia } from 'pinia'
import { createRouter, createWebHistory } from 'vue-router'
import LoginForm from '@/components/LoginForm.vue'
import { useUserStore } from '@/stores/user'

describe('认证流程集成测试', () => {
  let wrapper
  let router
  let userStore

  beforeEach(async () => {
    // 设置路由
    router = createRouter({
      history: createWebHistory(),
      routes: [
        { path: '/', name: 'Home', component: { template: '<div>Home</div>' } },
        { path: '/login', name: 'Login', component: LoginForm }
      ]
    })

    // 设置 Pinia
    setActivePinia(createPinia())
    userStore = useUserStore()

    // 挂载组件
    wrapper = mount(LoginForm, {
      global: {
        plugins: [router]
      }
    })

    await router.isReady()
  })

  afterEach(() => {
    wrapper.unmount()
  })

  it('应该完成完整的登录流程', async () => {
    // 模拟API响应
    const mockLogin = vi.fn().mockResolvedValue(true)
    userStore.login = mockLogin

    // 填写登录表单
    const mobileInput = wrapper.find('input[type="tel"]')
    const passwordInput = wrapper.find('input[type="password"]')
    const submitButton = wrapper.find('button[type="submit"]')

    await mobileInput.setValue('13800138000')
    await passwordInput.setValue('123456')

    // 提交表单
    await submitButton.trigger('click')

    // 断言登录方法被调用
    expect(mockLogin).toHaveBeenCalledWith({
      mobile: '13800138000',
      password: '123456'
    })
  })

  it('应该在登录失败时显示错误信息', async () => {
    // 模拟登录失败
    const mockLogin = vi.fn().mockResolvedValue(false)
    userStore.login = mockLogin

    // 填写表单并提交
    await wrapper.find('input[type="tel"]').setValue('13800138000')
    await wrapper.find('input[type="password"]').setValue('wrongpassword')
    await wrapper.find('button[type="submit"]').trigger('click')

    // 等待下一个tick
    await wrapper.vm.$nextTick()

    // 断言错误信息显示
    expect(wrapper.find('.error-message').exists()).toBe(true)
  })
})
```

## 🎭 E2E测试

### Playwright E2E测试
```javascript
// tests/e2e/auth-flow.spec.js
import { test, expect } from '@playwright/test'

test.describe('用户认证流程', () => {
  test.beforeEach(async ({ page }) => {
    // 访问应用首页
    await page.goto('http://localhost:3000')
  })

  test('完整的用户注册登录流程', async ({ page }) => {
    // 1. 点击注册按钮
    await page.click('text=注册')
    await expect(page).toHaveURL(/.*register/)

    // 2. 填写注册表单
    await page.fill('input[placeholder="请输入用户名"]', '测试用户')
    await page.fill('input[placeholder="请输入手机号"]', '13800138000')
    await page.fill('input[placeholder="请输入密码"]', '123456')
    
    // 3. 提交注册
    await page.click('button:has-text("注册")')
    
    // 4. 断言注册成功，跳转到登录页
    await expect(page).toHaveURL(/.*login/)
    await expect(page.locator('.success-message')).toContainText('注册成功')

    // 5. 填写登录表单
    await page.fill('input[placeholder="请输入手机号"]', '13800138000')
    await page.fill('input[placeholder="请输入密码"]', '123456')
    
    // 6. 提交登录
    await page.click('button:has-text("登录")')
    
    // 7. 断言登录成功，跳转到首页
    await expect(page).toHaveURL('http://localhost:3000/')
    await expect(page.locator('.user-name')).toContainText('测试用户')
  })

  test('登录失败的错误处理', async ({ page }) => {
    // 访问登录页
    await page.goto('http://localhost:3000/login')

    // 输入错误的凭据
    await page.fill('input[placeholder="请输入手机号"]', '13800138000')
    await page.fill('input[placeholder="请输入密码"]', 'wrongpassword')
    
    // 提交登录
    await page.click('button:has-text("登录")')
    
    // 断言错误信息显示
    await expect(page.locator('.error-message')).toContainText('手机号或密码错误')
    
    // 断言仍在登录页
    await expect(page).toHaveURL(/.*login/)
  })

  test('用户信息管理流程', async ({ page }) => {
    // 先登录（可以使用测试数据或API直接设置登录状态）
    await page.goto('http://localhost:3000/login')
    await page.fill('input[placeholder="请输入手机号"]', '13800138000')
    await page.fill('input[placeholder="请输入密码"]', '123456')
    await page.click('button:has-text("登录")')
    
    // 访问用户资料页
    await page.click('text=个人资料')
    await expect(page).toHaveURL(/.*profile/)
    
    // 修改用户信息
    await page.click('button:has-text("编辑资料")')
    await page.fill('input[placeholder="请输入用户名"]', '修改后的用户名')
    await page.click('button:has-text("保存")')
    
    // 断言修改成功
    await expect(page.locator('.success-message')).toContainText('更新成功')
    await expect(page.locator('.user-name')).toContainText('修改后的用户名')
  })

  test('登出功能', async ({ page }) => {
    // 登录后访问首页
    await page.goto('http://localhost:3000/')
    // ... 登录流程 ...
    
    // 点击登出
    await page.click('button:has-text("登出")')
    
    // 断言跳转到登录页
    await expect(page).toHaveURL(/.*login/)
    
    // 断言无法访问需要认证的页面
    await page.goto('http://localhost:3000/profile')
    await expect(page).toHaveURL(/.*login/)
  })
})
```

## 📊 测试执行和报告

### 测试命令配置
```json
// package.json
{
  "scripts": {
    "test": "npm run test:unit && npm run test:integration && npm run test:e2e",
    "test:unit": "vitest run",
    "test:unit:watch": "vitest",
    "test:integration": "vitest run tests/integration",
    "test:e2e": "playwright test",
    "test:e2e:ui": "playwright test --ui",
    "test:coverage": "vitest run --coverage",
    "test:report": "allure generate allure-results --clean && allure open"
  }
}
```

### Go测试命令
```bash
# 运行所有测试
go test ./...

# 运行特定包的测试
go test ./app/services

# 生成覆盖率报告
go test -coverprofile=coverage.out ./...
go tool cover -html=coverage.out -o coverage.html

# 运行基准测试
go test -bench=. ./...

# 详细输出
go test -v ./...
```

### CI/CD集成
```yaml
# .github/workflows/test.yml
name: 测试流水线

on: [push, pull_request]

jobs:
  backend-test:
    runs-on: ubuntu-latest
    services:
      mysql:
        image: mysql:8.0
        env:
          MYSQL_ROOT_PASSWORD: root
          MYSQL_DATABASE: gin_web_test
        ports:
          - 3306:3306
      redis:
        image: redis:6
        ports:
          - 6379:6379
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Go
        uses: actions/setup-go@v3
        with:
          go-version: 1.22
      
      - name: 运行后端测试
        working-directory: ./backend
        run: |
          go mod tidy
          go test -v -coverprofile=coverage.out ./...
          go tool cover -func=coverage.out
  
  frontend-test:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: 18
      
      - name: 安装依赖
        working-directory: ./frontend
        run: npm ci
      
      - name: 运行单元测试
        working-directory: ./frontend
        run: npm run test:unit
      
      - name: 运行E2E测试
        working-directory: ./frontend
        run: |
          npm run build
          npx playwright install
          npm run test:e2e
```

## 🎯 测试最佳实践

### 测试命名规范
```go
// 好的测试名称
func TestUserService_Register_Success(t *testing.T) {}
func TestUserService_Register_DuplicateMobile(t *testing.T) {}
func TestUserService_Login_WrongPassword(t *testing.T) {}

// 避免的测试名称
func TestRegister(t *testing.T) {}
func TestUser(t *testing.T) {}
```

### 测试数据管理
```go
// 使用测试工厂模式
func CreateTestUser(overrides ...func(*models.User)) models.User {
    user := models.User{
        Name:     "默认测试用户",
        Mobile:   "13800138000",
        Password: "hashedpassword",
        Status:   1,
    }
    
    for _, override := range overrides {
        override(&user)
    }
    
    global.App.DB.Create(&user)
    return user
}

// 使用示例
user1 := CreateTestUser() // 使用默认值
user2 := CreateTestUser(func(u *models.User) {
    u.Mobile = "13800138001"
    u.Name = "特定测试用户"
})
```

### 断言模式
```javascript
// 好的断言
expect(response.status).toBe(200)
expect(response.data.user.name).toBe('期望的用户名')
expect(mockFunction).toHaveBeenCalledWith(expectedParams)

// 避免的断言
expect(response).toBeTruthy() // 太宽泛
expect(response.data).toEqual(expect.any(Object)) // 缺乏具体性
```

---

**文档版本**: v1.0  
**最后更新**: 2024-12-19  
**测试负责人**: QA工程师  
**技术负责人**: 开发团队负责人 