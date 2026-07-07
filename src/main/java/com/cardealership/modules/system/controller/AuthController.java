package com.cardealership.modules.system.controller;

import com.cardealership.common.dto.Result;
import com.cardealership.modules.system.entity.SysUser;
import com.cardealership.modules.system.service.AuthService;
import com.cardealership.service.MinioService;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.Map;

@Tag(name = "认证管理", description = "登录、注册、个人中心")
@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {
    private final AuthService authService;
    private final MinioService minioService;

    @PostMapping("/login")
    public Result<Map<String, Object>> login(@RequestBody Map<String, String> body) {
        String username = body.get("username");
        String password = body.get("password");
        return Result.success(authService.login(username, password));
    }

    @PostMapping("/register")
    public Result<Map<String, Object>> register(@RequestBody Map<String, String> body) {
        String username = body.get("username");
        String password = body.get("password");
        String realName = body.getOrDefault("realName", username);
        String phone = body.getOrDefault("phone", "");
        return Result.success(authService.register(username, password, realName, phone));
    }

    @PostMapping("/refresh")
    public Result<Map<String, Object>> refresh(@RequestBody Map<String, String> body) {
        return Result.success(authService.refreshAccessToken(body.get("refreshToken")));
    }

    @PostMapping("/verify-identity")
    public Result<String> verifyIdentity(@RequestBody Map<String, String> body) {
        String username = body.get("username");
        String realName = body.get("realName");
        authService.verifyIdentity(username, realName);
        return Result.success("验证通过");
    }

    @PostMapping("/reset-password")
    public Result<String> resetPassword(@RequestBody Map<String, String> body) {
        String username = body.get("username");
        String realName = body.get("realName");
        String newPassword = body.get("newPassword");
        authService.resetPassword(username, realName, newPassword);
        return Result.success("密码重置成功");
    }

    @GetMapping("/me")
    public Result<SysUser> me() {
        return Result.success(authService.getCurrentUser());
    }

    @PutMapping("/profile")
    public Result<SysUser> updateProfile(@RequestBody Map<String, String> body) {
        return Result.success(authService.updateProfile(
            body.get("realName"), body.get("phone"), body.get("email")));
    }

    @PostMapping("/change-password")
    public Result<String> changePassword(@RequestBody Map<String, String> body) {
        authService.changePassword(body.get("oldPassword"), body.get("newPassword"));
        return Result.success("密码修改成功");
    }

    @PostMapping("/avatar")
    public Result<String> uploadAvatar(@RequestParam("file") MultipartFile file) throws IOException {
        String url = minioService.upload(file, "avatars");
        authService.updateAvatar(url);
        return Result.success(url);
    }
}
