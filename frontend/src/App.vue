<script setup>
import { ref, onMounted } from 'vue'
import ModSearch from './components/ModSearch.vue'
import ModList from './components/ModList.vue'
import { searchMods, getModDetail, getDownloadUrl } from './api/modApi.js'

// 响应式数据
const mods = ref([])
const loading = ref(false)
const total = ref(0)
const currentPage = ref(1)
const totalPages = ref(1)
const showDetail = ref(false)
const selectedMod = ref(null)
const searchRef = ref(null)

// 搜索处理
const handleSearch = async (searchParams) => {
  try {
    loading.value = true
    const response = await searchMods(searchParams)
    
    if (response.error_code === 0) {
      mods.value = response.data.list || []
      total.value = response.data.total || 0
      currentPage.value = response.data.page || 1
      totalPages.value = response.data.total_pages || 1
    } else {
      console.error('搜索失败:', response.message)
      mods.value = []
    }
  } catch (error) {
    console.error('搜索出错:', error)
    mods.value = []
  } finally {
    loading.value = false
  }
}

// 分页处理
const handlePageChange = (page) => {
  if (searchRef.value) {
    searchRef.value.searchParams.page = page
    handleSearch(searchRef.value.searchParams)
  }
}

// 查看详情
const handleViewDetail = async (id) => {
  try {
    const response = await getModDetail(id)
    if (response.error_code === 0) {
      selectedMod.value = response.data
      showDetail.value = true
    }
  } catch (error) {
    console.error('获取详情失败:', error)
  }
}

// 关闭详情
const closeDetail = () => {
  showDetail.value = false
  selectedMod.value = null
}

// 下载mod
const downloadMod = (id) => {
  const downloadUrl = getDownloadUrl(id)
  window.open(downloadUrl, '_blank')
}

// 格式化函数
const formatDownloadCount = (count) => {
  if (count >= 1000000) {
    return (count / 1000000).toFixed(1) + 'M'
  } else if (count >= 1000) {
    return (count / 1000).toFixed(1) + 'K'
  }
  return count.toString()
}

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
</script>

<template>
  <div id="app">
    <!-- 动态背景 -->
    <div class="animated-background">
      <div class="bg-shapes">
        <div class="shape shape-1"></div>
        <div class="shape shape-2"></div>
        <div class="shape shape-3"></div>
        <div class="shape shape-4"></div>
      </div>
    </div>
    
    <header class="app-header">
      <div class="header-content">
        <div class="header-main">
          <h1 class="header-title">
            <span class="title-icon">🎮</span>
            <span class="title-text">Mod搜索平台</span>
            <span class="title-badge">Beta</span>
          </h1>
          <p class="header-subtitle">发现、下载和管理你的游戏mod</p>
        </div>
        <div class="header-stats">
          <div class="stat-item">
            <div class="stat-number">{{ total || '∞' }}</div>
            <div class="stat-label">精选mod</div>
          </div>
          <div class="stat-divider"></div>
          <div class="stat-item">
            <div class="stat-number">24/7</div>
            <div class="stat-label">在线服务</div>
          </div>
        </div>
      </div>
    </header>
    
    <main class="app-main">
      <div class="container">
        <!-- 搜索组件 -->
        <ModSearch @search="handleSearch" ref="searchRef" />
        
        <!-- mod列表组件 -->
        <ModList 
          :mods="mods"
          :loading="loading"
          :total="total"
          :current-page="currentPage"
          :total-pages="totalPages"
          @page-change="handlePageChange"
          @view-detail="handleViewDetail"
        />
      </div>
    </main>
    
    <!-- mod详情弹窗 -->
    <Transition name="modal">
      <div v-if="showDetail" class="modal-overlay" @click="closeDetail">
        <div class="modal-content" @click.stop>
          <div class="modal-header">
            <div class="modal-title-section">
              <h2 class="modal-title">{{ selectedMod?.name }}</h2>
              <div class="modal-meta">
                <span class="modal-version">v{{ selectedMod?.version }}</span>
                <div class="modal-rating" v-if="selectedMod?.rating">
                  <span class="rating-stars">
                    <span v-for="n in 5" :key="n" class="star" :class="{ active: n <= Math.round(selectedMod.rating) }">★</span>
                  </span>
                  <span class="rating-score">{{ selectedMod.rating.toFixed(1) }}</span>
                </div>
              </div>
            </div>
            <button @click="closeDetail" class="close-btn">
              <span>✕</span>
            </button>
          </div>
          
          <div v-if="selectedMod" class="modal-body">
            <div class="detail-grid">
              <div class="detail-left">
                <div class="detail-info-card">
                  <h3 class="card-title">基本信息</h3>
                  <div class="info-grid">
                    <div class="info-item">
                      <div class="info-icon game-icon">🎮</div>
                      <div class="info-content">
                        <span class="info-label">游戏</span>
                        <span class="info-value">{{ selectedMod.game?.name || selectedMod.game_name }}</span>
                      </div>
                    </div>
                    <div class="info-item">
                      <div class="info-icon author-icon">👤</div>
                      <div class="info-content">
                        <span class="info-label">作者</span>
                        <span class="info-value">{{ selectedMod.author }}</span>
                      </div>
                    </div>
                    <div class="info-item">
                      <div class="info-icon download-icon">📥</div>
                      <div class="info-content">
                        <span class="info-label">下载量</span>
                        <span class="info-value">{{ formatDownloadCount(selectedMod.download_count) }}</span>
                      </div>
                    </div>
                    <div class="info-item">
                      <div class="info-icon size-icon">📦</div>
                      <div class="info-content">
                        <span class="info-label">文件大小</span>
                        <span class="info-value">{{ formatFileSize(selectedMod.file_size) }}</span>
                      </div>
                    </div>
                  </div>
                </div>
                
                <div v-if="selectedMod.categories?.length" class="detail-categories-card">
                  <h3 class="card-title">分类标签</h3>
                  <div class="categories-grid">
                    <span 
                      v-for="category in selectedMod.categories" 
                      :key="category.id" 
                      class="category-chip"
                    >
                      {{ category.name || category }}
                    </span>
                  </div>
                </div>
              </div>
              
              <div class="detail-right">
                <div v-if="selectedMod.description" class="detail-description-card">
                  <h3 class="card-title">详细描述</h3>
                  <div class="description-content">
                    <p>{{ selectedMod.description }}</p>
                  </div>
                </div>
              </div>
            </div>
            
            <div class="modal-actions">
              <button 
                v-if="selectedMod.download_url" 
                @click="downloadMod(selectedMod.id)" 
                class="btn-download-large"
              >
                <span class="btn-icon">⬇️</span>
                <span class="btn-text">
                  <span class="btn-main">立即下载</span>
                  <span class="btn-sub">{{ formatFileSize(selectedMod.file_size) }}</span>
                </span>
              </button>
              <button @click="closeDetail" class="btn-close-large">
                <span class="btn-icon">👁️</span>
                <span>查看更多</span>
              </button>
            </div>
          </div>
        </div>
      </div>
    </Transition>
  </div>
</template>

<style>
/* 全局样式重置 */
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen',
    'Ubuntu', 'Cantarell', 'Fira Sans', 'Droid Sans', 'Helvetica Neue',
    sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  background-attachment: fixed;
  color: #333;
  line-height: 1.6;
  overflow-x: hidden !important;
  width: 100% !important;
  max-width: 100% !important;
}

#app {
  min-height: 100vh;
  position: relative;
}

/* 超宽屏幕优化 - 双栏布局 */
@media (min-width: 3200px) {
  #app {
    display: grid;
    grid-template-columns: 1fr 1fr;
    padding: 0 2rem;
    gap: 2rem;
  }
}

/* 动态背景 */
.animated-background {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  pointer-events: none;
  z-index: -1;
}

.bg-shapes {
  position: relative;
  width: 100%;
  height: 100%;
}

.shape {
  position: absolute;
  background: rgba(255, 255, 255, 0.03);
  border-radius: 50%;
  animation: float 20s ease-in-out infinite;
}

.shape-1 {
  width: 300px;
  height: 300px;
  top: 10%;
  left: 10%;
  animation-delay: 0s;
}

.shape-2 {
  width: 200px;
  height: 200px;
  top: 60%;
  right: 10%;
  animation-delay: 5s;
}

.shape-3 {
  width: 150px;
  height: 150px;
  bottom: 20%;
  left: 60%;
  animation-delay: 10s;
}

.shape-4 {
  width: 100px;
  height: 100px;
  top: 30%;
  right: 30%;
  animation-delay: 15s;
}

@keyframes float {
  0%, 100% {
    transform: translate(0, 0) rotate(0deg);
    opacity: 0.3;
  }
  25% {
    transform: translate(30px, -30px) rotate(90deg);
    opacity: 0.6;
  }
  50% {
    transform: translate(-20px, 20px) rotate(180deg);
    opacity: 0.3;
  }
  75% {
    transform: translate(20px, -40px) rotate(270deg);
    opacity: 0.6;
  }
}

/* 头部设计 */
.app-header {
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.1), rgba(255, 255, 255, 0.05));
  backdrop-filter: blur(20px);
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  padding: 24px 32px;
  position: relative;
  overflow: hidden;
}

.app-header::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 2px;
  background: linear-gradient(90deg, #667eea, #764ba2, #f093fb, #f5576c);
  opacity: 0.8;
}

.header-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  width: 100% !important;
  max-width: none !important;
  margin: 0 !important;
  padding: 0 !important;
  box-sizing: border-box !important;
}

.header-main {
  flex: 1;
}

.header-title {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-bottom: 8px;
  color: white;
}

.title-icon {
  font-size: 2.5rem;
  animation: pulse 2s ease-in-out infinite;
}

@keyframes pulse {
  0%, 100% { transform: scale(1); }
  50% { transform: scale(1.1); }
}

.title-text {
  font-size: 2.2rem;
  font-weight: 800;
  background: linear-gradient(135deg, #ffffff, #f0f0f0);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.title-badge {
  background: linear-gradient(135deg, #f093fb, #f5576c);
  color: white;
  padding: 4px 12px;
  border-radius: 12px;
  font-size: 0.7rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  box-shadow: 0 2px 8px rgba(240, 147, 251, 0.3);
}

.header-subtitle {
  font-size: 1.1rem;
  color: rgba(255, 255, 255, 0.8);
  font-weight: 400;
  margin-left: 60px;
}

.header-stats {
  display: flex;
  align-items: center;
  gap: 24px;
  padding: 16px 24px;
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(15px);
  border-radius: 16px;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.stat-item {
  text-align: center;
}

.stat-number {
  font-size: 1.8rem;
  font-weight: 800;
  color: white;
  background: linear-gradient(135deg, #667eea, #764ba2);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.stat-label {
  font-size: 0.8rem;
  color: rgba(255, 255, 255, 0.7);
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  margin-top: 2px;
}

.stat-divider {
  width: 1px;
  height: 32px;
  background: rgba(255, 255, 255, 0.2);
}

.app-main {
  padding: 8px !important;
  width: 100% !important;
  max-width: 2400px !important;
  margin: 0 auto !important;
  box-sizing: border-box !important;
}

/* 4K屏幕减少左右空白 */
@media (min-width: 2561px) {
  .app-main {
    padding: 12px 8px !important;
  }
}

/* 2K屏幕适中padding */
@media (min-width: 1921px) and (max-width: 2560px) {
  .app-main {
    padding: 10px 8px !important;
  }
}

/* 主容器 */
.container {
  width: 100% !important;
  max-width: 2400px !important;
  padding: 0 !important;
  margin: 0 auto !important;
}

/* Modal过渡动画 */
.modal-enter-active {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.modal-leave-active {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.modal-enter-from,
.modal-leave-to {
  opacity: 0;
  transform: scale(0.9);
}

.modal-enter-to,
.modal-leave-from {
  opacity: 1;
  transform: scale(1);
}

/* 模态框样式 */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.8);
  backdrop-filter: blur(8px);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
  padding: 20px;
}

.modal-content {
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.95), rgba(255, 255, 255, 0.9));
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.3);
  border-radius: 24px;
  max-width: 900px;
  width: 100%;
  max-height: 90vh;
  overflow-y: auto;
  box-shadow: 0 25px 80px rgba(0, 0, 0, 0.3);
  position: relative;
}

.modal-content::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 2px;
  background: linear-gradient(90deg, #667eea, #764ba2, #f093fb, #f5576c);
  border-radius: 24px 24px 0 0;
}

.modal-header {
  padding: 32px 32px 24px;
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  border-bottom: 1px solid rgba(0, 0, 0, 0.1);
  background: rgba(255, 255, 255, 0.1);
}

.modal-title-section {
  flex: 1;
}

.modal-title {
  font-size: 2rem;
  font-weight: 800;
  color: #333;
  margin: 0 0 12px 0;
  line-height: 1.2;
  background: linear-gradient(135deg, #333, #666);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.modal-meta {
  display: flex;
  align-items: center;
  gap: 16px;
}

.modal-version {
  background: linear-gradient(135deg, #667eea, #764ba2);
  color: white;
  padding: 6px 16px;
  border-radius: 16px;
  font-size: 14px;
  font-weight: 600;
  letter-spacing: 0.5px;
  box-shadow: 0 2px 8px rgba(102, 126, 234, 0.3);
}

.modal-rating {
  display: flex;
  align-items: center;
  gap: 8px;
}

.rating-stars {
  display: flex;
  gap: 2px;
}

.star {
  color: #ddd;
  font-size: 16px;
  transition: color 0.2s ease;
}

.star.active {
  color: #ffd700;
  text-shadow: 0 0 8px rgba(255, 215, 0, 0.5);
}

.rating-score {
  font-size: 14px;
  font-weight: 600;
  color: #666;
  background: rgba(0, 0, 0, 0.05);
  padding: 4px 10px;
  border-radius: 12px;
}

.close-btn {
  background: rgba(0, 0, 0, 0.05);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(0, 0, 0, 0.1);
  width: 40px;
  height: 40px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.3s ease;
  color: #666;
  font-size: 18px;
  font-weight: bold;
}

.close-btn:hover {
  background: rgba(0, 0, 0, 0.1);
  border-color: rgba(0, 0, 0, 0.2);
  transform: rotate(90deg);
  color: #333;
}

.modal-body {
  padding: 0 32px 32px;
}

.detail-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 24px;
  margin-bottom: 32px;
}

.detail-left,
.detail-right {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.detail-info-card,
.detail-categories-card,
.detail-description-card {
  background: rgba(255, 255, 255, 0.6);
  backdrop-filter: blur(15px);
  border: 1px solid rgba(0, 0, 0, 0.1);
  border-radius: 16px;
  padding: 20px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
}

.card-title {
  font-size: 1.2rem;
  font-weight: 700;
  color: #333;
  margin-bottom: 16px;
  background: linear-gradient(135deg, #667eea, #764ba2);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.info-grid {
  display: grid;
  gap: 16px;
}

.info-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px;
  background: rgba(255, 255, 255, 0.5);
  border-radius: 12px;
  border: 1px solid rgba(0, 0, 0, 0.05);
  transition: all 0.2s ease;
}

.info-item:hover {
  background: rgba(255, 255, 255, 0.7);
  transform: translateY(-1px);
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.info-icon {
  width: 36px;
  height: 36px;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 16px;
  color: white;
}

.game-icon {
  background: linear-gradient(135deg, #667eea, #764ba2);
}

.author-icon {
  background: linear-gradient(135deg, #f093fb, #f5576c);
}

.download-icon {
  background: linear-gradient(135deg, #28a745, #20c997);
}

.size-icon {
  background: linear-gradient(135deg, #ffc107, #ff6f00);
}

.info-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.info-label {
  font-size: 12px;
  font-weight: 600;
  color: #666;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.info-value {
  font-size: 14px;
  font-weight: 600;
  color: #333;
}

.categories-grid {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.category-chip {
  background: linear-gradient(135deg, #667eea, #764ba2);
  color: white;
  padding: 6px 14px;
  border-radius: 16px;
  font-size: 12px;
  font-weight: 600;
  box-shadow: 0 2px 8px rgba(102, 126, 234, 0.3);
  transition: all 0.2s ease;
}

.category-chip:hover {
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
}

.description-content {
  line-height: 1.6;
  color: #555;
  font-size: 15px;
}

.modal-actions {
  display: flex;
  gap: 16px;
  padding-top: 24px;
  border-top: 1px solid rgba(0, 0, 0, 0.1);
}

.btn-download-large {
  flex: 2;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 12px;
  padding: 16px 24px;
  background: linear-gradient(135deg, #28a745, #20c997);
  color: white;
  border: none;
  border-radius: 16px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 4px 20px rgba(40, 167, 69, 0.3);
  position: relative;
  overflow: hidden;
}

.btn-download-large::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
  transition: left 0.5s ease;
}

.btn-download-large:hover::before {
  left: 100%;
}

.btn-download-large:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 30px rgba(40, 167, 69, 0.4);
}

.btn-close-large {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: 16px 24px;
  background: rgba(0, 0, 0, 0.05);
  color: #666;
  border: 1px solid rgba(0, 0, 0, 0.1);
  border-radius: 16px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
}

.btn-close-large:hover {
  background: rgba(0, 0, 0, 0.1);
  border-color: rgba(0, 0, 0, 0.2);
  transform: translateY(-1px);
  color: #333;
}

.btn-text {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  gap: 2px;
}

.btn-main {
  font-size: 16px;
  font-weight: 700;
}

.btn-sub {
  font-size: 12px;
  opacity: 0.8;
  font-weight: 500;
}

/* 响应式设计 */
@media (max-width: 1024px) {
  .header-content {
    flex-direction: column;
    gap: 20px;
    text-align: center;
  }
  
  .header-subtitle {
    margin-left: 0;
  }
  
  .detail-grid {
    grid-template-columns: 1fr;
    gap: 20px;
  }
}

@media (max-width: 768px) {
  .app-header {
    padding: 20px 16px;
  }
  
  .title-text {
    font-size: 1.8rem;
  }
  
  .title-icon {
    font-size: 2rem;
  }
  
  .header-subtitle {
    font-size: 1rem;
  }
  
  .stat-number {
    font-size: 1.4rem;
  }
  
  .app-main {
    padding: 16px;
  }
  
  .modal-overlay {
    padding: 12px;
  }
  
  .modal-content {
    max-height: 95vh;
  }
  
  .modal-header {
    padding: 24px 20px 20px;
  }
  
  .modal-body {
    padding: 0 20px 24px;
  }
  
  .modal-title {
    font-size: 1.6rem;
  }
  
  .modal-actions {
    flex-direction: column;
    gap: 12px;
  }
  
  .btn-download-large,
  .btn-close-large {
    flex: none;
  }
}

@media (max-width: 480px) {
  .app-header {
    padding: 16px 12px;
  }
  
  .header-title {
    flex-direction: column;
    gap: 8px;
  }
  
  .title-text {
    font-size: 1.5rem;
  }
  
  .title-icon {
    font-size: 1.8rem;
  }
  
  .header-subtitle {
    font-size: 0.9rem;
  }
  
  .header-stats {
    padding: 12px 16px;
    gap: 16px;
  }
  
  .stat-number {
    font-size: 1.2rem;
  }
  
  .app-main {
    padding: 12px;
  }
  
  .modal-header {
    padding: 20px 16px 16px;
    flex-direction: column;
    gap: 16px;
    align-items: flex-start;
  }
  
  .modal-body {
    padding: 0 16px 20px;
  }
  
  .modal-title {
    font-size: 1.4rem;
  }
  
  .modal-meta {
    flex-direction: column;
    align-items: flex-start;
    gap: 8px;
  }
  
  .close-btn {
    align-self: flex-end;
    position: absolute;
    top: 16px;
    right: 16px;
  }
  
  .info-grid {
    gap: 12px;
  }
  
  .info-item {
    padding: 10px;
  }
  
  .info-icon {
    width: 32px;
    height: 32px;
    font-size: 14px;
  }
  
  .btn-download-large,
  .btn-close-large {
    padding: 14px 20px;
  }
  
  .btn-main {
    font-size: 14px;
  }
  
  .btn-sub {
    font-size: 11px;
  }
}
</style>
