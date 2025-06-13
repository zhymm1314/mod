<template>
  <div class="mod-search">
    <!-- 搜索表单 -->
    <div class="search-form">
      <!-- 主搜索区域 -->
      <div class="search-main">
        <div class="search-input-wrapper">
          <div class="search-icon">🔍</div>
          <input
            type="text"
            v-model="searchParams.keyword"
            placeholder="探索无限可能的mod世界..."
            class="search-input"
            @keyup.enter="handleSearch"
          />
          <button @click="handleSearch" class="search-btn" :disabled="loading">
            <div v-if="loading" class="btn-spinner"></div>
            <span v-else class="btn-text">搜索</span>
          </button>
        </div>
      </div>
      
      <!-- 筛选器区域 -->
      <div class="filters-section">
        <div class="filters-header">
          <span class="filters-title">精准筛选</span>
          <button @click="resetFilters" class="reset-btn">
            <span class="reset-icon">↻</span>
            <span>重置</span>
          </button>
        </div>
        
        <div class="filters-grid">
          <div class="filter-group">
            <label class="filter-label">游戏类型</label>
            <div class="filter-select-wrapper">
              <select v-model="searchParams.game_id" @change="handleSearch" class="filter-select">
                <option value="">全部游戏</option>
                <option v-for="game in games" :key="game.id" :value="game.id">
                  {{ game.name }}
                </option>
              </select>
              <div class="select-arrow">▼</div>
            </div>
          </div>
          
          <div class="filter-group">
            <label class="filter-label">mod分类</label>
            <div class="filter-select-wrapper">
              <select v-model="searchParams.category_id" @change="handleSearch" class="filter-select">
                <option value="">全部分类</option>
                <option v-for="category in categories" :key="category.id" :value="category.id">
                  {{ category.name }}
                </option>
              </select>
              <div class="select-arrow">▼</div>
            </div>
          </div>
          
          <div class="filter-group">
            <label class="filter-label">排序方式</label>
            <div class="filter-select-wrapper">
              <select v-model="searchParams.sort_by" @change="handleSearch" class="filter-select">
                <option value="created_at">最新发布</option>
                <option value="rating">评分最高</option>
                <option value="download_count">下载最多</option>
                <option value="name">名称排序</option>
              </select>
              <div class="select-arrow">▼</div>
            </div>
          </div>
          
          <div class="filter-group">
            <label class="filter-label">排序顺序</label>
            <div class="filter-select-wrapper">
              <select v-model="searchParams.order" @change="handleSearch" class="filter-select">
                <option value="desc">降序 ↓</option>
                <option value="asc">升序 ↑</option>
              </select>
              <div class="select-arrow">▼</div>
            </div>
          </div>
        </div>
        
        <!-- 快速筛选标签 -->
        <div class="quick-filters">
          <div class="quick-filters-title">热门标签</div>
          <div class="quick-tags">
            <button 
              v-for="tag in quickTags" 
              :key="tag.key"
              @click="applyQuickFilter(tag)"
              :class="['quick-tag', { active: isTagActive(tag) }]"
            >
              <span class="tag-icon">{{ tag.icon }}</span>
              <span class="tag-text">{{ tag.label }}</span>
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { getGames, getCategories } from '../api/modApi.js'

// 定义事件
const emit = defineEmits(['search'])

// 响应式数据
const searchParams = ref({
  keyword: '',
  game_id: '',
  category_id: '',
  sort_by: 'created_at',
  order: 'desc',
  page: 1,
  page_size: 20
})

const games = ref([])
const categories = ref([])
const loading = ref(false)

// 快速筛选标签
const quickTags = ref([
  { key: 'hot', label: '热门推荐', icon: '🔥', sort_by: 'download_count', order: 'desc' },
  { key: 'new', label: '最新上架', icon: '✨', sort_by: 'created_at', order: 'desc' },
  { key: 'rating', label: '高评分', icon: '⭐', sort_by: 'rating', order: 'desc' },
  { key: 'popular', label: '下载量高', icon: '📈', sort_by: 'download_count', order: 'desc' }
])

// 搜索处理
const handleSearch = () => {
  searchParams.value.page = 1 // 重置页码
  emit('search', { ...searchParams.value })
}

// 重置筛选器
const resetFilters = () => {
  searchParams.value = {
    keyword: '',
    game_id: '',
    category_id: '',
    sort_by: 'created_at',
    order: 'desc',
    page: 1,
    page_size: 20
  }
  handleSearch()
}

// 应用快速筛选
const applyQuickFilter = (tag) => {
  searchParams.value.sort_by = tag.sort_by
  searchParams.value.order = tag.order
  handleSearch()
}

// 检查标签是否激活
const isTagActive = (tag) => {
  return searchParams.value.sort_by === tag.sort_by && searchParams.value.order === tag.order
}

// 加载游戏和分类数据
const loadGamesAndCategories = async () => {
  try {
    loading.value = true
    
    const [gamesResponse, categoriesResponse] = await Promise.all([
      getGames(),
      getCategories()
    ])
    
    if (gamesResponse.error_code === 0) {
      games.value = gamesResponse.data.list || []
    }
    
    if (categoriesResponse.error_code === 0) {
      categories.value = categoriesResponse.data.list || []
    }
  } catch (error) {
    console.error('加载游戏和分类失败:', error)
  } finally {
    loading.value = false
  }
}

// 暴露方法给父组件
defineExpose({
  searchParams
})

// 组件挂载时加载数据
onMounted(() => {
  loadGamesAndCategories()
  // 触发初始搜索
  handleSearch()
})
</script>

<style scoped>
.mod-search {
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.1), rgba(255, 255, 255, 0.05));
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 20px;
  padding: 28px;
  margin-bottom: 24px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
  position: relative;
  overflow: hidden;
}

.mod-search::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 2px;
  background: linear-gradient(90deg, #667eea, #764ba2, #f093fb, #f5576c);
  opacity: 0.6;
}

.search-form {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

/* 主搜索区域 */
.search-main {
  width: 100%;
}

.search-input-wrapper {
  position: relative;
  display: flex;
  align-items: center;
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 50px;
  padding: 4px;
  transition: all 0.3s ease;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
}

.search-input-wrapper:focus-within {
  transform: translateY(-2px);
  box-shadow: 0 8px 30px rgba(102, 126, 234, 0.2);
  border-color: rgba(255, 255, 255, 0.3);
}

.search-icon {
  padding: 16px 20px;
  color: rgba(255, 255, 255, 0.7);
  font-size: 18px;
  cursor: pointer;
  transition: all 0.2s ease;
}

.search-input {
  flex: 1;
  padding: 16px 8px;
  background: transparent;
  border: none;
  outline: none;
  color: rgba(255, 255, 255, 0.95);
  font-size: 16px;
  font-weight: 500;
  placeholder-color: rgba(255, 255, 255, 0.6);
}

.search-input::placeholder {
  color: rgba(255, 255, 255, 0.6);
  font-weight: 400;
}

.search-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 14px 28px;
  background: linear-gradient(135deg, #667eea, #764ba2);
  color: white;
  border: none;
  border-radius: 50px;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
  min-width: 100px;
  height: 48px;
}

.search-btn:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(102, 126, 234, 0.5);
}

.search-btn:disabled {
  opacity: 0.7;
  cursor: not-allowed;
}

.btn-spinner {
  width: 20px;
  height: 20px;
  border: 2px solid rgba(255, 255, 255, 0.3);
  border-top: 2px solid white;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

/* 筛选器区域 */
.filters-section {
  background: rgba(255, 255, 255, 0.03);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.05);
  border-radius: 16px;
  padding: 20px;
}

.filters-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.filters-title {
  font-size: 18px;
  font-weight: 700;
  color: rgba(255, 255, 255, 0.95);
  background: linear-gradient(135deg, #667eea, #764ba2);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.reset-btn {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 8px 16px;
  background: rgba(255, 255, 255, 0.05);
  backdrop-filter: blur(10px);
  color: rgba(255, 255, 255, 0.8);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 12px;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;
}

.reset-btn:hover {
  background: rgba(255, 255, 255, 0.1);
  border-color: rgba(255, 255, 255, 0.2);
  transform: translateY(-1px);
}

.reset-icon {
  font-size: 16px;
  animation: rotate 2s linear infinite paused;
}

.reset-btn:hover .reset-icon {
  animation-play-state: running;
}

@keyframes rotate {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.filters-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
  gap: 16px;
  margin-bottom: 20px;
}

.filter-group {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.filter-label {
  font-size: 13px;
  font-weight: 600;
  color: rgba(255, 255, 255, 0.8);
  text-transform: uppercase;
  letter-spacing: 0.5px;
  margin-left: 4px;
}

.filter-select-wrapper {
  position: relative;
}

.filter-select {
  width: 100%;
  padding: 12px 16px;
  padding-right: 40px;
  background: rgba(255, 255, 255, 0.05);
  backdrop-filter: blur(15px);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 12px;
  color: rgba(255, 255, 255, 0.9);
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  outline: none;
  transition: all 0.3s ease;
  appearance: none;
}

.filter-select:focus {
  border-color: rgba(102, 126, 234, 0.5);
  background: rgba(255, 255, 255, 0.08);
  box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
}

.filter-select:hover {
  background: rgba(255, 255, 255, 0.08);
  border-color: rgba(255, 255, 255, 0.2);
}

.select-arrow {
  position: absolute;
  right: 12px;
  top: 50%;
  transform: translateY(-50%);
  color: rgba(255, 255, 255, 0.6);
  font-size: 12px;
  pointer-events: none;
  transition: transform 0.2s ease;
}

.filter-select:focus + .select-arrow {
  transform: translateY(-50%) rotate(180deg);
}

/* 快速筛选标签 */
.quick-filters {
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  padding-top: 20px;
}

.quick-filters-title {
  font-size: 14px;
  font-weight: 600;
  color: rgba(255, 255, 255, 0.8);
  margin-bottom: 12px;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.quick-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
}

.quick-tag {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px 16px;
  background: rgba(255, 255, 255, 0.05);
  backdrop-filter: blur(15px);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 20px;
  color: rgba(255, 255, 255, 0.8);
  font-size: 13px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
  overflow: hidden;
}

.quick-tag::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.1), transparent);
  transition: left 0.5s ease;
}

.quick-tag:hover::before {
  left: 100%;
}

.quick-tag:hover {
  background: rgba(255, 255, 255, 0.1);
  border-color: rgba(255, 255, 255, 0.2);
  transform: translateY(-2px);
  color: rgba(255, 255, 255, 0.95);
}

.quick-tag.active {
  background: linear-gradient(135deg, #667eea, #764ba2);
  border-color: transparent;
  color: white;
  box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
}

.quick-tag.active:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
}

.tag-icon {
  font-size: 16px;
}

.tag-text {
  font-weight: 600;
}

/* 响应式设计 */
@media (max-width: 1024px) {
  .filters-grid {
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 12px;
  }
}

@media (max-width: 768px) {
  .mod-search {
    padding: 20px;
    border-radius: 16px;
  }
  
  .search-form {
    gap: 20px;
  }
  
  .search-input-wrapper {
    flex-direction: column;
    border-radius: 16px;
    padding: 8px;
    gap: 8px;
  }
  
  .search-icon {
    padding: 12px 16px;
  }
  
  .search-input {
    width: 100%;
    text-align: center;
    padding: 12px 16px;
  }
  
  .search-btn {
    width: 100%;
    border-radius: 12px;
  }
  
  .filters-header {
    flex-direction: column;
    gap: 12px;
    align-items: flex-start;
  }
  
  .filters-grid {
    grid-template-columns: 1fr;
    gap: 12px;
  }
  
  .quick-tags {
    justify-content: center;
  }
}

@media (max-width: 480px) {
  .mod-search {
    padding: 16px;
    margin-bottom: 16px;
  }
  
  .filters-section {
    padding: 16px;
  }
  
  .search-input {
    font-size: 14px;
  }
  
  .search-btn {
    font-size: 14px;
    padding: 12px 20px;
  }
  
  .quick-tag {
    font-size: 12px;
    padding: 8px 12px;
  }
  
  .tag-icon {
    font-size: 14px;
  }
}
</style> 