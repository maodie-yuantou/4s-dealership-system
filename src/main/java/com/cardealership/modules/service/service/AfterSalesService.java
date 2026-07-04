package com.cardealership.modules.service.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.cardealership.common.constant.Constants;
import com.cardealership.modules.service.entity.*;
import com.cardealership.modules.service.mapper.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class AfterSalesService {
    private final SvcAppointmentMapper appointmentMapper;
    private final SvcWorkOrderMapper workOrderMapper;
    private final SvcSettlementMapper settlementMapper;

    // ---- Appointment ----
    public Page<SvcAppointment> pageAppointments(int page, int size, String status) {
        LambdaQueryWrapper<SvcAppointment> q = new LambdaQueryWrapper<>();
        if (status != null && !status.isEmpty()) q.eq(SvcAppointment::getStatus, status);
        q.orderByDesc(SvcAppointment::getAppointmentTime);
        return appointmentMapper.selectPage(new Page<>(page, size), q);
    }

    @Transactional
    public void saveAppointment(SvcAppointment a) {
        if (a.getId() == null) appointmentMapper.insert(a);
        else appointmentMapper.updateById(a);
    }

    @Transactional
    public void deleteAppointment(Long id) { appointmentMapper.deleteById(id); }

    // ---- Work Order ----
    public Page<SvcWorkOrder> pageWorkOrders(int page, int size, String status) {
        LambdaQueryWrapper<SvcWorkOrder> q = new LambdaQueryWrapper<>();
        if (status != null && !status.isEmpty()) q.eq(SvcWorkOrder::getStatus, status);
        q.orderByDesc(SvcWorkOrder::getCreatedAt);
        return workOrderMapper.selectPage(new Page<>(page, size), q);
    }

    public SvcWorkOrder getWorkOrder(Long id) { return workOrderMapper.selectById(id); }

    @Transactional
    public void saveWorkOrder(SvcWorkOrder wo) {
        if (wo.getId() == null) {
            wo.setWoNo(Constants.WO_NO_PREFIX + System.currentTimeMillis());
            workOrderMapper.insert(wo);
        } else {
            workOrderMapper.updateById(wo);
        }
    }

    @Transactional
    public void updateWorkOrderStatus(Long id, String status) {
        SvcWorkOrder wo = new SvcWorkOrder(); wo.setId(id); wo.setStatus(status);
        if ("IN_PROGRESS".equals(status)) wo.setStartedAt(java.time.LocalDateTime.now());
        if ("COMPLETED".equals(status)) wo.setCompletedAt(java.time.LocalDateTime.now());
        workOrderMapper.updateById(wo);
    }

    // ---- Settlement ----
    public Page<SvcSettlement> pageSettlements(int page, int size, String paymentStatus) {
        LambdaQueryWrapper<SvcSettlement> q = new LambdaQueryWrapper<>();
        if (paymentStatus != null && !paymentStatus.isEmpty()) q.eq(SvcSettlement::getPaymentStatus, paymentStatus);
        q.orderByDesc(SvcSettlement::getCreatedAt);
        return settlementMapper.selectPage(new Page<>(page, size), q);
    }

    @Transactional
    public void saveSettlement(SvcSettlement s) {
        if (s.getId() == null) settlementMapper.insert(s);
        else settlementMapper.updateById(s);
    }
}
