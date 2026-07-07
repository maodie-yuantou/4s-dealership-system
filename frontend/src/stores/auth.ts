import { defineStore } from 'pinia'
import { ref } from 'vue'
import api from '../api'
import type { LoginResponse } from '../types/api'

export const useAuthStore = defineStore('auth', () => {
  const token = ref<string>(localStorage.getItem('admin_token') || localStorage.getItem('accessToken') || localStorage.getItem('token') || '')
  const user = ref<{ username: string; realName: string; roles: string[] } | null>(
    JSON.parse(localStorage.getItem('user') || 'null')
  )

  async function login(username: string, password: string): Promise<void> {
    const res = await api.post<LoginResponse>('/api/auth/login', { username, password })
    const d = (res.data as unknown as { data: LoginResponse }).data
    token.value = d.accessToken || (d as unknown as { token: string }).token
    user.value = { username: d.username, realName: d.realName, roles: d.roles }
    localStorage.setItem('admin_token', token.value)
    localStorage.setItem('accessToken', token.value)
    if (d.refreshToken) localStorage.setItem('refreshToken', d.refreshToken)
    localStorage.setItem('user', JSON.stringify(user.value))
  }

  function logout(): void {
    token.value = ''
    user.value = null
    localStorage.clear()
  }

  return { token, user, login, logout }
})
