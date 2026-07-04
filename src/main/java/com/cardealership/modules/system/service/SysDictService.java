package com.cardealership.modules.system.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.cardealership.modules.system.entity.SysDict;
import com.cardealership.modules.system.entity.SysDictType;
import com.cardealership.modules.system.mapper.SysDictMapper;
import com.cardealership.modules.system.mapper.SysDictTypeMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class SysDictService {
    private final SysDictMapper dictMapper;
    private final SysDictTypeMapper dictTypeMapper;

    public List<SysDictType> listTypes() {
        return dictTypeMapper.selectList(new LambdaQueryWrapper<>());
    }

    @Transactional
    public void saveType(SysDictType type) {
        if (type.getId() == null) dictTypeMapper.insert(type);
        else dictTypeMapper.updateById(type);
    }

    @Transactional
    public void deleteType(Long id) {
        dictTypeMapper.deleteById(id);
        dictMapper.delete(new LambdaQueryWrapper<SysDict>().eq(SysDict::getDictTypeId, id));
    }

    public List<SysDict> listByTypeCode(String typeCode) {
        SysDictType type = dictTypeMapper.selectOne(
                new LambdaQueryWrapper<SysDictType>().eq(SysDictType::getDictCode, typeCode));
        if (type == null) return List.of();
        return dictMapper.selectList(
                new LambdaQueryWrapper<SysDict>()
                        .eq(SysDict::getDictTypeId, type.getId())
                        .orderByAsc(SysDict::getSortOrder));
    }

    @Transactional
    public void saveDict(SysDict dict) {
        if (dict.getId() == null) dictMapper.insert(dict);
        else dictMapper.updateById(dict);
    }

    @Transactional
    public void deleteDict(Long id) {
        dictMapper.deleteById(id);
    }
}
