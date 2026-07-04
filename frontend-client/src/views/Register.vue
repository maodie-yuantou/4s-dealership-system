<template>
  <div style="min-height:100vh;background:#0a0a0a;display:flex;flex-direction:column">
    <div style="padding:14px 16px;display:flex;align-items:center;gap:12px;color:#fff">
      <span style="font-size:20px;cursor:pointer" @click="$router.back()">←</span>
      <span style="font-size:17px;font-weight:300;letter-spacing:2px">创建账号</span>
    </div>
    <div style="flex:1;padding:24px 20px">
      <div style="text-align:center;margin-bottom:30px">
        <div style="font-size:15px;color:#c9a96e;letter-spacing:3px;font-weight:600">RUNDA</div>
        <div style="font-size:12px;color:rgba(255,255,255,0.3);margin-top:8px">注册润达会员，畅享尊崇服务</div>
      </div>
      <van-field v-model="form.username" placeholder="用户名" maxlength="20" style="background:rgba(255,255,255,0.05);border-radius:8px;margin-bottom:10px;color:#fff" />
      <van-field v-model="form.password" type="password" placeholder="密码（不少于6位）" style="background:rgba(255,255,255,0.05);border-radius:8px;margin-bottom:10px;color:#fff" />
      <van-field v-model="form.rePassword" type="password" placeholder="确认密码" style="background:rgba(255,255,255,0.05);border-radius:8px;margin-bottom:10px;color:#fff" />
      <van-field v-model="form.realName" placeholder="真实姓名" maxlength="20" style="background:rgba(255,255,255,0.05);border-radius:8px;margin-bottom:10px;color:#fff" />
      <van-field v-model="form.phone" type="tel" placeholder="手机号" maxlength="11" style="background:rgba(255,255,255,0.05);border-radius:8px;margin-bottom:10px;color:#fff" />
      <van-button block size="large" round style="margin-top:30px;background:linear-gradient(135deg,#c9a96e,#b8943a);border:none;color:#fff;font-weight:600;font-size:16px;height:48px" @click="handleRegister" :loading="loading">注 册</van-button>
      <div style="text-align:center;margin-top:20px;font-size:13px;color:rgba(255,255,255,0.5)">
        已有账号？<span style="color:#c9a96e;cursor:pointer;font-weight:500" @click="$router.push('/login')">立即登录</span>
      </div>
    </div>
  </div>
</template>
<script setup>
import { ref, reactive } from 'vue'; import { useRouter } from 'vue-router'; import api from '../api'; import { showToast, showSuccessToast } from 'vant'
const router = useRouter(); const form = reactive({ username:'', password:'', rePassword:'', realName:'', phone:'' }); const loading = ref(false)
async function handleRegister() {
  if (!form.username || !form.password) { showToast('请输入用户名和密码'); return }
  if (form.password !== form.rePassword) { showToast('两次密码不一致'); return }
  if (form.password.length < 6) { showToast('密码不能少于6位'); return }
  loading.value = true
  try { await api.post('/api/auth/register', form); showSuccessToast('注册成功'); router.push('/login') } catch(e) { showToast(e.response?.data?.message || '注册失败') } finally { loading.value = false }
}
</script>
