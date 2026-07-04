<template>
  <div style="min-height:100vh;background:#0a0a0a">
    <div style="padding:14px 16px;display:flex;align-items:center;gap:12px;color:#fff;border-bottom:1px solid rgba(255,255,255,0.06)">
      <span style="font-size:20px;cursor:pointer" @click="$router.push('/mine')">←</span>
      <span style="font-size:17px;font-weight:300;letter-spacing:2px">预约记录</span>
    </div>
    <div v-if="list.length" style="padding:12px">
      <div v-for="a in list" :key="a.id" style="background:rgba(255,255,255,0.04);border-radius:10px;padding:16px;margin-bottom:10px;border:1px solid rgba(255,255,255,0.06)">
        <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:6px">
          <span style="color:#fff;font-weight:600">{{ a.serviceType==='MAINTENANCE'?'保养':'维修' }}</span>
          <span style="font-size:12px;color:#c9a96e">{{ a.status==='CONFIRMED'?'已确认':'待确认' }}</span>
        </div>
        <div style="font-size:12px;color:rgba(255,255,255,0.4)">{{ a.vehicleInfo }}</div>
        <div style="font-size:12px;color:rgba(255,255,255,0.3);margin-top:4px">{{ a.appointmentTime }}</div>
      </div>
    </div>
    <div v-else style="text-align:center;padding:80px 20px;color:rgba(255,255,255,0.2)">
      <div style="font-size:48px;margin-bottom:12px">📅</div>
      <div style="font-size:14px">暂无预约记录</div>
    </div>
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'; import api from '../api'
const list = ref([])
onMounted(async () => {
  try { const r = await api.get('/api/service/appointments', { params: { page:1, size:50 } }); list.value = r.data.data.records||[] } catch(e){}
})
</script>
