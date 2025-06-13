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
    <header class="app-header">
      <h1>🎮 Mod搜索平台</h1>
      <p>快速找到你需要的游戏mod</p>
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
    <div v-if="showDetail" class="modal-overlay" @click="closeDetail">
      <div class="modal-content" @click.stop>
        <div class="modal-header">
          <h2>{{ selectedMod?.name }}</h2>
          <button @click="closeDetail" class="close-btn">×</button>
        </div>
        
        <div v-if="selectedMod" class="modal-body">
          <div class="detail-info">
            <p><strong>游戏:</strong> {{ selectedMod.game?.name }}</p>
            <p><strong>作者:</strong> {{ selectedMod.author }}</p>
            <p><strong>版本:</strong> {{ selectedMod.version }}</p>
            <p><strong>评分:</strong> ⭐ {{ selectedMod.rating?.toFixed(1) }}</p>
            <p><strong>下载量:</strong> {{ formatDownloadCount(selectedMod.download_count) }}</p>
            <p><strong>文件大小:</strong> {{ formatFileSize(selectedMod.file_size) }}</p>
          </div>
          
          <div v-if="selectedMod.categories?.length" class="detail-categories">
            <strong>分类:</strong>
            <span 
              v-for="category in selectedMod.categories" 
              :key="category.id" 
              class="category-tag"
            >
              {{ category.name }}
            </span>
          </div>
          
          <div v-if="selectedMod.description" class="detail-description">
            <strong>描述:</strong>
            <p>{{ selectedMod.description }}</p>
          </div>
          
          <div class="detail-actions">
            <button 
              v-if="selectedMod.download_url" 
              @click="downloadMod(selectedMod.id)" 
              class="btn-download"
            >
              立即下载
            </button>
          </div>
        </div>
      </div>
    </div>
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
}

#app {
  min-height: 100vh;
}

.app-header {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  color: white;
  text-align: center;
  padding: 20px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.2);
}

.app-header h1 {
  font-size: 1.8rem;
  margin-bottom: 5px;
  font-weight: 600;
}

.app-header p {
  font-size: 0.9rem;
  opacity: 0.8;
}

.app-main {
  padding: 8px !important;
  width: 100vw !important;
  max-width: none !important;
  margin: 0 !important;
  box-sizing: border-box !important;
}

.container {
  width: 100% !important;
  max-width: none !important;
  padding: 0 !important;
  margin: 0 !important;
}

/* 模态框样式 */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.7);
  backdrop-filter: blur(4px);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
  padding: 20px;
}

.modal-content {
  background: white;
  border-radius: 12px;
  max-width: 600px;
  width: 100%;
  max-height: 85vh;
  overflow-y: auto;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px 24px;
  border-bottom: 1px solid #f0f0f0;
  background: #fafafa;
  border-radius: 12px 12px 0 0;
}

.modal-header h2 {
  margin: 0;
  color: #333;
  font-size: 1.4rem;
  font-weight: 600;
}

.close-btn {
  background: #f5f5f5;
  border: none;
  font-size: 18px;
  cursor: pointer;
  color: #666;
  padding: 8px;
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 6px;
  transition: all 0.2s;
}

.close-btn:hover {
  background: #e0e0e0;
  color: #333;
}

.modal-body {
  padding: 24px;
}

.detail-info {
  margin-bottom: 20px;
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 12px;
}

.detail-info p {
  margin-bottom: 8px;
  line-height: 1.5;
  font-size: 0.95rem;
  background: #f8f9fa;
  padding: 8px 12px;
  border-radius: 6px;
  border-left: 3px solid #667eea;
}

.detail-categories {
  margin-bottom: 20px;
}

.category-tag {
  display: inline-block;
  background: linear-gradient(135deg, #667eea, #764ba2);
  color: white;
  padding: 4px 12px;
  border-radius: 16px;
  font-size: 12px;
  font-weight: 500;
  margin-right: 8px;
  margin-top: 5px;
}

.detail-description {
  margin-bottom: 20px;
  background: #f8f9fa;
  padding: 16px;
  border-radius: 8px;
  border-left: 4px solid #667eea;
}

.detail-description p {
  margin-top: 10px;
  line-height: 1.6;
  color: #555;
}

.detail-actions {
  text-align: center;
  padding-top: 16px;
  border-top: 1px solid #f0f0f0;
}

.btn-download {
  background: linear-gradient(135deg, #28a745, #20c997);
  color: white;
  border: none;
  padding: 12px 32px;
  border-radius: 25px;
  font-size: 16px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
}

.btn-download:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(40, 167, 69, 0.4);
}

/* 响应式设计 */
@media (max-width: 768px) {
  .app-header {
    padding: 16px 12px;
  }
  
  .app-header h1 {
    font-size: 1.5rem;
  }
  
  .app-header p {
    font-size: 0.85rem;
  }
  
  .app-main {
    padding: 12px 16px;
  }
  
  .modal-overlay {
    padding: 12px;
  }
  
  .modal-content {
    width: 100%;
    max-height: 90vh;
  }
  
  .modal-header,
  .modal-body {
    padding: 16px;
  }
  
  .detail-info {
    grid-template-columns: 1fr;
    gap: 8px;
  }
  
  .detail-info p {
    font-size: 0.9rem;
    padding: 6px 10px;
  }
}

@media (max-width: 480px) {
  .app-header h1 {
    font-size: 1.3rem;
  }
  
  .app-main {
    padding: 8px 4px;
  }
  
  .modal-header,
  .modal-body {
    padding: 12px;
  }
}
</style>
