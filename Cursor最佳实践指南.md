# Cursor 最佳实践指南

> 一份全面的 Cursor AI 编程助手使用指南，助您提升开发效率

## 📋 目录

- [Cursor 简介](#-cursor-简介)
  - [核心特性](#核心特性)
- [收费机制详解](#-收费机制详解)
  - [免费版 (Hobby)](#-免费版-hobby)
  - [Pro 版](#-pro-版)
  - [Business 版](#-business-版)
  - [收费建议](#-收费建议)
- [模型选择策略](#-模型选择策略)
  - [模型对比表](#模型对比表)
  - [场景化模型选择](#场景化模型选择)
- [Cursor 基础使用指南](#-cursor-基础使用指南)
  - [Cursor 基础按键](#-cursor-基础按键)
  - [Rules 生成和配置方式](#rules-生成和配置方式)
  - [操作模式详解](#-操作模式详解)
  - [User Rules 实例和最佳实践](#-user-rules-实例和最佳实践)
  - [Rules 编写技巧](#-rules-编写技巧)
- [编程语言支持](#-编程语言支持)
  - [一级支持 (优秀)](#-一级支持-优秀)
  - [框架特定支持](#框架特定支持)
- [使用场景最佳实践](#-使用场景最佳实践)
  - [新项目开发](#-新项目开发)
  - [代码重构](#-代码重构)
  - [问题调试](#-问题调试)
  - [学习新技术](#-学习新技术)
- [推荐插件扩展](#-推荐插件扩展)
  - [AI 增强插件](#-ai-增强插件)
  - [快捷键和操作优化](#-快捷键和操作优化)
  - [语言特定插件](#-语言特定插件)
- [高级技巧](#-高级技巧)
- [常见问题解答](#-常见问题解答)
- [总结建议](#-总结建议)

## 🚀 Cursor 简介

Cursor 是一款基于 AI 的智能代码编辑器，集成了多种大语言模型，为开发者提供智能代码补全、代码生成、重构建议等功能。

### 核心特性
- **智能代码补全**: 基于上下文的精准代码建议
- **AI 对话编程**: 通过自然语言描述需求生成代码
- **代码重构**: 智能优化和重构现有代码
- **多模型支持**: 集成 Claude、GPT-4 等多种 AI 模型
- **项目理解**: 深度理解项目结构和代码逻辑

## 💰 收费机制详解

### 🆓 免费版 (Hobby)
```
价格: $0/月
包含内容:
├── 基础代码补全
├── 有限的 AI 对话次数 (~50次/月)
├── 基础模型访问 (GPT-3.5)
└── 社区支持

限制:
├── 每月使用次数限制
├── 无法使用高级模型
└── 功能相对基础
```

### 💎 Pro 版
```
价格: $20/月
包含内容:
├── 无限代码补全
├── 更多 AI 对话次数 (~500次/月)
├── 高级模型访问 (Claude-4-Sonnet, GPT-4)
├── 优先客户支持
├── 早期功能访问
└── 更快的响应速度

适合人群:
├── 专业开发者
├── 中小型团队
└── 重度 AI 编程用户
```

### 🏢 Business 版
```
价格: $40/月/用户
包含内容:
├── Pro 版所有功能
├── 团队管理功能
├── 企业级安全
├── 优先技术支持
├── 使用分析报告
└── 自定义集成

适合人群:
├── 企业团队
├── 大型项目
└── 需要团队协作的组织
```

### 💡 收费建议
- **个人开发者**: 建议从免费版开始，重度使用后升级 Pro
- **小团队**: Pro 版性价比最高
- **企业**: Business 版提供完整的企业级功能

[↑ 返回目录](#-目录)

## 🤖 模型选择策略

### 模型对比表

| 模型 | 适用场景 | 优势 | 劣势 | 推荐度 |
|------|----------|------|------|--------|
| **Claude-4-Sonnet** | 复杂逻辑、架构设计 | 推理能力强、代码质量高 | 响应稍慢 | ⭐⭐⭐⭐⭐ |
| **GPT-4** | 通用编程、文档生成 | 知识面广、创造性强 | 有时过于冗长 | ⭐⭐⭐⭐ |
| **GPT-4-Turbo** | 快速开发、原型设计 | 响应快、效率高 | 精度略低 | ⭐⭐⭐⭐ |
| **Claude-3.5-Sonnet** | 日常编程、代码补全 | 平衡性好、稳定 | 能力相对有限 | ⭐⭐⭐ |

### 场景化模型选择

#### 🏗️ 架构设计和复杂逻辑
```
推荐模型: Claude-4-Sonnet
使用场景:
├── 系统架构设计
├── 复杂算法实现
├── 设计模式应用
└── 性能优化方案

示例提示:
"设计一个高并发的用户认证系统，需要支持JWT、OAuth2.0，
并考虑Redis缓存和数据库连接池优化"
```

#### ⚡ 快速开发和原型
```
推荐模型: GPT-4-Turbo
使用场景:
├── 快速原型开发
├── 简单功能实现
├── 代码片段生成
└── 调试问题解决

示例提示:
"快速实现一个用户注册API接口，包含参数验证和数据库存储"
```

#### 📝 文档和注释
```
推荐模型: GPT-4
使用场景:
├── API 文档生成
├── 代码注释补充
├── README 编写
└── 技术方案文档

示例提示:
"为这个函数生成详细的JSDoc注释，包含参数说明和使用示例"
```

#### 🔧 代码重构和优化
```
推荐模型: Claude-4-Sonnet
使用场景:
├── 代码重构建议
├── 性能优化
├── 代码规范检查
└── 安全漏洞修复

示例提示:
"重构这段代码，提高可读性和性能，遵循SOLID原则"
```

[↑ 返回目录](#-目录)

## 📋 Cursor 基础使用指南

### ⌨️ Cursor 基础按键

在开始编写 Rules 之前，了解 Cursor 的基础操作快捷键能大大提升您的使用效率：

#### 🎯 **核心 AI 功能快捷键**

| 功能 | Windows/Linux | macOS | 说明 |
|------|---------------|-------|------|
| **AI 对话** | `Ctrl + K` | `Cmd + K` | 打开 AI 对话界面，最常用功能 |
| **行内编辑** | `Ctrl + I` | `Cmd + I` | 在当前行进行 AI 编辑 |
| **AI 代码补全** | `Tab` | `Tab` | 接受 AI 建议的代码补全 |
| **部分接受** | `Ctrl + →` | `Cmd + →` | 只接受建议的部分内容 |
| **拒绝建议** | `Esc` | `Esc` | 拒绝当前 AI 建议 |

#### 🔍 **代码分析和引用**

| 功能 | Windows/Linux | macOS | 说明 |
|------|---------------|-------|------|
| **引用文件** | `@filename` | `@filename` | 在对话中引用特定文件 |
| **引用代码块** | 选中 + `Ctrl + K` | 选中 + `Cmd + K` | 对选中代码进行 AI 分析 |
| **查看定义** | `F12` | `F12` | 跳转到函数/变量定义 |
| **查找引用** | `Shift + F12` | `Shift + F12` | 查找所有引用位置 |

#### 📁 **文件和项目操作**

| 功能 | Windows/Linux | macOS | 说明 |
|------|---------------|-------|------|
| **快速打开文件** | `Ctrl + P` | `Cmd + P` | 模糊搜索并打开文件 |
| **命令面板** | `Ctrl + Shift + P` | `Cmd + Shift + P` | 访问所有 Cursor 命令 |
| **侧边栏切换** | `Ctrl + B` | `Cmd + B` | 显示/隐藏侧边栏 |
| **终端切换** | `Ctrl + \`` | `Cmd + \`` | 显示/隐藏集成终端 |

#### 🎭 **操作模式切换**

| 模式 | 操作方式 | 特点 |
|------|----------|------|
| **Agent 模式** | 对话中明确说明 "使用 Agent 模式" | AI 直接修改文件 |
| **Ack 模式** | 默认模式 | AI 提供方案，用户确认后执行 |
| **Manual 模式** | 对话中说明 "仅提供建议，不修改代码" | AI 只给建议，不修改文件 |

#### 💡 **高效使用技巧**

```markdown
# 快速开发工作流
1. Ctrl/Cmd + K → 打开 AI 对话
2. 描述需求 → "实现用户登录功能"
3. @filename → 引用相关文件提供上下文
4. 选择操作模式 → Agent/Ack/Manual
5. Tab → 接受 AI 代码建议
6. Ctrl/Cmd + I → 针对特定行进行微调
```

#### 🔧 **自定义快捷键建议**

对于重度 Cursor 用户，建议自定义以下快捷键：

```json
// 在 Cursor 设置中添加
{
  "keybindings": [
    {
      "key": "ctrl+shift+k",
      "command": "cursor.openChat",
      "when": "editorTextFocus"
    },
    {
      "key": "alt+enter",
      "command": "cursor.acceptSuggestion",
      "when": "suggestWidgetVisible"
    }
  ]
}
```

#### 📱 **移动端和远程使用**

```
Cursor Web 版本:
- 基础快捷键与桌面版一致
- 触摸设备支持手势操作
- 云端同步 Rules 和设置

SSH 远程开发:
- 使用 Remote-SSH 插件
- 快捷键映射到远程服务器
- 保持本地 AI 功能可用
```

### Rules 文件结构
```
.cursor/
├── rules/
│   ├── frontend-guide.mdc      # 前端开发规范
│   ├── backend-guide.mdc       # 后端开发规范
│   ├── testing-guide.mdc       # 测试规范
│   └── communication-guide.mdc # 交流模式指南
└── .cursorignore              # 忽略文件配置
```

### 编写最佳实践

#### 1. 项目特定规范
```markdown
# 项目开发规范

## 技术栈
- 前端: Vue 3 + TypeScript + Tailwind CSS
- 后端: Go + Gin + MongoDB
- 测试: Vitest + Cypress

## 代码风格
- 使用 ESLint + Prettier
- 组件命名采用 PascalCase
- 函数命名采用 camelCase
- 常量命名采用 UPPER_SNAKE_CASE

## 文件结构
```
src/
├── components/     # 可复用组件
├── pages/         # 页面组件
├── hooks/         # 自定义 Hooks
├── utils/         # 工具函数
└── types/         # TypeScript 类型定义
```

#### 2. 交流模式定义
```markdown
# 交流模式指南

## [开发模式]
- 直接进行代码编写
- 优先考虑性能和可维护性
- 遵循项目规范

## [调试模式]
- 系统性分析错误
- 提供详细的调试步骤
- 给出根因分析

## [总结模式]
- 沉淀最佳实践
- 更新技术规范文档
- 提供可复用的解决方案
```

#### 3. 语言特定规范
```markdown
# Python 开发规范

## 代码风格
- 遵循 PEP 8 规范
- 使用 Black 进行代码格式化
- 使用 type hints 进行类型注解

## 项目结构
- 使用 Poetry 管理依赖
- 采用 src/ 布局
- 单元测试使用 pytest

## 最佳实践
- 使用 dataclasses 定义数据结构
- 异常处理要具体明确
- 文档字符串使用 Google 风格
```

### Rules 生成和配置方式

#### 🛠️ Rules 创建步骤

**1. 通过界面创建 Rules**
```
方式一: 通过 Cursor 界面
1. 打开 Cursor 设置 (Ctrl/Cmd + ,)
2. 搜索 "Cursor Rules" 或 "Rules for AI"
3. 点击 "Edit Rules" 按钮
4. 在编辑器中编写您的规则

方式二: 手动创建文件
1. 在项目根目录创建 .cursor/ 文件夹
2. 在 .cursor/ 文件夹内创建 rules 文件
3. 编写具体的开发规范和指导原则
```

> **注意**: 由于图片展示限制，建议您在 Cursor 中按照上述步骤操作，界面会有清晰的 Rules 编辑入口

**2. User Rules 配置 (个人偏好设置)**
```
位置: Cursor 设置 → User Rules
功能: 设置个人的开发偏好和交流风格
优先级: 高于项目 Rules，应用于所有项目
```

**3. 从原有项目生成 Rules (智能分析方式)**
```
方式三: AI 辅助生成项目 Rules
1. 打开 Cursor AI 对话界面 (Ctrl/Cmd + K)
2. 使用以下提示词让 AI 分析项目结构：

提示词模板:
"分析当前项目的代码结构、技术栈和编程风格，为我生成一套适合的 Cursor Rules 配置。
请重点关注：
- 项目使用的编程语言和框架
- 代码风格和命名规范
- 文件组织结构
- 依赖管理方式
- 测试框架和规范"

3. AI 会分析项目文件并生成定制化的 Rules
4. 复制生成的 Rules 内容到 .cursor/rules 文件中
5. 根据团队需求进行微调和完善
```

**实际操作示例:**
```markdown
# 示例对话过程

👤 用户: 分析我的 Vue + Go 项目，生成合适的 Cursor Rules

🤖 AI 分析结果:
基于您的项目分析，我发现：
- 前端框架: Vue 3 + TypeScript
- 状态管理: Pinia
- 样式方案: Tailwind CSS + CSS Modules
- 测试框架: Vitest + Vue Test Utils
- 构建工具: Vite
- 后端框架: Go + Gin
- 代码规范: ESLint + Prettier + gofmt

生成的 Rules 配置:
```typescript
# Vue + Go 全栈项目开发规范

## 前端技术栈要求
- 使用 Vue 3 Composition API
- 严格使用 TypeScript，避免 any 类型
- 优先使用 Pinia 进行状态管理
- 样式使用 Tailwind CSS 原子类

## Vue 组件开发规范
- 组件文件使用 PascalCase 命名
- Props 定义使用 defineProps<T>()
- 组合式函数以 use 开头
- 组件使用 <script setup> 语法

## Go 后端开发规范
- 遵循 Go 官方代码风格指南
- 使用 Gin 框架构建 REST API
- 错误处理要显式和具体
- 接口设计要简洁明确

## 代码质量要求
- Vue 组件必须有完整的 TypeScript 类型定义
- 复杂逻辑抽取为 composables
- 使用 v-memo 优化性能敏感组件
- Go 函数要有完整的错误处理
```

**更多语言项目示例:**

```markdown
# Python 项目分析示例
👤 用户: "分析我的 FastAPI + SQLAlchemy 项目，生成开发规范"

🤖 AI 生成的 Rules:
# Python FastAPI 项目开发规范

## 代码风格
- 遵循 PEP 8 和 Black 格式化规范
- 使用 type hints 进行严格类型注解
- 函数和变量使用 snake_case 命名
- 类名使用 PascalCase 命名

## API 开发规范
- 路由使用 APIRouter 进行模块化组织
- 响应模型必须继承 BaseModel
- 异常处理使用 HTTPException
- 依赖注入用于数据库连接和认证

## 数据库规范
- 模型定义使用 SQLAlchemy ORM
- 迁移文件使用 Alembic 管理
- 查询操作封装在 repository 层
- 事务处理确保数据一致性
```

```markdown
# Go 项目分析示例
👤 用户: "分析我的 Gin + GORM 微服务项目，生成规范"

🤖 AI 生成的 Rules:
# Go 微服务项目开发规范

## 代码组织
- 遵循 Go 官方项目布局标准
- 包名使用小写，简洁明了
- 接口定义要小而专一
- 错误处理要显式和具体

## API 开发规范
- 使用 Gin 框架构建 REST API
- 中间件用于认证、日志、限流
- 参数验证使用 validator 标签
- 响应格式统一，包含状态码和消息

## 微服务规范
- 服务间通信优先使用 gRPC
- 配置管理使用环境变量
- 日志格式采用结构化日志 (JSON)
- 健康检查和指标监控必须实现
```

**高级分析技巧:**

```markdown
# 深度分析提示词
"请深度分析我的项目，包括：
1. 📁 项目架构模式 (MVC/分层/微服务等)
2. 🔧 使用的设计模式和最佳实践
3. 📊 性能优化关注点
4. 🔒 安全规范和漏洞防护
5. 🧪 测试策略和覆盖率要求
6. 📝 文档和注释规范
7. 🚀 部署和运维考虑

基于分析结果生成完整的开发规范 Rules"
```

**智能生成的优势:**
- 🎯 **精准适配**: 基于实际项目代码分析，生成针对性规范
- 🚀 **快速启动**: 无需从零编写，大幅节省配置时间
- 📚 **学习参考**: 了解项目最佳实践和改进建议
- 🔄 **持续优化**: 随项目演进不断调整和完善规范
- 🤝 **团队协作**: 基于现有代码风格，减少团队分歧
- 🔍 **问题发现**: AI 可能识别出代码中的潜在问题和改进点

**使用注意事项:**
1. **隐私保护**: 确保项目中没有敏感信息泄露
2. **规范验证**: 生成的规范需要团队评审和确认
3. **定期更新**: 随着项目发展需要定期重新生成和调整
4. **渐进采用**: 可以分模块逐步应用生成的规范


#### 🎭 操作模式详解

**Agent 模式 (AI 自主操作)**
```
特点:
├── AI 直接编辑和修改文件
├── 自动化程度最高
├── 适合快速开发和原型制作
└── 需要明确的指导规则

使用场景:
├── 新项目快速搭建
├── 重复性代码生成
├── 批量文件处理
└── 自动化重构

风险控制:
├── 设置详细的 Rules 约束
├── 定期检查 AI 修改内容
├── 重要文件建议手动确认
└── 保持版本控制习惯
```

**Ack 模式 (确认后执行)**
```
特点:
├── AI 提供方案，用户确认后执行
├── 平衡了效率和安全性
├── 适合大多数开发场景
└── 可预览修改内容

使用场景:
├── 功能开发和修改
├── 代码重构和优化
├── 问题修复和调试
└── 新技术学习实践

操作流程:
1. 用户描述需求
2. AI 分析并提供方案
3. 用户确认或调整方案
4. AI 执行具体修改
```

**Manual 模式 (纯咨询模式)**
```
特点:
├── AI 只提供建议和代码示例
├── 用户手动实现所有修改
├── 最高的控制权和安全性
└── 适合学习和关键代码

使用场景:
├── 关键业务逻辑开发
├── 安全敏感代码
├── 学习新技术概念
└── 代码审查和咨询

优势:
├── 完全的代码控制权
├── 深度理解实现过程
├── 避免意外的代码修改
└── 适合团队规范要求
```

#### 🎯 User Rules 实例和最佳实践

**实例 1: 中文 Python 开发者配置**
```markdown
# 个人开发偏好 Rules

## 交流语言和风格
- Always respond in 中文, my programming language is Python
- 请用简洁的风格回复，避免不必要的重复或赘述
- 每次都用审视的目光，仔细看我输入的潜在问题
- 你要指出我的问题，并给出明显在我思考框架之外的建议
- 如果你觉得我说的太离谱，要及时指出
- 如果回答与之前的结果差不多，请仔细查看其他报错细节，换种思路解答给出建议

## Python 开发规范
- 优先使用 Python 3.9+ 语法特性
- 遵循 PEP 8 代码风格
- 使用 type hints 进行类型注解
- 异常处理要具体明确
- 优先考虑代码可读性和维护性

## 代码审查要求
- 检查潜在的性能问题
- 关注安全漏洞和边界条件
- 建议更好的算法和数据结构
- 提供单元测试建议
```

**实例 2: 全栈 JavaScript 开发者配置**
```markdown
# Full-Stack JavaScript Developer Rules

## Communication Style
- Provide concise, actionable responses
- Include code examples for complex concepts
- Explain the reasoning behind technical decisions
- Suggest alternative approaches when applicable

## Tech Stack Preferences
- Frontend: Vue 3 + TypeScript + Tailwind CSS
- Backend: Go + Gin + MongoDB/PostgreSQL
- Testing: Vitest + Vue Test Utils + Cypress
- Build Tools: Vite + ESLint + Prettier + gofmt

## Code Quality Standards
- Use TypeScript for all new JavaScript projects
- Implement proper error handling and logging
- Follow SOLID principles and clean code practices
- Ensure responsive design and accessibility
- Optimize for performance and SEO
```

**实例 3: Go 微服务开发者配置**
```markdown
# Go Microservices Developer Rules

## 开发规范
- 使用 Go 1.19+ 特性
- 遵循 Go 官方代码风格指南
- 优先使用标准库，谨慎引入第三方依赖
- 接口设计要简洁明确

## 微服务架构要求
- 每个服务职责单一，边界清晰
- 使用 gRPC 进行服务间通信
- 实现完整的可观测性 (日志/指标/链路追踪)
- 遵循 12-Factor App 原则

## 代码审查重点
- 并发安全和 goroutine 泄漏
- 错误处理和资源清理
- 性能优化和内存使用
- 单元测试覆盖率
```

#### 📝 Rules 编写技巧

**✅ 好的 Rules 示例**
```markdown
# 具体明确的指导
当用户要求实现用户认证时：
1. 使用 JWT 进行令牌管理
2. 密码使用 bcrypt 加密
3. 实现令牌刷新机制
4. 添加登录失败次数限制

# 提供代码模板
```typescript
// 用户认证接口标准模板
interface AuthService {
  login(credentials: LoginCredentials): Promise<AuthResult>;
  logout(token: string): Promise<void>;
  refreshToken(refreshToken: string): Promise<AuthResult>;
}
```

**❌ 避免的 Rules 写法**
```markdown
# 过于模糊的指导
- 写好代码
- 注意性能
- 遵循最佳实践

# 过于冗长的描述
（避免写几百行的详细说明，要简洁明了）
```

**💡 Rules 优化建议**
1. **分层设计**: User Rules (个人) → Project Rules (项目) → Feature Rules (功能)
2. **定期更新**: 根据项目进展和技术栈变化及时调整
3. **团队共享**: 重要的 Rules 可以作为团队规范分享
4. **测试验证**: 定期检查 AI 是否按照 Rules 执行
5. **版本控制**: 将 Rules 纳入版本控制，便于追踪变化

## 🌐 编程语言支持

### 🥇 一级支持 (优秀)
```
JavaScript/TypeScript
├── 智能补全: ⭐⭐⭐⭐⭐
├── 代码生成: ⭐⭐⭐⭐⭐
├── 重构建议: ⭐⭐⭐⭐⭐
└── 框架支持: Vue, React, Angular, Gin

Python
├── 智能补全: ⭐⭐⭐⭐⭐
├── 代码生成: ⭐⭐⭐⭐⭐
├── 重构建议: ⭐⭐⭐⭐
└── 框架支持: Django, Flask, FastAPI

Java
├── 智能补全: ⭐⭐⭐⭐
├── 代码生成: ⭐⭐⭐⭐
├── 重构建议: ⭐⭐⭐⭐
└── 框架支持: Spring, Spring Boot

Go
├── 智能补全: ⭐⭐⭐⭐
├── 代码生成: ⭐⭐⭐⭐
├── 重构建议: ⭐⭐⭐⭐
└── 框架支持: Gin, Echo, Fiber
```

### 🥈 二级支持 (良好)
```
C#, Rust, C++, PHP, Ruby, Swift, Kotlin
├── 基础功能完善
├── 代码补全准确
└── 部分高级功能支持
```

### 🥉 三级支持 (基础)
```
Dart, Scala, Haskell, Lua, Shell
├── 基础语法支持
├── 简单代码生成
└── 有限的智能建议
```

### 框架特定支持

#### 前端框架
- **Vue**: 组件生成、Composition API、状态管理、响应式数据
- **React**: Hook 使用、组件生命周期、状态管理
- **Angular**: 服务注入、组件生命周期、RxJS
- **Svelte**: 响应式语法、组件编写

#### 后端框架
- **Gin**: 路由组、中间件、JSON 处理、性能优化
- **Express.js**: 路由设计、中间件、错误处理
- **Django**: 模型设计、视图函数、模板系统
- **Spring Boot**: 注解使用、依赖注入、配置管理

## 🎯 使用场景最佳实践

### 🚀 新项目开发

#### 项目初始化
```
步骤 1: 项目规划
├── 使用 Claude-4-Sonnet 进行架构设计
├── 定义技术栈和项目结构
└── 创建开发规范 Rules

步骤 2: 基础搭建
├── 使用 GPT-4-Turbo 快速生成脚手架
├── 配置开发环境和工具链
└── 实现基础功能模块

步骤 3: 功能开发
├── 使用合适的模型进行功能实现
├── 遵循项目 Rules 规范
└── 持续重构和优化
```

#### 示例对话
```
用户: [开发模式] 创建一个电商网站的用户认证系统

AI 响应:
基于项目规范，我将为您创建一个完整的用户认证系统：

1. 数据库模型设计
2. JWT 令牌管理
3. 密码加密存储
4. 登录/注册接口
5. 权限中间件

[生成具体代码...]
```

### 🔧 代码重构

#### 重构策略
```
阶段 1: 代码分析
├── 使用 Claude-4-Sonnet 分析代码质量
├── 识别重构机会和风险点
└── 制定重构计划

阶段 2: 逐步重构
├── 小步快跑，逐个模块重构
├── 保持功能不变，提升代码质量
└── 添加单元测试保证稳定性

阶段 3: 验证优化
├── 性能测试和功能验证
├── 代码审查和规范检查
└── 文档更新和知识沉淀
```

### 🐛 问题调试

#### 调试流程
```
问题定位:
├── 描述问题现象和错误信息
├── 提供相关代码片段和日志
└── 说明复现步骤和环境信息

解决方案:
├── 使用 Claude-4-Sonnet 进行根因分析
├── 提供多种解决方案对比
└── 给出预防措施和最佳实践

验证修复:
├── 测试修复效果
├── 更新相关文档
└── 总结经验教训
```

### 📚 学习新技术

#### 学习路径
```
基础了解:
├── 使用 GPT-4 了解技术概念和原理
├── 获取学习资源和路线图
└── 理解应用场景和优势

实践练习:
├── 使用 GPT-4-Turbo 快速上手实践
├── 完成小项目和练习题
└── 解决实际问题和挑战

深入掌握:
├── 使用 Claude-4-Sonnet 学习高级特性
├── 理解最佳实践和设计模式
└── 能够独立解决复杂问题
```

## 🔌 推荐插件扩展

Cursor 基于 VS Code 构建，支持丰富的插件生态系统。以下是针对 AI 编程和开发效率优化的推荐插件：

### 🤖 AI 增强插件

#### 1. Auto Save on Window Change
```
插件名: Auto Save on Window Change
功能: 窗口切换时自动保存
适用场景: Agent 模式编程，频繁切换文件
安装: Ctrl+Shift+P → Extensions → 搜索 "Auto Save"

配置建议:
- 启用 "Auto Save: On Window Change"
- 设置延迟保存避免频繁写入
```

#### 2. Save Typing (推荐)
```
插件名: Save Typing / Auto Save
功能: 编辑即保存，无需手动 Ctrl+S
适用场景: AI 代码生成后立即保存
安装: Extensions → 搜索 "Save Typing"

配置示例:
{
  "files.autoSave": "afterDelay",
  "files.autoSaveDelay": 1000,
  "saveTyping.enable": true
}
```

#### 3. Code Spell Checker
```
插件名: Code Spell Checker
功能: 代码拼写检查，提升 AI 生成代码质量
适用场景: 变量命名、注释检查
特点: 支持多语言，可自定义词典
```

### ⌨️ 快捷键和操作优化

#### 1. IntelliJ IDEA Keybindings (强烈推荐)
```
插件名: IntelliJ IDEA Keybindings
功能: 提供 JetBrains IDE 同款快捷键
适用人群: 
├── IntelliJ IDEA 用户
├── WebStorm 用户
├── PyCharm 用户
└── 其他 JetBrains IDE 用户

常用快捷键映射:
├── Ctrl+Shift+F → 全局搜索
├── Ctrl+N → 快速打开类/文件
├── Ctrl+Shift+N → 快速打开文件
├── Alt+Enter → 快速修复
├── Ctrl+Alt+L → 格式化代码
└── Shift+F6 → 重命名
```

#### 2. Vim Keymap
```
插件名: Vim
功能: Vim 编辑模式支持
适用人群: Vim 用户
特点: 完整的 Vim 命令支持
```

#### 3. Emacs Keymap
```
插件名: Emacs Keymap
功能: Emacs 快捷键支持
适用人群: Emacs 用户
```

### 🎨 界面和主题优化

#### 1. Material Theme
```
插件名: Material Theme
功能: 现代化的界面主题
推荐主题:
├── Material Theme Ocean
├── Material Theme Darker
└── Material Theme Palenight
```

#### 2. Bracket Pair Colorizer
```
插件名: Bracket Pair Colorizer 2
功能: 括号配对着色
适用场景: 复杂嵌套代码阅读
特点: 提升代码可读性
```

#### 3. Indent Rainbow
```
插件名: Indent Rainbow
功能: 缩进层级彩色显示
适用场景: Python、YAML 等缩进敏感语言
```

### 🔧 开发效率插件

#### 1. GitLens
```
插件名: GitLens
功能: Git 增强工具
特性:
├── 行级 Git 信息显示
├── 提交历史可视化
├── 代码作者信息
└── 分支比较功能
```

#### 2. Live Server
```
插件名: Live Server
功能: 本地开发服务器
适用场景: 前端开发实时预览
特点: 自动刷新，支持热重载
```

#### 3. REST Client
```
插件名: REST Client
功能: API 测试工具
适用场景: 后端 API 开发测试
特点: 支持 HTTP 文件格式
```

#### 4. Thunder Client
```
插件名: Thunder Client
功能: 轻量级 API 测试工具
特点: 类似 Postman 的界面
适用场景: API 开发和调试
```

### 📝 代码质量插件

#### 1. ESLint
```
插件名: ESLint
功能: JavaScript/TypeScript 代码检查
配置: 自动检测项目配置文件
特点: 实时错误提示和修复建议
```

#### 2. Prettier
```
插件名: Prettier - Code formatter
功能: 代码格式化工具
支持语言: JS/TS/CSS/HTML/JSON/Markdown
配置建议:
{
  "editor.formatOnSave": true,
  "prettier.requireConfig": true
}
```

#### 3. SonarLint
```
插件名: SonarLint
功能: 代码质量和安全检查
特点: 实时检测代码异味和漏洞
支持: Java/JS/TS/Python/PHP/Go
```

### 🌐 语言特定插件

#### Python 开发
```
必装插件:
├── Python (官方)
├── Pylance (智能提示)
├── Python Docstring Generator
└── autoDocstring

推荐插件:
├── Python Test Explorer
├── Jupyter
└── Python Environment Manager
```

#### JavaScript/TypeScript 开发
```
必装插件:
├── TypeScript Importer
├── Auto Rename Tag
├── Vue Language Features (Volar)
└── JavaScript (ES6) code snippets

推荐插件:
├── Vue VSCode Snippets
├── Quokka.js (实时代码执行)
├── Import Cost (包大小显示)
└── Bundle Analyzer
```

#### Go 开发
```
必装插件:
├── Go (官方)
├── Go Test Explorer
└── Go Outline

推荐插件:
├── Go Doc
├── Go Mod Helper
└── Go Test Generator
```

#### Java 开发
```
必装插件:
├── Extension Pack for Java
├── Spring Boot Tools
├── Maven for Java
└── Gradle for Java

推荐插件:
├── Java Test Runner
├── Java Dependency Viewer
└── Spring Boot Dashboard
```

### 🚀 AI 编程专用插件配置

#### 针对 Agent 模式的优化配置
```json
{
  // 自动保存配置
  "files.autoSave": "afterDelay",
  "files.autoSaveDelay": 500,
  
  // 快速响应配置
  "editor.quickSuggestions": {
    "other": true,
    "comments": true,
    "strings": true
  },
  
  // AI 友好的编辑器设置
  "editor.acceptSuggestionOnCommitCharacter": true,
  "editor.acceptSuggestionOnEnter": "on",
  "editor.tabCompletion": "on",
  
  // 文件监控优化
  "files.watcherExclude": {
    "**/.git/objects/**": true,
    "**/node_modules/**": true,
    "**/tmp/**": true
  }
}
```

### 📦 插件安装和管理

#### 快速安装方法
```bash
# 方法1: 通过命令面板
Ctrl+Shift+P → Extensions: Install Extensions

# 方法2: 快捷键
Ctrl+Shift+X

# 方法3: 命令行安装 (如果支持)
cursor --install-extension ms-python.python
```

#### 插件管理最佳实践
```
1. 定期清理不用的插件
2. 关注插件更新和兼容性
3. 备份插件配置
4. 团队共享插件列表
5. 测试插件对性能的影响
```

### 🎯 插件推荐总结

#### 🌟 必装插件 (适合所有开发者)
1. **IntelliJ IDEA Keybindings** - JetBrains 用户必备
2. **Save Typing** - AI 编程效率神器
3. **GitLens** - Git 增强工具
4. **Prettier** - 代码格式化
5. **Material Theme** - 界面美化

#### ⚡ AI 编程特别推荐
1. **Auto Save on Window Change** - Agent 模式必备
2. **Code Spell Checker** - 提升代码质量
3. **Bracket Pair Colorizer** - 提升可读性
4. **REST Client** - API 测试
5. **Live Server** - 前端实时预览

#### 🔧 语言特定必装
- **Vue/TypeScript**: Vue Language Features (Volar) + Vue VSCode Snippets
- **Python**: Python + Pylance + autoDocstring
- **Go**: Go (官方) + Go Test Explorer
- **Java**: Extension Pack for Java + Spring Boot Tools

### 💡 插件使用技巧

1. **性能优化**: 只安装必需的插件，定期禁用不常用的插件
2. **快捷键冲突**: 注意插件间的快捷键冲突，及时调整
3. **配置同步**: 使用 Settings Sync 在多设备间同步插件配置
4. **团队协作**: 创建团队插件推荐列表，保持开发环境一致

## 🎨 高级技巧

### 1. 上下文管理
```markdown
# 有效的上下文提供
当前项目: Vue 3 + TypeScript + Tailwind CSS
当前文件: src/components/UserProfile.vue
需求: 添加用户头像上传功能

请基于现有代码风格实现...
```

### 2. 分步骤开发
```markdown
# 复杂功能分解
请分3个步骤实现用户管理系统:
1. 首先实现用户模型和数据库设计
2. 然后实现CRUD API接口
3. 最后实现前端用户界面

每个步骤完成后等待我确认再继续下一步
```

### 3. 代码审查模式
```markdown
# 代码审查请求
请审查以下代码，重点关注:
- 安全性问题
- 性能优化机会
- 代码规范遵循
- 可维护性改进

[粘贴代码...]
```

### 4. 多文件协作
```markdown
# 引用多个文件
@filename1.js @filename2.ts 
基于这两个文件的现有逻辑，实现新的功能模块
```

## ❓ 常见问题解答

### Q1: 如何选择合适的模型？
**A**: 根据任务复杂度选择：
- 简单任务 → GPT-4-Turbo (快速)
- 复杂逻辑 → Claude-4-Sonnet (精准)
- 文档生成 → GPT-4 (全面)

### Q2: Rules 文件多大合适？
**A**: 建议单个 Rules 文件控制在 200-500 行，过长会影响 AI 理解效果。

### Q3: 免费版够用吗？
**A**: 对于轻度使用够用，但重度开发建议升级 Pro 版获得更好体验。

### Q4: 如何提高代码生成质量？
**A**: 
- 提供清晰的需求描述
- 包含足够的上下文信息
- 使用项目特定的 Rules
- 分步骤进行复杂开发

### Q5: 支持团队协作吗？
**A**: Business 版支持团队功能，可以共享 Rules 和配置。

### Q6: User Rules 和 Project Rules 有什么区别？
**A**: 
- **User Rules**: 个人偏好设置，应用于所有项目，优先级最高
- **Project Rules**: 项目特定规范，只在当前项目生效
- **优先级**: User Rules > Project Rules > 默认规则
- **使用建议**: User Rules 设置个人习惯，Project Rules 设置技术规范

### Q7: Agent/Ack/Manual 模式如何选择？
**A**: 
- **Agent 模式**: 适合快速原型开发、重复性任务、有明确 Rules 约束的场景
- **Ack 模式**: 适合大多数开发场景，平衡效率和安全性
- **Manual 模式**: 适合关键业务逻辑、学习新技术、需要完全控制的场景

### Q8: Rules 不生效怎么办？
**A**: 
1. 检查 Rules 文件路径是否正确 (.cursor/rules 或设置中的 Rules)
2. 确认 Rules 语法格式正确
3. 重启 Cursor 使 Rules 生效
4. 检查 Rules 内容是否过于复杂或冲突
5. 尝试简化 Rules 内容进行测试

### Q9: 推荐的插件会影响 Cursor 性能吗？
**A**: 
- 适量安装插件不会明显影响性能
- 建议只安装必需的插件
- 定期禁用不常用的插件
- 关注插件的内存和CPU使用情况

### Q10: IntelliJ IDEA Keybindings 插件好用吗？
**A**: 
- 对 JetBrains IDE 用户来说非常友好
- 几乎完美复制了 IDEA 的快捷键体验
- 大大降低了从 IDEA 迁移到 Cursor 的学习成本
- 强烈推荐给习惯 JetBrains 快捷键的开发者

### Q11: Save Typing 插件如何配置？
**A**: 
```json
{
  "files.autoSave": "afterDelay",
  "files.autoSaveDelay": 1000,
  "saveTyping.enable": true
}
```
建议设置1秒延迟，避免过于频繁的保存操作。

### Q12: 如何调试 Rules 配置？
**A**: 
- 在对话中明确提到 Rules 要求，观察 AI 是否遵循
- 逐步添加 Rules 内容，测试每项规则的效果
- 使用简单明确的语言编写 Rules
- 定期检查和更新 Rules 内容
- 参考其他开发者的 Rules 示例进行优化

### Q13: Cursor 的快捷键可以自定义吗？
**A**: 
- 可以通过 `Ctrl/Cmd + Shift + P` 打开命令面板
- 搜索 "Preferences: Open Keyboard Shortcuts" 
- 可以修改现有快捷键或添加新的快捷键绑定
- 推荐为常用 AI 功能设置顺手的快捷键
- 可以导入 IntelliJ IDEA Keybindings 插件获得 JetBrains 风格快捷键

### Q14: Ctrl+K 和 Ctrl+I 有什么区别？
**A**: 
- **Ctrl+K**: 打开完整的 AI 对话界面，适合复杂需求和多轮对话
- **Ctrl+I**: 行内 AI 编辑，直接在当前光标位置进行快速修改
- **使用建议**: 简单修改用 Ctrl+I，复杂需求用 Ctrl+K
- **组合使用**: 先用 Ctrl+K 分析，再用 Ctrl+I 微调

### Q15: 如何快速引用多个文件？
**A**: 
- 在 AI 对话中使用 `@文件名` 语法
- 支持模糊匹配：`@user` 可能匹配到 `UserService.go`
- 可以同时引用多个文件：`@user.go @auth.go`
- 先选中代码再 `Ctrl+K` 会自动引用选中的代码片段
- 使用 `Ctrl+P` 快速查找文件名再复制引用

### Q16: Mac 和 Windows 快捷键完全一样吗？
**A**: 
- 核心功能快捷键基本一致，只是修饰键不同
- **Windows/Linux**: `Ctrl` 键 → **macOS**: `Cmd` 键
- **Windows/Linux**: `Alt` 键 → **macOS**: `Option` 键
- 建议 Mac 用户记住 `Cmd+K` 和 `Cmd+I` 这两个最重要的快捷键
- 详细对照表请查看 [Cursor 基础按键](#️-cursor-基础按键) 章节

## 🎯 总结建议

### 💡 最佳实践要点
1. **合理选择模型**: 根据任务特点选择最适合的 AI 模型
2. **编写清晰 Rules**: 为项目定制专门的开发规范
3. **优化插件配置**: 安装适合的插件提升开发效率
4. **渐进式使用**: 从简单任务开始，逐步掌握高级功能
5. **保持更新**: 关注 Cursor 新功能和模型更新
6. **团队协作**: 建立团队统一的使用规范和最佳实践

### 🚀 效率提升建议
- **快速原型**: 使用 AI 快速验证想法和方案
- **代码审查**: 让 AI 帮助发现潜在问题
- **学习助手**: 利用 AI 学习新技术和框架
- **文档生成**: 自动生成和维护项目文档
- **重构优化**: 持续改进代码质量和性能
- **插件生态**: 充分利用插件生态系统提升开发体验
- **快捷键优化**: 使用熟悉的快捷键映射提高操作效率

---

**让 AI 成为您的编程伙伴，而不是替代品！** 🤝

[↑ 返回顶部](#cursor-最佳实践指南)

---

> 本文档持续更新，欢迎反馈和建议  
> 最后更新: 2024年12月  
> 
> **快速导航**: [目录](#-目录) | [简介](#-cursor-简介) | [收费](#-收费机制详解) | [模型](#-模型选择策略) | [Rules](#-cursor-基础使用指南) | [插件](#-推荐插件扩展) | [FAQ](#-常见问题解答) 