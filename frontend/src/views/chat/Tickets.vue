<template>
  <div><el-card><template #header><span>智能客服工单</span></template>
      <el-table :data="tableData" border stripe v-loading="loading"><el-table-column prop="ticketNo" label="工单号" width="150"/><el-table-column prop="customerName" label="客户"/><el-table-column prop="phone" label="手机号"/><el-table-column prop="question" label="问题摘要"/><el-table-column prop="priority" label="优先级"><template #default="{row}"><el-tag :type="row.priority==='URGENT'?'danger':row.priority==='HIGH'?'warning':'info'">{{row.priority}}</el-tag></template></el-table-column><el-table-column prop="status" label="状态"><template #default="{row}"><el-tag :type="row.status==='RESOLVED'?'success':row.status==='PROCESSING'?'warning':''">{{{PENDING:'待处理',ASSIGNED:'已分配',PROCESSING:'处理中',RESOLVED:'已解决',CLOSED:'已关闭'}[row.status]}}</el-tag></template></el-table-column><el-table-column label="操作" width="200"><template #default="{row}"><el-button v-if="row.status==='PENDING'" size="small" type="primary" @click="assignTicket(row)">分配</el-button><el-button v-if="row.status==='PROCESSING'" size="small" type="success" @click="resolveTicket(row)">解决</el-button></template></el-table-column></el-table></el-card></div>
</template><script setup>
import { ref,onMounted } from 'vue';import api from '../../api';import { ElMessage,ElMessageBox } from 'element-plus'
const tableData=ref([]),loading=ref(false)
async function fetchData(){loading.value=true;const r=await api.get('/api/client/chat/tickets/pending');tableData.value=r.data.data;loading.value=false}
async function assignTicket(row){const r=await ElMessageBox.prompt('输入客服人员ID','分配工单');await api.put(`/api/client/chat/tickets/${row.id}/assign`,{assigneeId:parseInt(r.value)});ElMessage.success('已分配');fetchData()}
async function resolveTicket(row){const r=await ElMessageBox.prompt('输入解决方案','解决工单');await api.put(`/api/client/chat/tickets/${row.id}/resolve`,{resolution:r.value});ElMessage.success('已解决');fetchData()}
onMounted(fetchData)
</script>
