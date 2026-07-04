package com.cardealership.modules.crm.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.cardealership.common.constant.Constants;
import com.cardealership.modules.crm.entity.*;
import com.cardealership.modules.crm.mapper.*;
import com.cardealership.modules.system.entity.SysUser;
import com.cardealership.modules.system.mapper.SysUserMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class CrmService {
    private final CrmCustomerMapper customerMapper;
    private final CrmFollowUpMapper followUpMapper;
    private final CrmLeadMapper leadMapper;
    private final CrmLeadAssignLogMapper assignLogMapper;
    private final CrmLostCustomerMapper lostCustomerMapper;
    private final CrmReminderMapper reminderMapper;
    private final SysUserMapper userMapper;

    // ---- Customer ----
    public Page<CrmCustomer> pageCustomers(int page, int size, String keyword, String customerType, String grade) {
        LambdaQueryWrapper<CrmCustomer> q = new LambdaQueryWrapper<>();
        if (StringUtils.hasText(keyword)) q.and(w -> w.like(CrmCustomer::getName, keyword).or().like(CrmCustomer::getPhone, keyword));
        if (StringUtils.hasText(customerType)) q.eq(CrmCustomer::getCustomerType, customerType);
        if (StringUtils.hasText(grade)) q.eq(CrmCustomer::getGrade, grade);
        q.orderByDesc(CrmCustomer::getCreatedAt);
        Page<CrmCustomer> result = customerMapper.selectPage(new Page<>(page, size), q);
        for (CrmCustomer c : result.getRecords()) {
            if (c.getAssigneeId() != null) {
                SysUser u = userMapper.selectById(c.getAssigneeId());
                if (u != null) c.setAssigneeName(u.getRealName());
            }
        }
        return result;
    }

    public CrmCustomer getCustomer(Long id) { return customerMapper.selectById(id); }

    @Transactional
    public void saveCustomer(CrmCustomer c) {
        if (c.getId() == null) customerMapper.insert(c);
        else customerMapper.updateById(c);
    }

    @Transactional
    public void deleteCustomer(Long id) { customerMapper.deleteById(id); }

    // ---- FollowUp ----
    public Page<CrmFollowUp> pageFollowUps(int page, int size, Long customerId) {
        LambdaQueryWrapper<CrmFollowUp> q = new LambdaQueryWrapper<>();
        if (customerId != null) q.eq(CrmFollowUp::getCustomerId, customerId);
        q.orderByDesc(CrmFollowUp::getCreatedAt);
        return followUpMapper.selectPage(new Page<>(page, size), q);
    }

    @Transactional
    public void saveFollowUp(CrmFollowUp f) {
        if (f.getId() == null) followUpMapper.insert(f);
        else followUpMapper.updateById(f);

        CrmCustomer customer = customerMapper.selectById(f.getCustomerId());
        if (customer != null && f.getNextFollowTime() != null) {
            CrmReminder reminder = new CrmReminder();
            reminder.setCustomerId(f.getCustomerId());
            reminder.setReminderType("FOLLOW_UP");
            reminder.setRemindTime(f.getNextFollowTime());
            reminder.setAssigneeId(f.getFollowBy());
            reminder.setRemark("跟进提醒: " + customer.getName());
            reminderMapper.insert(reminder);
        }
    }

    // ---- Lead ----
    public Page<CrmLead> pageLeads(int page, int size, String status, String keyword) {
        LambdaQueryWrapper<CrmLead> q = new LambdaQueryWrapper<>();
        if (StringUtils.hasText(status)) q.eq(CrmLead::getStatus, status);
        if (StringUtils.hasText(keyword)) q.and(w -> w.like(CrmLead::getCustomerName, keyword).or().like(CrmLead::getPhone, keyword));
        q.orderByDesc(CrmLead::getCreatedAt);
        Page<CrmLead> result = leadMapper.selectPage(new Page<>(page, size), q);
        for (CrmLead l : result.getRecords()) {
            if (l.getAssigneeId() != null) {
                SysUser u = userMapper.selectById(l.getAssigneeId());
                if (u != null) l.setAssigneeName(u.getRealName());
            }
        }
        return result;
    }

    @Transactional
    public void saveLead(CrmLead lead) {
        if (lead.getId() == null) {
            lead.setStatus("PUBLIC");
            leadMapper.insert(lead);
        } else {
            leadMapper.updateById(lead);
        }
    }

    @Transactional
    public void assignLead(Long leadId, Long toUserId, Long assignBy) {
        CrmLead lead = leadMapper.selectById(leadId);
        if (lead == null) throw new IllegalArgumentException("线索不存在");

        CrmLeadAssignLog log = new CrmLeadAssignLog();
        log.setLeadId(leadId);
        log.setFromUserId(lead.getAssigneeId());
        log.setToUserId(toUserId);
        log.setAssignType("MANUAL");
        log.setCreatedBy(assignBy);
        assignLogMapper.insert(log);

        lead.setAssigneeId(toUserId);
        lead.setAssignTime(LocalDateTime.now());
        lead.setStatus("ASSIGNED");
        leadMapper.updateById(lead);
    }

    @Transactional
    public void returnLead(Long leadId) {
        CrmLead lead = leadMapper.selectById(leadId);
        if (lead == null) return;
        lead.setAssigneeId(null);
        lead.setAssignTime(null);
        lead.setStatus("PUBLIC");
        leadMapper.updateById(lead);
    }

    @Transactional
    public void deleteLead(Long id) { leadMapper.deleteById(id); }

    // ---- Lost Customer ----
    public Page<CrmLostCustomer> pageLost(int page, int size) {
        return lostCustomerMapper.selectPage(new Page<>(page, size),
                new LambdaQueryWrapper<CrmLostCustomer>().orderByDesc(CrmLostCustomer::getCreatedAt));
    }

    @Transactional
    public void saveLost(CrmLostCustomer lc) {
        if (lc.getId() == null) lostCustomerMapper.insert(lc);
        else lostCustomerMapper.updateById(lc);

        CrmCustomer customer = customerMapper.selectById(lc.getCustomerId());
        if (customer != null) {
            customer.setGrade("D");
            customerMapper.updateById(customer);
        }
    }

    // ---- Reminder ----
    public Page<CrmReminder> pageReminders(int page, int size, String status, Long assigneeId) {
        LambdaQueryWrapper<CrmReminder> q = new LambdaQueryWrapper<>();
        if (StringUtils.hasText(status)) q.eq(CrmReminder::getStatus, status);
        if (assigneeId != null) q.eq(CrmReminder::getAssigneeId, assigneeId);
        q.orderByAsc(CrmReminder::getRemindTime);
        return reminderMapper.selectPage(new Page<>(page, size), q);
    }

    @Transactional
    public void updateReminderStatus(Long id, String status) {
        CrmReminder r = new CrmReminder();
        r.setId(id);
        r.setStatus(status);
        reminderMapper.updateById(r);
    }
}
