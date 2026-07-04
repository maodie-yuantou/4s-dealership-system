<template>
  <div>
    <el-card><template #header><div style="display:flex;justify-content:space-between"><span>配件库存</span><el-button type="primary" size="small" @click="openDialog()">新增配件</el-button></div></template>
      <el-table :data="tableData" border stripe v-loading="loading">
        <el-table-column prop="accessoryCode" label="编码"/><el-table-column prop="accessoryName" label="名称"/>
        <el-table-column prop="category" label="分类"/><el-table-column prop="price" label="单价"/>
        <el-table-column prop="quantity" label="库存"/><el-table-column prop="alertQuantity" label="预警数"/>
        <el-table-column label="操作" width="150"><template #default="{row}"><el-button size="small" @click="openDialog(row)">编辑</el-button></template></el-table-column>
      </el-table>
      <div style="margin-top:16px;text-align:right"><el-pagination v-model:current-page="page" :page-size="size" :total="total" layout="total,prev,pager,next" @current-change="fetchData"/></div>
    </el-card>
    <el-dialog :title="form.id?'编辑配件':'新增配件'" v-model="dialogVisible" width="400px" @close="form={}">
      <el-form :model="form" label-width="80px"><el-form-item label="编码"><el-input v-model="form.accessoryCode"/></el-form-item><el-form-item label="名称"><el-input v-model="form.accessoryName"/></el-form-item><el-form-item label="分类"><el-input v-model="form.category"/></el-form-item><el-form-item label="单价"><el-input-number v-model="form.price" :min="0" style="width:100%"/></el-form-item><el-form-item label="库存"><el-input-number v-model="form.quantity" :min="0" style="width:100%"/></el-form-item></el-form>
      <template #footer><el-button @click="dialogVisible=false">取消</el-button><el-button type="primary" @click="saveForm">保存</el-button></template>
    </el-dialog>
  </div>
</template><script setup>
import { ref,onMounted } from 'vue';import api from '../../api';import { ElMessage } from 'element-plus'
const tableData=ref([]),loading=ref(false),page=ref(1),size=ref(10),total=ref(0),dialogVisible=ref(false),form=ref({})
async function fetchData(){loading.value=true;const r=await api.get('/api/stock/accessories',{params:{page:page.value,size:size.value}});tableData.value=r.data.data.records;total.value=r.data.data.total;loading.value=false}
function openDialog(row){form.value=row?{...row}:{};dialogVisible.value=true}
async function saveForm(){await api.post('/api/stock/accessories',form.value);ElMessage.success('OK');dialogVisible.value=false;fetchData()}
onMounted(fetchData)
</script>
