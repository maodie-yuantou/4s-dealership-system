<template>
  <div style="background:#f5f5f5;min-height:100vh;padding-bottom:60px">
    <!-- 搜索栏 -->
    <div style="background:linear-gradient(180deg,#ff5000,#ff6a20);padding:12px 16px 16px">
      <div style="display:flex;align-items:center;gap:8px">
        <div style="flex:1;background:rgba(255,255,255,0.9);border-radius:20px;padding:8px 16px;display:flex;align-items:center;gap:6px;font-size:13px;color:#999" @click="$router.push('/cars')">
          <span>🔍</span><span>搜索车型、品牌</span>
        </div>
        <span style="color:#fff;font-size:24px;cursor:pointer" @click="$router.push('/chat')">💬</span>
      </div>
    </div>

    <!-- 轮播横幅 -->
    <div style="margin:10px 12px;background:linear-gradient(135deg,#1a1a2e,#16213e);border-radius:16px;padding:30px 20px;color:#fff;text-align:center">
      <div style="font-size:11px;letter-spacing:3px;color:#ff6a20;margin-bottom:8px">HOT RECOMMEND</div>
      <div style="font-size:22px;font-weight:700;letter-spacing:2px">全新车型到店</div>
      <div style="font-size:13px;opacity:0.7;margin:10px 0 20px">豪华品牌 · 现车充足 · 到店试驾有礼</div>
      <div style="display:inline-block;padding:10px 28px;background:#ff5000;border-radius:20px;font-size:14px;font-weight:600;cursor:pointer" @click="$router.push('/test-drive')">立即预约</div>
    </div>

    <!-- 快捷分类 -->
    <div style="margin:0 12px;background:#fff;border-radius:12px;padding:16px 0;display:flex;text-align:center">
      <div v-for="cat in categories" :key="cat.label" style="flex:1;cursor:pointer" @click="$router.push(cat.path)">
        <div style="font-size:28px;margin-bottom:6px">{{ cat.icon }}</div>
        <div style="font-size:12px;color:#666">{{ cat.label }}</div>
      </div>
    </div>

    <!-- 热门车型 -->
    <div style="padding:16px 12px 8px;display:flex;justify-content:space-between;align-items:center">
      <div style="font-size:17px;font-weight:700;color:#333">热门车型</div>
      <div style="font-size:12px;color:#ff5000;cursor:pointer" @click="$router.push('/cars')">更多 →</div>
    </div>
    <div style="padding:0 12px;display:flex;flex-wrap:wrap;gap:8px">
      <div v-for="c in hotCars" :key="c.id" style="width:calc(50% - 4px);background:#fff;border-radius:10px;overflow:hidden;cursor:pointer" @click="$router.push('/car/'+c.id)">
        <div style="height:130px;background:#eee;overflow:hidden;position:relative">
          <img :src="getCarImage(c.brand,c.model,c.imageUrl)" style="width:100%;height:100%;object-fit:cover" :alt="c.brand" @error="e => e.target.src = getCarPlaceholder(c.brand, c.model)" />
          <span :style="{position:'absolute',top:'6px',left:'6px',padding:'2px 8px',borderRadius:3,fontSize:10,color:'#fff',background:c.status==='IN_STOCK'?'#07c160':c.status==='RESERVED'?'#f0ad4e':'#1989fa'}">{{ c.status==='IN_STOCK'?'在库':c.status==='SHOWROOM'?'展厅':'已订' }}</span>
        </div>
        <div style="padding:10px">
          <div style="font-size:13px;font-weight:600;color:#333;overflow:hidden;text-overflow:ellipsis;white-space:nowrap">{{ c.brand }} {{ c.model }}</div>
          <div style="font-size:11px;color:#999;margin-top:4px">{{ c.modelYear }}款 · {{ c.color }}</div>
          <div style="margin-top:6px;display:flex;align-items:baseline;justify-content:space-between">
            <span style="color:#ff5000;font-size:16px;font-weight:700">{{ ((c.guidePrice||0)/10000).toFixed(2) }}<span style="font-size:11px;font-weight:500">万</span></span>
            <span style="font-size:10px;color:#999">{{ (c.guidePrice*0.9/10000).toFixed(2) }}万起</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'; import api, { getCarImage, getCarPlaceholder } from '../api'
const hotCars = ref([])
const categories = [
  { icon:'🚗', label:'全部车型', path:'/cars' },{ icon:'📋', label:'预约试驾', path:'/test-drive' },
  { icon:'💰', label:'金融计算', path:'/finance' },{ icon:'🔄', label:'置换估价', path:'/trade-in' },
  { icon:'🔧', label:'预约保养', path:'/test-drive' }
]
onMounted(async () => {
  try { const r = await api.get('/api/stock/vehicles', { params: { page:1, size:6 } }); hotCars.value = r.data.data.records } catch(e){}
})
</script>
