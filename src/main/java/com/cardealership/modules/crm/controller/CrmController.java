package com.cardealership.modules.crm.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.cardealership.common.dto.Result;
import com.cardealership.modules.crm.entity.*;
import com.cardealership.modules.crm.service.CrmService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/crm")
@RequiredArgsConstructor
public class CrmController {
    private final CrmService crmService;

    // ---- Customers ----
    @GetMapping("/customers")
    public Result<Page<CrmCustomer>> customers(@RequestParam(defaultValue = "1") int page,
                                                @RequestParam(defaultValue = "10") int size,
                                                @RequestParam(required = false) String keyword,
                                                @RequestParam(required = false) String customerType,
                                                @RequestParam(required = false) String grade) {
        return Result.success(crmService.pageCustomers(page, size, keyword, customerType, grade));
    }

    @GetMapping("/customers/{id}")
    public Result<CrmCustomer> getCustomer(@PathVariable Long id) {
        return Result.success(crmService.getCustomer(id));
    }

    @PostMapping("/customers")
    public Result<?> saveCustomer(@RequestBody CrmCustomer c) { crmService.saveCustomer(c); return Result.success(); }

    @PutMapping("/customers/{id}")
    public Result<?> updateCustomer(@PathVariable Long id, @RequestBody CrmCustomer c) { c.setId(id); crmService.saveCustomer(c); return Result.success(); }

    @DeleteMapping("/customers/{id}")
    @PreAuthorize("hasAnyRole('ADMIN','SALES_MANAGER')")
    public Result<?> deleteCustomer(@PathVariable Long id) { crmService.deleteCustomer(id); return Result.success(); }

    // ---- Follow-ups ----
    @GetMapping("/follow-ups")
    public Result<Page<CrmFollowUp>> followUps(@RequestParam(defaultValue = "1") int page,
                                                @RequestParam(defaultValue = "10") int size,
                                                @RequestParam(required = false) Long customerId) {
        return Result.success(crmService.pageFollowUps(page, size, customerId));
    }

    @PostMapping("/follow-ups")
    public Result<?> saveFollowUp(@RequestBody CrmFollowUp f) { crmService.saveFollowUp(f); return Result.success(); }

    // ---- Leads ----
    @GetMapping("/leads")
    public Result<Page<CrmLead>> leads(@RequestParam(defaultValue = "1") int page,
                                        @RequestParam(defaultValue = "10") int size,
                                        @RequestParam(required = false) String status,
                                        @RequestParam(required = false) String keyword) {
        return Result.success(crmService.pageLeads(page, size, status, keyword));
    }

    @PostMapping("/leads")
    public Result<?> saveLead(@RequestBody CrmLead lead) { crmService.saveLead(lead); return Result.success(); }

    @PutMapping("/leads/{id}")
    public Result<?> updateLead(@PathVariable Long id, @RequestBody CrmLead lead) { lead.setId(id); crmService.saveLead(lead); return Result.success(); }

    @DeleteMapping("/leads/{id}")
    @PreAuthorize("hasAnyRole('ADMIN','SALES_MANAGER')")
    public Result<?> deleteLead(@PathVariable Long id) { crmService.deleteLead(id); return Result.success(); }

    @PostMapping("/leads/{id}/assign")
    @PreAuthorize("hasAnyRole('ADMIN','SALES_MANAGER')")
    public Result<?> assignLead(@PathVariable Long id, @RequestBody Map<String, Long> body) {
        crmService.assignLead(id, body.get("toUserId"), body.get("assignBy"));
        return Result.success();
    }

    @PostMapping("/leads/{id}/return")
    @PreAuthorize("hasAnyRole('ADMIN','SALES_MANAGER')")
    public Result<?> returnLead(@PathVariable Long id) { crmService.returnLead(id); return Result.success(); }

    // ---- Lost Customers ----
    @GetMapping("/lost-customers")
    public Result<Page<CrmLostCustomer>> lost(@RequestParam(defaultValue = "1") int page,
                                               @RequestParam(defaultValue = "10") int size) {
        return Result.success(crmService.pageLost(page, size));
    }

    @PostMapping("/lost-customers")
    public Result<?> saveLost(@RequestBody CrmLostCustomer lc) { crmService.saveLost(lc); return Result.success(); }

    // ---- Reminders ----
    @GetMapping("/reminders")
    public Result<Page<CrmReminder>> reminders(@RequestParam(defaultValue = "1") int page,
                                                @RequestParam(defaultValue = "10") int size,
                                                @RequestParam(required = false) String status,
                                                @RequestParam(required = false) Long assigneeId) {
        return Result.success(crmService.pageReminders(page, size, status, assigneeId));
    }

    @PutMapping("/reminders/{id}/status")
    public Result<?> updateReminderStatus(@PathVariable Long id, @RequestBody Map<String, String> body) {
        crmService.updateReminderStatus(id, body.get("status"));
        return Result.success();
    }
}
