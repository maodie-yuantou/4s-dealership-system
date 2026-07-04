import axios from 'axios'
import { ElMessage } from 'element-plus'

const api = axios.create({ timeout: 15000 })

api.interceptors.request.use(config => {
  const token = localStorage.getItem('token')
  if (token) config.headers.Authorization = `Bearer ${token}`
  return config
})

api.interceptors.response.use(
  res => res,
  err => {
    const data = err.response?.data
    const msg = data?.message || err.message
    if (err.response?.status === 403) {
      ElMessage({ message: msg, type: 'warning', duration: 5000, showClose: true })
      return Promise.reject(err)
    }
    ElMessage.error(msg)
    if (err.response?.status === 401) {
      localStorage.clear()
      window.location.href = '/login'
    }
    return Promise.reject(err)
  }
)

export default api
