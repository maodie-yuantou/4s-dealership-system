<template>
  <div>
    <el-card><template #header><div style="display:flex;justify-content:space-between"><span>活动管理</span><el-button type="primary" size="small" @click="openDialog()">新建活动</el-button></div></template>
      <el-table :data="tableData" border stripe v-loading="loading">
        <el-table-column prop="campaignName" label="活动名称"/><el-table-column prop="campaignType" label="类型"/>
        <el-table-column prop="budget" label="预算"/><el-table-column prop="actualCost" label="实际花费"/>
        <el-table-column prop="expectedLeads" label="预期获客"/><el-table-column prop="actualLeads" label="实际获客"/>
        <el-table-column prop="status" label="状态"><template #default="{row}"><el-tag>{{{PLANNING:'策划中',IN_PROGRESS:'执行中',COMPLETED:'已完成',CANCELLED:'已取消'}[row.status]}}</el-tag></template></el-table-column>
      </el-table>
      <div style="margin-top:16px;text-align:right"><el-pagination v-model:current-page="page" :page-size="size" :total="total" layout="total,prev,pager,next" @current-change="fetchData"/></div>
    </el-card>
  </div>
</template><script setup>
import { ref,onMounted } from 'vue';import api from '../../api';import { ElMessage } from 'element-plus'
const tableData=ref([]),loading=ref(false),page=ref(1),size=ref(10),total=ref(0),dialogVisible=ref(false),form=ref({})
async function fetchData(){loading.value=true;const r=await api.get('/api/marketing/campaigns',{params:{page:page.value,size:size.value}});tableData.value=r.data.data.records;total.value=r.data.data.total;loading.value=false}
function openDialog(row){form.value=row?{...row}:{};dialogVisible.value=true}
async function saveForm(){await api.post('/api/marketing/campaigns',form.value);ElMessage.success('OK');dialogVisible.value=false;fetchData()}
onMounted(fetchData)
</script>
