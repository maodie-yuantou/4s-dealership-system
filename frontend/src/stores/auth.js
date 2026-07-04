import { defineStore } from 'pinia'
import { ref } from 'vue'
import api from '../api'

export const useAuthStore = defineStore('auth', () => {
  const token = ref(localStorage.getItem('token') || '')
  const user = ref(JSON.parse(localStorage.getItem('user') || 'null'))

  async function login(username, password) {
    const res = await api.post('/api/auth/login', { username, password })
    token.value = res.data.data.token
    user.value = { username: res.data.data.username, realName: res.data.data.realName, roles: res.data.data.roles }
    localStorage.setItem('token', token.value)
    localStorage.setItem('user', JSON.stringify(user.value))
  }

  function logout() {
    token.value = ''
    user.value = null
    localStorage.clear()
  }

  return { token, user, login, logout }
})
