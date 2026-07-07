package com.cardealership.modules.system.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.cardealership.modules.crm.entity.CrmCustomer;
import com.cardealership.modules.crm.mapper.CrmCustomerMapper;
import com.cardealership.modules.system.entity.SysUser;
import com.cardealership.modules.system.entity.SysUserRole;
import com.cardealership.modules.system.entity.SysRole;
import com.cardealership.modules.system.mapper.SysUserMapper;
import com.cardealership.modules.system.mapper.SysUserRoleMapper;
import com.cardealership.modules.system.mapper.SysRoleMapper;
import com.cardealership.security.JwtTokenProvider;
import com.cardealership.security.UserDetailsImpl;
import com.cardealership.service.RefreshTokenService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class AuthService {
    private final SysUserMapper userMapper;
    private final SysUserRoleMapper userRoleMapper;
    private final SysRoleMapper roleMapper;
    private final PasswordEncoder passwordEncoder;
    private final JwtTokenProvider jwtTokenProvider;
    private final RefreshTokenService refreshTokenService;
    private final CrmCustomerMapper customerMapper;

    public Map<String, Object> login(String username, String password) {
        SysUser user = userMapper.selectOne(
                new LambdaQueryWrapper<SysUser>().eq(SysUser::getUsername, username));
        if (user == null || !passwordEncoder.matches(password, user.getPassword()))
            throw new IllegalArgumentException("用户名或密码错误");
        if (user.getStatus() != null && user.getStatus() == 0)
            throw new IllegalArgumentException("账号已被禁用");

        List<String> roles = getUserRoles(user.getId());
        String accessToken = jwtTokenProvider.generateAccessToken(user.getId(), user.getUsername(), roles);
        String refreshToken = jwtTokenProvider.generateRefreshToken(user.getId(), user.getUsername());
        refreshTokenService.store(refreshToken, user.getId());

        Map<String, Object> result = new HashMap<>();
        result.put("accessToken", accessToken);
        result.put("token", accessToken);
        result.put("refreshToken", refreshToken);
        result.put("userId", user.getId());
        result.put("username", user.getUsername());
        result.put("realName", user.getRealName());
        result.put("phone", user.getPhone());
        result.put("roles", roles);
        CrmCustomer c = customerMapper.selectOne(new LambdaQueryWrapper<CrmCustomer>().eq(CrmCustomer::getPhone, user.getPhone()));
        if (c != null) result.put("customerId", c.getId());
        return result;
    }

    public Map<String, Object> register(String username, String password, String realName, String phone) {
        if (userMapper.selectOne(new LambdaQueryWrapper<SysUser>().eq(SysUser::getUsername, username)) != null)
            throw new IllegalArgumentException("用户名已存在");

        SysUser user = new SysUser();
        user.setUsername(username);
        user.setPassword(passwordEncoder.encode(password));
        user.setRealName(realName);
        user.setPhone(phone);
        user.setStatus(1);
        userMapper.insert(user);

        SysUserRole ur = new SysUserRole();
        ur.setUserId(user.getId());
        ur.setRoleId(3L);
        userRoleMapper.insert(ur);

        CrmCustomer customer = null;
        if (phone != null && !phone.isEmpty()) {
            customer = customerMapper.selectOne(new LambdaQueryWrapper<CrmCustomer>().eq(CrmCustomer::getPhone, phone));
            if (customer == null) {
                customer = new CrmCustomer();
                customer.setName(realName != null ? realName : username);
                customer.setPhone(phone);
                customer.setCustomerType("OWNER");
                customer.setGrade("C");
                customerMapper.insert(customer);
            }
        }

        List<String> roles = getUserRoles(user.getId());
        String accessToken = jwtTokenProvider.generateAccessToken(user.getId(), user.getUsername(), roles);
        String refreshToken = jwtTokenProvider.generateRefreshToken(user.getId(), user.getUsername());
        refreshTokenService.store(refreshToken, user.getId());

        Map<String, Object> result = new HashMap<>();
        result.put("accessToken", accessToken);
        result.put("refreshToken", refreshToken);
        result.put("userId", user.getId());
        result.put("username", user.getUsername());
        result.put("realName", user.getRealName());
        result.put("phone", phone);
        result.put("roles", roles);
        if (customer != null) result.put("customerId", customer.getId());
        return result;
    }

    public Map<String, Object> refreshAccessToken(String refreshToken) {
        Long userId = refreshTokenService.validate(refreshToken);
        if (userId == null) throw new IllegalArgumentException("Refresh token 无效或已过期");
        SysUser user = userMapper.selectById(userId);
        if (user == null || (user.getStatus() != null && user.getStatus() == 0))
            throw new IllegalArgumentException("用户不存在或已禁用");
        refreshTokenService.delete(refreshToken);
        List<String> roles = getUserRoles(userId);
        String newAccessToken = jwtTokenProvider.generateAccessToken(userId, user.getUsername(), roles);
        String newRefreshToken = jwtTokenProvider.generateRefreshToken(userId, user.getUsername());
        refreshTokenService.store(newRefreshToken, userId);
        Map<String, Object> result = new HashMap<>();
        result.put("accessToken", newAccessToken);
        result.put("refreshToken", newRefreshToken);
        return result;
    }

    public void verifyIdentity(String username, String realName) {
        SysUser user = userMapper.selectOne(new LambdaQueryWrapper<SysUser>().eq(SysUser::getUsername, username));
        if (user == null) throw new IllegalArgumentException("用户不存在");
        if (realName == null || !realName.equals(user.getRealName()))
            throw new IllegalArgumentException("真实姓名验证失败");
    }

    public void resetPassword(String username, String realName, String newPassword) {
        SysUser user = userMapper.selectOne(new LambdaQueryWrapper<SysUser>().eq(SysUser::getUsername, username));
        if (user == null) throw new IllegalArgumentException("用户不存在");
        if (realName == null || !realName.equals(user.getRealName()))
            throw new IllegalArgumentException("真实姓名验证失败");
        if (newPassword == null || newPassword.length() < 6)
            throw new IllegalArgumentException("密码不能少于6位");
        user.setPassword(passwordEncoder.encode(newPassword));
        userMapper.updateById(user);
    }

    public SysUser updateProfile(String realName, String phone, String email) {
        SysUser user = getCurrentUser();
        if (realName != null) user.setRealName(realName);
        if (phone != null) { user.setPhone(phone); syncCrmCustomer(user); }
        if (email != null) user.setEmail(email);
        userMapper.updateById(user);
        user.setPassword(null);
        return user;
    }

    private void syncCrmCustomer(SysUser user) {
        if (user.getPhone() == null || user.getPhone().isEmpty()) return;
        CrmCustomer c = customerMapper.selectOne(new LambdaQueryWrapper<CrmCustomer>().eq(CrmCustomer::getPhone, user.getPhone()));
        if (c == null) {
            c = new CrmCustomer();
            c.setName(user.getRealName() != null ? user.getRealName() : user.getUsername());
            c.setPhone(user.getPhone());
            c.setCustomerType("OWNER");
            c.setGrade("C");
            customerMapper.insert(c);
        } else {
            c.setName(user.getRealName() != null ? user.getRealName() : user.getUsername());
            customerMapper.updateById(c);
        }
    }

    public void changePassword(String oldPassword, String newPassword) {
        SysUser user = getCurrentUser();
        if (!passwordEncoder.matches(oldPassword, user.getPassword()))
            throw new IllegalArgumentException("原密码输入错误");
        if (newPassword == null || newPassword.length() < 6)
            throw new IllegalArgumentException("密码不能少于6位");
        user.setPassword(passwordEncoder.encode(newPassword));
        userMapper.updateById(user);
    }

    public void updateAvatar(String url) {
        SysUser user = getCurrentUser();
        user.setAvatar(url);
        userMapper.updateById(user);
    }

    public SysUser getCurrentUser() {
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        if (principal instanceof UserDetailsImpl ud) {
            SysUser user = userMapper.selectById(ud.getUserId());
            if (user != null) {
                user.setPassword(null);
                user.setRoleCodes(getUserRoles(user.getId()));
            }
            return user;
        }
        return null;
    }

    public List<String> getUserRoles(Long userId) {
        List<SysUserRole> urList = userRoleMapper.selectList(
                new LambdaQueryWrapper<SysUserRole>().eq(SysUserRole::getUserId, userId));
        if (urList.isEmpty()) return List.of();
        List<Long> roleIds = urList.stream().map(SysUserRole::getRoleId).toList();
        return roleMapper.selectBatchIds(roleIds).stream().map(SysRole::getRoleCode).toList();
    }
}
