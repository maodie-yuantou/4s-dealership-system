package com.cardealership;

import com.cardealership.modules.system.entity.SysUser;
import com.cardealership.modules.system.entity.SysUserRole;
import com.cardealership.modules.system.entity.SysRole;
import com.cardealership.modules.system.mapper.SysUserMapper;
import com.cardealership.modules.system.mapper.SysUserRoleMapper;
import com.cardealership.modules.system.mapper.SysRoleMapper;
import com.cardealership.modules.system.service.AuthService;
import com.cardealership.security.JwtTokenProvider;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AuthServiceTest {

    @Mock private SysUserMapper userMapper;
    @Mock private SysUserRoleMapper userRoleMapper;
    @Mock private SysRoleMapper roleMapper;
    @Mock private PasswordEncoder passwordEncoder;
    @Mock private JwtTokenProvider jwtTokenProvider;

    private AuthService authService;

    @BeforeEach
    void setUp() {
        authService = new AuthService(userMapper, userRoleMapper, roleMapper,
            passwordEncoder, jwtTokenProvider);
    }

    @Test
    void shouldLoginSuccessfully() {
        SysUser user = new SysUser();
        user.setId(1L);
        user.setUsername("admin");
        user.setPassword("encoded_pw");
        user.setRealName("管理员");

        when(userMapper.selectOne(any())).thenReturn(user);
        when(passwordEncoder.matches("admin123", "encoded_pw")).thenReturn(true);

        SysUserRole ur = new SysUserRole();
        ur.setUserId(1L);
        ur.setRoleId(1L);
        when(userRoleMapper.selectList(any())).thenReturn(List.of(ur));

        SysRole role = new SysRole();
        role.setId(1L);
        role.setRoleCode("ADMIN");
        when(roleMapper.selectBatchIds(any())).thenReturn(List.of(role));

        when(jwtTokenProvider.generateToken(eq(1L), eq("admin"), any()))
            .thenReturn("test.jwt.token");

        Map<String, Object> result = authService.login("admin", "admin123");

        assertEquals("test.jwt.token", result.get("token"));
        assertEquals("admin", result.get("username"));
        assertEquals("管理员", result.get("realName"));
        assertTrue(((List<?>) result.get("roles")).contains("ADMIN"));
    }

    @Test
    void shouldRejectWrongPassword() {
        SysUser user = new SysUser();
        user.setUsername("admin");
        user.setPassword("encoded_pw");

        when(userMapper.selectOne(any())).thenReturn(user);
        when(passwordEncoder.matches("wrong", "encoded_pw")).thenReturn(false);

        assertThrows(IllegalArgumentException.class,
            () -> authService.login("admin", "wrong"),
            "用户名或密码错误");
    }

    @Test
    void shouldRejectNonexistentUser() {
        when(userMapper.selectOne(any())).thenReturn(null);

        assertThrows(IllegalArgumentException.class,
            () -> authService.login("nobody", "whatever"),
            "用户名或密码错误");
    }
}
