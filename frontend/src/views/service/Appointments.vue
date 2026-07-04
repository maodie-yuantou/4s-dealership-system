<template>
  <div>
    <el-card><template #header><span>售后预约管理</span></template>
      <el-table :data="tableData" border stripe v-loading="loading">
        <el-table-column prop="customerName" label="客户" /><el-table-column prop="phone" label="手机号" />
        <el-table-column prop="vehicleInfo" label="车辆信息" /><el-table-column prop="serviceType" label="服务类型"><template #default="{row}">{{{MAINTENANCE:'保养',REPAIR:'维修',BODY_WORK:'钣喷',OTHER:'其他'}[row.serviceType]}}</template></el-table-column>
        <el-table-column prop="appointmentTime" label="预约时间" width="160" />
        <el-table-column prop="status" label="状态"><template #default="{row}"><el-tag :type="row.status==='CONFIRMED'?'success':row.status==='ARRIVED'?'warning':'info'">{{{PENDING:'待确认',CONFIRMED:'已确认',ARRIVED:'已到店',CANCELLED:'已取消'}[row.status]}}</el-tag></template></el-table-column>
      </el-table>
      <div style="margin-top:16px;text-align:right"><el-pagination v-model:current-page="page" :page-size="size" :total="total" layout="total,prev,pager,next" @current-change="fetchData"/></div>
    </el-card>
  </div>
</template><script setup>
import { ref,onMounted } from 'vue';import api from '../../api'
const tableData=ref([]),loading=ref(false),page=ref(1),size=ref(10),total=ref(0)
async function fetchData(){loading.value=true;const r=await api.get('/api/service/appointments',{params:{page:page.value,size:size.value}});tableData.value=r.data.data.records;total.value=r.data.data.total;loading.value=false}
onMounted(fetchData)
</script>
