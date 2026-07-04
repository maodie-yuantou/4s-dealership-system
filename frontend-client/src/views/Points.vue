<template>
  <div style="min-height:100vh;background:#0a0a0a">
    <div style="padding:14px 16px;display:flex;align-items:center;gap:12px;color:#fff;border-bottom:1px solid rgba(255,255,255,0.06)">
      <span style="font-size:20px;cursor:pointer" @click="$router.push('/mine')">←</span>
      <span style="font-size:17px;font-weight:300;letter-spacing:2px">积分会员</span>
    </div>
    <div style="background:linear-gradient(135deg,rgba(201,169,110,0.15),rgba(201,169,110,0.05));margin:16px;border-radius:14px;padding:30px 20px;text-align:center;border:1px solid rgba(201,169,110,0.15)">
      <div style="font-size:12px;color:#c9a96e;letter-spacing:2px">可用积分</div>
      <div style="font-size:48px;font-weight:700;color:#c9a96e;margin:10px 0">{{ points }}</div>
      <div style="font-size:12px;color:rgba(255,255,255,0.4)">会员等级: {{ level }}</div>
    </div>
    <div style="margin:16px;background:rgba(255,255,255,0.04);border-radius:12px;overflow:hidden;border:1px solid rgba(255,255,255,0.06)">
      <div style="padding:14px 16px;color:#fff;font-size:14px;font-weight:600;border-bottom:1px solid rgba(255,255,255,0.06)">积分规则</div>
      <div v-for="r in rules" :key="r" style="padding:12px 16px;color:rgba(255,255,255,0.5);font-size:13px;border-bottom:1px solid rgba(255,255,255,0.04)">{{ r }}</div>
    </div>
  </div>
</template>
<script setup>
import { ref } from 'vue'
const points = ref(0); const level = ref('普通会员')
const rules = ['消费1元=1积分','每日签到+5积分','积分可兑换保养套餐和精品','积分有效期2年']
</script>
