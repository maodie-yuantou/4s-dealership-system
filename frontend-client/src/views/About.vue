<template>
  <div style="min-height:100vh;background:#0a0a0a">
    <div style="padding:14px 16px;display:flex;align-items:center;gap:12px;color:#fff;border-bottom:1px solid rgba(255,255,255,0.06)">
      <span style="font-size:20px;cursor:pointer" @click="$router.push('/mine')">←</span>
      <span style="font-size:17px;font-weight:300;letter-spacing:2px">关于我们</span>
    </div>
    <div style="text-align:center;padding:50px 20px 30px">
      <div style="font-size:32px;font-weight:700;letter-spacing:4px;color:#c9a96e;margin-bottom:10px">RUNDA</div>
      <div style="font-size:14px;color:rgba(255,255,255,0.4)">润达汽车 · 豪华品牌授权经销商</div>
    </div>
    <div style="margin:0 16px 12px;background:rgba(255,255,255,0.04);border-radius:12px;overflow:hidden;border:1px solid rgba(255,255,255,0.06)">
      <van-cell title="服务热线" value="400-888-8888" style="--van-cell-background:transparent;--van-cell-text-color:#fff;--van-cell-value-color:rgba(255,255,255,0.5)" />
      <van-cell title="展厅地址" value="XX市XX区XX路XX号汽车城" style="--van-cell-background:transparent;--van-cell-text-color:#fff;--van-cell-value-color:rgba(255,255,255,0.5)" />
      <van-cell title="营业时间" value="9:00 - 18:00" style="--van-cell-background:transparent;--van-cell-text-color:#fff;--van-cell-value-color:rgba(255,255,255,0.5)" />
      <van-cell title="授权品牌" value="奥迪 宝马 奔驰 特斯拉 比亚迪等" style="--van-cell-background:transparent;--van-cell-text-color:#fff;--van-cell-value-color:rgba(255,255,255,0.5)" />
      <van-cell title="版本号" value="v1.0.0" style="--van-cell-background:transparent;--van-cell-text-color:#fff;--van-cell-value-color:rgba(255,255,255,0.5)" />
    </div>
  </div>
</template>
