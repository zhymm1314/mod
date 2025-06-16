# UI/UX 设计系统

## 🎨 设计原则

### 核心理念
- **简洁性**: 界面简洁清晰，避免冗余元素
- **一致性**: 保持设计语言和交互模式的统一
- **可用性**: 优先用户体验，操作简单直观
- **现代化**: 采用现代设计趋势，保持视觉新鲜感

### 设计价值观
- **用户至上**: 所有设计决策以用户需求为核心
- **性能优先**: 在美观的基础上确保性能表现
- **无障碍**: 考虑不同用户群体的使用需求
- **移动友好**: 移动端体验与桌面端同等重要

## 🌈 色彩规范

### 主色调
```css
/* 主色调 - 品牌色 */
--primary-color: #1890ff;        /* 主蓝色 */
--primary-light: #40a9ff;        /* 浅蓝色 */
--primary-dark: #096dd9;         /* 深蓝色 */

/* 辅助色 */
--secondary-color: #722ed1;      /* 紫色 */
--accent-color: #13c2c2;         /* 青色 */
```

### 功能色彩
```css
/* 状态色 */
--success-color: #52c41a;        /* 成功绿 */
--warning-color: #faad14;        /* 警告橙 */
--error-color: #ff4d4f;          /* 错误红 */
--info-color: #1890ff;           /* 信息蓝 */

/* 中性色 */
--text-primary: #262626;         /* 主要文本 */
--text-secondary: #8c8c8c;       /* 次要文本 */
--text-disabled: #bfbfbf;        /* 禁用文本 */
--border-color: #d9d9d9;         /* 边框色 */
--background-color: #fafafa;     /* 背景色 */
--white: #ffffff;                /* 纯白 */
```

### 色彩使用指南
```scss
// 按钮色彩使用
.btn-primary {
  background-color: var(--primary-color);
  border-color: var(--primary-color);
  color: var(--white);
  
  &:hover {
    background-color: var(--primary-light);
    border-color: var(--primary-light);
  }
}

.btn-success {
  background-color: var(--success-color);
  border-color: var(--success-color);
  color: var(--white);
}

// 文本色彩使用
.text-primary { color: var(--text-primary); }
.text-secondary { color: var(--text-secondary); }
.text-success { color: var(--success-color); }
.text-warning { color: var(--warning-color); }
.text-error { color: var(--error-color); }
```

## 📝 字体规范

### 字体族
```css
/* 字体栈 */
--font-family-base: -apple-system, BlinkMacSystemFont, 'Segoe UI', 
                    'PingFang SC', 'Hiragino Sans GB', 'Microsoft YaHei', 
                    'Helvetica Neue', Helvetica, Arial, sans-serif;

--font-family-code: 'SFMono-Regular', Consolas, 'Liberation Mono', 
                    Menlo, Courier, monospace;
```

### 字体大小
```css
/* 字体大小规范 */
--font-size-xs: 12px;            /* 辅助文本 */
--font-size-sm: 14px;            /* 正文小号 */
--font-size-base: 16px;          /* 正文基础 */
--font-size-lg: 18px;            /* 正文大号 */
--font-size-xl: 20px;            /* 小标题 */
--font-size-2xl: 24px;           /* 中标题 */
--font-size-3xl: 32px;           /* 大标题 */
```

### 行高规范
```css
/* 行高设置 */
--line-height-tight: 1.2;       /* 紧密行高 */
--line-height-base: 1.5;         /* 基础行高 */
--line-height-loose: 1.8;        /* 宽松行高 */
```

### 字体使用示例
```scss
// 标题样式
.title-1 {
  font-size: var(--font-size-3xl);
  line-height: var(--line-height-tight);
  font-weight: 600;
  color: var(--text-primary);
}

.title-2 {
  font-size: var(--font-size-2xl);
  line-height: var(--line-height-tight);
  font-weight: 500;
  color: var(--text-primary);
}

// 正文样式
.body-text {
  font-size: var(--font-size-base);
  line-height: var(--line-height-base);
  color: var(--text-primary);
}

.caption {
  font-size: var(--font-size-sm);
  line-height: var(--line-height-base);
  color: var(--text-secondary);
}
```

## 📏 间距规范

### 间距系统
```css
/* 8px 基础间距系统 */
--spacing-xs: 4px;               /* 极小间距 */
--spacing-sm: 8px;               /* 小间距 */
--spacing-md: 16px;              /* 中等间距 */
--spacing-lg: 24px;              /* 大间距 */
--spacing-xl: 32px;              /* 特大间距 */
--spacing-2xl: 48px;             /* 超大间距 */
--spacing-3xl: 64px;             /* 最大间距 */
```

### 布局间距应用
```scss
// 页面布局
.page-container {
  padding: var(--spacing-lg);
  
  @media (max-width: 768px) {
    padding: var(--spacing-md);
  }
}

// 卡片间距
.card {
  padding: var(--spacing-lg);
  margin-bottom: var(--spacing-md);
  
  .card-header {
    margin-bottom: var(--spacing-md);
  }
  
  .card-footer {
    margin-top: var(--spacing-md);
  }
}

// 表单间距
.form-item {
  margin-bottom: var(--spacing-md);
  
  .form-label {
    margin-bottom: var(--spacing-xs);
  }
}
```

## 📱 响应式布局规范

### 断点设置
```css
/* 响应式断点 */
--breakpoint-xs: 480px;          /* 手机竖屏 */
--breakpoint-sm: 768px;          /* 手机横屏/平板竖屏 */
--breakpoint-md: 1024px;         /* 平板横屏/小屏幕笔记本 */
--breakpoint-lg: 1280px;         /* 桌面显示器 */
--breakpoint-xl: 1440px;         /* 大屏显示器 */
--breakpoint-2xl: 1920px;        /* 超大屏显示器 */
```

### Grid 布局系统
```scss
// 12列栅格系统
.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 var(--spacing-md);
}

.row {
  display: grid;
  grid-template-columns: repeat(12, 1fr);
  gap: var(--spacing-md);
}

// 响应式列宽
.col-12 { grid-column: span 12; }
.col-6 { grid-column: span 6; }
.col-4 { grid-column: span 4; }
.col-3 { grid-column: span 3; }

@media (max-width: 768px) {
  .col-sm-12 { grid-column: span 12; }
  .col-sm-6 { grid-column: span 6; }
}

@media (max-width: 480px) {
  .col-xs-12 { grid-column: span 12; }
}
```

### Flexbox 布局工具类
```scss
// Flexbox 工具类
.flex { display: flex; }
.flex-col { flex-direction: column; }
.flex-wrap { flex-wrap: wrap; }

.justify-start { justify-content: flex-start; }
.justify-center { justify-content: center; }
.justify-end { justify-content: flex-end; }
.justify-between { justify-content: space-between; }

.items-start { align-items: flex-start; }
.items-center { align-items: center; }
.items-end { align-items: flex-end; }
.items-stretch { align-items: stretch; }

.flex-1 { flex: 1; }
.flex-auto { flex: auto; }
.flex-none { flex: none; }
```

## 🧩 组件库设计

### 按钮组件
```scss
// 按钮基础样式
.btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: var(--spacing-xs) var(--spacing-md);
  border: 1px solid transparent;
  border-radius: 6px;
  font-size: var(--font-size-base);
  line-height: 1.5;
  text-decoration: none;
  cursor: pointer;
  transition: all 0.2s ease;
  
  &:disabled {
    opacity: 0.6;
    cursor: not-allowed;
  }
}

// 按钮尺寸
.btn-sm {
  padding: var(--spacing-xs) var(--spacing-sm);
  font-size: var(--font-size-sm);
}

.btn-lg {
  padding: var(--spacing-sm) var(--spacing-lg);
  font-size: var(--font-size-lg);
}

// 按钮类型
.btn-primary {
  background-color: var(--primary-color);
  border-color: var(--primary-color);
  color: var(--white);
  
  &:hover:not(:disabled) {
    background-color: var(--primary-light);
    border-color: var(--primary-light);
  }
}

.btn-outline {
  background-color: transparent;
  border-color: var(--primary-color);
  color: var(--primary-color);
  
  &:hover:not(:disabled) {
    background-color: var(--primary-color);
    color: var(--white);
  }
}
```

### 输入框组件
```scss
// 输入框样式
.input {
  width: 100%;
  padding: var(--spacing-xs) var(--spacing-sm);
  border: 1px solid var(--border-color);
  border-radius: 6px;
  font-size: var(--font-size-base);
  line-height: 1.5;
  transition: border-color 0.2s ease;
  
  &:focus {
    outline: none;
    border-color: var(--primary-color);
    box-shadow: 0 0 0 2px rgba(24, 144, 255, 0.2);
  }
  
  &::placeholder {
    color: var(--text-disabled);
  }
  
  &:disabled {
    background-color: var(--background-color);
    cursor: not-allowed;
  }
}

// 输入框状态
.input-error {
  border-color: var(--error-color);
  
  &:focus {
    border-color: var(--error-color);
    box-shadow: 0 0 0 2px rgba(255, 77, 79, 0.2);
  }
}

.input-success {
  border-color: var(--success-color);
}
```

### 卡片组件
```scss
// 卡片样式
.card {
  background-color: var(--white);
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  overflow: hidden;
  transition: box-shadow 0.2s ease;
  
  &:hover {
    box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
  }
}

.card-header {
  padding: var(--spacing-lg);
  border-bottom: 1px solid var(--border-color);
  
  .card-title {
    margin: 0;
    font-size: var(--font-size-xl);
    font-weight: 600;
    color: var(--text-primary);
  }
}

.card-body {
  padding: var(--spacing-lg);
}

.card-footer {
  padding: var(--spacing-md) var(--spacing-lg);
  background-color: var(--background-color);
  border-top: 1px solid var(--border-color);
}
```

## 🔄 动画规范

### 过渡时间
```css
/* 动画时长 */
--transition-fast: 0.1s;         /* 快速过渡 */
--transition-base: 0.2s;         /* 基础过渡 */
--transition-slow: 0.3s;         /* 慢速过渡 */
```

### 缓动函数
```css
/* 缓动曲线 */
--ease-out: cubic-bezier(0.215, 0.61, 0.355, 1);
--ease-in: cubic-bezier(0.55, 0.055, 0.675, 0.19);
--ease-in-out: cubic-bezier(0.645, 0.045, 0.355, 1);
```

### 常用动画
```scss
// 淡入淡出
.fade-enter-active,
.fade-leave-active {
  transition: opacity var(--transition-base) var(--ease-in-out);
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

// 滑动动画
.slide-up-enter-active,
.slide-up-leave-active {
  transition: transform var(--transition-base) var(--ease-out);
}

.slide-up-enter-from {
  transform: translateY(20px);
}

.slide-up-leave-to {
  transform: translateY(-20px);
}

// 加载动画
@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.loading {
  animation: spin 1s linear infinite;
}
```

## 🌙 深色模式支持

### CSS变量切换
```css
/* 浅色模式 */
:root {
  --bg-primary: #ffffff;
  --bg-secondary: #fafafa;
  --text-primary: #262626;
  --text-secondary: #8c8c8c;
}

/* 深色模式 */
[data-theme="dark"] {
  --bg-primary: #1f1f1f;
  --bg-secondary: #262626;
  --text-primary: #ffffff;
  --text-secondary: #bfbfbf;
}

/* 组件样式使用变量 */
.card {
  background-color: var(--bg-primary);
  color: var(--text-primary);
}
```

### 主题切换实现
```javascript
// composables/useTheme.js
import { ref, watch } from 'vue'

export function useTheme() {
  const isDark = ref(false)
  
  const toggleTheme = () => {
    isDark.value = !isDark.value
  }
  
  const setTheme = (dark) => {
    isDark.value = dark
  }
  
  // 监听主题变化，更新DOM
  watch(isDark, (dark) => {
    if (dark) {
      document.documentElement.setAttribute('data-theme', 'dark')
    } else {
      document.documentElement.removeAttribute('data-theme')
    }
    
    // 持久化存储
    localStorage.setItem('theme', dark ? 'dark' : 'light')
  }, { immediate: true })
  
  // 初始化主题
  const initTheme = () => {
    const savedTheme = localStorage.getItem('theme')
    if (savedTheme) {
      isDark.value = savedTheme === 'dark'
    } else {
      // 跟随系统主题
      isDark.value = window.matchMedia('(prefers-color-scheme: dark)').matches
    }
  }
  
  return {
    isDark,
    toggleTheme,
    setTheme,
    initTheme
  }
}
```

## 📐 图标规范

### 图标系统
- **图标库**: Heroicons、Lucide React 或自定义图标
- **尺寸**: 16px, 20px, 24px, 32px
- **风格**: 线性图标，保持一致的描边宽度
- **色彩**: 继承文本颜色，支持主题切换

### 图标使用
```vue
<template>
  <!-- 图标组件 -->
  <Icon name="user" size="20" class="text-primary" />
  <Icon name="search" size="24" class="text-secondary" />
</template>

<style>
.icon {
  display: inline-block;
  width: var(--icon-size, 20px);
  height: var(--icon-size, 20px);
  fill: currentColor;
  vertical-align: middle;
}
</style>
```

---

**文档版本**: v1.0  
**最后更新**: 2024-12-19  
**设计负责人**: UI/UX设计师  
**技术负责人**: 前端开发工程师 