package com.cardealership;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.cardealership.modules.stock.entity.StockVehicle;
import com.cardealership.modules.stock.service.StockService;
import com.cardealership.service.DataInitService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;

import java.math.BigDecimal;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
class StockControllerTest {

    @Autowired private MockMvc mockMvc;
    @MockBean private StockService stockService;
    @MockBean private DataInitService dataInitService;

    @Test
    @WithMockUser
    void shouldReturnVehicleList() throws Exception {
        StockVehicle vehicle = new StockVehicle();
        vehicle.setId(1L);
        vehicle.setBrand("奥迪");
        vehicle.setModel("A6L");
        vehicle.setColor("黑色");
        vehicle.setModelYear(2024);
        vehicle.setGuidePrice(new BigDecimal("427900"));
        vehicle.setStatus("IN_STOCK");

        Page<StockVehicle> page = new Page<>(1, 10);
        page.setRecords(java.util.List.of(vehicle));
        page.setTotal(1);

        when(stockService.pageVehicles(anyInt(), anyInt(), any(), any())).thenReturn(page);

        mockMvc.perform(get("/api/stock/vehicles?page=1&size=10"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.data.records[0].brand").value("奥迪"))
            .andExpect(jsonPath("$.data.records[0].model").value("A6L"))
            .andExpect(jsonPath("$.data.total").value(1));
    }

    @Test
    @WithMockUser
    void shouldReturnVehicleById() throws Exception {
        StockVehicle vehicle = new StockVehicle();
        vehicle.setId(1L);
        vehicle.setBrand("宝马");
        vehicle.setModel("325Li");
        vehicle.setColor("白色");
        vehicle.setModelYear(2024);
        vehicle.setGuidePrice(new BigDecimal("349900"));
        vehicle.setStatus("IN_STOCK");

        when(stockService.getVehicle(1L)).thenReturn(vehicle);

        mockMvc.perform(get("/api/stock/vehicles/1"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.data.brand").value("宝马"))
            .andExpect(jsonPath("$.data.model").value("325Li"));
    }

    @Test
    void shouldAllowAnonymousVehicleAccess() throws Exception {
        StockVehicle vehicle = new StockVehicle();
        vehicle.setId(1L);
        vehicle.setBrand("特斯拉");
        vehicle.setModel("Model Y");
        vehicle.setGuidePrice(new BigDecimal("263900"));
        vehicle.setStatus("IN_STOCK");

        when(stockService.getVehicle(1L)).thenReturn(vehicle);

        // 匿名用户可浏览车型
        mockMvc.perform(get("/api/stock/vehicles/1"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.data.brand").value("特斯拉"));
    }
}
