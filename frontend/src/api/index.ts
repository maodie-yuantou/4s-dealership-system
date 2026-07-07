import axios, { type AxiosResponse, type InternalAxiosRequestConfig } from 'axios'
import { ElMessage } from 'element-plus'
import type { ApiResponse } from '../types/api'

const api = axios.create({ timeout: 15000 })

let isRefreshing = false
let pendingRequests: Array<{ resolve: (value: unknown) => void; reject: (reason?: unknown) => void; config: InternalAxiosRequestConfig }> = []

function getToken(): string | null {
  return localStorage.getItem('admin_token') || localStorage.getItem('accessToken') || localStorage.getItem('token')
}

function getRefreshToken(): string | null {
  return localStorage.getItem('refreshToken')
}

function setTokens(accessToken: string, refreshToken?: string): void {
  localStorage.setItem('admin_token', accessToken)
  localStorage.setItem('accessToken', accessToken)
  if (refreshToken) localStorage.setItem('refreshToken', refreshToken)
}

api.interceptors.request.use((config) => {
  const token = getToken()
  if (token) config.headers.Authorization = 'Bearer ' + token
  return config
})

api.interceptors.response.use(
  (response: AxiosResponse) => response,
  async (error) => {
    const status = error.response?.status
    const msg = error.response?.data?.message
    const originalRequest = error.config as InternalAxiosRequestConfig & { _retry?: boolean }

    if (status === 401 && !originalRequest._retry && !originalRequest.url?.includes('/api/auth/refresh')) {
      const refreshToken = getRefreshToken()
      if (!refreshToken) {
        localStorage.clear()
        ElMessage.error(msg || '登录已过期，请重新登录')
        setTimeout(() => { window.location.href = '/admin/login' }, 1500)
        return Promise.reject(error)
      }

      if (isRefreshing) {
        return new Promise((resolve, reject) => {
          pendingRequests.push({ resolve, reject, config: originalRequest })
        })
      }

      originalRequest._retry = true
      isRefreshing = true

      try {
        const res = await axios.post<ApiResponse<{ accessToken: string; refreshToken: string }>>('/api/auth/refresh', { refreshToken })
        const newAccessToken = res.data.data.accessToken
        const newRefreshToken = res.data.data.refreshToken
        setTokens(newAccessToken, newRefreshToken)
        originalRequest.headers.Authorization = 'Bearer ' + newAccessToken
        pendingRequests.forEach(p => p.resolve(api(p.config)))
        pendingRequests = []
        return api(originalRequest)
      } catch (_refreshError) {
        localStorage.clear()
        pendingRequests.forEach(p => p.reject((p as unknown as { error: unknown }).error))
        pendingRequests = []
        ElMessage.error('登录已过期，请重新登录')
        setTimeout(() => { window.location.href = '/admin/login' }, 1500)
        return Promise.reject(_refreshError)
      } finally {
        isRefreshing = false
      }
    }

    if (status === 403) {
      ElMessage.error(msg || '您没有该功能权限，请联系相关人员！')
    } else if (msg && status !== 401) {
      ElMessage.error(msg)
    }
    return Promise.reject(error)
  }
)

export async function get<T>(url: string, params?: Record<string, unknown>): Promise<ApiResponse<T>> {
  const res = await api.get<ApiResponse<T>>(url, { params })
  return res.data
}

export async function post<T>(url: string, data?: unknown): Promise<ApiResponse<T>> {
  const res = await api.post<ApiResponse<T>>(url, data)
  return res.data
}

export async function put<T>(url: string, data?: unknown): Promise<ApiResponse<T>> {
  const res = await api.put<ApiResponse<T>>(url, data)
  return res.data
}

export async function del<T>(url: string): Promise<ApiResponse<T>> {
  const res = await api.delete<ApiResponse<T>>(url)
  return res.data
}

export default api
