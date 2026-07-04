<template>
  <div style="background:#f5f5f5;min-height:100vh;padding-bottom:80px">
    <div style="background:#fff;padding:14px 16px;display:flex;align-items:center;border-bottom:1px solid #eee">
      <span style="font-size:17px;font-weight:600">购物车</span>
      <span v-if="cart.totalCount" style="margin-left:auto;font-size:13px;color:#ff5000;cursor:pointer" @click="cart.clear()">清空</span>
    </div>
    <div v-if="cart.items.length" style="padding:12px">
      <div v-for="item in cart.items" :key="item.type+item.id" style="background:#fff;border-radius:10px;padding:14px;margin-bottom:10px;display:flex;gap:12px;align-items:center">
        <img :src="item.image" style="width:80px;height:80px;border-radius:8px;object-fit:cover;background:#eee" @error="e=>e.target.src='https://picsum.photos/80'" />
        <div style="flex:1">
          <div style="font-size:14px;font-weight:600;color:#333">{{ item.name }}</div>
          <div style="font-size:12px;color:#999;margin-top:4px">{{ item.desc }}</div>
          <div style="display:flex;justify-content:space-between;align-items:center;margin-top:10px">
            <span style="color:#ff5000;font-size:16px;font-weight:700">¥{{ item.price.toLocaleString() }}</span>
            <div style="display:flex;align-items:center;gap:8px">
              <span style="width:28px;height:28px;border-radius:50%;border:1px solid #ddd;display:flex;align-items:center;justify-content:center;font-size:18px;cursor:pointer;color:#999" @click="cart.updateQty(item.id,item.type,item.quantity-1)">−</span>
              <span style="font-size:14px;font-weight:600;min-width:20px;text-align:center">{{ item.quantity }}</span>
              <span style="width:28px;height:28px;border-radius:50%;border:1px solid #ddd;display:flex;align-items:center;justify-content:center;font-size:18px;cursor:pointer;color:#999" @click="cart.updateQty(item.id,item.type,item.quantity+1)">+</span>
            </div>
          </div>
        </div>
        <span style="color:#ccc;font-size:20px;cursor:pointer" @click="cart.remove(item.id,item.type)">×</span>
      </div>
    </div>
    <div v-else style="text-align:center;padding:100px 20px;color:#ccc">
      <div style="font-size:56px;margin-bottom:12px">🛒</div>
      <div style="font-size:15px">购物车是空的</div>
      <div style="font-size:13px;margin-top:8px;color:#ff5000;cursor:pointer" @click="$router.push('/cars')">去逛逛 →</div>
    </div>
    <div v-if="cart.items.length" style="position:fixed;bottom:50px;left:0;right:0;background:#fff;padding:12px 16px;display:flex;align-items:center;gap:12px;box-shadow:0 -2px 10px rgba(0,0,0,0.06)">
      <div style="flex:1"><span style="font-size:12px;color:#999">合计 </span><span style="color:#ff5000;font-size:22px;font-weight:700">¥{{ cart.totalPrice.toLocaleString() }}</span></div>
      <div style="padding:12px 36px;background:#ff5000;color:#fff;border-radius:24px;font-size:15px;font-weight:600;cursor:pointer" @click="checkout">提交订单</div>
    </div>
  </div>
</template>
<script setup>
import { useCartStore } from '../stores/cart'; import api from '../api'; import { showToast, showSuccessToast } from 'vant'
const cart = useCartStore()
async function checkout() {
  if (!localStorage.getItem('token')) { showToast('请先登录'); return }
  const cid = localStorage.getItem('cid') || '1'
  const orderNo = 'SO' + Date.now()
  try {
    await api.post('/api/sale/orders', {
      orderNo, customerId: parseInt(cid),
      guidePrice: cart.totalPrice, discount: 0,
      totalPrice: cart.totalPrice, status: 'PENDING_DEPOSIT'
    })
    showSuccessToast('订单已提交')
    cart.clear()
  } catch(e) { showToast(e.response?.data?.message || '提交失败') }
}
</script>
