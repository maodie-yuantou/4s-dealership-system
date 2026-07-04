<template>
  <div><el-card><template #header><div style="display:flex;justify-content:space-between"><span>卡券管理</span><el-button type="primary" size="small" @click="openDialog()">创建卡券</el-button></div></template>
      <el-table :data="tableData" border stripe v-loading="loading"><el-table-column prop="couponName" label="名称"/><el-table-column prop="couponType" label="类型"><template #default="{row}">{{{MAINTENANCE:'保养券',LABOR:'工时券',DISCOUNT:'折扣券',OTHER:'其他'}[row.couponType]}}</template></el-table-column><el-table-column prop="faceValue" label="面值"/><el-table-column prop="totalQuantity" label="总数"/><el-table-column prop="issuedQuantity" label="已发"/><el-table-column prop="usedQuantity" label="已用"/><el-table-column prop="status" label="状态"><template #default="{row}"><el-tag :type="row.status==='ACTIVE'?'success':row.status==='PAUSED'?'warning':'info'">{{{ACTIVE:'生效',PAUSED:'暂停',EXPIRED:'过期'}[row.status]}}</el-tag></template></el-table-column></el-table>
      <div style="margin-top:16px;text-align:right"><el-pagination v-model:current-page="page" :page-size="size" :total="total" layout="total,prev,pager,next" @current-change="fetchData"/></div></el-card></div>
</template><script setup>
import { ref,onMounted } from 'vue';import api from '../../api';import { ElMessage } from 'element-plus'
const tableData=ref([]),loading=ref(false),page=ref(1),size=ref(10),total=ref(0),dialogVisible=ref(false),form=ref({})
async function fetchData(){loading.value=true;const r=await api.get('/api/marketing/coupons',{params:{page:page.value,size:size.value}});tableData.value=r.data.data.records;total.value=r.data.data.total;loading.value=false}
function openDialog(row){form.value=row?{...row}:{};dialogVisible.value=true}
async function saveForm(){await api.post('/api/marketing/coupons',form.value);ElMessage.success('OK');dialogVisible.value=false;fetchData()}
onMounted(fetchData)
</script>
