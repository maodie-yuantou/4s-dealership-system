<template>
  <div style="background:#f5f5f5;min-height:100vh;padding-bottom:80px">
    <div style="position:relative;height:250px;overflow:hidden" @dblclick="preview">
      <img :src="getCarImage(car.brand,car.model,car.imageUrl)" style="width:100%;height:100%;object-fit:cover" :alt="car.brand" @error="e=>e.target.src=getCarPlaceholder(car.brand,car.model)" />
      <div style="position:absolute;top:0;left:0;right:0;bottom:0;background:linear-gradient(to bottom,transparent 30%,rgba(0,0,0,0.7))"></div>
      <span style="position:absolute;top:14px;left:14px;width:32px;height:32px;background:rgba(0,0,0,0.5);border-radius:50%;display:flex;align-items:center;justify-content:center;color:#fff;font-size:18px;cursor:pointer" @click="$router.back()">←</span>
      <span :style="{position:'absolute',top:'14px',right:'14px',padding:'4px 12px',borderRadius:4,fontSize:12,color:'#fff',background:car.status==='IN_STOCK'?'rgba(7,193,96,0.85)':car.status==='RESERVED'?'rgba(240,173,78,0.85)':'rgba(153,153,153,0.85)'}">{{ car.status==='IN_STOCK'?'现车':car.status==='SHOWROOM'?'展厅':'已订' }}</span>
    </div>
    <div style="margin:-40px 12px 0;position:relative;z-index:1;background:#fff;border-radius:12px;padding:16px">
      <div style="display:flex;align-items:flex-start;justify-content:space-between">
        <div><h2 style="margin:0;font-size:20px;font-weight:600">{{ car.brand }} {{ car.model }}</h2>
        <div style="font-size:13px;color:#999;margin-top:6px">{{ car.modelYear }}款 · {{ car.vehicleType||'轿车' }} · {{ car.color }}</div></div>
        <div style="text-align:right"><span style="color:#ff5000;font-size:26px;font-weight:700">{{ ((car.guidePrice||0)/10000).toFixed(2) }}</span><span style="font-size:12px;color:#999">万</span></div>
      </div>
    </div>
    <div style="margin:12px;background:#fff;border-radius:12px;padding:16px">
      <h3 style="margin:0 0 14px;font-size:15px;font-weight:600">车辆参数</h3>
      <div style="display:flex;flex-wrap:wrap">
        <div v-for="p in params" :key="p.label" style="width:25%;margin-bottom:14px;text-align:center"><div style="font-size:11px;color:#999">{{ p.label }}</div><div style="font-size:14px;font-weight:500;color:#333;margin-top:4px">{{ p.value }}</div></div>
      </div>
    </div>
    <div v-if="videos.length" style="margin:12px;background:#fff;border-radius:12px;padding:16px">
      <h3 style="margin:0 0 14px;font-size:15px;font-weight:600">车辆视频 <span style="font-size:12px;color:#999;font-weight:400">{{ videos.length }}个</span></h3>
      <div v-for="v in videos" :key="v.id" style="margin-bottom:10px;background:#000;border-radius:8px;overflow:hidden">
        <iframe v-if="playingId===v.id&&isBilibili(v.videoUrl)" :src="bilibiliEmbed(v.videoUrl)" allowfullscreen style="width:100%;aspect-ratio:16/9;border:none"></iframe>
        <video v-else-if="playingId===v.id" :src="v.videoUrl" controls autoplay style="width:100%;aspect-ratio:16/9" @ended="playingId=null"></video>
        <div v-else @click="playVideo(v)" style="width:100%;aspect-ratio:16/9;display:flex;align-items:center;justify-content:center;color:#999;cursor:pointer">
          <div style="width:44px;height:44px;border:2px solid #ccc;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:18px">▶</div>
          <div style="margin-left:12px;font-size:14px">{{ v.title }}</div>
        </div>
      </div>
    </div>
    <div style="position:fixed;bottom:0;left:0;right:0;background:#fff;padding:10px 16px;display:flex;gap:10px;box-shadow:0 -2px 10px rgba(0,0,0,0.06);z-index:100">
      <van-button plain size="large" style="flex:1;border-radius:24px" @click="addToCart">加入购物车</van-button>
      <van-button type="primary" size="large" style="flex:1;border-radius:24px;background:#ff5000;border:none" @click="$router.push('/test-drive')">预约试驾</van-button>
    </div>
  </div>
</template>
<script setup>
import { ref, onMounted, computed } from 'vue'; import { useRoute } from 'vue-router'; import { showImagePreview } from 'vant'; import api, { getCarImage, getCarPlaceholder } from '../api'; import { useCartStore } from '../stores/cart'
const route = useRoute(); const car = ref({}); const videos = ref([]); const playingId = ref(null)
const params = computed(() => [{ label:'品牌',value:car.value.brand },{ label:'车型',value:car.value.model },{ label:'年份',value:(car.value.modelYear||'')+'款' },{ label:'颜色',value:car.value.color },{ label:'类型',value:car.value.vehicleType||'-' },{ label:'库存',value:car.value.status==='IN_STOCK'?'现车':car.value.status==='SHOWROOM'?'展厅':'已订' },{ label:'入库',value:car.value.inboundDate||'-' },{ label:'车架号',value:(car.value.vin||'').slice(-8) }])
function preview(){showImagePreview({images:[getCarImage(car.value.brand,car.value.model,car.value.imageUrl)],showIndex:false,closeable:true})}
const cartStore = useCartStore()
function addToCart(){cartStore.add({type:'vehicle',id:car.value.id,name:car.value.brand+' '+car.value.model,desc:(car.value.modelYear||'')+'款 · '+car.value.color,price:car.value.guidePrice||0,image:getCarImage(car.value.brand,car.value.model,car.value.imageUrl)})}
function playVideo(v){playingId.value=v.id}
function isBilibili(url){return url.includes('bilibili.com')}
function bilibiliEmbed(url){const m=url.match(/BV\w+/);return m?'//player.bilibili.com/player.html?bvid='+m[0]+'&high_quality=1&autoplay=1':url}
onMounted(async()=>{try{const r=await api.get('/api/stock/vehicles/'+route.params.id);car.value=r.data.data}catch(e){};try{const r=await api.get('/api/stock/vehicles/'+route.params.id+'/videos');videos.value=r.data.data}catch(e){}})
</script>
