import { createRouter, createWebHistory, type RouteRecordRaw } from 'vue-router'
import { useAuthStore } from '../stores/auth'

const routes: RouteRecordRaw[] = [
  { path: '/login', name: 'Login', component: () => import('../views/login/Login.vue'), meta: { public: true } },
  {
    path: '/', component: () => import('../layout/MainLayout.vue'), redirect: '/dashboard',
    children: [
      { path: 'dashboard', name: 'Dashboard', component: () => import('../views/dashboard/Dashboard.vue'), meta: { title: 'KPI大屏' } },
      { path: 'system/users', name: 'Users', component: () => import('../views/system/Users.vue'), meta: { title: '用户管理' } },
      { path: 'system/roles', name: 'Roles', component: () => import('../views/system/Roles.vue'), meta: { title: '角色管理' } },
      { path: 'system/depts', name: 'Depts', component: () => import('../views/system/Depts.vue'), meta: { title: '部门管理' } },
      { path: 'crm/customers', name: 'Customers', component: () => import('../views/crm/Customers.vue'), meta: { title: '客户档案' } },
      { path: 'crm/leads', name: 'Leads', component: () => import('../views/crm/Leads.vue'), meta: { title: '线索公海' } },
      { path: 'crm/follow-ups', name: 'FollowUps', component: () => import('../views/crm/FollowUps.vue'), meta: { title: '跟进记录' } },
      { path: 'sale/opportunities', name: 'Opportunities', component: () => import('../views/sale/Opportunities.vue'), meta: { title: '销售机会' } },
      { path: 'sale/orders', name: 'Orders', component: () => import('../views/sale/Orders.vue'), meta: { title: '订单管理' } },
      { path: 'stock/vehicles', name: 'StockVehicles', component: () => import('../views/stock/Vehicles.vue'), meta: { title: '整车库存' } },
      { path: 'stock/accessories', name: 'Accessories', component: () => import('../views/stock/Accessories.vue'), meta: { title: '配件库存' } },
      { path: 'service/appointments', name: 'SvcAppointments', component: () => import('../views/service/Appointments.vue'), meta: { title: '预约管理' } },
      { path: 'service/work-orders', name: 'WorkOrders', component: () => import('../views/service/WorkOrders.vue'), meta: { title: '维修工单' } },
      { path: 'finance/payments', name: 'Payments', component: () => import('../views/finance/Payments.vue'), meta: { title: '收款管理' } },
      { path: 'finance/invoices', name: 'Invoices', component: () => import('../views/finance/Invoices.vue'), meta: { title: '发票管理' } },
      { path: 'report/kpi', name: 'ReportKpi', component: () => import('../views/report/Kpi.vue'), meta: { title: '报表分析' } },
      { path: 'marketing/campaigns', name: 'Campaigns', component: () => import('../views/marketing/Campaigns.vue'), meta: { title: '活动管理' } },
      { path: 'marketing/coupons', name: 'Coupons', component: () => import('../views/marketing/Coupons.vue'), meta: { title: '卡券管理' } },
      { path: 'chat/tickets', name: 'ChatTickets', component: () => import('../views/chat/Tickets.vue'), meta: { title: '客服工单' } }
    ]
  }
]

const router = createRouter({
  history: createWebHistory('/admin/'),
  routes
})

router.beforeEach((to, _from, next) => {
  const auth = useAuthStore()
  if (to.meta.public || auth.token) {
    next()
  } else {
    next('/login')
  }
})

export default router
