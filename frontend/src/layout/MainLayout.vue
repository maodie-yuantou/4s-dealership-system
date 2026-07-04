<template>
  <el-container style="height:100vh">
    <el-aside width="220px" style="background:#304156;overflow-y:auto">
      <div style="color:#fff;text-align:center;padding:16px;font-size:18px;font-weight:bold;border-bottom:1px solid #4a5064">润达4S店</div>
      <el-menu :default-active="route.path" background-color="#304156" text-color="#bfcbd9" active-text-color="#409EFF" router>
        <el-menu-item index="/dashboard"><el-icon><DataAnalysis /></el-icon> KPI大屏</el-menu-item>
        <el-sub-menu index="system"><template #title><el-icon><Setting /></el-icon> 系统管理</template>
          <el-menu-item index="/system/users">用户管理</el-menu-item><el-menu-item index="/system/roles">角色管理</el-menu-item><el-menu-item index="/system/depts">部门管理</el-menu-item></el-sub-menu>
        <el-sub-menu index="crm"><template #title><el-icon><UserFilled /></el-icon> 客户关系</template>
          <el-menu-item index="/crm/customers">客户档案</el-menu-item><el-menu-item index="/crm/leads">线索公海</el-menu-item><el-menu-item index="/crm/follow-ups">跟进记录</el-menu-item></el-sub-menu>
        <el-sub-menu index="sale"><template #title><el-icon><Sell /></el-icon> 整车销售</template>
          <el-menu-item index="/sale/opportunities">销售机会</el-menu-item><el-menu-item index="/sale/orders">订单管理</el-menu-item></el-sub-menu>
        <el-sub-menu index="stock"><template #title><el-icon><Box /></el-icon> 库存管理</template>
          <el-menu-item index="/stock/vehicles">整车库存</el-menu-item><el-menu-item index="/stock/accessories">配件库存</el-menu-item></el-sub-menu>
        <el-sub-menu index="service"><template #title><el-icon><Tool /></el-icon> 售后维修</template>
          <el-menu-item index="/service/appointments">预约管理</el-menu-item><el-menu-item index="/service/work-orders">维修工单</el-menu-item></el-sub-menu>
        <el-sub-menu index="finance"><template #title><el-icon><Money /></el-icon> 财务结算</template>
          <el-menu-item index="/finance/payments">收款管理</el-menu-item><el-menu-item index="/finance/invoices">发票管理</el-menu-item></el-sub-menu>
        <el-menu-item index="/report/kpi"><el-icon><TrendCharts /></el-icon> 统计报表</el-menu-item>
        <el-sub-menu index="marketing"><template #title><el-icon><Promotion /></el-icon> 市场营销</template>
          <el-menu-item index="/marketing/campaigns">活动管理</el-menu-item><el-menu-item index="/marketing/coupons">卡券管理</el-menu-item></el-sub-menu>
        <el-menu-item index="/chat/tickets"><el-icon><ChatLineSquare /></el-icon> 客服工单</el-menu-item>
      </el-menu>
    </el-aside>
    <el-container>
      <el-header style="background:#fff;display:flex;justify-content:flex-end;align-items:center;border-bottom:1px solid #e6e6e6;padding:0 20px">
        <span>{{ auth.user?.realName || auth.user?.username }}</span>
        <el-button type="danger" size="small" style="margin-left:12px" @click="handleLogout">退出</el-button>
      </el-header>
      <el-main style="background:#f0f2f5"><router-view /></el-main>
    </el-container>
  </el-container>
</template>
<script setup>
import { useRouter,useRoute } from 'vue-router';import { useAuthStore } from '../stores/auth'
const router=useRouter();const route=useRoute();const auth=useAuthStore()
function handleLogout(){auth.logout();router.push('/login')}
</script>
