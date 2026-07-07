<template>
  <div style="min-height:100vh;background:#f5f5f5;display:flex;flex-direction:column">
    <div style="background:#fff;padding:14px 16px;display:flex;align-items:center">
      <span style="font-size:18px;cursor:pointer;width:30px" @click="$router.back()">←</span>
      <span style="flex:1;text-align:center;font-size:17px;font-weight:600">登录</span>
    </div>
    <div style="flex:1;padding:24px">
      <div style="background:#fff;border-radius:12px;overflow:hidden">
        <van-tabs v-model:active="tab" color="#ff5000" style="padding:0 16px">
          <van-tab title="账号密码">
            <div style="padding:20px 0">
              <van-field v-model="username" placeholder="用户名" />
              <van-field v-model="password" type="password" placeholder="密码" />
              <div style="text-align:right;padding:8px 16px 0"><span style="color:#ff5000;font-size:13px;cursor:pointer" @click="$router.push('/reset-password')">忘记密码？</span></div>
              <div style="padding:0 16px;margin-top:20px"><van-button block size="large" round style="background:#ff5000;border:none;color:#fff;font-weight:600;height:44px" @click="passwordLogin" :loading="loading">登录</van-button></div>
            </div>
          </van-tab>
          <van-tab title="手机登录">
            <div style="padding:20px 0">
              <van-field v-model="phone" placeholder="手机号" type="tel" maxlength="11" />
              <van-field v-model="smsCode" placeholder="验证码" type="digit" maxlength="6">
                <template #button><van-button size="small" plain color="#ff5000" :disabled="countdown>0" @click="sendSms">{{ countdown>0?countdown+'s':'获取验证码' }}</van-button></template>
              </van-field>
              <div style="padding:0 16px;margin-top:20px"><van-button block size="large" round style="background:#ff5000;border:none;color:#fff;font-weight:600;height:44px" @click="phoneLogin" :loading="loading">登录</van-button></div>
            </div>
          </van-tab>
        </van-tabs>
      </div>
      <div style="text-align:center;margin-top:24px;font-size:14px;color:#999">
        还没有账号？<span style="color:#ff5000;font-weight:600;cursor:pointer" @click="$router.push('/register')">立即注册</span>
      </div>
    </div>
  </div>
</template>
<script setup>
import { ref } from 'vue'; import { useRouter } from 'vue-router'; import { useUserStore } from '../stores/user'; import { showToast } from 'vant'; import api from '../api'
const router = useRouter(); const user = useUserStore(); const tab = ref(1); const phone = ref(''); const smsCode = ref(''); const username = ref(''); const password = ref(''); const loading = ref(false); const countdown = ref(0)
async function sendSms(){if(phone.value.length<11){showToast('请输入正确手机号');return};try{const r=await api.post('/api/client/check-phone',{phone:phone.value});if(r.data.data!=='ok'){showToast('该用户不存在');return}}catch(e){showToast('该用户不存在');return};countdown.value=60;const t=setInterval(()=>{countdown.value--;if(countdown.value<=0)clearInterval(t)},1000);showToast('验证码已发送(模拟:123456)')}
async function phoneLogin(){
  if(!phone.value||!smsCode.value){showToast('请输入手机号和验证码');return}
  loading.value=true
  try{
    const r=await api.post('/api/client/login',{phone:phone.value})
    const d=r.data.data
    localStorage.setItem('cid',d.customerId);localStorage.setItem('cname',d.name);localStorage.setItem('cphone',phone.value)
    if(d.token)localStorage.setItem('token',d.token)
    showToast('登录成功');router.push('/')
  }catch(e){showToast(e.response?.data?.message||'登录失败')}finally{loading.value=false}
}
async function passwordLogin(){
  if(!username.value||!password.value){showToast('请输入用户名和密码');return};loading.value=true
  try{const r=await api.post('/api/auth/login',{username:username.value,password:password.value});const d=r.data.data;localStorage.setItem('token',d.token);localStorage.setItem('cid',d.userId);localStorage.setItem('cname',d.realName||d.username);localStorage.setItem('cphone',d.phone||'');showToast('登录成功');router.push('/')}catch(e){showToast(e.response?.data?.message||'登录失败')}finally{loading.value=false}
}
</script>
