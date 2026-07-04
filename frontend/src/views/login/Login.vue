<template>
  <div style="display:flex;justify-content:center;align-items:center;height:100vh;background:linear-gradient(135deg,#1f3a5f 0%,#304156 100%)">
    <el-card style="width:400px">
      <template #header>
        <h2 style="text-align:center;margin:0">润达4S店管理系统</h2>
      </template>
      <el-form @keyup.enter="handleLogin">
        <el-form-item><el-input v-model="username" placeholder="用户名" prefix-icon="User" /></el-form-item>
        <el-form-item><el-input v-model="password" type="password" placeholder="密码" prefix-icon="Lock" show-password /></el-form-item>
        <el-form-item><el-button type="primary" style="width:100%" @click="handleLogin" :loading="loading">登 录</el-button></el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../../stores/auth'
import { ElMessage } from 'element-plus'

const router = useRouter()
const auth = useAuthStore()
const username = ref('')
const password = ref('')
const loading = ref(false)

async function handleLogin() {
  loading.value = true
  try {
    await auth.login(username.value, password.value)
    ElMessage.success('登录成功')
    router.push('/dashboard')
  } catch (e) {
  } finally {
    loading.value = false
  }
}
</script>
