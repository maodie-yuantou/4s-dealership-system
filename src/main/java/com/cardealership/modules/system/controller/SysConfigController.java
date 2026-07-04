package com.cardealership.modules.system.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.cardealership.common.dto.Result;
import com.cardealership.modules.system.entity.SysConfig;
import com.cardealership.modules.system.service.SysConfigService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/system/configs")
@RequiredArgsConstructor
public class SysConfigController {
    private final SysConfigService configService;

    @GetMapping
    @PreAuthorize("hasRole('ADMIN')")
    public Result<Page<SysConfig>> list(@RequestParam(defaultValue = "1") int page,
                                         @RequestParam(defaultValue = "20") int size) {
        return Result.success(configService.page(page, size));
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public Result<?> save(@RequestBody SysConfig config) {
        configService.save(config);
        return Result.success();
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public Result<?> update(@PathVariable Long id, @RequestBody SysConfig config) {
        config.setId(id);
        configService.save(config);
        return Result.success();
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public Result<?> delete(@PathVariable Long id) {
        configService.delete(id);
        return Result.success();
    }
}
