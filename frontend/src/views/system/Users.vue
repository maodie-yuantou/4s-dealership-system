<template>
  <div>
    <el-card>
      <template #header><div style="display:flex;justify-content:space-between;align-items:center"><span>用户管理</span><el-button type="primary" size="small" @click="openDialog()">新增用户</el-button></div></template>
      <el-table :data="tableData" border stripe v-loading="loading">
        <el-table-column prop="id" label="ID" width="60"/><el-table-column prop="username" label="用户名"/><el-table-column prop="realName" label="姓名"/><el-table-column prop="phone" label="手机号"/><el-table-column prop="email" label="邮箱"/><el-table-column prop="deptName" label="部门"/>
        <el-table-column label="状态" width="80"><template #default="{row}"><el-tag :type="row.status===1?'success':'danger'">{{row.status===1?'启用':'禁用'}}</el-tag></template></el-table-column>
        <el-table-column label="操作" width="200" fixed="right"><template #default="{row}"><el-button size="small" @click="openDialog(row)">编辑</el-button><el-button size="small" type="warning" @click="toggleStatus(row)">{{row.status===1?'禁用':'启用'}}</el-button></template></el-table-column>
      </el-table>
      <div style="margin-top:16px;text-align:right"><el-pagination v-model:current-page="page" :page-size="size" :total="total" layout="total,prev,pager,next" @current-change="fetchData"/></div>
    </el-card>
    <el-dialog :title="form.id?'编辑用户':'新增用户'" v-model="dialogVisible" width="500px" @close="resetForm"><el-form :model="form" label-width="80px"><el-form-item label="用户名"><el-input v-model="form.username"/></el-form-item><el-form-item label="姓名"><el-input v-model="form.realName"/></el-form-item><el-form-item label="密码"><el-input v-model="form.password" type="password" placeholder="留空则不修改"/></el-form-item><el-form-item label="手机号"><el-input v-model="form.phone"/></el-form-item><el-form-item label="邮箱"><el-input v-model="form.email"/></el-form-item></el-form><template #footer><el-button @click="dialogVisible=false">取消</el-button><el-button type="primary" @click="saveUser">保存</el-button></template></el-dialog>
  </div>
</template>
<script setup>
import { ref,onMounted } from 'vue';import api from '../../api';import { ElMessage } from 'element-plus'
const tableData=ref([]),loading=ref(false),page=ref(1),size=ref(10),total=ref(0),dialogVisible=ref(false),form=ref({})
async function fetchData(){loading.value=true;const res=await api.get('/api/system/users',{params:{page:page.value,size:size.value}});tableData.value=res.data.data.records;total.value=res.data.data.total;loading.value=false}
function openDialog(row){form.value=row?{...row}:{};dialogVisible.value=true}
function resetForm(){form.value={}}
async function saveUser(){if(form.value.id)await api.put(`/api/system/users/${form.value.id}`,form.value);else await api.post('/api/system/users',form.value);ElMessage.success('保存成功');dialogVisible.value=false;fetchData()}
async function toggleStatus(row){await api.put(`/api/system/users/${row.id}/status`,{status:row.status===1?0:1});ElMessage.success('状态已更新');fetchData()}
onMounted(fetchData)
</script>
