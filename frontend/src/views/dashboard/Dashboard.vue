<template>
  <div>
    <h3>KPI 实时大屏</h3>
    <el-row :gutter="20" style="margin-top:16px">
      <el-col :span="4" v-for="card in cards" :key="card.title">
        <el-card shadow="hover" style="text-align:center">
          <div style="font-size:28px;font-weight:bold;color:#409EFF">{{ card.value }}</div>
          <div style="color:#909399;margin-top:8px">{{ card.title }}</div>
        </el-card>
      </el-col>
    </el-row>
    <el-row :gutter="20" style="margin-top:24px">
      <el-col :span="12">
        <el-card header="销售漏斗">
          <div ref="funnelChart" style="height:300px"></div>
        </el-card>
      </el-col>
      <el-col :span="12">
        <el-card header="快捷操作">
          <el-row :gutter="12">
            <el-col :span="8" v-for="act in actions" :key="act.label">
              <el-button :type="act.type" style="width:100%;margin-bottom:12px" @click="$router.push(act.path)">{{ act.label }}</el-button>
            </el-col>
          </el-row>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import api from '../../api'
import * as echarts from 'echarts'

const cards = ref([
  { title: '今日新线索', value: 0 }, { title: '今日订单', value: 0 },
  { title: '在库车辆', value: 0 }, { title: '在修车辆', value: 0 },
  { title: '今日交车', value: 0 }, { title: '待处理工单', value: 0 }
])

const actions = [
  { label: '新建线索', type: 'primary', path: '/crm/leads' },
  { label: '创建订单', type: 'success', path: '/sale/orders' },
  { label: '录入车辆', type: 'warning', path: '/stock/vehicles' },
  { label: '开维修单', type: 'danger', path: '/service/work-orders' },
  { label: '收款结算', type: 'info', path: '/finance/payments' },
  { label: '客服工单', type: '', path: '/chat/tickets' }
]

const funnelChart = ref(null)

onMounted(async () => {
  try {
    const kpi = await api.get('/api/report/kpi')
    const d = kpi.data.data
    cards.value[0].value = d.todayLeads
    cards.value[1].value = d.todayOrders
    cards.value[2].value = d.totalStock
    cards.value[3].value = d.inService
    cards.value[4].value = d.todayDeliveries
  } catch (e) {}
  try {
    const funnel = await api.get('/api/report/sales-funnel')
    const f = funnel.data.data
    const chart = echarts.init(funnelChart.value)
    chart.setOption({
      tooltip: { trigger: 'item' },
      series: [{ type: 'funnel', left: '10%', width: '80%',
        data: [{ value: f.leads, name: '线索' },{ value: f.opportunities, name: '意向' },{ value: f.orders, name: '订单' },{ value: f.deliveries, name: '交车' }]
      }]
    })
  } catch (e) {}
})
</script>
