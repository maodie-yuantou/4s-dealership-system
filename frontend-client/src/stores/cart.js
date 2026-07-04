import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { showToast } from 'vant'

export const useCartStore = defineStore('cart', () => {
  const items = ref(JSON.parse(localStorage.getItem('cart')||'[]'))

  function save() { localStorage.setItem('cart', JSON.stringify(items.value)) }

  const totalCount = computed(() => items.value.reduce((s,i) => s + i.quantity, 0))
  const totalPrice = computed(() => items.value.reduce((s,i) => s + i.price * i.quantity, 0))

  function add(item) {
    const exist = items.value.find(i => i.id === item.id && i.type === item.type)
    if (exist) { exist.quantity++ } else { items.value.push({...item, quantity: 1}) }
    save(); showToast('已加入购物车')
  }

  function remove(id, type) {
    items.value = items.value.filter(i => !(i.id === id && i.type === type))
    save()
  }

  function updateQty(id, type, qty) {
    const item = items.value.find(i => i.id === id && i.type === type)
    if (item) { item.quantity = Math.max(1, qty); save() }
  }

  function clear() { items.value = []; save() }

  return { items, totalCount, totalPrice, add, remove, updateQty, clear }
})
