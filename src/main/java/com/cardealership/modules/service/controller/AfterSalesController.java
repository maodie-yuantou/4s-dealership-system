package com.cardealership.modules.service.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.cardealership.common.dto.Result;
import com.cardealership.modules.service.entity.*;
import com.cardealership.modules.service.service.AfterSalesService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/service")
@RequiredArgsConstructor
public class AfterSalesController {
    private final AfterSalesService service;

    @GetMapping("/appointments")
    public Result<Page<SvcAppointment>> appointments(@RequestParam(defaultValue = "1") int page,
                                                      @RequestParam(defaultValue = "10") int size,
                                                      @RequestParam(required = false) String status) {
        return Result.success(service.pageAppointments(page, size, status));
    }

    @PostMapping("/appointments")
    public Result<?> saveAppointment(@RequestBody SvcAppointment a) { service.saveAppointment(a); return Result.success(); }

    @PutMapping("/appointments/{id}")
    public Result<?> updateAppointment(@PathVariable Long id, @RequestBody SvcAppointment a) { a.setId(id); service.saveAppointment(a); return Result.success(); }

    @DeleteMapping("/appointments/{id}")
    public Result<?> deleteAppointment(@PathVariable Long id) { service.deleteAppointment(id); return Result.success(); }

    @GetMapping("/work-orders")
    public Result<Page<SvcWorkOrder>> workOrders(@RequestParam(defaultValue = "1") int page,
                                                  @RequestParam(defaultValue = "10") int size,
                                                  @RequestParam(required = false) String status) {
        return Result.success(service.pageWorkOrders(page, size, status));
    }

    @GetMapping("/work-orders/{id}")
    public Result<SvcWorkOrder> getWorkOrder(@PathVariable Long id) { return Result.success(service.getWorkOrder(id)); }

    @PostMapping("/work-orders")
    public Result<?> saveWorkOrder(@RequestBody SvcWorkOrder wo) { service.saveWorkOrder(wo); return Result.success(); }

    @PutMapping("/work-orders/{id}")
    public Result<?> updateWorkOrder(@PathVariable Long id, @RequestBody SvcWorkOrder wo) { wo.setId(id); service.saveWorkOrder(wo); return Result.success(); }

    @PutMapping("/work-orders/{id}/status")
    public Result<?> updateStatus(@PathVariable Long id, @RequestBody Map<String, String> body) { service.updateWorkOrderStatus(id, body.get("status")); return Result.success(); }

    @GetMapping("/settlements")
    public Result<Page<SvcSettlement>> settlements(@RequestParam(defaultValue = "1") int page,
                                                    @RequestParam(defaultValue = "10") int size,
                                                    @RequestParam(required = false) String paymentStatus) {
        return Result.success(service.pageSettlements(page, size, paymentStatus));
    }

    @PostMapping("/settlements")
    public Result<?> saveSettlement(@RequestBody SvcSettlement s) { service.saveSettlement(s); return Result.success(); }

    @PutMapping("/settlements/{id}")
    public Result<?> updateSettlement(@PathVariable Long id, @RequestBody SvcSettlement s) { s.setId(id); service.saveSettlement(s); return Result.success(); }
}
