package com.cardealership.modules.finance.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.cardealership.common.constant.Constants;
import com.cardealership.modules.finance.entity.*;
import com.cardealership.modules.finance.mapper.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;

@Service
@RequiredArgsConstructor
public class FinanceService {
    private final FinPaymentMapper paymentMapper;
    private final FinInvoiceMapper invoiceMapper;
    private final FinDailySettlementMapper dailySettlementMapper;

    public Page<FinPayment> pagePayments(int page, int size, String paymentType) {
        LambdaQueryWrapper<FinPayment> q = new LambdaQueryWrapper<>();
        if (paymentType != null && !paymentType.isEmpty()) q.eq(FinPayment::getPaymentType, paymentType);
        q.orderByDesc(FinPayment::getCreatedAt);
        return paymentMapper.selectPage(new Page<>(page, size), q);
    }

    @Transactional
    public void savePayment(FinPayment p) {
        if (p.getId() == null) { p.setPaymentNo(Constants.PAYMENT_NO_PREFIX + System.currentTimeMillis()); paymentMapper.insert(p); }
        else paymentMapper.updateById(p);
    }

    public Page<FinInvoice> pageInvoices(int page, int size, String status) {
        LambdaQueryWrapper<FinInvoice> q = new LambdaQueryWrapper<>();
        if (status != null && !status.isEmpty()) q.eq(FinInvoice::getStatus, status);
        q.orderByDesc(FinInvoice::getCreatedAt);
        return invoiceMapper.selectPage(new Page<>(page, size), q);
    }

    @Transactional
    public void saveInvoice(FinInvoice i) {
        if (i.getId() == null) { i.setInvoiceNo(Constants.INVOICE_NO_PREFIX + System.currentTimeMillis()); invoiceMapper.insert(i); }
        else invoiceMapper.updateById(i);
    }

    public Page<FinDailySettlement> pageDailySettlements(int page, int size) {
        return dailySettlementMapper.selectPage(new Page<>(page, size),
                new LambdaQueryWrapper<FinDailySettlement>().orderByDesc(FinDailySettlement::getSettleDate));
    }

    @Transactional
    public void saveDailySettlement(FinDailySettlement ds) {
        if (ds.getId() == null) { ds.setSettleDate(LocalDate.now()); dailySettlementMapper.insert(ds); }
        else dailySettlementMapper.updateById(ds);
    }
}
