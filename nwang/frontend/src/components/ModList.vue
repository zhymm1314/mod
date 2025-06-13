<template>
  <div class="mod-list">
    <!-- 加载状态 -->
    <div v-if="loading" class="loading">
      <p>加载中...</p>
    </div>
    
    <!-- 搜索结果统计 -->
    <div v-if="!loading && mods.length > 0" class="search-stats">
      找到 {{ total }} 个mod，第 {{ currentPage }}/{{ totalPages }} 页
    </div>
    
    <!-- mod列表 -->
    <div v-if="!loading && mods.length > 0" class="mod-grid-container">
      <div class="mod-grid" :style="{ '--mod-count': mods.length }">
      <div v-for="mod in mods" :key="mod.id" class="mod-card">
        <div class="mod-header">
          <h3 class="mod-name">{{ mod.name }}</h3>
          <span class="mod-version">v{{ mod.version }}</span>
        </div>
        
        <div class="mod-info">
          <div class="mod-meta">
            <span class="mod-game">🎮 {{ mod.game_name }}</span>
            <span class="mod-author">👤 {{ mod.author }}</span>
          </div>
          
          <div class="mod-categories">
            <span 
              v-for="category in mod.categories" 
              :key="category" 
              class="category-tag"
            >
              {{ category }}
            </span>
          </div>
          
          <div class="mod-stats">
            <span class="stat-item">
              ⭐ {{ mod.rating.toFixed(1) }}
            </span>
            <span class="stat-item">
              📥 {{ formatDownloadCount(mod.download_count) }}
            </span>
            <span class="stat-item">
              📦 {{ formatFileSize(mod.file_size) }}
            </span>
          </div>
          
          <div class="mod-date">
            更新时间: {{ formatDate(mod.updated_at) }}
          </div>
        </div>
        
        <div class="mod-actions">
          <button @click="viewDetail(mod.id)" class="btn-detail">
            查看详情
          </button>
          <button @click="downloadMod(mod.id)" class="btn-download">
            下载
          </button>
        </div>
      </div>
    </div>
    </div>
    
    <!-- 空状态 -->
    <div v-if="!loading && mods.length === 0" class="empty-state">
      <p>暂无找到相关mod</p>
      <p>尝试修改搜索条件或关键词</p>
    </div>
    
    <!-- 分页 -->
    <div v-if="!loading && totalPages > 1" class="pagination">
      <button 
        @click="changePage(currentPage - 1)" 
        :disabled="currentPage <= 1"
        class="page-btn"
      >
        上一页
      </button>
      
      <span class="page-info">
        第 {{ currentPage }} 页 / 共 {{ totalPages }} 页
      </span>
      
      <button 
        @click="changePage(currentPage + 1)" 
        :disabled="currentPage >= totalPages"
        class="page-btn"
      >
        下一页
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { getDownloadUrl } from '../api/modApi.js'

// 定义props
const props = defineProps({
  mods: {
    type: Array,
    default: () => []
  },
  loading: {
    type: Boolean,
    default: false
  },
  total: {
    type: Number,
    default: 0
  },
  currentPage: {
    type: Number,
    default: 1
  },
  totalPages: {
    type: Number,
    default: 1
  }
})

// 定义事件
const emit = defineEmits(['page-change', 'view-detail'])

// 格式化下载次数
const formatDownloadCount = (count) => {
  if (count >= 1000000) {
    return (count / 1000000).toFixed(1) + 'M'
  } else if (count >= 1000) {
    return (count / 1000).toFixed(1) + 'K'
  }
  return count.toString()
}

// 格式化文件大小
const formatFileSize = (size) => {
  if (size === 0) return '未知'
  
  const units = ['B', 'KB', 'MB', 'GB']
  let index = 0
  let fileSize = size
  
  while (fileSize >= 1024 && index < units.length - 1) {
    fileSize /= 1024
    index++
  }
  
  return fileSize.toFixed(1) + ' ' + units[index]
}

// 格式化日期
const formatDate = (dateString) => {
  const date = new Date(dateString)
  return date.toLocaleDateString('zh-CN')
}

// 页面切换
const changePage = (page) => {
  if (page >= 1 && page <= props.totalPages) {
    emit('page-change', page)
  }
}

// 查看详情
const viewDetail = (id) => {
  emit('view-detail', id)
}

// 下载mod
const downloadMod = (id) => {
  const downloadUrl = getDownloadUrl(id)
  window.open(downloadUrl, '_blank')
}
</script>

<style>
/* 使用全局样式，避免scoped的问题 */
.mod-list {
  margin-top: 12px;
  width: 100% !important;
  max-width: none !important;
  padding: 0 !important;
  box-sizing: border-box !important;
}

.loading {
  text-align: center;
  padding: 40px;
  color: rgba(255, 255, 255, 0.8);
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border-radius: 12px;
  margin: 20px 0;
}

.search-stats {
  padding: 12px 16px;
  color: rgba(255, 255, 255, 0.9);
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border-radius: 8px;
  margin-bottom: 16px;
  font-size: 14px;
  font-weight: 500;
}

/* 网格容器 */
.mod-grid-container {
  width: 100% !important;
}

/* CSS Grid网格布局 - 多行多列 */
.mod-grid {
  display: grid !important;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)) !important;
  gap: 20px !important;
  width: 100% !important;
  margin: 0 !important;
  padding: 20px !important;
  box-sizing: border-box !important;
  /* 临时调试样式 */
  border: 3px solid red !important;
  background: yellow !important;
}

.mod-card {
  /* Grid项目自动适应网格 */
  background: white !important;
  border: 2px solid blue !important;
  border-radius: 12px !important;
  overflow: hidden !important;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1) !important;
  transition: all 0.3s ease !important;
  /* 确保卡片高度一致 */
  display: flex !important;
  flex-direction: column !important;
}

.mod-card:hover {
  transform: translateY(-4px) !important;
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.15) !important;
}

.mod-header {
  padding: 16px;
  border-bottom: 1px solid #eee;
  background: #f8f9fa;
}

.mod-name {
  font-size: 1.1rem;
  font-weight: 600;
  color: #333;
  margin: 0 0 8px 0;
}

.mod-version {
  display: inline-block;
  background: linear-gradient(135deg, #667eea, #764ba2);
  color: white;
  padding: 4px 8px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 500;
}

.mod-info {
  padding: 12px 16px;
  flex: 1; /* 占据剩余空间 */
}

.mod-meta {
  display: flex;
  justify-content: space-between;
  margin-bottom: 8px;
  font-size: 13px;
  color: #666;
}

.mod-categories {
  margin-bottom: 8px;
  min-height: 20px;
}

.category-tag {
  display: inline-block;
  background: #e3f2fd;
  color: #1976d2;
  padding: 2px 8px;
  border-radius: 10px;
  font-size: 11px;
  margin-right: 6px;
  margin-bottom: 4px;
  border: 1px solid #bbdefb;
}

.mod-stats {
  display: flex;
  justify-content: space-between;
  margin-bottom: 8px;
  font-size: 12px;
  color: #666;
}

.stat-item {
  display: flex;
  align-items: center;
  gap: 2px;
}

.mod-date {
  font-size: 11px;
  color: #888;
  text-align: right;
}

.mod-actions {
  padding: 12px 16px;
  background: #f8f9fa;
  display: flex;
  gap: 8px;
}

.btn-detail {
  flex: 1;
  padding: 8px 16px;
  background: #e3f2fd;
  color: #1976d2;
  border: 1px solid #bbdefb;
  border-radius: 6px;
  font-size: 13px;
  cursor: pointer;
}

.btn-download {
  flex: 1;
  padding: 8px 16px;
  background: #4caf50;
  color: white;
  border: none;
  border-radius: 6px;
  font-size: 13px;
  cursor: pointer;
}

.empty-state {
  text-align: center;
  padding: 60px 20px;
  color: rgba(255, 255, 255, 0.8);
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border-radius: 12px;
  margin: 20px 0;
}

.pagination {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 16px;
  margin-top: 24px;
  padding: 16px;
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border-radius: 12px;
}

.page-btn {
  padding: 10px 20px;
  background: linear-gradient(135deg, #667eea, #764ba2);
  color: white;
  border: none;
  border-radius: 8px;
  font-size: 14px;
  cursor: pointer;
}

.page-btn:disabled {
  background: #ccc;
  cursor: not-allowed;
}

.page-info {
  color: rgba(255, 255, 255, 0.9);
  font-size: 14px;
}

/* 响应式网格布局 */
/* 超大屏幕 (> 1400px) - 5列 */
@media (min-width: 1401px) {
  .mod-grid {
    grid-template-columns: repeat(auto-fill, minmax(260px, 1fr)) !important;
    gap: 24px !important;
  }
}

/* 大屏幕 (1201px - 1400px) - 4列 */
@media (max-width: 1400px) and (min-width: 1201px) {
  .mod-grid {
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)) !important;
    gap: 20px !important;
  }
}

/* 中等屏幕 (901px - 1200px) - 3列 */
@media (max-width: 1200px) and (min-width: 901px) {
  .mod-grid {
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)) !important;
    gap: 18px !important;
  }
}

/* 平板 (601px - 900px) - 2列 */
@media (max-width: 900px) and (min-width: 601px) {
  .mod-grid {
    grid-template-columns: repeat(auto-fill, minmax(260px, 1fr)) !important;
    gap: 16px !important;
    padding: 16px !important;
  }
}

/* 手机 (≤ 600px) - 1列 */
@media (max-width: 600px) {
  .mod-grid {
    grid-template-columns: 1fr !important;
    gap: 12px !important;
    padding: 12px !important;
  }
}
</style> 