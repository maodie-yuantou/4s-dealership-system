<template>
  <div><el-card><template #header><div style="display:flex;justify-content:space-between"><span>角色管理</span><el-button type="primary" size="small" @click="openDialog()">新增角色</el-button></div></template>
      <el-table :data="tableData" border stripe><el-table-column prop="roleName" label="角色名称"/><el-table-column prop="roleCode" label="角色编码"/><el-table-column prop="description" label="描述"/><el-table-column label="操作" width="200"><template #default="{row}"><el-button size="small" @click="openDialog(row)">编辑</el-button><el-button size="small" type="danger" @click="del(row.id)">删除</el-button></template></el-table-column></el-table></el-card>
    <el-dialog :title="form.id?'编辑角色':'新增角色'" v-model="dialogVisible" width="400px" @close="form={}"><el-form :model="form" label-width="80px"><el-form-item label="名称"><el-input v-model="form.roleName"/></el-form-item><el-form-item label="编码"><el-input v-model="form.roleCode"/></el-form-item><el-form-item label="描述"><el-input v-model="form.description"/></el-form-item></el-form><template #footer><el-button @click="dialogVisible=false">取消</el-button><el-button type="primary" @click="saveForm">保存</el-button></template></el-dialog></div>
</template><script setup>
import { ref,onMounted } from 'vue';import api from '../../api';import { ElMessage } from 'element-plus'
const tableData=ref([]),dialogVisible=ref(false),form=ref({})
async function fetch(){const r=await api.get('/api/system/roles/all');tableData.value=r.data.data}
function openDialog(row){form.value=row?{...row}:{};dialogVisible.value=true}
async function saveForm(){await api.post('/api/system/roles',form.value);ElMessage.success('OK');dialogVisible.value=false;fetch()}
async function del(id){await api.delete(`/api/system/roles/${id}`);ElMessage.success('已删除');fetch()}
onMounted(fetch)
</script>
