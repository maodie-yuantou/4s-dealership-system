package com.cardealership.modules.stock.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.cardealership.common.constant.Constants;
import com.cardealership.modules.stock.entity.*;
import com.cardealership.modules.stock.mapper.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.LocalDate;

@Service
@RequiredArgsConstructor
public class StockService {
    private final StockVehicleMapper vehicleMapper;
    private final StockAccessoryMapper accessoryMapper;
    private final StockCheckMapper checkMapper;
    private final VehicleVideoMapper videoMapper;

    // ---- Vehicle ----
    public Page<StockVehicle> pageVehicles(int page, int size, String status, String keyword) {
        LambdaQueryWrapper<StockVehicle> q = new LambdaQueryWrapper<>();
        if (StringUtils.hasText(status)) q.eq(StockVehicle::getStatus, status);
        if (StringUtils.hasText(keyword)) q.and(w -> w.like(StockVehicle::getVin, keyword).or().like(StockVehicle::getBrand, keyword).or().like(StockVehicle::getModel, keyword));
        q.orderByDesc(StockVehicle::getCreatedAt);
        return vehicleMapper.selectPage(new Page<>(page, size), q);
    }

    public StockVehicle getVehicle(Long id) { return vehicleMapper.selectById(id); }

    @Transactional
    public void saveVehicle(StockVehicle v) {
        if (v.getId() == null) { v.setStatus("IN_STOCK"); v.setInboundDate(LocalDate.now()); vehicleMapper.insert(v); }
        else vehicleMapper.updateById(v);
    }

    @Transactional
    public void updateVehicleStatus(Long id, String status) {
        StockVehicle v = new StockVehicle(); v.setId(id); v.setStatus(status);
        if ("DELIVERED".equals(status)) v.setOutboundDate(LocalDate.now());
        vehicleMapper.updateById(v);
    }

    public Page<StockVehicle> getAlerts(int page, int size) {
        LocalDate alertDate = LocalDate.now().minusDays(Constants.DEFAULT_STOCK_ALERT_DAYS);
        return vehicleMapper.selectPage(new Page<>(page, size),
                new LambdaQueryWrapper<StockVehicle>()
                        .lt(StockVehicle::getInboundDate, alertDate)
                        .in(StockVehicle::getStatus, "IN_STOCK", "SHOWROOM"));
    }

    // ---- Accessory ----
    public Page<StockAccessory> pageAccessories(int page, int size) {
        return accessoryMapper.selectPage(new Page<>(page, size),
                new LambdaQueryWrapper<StockAccessory>().orderByAsc(StockAccessory::getAccessoryName));
    }

    @Transactional
    public void saveAccessory(StockAccessory a) {
        if (a.getId() == null) accessoryMapper.insert(a);
        else accessoryMapper.updateById(a);
    }

    // ---- Check ----
    public Page<StockCheck> pageChecks(int page, int size) {
        return checkMapper.selectPage(new Page<>(page, size),
                new LambdaQueryWrapper<StockCheck>().orderByDesc(StockCheck::getCheckDate));
    }

    @Transactional
    public void saveCheck(StockCheck c) {
        if (c.getId() == null) { c.setCheckNo(Constants.CHECK_NO_PREFIX + System.currentTimeMillis()); checkMapper.insert(c); }
        else checkMapper.updateById(c);
    }

    // ---- Video ----
    public java.util.List<VehicleVideo> getVideos(Long vehicleId) {
        return videoMapper.selectList(
            new LambdaQueryWrapper<VehicleVideo>()
                .eq(VehicleVideo::getVehicleId, vehicleId)
                .orderByAsc(VehicleVideo::getSortOrder));
    }

    @Transactional
    public VehicleVideo addVideo(VehicleVideo video) {
        if (video.getSortOrder() == null) video.setSortOrder(0);
        videoMapper.insert(video);
        return video;
    }

    @Transactional
    public void deleteVideo(Long id) {
        videoMapper.deleteById(id);
    }
}
