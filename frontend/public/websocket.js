// WebSocket 客户端工具
// 客户端页面使用时: import { connectWebSocket } from '../utils/websocket.js'
// 在 App.vue onMounted 中调用 connectWebSocket(customerId);

export function connectWebSocket(customerId) {
  if (!customerId || customerId === '0') return

  const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:'
  const host = window.location.host
  const wsUrl = `${protocol}//${host}/ws`

  // 使用 SockJS + STOMP 或者原生 WebSocket
  // 这里使用简单原生 WebSocket + STOMP-like JSON 协议
  const socket = new WebSocket(wsUrl)

  socket.onopen = () => {
    console.log('WebSocket connected')
    // 订阅用户通知
    const subMsg = JSON.stringify({
      type: 'SUBSCRIBE',
      destination: `/user/${customerId}/queue/notifications`
    })
    socket.send(subMsg)
  }

  socket.onmessage = (event) => {
    try {
      const data = JSON.parse(event.data)
      if (data.content) {
        // 使用 Vant Notify 弹出通知
        if (window.vantNotify) {
          window.vantNotify({ type: 'primary', message: data.content, duration: 3000 })
        }
      }
    } catch (e) {
      // ignore
    }
  }

  socket.onclose = () => {
    console.log('WebSocket disconnected, reconnecting in 5s...')
    setTimeout(() => connectWebSocket(customerId), 5000)
  }

  socket.onerror = (e) => {
    console.log('WebSocket error, will retry')
  }

  return socket
}
