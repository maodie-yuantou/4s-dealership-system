package com.cardealership.modules.system.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.cardealership.modules.system.entity.SysDept;
import com.cardealership.modules.system.mapper.SysDeptMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class SysDeptService {
    private final SysDeptMapper deptMapper;

    public List<SysDept> getTree() {
        List<SysDept> all = deptMapper.selectList(
                new LambdaQueryWrapper<SysDept>().orderByAsc(SysDept::getSortOrder));
        List<SysDept> trees = new ArrayList<>();
        for (SysDept d : all) {
            if (d.getParentId() == 0) {
                d.setChildren(getChildren(d, all));
                trees.add(d);
            }
        }
        return trees;
    }

    private List<SysDept> getChildren(SysDept parent, List<SysDept> all) {
        List<SysDept> children = new ArrayList<>();
        for (SysDept d : all) {
            if (d.getParentId().equals(parent.getId())) {
                d.setChildren(getChildren(d, all));
                children.add(d);
            }
        }
        return children;
    }

    public List<SysDept> listAll() {
        return deptMapper.selectList(
                new LambdaQueryWrapper<SysDept>().orderByAsc(SysDept::getSortOrder));
    }

    @Transactional
    public void save(SysDept dept) {
        if (dept.getId() == null) {
            deptMapper.insert(dept);
        } else {
            deptMapper.updateById(dept);
        }
    }

    @Transactional
    public void delete(Long id) {
        deptMapper.deleteById(id);
    }
}
