package com.cardealership.modules.system.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.cardealership.modules.system.entity.SysDept;
import com.cardealership.modules.system.entity.SysRole;
import com.cardealership.modules.system.entity.SysUser;
import com.cardealership.modules.system.entity.SysUserRole;
import com.cardealership.modules.system.mapper.*;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.util.List;

@Service
@RequiredArgsConstructor
public class SysUserService {
    private final SysUserMapper userMapper;
    private final SysUserRoleMapper userRoleMapper;
    private final SysRoleMapper roleMapper;
    private final SysDeptMapper deptMapper;
    private final PasswordEncoder passwordEncoder;

    public Page<SysUser> page(int page, int size, String keyword, Long deptId, Integer status) {
        LambdaQueryWrapper<SysUser> q = new LambdaQueryWrapper<>();
        if (StringUtils.hasText(keyword)) {
            q.and(w -> w.like(SysUser::getUsername, keyword)
                    .or().like(SysUser::getRealName, keyword)
                    .or().like(SysUser::getPhone, keyword));
        }
        if (deptId != null) q.eq(SysUser::getDeptId, deptId);
        if (status != null) q.eq(SysUser::getStatus, status);
        q.orderByDesc(SysUser::getCreatedAt);
        Page<SysUser> result = userMapper.selectPage(new Page<>(page, size), q);
        for (SysUser user : result.getRecords()) {
            if (user.getDeptId() != null) {
                SysDept dept = deptMapper.selectById(user.getDeptId());
                if (dept != null) user.setDeptName(dept.getDeptName());
            }
            List<SysUserRole> urList = userRoleMapper.selectList(
                    new LambdaQueryWrapper<SysUserRole>().eq(SysUserRole::getUserId, user.getId()));
            List<Long> roleIds = urList.stream().map(SysUserRole::getRoleId).toList();
            if (!roleIds.isEmpty()) {
                user.setRoleCodes(roleMapper.selectBatchIds(roleIds).stream()
                        .map(SysRole::getRoleCode).toList());
            }
        }
        return result;
    }

    public SysUser getById(Long id) {
        return userMapper.selectById(id);
    }

    public SysUser getByUsername(String username) {
        return userMapper.selectOne(new LambdaQueryWrapper<SysUser>().eq(SysUser::getUsername, username));
    }

    @Transactional
    public void create(SysUser user) {
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        userMapper.insert(user);
    }

    @Transactional
    public void update(SysUser user) {
        if (StringUtils.hasText(user.getPassword())) {
            user.setPassword(passwordEncoder.encode(user.getPassword()));
        } else {
            user.setPassword(null);
        }
        userMapper.updateById(user);
    }

    @Transactional
    public void updateStatus(Long id, Integer status) {
        SysUser user = new SysUser();
        user.setId(id);
        user.setStatus(status);
        userMapper.updateById(user);
    }

    @Transactional
    public void assignRoles(Long userId, List<Long> roleIds) {
        userRoleMapper.delete(new LambdaQueryWrapper<SysUserRole>().eq(SysUserRole::getUserId, userId));
        if (roleIds != null && !roleIds.isEmpty()) {
            for (Long roleId : roleIds) {
                SysUserRole ur = new SysUserRole();
                ur.setUserId(userId);
                ur.setRoleId(roleId);
                userRoleMapper.insert(ur);
            }
        }
    }

    @Transactional
    public void resetPassword(Long id, String password) {
        SysUser user = new SysUser();
        user.setId(id);
        user.setPassword(passwordEncoder.encode(password));
        userMapper.updateById(user);
    }

    public List<Long> getUserRoleIds(Long userId) {
        return userRoleMapper.selectList(
                new LambdaQueryWrapper<SysUserRole>().eq(SysUserRole::getUserId, userId))
                .stream().map(SysUserRole::getRoleId).toList();
    }
}
