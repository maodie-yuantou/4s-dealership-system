<template>
  <div style="min-height:100vh;background:#0a0a0a">
    <div style="padding:14px 16px;display:flex;align-items:center;gap:12px;color:#fff;border-bottom:1px solid rgba(255,255,255,0.06)">
      <span style="font-size:20px;cursor:pointer" @click="$router.push('/mine')">←</span>
      <span style="font-size:17px;font-weight:300;letter-spacing:2px">我的订单</span>
    </div>
    <div v-if="orders.length" style="padding:12px">
      <div v-for="o in orders" :key="o.id" style="background:rgba(255,255,255,0.04);border-radius:10px;padding:16px;margin-bottom:10px;border:1px solid rgba(255,255,255,0.06)">
        <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:8px">
          <span style="color:#fff;font-weight:600">{{ o.orderNo }}</span>
          <span :style="{padding:'3px 10px',borderRadius:4,fontSize:11,background:o.status==='COMPLETED'?'rgba(7,193,96,0.15)':o.status==='PENDING_DELIVERY'?'rgba(25,137,250,0.15)':'rgba(240,173,78,0.15)',color:o.status==='COMPLETED'?'#07c160':o.status==='PENDING_DELIVERY'?'#1989fa':'#f0ad4e'}">{{ {COMPLETED:'已完成',PENDING_DELIVERY:'待交付',PENDING_DEPOSIT:'待付定金'}[o.status]||o.status }}</span>
        </div>
        <div style="font-size:13px;color:rgba(255,255,255,0.4)">总价: ¥{{ (o.totalPrice||0).toLocaleString() }}</div>
      </div>
    </div>
    <div v-else style="text-align:center;padding:80px 20px;color:rgba(255,255,255,0.2)">
      <div style="font-size:48px;margin-bottom:12px">📋</div>
      <div style="font-size:14px">暂无订单</div>
    </div>
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'; import api from '../api'
const orders = ref([])
onMounted(async () => {
  try { const r = await api.get('/api/sale/orders', { params: { page:1, size:50 } }); orders.value = r.data.data.records||[] } catch(e){}
})
</script>
