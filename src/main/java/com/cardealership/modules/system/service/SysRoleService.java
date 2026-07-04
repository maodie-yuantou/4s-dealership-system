package com.cardealership.modules.system.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.cardealership.modules.system.entity.SysRole;
import com.cardealership.modules.system.entity.SysRolePermission;
import com.cardealership.modules.system.mapper.SysRoleMapper;
import com.cardealership.modules.system.mapper.SysRolePermissionMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class SysRoleService {
    private final SysRoleMapper roleMapper;
    private final SysRolePermissionMapper rolePermissionMapper;

    public List<SysRole> listAll() {
        return roleMapper.selectList(new LambdaQueryWrapper<SysRole>().orderByAsc(SysRole::getRoleCode));
    }

    public Page<SysRole> page(int page, int size) {
        return roleMapper.selectPage(new Page<>(page, size),
                new LambdaQueryWrapper<SysRole>().orderByAsc(SysRole::getRoleCode));
    }

    public SysRole getById(Long id) {
        SysRole role = roleMapper.selectById(id);
        if (role != null) {
            role.setPermissionIds(rolePermissionMapper.selectList(
                    new LambdaQueryWrapper<SysRolePermission>().eq(SysRolePermission::getRoleId, id))
                    .stream().map(SysRolePermission::getPermissionId).toList());
        }
        return role;
    }

    @Transactional
    public void save(SysRole role) {
        if (role.getId() == null) {
            roleMapper.insert(role);
        } else {
            roleMapper.updateById(role);
        }
    }

    @Transactional
    public void delete(Long id) {
        roleMapper.deleteById(id);
        rolePermissionMapper.delete(new LambdaQueryWrapper<SysRolePermission>().eq(SysRolePermission::getRoleId, id));
    }

    @Transactional
    public void assignPermissions(Long roleId, List<Long> permIds) {
        rolePermissionMapper.delete(new LambdaQueryWrapper<SysRolePermission>().eq(SysRolePermission::getRoleId, roleId));
        if (permIds != null && !permIds.isEmpty()) {
            for (Long permId : permIds) {
                SysRolePermission rp = new SysRolePermission();
                rp.setRoleId(roleId);
                rp.setPermissionId(permId);
                rolePermissionMapper.insert(rp);
            }
        }
    }
}
