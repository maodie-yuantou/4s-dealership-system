<template>
  <div style="background:#f5f5f5;min-height:100vh">
    <div style="background:#000;color:#fff;padding:14px 16px;display:flex;align-items:center;gap:12px">
      <span style="font-size:20px" @click="$router.back()">←</span>
      <span style="font-size:17px;font-weight:bold">预约试驾</span>
    </div>
    <div style="background:linear-gradient(135deg,#0f3460,#1a1a2e);color:#fff;padding:30px 20px;text-align:center">
      <div style="font-size:36px;margin-bottom:8px">🚗</div>
      <div style="font-size:17px;font-weight:bold">亲身感受，才知非凡</div>
      <div style="font-size:12px;opacity:0.7;margin-top:6px">选择心仪车型，专属顾问1小时内联系您</div>
    </div>
    <!-- 可选车型 -->
    <div style="margin:12px;background:#fff;border-radius:12px;overflow:hidden">
      <div style="padding:12px 16px;font-size:14px;font-weight:bold;border-bottom:1px solid #f5f5f5">选择意向车型</div>
      <div style="padding:8px 12px;overflow-x:auto;white-space:nowrap">
        <span v-for="c in cars" :key="c.id" style="display:inline-block;padding:8px 14px;margin:4px;background:selectedCar===c.id?'#1989fa':'#f5f5f5';color:selectedCar===c.id?'#fff':'#333';border-radius:20px;font-size:12px;cursor:pointer" @click="selectedCar=c.id;form.model=c.brand+' '+c.model">{{ c.brand }} {{ c.model }}</span>
      </div>
    </div>
    <!-- 表单 -->
    <div style="margin:12px;background:#fff;border-radius:12px;overflow:hidden">
      <van-field v-model="form.name" label="姓名" placeholder="您的姓名" />
      <van-field v-model="form.phone" label="手机号" placeholder="您的手机号" type="tel" maxlength="11" />
      <van-field :model-value="form.model" label="意向车型" placeholder="请在上方选择车型" readonly />
      <van-field v-model="form.remark" label="备注" placeholder="试驾时间偏好" type="textarea" rows="2" />
    </div>
    <div style="margin:12px">
      <van-button type="primary" block size="large" round @click="submit">立即预约试驾</van-button>
    </div>
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'; import api from '../api'; import { showToast } from 'vant'
const cars = ref([]); const selectedCar = ref(null)
const form = ref({ name:'', phone:'', model:'', remark:'' })
onMounted(async () => { try { const r = await api.get('/api/stock/vehicles?size=50'); cars.value = r.data.data.records } catch(e){} })
async function submit() { if (!form.value.phone) { showToast('请输入手机号'); return }; showToast('预约成功!'); form.value = { name:'', phone:'', model:'', remark:'' }; selectedCar.value = null }
</script>
