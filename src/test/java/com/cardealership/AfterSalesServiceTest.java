package com.cardealership;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.cardealership.modules.service.entity.SvcAppointment;
import com.cardealership.modules.service.entity.SvcWorkOrder;
import com.cardealership.modules.service.mapper.SvcAppointmentMapper;
import com.cardealership.modules.service.mapper.SvcWorkOrderMapper;
import com.cardealership.modules.service.mapper.SvcSettlementMapper;
import com.cardealership.modules.service.service.AfterSalesService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AfterSalesServiceTest {

    @Mock private SvcAppointmentMapper appointmentMapper;
    @Mock private SvcWorkOrderMapper workOrderMapper;
    @Mock private SvcSettlementMapper settlementMapper;

    private AfterSalesService service;

    @BeforeEach
    void setUp() {
        service = new AfterSalesService(appointmentMapper, workOrderMapper, settlementMapper);
    }

    @Test
    void shouldListAppointments() {
        SvcAppointment a = new SvcAppointment();
        a.setId(1L);
        a.setServiceType("MAINTENANCE");
        Page<SvcAppointment> page = new Page<>(1, 10);
        page.setRecords(List.of(a));
        page.setTotal(1);
        doReturn(page).when(appointmentMapper).selectPage(any(Page.class), any(LambdaQueryWrapper.class));

        Page<SvcAppointment> result = service.pageAppointments(1, 10, null);
        assertEquals(1, result.getTotal());
        assertEquals("MAINTENANCE", result.getRecords().get(0).getServiceType());
    }

    @Test
    void shouldSaveNewAppointment() {
        SvcAppointment a = new SvcAppointment();
        service.saveAppointment(a);
        verify(appointmentMapper).insert(a);
    }

    @Test
    void shouldUpdateExistingAppointment() {
        SvcAppointment a = new SvcAppointment();
        a.setId(1L);
        service.saveAppointment(a);
        verify(appointmentMapper).updateById(a);
    }

    @Test
    void shouldDeleteAppointment() {
        service.deleteAppointment(1L);
        verify(appointmentMapper).deleteById(1L);
    }

    // ========== Work Orders ==========
    @Test
    void shouldListWorkOrders() {
        SvcWorkOrder wo = new SvcWorkOrder();
        wo.setId(1L);
        wo.setWoNo("WO001");
        Page<SvcWorkOrder> page = new Page<>(1, 10);
        page.setRecords(List.of(wo));
        page.setTotal(1);
        doReturn(page).when(workOrderMapper).selectPage(any(Page.class), any(LambdaQueryWrapper.class));

        Page<SvcWorkOrder> result = service.pageWorkOrders(1, 10, null);
        assertEquals(1, result.getTotal());
        assertEquals("WO001", result.getRecords().get(0).getWoNo());
    }

    @Test
    void shouldGetWorkOrderById() {
        SvcWorkOrder wo = new SvcWorkOrder();
        wo.setId(1L);
        doReturn(wo).when(workOrderMapper).selectById(1L);

        SvcWorkOrder result = service.getWorkOrder(1L);
        assertNotNull(result);
    }

    @Test
    void shouldSaveNewWorkOrder() {
        SvcWorkOrder wo = new SvcWorkOrder();
        service.saveWorkOrder(wo);
        assertNotNull(wo.getWoNo());
        assertTrue(wo.getWoNo().startsWith("WO"));
        verify(workOrderMapper).insert(wo);
    }

    @Test
    void shouldUpdateWorkOrderStatusToInProgress() {
        service.updateWorkOrderStatus(1L, "IN_PROGRESS");
        verify(workOrderMapper).updateById(any(SvcWorkOrder.class));
    }
}
