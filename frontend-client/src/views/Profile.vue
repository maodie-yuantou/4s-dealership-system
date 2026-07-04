<template>
  <div style="background:#f5f5f5;min-height:100vh;padding-bottom:30px">
    <div style="background:#fff;padding:14px 16px;display:flex;align-items:center;border-bottom:1px solid #eee">
      <span style="font-size:18px;cursor:pointer;width:30px" @click="$router.push('/mine')">←</span>
      <span style="flex:1;text-align:center;font-size:17px;font-weight:600">个人资料</span>
    </div>
    <div style="text-align:center;padding:30px 20px;background:#fff;margin-bottom:12px">
      <label style="cursor:pointer;display:inline-block;position:relative">
        <input type="file" accept="image/*" style="display:none" @change="onFileChange" />
        <img :src="avatarSrc" style="width:76px;height:76px;border-radius:50%;object-fit:cover;display:block;border:2px solid #eee" />
        <div style="position:absolute;bottom:0;right:0;width:22px;height:22px;background:#ff5000;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:12px;color:#fff;border:2px solid #fff">+</div>
      </label>
      <div style="margin-top:8px;font-size:12px;color:#999">点击更换头像</div>
    </div>
    <div style="background:#fff;margin-bottom:12px">
      <van-cell title="用户名" :value="profile.username||''" />
      <van-field v-model="form.realName" label="姓名" placeholder="请输入姓名" />
      <van-field v-model="form.phone" label="手机号" placeholder="请输入手机号" type="tel" />
      <van-field v-model="form.email" label="邮箱" placeholder="请输入邮箱" type="email" />
    </div>
    <div style="padding:0 16px"><van-button block round style="background:#ff5000;border:none;color:#fff;font-weight:600;height:44px" :loading="saving" @click="saveProfile">保存资料</van-button></div>
    <div style="background:#fff;margin:16px 0 12px">
      <div style="padding:14px 16px;font-size:15px;font-weight:600;border-bottom:1px solid #f5f5f5">修改密码</div>
      <van-field v-model="pwd.oldPassword" type="password" label="原密码" placeholder="请输入原密码" />
      <van-field v-model="pwd.newPassword" type="password" label="新密码" placeholder="不少于6位" />
      <van-field v-model="pwd.confirmPassword" type="password" label="确认密码" placeholder="再次输入新密码" />
    </div>
    <div style="padding:0 16px"><van-button block round style="background:#fff;border:1px solid #ff5000;color:#ff5000;font-weight:500;height:44px" :loading="changingPwd" @click="changePassword">修改密码</van-button></div>
  </div>
</template>
<script setup>
import { ref, reactive, computed, onMounted } from 'vue'; import api from '../api'; import { showToast, showSuccessToast } from 'vant'
const profile = ref({}); const saving = ref(false); const changingPwd = ref(false)
const form = reactive({ realName:'', phone:'', email:'' })
const pwd = reactive({ oldPassword:'', newPassword:'', confirmPassword:'' })
const avatarTs = ref(Date.now())
const avatarSrc = computed(() => {
  const a = profile.value.avatar
  if (!a) return 'https://picsum.photos/100'
  if (a.startsWith('http')) return a + '?t=' + avatarTs.value
  return 'http://localhost:8080' + a + '?t=' + avatarTs.value
})
async function loadProfile() {
  try { const r = await api.get('/api/auth/me'); const u = r.data.data||{}; profile.value = u; form.realName = u.realName||''; form.phone = u.phone||''; form.email = u.email||'' } catch(e){ showToast('获取用户信息失败，请重新登录') }
}
async function onFileChange(e) {
  const file = e.target.files[0]; if (!file) return
  const fd = new FormData(); fd.append('file', file)
  try { const r = await api.post('/api/auth/avatar', fd); profile.value.avatar = r.data.data; avatarTs.value = Date.now(); showSuccessToast('头像更新成功') } catch(e) { showToast(e.response?.data?.message || '上传失败，请重新登录') }
}
async function saveProfile() {
  saving.value = true
  try { const r = await api.put('/api/auth/profile', { realName: form.realName, phone: form.phone, email: form.email }); Object.assign(profile.value, r.data.data); showSuccessToast('保存成功') } catch(e) { showToast(e.response?.data?.message || '保存失败，请重新登录') } finally { saving.value = false }
}
async function changePassword() {
  if (!pwd.oldPassword||!pwd.newPassword) { showToast('请填写完整'); return }
  if (pwd.newPassword!==pwd.confirmPassword) { showToast('两次密码不一致'); return }
  if (pwd.newPassword.length<6) { showToast('新密码不能少于6位'); return }
  changingPwd.value = true
  try { await api.post('/api/auth/change-password', { oldPassword:pwd.oldPassword, newPassword:pwd.newPassword }); showSuccessToast('密码修改成功'); Object.assign(pwd,{oldPassword:'',newPassword:'',confirmPassword:''}) } catch(e) { showToast(e.response?.data?.message||'修改失败') } finally { changingPwd.value = false }
}
onMounted(loadProfile)
</script>
