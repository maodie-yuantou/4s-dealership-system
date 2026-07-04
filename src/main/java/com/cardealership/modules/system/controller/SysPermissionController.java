package com.cardealership.modules.system.controller;

import com.cardealership.common.dto.Result;
import com.cardealership.modules.system.entity.SysPermission;
import com.cardealership.modules.system.service.SysPermissionService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/system/permissions")
@RequiredArgsConstructor
public class SysPermissionController {
    private final SysPermissionService permService;

    @GetMapping("/tree")
    @PreAuthorize("hasRole('ADMIN')")
    public Result<List<SysPermission>> tree() {
        return Result.success(permService.getTree());
    }

    @GetMapping
    @PreAuthorize("hasRole('ADMIN')")
    public Result<List<SysPermission>> list() {
        return Result.success(permService.listAll());
    }

    @GetMapping("/user/{userId}")
    @PreAuthorize("hasRole('ADMIN')")
    public Result<List<SysPermission>> userPermissions(@PathVariable Long userId) {
        return Result.success(permService.getByUserId(userId));
    }

    @GetMapping("/my")
    public Result<List<SysPermission>> myPermissions() {
        com.cardealership.security.UserDetailsImpl ud =
                (com.cardealership.security.UserDetailsImpl) org.springframework.security.core.context.SecurityContextHolder
                        .getContext().getAuthentication().getPrincipal();
        return Result.success(permService.getByUserId(ud.getUserId()));
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public Result<?> save(@RequestBody SysPermission perm) {
        permService.save(perm);
        return Result.success();
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public Result<?> update(@PathVariable Long id, @RequestBody SysPermission perm) {
        perm.setId(id);
        permService.save(perm);
        return Result.success();
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public Result<?> delete(@PathVariable Long id) {
        permService.delete(id);
        return Result.success();
    }
}
