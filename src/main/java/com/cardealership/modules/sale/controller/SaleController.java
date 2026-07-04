package com.cardealership.modules.sale.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.cardealership.common.dto.Result;
import com.cardealership.modules.sale.entity.*;
import com.cardealership.modules.sale.service.SaleService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/sale")
@RequiredArgsConstructor
public class SaleController {
    private final SaleService saleService;

    @GetMapping("/opportunities")
    public Result<Page<SaleOpportunity>> opportunities(@RequestParam(defaultValue = "1") int page,
                                                        @RequestParam(defaultValue = "10") int size,
                                                        @RequestParam(required = false) String status) {
        return Result.success(saleService.pageOpportunities(page, size, status));
    }

    @PostMapping("/opportunities")
    public Result<?> saveOpportunity(@RequestBody SaleOpportunity o) { saleService.saveOpportunity(o); return Result.success(); }

    @PutMapping("/opportunities/{id}")
    public Result<?> updateOpportunity(@PathVariable Long id, @RequestBody SaleOpportunity o) { o.setId(id); saleService.saveOpportunity(o); return Result.success(); }

    @DeleteMapping("/opportunities/{id}")
    @PreAuthorize("hasAnyRole('ADMIN','SALES_MANAGER')")
    public Result<?> deleteOpportunity(@PathVariable Long id) { saleService.deleteOpportunity(id); return Result.success(); }

    @GetMapping("/orders")
    public Result<Page<SaleOrder>> orders(@RequestParam(defaultValue = "1") int page,
                                           @RequestParam(defaultValue = "10") int size,
                                           @RequestParam(required = false) String status,
                                           @RequestParam(required = false) Long assigneeId) {
        return Result.success(saleService.pageOrders(page, size, status, assigneeId));
    }

    @GetMapping("/orders/{id}")
    public Result<SaleOrder> getOrder(@PathVariable Long id) { return Result.success(saleService.getOrder(id)); }

    @PostMapping("/orders")
    public Result<?> saveOrder(@RequestBody SaleOrder order) { saleService.saveOrder(order); return Result.success(); }

    @PutMapping("/orders/{id}")
    public Result<?> updateOrder(@PathVariable Long id, @RequestBody SaleOrder order) { order.setId(id); saleService.saveOrder(order); return Result.success(); }

    @PutMapping("/orders/{id}/status")
    public Result<?> updateOrderStatus(@PathVariable Long id, @RequestBody Map<String, String> body) {
        saleService.updateOrderStatus(id, body.get("status")); return Result.success();
    }

    @PostMapping("/orders/{id}/approve")
    public Result<?> approveOrder(@PathVariable Long id, @RequestBody Map<String, Object> body) {
        saleService.approveOrder(id,
                Long.valueOf(body.get("approverId").toString()),
                (String) body.get("level"),
                (Boolean) body.get("approved"),
                (String) body.get("comment"));
        return Result.success();
    }

    @GetMapping("/deliveries")
    public Result<Page<SaleDelivery>> deliveries(@RequestParam(defaultValue = "1") int page,
                                                  @RequestParam(defaultValue = "10") int size) {
        return Result.success(saleService.pageDeliveries(page, size));
    }

    @PostMapping("/deliveries")
    public Result<?> saveDelivery(@RequestBody SaleDelivery d) { saleService.saveDelivery(d); return Result.success(); }

    @PutMapping("/deliveries/{id}")
    public Result<?> updateDelivery(@PathVariable Long id, @RequestBody SaleDelivery d) { d.setId(id); saleService.saveDelivery(d); return Result.success(); }

    @GetMapping("/contracts")
    public Result<Page<SaleContract>> contracts(@RequestParam(defaultValue = "1") int page,
                                                 @RequestParam(defaultValue = "10") int size) {
        return Result.success(saleService.pageContracts(page, size));
    }

    @PostMapping("/contracts")
    public Result<?> saveContract(@RequestBody SaleContract c) { saleService.saveContract(c); return Result.success(); }

    @PutMapping("/contracts/{id}")
    public Result<?> updateContract(@PathVariable Long id, @RequestBody SaleContract c) { c.setId(id); saleService.saveContract(c); return Result.success(); }
}
