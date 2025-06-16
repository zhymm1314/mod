# 📚 项目文档导航

> 嘿！欢迎来到我们的文档世界 🌟  
> 这里按开发维度整理，让你快速找到需要的内容，还能配合 **Cursor AI** 一起愉快编程！

## 🗂️ 文档结构

我们把文档分成了4个区域，就像整理房间一样井井有条：

```
docs/
├── 🎯 requirements/     需求和设计
├── 🎨 frontend/        前端开发  
├── ⚙️ backend/         后端开发
└── 🧪 testing/         测试相关
```

## 🚀 5分钟快速上手

### 新同学看这里 👋
1. **先了解项目**：看看 [产品需求](requirements/product-requirements.md) 知道我们在做什么
2. **搭建环境**：回到主目录的 `README.md` 按步骤来
3. **选择你的角色**：前端？后端？测试？直接跳到对应区域
4. **配置Cursor**：让AI助手了解我们的规则

### 按角色快速定位 🎭
- **产品同学** → `requirements/` 看需求文档
- **前端工程师** → `frontend/` + 用 `frontend-guide.mdc` 规则
- **后端工程师** → `backend/` + 用 `backend-guide.mdc` 规则  
- **测试工程师** → `testing/` + 用 `testing-guide.mdc` 规则

## 📋 各区域详情

### 🎯 需求设计区
**在这里找到**：产品需求、技术方案、API设计

| 文档 | 干什么用的 |
|------|-----------|
| [产品需求](requirements/product-requirements.md) | 了解功能需求和用户故事 |
| [技术需求](requirements/technical-requirements.md) | 架构决策和性能要求 |
| [API设计](requirements/api-design.md) | 接口规范和错误码 |

**Cursor用法**：`@docs/requirements/product-requirements.md 帮我分析这个需求`

### 🎨 前端开发区  
**在这里找到**：Vue3规范、设计系统、组件开发

| 文档 | 干什么用的 |
|------|-----------|
| [Vue3规范](frontend/vue-standards.md) | Composition API和组件设计 |
| [设计系统](frontend/design-system.md) | 颜色、字体、间距、组件库 |

**Cursor用法**：`@docs/frontend/vue-standards.md 帮我写个用户组件`

### ⚙️ 后端开发区
**在这里找到**：Go规范、Gin框架、MVC架构

| 文档 | 干什么用的 |
|------|-----------|
| [Go规范](backend/go-standards.md) | Go代码规范和最佳实践 |
| [Gin框架](backend/gin-framework.md) | MVC架构、中间件、路由 |
| [MVC架构](backend/backend-mvc-guide.md) | 架构设计和层次分离 |

**Cursor用法**：`@docs/backend/gin-framework.md 帮我实现登录API`

### 🧪 测试验证区
**在这里找到**：测试策略、单元测试、集成测试

| 文档 | 干什么用的 |
|------|-----------|
| [测试策略](testing/test-strategy.md) | 测试金字塔和覆盖率目标 |

**Cursor用法**：`@docs/testing/test-strategy.md 帮我写测试用例`

## 🤖 Cursor AI 协作技巧

### 单个功能开发
```bash
# 前端开发
@docs/frontend/vue-standards.md 创建用户资料页面

# 后端开发  
@docs/backend/gin-framework.md 实现用户API

# 写测试
@docs/testing/test-strategy.md 为用户服务写单元测试
```

### 全栈功能开发
```bash
# 一次性引用多个文档，让AI了解全貌
@docs/requirements/product-requirements.md @docs/frontend/vue-standards.md @docs/backend/gin-framework.md 实现完整的用户登录功能
```

## 📝 文档维护小贴士

- **文档会跟着代码一起更新**，不用担心过时
- **有问题随时提issue**，我们一起完善
- **重大改动会通知大家**，保持同步

---

**文档版本**: v1.0 | **最后更新**: 2025-06-16  
**维护**: 开发团队 | **特色**: 支持Cursor AI协作 🚀 