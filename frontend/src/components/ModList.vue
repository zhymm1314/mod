<template>
  <div class="mod-list">
    <!-- 加载状态 -->
    <div v-if="loading" class="loading">
      <div class="loading-spinner"></div>
      <p>正在搜索最适合的mod...</p>
    </div>
    
    <!-- 搜索结果统计 -->
    <div v-if="!loading && mods.length > 0" class="search-stats">
      <div class="stats-content">
        <span class="stats-number">{{ total }}</span>
        <span class="stats-text">个精选mod</span>
        <div class="stats-divider"></div>
        <span class="stats-page">第 {{ currentPage }}/{{ totalPages }} 页</span>
      </div>
    </div>
    
    <!-- mod列表 -->
    <div v-if="!loading && mods.length > 0" class="mod-grid-container">
      <div class="mod-grid">
        <div 
          v-for="mod in mods" 
          :key="mod.id" 
          class="mod-card"
          @click="viewDetail(mod.id)"
        >
          <!-- 卡片背景装饰 -->
          <div class="card-background"></div>
          
          <!-- 卡片头部 -->
          <div class="mod-header">
            <div class="mod-title-section">
              <h3 class="mod-name">{{ mod.name }}</h3>
              <span class="mod-version">v{{ mod.version }}</span>
            </div>
            <div class="mod-rating">
              <div class="rating-stars">
                <span v-for="n in 5" :key="n" class="star" :class="{ active: n <= Math.round(mod.rating) }">
                  ★
                </span>
              </div>
              <span class="rating-score">{{ mod.rating.toFixed(1) }}</span>
            </div>
          </div>
          
          <!-- 卡片内容 -->
          <div class="mod-content">
            <div class="mod-meta">
              <div class="meta-item">
                <div class="meta-icon game-icon">🎮</div>
                <span class="meta-text">{{ mod.game_name }}</span>
              </div>
              <div class="meta-item">
                <div class="meta-icon author-icon">👤</div>
                <span class="meta-text">{{ mod.author }}</span>
              </div>
            </div>
            
            <div class="mod-categories" v-if="mod.categories && mod.categories.length">
              <span 
                v-for="category in mod.categories.slice(0, 3)" 
                :key="category" 
                class="category-tag"
              >
                {{ category }}
              </span>
              <span v-if="mod.categories.length > 3" class="more-categories">
                +{{ mod.categories.length - 3 }}
              </span>
            </div>
            
            <div class="mod-stats">
              <div class="stat-item downloads">
                <div class="stat-icon">📥</div>
                <div class="stat-info">
                  <span class="stat-value">{{ formatDownloadCount(mod.download_count) }}</span>
                  <span class="stat-label">下载</span>
                </div>
              </div>
              <div class="stat-item size">
                <div class="stat-icon">📦</div>
                <div class="stat-info">
                  <span class="stat-value">{{ formatFileSize(mod.file_size) }}</span>
                  <span class="stat-label">大小</span>
                </div>
              </div>
              <div class="stat-item date">
                <div class="stat-icon">🕒</div>
                <div class="stat-info">
                  <span class="stat-value">{{ formatDate(mod.updated_at) }}</span>
                  <span class="stat-label">更新</span>
                </div>
              </div>
            </div>
          </div>
          
          <!-- 卡片操作按钮 -->
          <div class="mod-actions">
            <button @click.stop="viewDetail(mod.id)" class="btn-detail">
              <span class="btn-icon">👁️</span>
              <span>详情</span>
            </button>
            <button @click.stop="downloadMod(mod.id)" class="btn-download">
              <span class="btn-icon">⬇️</span>
              <span>下载</span>
            </button>
          </div>
          
          <!-- 悬停效果遮罩 -->
          <div class="hover-overlay"></div>
        </div>
      </div>
    </div>
    
    <!-- 空状态 -->
    <div v-if="!loading && mods.length === 0" class="empty-state">
      <div class="empty-icon">🔍</div>
      <h3>未找到相关mod</h3>
      <p>尝试调整搜索条件或关键词</p>
      <div class="empty-suggestions">
        <span class="suggestion-tag">热门游戏</span>
        <span class="suggestion-tag">最新上传</span>
        <span class="suggestion-tag">高评分</span>
      </div>
    </div>
    
    <!-- 分页 -->
    <div v-if="!loading && totalPages > 1" class="pagination">
      <button 
        @click="changePage(currentPage - 1)" 
        :disabled="currentPage <= 1"
        class="page-btn prev"
      >
        <span class="btn-icon">‹</span>
        <span>上一页</span>
      </button>
      
      <div class="page-numbers">
        <button
          v-for="page in getPageNumbers()"
          :key="page"
          @click="changePage(page)"
          :class="['page-number', { active: page === currentPage, ellipsis: page === '...' }]"
          :disabled="page === '...'"
        >
          {{ page }}
        </button>
      </div>
      
      <button 
        @click="changePage(currentPage + 1)" 
        :disabled="currentPage >= totalPages"
        class="page-btn next"
      >
        <span>下一页</span>
        <span class="btn-icon">›</span>
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
  const now = new Date()
  const diffTime = Math.abs(now - date)
  const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24))
  
  if (diffDays <= 1) return '今天'
  if (diffDays <= 7) return `${diffDays}天前`
  if (diffDays <= 30) return `${Math.ceil(diffDays / 7)}周前`
  if (diffDays <= 365) return `${Math.ceil(diffDays / 30)}月前`
  return `${Math.ceil(diffDays / 365)}年前`
}

// 页面切换
const changePage = (page) => {
  if (page >= 1 && page <= props.totalPages && page !== '...') {
    emit('page-change', page)
  }
}

// 获取页码数组
const getPageNumbers = () => {
  const pages = []
  const { currentPage, totalPages } = props
  
  if (totalPages <= 7) {
    for (let i = 1; i <= totalPages; i++) {
      pages.push(i)
    }
  } else {
    pages.push(1)
    if (currentPage > 4) pages.push('...')
    
    for (let i = Math.max(2, currentPage - 2); i <= Math.min(totalPages - 1, currentPage + 2); i++) {
      pages.push(i)
    }
    
    if (currentPage < totalPages - 3) pages.push('...')
    pages.push(totalPages)
  }
  
  return pages
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

<style scoped>
/* 主容器 */
.mod-list {
  margin-top: 16px;
  width: 100%;
  padding: 0;
}

/* 加载状态 */
.loading {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 80px 20px;
  background: rgba(255, 255, 255, 0.05);
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 24px;
  color: rgba(255, 255, 255, 0.9);
  margin: 20px 0;
}

.loading-spinner {
  width: 48px;
  height: 48px;
  border: 3px solid rgba(255, 255, 255, 0.1);
  border-top: 3px solid #667eea;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin-bottom: 16px;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

/* 搜索统计 */
.search-stats {
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.1), rgba(255, 255, 255, 0.05));
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 16px;
  padding: 20px 24px;
  margin-bottom: 24px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
}

.stats-content {
  display: flex;
  align-items: center;
  gap: 16px;
  color: rgba(255, 255, 255, 0.9);
}

.stats-number {
  font-size: 28px;
  font-weight: 700;
  background: linear-gradient(135deg, #667eea, #764ba2);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.stats-text {
  font-size: 16px;
  font-weight: 500;
}

.stats-divider {
  width: 1px;
  height: 24px;
  background: rgba(255, 255, 255, 0.2);
}

.stats-page {
  font-size: 14px;
  opacity: 0.8;
}

/* mod网格容器 */
.mod-grid-container {
  width: 100% !important;
  max-width: none !important;
  padding: 0 !important;
  margin: 0 !important;
}

.mod-grid {
  display: grid !important;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)) !important;
  gap: 20px !important;
  width: 100% !important;
  max-width: none !important;
  padding: 0 !important;
  margin: 0 !important;
}

/* 响应式Grid断点 */
/* 4K屏幕优化 (>2560px) */
@media (min-width: 2561px) {
  .mod-grid {
    grid-template-columns: repeat(auto-fill, minmax(380px, 1fr)) !important;
    gap: 32px !important;
  }
}

/* 2K屏幕 (1921px-2560px) */
@media (min-width: 1921px) and (max-width: 2560px) {
  .mod-grid {
    grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)) !important;
    gap: 28px !important;
  }
}

/* 大屏幕 (1401px-1920px) */
@media (min-width: 1401px) and (max-width: 1920px) {
  .mod-grid {
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)) !important;
    gap: 24px !important;
  }
}

@media (max-width: 1400px) {
  .mod-grid {
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)) !important;
    gap: 20px !important;
  }
}

@media (max-width: 1024px) {
  .mod-grid {
    grid-template-columns: repeat(auto-fill, minmax(260px, 1fr)) !important;
    gap: 16px !important;
  }
}

@media (max-width: 768px) {
  .mod-grid {
    grid-template-columns: repeat(auto-fill, minmax(240px, 1fr)) !important;
    gap: 12px !important;
  }
}

@media (max-width: 600px) {
  .mod-grid {
    grid-template-columns: 1fr !important;
    gap: 10px !important;
  }
}

/* mod卡片 */
.mod-card {
  position: relative;
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.1), rgba(255, 255, 255, 0.05));
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 20px;
  overflow: hidden;
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  cursor: pointer;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
  display: flex;
  flex-direction: column;
  min-height: 320px;
}

.mod-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 2px;
  background: linear-gradient(90deg, #667eea, #764ba2, #f093fb, #f5576c);
  opacity: 0;
  transition: opacity 0.3s ease;
}

.mod-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 20px 60px rgba(102, 126, 234, 0.2);
  border-color: rgba(255, 255, 255, 0.2);
}

.mod-card:hover::before {
  opacity: 1;
}

.card-background {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(135deg, 
    rgba(102, 126, 234, 0.03) 0%, 
    rgba(118, 75, 162, 0.03) 100%
  );
  opacity: 0;
  transition: opacity 0.3s ease;
}

.mod-card:hover .card-background {
  opacity: 1;
}

/* 卡片头部 */
.mod-header {
  padding: 24px 24px 16px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
}

.mod-title-section {
  flex: 1;
  margin-right: 16px;
}

.mod-name {
  font-size: 20px;
  font-weight: 700;
  color: rgba(255, 255, 255, 0.95);
  margin: 0 0 8px 0;
  line-height: 1.3;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.mod-version {
  display: inline-flex;
  align-items: center;
  background: linear-gradient(135deg, #667eea, #764ba2);
  color: white;
  padding: 6px 12px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 600;
  letter-spacing: 0.5px;
  box-shadow: 0 2px 8px rgba(102, 126, 234, 0.3);
}

.mod-rating {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  gap: 4px;
}

.rating-stars {
  display: flex;
  gap: 2px;
}

.star {
  color: rgba(255, 255, 255, 0.3);
  font-size: 14px;
  transition: color 0.2s ease;
}

.star.active {
  color: #ffd700;
  text-shadow: 0 0 8px rgba(255, 215, 0, 0.5);
}

.rating-score {
  font-size: 12px;
  font-weight: 600;
  color: rgba(255, 255, 255, 0.8);
  background: rgba(255, 255, 255, 0.1);
  padding: 2px 8px;
  border-radius: 8px;
}

/* 卡片内容 */
.mod-content {
  padding: 20px 24px;
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.mod-meta {
  display: flex;
  gap: 16px;
}

.meta-item {
  display: flex;
  align-items: center;
  gap: 8px;
  flex: 1;
}

.meta-icon {
  width: 32px;
  height: 32px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14px;
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
}

.game-icon {
  background: linear-gradient(135deg, #667eea, #764ba2);
}

.author-icon {
  background: linear-gradient(135deg, #f093fb, #f5576c);
}

.meta-text {
  font-size: 13px;
  font-weight: 500;
  color: rgba(255, 255, 255, 0.8);
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.mod-categories {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  min-height: 24px;
}

.category-tag {
  display: inline-flex;
  align-items: center;
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  color: rgba(255, 255, 255, 0.9);
  padding: 4px 12px;
  border-radius: 12px;
  font-size: 11px;
  font-weight: 500;
  border: 1px solid rgba(255, 255, 255, 0.1);
  transition: all 0.2s ease;
}

.category-tag:hover {
  background: rgba(255, 255, 255, 0.15);
  transform: translateY(-1px);
}

.more-categories {
  display: inline-flex;
  align-items: center;
  background: linear-gradient(135deg, #667eea, #764ba2);
  color: white;
  padding: 4px 10px;
  border-radius: 12px;
  font-size: 10px;
  font-weight: 600;
}

.mod-stats {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 12px;
  margin-top: auto;
}

.stat-item {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 12px;
  background: rgba(255, 255, 255, 0.05);
  backdrop-filter: blur(10px);
  border-radius: 12px;
  border: 1px solid rgba(255, 255, 255, 0.05);
  transition: all 0.2s ease;
}

.stat-item:hover {
  background: rgba(255, 255, 255, 0.1);
  border-color: rgba(255, 255, 255, 0.1);
}

.stat-icon {
  font-size: 16px;
  opacity: 0.8;
}

.stat-info {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.stat-value {
  font-size: 14px;
  font-weight: 600;
  color: rgba(255, 255, 255, 0.9);
}

.stat-label {
  font-size: 10px;
  font-weight: 500;
  color: rgba(255, 255, 255, 0.6);
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

/* 卡片操作按钮 */
.mod-actions {
  padding: 20px 24px 24px;
  display: flex;
  gap: 12px;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  background: rgba(255, 255, 255, 0.02);
}

.btn-detail,
.btn-download {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: 12px 20px;
  border: none;
  border-radius: 12px;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
  overflow: hidden;
}

.btn-detail {
  background: rgba(255, 255, 255, 0.1);
  color: rgba(255, 255, 255, 0.9);
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.btn-detail:hover {
  background: rgba(255, 255, 255, 0.15);
  border-color: rgba(255, 255, 255, 0.2);
  transform: translateY(-2px);
}

.btn-download {
  background: linear-gradient(135deg, #28a745, #20c997);
  color: white;
  box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
}

.btn-download:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(40, 167, 69, 0.4);
}

.btn-icon {
  font-size: 16px;
}

/* 悬停遮罩 */
.hover-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(135deg, 
    rgba(102, 126, 234, 0.1) 0%, 
    rgba(118, 75, 162, 0.1) 100%
  );
  opacity: 0;
  transition: opacity 0.3s ease;
  pointer-events: none;
}

.mod-card:hover .hover-overlay {
  opacity: 1;
}

/* 空状态 */
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 80px 20px;
  text-align: center;
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.05), rgba(255, 255, 255, 0.02));
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 24px;
  margin: 20px 0;
}

.empty-icon {
  font-size: 64px;
  margin-bottom: 20px;
  opacity: 0.6;
}

.empty-state h3 {
  font-size: 24px;
  font-weight: 700;
  color: rgba(255, 255, 255, 0.9);
  margin-bottom: 8px;
}

.empty-state p {
  font-size: 16px;
  color: rgba(255, 255, 255, 0.7);
  margin-bottom: 24px;
}

.empty-suggestions {
  display: flex;
  gap: 12px;
  flex-wrap: wrap;
  justify-content: center;
}

.suggestion-tag {
  padding: 8px 16px;
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  color: rgba(255, 255, 255, 0.8);
  border-radius: 20px;
  font-size: 12px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.suggestion-tag:hover {
  background: rgba(255, 255, 255, 0.15);
  transform: translateY(-2px);
}

/* 分页 */
.pagination {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 16px;
  margin-top: 40px;
  padding: 24px;
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.05), rgba(255, 255, 255, 0.02));
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 20px;
}

.page-btn {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 12px 20px;
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  color: rgba(255, 255, 255, 0.9);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 12px;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
}

.page-btn:not(:disabled):hover {
  background: rgba(255, 255, 255, 0.15);
  border-color: rgba(255, 255, 255, 0.2);
  transform: translateY(-2px);
}

.page-btn:disabled {
  opacity: 0.4;
  cursor: not-allowed;
}

.page-numbers {
  display: flex;
  gap: 8px;
  align-items: center;
}

.page-number {
  width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(255, 255, 255, 0.05);
  backdrop-filter: blur(10px);
  color: rgba(255, 255, 255, 0.8);
  border: 1px solid rgba(255, 255, 255, 0.05);
  border-radius: 10px;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
}

.page-number:not(.ellipsis):hover {
  background: rgba(255, 255, 255, 0.1);
  border-color: rgba(255, 255, 255, 0.1);
  transform: translateY(-1px);
}

.page-number.active {
  background: linear-gradient(135deg, #667eea, #764ba2);
  color: white;
  border-color: transparent;
  box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
}

.page-number.ellipsis {
  background: transparent;
  border: none;
  cursor: default;
  color: rgba(255, 255, 255, 0.5);
}

.btn-icon {
  font-size: 18px;
  font-weight: bold;
}

/* 响应式设计 */
@media (max-width: 1200px) {
  .mod-grid {
    grid-template-columns: repeat(auto-fill, minmax(340px, 1fr));
    gap: 20px;
  }
}

@media (max-width: 768px) {
  .mod-grid {
    grid-template-columns: 1fr;
    gap: 16px;
    padding: 0;
  }
  
  .mod-card {
    min-height: 300px;
  }
  
  .mod-header {
    padding: 20px 20px 16px;
  }
  
  .mod-content {
    padding: 16px 20px;
  }
  
  .mod-actions {
    padding: 16px 20px 20px;
  }
  
  .stats-content {
    flex-direction: column;
    align-items: flex-start;
    text-align: left;
    gap: 8px;
  }
  
  .stats-divider {
    width: 100%;
    height: 1px;
  }
  
  .pagination {
    flex-direction: column;
    gap: 16px;
  }
  
  .page-numbers {
    flex-wrap: wrap;
    justify-content: center;
  }
}

@media (max-width: 480px) {
  .search-stats {
    padding: 16px 20px;
  }
  
  .mod-header {
    flex-direction: column;
    gap: 12px;
    align-items: flex-start;
  }
  
  .mod-title-section {
    margin-right: 0;
  }
  
  .mod-rating {
    align-items: flex-start;
    flex-direction: row;
    gap: 8px;
  }
  
  .mod-meta {
    flex-direction: column;
    gap: 12px;
  }
  
  .meta-item {
    flex: none;
  }
  
  .mod-stats {
    grid-template-columns: 1fr;
    gap: 8px;
  }
  
  .mod-actions {
    flex-direction: column;
    gap: 8px;
  }
  
  .empty-state {
    padding: 60px 20px;
  }
  
  .empty-icon {
    font-size: 48px;
  }
}
</style> 