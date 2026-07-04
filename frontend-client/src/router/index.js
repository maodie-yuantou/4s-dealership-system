import { createRouter, createWebHistory } from 'vue-router'
const routes = [
  { path: '/', component: () => import('../views/Home.vue') },
  { path: '/services', component: () => import('../views/Services.vue') },
  { path: '/cart', component: () => import('../views/Cart.vue') },
  { path: '/cars', component: () => import('../views/Cars.vue') },
  { path: '/car/:id', component: () => import('../views/CarDetail.vue') },
  { path: '/test-drive', component: () => import('../views/TestDrive.vue') },
  { path: '/finance', component: () => import('../views/FinanceCalc.vue') },
  { path: '/trade-in', component: () => import('../views/TradeIn.vue') },
  { path: '/chat', component: () => import('../views/Chat.vue') },
  { path: '/mine', component: () => import('../views/Mine.vue') },
  { path: '/login', component: () => import('../views/Login.vue') },
  { path: '/register', component: () => import('../views/Register.vue') },
  { path: '/reset-password', component: () => import('../views/ResetPassword.vue') },
  { path: '/profile', component: () => import('../views/Profile.vue') },
  { path: '/orders', component: () => import('../views/Orders.vue') },
  { path: '/appointments', component: () => import('../views/Appointments.vue') },
  { path: '/coupons', component: () => import('../views/Coupons.vue') },
  { path: '/points', component: () => import('../views/Points.vue') },
  { path: '/about', component: () => import('../views/About.vue') }
]
export default createRouter({ history: createWebHistory(), routes })
