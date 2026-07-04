<template>
  <div style="background:#f5f5f5;min-height:100vh">
    <div style="background:#000;color:#fff;padding:16px;display:flex;align-items:center;gap:12px">
      <span style="font-size:20px" @click="$router.back()">←</span>
      <span style="font-size:18px;font-weight:bold">金融计算器</span>
    </div>
    <div style="background:#fff;margin:12px;border-radius:12px;padding:16px">
      <h4 style="margin:0 0 16px">贷款方案</h4>
      <van-field label="车价(万)" :model-value="price" readonly />
      <van-slider v-model="price" :min="5" :max="100" :step="1" style="margin:16px" @update:model-value="calc" />
      <van-field label="首付比例" :model-value="downPercent+'%'" readonly />
      <van-slider v-model="downPercent" :min="10" :max="80" :step="10" style="margin:16px" @update:model-value="calc" />
      <van-field label="贷款期限" :model-value="months+'个月'" readonly />
      <van-slider v-model="months" :min="12" :max="60" :step="12" style="margin:16px" @update:model-value="calc" />
      <van-divider />
      <div style="display:flex;justify-content:space-around;text-align:center">
        <div><div style="color:#999;font-size:12px">首付</div><div style="font-size:20px;font-weight:bold;color:#e74c3c">{{ down.toFixed(1) }}万</div></div>
        <div><div style="color:#999;font-size:12px">月供</div><div style="font-size:20px;font-weight:bold;color:#1989fa">{{ monthly.toFixed(0) }}元</div></div>
        <div><div style="color:#999;font-size:12px">总利息</div><div style="font-size:20px;font-weight:bold">{{ interest.toFixed(0) }}元</div></div>
      </div>
      <van-button type="primary" block round style="margin-top:20px" @click="$router.push('/test-drive')">预约咨询金融方案</van-button>
    </div>
  </div>
</template>
<script setup>
import { ref } from 'vue'
const price = ref(25), downPercent = ref(30), months = ref(36), down = ref(7.5), monthly = ref(5200), interest = ref(12000)
function calc() { const loan = price.value * 10000 * (1 - downPercent.value / 100); down.value = price.value * downPercent.value / 100; const r = 0.04; monthly.value = (loan * r / 12) / (1 - Math.pow(1 + r / 12, -months.value)); interest.value = monthly.value * months.value - loan }
</script>
