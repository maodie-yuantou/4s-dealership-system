package com.cardealership.modules.system.controller;

import com.cardealership.common.dto.Result;
import com.cardealership.modules.system.entity.SysDept;
import com.cardealership.modules.system.service.SysDeptService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/system/depts")
@RequiredArgsConstructor
public class SysDeptController {
    private final SysDeptService deptService;

    @GetMapping("/tree")
    @PreAuthorize("hasRole('ADMIN')")
    public Result<List<SysDept>> tree() {
        return Result.success(deptService.getTree());
    }

    @GetMapping
    @PreAuthorize("hasRole('ADMIN')")
    public Result<List<SysDept>> list() {
        return Result.success(deptService.listAll());
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public Result<?> save(@RequestBody SysDept dept) {
        deptService.save(dept);
        return Result.success();
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public Result<?> update(@PathVariable Long id, @RequestBody SysDept dept) {
        dept.setId(id);
        deptService.save(dept);
        return Result.success();
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public Result<?> delete(@PathVariable Long id) {
        deptService.delete(id);
        return Result.success();
    }
}
