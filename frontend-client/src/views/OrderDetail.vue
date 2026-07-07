<template>
  <div style="background:#f5f5f5;min-height:100vh;padding-bottom:20px">
    <div style="background:#fff;padding:14px 16px;display:flex;align-items:center;border-bottom:1px solid #eee">
      <span style="font-size:18px;cursor:pointer;width:30px" @click="$router.back()">←</span>
      <span style="flex:1;text-align:center;font-size:17px;font-weight:600">订单详情</span>
    </div>
    <div v-if="order.id" style="padding:12px">
      <!-- 订单号+状态 -->
      <div style="background:#fff;border-radius:10px;padding:16px;margin-bottom:10px">
        <div style="display:flex;justify-content:space-between;align-items:center">
          <div>
            <div style="font-size:12px;color:#999;margin-bottom:4px">订单号</div>
            <div style="font-weight:600;color:#333">{{ order.orderNo }}</div>
          </div>
          <div :style="{padding:'4px 14px',borderRadius:20,fontSize:13,fontWeight:600,color:order.status==='COMPLETED'?'#07c160':order.status==='PENDING_DELIVERY'?'#1989fa':'#f0ad4e',background:order.status==='COMPLETED'?'#e6f9f0':order.status==='PENDING_DELIVERY'?'#e6f2ff':'#fef5e7'}">{{ {PENDING_DEPOSIT:'待付定金',PENDING_DELIVERY:'待交车',COMPLETED:'已完成',CANCELLED:'已取消'}[order.status]||order.status }}</div>
        </div>
        <div style="font-size:12px;color:#bbb;margin-top:8px">下单时间：{{ order.createdAt||'-' }}</div>
      </div>

      <!-- 商品列表 -->
      <div style="background:#fff;border-radius:10px;padding:16px;margin-bottom:10px">
        <div style="font-size:14px;font-weight:600;margin-bottom:12px;color:#333">商品明细</div>
        <div v-for="(item,i) in items" :key="i" style="display:flex;align-items:center;padding:10px 0;border-bottom:1px solid #f5f5f5">
          <div style="flex:1">
            <div style="font-size:14px;font-weight:500;color:#333">{{ item.name }}</div>
            <div style="font-size:11px;color:#999;margin-top:2px">{{ item.desc }}</div>
          </div>
          <div style="text-align:right">
            <div style="color:#ff5000;font-weight:600">¥{{ (item.price||0).toLocaleString() }}</div>
            <div style="font-size:11px;color:#999">×{{ item.qty||1 }}</div>
          </div>
        </div>
        <div v-if="!items.length" style="text-align:center;padding:20px;color:#ccc">无商品明细</div>
      </div>

      <!-- 价格汇总 -->
      <div style="background:#fff;border-radius:10px;padding:16px;margin-bottom:10px">
        <div style="font-size:14px;font-weight:600;margin-bottom:12px;color:#333">价格明细</div>
        <div style="display:flex;justify-content:space-between;padding:8px 0;border-bottom:1px solid #f5f5f5"><span style="color:#999">商品总价</span><span style="font-weight:500">¥{{ (order.guidePrice||0).toLocaleString() }}</span></div>
        <div style="display:flex;justify-content:space-between;padding:8px 0;border-bottom:1px solid #f5f5f5"><span style="color:#999">优惠金额</span><span style="color:#07c160;font-weight:500">-¥{{ (order.discount||0).toLocaleString() }}</span></div>
        <div style="display:flex;justify-content:space-between;padding:10px 0"><span style="font-weight:600;font-size:16px">实付金额</span><span style="color:#ff5000;font-size:22px;font-weight:700">¥{{ (order.totalPrice||0).toLocaleString() }}</span></div>
      </div>
    </div>
  </div>
</template>
<script setup>
import { ref, computed, onMounted } from 'vue'; import { useRoute } from 'vue-router'; import api from '../api'
const route = useRoute(); const order = ref({})
const items = computed(() => { try { return JSON.parse(order.value.remark||'[]') } catch(e) { console.log('parse error',e); return [] } })
onMounted(async () => {
  try { const r = await api.get('/api/sale/orders/'+route.query.id); order.value = r.data.data||{} } catch(e){}
})
</script>
