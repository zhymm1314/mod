<template>
  <div class="mod-search">
    <!-- 搜索表单 -->
    <div class="search-form">
      <div class="search-input-group">
        <input
          type="text"
          v-model="searchParams.keyword"
          placeholder="搜索mod名称、描述或作者..."
          class="search-input"
          @keyup.enter="handleSearch"
        />
        <button @click="handleSearch" class="search-btn">搜索</button>
      </div>
      
      <!-- 筛选器 -->
      <div class="filters">
        <select v-model="searchParams.game_id" @change="handleSearch" class="filter-select">
          <option value="">全部游戏</option>
          <option v-for="game in games" :key="game.id" :value="game.id">
            {{ game.name }}
          </option>
        </select>
        
        <select v-model="searchParams.category_id" @change="handleSearch" class="filter-select">
          <option value="">全部分类</option>
          <option v-for="category in categories" :key="category.id" :value="category.id">
            {{ category.name }}
          </option>
        </select>
        
        <select v-model="searchParams.sort_by" @change="handleSearch" class="filter-select">
          <option value="created_at">按时间排序</option>
          <option value="rating">按评分排序</option>
          <option value="download_count">按下载量排序</option>
        </select>
        
        <select v-model="searchParams.order" @change="handleSearch" class="filter-select">
          <option value="desc">降序</option>
          <option value="asc">升序</option>
        </select>
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

// 搜索处理
const handleSearch = () => {
  searchParams.value.page = 1 // 重置页码
  emit('search', { ...searchParams.value })
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
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  padding: 16px;
  border-radius: 12px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
  margin-bottom: 16px;
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.search-form {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.search-input-group {
  display: flex;
  gap: 8px;
  align-items: center;
}

.search-input {
  flex: 1;
  padding: 10px 16px;
  border: 2px solid rgba(102, 126, 234, 0.2);
  border-radius: 25px;
  font-size: 14px;
  outline: none;
  transition: all 0.3s ease;
  background: rgba(255, 255, 255, 0.9);
}

.search-input:focus {
  border-color: #667eea;
  background: white;
  box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
}

.search-btn {
  padding: 10px 20px;
  background: linear-gradient(135deg, #667eea, #764ba2);
  color: white;
  border: none;
  border-radius: 25px;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
  white-space: nowrap;
}

.search-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
}

.filters {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
  gap: 10px;
  align-items: center;
}

.filter-select {
  padding: 8px 12px;
  border: 1px solid rgba(102, 126, 234, 0.2);
  border-radius: 8px;
  background: rgba(255, 255, 255, 0.9);
  font-size: 13px;
  cursor: pointer;
  outline: none;
  transition: all 0.3s ease;
}

.filter-select:focus {
  border-color: #667eea;
  background: white;
  box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
}

/* 响应式设计 */
@media (max-width: 768px) {
  .mod-search {
    padding: 12px;
    margin-bottom: 12px;
  }
  
  .search-input-group {
    flex-direction: column;
    gap: 8px;
  }
  
  .search-input,
  .search-btn {
    width: 100%;
  }
  
  .filters {
    grid-template-columns: repeat(auto-fit, minmax(100px, 1fr));
    gap: 8px;
  }
  
  .filter-select {
    font-size: 12px;
    padding: 6px 10px;
  }
}

@media (max-width: 480px) {
  .mod-search {
    padding: 10px;
    border-radius: 8px;
  }
  
  .filters {
    grid-template-columns: 1fr;
  }
  
  .search-input,
  .search-btn {
    font-size: 13px;
  }
}
</style> 