package com.cardealership.modules.sale.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.cardealership.common.constant.Constants;
import com.cardealership.modules.crm.entity.CrmCustomer;
import com.cardealership.modules.crm.mapper.CrmCustomerMapper;
import com.cardealership.modules.sale.entity.*;
import com.cardealership.modules.sale.mapper.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class SaleService {
    private final SaleOpportunityMapper opportunityMapper;
    private final SaleOrderMapper orderMapper;
    private final SaleDeliveryMapper deliveryMapper;
    private final SaleContractMapper contractMapper;
    private final SaleOrderApprovalMapper approvalMapper;
    private final CrmCustomerMapper customerMapper;

    // ---- Opportunity ----
    public Page<SaleOpportunity> pageOpportunities(int page, int size, String status) {
        LambdaQueryWrapper<SaleOpportunity> q = new LambdaQueryWrapper<>();
        if (status != null && !status.isEmpty()) q.eq(SaleOpportunity::getStatus, status);
        q.orderByDesc(SaleOpportunity::getCreatedAt);
        return opportunityMapper.selectPage(new Page<>(page, size), q);
    }

    @Transactional
    public void saveOpportunity(SaleOpportunity o) {
        if (o.getId() == null) opportunityMapper.insert(o);
        else opportunityMapper.updateById(o);
    }

    @Transactional
    public void deleteOpportunity(Long id) { opportunityMapper.deleteById(id); }

    // ---- Order ----
    public Page<SaleOrder> pageOrders(int page, int size, String status, Long assigneeId) {
        LambdaQueryWrapper<SaleOrder> q = new LambdaQueryWrapper<>();
        if (status != null && !status.isEmpty()) q.eq(SaleOrder::getStatus, status);
        if (assigneeId != null) q.eq(SaleOrder::getAssigneeId, assigneeId);
        q.orderByDesc(SaleOrder::getCreatedAt);
        return orderMapper.selectPage(new Page<>(page, size), q);
    }

    public SaleOrder getOrder(Long id) { return orderMapper.selectById(id); }

    @Transactional
    public void saveOrder(SaleOrder order) {
        if (order.getId() == null) {
            order.setOrderNo(Constants.ORDER_NO_PREFIX + System.currentTimeMillis());
            orderMapper.insert(order);
        } else {
            orderMapper.updateById(order);
        }
    }

    @Transactional
    public void updateOrderStatus(Long id, String status) {
        SaleOrder o = new SaleOrder();
        o.setId(id);
        o.setStatus(status);
        orderMapper.updateById(o);

        if ("COMPLETED".equals(status)) {
            SaleOrder order = orderMapper.selectById(id);
            CrmCustomer customer = customerMapper.selectById(order.getCustomerId());
            if (customer != null) {
                customer.setCustomerType("OWNER");
                customer.setPurchaseDate(java.time.LocalDate.now());
                customerMapper.updateById(customer);
            }
        }
    }

    @Transactional
    public void approveOrder(Long orderId, Long approverId, String level, Boolean approved, String comment) {
        SaleOrderApproval a = new SaleOrderApproval();
        a.setOrderId(orderId);
        a.setApprovalLevel(level);
        a.setApproverId(approverId);
        a.setStatus(approved ? "APPROVED" : "REJECTED");
        a.setComment(comment);
        a.setApprovedAt(LocalDateTime.now());
        approvalMapper.insert(a);

        SaleOrder o = new SaleOrder();
        o.setId(orderId);
        o.setStatus(approved ? "PENDING_DEPOSIT" : "PENDING_APPROVAL");
        orderMapper.updateById(o);
    }

    // ---- Delivery ----
    public Page<SaleDelivery> pageDeliveries(int page, int size) {
        return deliveryMapper.selectPage(new Page<>(page, size),
                new LambdaQueryWrapper<SaleDelivery>().orderByDesc(SaleDelivery::getCreatedAt));
    }

    @Transactional
    public void saveDelivery(SaleDelivery d) {
        if (d.getId() == null) deliveryMapper.insert(d);
        else deliveryMapper.updateById(d);

        if ("COMPLETED".equals(d.getDeliveryStatus())) {
            updateOrderStatus(d.getOrderId(), "COMPLETED");
        }
    }

    // ---- Contract ----
    public Page<SaleContract> pageContracts(int page, int size) {
        return contractMapper.selectPage(new Page<>(page, size),
                new LambdaQueryWrapper<SaleContract>().orderByDesc(SaleContract::getCreatedAt));
    }

    @Transactional
    public void saveContract(SaleContract c) {
        if (c.getId() == null) {
            c.setContractNo(Constants.CONTRACT_NO_PREFIX + System.currentTimeMillis());
            contractMapper.insert(c);
        } else {
            contractMapper.updateById(c);
        }
    }
}
