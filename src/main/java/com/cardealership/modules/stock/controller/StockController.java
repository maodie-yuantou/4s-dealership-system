package com.cardealership.modules.stock.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.cardealership.common.dto.Result;
import com.cardealership.modules.stock.entity.*;
import com.cardealership.modules.stock.service.StockService;
import com.cardealership.service.MinioService;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.Map;

@RestController
@RequestMapping("/api/stock")
@RequiredArgsConstructor
@Tag(name = "库存管理", description = "整车入库、出库、库存查询、配件管理")
public class StockController {
    private final StockService stockService;
    private final MinioService minioService;

    @GetMapping("/vehicles")
    public Result<Page<StockVehicle>> vehicles(@RequestParam(defaultValue = "1") int page,
                                                @RequestParam(defaultValue = "10") int size,
                                                @RequestParam(required = false) String status,
                                                @RequestParam(required = false) String keyword) {
        return Result.success(stockService.pageVehicles(page, size, status, keyword));
    }

    @GetMapping("/vehicles/{id}")
    public Result<StockVehicle> getVehicle(@PathVariable Long id) { return Result.success(stockService.getVehicle(id)); }

    @PreAuthorize("hasAnyRole('ADMIN', 'SALES_MANAGER')")
    @PostMapping("/vehicles")
    public Result<?> saveVehicle(@RequestBody StockVehicle v) { stockService.saveVehicle(v); return Result.success(); }

    @PreAuthorize("hasAnyRole('ADMIN', 'SALES_MANAGER')")
    @PutMapping("/vehicles/{id}")
    public Result<?> updateVehicle(@PathVariable Long id, @RequestBody StockVehicle v) { v.setId(id); stockService.saveVehicle(v); return Result.success(); }

    @PreAuthorize("hasAnyRole('ADMIN', 'SALES_MANAGER')")
    @PostMapping("/vehicles/upload")
    public Result<String> uploadImage(@RequestParam("file") MultipartFile file) throws IOException {
        return Result.success(minioService.upload(file, "vehicles/images"));
    }

    @PreAuthorize("hasAnyRole('ADMIN', 'SALES_MANAGER')")
    @PutMapping("/vehicles/{id}/status")
    public Result<?> updateStatus(@PathVariable Long id, @RequestBody Map<String, String> body) { stockService.updateVehicleStatus(id, body.get("status")); return Result.success(); }

    @GetMapping("/vehicles/alerts")
    public Result<Page<StockVehicle>> alerts(@RequestParam(defaultValue = "1") int page, @RequestParam(defaultValue = "10") int size) {
        return Result.success(stockService.getAlerts(page, size));
    }

    @GetMapping("/accessories")
    public Result<Page<StockAccessory>> accessories(@RequestParam(defaultValue = "1") int page, @RequestParam(defaultValue = "10") int size) {
        return Result.success(stockService.pageAccessories(page, size));
    }

    @PreAuthorize("hasAnyRole('ADMIN', 'SALES_MANAGER')")
    @PostMapping("/accessories")
    public Result<?> saveAccessory(@RequestBody StockAccessory a) { stockService.saveAccessory(a); return Result.success(); }

    @GetMapping("/checks")
    public Result<Page<StockCheck>> checks(@RequestParam(defaultValue = "1") int page, @RequestParam(defaultValue = "10") int size) {
        return Result.success(stockService.pageChecks(page, size));
    }

    @PostMapping("/checks")
    public Result<?> saveCheck(@RequestBody StockCheck c) { stockService.saveCheck(c); return Result.success(); }

    // ---- Vehicle Videos ----

    @GetMapping("/vehicles/{vehicleId}/videos")
    public Result<java.util.List<VehicleVideo>> getVideos(@PathVariable Long vehicleId) {
        return Result.success(stockService.getVideos(vehicleId));
    }

    @PreAuthorize("hasAnyRole('ADMIN', 'SALES_MANAGER')")
    @PostMapping("/vehicles/{vehicleId}/videos")
    public Result<VehicleVideo> addVideo(@PathVariable Long vehicleId, @RequestBody VehicleVideo video) {
        video.setVehicleId(vehicleId);
        video.setSourceType("LINK");
        return Result.success(stockService.addVideo(video));
    }

    @PreAuthorize("hasAnyRole('ADMIN', 'SALES_MANAGER')")
    @PostMapping("/vehicles/{vehicleId}/videos/upload")
    public Result<VehicleVideo> uploadVideo(@PathVariable Long vehicleId,
                                             @RequestParam("file") MultipartFile file,
                                             @RequestParam(value = "title", defaultValue = "") String title) throws IOException {
        String url = minioService.upload(file, "vehicles/videos");
        String originalName = file.getOriginalFilename();

        VehicleVideo video = new VehicleVideo();
        video.setVehicleId(vehicleId);
        video.setTitle(title.isEmpty() ? originalName : title);
        video.setVideoUrl(url);
        video.setSourceType("LOCAL");
        return Result.success(stockService.addVideo(video));
    }

    @PreAuthorize("hasAnyRole('ADMIN', 'SALES_MANAGER')")
    @DeleteMapping("/vehicles/{vehicleId}/videos/{videoId}")
    public Result<?> deleteVideo(@PathVariable Long vehicleId, @PathVariable Long videoId) {
        stockService.deleteVideo(videoId);
        return Result.success();
    }
}
