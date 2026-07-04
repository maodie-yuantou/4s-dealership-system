package com.cardealership.modules.client.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.cardealership.modules.client.entity.*;
import com.cardealership.modules.client.mapper.*;
import com.cardealership.modules.crm.entity.CrmCustomer;
import com.cardealership.modules.crm.entity.CrmReminder;
import com.cardealership.modules.crm.mapper.CrmCustomerMapper;
import com.cardealership.modules.crm.mapper.CrmReminderMapper;
import com.cardealership.modules.service.entity.*;
import com.cardealership.modules.service.mapper.*;
import com.cardealership.modules.sale.entity.SaleOrder;
import com.cardealership.modules.sale.mapper.SaleOrderMapper;
import com.cardealership.modules.marketing.entity.MktCoupon;
import com.cardealership.modules.marketing.mapper.MktCouponMapper;
import com.cardealership.modules.stock.entity.StockVehicle;
import com.cardealership.modules.stock.mapper.StockVehicleMapper;
import com.cardealership.modules.system.entity.SysUser;
import com.cardealership.modules.system.mapper.SysUserMapper;
import com.cardealership.security.JwtTokenProvider;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.*;

@Service
@RequiredArgsConstructor
public class ClientService {
    private final CrmCustomerMapper customerMapper;
    private final SysUserMapper sysUserMapper;
    private final JwtTokenProvider jwtTokenProvider;
    private final CustomerVehicleMapper vehicleMapper;
    private final CustomerPointsMapper pointsMapper;
    private final MallProductMapper productMapper;
    private final MallOrderMapper orderMapper;
    private final MallOrderItemMapper orderItemMapper;
    private final RescueOrderMapper rescueMapper;
    private final AccidentReportMapper accidentMapper;
    private final ValuationRequestMapper valuationMapper;
    private final SvcAppointmentMapper apptMapper;
    private final SvcWorkOrderMapper woMapper;
    private final SaleOrderMapper saleOrderMapper;
    private final CrmReminderMapper reminderMapper;
    private final MktCouponMapper couponMapper;
    private final StockVehicleMapper stockVehicleMapper;

    // ========== 客户认证（手机号登录，简化模拟微信登录） ==========
    public boolean checkPhoneExists(String phone) {
        return customerMapper.selectOne(
            new LambdaQueryWrapper<CrmCustomer>().eq(CrmCustomer::getPhone, phone)) != null;
    }

    public Map<String, Object> phoneLogin(String phone) {
        CrmCustomer customer = customerMapper.selectOne(
                new LambdaQueryWrapper<CrmCustomer>().eq(CrmCustomer::getPhone, phone));
        if (customer == null) {
            throw new IllegalArgumentException("该手机号未绑定用户，请先注册账号");
        }
        Map<String, Object> result = new HashMap<>();
        result.put("customerId", customer.getId());
        result.put("name", customer.getName());
        result.put("phone", customer.getPhone());
        result.put("grade", customer.getGrade());

        // 同时查 sys_user，如果手机号匹配则生成 JWT token
        SysUser sysUser = sysUserMapper.selectOne(
            new LambdaQueryWrapper<SysUser>().eq(SysUser::getPhone, phone));
        if (sysUser != null) {
            List<String> roles = List.of("SALES_CONSULTANT");
            String token = jwtTokenProvider.generateToken(sysUser.getId(), sysUser.getUsername(), roles);
            result.put("token", token);
            result.put("username", sysUser.getUsername());
        }
        return result;
    }

    // ========== 我的车辆 ==========
    public List<CustomerVehicle> getMyVehicles(Long customerId) {
        return vehicleMapper.selectList(
                new LambdaQueryWrapper<CustomerVehicle>().eq(CustomerVehicle::getCustomerId, customerId));
    }

    @Transactional
    public void bindVehicle(Long customerId, CustomerVehicle v) {
        v.setCustomerId(customerId);
        if (v.getVin() != null) {
            StockVehicle sv = stockVehicleMapper.selectOne(
                    new LambdaQueryWrapper<StockVehicle>().eq(StockVehicle::getVin, v.getVin()));
            if (sv != null) {
                if (v.getBrand() == null || v.getBrand().isEmpty()) v.setBrand(sv.getBrand());
                if (v.getModel() == null || v.getModel().isEmpty()) v.setModel(sv.getModel());
                if (v.getModelYear() == null) v.setModelYear(sv.getModelYear());
            }
        }
        vehicleMapper.insert(v);
    }

    @Transactional
    public void updateVehicleMileage(Long id, int mileage) {
        CustomerVehicle v = new CustomerVehicle();
        v.setId(id); v.setMileage(mileage);
        vehicleMapper.updateById(v);
    }

    @Transactional
    public void deleteVehicle(Long id) { vehicleMapper.deleteById(id); }

    // ========== 我的订单 ==========
    public List<SaleOrder> getMySaleOrders(Long customerId) {
        return saleOrderMapper.selectList(
                new LambdaQueryWrapper<SaleOrder>().eq(SaleOrder::getCustomerId, customerId)
                        .orderByDesc(SaleOrder::getCreatedAt));
    }

    public List<SvcWorkOrder> getMyServiceOrders(Long customerId) {
        return woMapper.selectList(
                new LambdaQueryWrapper<SvcWorkOrder>().eq(SvcWorkOrder::getCustomerId, customerId)
                        .orderByDesc(SvcWorkOrder::getCreatedAt));
    }

    // ========== 我的卡券 ==========
    public List<Map<String, Object>> getMyCoupons(Long customerId) {
        // Query through mkt_coupon_issue table - simplified: return all active coupons
        List<MktCoupon> coupons = couponMapper.selectList(
                new LambdaQueryWrapper<MktCoupon>().eq(MktCoupon::getStatus, "ACTIVE"));
        List<Map<String, Object>> result = new ArrayList<>();
        for (MktCoupon c : coupons) {
            Map<String, Object> m = new HashMap<>();
            m.put("couponName", c.getCouponName());
            m.put("faceValue", c.getFaceValue());
            m.put("validFrom", c.getValidFrom());
            m.put("validTo", c.getValidTo());
            result.add(m);
        }
        return result;
    }

    // ========== 积分与会员 ==========
    public Map<String, Object> getMyPoints(Long customerId) {
        CustomerPoints p = pointsMapper.selectOne(
                new LambdaQueryWrapper<CustomerPoints>().eq(CustomerPoints::getCustomerId, customerId));
        Map<String, Object> result = new HashMap<>();
        if (p == null) {
            result.put("totalPoints", 0); result.put("totalGrowth", 0); result.put("memberLevel", "NORMAL");
        } else {
            result.put("totalPoints", p.getTotalPoints()); result.put("totalGrowth", p.getTotalGrowth());
            result.put("memberLevel", p.getMemberLevel());
        }
        return result;
    }

    // ========== 服务预约 ==========
    @Transactional
    public void createAppointment(Long customerId, SvcAppointment appt) {
        CrmCustomer c = customerMapper.selectById(customerId);
        appt.setCustomerId(customerId);
        appt.setCustomerName(c != null ? c.getName() : "");
        appt.setStatus("CONFIRMED");
        appt.setCreatedBy(customerId);
        apptMapper.insert(appt);
    }

    public List<SvcAppointment> getMyAppointments(Long customerId) {
        return apptMapper.selectList(
                new LambdaQueryWrapper<SvcAppointment>().eq(SvcAppointment::getCustomerId, customerId)
                        .orderByDesc(SvcAppointment::getAppointmentTime));
    }

    // ========== 透明车间（维修进度） ==========
    public Map<String, Object> getServiceProgress(Long workOrderId) {
        SvcWorkOrder wo = woMapper.selectById(workOrderId);
        if (wo == null) throw new IllegalArgumentException("工单不存在");
        Map<String, Object> result = new HashMap<>();
        result.put("woNo", wo.getWoNo());
        result.put("status", wo.getStatus());
        result.put("vehicleDesc", wo.getVehicleDesc());

        List<Map<String, String>> steps = new ArrayList<>();
        String[] statuses = {"RECEPTION", "DISPATCHED", "IN_PROGRESS", "QC", "WASH", "SETTLEMENT", "COMPLETED"};
        String[] labels = {"待接车", "派工中", "维修中", "质检中", "洗车中", "结算中", "待交车"};
        boolean found = false;
        for (int i = 0; i < statuses.length; i++) {
            Map<String, String> step = new HashMap<>();
            step.put("label", labels[i]);
            if (statuses[i].equals(wo.getStatus())) { step.put("status", "current"); found = true; }
            else if (!found) step.put("status", "done");
            else step.put("status", "pending");
            steps.add(step);
        }
        result.put("steps", steps);
        return result;
    }

    // ========== 在线商城 ==========
    public Page<MallProduct> getProducts(int page, int size, String category) {
        LambdaQueryWrapper<MallProduct> q = new LambdaQueryWrapper<>();
        if (category != null && !category.isEmpty()) q.eq(MallProduct::getCategory, category);
        q.eq(MallProduct::getStatus, "ON_SALE").orderByAsc(MallProduct::getSortOrder);
        return productMapper.selectPage(new Page<>(page, size), q);
    }

    @Transactional
    public MallOrder createMallOrder(Long customerId, List<Map<String, Object>> items) {
        MallOrder order = new MallOrder();
        order.setOrderNo("MO" + System.currentTimeMillis());
        order.setCustomerId(customerId);
        BigDecimal total = BigDecimal.ZERO;
        List<MallOrderItem> orderItems = new ArrayList<>();
        for (Map<String, Object> item : items) {
            Long productId = Long.valueOf(item.get("productId").toString());
            int qty = Integer.parseInt(item.get("quantity").toString());
            MallProduct p = productMapper.selectById(productId);
            if (p == null) continue;
            MallOrderItem oi = new MallOrderItem();
            oi.setProductId(productId); oi.setProductName(p.getProductName());
            oi.setPrice(p.getSalePrice()); oi.setQuantity(qty);
            oi.setTotalPrice(p.getSalePrice().multiply(BigDecimal.valueOf(qty)));
            total = total.add(oi.getTotalPrice());
            orderItems.add(oi);
        }
        order.setTotalAmount(total); order.setPayAmount(total);
        orderMapper.insert(order);
        for (MallOrderItem oi : orderItems) { oi.setOrderId(order.getId()); orderItemMapper.insert(oi); }
        order.setItems(orderItems);
        return order;
    }

    public List<MallOrder> getMyMallOrders(Long customerId) {
        List<MallOrder> orders = orderMapper.selectList(
                new LambdaQueryWrapper<MallOrder>().eq(MallOrder::getCustomerId, customerId)
                        .orderByDesc(MallOrder::getCreatedAt));
        for (MallOrder o : orders) {
            o.setItems(orderItemMapper.selectList(
                    new LambdaQueryWrapper<MallOrderItem>().eq(MallOrderItem::getOrderId, o.getId())));
        }
        return orders;
    }

    // ========== 智能提醒 ==========
    public List<CrmReminder> getMyReminders(Long customerId) {
        return reminderMapper.selectList(
                new LambdaQueryWrapper<CrmReminder>().eq(CrmReminder::getCustomerId, customerId)
                        .eq(CrmReminder::getStatus, "PENDING").orderByAsc(CrmReminder::getRemindTime));
    }

    // ========== 维保历史 ==========
    public List<SvcWorkOrder> getServiceHistory(Long customerId) {
        return woMapper.selectList(
                new LambdaQueryWrapper<SvcWorkOrder>().eq(SvcWorkOrder::getCustomerId, customerId)
                        .eq(SvcWorkOrder::getStatus, "COMPLETED").orderByDesc(SvcWorkOrder::getCreatedAt));
    }

    // ========== 道路救援 ==========
    @Transactional
    public void createRescue(Long customerId, RescueOrder rescue) {
        rescue.setCustomerId(customerId);
        rescue.setRescueNo("RE" + System.currentTimeMillis());
        rescue.setStatus("PENDING");
        rescueMapper.insert(rescue);
    }

    public RescueOrder getRescueStatus(Long rescueId) {
        return rescueMapper.selectById(rescueId);
    }

    // ========== 事故出险 ==========
    @Transactional
    public void reportAccident(Long customerId, AccidentReport report) {
        report.setCustomerId(customerId);
        report.setReportNo("AC" + System.currentTimeMillis());
        report.setStatus("REPORTED");
        accidentMapper.insert(report);
    }

    public List<AccidentReport> getMyAccidents(Long customerId) {
        return accidentMapper.selectList(
                new LambdaQueryWrapper<AccidentReport>().eq(AccidentReport::getCustomerId, customerId)
                        .orderByDesc(AccidentReport::getCreatedAt));
    }

    // ========== 二手车估价 ==========
    @Transactional
    public void requestValuation(Long customerId, ValuationRequest v) {
        v.setCustomerId(customerId);
        // Simple estimation logic
        BigDecimal base = BigDecimal.valueOf(80000);
        int age = LocalDate.now().getYear() - (v.getModelYear() != null ? v.getModelYear() : 2020);
        BigDecimal depreciation = base.multiply(BigDecimal.valueOf(age * 0.1));
        v.setEstimatedPrice(base.subtract(depreciation).max(BigDecimal.valueOf(10000)));
        v.setStatus("PENDING");
        valuationMapper.insert(v);
    }

    public List<ValuationRequest> getMyValuations(Long customerId) {
        return valuationMapper.selectList(
                new LambdaQueryWrapper<ValuationRequest>().eq(ValuationRequest::getCustomerId, customerId)
                        .orderByDesc(ValuationRequest::getCreatedAt));
    }
}
