package com.cardealership.modules.system.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.cardealership.modules.system.entity.SysOperationLog;
import com.cardealership.modules.system.mapper.SysOperationLogMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class SysOperationLogService {
    private final SysOperationLogMapper logMapper;

    public Page<SysOperationLog> page(int page, int size, String module, String username) {
        LambdaQueryWrapper<SysOperationLog> q = new LambdaQueryWrapper<>();
        if (module != null && !module.isEmpty()) q.eq(SysOperationLog::getModule, module);
        if (username != null && !username.isEmpty()) q.like(SysOperationLog::getUsername, username);
        q.orderByDesc(SysOperationLog::getCreatedAt);
        return logMapper.selectPage(new Page<>(page, size), q);
    }

    public void save(SysOperationLog log) {
        logMapper.insert(log);
    }
}
