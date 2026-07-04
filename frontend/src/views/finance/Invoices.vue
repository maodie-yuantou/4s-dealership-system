<template>
  <div>
    <el-card><template #header><div style="display:flex;justify-content:space-between"><span>发票管理</span><el-button type="primary" size="small" @click="openDialog()">开具发票</el-button></div></template>
      <el-table :data="tableData" border stripe v-loading="loading">
        <el-table-column prop="invoiceNo" label="发票号" width="150"/><el-table-column prop="customerName" label="客户"/>
        <el-table-column prop="amount" label="金额"/><el-table-column prop="totalAmount" label="价税合计"/>
        <el-table-column prop="status" label="状态"><template #default="{row}"><el-tag :type="row.status==='ISSUED'?'success':'danger'">{{{ISSUED:'已开具',VOIDED:'已作废',RED_FLUSH:'已红冲'}[row.status]}}</el-tag></template></el-table-column>
      </el-table>
      <div style="margin-top:16px;text-align:right"><el-pagination v-model:current-page="page" :page-size="size" :total="total" layout="total,prev,pager,next" @current-change="fetchData"/></div>
    </el-card>
  </div>
</template><script setup>
import { ref,onMounted } from 'vue';import api from '../../api';import { ElMessage } from 'element-plus'
const tableData=ref([]),loading=ref(false),page=ref(1),size=ref(10),total=ref(0),dialogVisible=ref(false),form=ref({})
async function fetchData(){loading.value=true;const r=await api.get('/api/finance/invoices',{params:{page:page.value,size:size.value}});tableData.value=r.data.data.records;total.value=r.data.data.total;loading.value=false}
function openDialog(row){form.value=row?{...row}:{};dialogVisible.value=true}
async function saveForm(){await api.post('/api/finance/invoices',form.value);ElMessage.success('OK');dialogVisible.value=false;fetchData()}
onMounted(fetchData)
</script>
