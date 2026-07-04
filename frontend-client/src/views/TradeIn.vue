<template>
  <div style="background:#f5f5f5;min-height:100vh">
    <div style="background:#000;color:#fff;padding:16px;display:flex;align-items:center;gap:12px">
      <span style="font-size:20px" @click="$router.back()">←</span>
      <span style="font-size:18px;font-weight:bold">二手车置换</span>
    </div>
    <div style="background:linear-gradient(135deg,#f093fb,#f5576c);margin:12px;border-radius:12px;padding:24px;color:#fff;text-align:center">
      <div style="font-size:36px;margin-bottom:8px">💰</div>
      <div style="font-size:18px;font-weight:bold">旧车换新车，一步到位</div>
      <div style="font-size:13px;opacity:0.9;margin-top:4px">任意品牌均可置换，享厂家置换补贴</div>
    </div>
    <div style="background:#fff;margin:12px;border-radius:12px;padding:16px">
      <van-field v-model="form.brand" label="品牌" placeholder="例:奥迪" />
      <van-field v-model="form.model" label="车型" placeholder="例:A4L" />
      <van-field v-model="form.modelYear" label="上牌年份" placeholder="例:2020" type="number" />
      <van-field v-model="form.mileage" label="行驶里程(万公里)" placeholder="例:5" type="number" />
      <van-field v-model="form.licensePlate" label="车牌号" placeholder="例:京A12345" />
      <van-field v-model="form.phone" label="联系电话" placeholder="手机号" type="tel" />
      <van-button type="primary" block size="large" round style="margin-top:20px" @click="evaluate" :loading="loading">免费在线估价</van-button>
    </div>
    <div v-if="result" style="margin:12px;background:#fff;border-radius:12px;padding:20px;text-align:center">
      <div style="font-size:14px;color:#999">系统预估回收价</div>
      <div style="font-size:36px;color:#e74c3c;font-weight:bold;margin:8px 0">¥{{ (result/10000).toFixed(2) }}万</div>
      <div style="font-size:12px;color:#999">*仅供参考，最终以到店评估为准</div>
      <van-button type="warning" size="small" round style="margin-top:12px">预约到店评估</van-button>
    </div>
  </div>
</template>
<script setup>
import { ref } from 'vue'; import api from '../api'; import { showToast } from 'vant'
const form = ref({ brand:'', model:'', modelYear:'', mileage:'', licensePlate:'', phone:'' }); const loading = ref(false); const result = ref(null)
async function evaluate() { if (!form.value.phone) { showToast('请输入联系电话'); return }; loading.value = true; try { const r = await api.post('/api/client/valuations?customerId=1', form.value); result.value = r.data.data.estimatedPrice } catch(e){} finally { loading.value = false } }
</script>
