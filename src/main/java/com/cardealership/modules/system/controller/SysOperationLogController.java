package com.cardealership.modules.system.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.cardealership.common.dto.Result;
import com.cardealership.modules.system.entity.SysOperationLog;
import com.cardealership.modules.system.service.SysOperationLogService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/system/logs")
@RequiredArgsConstructor
public class SysOperationLogController {
    private final SysOperationLogService logService;

    @GetMapping
    @PreAuthorize("hasRole('ADMIN')")
    public Result<Page<SysOperationLog>> list(@RequestParam(defaultValue = "1") int page,
                                               @RequestParam(defaultValue = "10") int size,
                                               @RequestParam(required = false) String module,
                                               @RequestParam(required = false) String username) {
        return Result.success(logService.page(page, size, module, username));
    }
}
