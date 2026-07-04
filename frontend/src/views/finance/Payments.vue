<template>
  <div>
    <el-card><template #header><div style="display:flex;justify-content:space-between"><span>收款管理</span><el-button type="primary" size="small" @click="openDialog()">新增收款</el-button></div></template>
      <el-table :data="tableData" border stripe v-loading="loading">
        <el-table-column prop="paymentNo" label="收款编号" width="150"/><el-table-column prop="payerName" label="付款人"/>
        <el-table-column prop="amount" label="金额"/><el-table-column prop="paymentMethod" label="方式"><template #default="{row}">{{{CASH:'现金',BANK_CARD:'银行卡',WECHAT:'微信',ALIPAY:'支付宝',TRANSFER:'转账'}[row.paymentMethod]}}</template></el-table-column>
        <el-table-column prop="paymentType" label="类型"><template #default="{row}">{{{SALE_DEPOSIT:'销售定金',SALE_BALANCE:'购车尾款',SERVICE:'维修款',INSURANCE:'续保费',OTHER:'其他'}[row.paymentType]}}</template></el-table-column>
        <el-table-column prop="paidAt" label="收款时间" width="160"/>
      </el-table>
      <div style="margin-top:16px;text-align:right"><el-pagination v-model:current-page="page" :page-size="size" :total="total" layout="total,prev,pager,next" @current-change="fetchData"/></div>
    </el-card>
    <el-dialog :title="form.id?'编辑收款':'新增收款'" v-model="dialogVisible" width="400px" @close="form={}">
      <el-form :model="form" label-width="80px"><el-form-item label="付款人"><el-input v-model="form.payerName"/></el-form-item><el-form-item label="金额"><el-input-number v-model="form.amount" :min="0" :step="100" style="width:100%"/></el-form-item><el-form-item label="方式"><el-select v-model="form.paymentMethod"><el-option label="现金" value="CASH"/><el-option label="银行卡" value="BANK_CARD"/><el-option label="微信" value="WECHAT"/><el-option label="支付宝" value="ALIPAY"/></el-select></el-form-item><el-form-item label="类型"><el-select v-model="form.paymentType"><el-option label="销售定金" value="SALE_DEPOSIT"/><el-option label="购车尾款" value="SALE_BALANCE"/><el-option label="维修款" value="SERVICE"/></el-select></el-form-item></el-form>
      <template #footer><el-button @click="dialogVisible=false">取消</el-button><el-button type="primary" @click="saveForm">保存</el-button></template>
    </el-dialog>
  </div>
</template><script setup>
import { ref,onMounted } from 'vue';import api from '../../api';import { ElMessage } from 'element-plus'
const tableData=ref([]),loading=ref(false),page=ref(1),size=ref(10),total=ref(0),dialogVisible=ref(false),form=ref({})
async function fetchData(){loading.value=true;const r=await api.get('/api/finance/payments',{params:{page:page.value,size:size.value}});tableData.value=r.data.data.records;total.value=r.data.data.total;loading.value=false}
function openDialog(row){form.value=row?{...row}:{};dialogVisible.value=true}
async function saveForm(){if(form.value.id)await api.put(`/api/finance/payments/${form.value.id}`,form.value);else await api.post('/api/finance/payments',form.value);ElMessage.success('OK');dialogVisible.value=false;fetchData()}
onMounted(fetchData)
</script>
