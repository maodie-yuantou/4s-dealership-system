package com.cardealership.modules.system.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.cardealership.modules.system.entity.SysPermission;
import com.cardealership.modules.system.entity.SysRolePermission;
import com.cardealership.modules.system.mapper.SysPermissionMapper;
import com.cardealership.modules.system.mapper.SysRolePermissionMapper;
import com.cardealership.modules.system.mapper.SysUserRoleMapper;
import com.cardealership.modules.system.entity.SysUserRole;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class SysPermissionService {
    private final SysPermissionMapper permissionMapper;
    private final SysRolePermissionMapper rolePermissionMapper;
    private final SysUserRoleMapper userRoleMapper;

    public List<SysPermission> buildTree(List<SysPermission> all) {
        List<SysPermission> trees = new ArrayList<>();
        for (SysPermission p : all) {
            if (p.getParentId() == 0) {
                p.setChildren(getChildren(p, all));
                trees.add(p);
            }
        }
        return trees;
    }

    private List<SysPermission> getChildren(SysPermission parent, List<SysPermission> all) {
        List<SysPermission> children = new ArrayList<>();
        for (SysPermission p : all) {
            if (p.getParentId().equals(parent.getId())) {
                p.setChildren(getChildren(p, all));
                children.add(p);
            }
        }
        return children;
    }

    public List<SysPermission> listAll() {
        return permissionMapper.selectList(
                new LambdaQueryWrapper<SysPermission>().orderByAsc(SysPermission::getSortOrder));
    }

    public List<SysPermission> getTree() {
        return buildTree(listAll());
    }

    public SysPermission getById(Long id) {
        return permissionMapper.selectById(id);
    }

    @Transactional
    public void save(SysPermission perm) {
        if (perm.getId() == null) {
            permissionMapper.insert(perm);
        } else {
            permissionMapper.updateById(perm);
        }
    }

    @Transactional
    public void delete(Long id) {
        permissionMapper.deleteById(id);
    }

    public List<SysPermission> getByUserId(Long userId) {
        List<SysUserRole> urList = userRoleMapper.selectList(
                new LambdaQueryWrapper<SysUserRole>().eq(SysUserRole::getUserId, userId));
        if (urList.isEmpty()) return List.of();
        List<Long> roleIds = urList.stream().map(SysUserRole::getRoleId).toList();
        List<SysRolePermission> rpList = rolePermissionMapper.selectList(
                new LambdaQueryWrapper<SysRolePermission>().in(SysRolePermission::getRoleId, roleIds));
        if (rpList.isEmpty()) return List.of();
        List<Long> permIds = rpList.stream().map(SysRolePermission::getPermissionId).distinct().toList();
        return permissionMapper.selectList(
                new LambdaQueryWrapper<SysPermission>()
                        .in(SysPermission::getId, permIds)
                        .eq(SysPermission::getStatus, 1)
                        .orderByAsc(SysPermission::getSortOrder));
    }
}
