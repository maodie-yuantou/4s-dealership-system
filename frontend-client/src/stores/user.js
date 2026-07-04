import { defineStore } from 'pinia'
import { ref } from 'vue'
import api from '../api'
export const useUserStore = defineStore('user', () => {
  const customerId = ref(localStorage.getItem('cid') || '')
  const name = ref(localStorage.getItem('cname') || '')
  const phone = ref(localStorage.getItem('cphone') || '')
  async function login(p) {
    const r = await api.post('/api/client/login', { phone: p })
    const d = r.data.data
    customerId.value = d.customerId; name.value = d.name; phone.value = p
    localStorage.setItem('cid', d.customerId); localStorage.setItem('cname', d.name); localStorage.setItem('cphone', p)
    if (d.token) { localStorage.setItem('token', d.token); localStorage.setItem('cid', d.customerId) }
  }
  function logout() { customerId.value = ''; name.value = ''; phone.value = ''; localStorage.clear() }
  return { customerId, name, phone, login, logout }
})
