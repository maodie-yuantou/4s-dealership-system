<template>
  <div><el-card><template #header><span>跟进记录</span></template>
      <el-table :data="tableData" border stripe v-loading="loading"><el-table-column prop="customerId" label="客户ID" width="80"/><el-table-column prop="followMethod" label="方式" width="80"><template #default="{row}">{{{PHONE:'电话',WECHAT:'微信',VISIT:'到店',OTHER:'其他'}[row.followMethod]}}</template></el-table-column><el-table-column prop="summary" label="沟通摘要"/><el-table-column prop="result" label="结果"/><el-table-column prop="nextFollowTime" label="下次跟进" width="160"/></el-table>
      <div style="margin-top:16px;text-align:right"><el-pagination v-model:current-page="page" :page-size="size" :total="total" layout="total,prev,pager,next" @current-change="fetchData"/></div></el-card></div>
</template><script setup>
import { ref,onMounted } from 'vue';import api from '../../api'
const tableData=ref([]),loading=ref(false),page=ref(1),size=ref(10),total=ref(0)
async function fetchData(){loading.value=true;const r=await api.get('/api/crm/follow-ups',{params:{page:page.value,size:size.value}});tableData.value=r.data.data.records;total.value=r.data.data.total;loading.value=false}
onMounted(fetchData)
</script>
