<template>
  <div style="display:flex;flex-direction:column;height:100vh;background:#f5f5f5">
    <div style="background:#000;color:#fff;padding:16px;display:flex;align-items:center;gap:12px">
      <span style="font-size:20px" @click="$router.back()">←</span>
      <div><div style="font-weight:bold">在线咨询</div><div style="font-size:11px;opacity:0.7">AI客服 · 秒回您的购车问题</div></div>
    </div>
    <div style="flex:1;overflow-y:auto;padding:12px">
      <div v-for="(m,i) in messages" :key="i" style="margin-bottom:12px">
        <div v-if="m.role==='AI'" style="display:flex;justify-content:flex-start"><div style="background:#fff;padding:10px 14px;border-radius:12px 12px 12px 4px;max-width:80%;font-size:14px;white-space:pre-wrap;box-shadow:0 1px 2px rgba(0,0,0,0.05)">{{ m.content }}</div></div>
        <div v-else style="display:flex;justify-content:flex-end"><div style="background:#1989fa;color:#fff;padding:10px 14px;border-radius:12px 12px 4px 12px;max-width:80%;font-size:14px">{{ m.content }}</div></div>
      </div>
      <van-loading v-if="waiting" size="20px" style="margin:8px auto;display:block" />
    </div>
    <div style="display:flex;padding:10px;background:#fff;gap:8px;align-items:center;border-top:1px solid #eee">
      <van-button size="small" plain type="warning" style="flex-shrink:0" @click="transfer">转人工</van-button>
      <van-field v-model="input" placeholder="输入您的问题..." style="flex:1;background:#f5f5f5;border-radius:20px;padding:4px 12px" @keyup.enter="send" />
      <van-button size="small" type="primary" round @click="send">发送</van-button>
    </div>
  </div>
</template>
<script setup>
import { ref } from 'vue'; import api from '../api'; import { showToast } from 'vant'; import { useUserStore } from '../stores/user'
const user = useUserStore(); const sessionId = 'sess_' + Date.now(); const messages = ref([{ role:'AI', content:'您好！我是润达4S店智能客服小润。我可以帮您：\n· 查询车型和价格\n· 解答购车疑问\n· 预约试驾\n· 计算金融方案\n\n请问有什么可以帮您的？' }]); const input = ref(''); const waiting = ref(false)
async function send() { if (!input.value.trim()) return; const msg = input.value; input.value = ''; messages.value.push({ role:'USER', content:msg }); waiting.value = true; try { const r = await api.post('/api/client/chat', { sessionId, customerId: user.customerId || 1, message: msg }); messages.value.push({ role:'AI', content: r.data.data.reply }); if (r.data.data.transferToHuman) showToast('已转人工，工单:' + r.data.data.ticketNo) } catch(e) { messages.value.push({ role:'AI', content:'系统繁忙，请稍后再试' }) } finally { waiting.value = false } }
async function transfer() { await api.post('/api/client/chat/transfer', { customerId: user.customerId || 1, question: '客户请求转人工' }); showToast('已转人工，请保持电话畅通') }
</script>
