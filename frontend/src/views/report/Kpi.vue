<template>
  <div>
    <h3>报表分析</h3>
    <el-row :gutter="20" style="margin-top:16px">
      <el-col :span="12"><el-card header="KPI 概览"><el-descriptions :column="2" border><el-descriptions-item v-for="item in kpiItems" :key="item.label" :label="item.label">{{ item.value }}</el-descriptions-item></el-descriptions></el-card></el-col>
      <el-col :span="12"><el-card header="销售漏斗"><div ref="funnelChart" style="height:300px"></div></el-card></el-col>
    </el-row>
  </div>
</template><script setup>
import { ref,onMounted } from 'vue';import api from '../../api';import * as echarts from 'echarts'
const kpiItems=ref([{label:'今日新线索',value:0},{label:'今日订单',value:0},{label:'在库车辆',value:0},{label:'在修车辆',value:0},{label:'今日交车',value:0}])
const funnelChart=ref(null)
onMounted(async()=>{try{const k=await api.get('/api/report/kpi');const d=k.data.data;kpiItems.value[0].value=d.todayLeads;kpiItems.value[1].value=d.todayOrders;kpiItems.value[2].value=d.totalStock;kpiItems.value[3].value=d.inService;kpiItems.value[4].value=d.todayDeliveries}catch(e){};try{const f=await api.get('/api/report/sales-funnel');const ff=f.data.data;const c=echarts.init(funnelChart.value);c.setOption({series:[{type:'funnel',left:'10%',width:'80%',data:[{value:ff.leads,name:'线索'},{value:ff.opportunities,name:'意向'},{value:ff.orders,name:'订单'},{value:ff.deliveries,name:'交车'}]}]})}catch(e){}})
</script>
