<template>
  <div style="background:#f5f5f5;min-height:100vh;padding-bottom:20px">
    <div style="background:#fff;padding:14px 16px;display:flex;align-items:center;border-bottom:1px solid #eee">
      <span style="font-size:18px;cursor:pointer" @click="$router.back()">←</span>
      <span style="flex:1;text-align:center;font-size:17px;font-weight:600">预约{{ typeName }}</span>
    </div>
    <!-- 试驾 -->
    <template v-if="serviceType==='TEST_DRIVE'">
      <div style="background:linear-gradient(180deg,#1989fa,#1556b0);padding:30px 20px;text-align:center;color:#fff;margin-bottom:12px">
        <div style="font-size:36px;margin-bottom:8px">🚗</div>
        <div style="font-size:18px;font-weight:600">预约试驾</div>
        <div style="font-size:12px;opacity:0.7;margin-top:4px">亲身感受，才能做出最好的选择</div>
      </div>
      <div style="padding:0 16px"><div style="background:#fff;border-radius:12px;overflow:hidden">
        <van-field v-model="form.customerName" label="姓名" placeholder="请输入姓名" />
        <van-field v-model="form.phone" label="手机号" placeholder="请输入手机号" type="tel" />
        <van-field v-model="form.vehicleInfo" label="意向车型" placeholder="如: 奥迪A6L" />
        <div style="padding:12px 16px"><div style="font-size:14px;color:#333;margin-bottom:8px">到店时间</div><input type="datetime-local" v-model="form.appointmentTime" style="width:100%;padding:10px;border:1px solid #eee;border-radius:8px;font-size:14px;color:#333" /></div>
        <div style="padding:16px"><van-button block round type="primary" style="background:#1989fa;border:none;font-weight:600" @click="submit" :loading="loading">提交预约</van-button></div>
      </div></div>
    </template>

    <!-- 保养 -->
    <template v-else-if="serviceType==='MAINTENANCE'">
      <div style="background:linear-gradient(180deg,#07c160,#059048);padding:30px 20px;text-align:center;color:#fff;margin-bottom:12px">
        <div style="font-size:36px;margin-bottom:8px">🔧</div>
        <div style="font-size:18px;font-weight:600">预约保养</div>
        <div style="font-size:12px;opacity:0.7;margin-top:4px">定期保养，延长爱车寿命</div>
      </div>
      <div style="padding:0 16px"><div style="background:#fff;border-radius:12px;overflow:hidden">
        <van-field v-model="form.customerName" label="姓名" placeholder="请输入姓名" />
        <van-field v-model="form.phone" label="手机号" placeholder="请输入手机号" type="tel" />
        <van-field v-model="form.vehicleInfo" label="车辆信息" placeholder="品牌车型+车牌号" />
        <div style="padding:12px 16px;display:flex;flex-wrap:wrap;gap:8px">
          <span v-for="p in ['基础保养','大保养','空调清洗','刹车片更换','轮胎更换','全车检查']" :key="p" :style="{padding:'6px 14px',borderRadius:16,fontSize:12,cursor:'pointer',color:form.description===p?'#07c160':'#999',background:form.description===p?'#e6f9f0':'#f5f5f5',border:form.description===p?'1px solid #07c160':'1px solid transparent'}" @click="form.description = form.description===p?'':p">{{ p }}</span>
        </div>
        <div style="padding:12px 16px"><div style="font-size:14px;color:#333;margin-bottom:8px">预约时间</div><input type="datetime-local" v-model="form.appointmentTime" style="width:100%;padding:10px;border:1px solid #eee;border-radius:8px;font-size:14px;color:#333" /></div>
        <div style="padding:16px"><van-button block round type="primary" style="background:#07c160;border:none;font-weight:600" @click="submit" :loading="loading">提交预约</van-button></div>
      </div></div>
    </template>

    <!-- 维修 -->
    <template v-else>
      <div style="background:linear-gradient(180deg,#f0ad4e,#d68910);padding:30px 20px;text-align:center;color:#fff;margin-bottom:12px">
        <div style="font-size:36px;margin-bottom:8px">🔨</div>
        <div style="font-size:18px;font-weight:600">预约维修</div>
        <div style="font-size:12px;opacity:0.7;margin-top:4px">专业技师，快速响应</div>
      </div>
      <div style="padding:0 16px"><div style="background:#fff;border-radius:12px;overflow:hidden">
        <van-field v-model="form.customerName" label="姓名" placeholder="请输入姓名" />
        <van-field v-model="form.phone" label="手机号" placeholder="请输入手机号" type="tel" />
        <van-field v-model="form.vehicleInfo" label="车辆信息" placeholder="品牌车型+车牌号" />
        <van-field v-model="form.description" label="故障描述" placeholder="请详细描述车辆故障现象" type="textarea" rows="4" />
        <div style="padding:12px 16px"><div style="font-size:14px;color:#333;margin-bottom:8px">期望到店时间</div><input type="datetime-local" v-model="form.appointmentTime" style="width:100%;padding:10px;border:1px solid #eee;border-radius:8px;font-size:14px;color:#333" /></div>
        <div style="padding:16px"><van-button block round type="primary" style="background:#f0ad4e;border:none;font-weight:600;color:#fff" @click="submit" :loading="loading">提交预约</van-button></div>
      </div></div>
    </template>
  </div>
</template>
<script setup>
import { ref, reactive, computed } from 'vue'; import { useRoute } from 'vue-router'; import api from '../api'; import { showToast, showSuccessToast } from 'vant'
const route = useRoute(); const serviceType = route.query.type || 'TEST_DRIVE'
const typeName = computed(() => ({TEST_DRIVE:'试驾',MAINTENANCE:'保养',REPAIR:'维修'}[serviceType]||'服务'))
const loading = ref(false);
const form = reactive({ customerName:'', phone:'', vehicleInfo:'', description:'', appointmentTime:'', serviceType })
async function submit() {
  if (!form.customerName || !form.phone) { showToast('请填写姓名和手机号'); return }
  const t = form.appointmentTime
  if (!t) { showToast('请填写预约时间'); return }
  if (!t) { showToast('请选择时间'); return }
  form.appointmentTime = new Date(t).toISOString().slice(0,19)
  form.customerId = parseInt(localStorage.getItem('cid') || '0')
  loading.value = true
  try { await api.post('/api/client/book-appointment', form); showSuccessToast('预约成功'); setTimeout(() => history.back(), 1000) } catch(e) { showToast(e.response?.data?.message || '预约失败') } finally { loading.value = false }
}
</script>
