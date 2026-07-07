<template>
  <div style="display:flex;flex-direction:column;height:100vh;background:#f5f5f5">
    <div style="background:#000;color:#fff;padding:16px;display:flex;align-items:center;gap:12px">
      <span style="font-size:20px" @click="$router.back()">←</span>
      <div><div style="font-weight:bold">在线咨询</div><div style="font-size:11px;opacity:0.7">AI客服 · 秒回您的购车问题</div></div>
    </div>
    <!-- 未登录提示 -->
    <div v-if="!loggedIn" style="flex:1;display:flex;flex-direction:column;align-items:center;justify-content:center;padding:40px">
      <div style="font-size:60px;margin-bottom:20px">🔒</div>
      <div style="font-size:16px;color:#666;margin-bottom:24px">请先登录后再使用在线客服</div>
      <van-button type="primary" round block style="width:200px" @click="$router.push('/login')">去登录</van-button>
    </div>
    <template v-else>
    <div style="flex:1;overflow-y:auto;padding:12px" ref="chatBody">
      <div v-for="(m,i) in messages" :key="i" style="margin-bottom:12px">
        <div v-if="m.role==='AI'" style="display:flex;justify-content:flex-start"><div style="background:#fff;padding:10px 14px;border-radius:12px 12px 12px 4px;max-width:80%;font-size:14px;white-space:pre-wrap;box-shadow:0 1px 2px rgba(0,0,0,0.05)">{{ m.content }}</div></div>
        <div v-else style="display:flex;justify-content:flex-end"><div style="background:#1989fa;color:#fff;padding:10px 14px;border-radius:12px 12px 4px 12px;max-width:80%;font-size:14px">{{ m.content }}</div></div>
      </div>
      <van-loading v-if="waiting" size="20px" style="margin:8px auto;display:block" />
    </div>
    <div v-if="showEmoji" style="background:#fff;border-top:1px solid #eee;padding:8px;max-height:180px;overflow-y:auto;display:flex;flex-wrap:wrap;gap:2px">
      <span v-for="e in emojis" :key="e" style="font-size:22px;cursor:pointer;width:30px;text-align:center;line-height:30px" @click="input+=e;showEmoji=false">{{ e }}</span>
    </div>
    <div style="display:flex;padding:10px;background:#fff;gap:8px;align-items:center;border-top:1px solid #eee">
      <span style="font-size:22px;cursor:pointer;flex-shrink:0" @click="showEmoji=!showEmoji">😊</span>
      <van-button size="small" plain type="warning" style="flex-shrink:0" @click="transfer">转人工</van-button>
      <van-field v-model="input" placeholder="输入您的问题..." style="flex:1;background:#f5f5f5;border-radius:20px;padding:4px 12px" @keyup.enter="send" />
      <van-button size="small" type="primary" round @click="send">发送</van-button>
    </div>
    </template>
  </div>
</template>
<script setup>
import { ref, computed, nextTick } from 'vue'; import api from '../api'; import { showToast } from 'vant'
const loggedIn = computed(() => !!localStorage.getItem('token'))
const sessionId = 'sess_' + Date.now()
const messages = ref([{ role:'AI', content:'您好！我是润达4S店智能客服小润 😊✨ 我可以帮您：\n🚗 查询车型和价格\n📝 解答购车疑问\n📅 预约试驾\n💰 计算金融方案\n\n请问有什么可以帮您的？' }])
const input = ref(''); const waiting = ref(false); const showEmoji = ref(false); const chatBody = ref(null)
const emojis = ['😀','😃','😄','😁','😆','😅','🤣','😂','🙂','😊','😇','🥰','😍','🤩','😘','😗','😚','😋','😛','😜','🤪','😝','🤑','🤗','🤭','🤫','🤔','🤐','🤨','😐','😑','😶','😏','😒','🙄','😬','🤥','😌','😔','😪','🤤','😴','😷','🤒','🤕','🤢','🤮','🥴','😵','🤯','🤠','🥳','😎','🤓','🧐','😕','😟','🙁','😮','😯','😲','😳','🥺','😦','😧','😨','😰','😥','😢','😭','😱','😖','😣','😞','😓','😩','😫','🥱','😤','😡','😠','🤬','💀','☠','💩','🤡','👻','👽','🤖','🎃','😺','😸','😹','😻','😼','😽','🙀','😿','😾','❤','🧡','💛','💚','💙','💜','🤎','🖤','🤍','💯','💢','💥','💫','💦','💨','🕳','👋','🤚','✋','🖐','👌','🤏','✌','🤞','🤟','🤘','🤙','👈','👉','👆','👇','☝','👍','👎','✊','👊','🤛','🤜','🙏']
function scrollToBottom() { nextTick(() => { if (chatBody.value) chatBody.value.scrollTop = chatBody.value.scrollHeight }) }
async function send() { if (!input.value.trim()) return; const msg = input.value; input.value = ''; showEmoji.value = false; messages.value.push({ role:'USER', content:msg }); waiting.value = true; scrollToBottom(); try { const r = await api.post('/api/client/chat', { sessionId, customerId: localStorage.getItem('cid')||1, message: msg }); messages.value.push({ role:'AI', content: r.data.data.reply }); if (r.data.data.transferToHuman) showToast('已转人工，工单:' + r.data.data.ticketNo) } catch(e) { messages.value.push({ role:'AI', content:'系统繁忙，请稍后再试' }) } finally { waiting.value = false; scrollToBottom() } }
async function transfer() { await api.post('/api/client/chat/transfer', { customerId: localStorage.getItem('cid')||1, question: '客户请求转人工' }); showToast('已转人工，请保持电话畅通') }
</script>