package com.cardealership.modules.finance.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.cardealership.common.dto.Result;
import com.cardealership.modules.finance.entity.*;
import com.cardealership.modules.finance.service.FinanceService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/finance")
@RequiredArgsConstructor
public class FinanceController {
    private final FinanceService financeService;

    @GetMapping("/payments")
    public Result<Page<FinPayment>> payments(@RequestParam(defaultValue = "1") int page,
                                              @RequestParam(defaultValue = "10") int size,
                                              @RequestParam(required = false) String paymentType) {
        return Result.success(financeService.pagePayments(page, size, paymentType));
    }

    @PostMapping("/payments")
    public Result<?> savePayment(@RequestBody FinPayment p) { financeService.savePayment(p); return Result.success(); }

    @PutMapping("/payments/{id}")
    public Result<?> updatePayment(@PathVariable Long id, @RequestBody FinPayment p) { p.setId(id); financeService.savePayment(p); return Result.success(); }

    @GetMapping("/invoices")
    public Result<Page<FinInvoice>> invoices(@RequestParam(defaultValue = "1") int page,
                                              @RequestParam(defaultValue = "10") int size,
                                              @RequestParam(required = false) String status) {
        return Result.success(financeService.pageInvoices(page, size, status));
    }

    @PostMapping("/invoices")
    public Result<?> saveInvoice(@RequestBody FinInvoice i) { financeService.saveInvoice(i); return Result.success(); }

    @PutMapping("/invoices/{id}")
    public Result<?> updateInvoice(@PathVariable Long id, @RequestBody FinInvoice i) { i.setId(id); financeService.saveInvoice(i); return Result.success(); }

    @GetMapping("/daily-settlements")
    public Result<Page<FinDailySettlement>> dailySettlements(@RequestParam(defaultValue = "1") int page,
                                                              @RequestParam(defaultValue = "10") int size) {
        return Result.success(financeService.pageDailySettlements(page, size));
    }

    @PostMapping("/daily-settlements")
    public Result<?> saveDailySettlement(@RequestBody FinDailySettlement ds) { financeService.saveDailySettlement(ds); return Result.success(); }
}
