<template>
  <div><el-card><template #header><div style="display:flex;justify-content:space-between"><span>部门管理</span><el-button type="primary" size="small" @click="openDialog()">新增部门</el-button></div></template>
      <el-table :data="tableData" border stripe row-key="id" default-expand-all><el-table-column prop="deptName" label="名称"/><el-table-column prop="deptCode" label="编码"/><el-table-column prop="leader" label="负责人"/><el-table-column prop="phone" label="电话"/><el-table-column label="操作" width="150"><template #default="{row}"><el-button size="small" @click="openDialog(row)">编辑</el-button><el-button size="small" type="danger" @click="del(row.id)">删除</el-button></template></el-table-column></el-table></el-card>
    <el-dialog :title="form.id?'编辑部门':'新增部门'" v-model="dialogVisible" width="400px" @close="form={}"><el-form :model="form" label-width="80px"><el-form-item label="名称"><el-input v-model="form.deptName"/></el-form-item><el-form-item label="编码"><el-input v-model="form.deptCode"/></el-form-item><el-form-item label="负责人"><el-input v-model="form.leader"/></el-form-item><el-form-item label="电话"><el-input v-model="form.phone"/></el-form-item></el-form><template #footer><el-button @click="dialogVisible=false">取消</el-button><el-button type="primary" @click="saveForm">保存</el-button></template></el-dialog></div>
</template><script setup>
import { ref,onMounted } from 'vue';import api from '../../api';import { ElMessage } from 'element-plus'
const tableData=ref([]),dialogVisible=ref(false),form=ref({})
async function fetch(){const r=await api.get('/api/system/depts/tree');tableData.value=r.data.data}
function openDialog(row){form.value=row?{...row}:{};dialogVisible.value=true}
async function saveForm(){await api.post('/api/system/depts',form.value);ElMessage.success('OK');dialogVisible.value=false;fetch()}
async function del(id){await api.delete(`/api/system/depts/${id}`);ElMessage.success('已删除');fetch()}
onMounted(fetch)
</script>
