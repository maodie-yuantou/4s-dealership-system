package com.cardealership.modules.system.controller;

import com.cardealership.common.dto.Result;
import com.cardealership.modules.system.entity.SysDict;
import com.cardealership.modules.system.entity.SysDictType;
import com.cardealership.modules.system.service.SysDictService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/system/dict")
@RequiredArgsConstructor
public class SysDictController {
    private final SysDictService dictService;

    @GetMapping("/types")
    @PreAuthorize("hasRole('ADMIN')")
    public Result<List<SysDictType>> types() {
        return Result.success(dictService.listTypes());
    }

    @PostMapping("/types")
    @PreAuthorize("hasRole('ADMIN')")
    public Result<?> saveType(@RequestBody SysDictType type) {
        dictService.saveType(type);
        return Result.success();
    }

    @DeleteMapping("/types/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public Result<?> deleteType(@PathVariable Long id) {
        dictService.deleteType(id);
        return Result.success();
    }

    @GetMapping("/{typeCode}")
    @PreAuthorize("hasRole('ADMIN')")
    public Result<List<SysDict>> listByType(@PathVariable String typeCode) {
        return Result.success(dictService.listByTypeCode(typeCode));
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public Result<?> save(@RequestBody SysDict dict) {
        dictService.saveDict(dict);
        return Result.success();
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public Result<?> delete(@PathVariable Long id) {
        dictService.deleteDict(id);
        return Result.success();
    }
}
