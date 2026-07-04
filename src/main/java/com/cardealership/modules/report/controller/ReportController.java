package com.cardealership.modules.report.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.cardealership.common.dto.Result;
import com.cardealership.modules.sale.entity.SaleOrder;
import com.cardealership.modules.sale.mapper.SaleOrderMapper;
import com.cardealership.modules.crm.entity.CrmLead;
import com.cardealership.modules.crm.mapper.CrmLeadMapper;
import com.cardealership.modules.stock.entity.StockVehicle;
import com.cardealership.modules.stock.mapper.StockVehicleMapper;
import com.cardealership.modules.service.entity.SvcWorkOrder;
import com.cardealership.modules.service.mapper.SvcWorkOrderMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.*;

@RestController
@RequestMapping("/api/report")
@RequiredArgsConstructor
public class ReportController {
    private final CrmLeadMapper leadMapper;
    private final SaleOrderMapper orderMapper;
    private final StockVehicleMapper stockVehicleMapper;
    private final SvcWorkOrderMapper workOrderMapper;

    @GetMapping("/kpi")
    public Result<Map<String, Object>> kpi() {
        Map<String, Object> kpi = new LinkedHashMap<>();
        long todayLeads = leadMapper.selectCount(new LambdaQueryWrapper<CrmLead>()
                .ge(CrmLead::getCreatedAt, LocalDate.now()));
        long todayOrders = orderMapper.selectCount(new LambdaQueryWrapper<SaleOrder>()
                .ge(SaleOrder::getCreatedAt, LocalDate.now()));
        long totalStock = stockVehicleMapper.selectCount(new LambdaQueryWrapper<StockVehicle>()
                .eq(StockVehicle::getStatus, "IN_STOCK"));
        long inService = workOrderMapper.selectCount(new LambdaQueryWrapper<SvcWorkOrder>()
                .in(SvcWorkOrder::getStatus, "RECEPTION", "DISPATCHED", "IN_PROGRESS"));
        long todayDeliveries = orderMapper.selectCount(new LambdaQueryWrapper<SaleOrder>()
                .eq(SaleOrder::getStatus, "COMPLETED")
                .ge(SaleOrder::getCreatedAt, LocalDate.now()));

        kpi.put("todayLeads", todayLeads);
        kpi.put("todayOrders", todayOrders);
        kpi.put("totalStock", totalStock);
        kpi.put("inService", inService);
        kpi.put("todayDeliveries", todayDeliveries);
        return Result.success(kpi);
    }

    @GetMapping("/sales-funnel")
    public Result<Map<String, Object>> salesFunnel() {
        Map<String, Object> funnel = new LinkedHashMap<>();
        long leads = leadMapper.selectCount(null);
        long opportunities = orderMapper.selectCount(null);
        long orders = orderMapper.selectCount(new LambdaQueryWrapper<SaleOrder>()
                .ne(SaleOrder::getStatus, "CANCELLED"));
        long deliveries = orderMapper.selectCount(new LambdaQueryWrapper<SaleOrder>()
                .eq(SaleOrder::getStatus, "COMPLETED"));
        funnel.put("leads", leads);
        funnel.put("opportunities", opportunities);
        funnel.put("orders", orders);
        funnel.put("deliveries", deliveries);
        return Result.success(funnel);
    }

    @GetMapping("/sales-performance")
    public Result<List<Map<String, Object>>> salesPerformance() {
        List<SaleOrder> allOrders = orderMapper.selectList(null);
        Map<String, java.math.BigDecimal> byStatus = new LinkedHashMap<>();
        for (SaleOrder o : allOrders) {
            byStatus.merge(o.getStatus(), o.getTotalPrice() != null ? o.getTotalPrice() : java.math.BigDecimal.ZERO, java.math.BigDecimal::add);
        }
        List<Map<String, Object>> result = new ArrayList<>();
        for (Map.Entry<String, java.math.BigDecimal> e : byStatus.entrySet()) {
            Map<String, Object> item = new LinkedHashMap<>();
            item.put("status", e.getKey());
            item.put("amount", e.getValue());
            result.add(item);
        }
        return Result.success(result);
    }
}
