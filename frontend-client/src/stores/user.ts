import { defineStore } from 'pinia'
import { ref } from 'vue'
import api from '../api'
import type { ClientLoginResponse } from '../types/api'

export const useUserStore = defineStore('user', () => {
  const customerId = ref<string>(localStorage.getItem('cid') || '')
  const name = ref<string>(localStorage.getItem('cname') || '')
  const phone = ref<string>(localStorage.getItem('cphone') || '')

  async function login(p: string): Promise<void> {
    const r = await api.post<ClientLoginResponse>('/api/client/login', { phone: p })
    const d = (r.data as unknown as { data: ClientLoginResponse }).data
    customerId.value = String(d.customerId)
    name.value = d.name
    phone.value = p
    localStorage.setItem('cid', String(d.customerId))
    localStorage.setItem('cname', d.name)
    localStorage.setItem('cphone', p)
    const accessToken = d.accessToken || (d as unknown as { token: string }).token
    if (accessToken) {
      localStorage.setItem('token', accessToken)
      localStorage.setItem('accessToken', accessToken)
      if (d.refreshToken) localStorage.setItem('refreshToken', d.refreshToken)
    }
  }

  function logout(): void {
    customerId.value = ''
    name.value = ''
    phone.value = ''
    localStorage.clear()
  }

  return { customerId, name, phone, login, logout }
})
