<template>
  <div style="background:#f5f5f5;min-height:100vh;padding-bottom:60px">
    <div style="background:linear-gradient(180deg,#ff5000,#ff6a20);padding:30px 20px 24px;cursor:pointer" @click="goProfile">
      <div style="display:flex;align-items:center;gap:12px">
        <img :src="avatarSrc" style="width:60px;height:60px;border-radius:50%;object-fit:cover;border:2px solid rgba(255,255,255,0.4)" />
        <div>
          <div style="font-size:18px;font-weight:600;color:#fff">{{ displayName || '点击登录' }}</div>
          <div style="font-size:12px;color:rgba(255,255,255,0.7);margin-top:4px">{{ displayPhone || '登录后享受更多服务' }}</div>
        </div>
        <span style="margin-left:auto;color:rgba(255,255,255,0.7);font-size:14px">设置 →</span>
      </div>
    </div>

    <div style="margin:12px;background:#fff;border-radius:12px;display:flex;text-align:center;padding:16px 0">
      <div style="flex:1"><div style="font-size:20px;font-weight:700;color:#ff5000">0</div><div style="font-size:11px;color:#999;margin-top:4px">订单</div></div>
      <div style="flex:1"><div style="font-size:20px;font-weight:700;color:#ff5000">0</div><div style="font-size:11px;color:#999;margin-top:4px">收藏</div></div>
      <div style="flex:1"><div style="font-size:20px;font-weight:700;color:#ff5000">0</div><div style="font-size:11px;color:#999;margin-top:4px">卡券</div></div>
      <div style="flex:1"><div style="font-size:20px;font-weight:700;color:#ff5000">0</div><div style="font-size:11px;color:#999;margin-top:4px">积分</div></div>
    </div>

    <div style="margin:0 12px 12px;background:#fff;border-radius:12px;overflow:hidden">
      <van-cell title="我的订单" icon="orders-o" is-link @click="$router.push('/orders')" />
      <van-cell title="预约记录" icon="calendar-o" is-link @click="$router.push('/appointments')" />
      <van-cell title="我的卡券" icon="coupon-o" is-link @click="$router.push('/coupons')" />
      <van-cell title="积分会员" icon="gold-coin-o" is-link @click="$router.push('/points')" />
    </div>
    <div style="margin:0 12px 12px;background:#fff;border-radius:12px;overflow:hidden">
      <van-cell title="在线客服" icon="chat-o" is-link @click="$router.push('/chat')" />
      <van-cell title="关于我们" icon="info-o" is-link @click="$router.push('/about')" />
    </div>
    <div style="margin:20px 12px" v-if="displayName">
      <van-button block round style="background:#fff;color:#999;font-size:14px" @click="handleLogout">退出登录</van-button>
    </div>
  </div>
</template>
<script setup>
import { ref, computed, onMounted } from 'vue'; import { useRouter } from 'vue-router'; import { useUserStore } from '../stores/user'; import api from '../api'
const router = useRouter(); const user = useUserStore(); const profile = ref({})
const displayName = computed(() => profile.value.realName || user.name || localStorage.getItem('cname') || '')
const displayPhone = computed(() => profile.value.phone || user.phone || localStorage.getItem('cphone') || '')
const avatarSrc = computed(() => profile.value.avatar || 'https://picsum.photos/100')
onMounted(async () => { try { const r = await api.get('/api/auth/me'); profile.value = r.data.data||{} } catch(e){} })
function goProfile() { if (localStorage.getItem('token')) router.push('/profile'); else router.push('/login') }
function handleLogout() { localStorage.clear(); user.logout(); router.push('/') }
</script>
