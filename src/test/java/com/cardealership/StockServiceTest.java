package com.cardealership;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.cardealership.modules.stock.entity.StockVehicle;
import com.cardealership.modules.stock.entity.VehicleVideo;
import com.cardealership.modules.stock.mapper.StockVehicleMapper;
import com.cardealership.modules.stock.mapper.VehicleVideoMapper;
import com.cardealership.modules.stock.service.StockService;
import com.cardealership.modules.stock.mapper.StockAccessoryMapper;
import com.cardealership.modules.stock.mapper.StockCheckMapper;
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
class StockServiceTest {

    @Mock private StockVehicleMapper vehicleMapper;
    @Mock private StockAccessoryMapper accessoryMapper;
    @Mock private StockCheckMapper checkMapper;
    @Mock private VehicleVideoMapper videoMapper;

    private StockService stockService;

    @BeforeEach
    void setUp() {
        stockService = new StockService(vehicleMapper, accessoryMapper, checkMapper, videoMapper);
    }

    @Test
    void shouldPageVehicles() {
        StockVehicle v = new StockVehicle();
        v.setId(1L);
        v.setBrand("奥迪");
        v.setModel("A6L");
        Page<StockVehicle> page = new Page<>(1, 10);
        page.setRecords(List.of(v));
        page.setTotal(1);
        doReturn(page).when(vehicleMapper).selectPage(any(Page.class), any(LambdaQueryWrapper.class));

        Page<StockVehicle> result = stockService.pageVehicles(1, 10, null, null);
        assertEquals(1, result.getTotal());
        assertEquals("奥迪", result.getRecords().get(0).getBrand());
    }

    @Test
    void shouldGetVehicleById() {
        StockVehicle v = new StockVehicle();
        v.setId(1L);
        v.setBrand("宝马");
        doReturn(v).when(vehicleMapper).selectById(1L);

        StockVehicle result = stockService.getVehicle(1L);
        assertEquals("宝马", result.getBrand());
    }

    @Test
    void shouldSaveNewVehicle() {
        StockVehicle v = new StockVehicle();
        v.setBrand("奔驰");
        stockService.saveVehicle(v);
        verify(vehicleMapper).insert(v);
    }

    @Test
    void shouldUpdateVehicleStatus() {
        stockService.updateVehicleStatus(1L, "SOLD");
        verify(vehicleMapper).updateById(any(StockVehicle.class));
    }

    @Test
    void shouldGetVideos() {
        VehicleVideo video = new VehicleVideo();
        video.setId(1L);
        video.setTitle("外观展示");
        doReturn(List.of(video)).when(videoMapper).selectList(any(LambdaQueryWrapper.class));

        List<VehicleVideo> result = stockService.getVideos(1L);
        assertEquals(1, result.size());
        assertEquals("外观展示", result.get(0).getTitle());
    }

    @Test
    void shouldAddVideo() {
        VehicleVideo v = new VehicleVideo();
        v.setTitle("试驾视频");
        stockService.addVideo(v);
        verify(videoMapper).insert(v);
    }

    @Test
    void shouldDeleteVideo() {
        stockService.deleteVideo(1L);
        verify(videoMapper).deleteById(1L);
    }
}
