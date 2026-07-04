<template>
  <div>
    <el-card><template #header><div style="display:flex;justify-content:space-between"><span>维修工单</span><el-button type="primary" size="small" @click="openDialog()">开立工单</el-button></div></template>
      <el-table :data="tableData" border stripe v-loading="loading">
        <el-table-column prop="woNo" label="工单号" width="150"/><el-table-column prop="vehicleDesc" label="车辆"/>
        <el-table-column prop="customerComplaint" label="客户描述"/><el-table-column prop="status" label="状态">
          <template #default="{row}"><el-tag :type="row.status==='COMPLETED'?'success':row.status==='IN_PROGRESS'?'warning':''">{{{RECEPTION:'待接车',DISPATCHED:'已派工',IN_PROGRESS:'维修中',QC:'质检中',WASH:'洗车中',SETTLEMENT:'结算中',COMPLETED:'已完成'}[row.status]||row.status}}</el-tag></template>
        </el-table-column>
        <el-table-column label="操作" width="200"><template #default="{row}"><el-button size="small" @click="openDialog(row)">编辑</el-button><el-button v-if="row.status!=='COMPLETED'" size="small" type="primary" @click="updateStatus(row)">下一状态</el-button></template></el-table-column>
      </el-table>
      <div style="margin-top:16px;text-align:right"><el-pagination v-model:current-page="page" :page-size="size" :total="total" layout="total,prev,pager,next" @current-change="fetchData"/></div>
    </el-card>
    <el-dialog :title="form.id?'编辑工单':'开立工单'" v-model="dialogVisible" width="500px" @close="form={}">
      <el-form :model="form" label-width="80px"><el-form-item label="客户ID"><el-input-number v-model="form.customerId" style="width:100%"/></el-form-item><el-form-item label="车辆"><el-input v-model="form.vehicleDesc"/></el-form-item><el-form-item label="客户描述"><el-input v-model="form.customerComplaint" type="textarea"/></el-form-item><el-form-item label="里程"><el-input-number v-model="form.mileage" :min="0" style="width:100%"/></el-form-item></el-form>
      <template #footer><el-button @click="dialogVisible=false">取消</el-button><el-button type="primary" @click="saveForm">保存</el-button></template>
    </el-dialog>
  </div>
</template><script setup>
import { ref,onMounted } from 'vue';import api from '../../api';import { ElMessage } from 'element-plus'
const tableData=ref([]),loading=ref(false),page=ref(1),size=ref(10),total=ref(0),dialogVisible=ref(false),form=ref({})
const statusFlow = ['RECEPTION','DISPATCHED','IN_PROGRESS','QC','WASH','SETTLEMENT','COMPLETED']
async function fetchData(){loading.value=true;const r=await api.get('/api/service/work-orders',{params:{page:page.value,size:size.value}});tableData.value=r.data.data.records;total.value=r.data.data.total;loading.value=false}
function openDialog(row){form.value=row?{...row}:{};dialogVisible.value=true}
async function saveForm(){if(form.value.id)await api.put(`/api/service/work-orders/${form.value.id}`,form.value);else await api.post('/api/service/work-orders',form.value);ElMessage.success('OK');dialogVisible.value=false;fetchData()}
async function updateStatus(row){const idx=statusFlow.indexOf(row.status);if(idx>=0&&idx<statusFlow.length-1){await api.put(`/api/service/work-orders/${row.id}/status`,{status:statusFlow[idx+1]});ElMessage.success('状态已更新');fetchData()}}
onMounted(fetchData)
</script>
