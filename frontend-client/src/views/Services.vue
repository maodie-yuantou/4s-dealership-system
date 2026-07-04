<template>
  <div style="background:#f5f5f5;min-height:100vh;padding-bottom:60px">
    <div style="background:linear-gradient(180deg,#ff5000,#ff6a20);padding:30px 16px 24px">
      <div style="font-size:20px;font-weight:700;color:#fff;letter-spacing:1px">车主服务</div>
      <div style="font-size:12px;color:rgba(255,255,255,0.7);margin-top:4px">润达汽车 · 一站式用车服务</div>
    </div>
    <div style="padding:12px">
      <div style="display:flex;flex-wrap:wrap;gap:10px">
        <div v-for="s in services" :key="s.label" style="width:calc(50% - 5px);background:#fff;border-radius:12px;padding:20px 16px;cursor:pointer;transition:all 0.2s" @click="$router.push(s.path)">
          <div style="font-size:32px;margin-bottom:10px">{{ s.icon }}</div>
          <div style="font-size:16px;font-weight:600;color:#333">{{ s.label }}</div>
          <div style="font-size:12px;color:#999;margin-top:4px">{{ s.desc }}</div>
        </div>
      </div>
    </div>
  </div>
</template>
<script setup>
const services = [
  { icon:'📋', label:'预约试驾', desc:'到店体验心仪车型', path:'/test-drive' },
  { icon:'💰', label:'金融计算', desc:'多种灵活购车方案', path:'/finance' },
  { icon:'🔄', label:'置换估价', desc:'二手车高价回收', path:'/trade-in' },
  { icon:'💬', label:'在线客服', desc:'专业顾问实时回复', path:'/chat' },
  { icon:'🚗', label:'专属顾问', desc:'一对一购车咨询', path:'/chat' },
  { icon:'🔧', label:'预约保养', desc:'在线预约到店保养', path:'/test-drive' },
]
</script>
