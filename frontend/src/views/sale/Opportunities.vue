<template>
  <div><el-card><template #header><div style="display:flex;justify-content:space-between"><span>销售机会</span><el-button type="primary" size="small" @click="openDialog()">新建机会</el-button></div></template>
      <el-table :data="tableData" border stripe v-loading="loading"><el-table-column prop="customerId" label="客户ID" width="80"/><el-table-column prop="intentColor" label="意向颜色"/><el-table-column prop="paymentMethod" label="付款方式"/><el-table-column prop="status" label="状态"><template #default="{row}"><el-tag>{{{FOLLOWING:'跟进中',QUOTED:'已报价',ORDERED:'已下单',LOST:'已丢失'}[row.status]||row.status}}</el-tag></template></el-table-column><el-table-column label="操作" width="150"><template #default="{row}"><el-button size="small" @click="openDialog(row)">编辑</el-button><el-button size="small" type="danger" @click="del(row.id)">删除</el-button></template></el-table-column></el-table>
      <div style="margin-top:16px;text-align:right"><el-pagination v-model:current-page="page" :page-size="size" :total="total" layout="total,prev,pager,next" @current-change="fetchData"/></div></el-card></div>
</template><script setup>
import { ref,onMounted } from 'vue';import api from '../../api';import { ElMessage } from 'element-plus'
const tableData=ref([]),loading=ref(false),page=ref(1),size=ref(10),total=ref(0)
async function fetchData(){loading.value=true;const r=await api.get('/api/sale/opportunities',{params:{page:page.value,size:size.value}});tableData.value=r.data.data.records;total.value=r.data.data.total;loading.value=false}
async function del(id){await api.delete(`/api/sale/opportunities/${id}`);ElMessage.success('已删除');fetchData()}
onMounted(fetchData)
</script>
