// mod相关API接口

const API_BASE = '/api'

// 搜索mod
export async function searchMods(params = {}) {
  const queryParams = new URLSearchParams()
  
  // 添加搜索参数
  if (params.keyword) queryParams.append('keyword', params.keyword)
  if (params.game_id) queryParams.append('game_id', params.game_id)
  if (params.category_id) queryParams.append('category_id', params.category_id)
  if (params.author) queryParams.append('author', params.author)
  if (params.sort_by) queryParams.append('sort_by', params.sort_by)
  if (params.order) queryParams.append('order', params.order)
  if (params.page) queryParams.append('page', params.page)
  if (params.page_size) queryParams.append('page_size', params.page_size)
  
  const response = await fetch(`${API_BASE}/mods/search?${queryParams}`)
  if (!response.ok) {
    throw new Error(`HTTP error! status: ${response.status}`)
  }
  return await response.json()
}

// 获取mod详情
export async function getModDetail(id) {
  const response = await fetch(`${API_BASE}/mods/${id}`)
  if (!response.ok) {
    throw new Error(`HTTP error! status: ${response.status}`)
  }
  return await response.json()
}

// 获取游戏列表
export async function getGames() {
  const response = await fetch(`${API_BASE}/games`)
  if (!response.ok) {
    throw new Error(`HTTP error! status: ${response.status}`)
  }
  return await response.json()
}

// 获取分类列表
export async function getCategories() {
  const response = await fetch(`${API_BASE}/categories`)
  if (!response.ok) {
    throw new Error(`HTTP error! status: ${response.status}`)
  }
  return await response.json()
}

// 获取下载链接
export function getDownloadUrl(id) {
  return `${API_BASE}/mods/${id}/download`
} 