package com.cardealership.modules.system.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.cardealership.modules.system.entity.SysConfig;
import com.cardealership.modules.system.mapper.SysConfigMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class SysConfigService {
    private final SysConfigMapper configMapper;

    public Page<SysConfig> page(int page, int size) {
        return configMapper.selectPage(new Page<>(page, size),
                new LambdaQueryWrapper<SysConfig>().orderByAsc(SysConfig::getConfigKey));
    }

    public String getValue(String key) {
        SysConfig config = configMapper.selectOne(
                new LambdaQueryWrapper<SysConfig>().eq(SysConfig::getConfigKey, key));
        return config != null ? config.getConfigValue() : null;
    }

    @Transactional
    public void save(SysConfig config) {
        if (config.getId() == null) configMapper.insert(config);
        else configMapper.updateById(config);
    }

    @Transactional
    public void delete(Long id) {
        configMapper.deleteById(id);
    }
}
