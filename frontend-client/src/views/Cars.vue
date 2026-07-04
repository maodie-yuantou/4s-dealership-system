<template>
  <div style="background:#f5f5f5;min-height:100vh;padding-bottom:60px">
    <div style="background:linear-gradient(180deg,#ff5000,#ff6a20);padding:12px 16px 16px">
      <div style="display:flex;align-items:center;gap:8px;margin-bottom:12px">
        <div style="flex:1;background:#fff;border-radius:20px;padding:8px 14px;display:flex;align-items:center;gap:6px">
          <span>🔍</span><input v-model="keyword" placeholder="搜索车型" style="border:none;outline:none;font-size:14px;flex:1" @input="filterData" />
        </div>
      </div>
    </div>
    <div style="padding:10px 12px;display:flex;gap:8px;overflow-x:auto;background:#fff">
      <div :style="{flexShrink:0,padding:'6px 14px',borderRadius:14,fontSize:12,cursor:pointer,background:!brand?'#ff5000':'#f5f5f5',color:!brand?'#fff':'#666'}" @click="brand='';filterData()">全部</div>
      <div v-for="b in brands" :key="b" :style="{flexShrink:0,padding:'6px 14px',borderRadius:14,fontSize:12,cursor:pointer,background:brand===b?'#ff5000':'#f5f5f5',color:brand===b?'#fff':'#666'}" @click="brand=(brand===b?'':b);filterData()">{{ b }}</div>
    </div>
    <div style="padding:8px;display:flex;flex-wrap:wrap;gap:6px">
      <div v-for="c in filtered" :key="c.id" style="width:calc(50% - 3px);background:#fff;border-radius:10px;overflow:hidden;cursor:pointer" @click="$router.push('/car/'+c.id)">
        <div style="height:130px;background:#eee;overflow:hidden;position:relative" @dblclick.stop="preview(c)">
          <img :src="getCarImage(c.brand,c.model,c.imageUrl)" style="width:100%;height:100%;object-fit:cover" :alt="c.brand" @error="e => e.target.src = getCarPlaceholder(c.brand, c.model)" />
          <span :style="{position:'absolute',top:'6px',left:'6px',padding:'2px 8px',borderRadius:3,fontSize:10,color:'#fff',background:c.status==='IN_STOCK'?'#07c160':c.status==='RESERVED'?'#f0ad4e':'#1989fa'}">{{ c.status==='IN_STOCK'?'在库':'已订' }}</span>
        </div>
        <div style="padding:10px">
          <div style="font-size:13px;font-weight:600;color:#333;overflow:hidden;text-overflow:ellipsis;white-space:nowrap">{{ c.brand }} {{ c.model }}</div>
          <div style="font-size:11px;color:#999;margin-top:3px">{{ c.modelYear }}款 · {{ c.color }}</div>
          <div style="margin-top:6px;color:#ff5000;font-size:16px;font-weight:700">{{ (c.guidePrice/10000).toFixed(2) }}<span style="font-size:11px;font-weight:500">万</span></div>
        </div>
      </div>
    </div>
  </div>
</template>
<script setup>
import { ref, computed, onMounted } from 'vue'; import { showImagePreview } from 'vant'; import api, { getCarImage, getCarPlaceholder } from '../api'
const cars = ref([]); const brand = ref(''); const keyword = ref(''); const brands = ref([])
const filtered = computed(() => {
  let list = cars.value
  if (brand.value) list = list.filter(c => c.brand === brand.value)
  if (keyword.value) list = list.filter(c => (c.brand+c.model).toLowerCase().includes(keyword.value.toLowerCase()))
  return list
})
function preview(c) { showImagePreview({ images: [getCarImage(c.brand,c.model,c.imageUrl)], showIndex: false, closeable: true }) }
async function filterData() {
  try { const r = await api.get('/api/stock/vehicles', { params: { page:1,size:50 } }); cars.value = r.data.data.records; brands.value = [...new Set(r.data.data.records.map(c=>c.brand))] } catch(e){}
}
onMounted(filterData)
</script>
