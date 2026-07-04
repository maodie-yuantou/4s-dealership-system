<template>
  <div style="background:#f5f5f5;min-height:100vh">
    <router-view />
    <van-tabbar v-model="active" active-color="#ff5000" inactive-color="#999" style="position:fixed;bottom:0;left:0;right:0;z-index:999" v-if="showTab">
      <van-tabbar-item icon="home-o" to="/">首页</van-tabbar-item>
      <van-tabbar-item icon="label-o" to="/cars">车型</van-tabbar-item>
      <van-tabbar-item icon="shopping-cart-o" to="/cart" :badge="cartCount||''">购物车</van-tabbar-item>
      <van-tabbar-item icon="apps-o" to="/services">服务</van-tabbar-item>
      <van-tabbar-item icon="user-o" to="/mine">我的</van-tabbar-item>
    </van-tabbar>
  </div>
</template>
<script setup>
import { ref, watch, computed } from 'vue'; import { useRoute } from 'vue-router'; import { useCartStore } from './stores/cart'
const route = useRoute(); const cart = useCartStore()
const active = ref(0); const cartCount = computed(() => cart.totalCount || '')
const noTab = ['/login','/register','/reset-password']
const minePages = ['/mine','/profile','/orders','/appointments','/coupons','/points','/about']
const showTab = ref(true)
watch(() => route.path, p => {
  showTab.value = !noTab.includes(p) && !p.startsWith('/car/') && !p.startsWith('/test-drive') && !p.startsWith('/finance') && !p.startsWith('/trade-in') && !p.startsWith('/chat')
  if (p === '/' || p === '/home') active.value = 0
  else if (p.startsWith('/cars')) active.value = 1
  else if (p === '/cart') active.value = 2
  else if (p.startsWith('/services')) active.value = 3
  else if (minePages.includes(p)) active.value = 4
}, { immediate: true })
</script>
