import axios from 'axios'
import { showToast } from 'vant'

const api = axios.create({ timeout: 15000 })

api.interceptors.request.use(config => {
  const token = localStorage.getItem('token')
  if (token) config.headers.Authorization = `Bearer ${token}`
  return config
})

api.interceptors.response.use(
  res => res,
  err => {
    const msg = err.response?.data?.message || err.message
    if (err.response?.status === 403) {
      showToast(msg)
      return Promise.reject(err)
    }
    if (err.response?.status === 401) {
      localStorage.clear()
      window.location.href = '/login'
      return Promise.reject(err)
    }
    return Promise.reject(err)
  }
)

export const carImages = {
  '奥迪': { 'A6L': 'https://picsum.photos/seed/audi-a6l/800/450' },
  '宝马': { '325Li': 'https://picsum.photos/seed/bmw-325li/800/450' },
  '奔驰': { 'C260L': 'https://picsum.photos/seed/benz-c260l/800/450' },
  '特斯拉': { 'Model Y': 'https://picsum.photos/seed/tesla-model-y/800/450' },
  '比亚迪': { '汉EV': 'https://picsum.photos/seed/byd-han-ev/800/450' },
  '丰田': { '凯美瑞': 'https://picsum.photos/seed/toyota-camry/800/450' },
  '本田': { 'CR-V': 'https://picsum.photos/seed/honda-crv/800/450' },
  '大众': { '途观L': 'https://picsum.photos/seed/vw-tiguan/800/450' },
  '理想': { 'L8': 'https://picsum.photos/seed/lixiang-l8/800/450' },
  '沃尔沃': { 'XC60': 'https://picsum.photos/seed/volvo-xc60/800/450' },
  '长安': { '深蓝SL03': 'https://picsum.photos/seed/changan-sl03/800/450' },
  '别克': { 'GL8': 'https://picsum.photos/seed/buick-gl8/800/450' }
}

const colors = {
  '奥迪': '#1a1a1a', '宝马': '#1c69d4', '奔驰': '#3a3a3a',
  '特斯拉': '#e82127', '比亚迪': '#2948ff', '丰田': '#eb0a1e',
  '本田': '#cc0000', '大众': '#003b6f', '理想': '#00b478',
  '沃尔沃': '#003057', '长安': '#003da5', '别克': '#888b8d'
}

export function getCarImage(brand, model, imageUrl) {
  if (imageUrl && (imageUrl.startsWith('http') || imageUrl.startsWith('/'))) return imageUrl
  const b = carImages[brand]
  if (b) {
    if (b[model]) return b[model]
    for (const k of Object.keys(b)) { if (model && model.includes(k)) return b[k] }
    return Object.values(b)[0]
  }
  return `https://picsum.photos/seed/${encodeURIComponent(brand)}-${encodeURIComponent(model||'car')}/800/450`
}

export function getCarPlaceholder(brand, model) {
  const bg = colors[brand] || '#333'
  const text = `${brand} ${model || ''}`
  const svg = `<svg xmlns="http://www.w3.org/2000/svg" width="800" height="400"><defs><linearGradient id="g" x1="0" y1="0" x2="1" y2="1"><stop offset="0%" stop-color="${bg}"/><stop offset="100%" stop-color="${bg}" stop-opacity="0.7"/></linearGradient></defs><rect width="800" height="400" fill="url(#g)"/><text x="400" y="180" text-anchor="middle" fill="white" font-size="80">🚗</text><text x="400" y="260" text-anchor="middle" fill="white" font-size="36" font-family="sans-serif">${text}</text></svg>`
  return 'data:image/svg+xml,' + encodeURIComponent(svg)
}

export default api
