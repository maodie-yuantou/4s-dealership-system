<template>
  <div style="min-height:100vh;background:#0a0a0a">
    <div style="padding:14px 16px;display:flex;align-items:center;gap:12px;color:#fff;border-bottom:1px solid rgba(255,255,255,0.06)">
      <span style="font-size:20px;cursor:pointer" @click="$router.push('/mine')">←</span>
      <span style="font-size:17px;font-weight:300;letter-spacing:2px">我的卡券</span>
    </div>
    <div v-if="list.length" style="padding:12px">
      <div v-for="c in list" :key="c.id" style="background:linear-gradient(135deg,rgba(201,169,110,0.1),rgba(201,169,110,0.05));border-radius:10px;padding:16px;margin-bottom:10px;border:1px solid rgba(201,169,110,0.2)">
        <div style="display:flex;justify-content:space-between;align-items:center">
          <div>
            <div style="color:#c9a96e;font-weight:600;font-size:16px">{{ c.couponName }}</div>
            <div style="font-size:12px;color:rgba(255,255,255,0.4);margin-top:4px">有效期至 {{ c.validTo }}</div>
          </div>
          <div style="text-align:right">
            <div style="color:#c9a96e;font-size:24px;font-weight:700">¥{{ c.faceValue }}</div>
            <div style="font-size:11px;color:rgba(255,255,255,0.4)">{{ c.status==='ACTIVE'?'可用':'已过期' }}</div>
          </div>
        </div>
      </div>
    </div>
    <div v-else style="text-align:center;padding:80px 20px;color:rgba(255,255,255,0.2)">
      <div style="font-size:48px;margin-bottom:12px">🎫</div>
      <div style="font-size:14px">暂无卡券</div>
    </div>
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'; import api from '../api'
const list = ref([])
onMounted(async () => {
  try { const r = await api.get('/api/marketing/coupons', { params: { page:1, size:50 } }); list.value = r.data.data.records||[] } catch(e){}
})
</script>
