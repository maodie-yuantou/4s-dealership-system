<template>
  <div style="min-height:100vh;background:#0a0a0a;display:flex;flex-direction:column">
    <div style="padding:14px 16px;display:flex;align-items:center;gap:12px;color:#fff">
      <span style="font-size:20px;cursor:pointer" @click="$router.back()">←</span>
      <span style="font-size:17px;font-weight:300;letter-spacing:2px">找回密码</span>
    </div>
    <div style="flex:1;padding:24px 20px">
      <!-- 步骤1 -->
      <div v-if="step===1">
        <div style="text-align:center;margin-bottom:30px">
          <div style="font-size:40px;margin-bottom:12px">🔑</div>
          <div style="font-size:14px;color:rgba(255,255,255,0.6)">验证身份以重置密码</div>
        </div>
        <van-field v-model="form.username" placeholder="用户名" style="background:rgba(255,255,255,0.05);border-radius:8px;margin-bottom:10px;color:#fff" />
        <van-field v-model="form.realName" placeholder="注册时的真实姓名" style="background:rgba(255,255,255,0.05);border-radius:8px;color:#fff" />
        <van-button block size="large" round style="margin-top:28px;background:linear-gradient(135deg,#c9a96e,#b8943a);border:none;color:#fff;font-weight:600;height:48px" @click="verify" :loading="loading">验证身份</van-button>
      </div>
      <!-- 步骤2 -->
      <div v-else-if="step===2">
        <div style="text-align:center;margin-bottom:30px">
          <div style="font-size:40px;margin-bottom:12px">✅</div>
          <div style="font-size:14px;color:#c9a96e;font-weight:500">验证通过</div>
          <div style="font-size:12px;color:rgba(255,255,255,0.4);margin-top:6px">请设置新密码</div>
        </div>
        <van-field v-model="form.newPassword" type="password" placeholder="新密码（不少于6位）" style="background:rgba(255,255,255,0.05);border-radius:8px;margin-bottom:10px;color:#fff" />
        <van-field v-model="form.confirmPassword" type="password" placeholder="确认新密码" style="background:rgba(255,255,255,0.05);border-radius:8px;color:#fff" />
        <van-button block size="large" round style="margin-top:28px;background:linear-gradient(135deg,#c9a96e,#b8943a);border:none;color:#fff;font-weight:600;height:48px" @click="resetPass" :loading="loading">重置密码</van-button>
        <div style="text-align:center;margin-top:16px"><span style="color:rgba(255,255,255,0.4);font-size:13px;cursor:pointer" @click="step=1">← 返回上一步</span></div>
      </div>
      <!-- 成功 -->
      <div v-else style="text-align:center;padding-top:60px">
        <div style="font-size:56px;margin-bottom:16px">🎉</div>
        <div style="font-size:18px;font-weight:600;color:#c9a96e;margin-bottom:8px">密码重置成功</div>
        <div style="font-size:13px;color:rgba(255,255,255,0.4);margin-bottom:30px">请使用新密码重新登录</div>
        <van-button block size="large" round style="background:linear-gradient(135deg,#c9a96e,#b8943a);border:none;color:#fff;font-weight:600;height:48px" @click="$router.push('/login')">返回登录</van-button>
      </div>
    </div>
  </div>
</template>
<script setup>
import { ref, reactive } from 'vue'; import api from '../api'; import { showToast } from 'vant'
const step = ref(1); const loading = ref(false)
const form = reactive({ username:'', realName:'', newPassword:'', confirmPassword:'' })
async function verify() {
  if (!form.username || !form.realName) { showToast('请填写用户名和真实姓名'); return }
  loading.value = true
  try { await api.post('/api/auth/verify-identity', { username:form.username, realName:form.realName }); step.value=2 } catch(e) { showToast(e.response?.data?.message||'验证失败') } finally { loading.value=false }
}
async function resetPass() {
  if (!form.newPassword||form.newPassword.length<6) { showToast('密码不能少于6位'); return }
  if (form.newPassword!==form.confirmPassword) { showToast('两次密码不一致'); return }
  loading.value = true
  try { await api.post('/api/auth/reset-password', { username:form.username, realName:form.realName, newPassword:form.newPassword }); step.value=3 } catch(e) { showToast(e.response?.data?.message||'重置失败') } finally { loading.value=false }
}
</script>
