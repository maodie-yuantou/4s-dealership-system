package com.cardealership.modules.client.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.cardealership.common.dto.Result;
import com.cardealership.modules.client.entity.*;
import com.cardealership.modules.client.service.ClientService;
import com.cardealership.modules.service.entity.SvcAppointment;
import com.cardealership.modules.service.entity.SvcWorkOrder;
import com.cardealership.modules.sale.entity.SaleOrder;
import com.cardealership.modules.crm.entity.CrmReminder;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/client")
@RequiredArgsConstructor
public class ClientController {
    private final ClientService clientService;

    // === 认证 ===
    @PostMapping("/login")
    public Result<Map<String, Object>> login(@RequestBody Map<String, String> body) {
        return Result.success(clientService.phoneLogin(body.get("phone")));
    }

    @PostMapping("/check-phone")
    public Result<String> checkPhone(@RequestBody Map<String, String> body) {
        return Result.success(clientService.checkPhoneExists(body.get("phone")) ? "ok" : "not_found");
    }

    // === 我的车辆 ===
    @GetMapping("/vehicles")
    public Result<List<CustomerVehicle>> myVehicles(@RequestParam Long customerId) {
        return Result.success(clientService.getMyVehicles(customerId));
    }

    @PostMapping("/vehicles")
    public Result<?> bindVehicle(@RequestParam Long customerId, @RequestBody CustomerVehicle v) {
        clientService.bindVehicle(customerId, v); return Result.success();
    }

    @PutMapping("/vehicles/{id}/mileage")
    public Result<?> updateMileage(@PathVariable Long id, @RequestBody Map<String, Integer> body) {
        clientService.updateVehicleMileage(id, body.get("mileage")); return Result.success();
    }

    @DeleteMapping("/vehicles/{id}")
    public Result<?> deleteVehicle(@PathVariable Long id) { clientService.deleteVehicle(id); return Result.success(); }

    // === 我的订单 ===
    @GetMapping("/orders/sales")
    public Result<List<SaleOrder>> mySaleOrders(@RequestParam Long customerId) {
        return Result.success(clientService.getMySaleOrders(customerId));
    }

    @GetMapping("/orders/services")
    public Result<List<SvcWorkOrder>> myServiceOrders(@RequestParam Long customerId) {
        return Result.success(clientService.getMyServiceOrders(customerId));
    }

    // === 我的卡券 ===
    @GetMapping("/coupons")
    public Result<List<Map<String, Object>>> myCoupons(@RequestParam Long customerId) {
        return Result.success(clientService.getMyCoupons(customerId));
    }

    // === 积分会员 ===
    @GetMapping("/points")
    public Result<Map<String, Object>> myPoints(@RequestParam Long customerId) {
        return Result.success(clientService.getMyPoints(customerId));
    }

    // === 服务预约 ===
    @PostMapping("/appointments")
    public Result<?> createAppointment(@RequestParam Long customerId, @RequestBody SvcAppointment appt) {
        clientService.createAppointment(customerId, appt); return Result.success();
    }

    @GetMapping("/appointments")
    public Result<List<SvcAppointment>> myAppointments(@RequestParam Long customerId) {
        return Result.success(clientService.getMyAppointments(customerId));
    }

    // === 透明车间 ===
    @GetMapping("/service-progress/{workOrderId}")
    public Result<Map<String, Object>> serviceProgress(@PathVariable Long workOrderId) {
        return Result.success(clientService.getServiceProgress(workOrderId));
    }

    // === 在线商城 ===
    @GetMapping("/products")
    public Result<Page<MallProduct>> products(@RequestParam(defaultValue = "1") int page,
                                               @RequestParam(defaultValue = "10") int size,
                                               @RequestParam(required = false) String category) {
        return Result.success(clientService.getProducts(page, size, category));
    }

    @PostMapping("/orders/mall")
    public Result<MallOrder> createMallOrder(@RequestParam Long customerId, @RequestBody List<Map<String, Object>> items) {
        return Result.success(clientService.createMallOrder(customerId, items));
    }

    @GetMapping("/orders/mall")
    public Result<List<MallOrder>> myMallOrders(@RequestParam Long customerId) {
        return Result.success(clientService.getMyMallOrders(customerId));
    }

    // === 智能提醒 ===
    @GetMapping("/reminders")
    public Result<List<CrmReminder>> myReminders(@RequestParam Long customerId) {
        return Result.success(clientService.getMyReminders(customerId));
    }

    // === 维保历史 ===
    @GetMapping("/service-history")
    public Result<List<SvcWorkOrder>> serviceHistory(@RequestParam Long customerId) {
        return Result.success(clientService.getServiceHistory(customerId));
    }

    // === 道路救援 ===
    @PostMapping("/rescue")
    public Result<?> createRescue(@RequestParam Long customerId, @RequestBody RescueOrder rescue) {
        clientService.createRescue(customerId, rescue); return Result.success();
    }

    @GetMapping("/rescue/{id}")
    public Result<RescueOrder> rescueStatus(@PathVariable Long id) {
        return Result.success(clientService.getRescueStatus(id));
    }

    // === 事故出险 ===
    @PostMapping("/accidents")
    public Result<?> reportAccident(@RequestParam Long customerId, @RequestBody AccidentReport report) {
        clientService.reportAccident(customerId, report); return Result.success();
    }

    @GetMapping("/accidents")
    public Result<List<AccidentReport>> myAccidents(@RequestParam Long customerId) {
        return Result.success(clientService.getMyAccidents(customerId));
    }

    // === 二手车估价 ===
    @PostMapping("/valuations")
    public Result<?> requestValuation(@RequestParam Long customerId, @RequestBody ValuationRequest v) {
        clientService.requestValuation(customerId, v); return Result.success();
    }

    @GetMapping("/valuations")
    public Result<List<ValuationRequest>> myValuations(@RequestParam Long customerId) {
        return Result.success(clientService.getMyValuations(customerId));
    }
}
