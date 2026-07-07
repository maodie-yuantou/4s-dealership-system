package com.cardealership.service;

import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import java.util.concurrent.TimeUnit;

@Service
@RequiredArgsConstructor
public class RefreshTokenService {
    private final StringRedisTemplate redisTemplate;
    private static final String PREFIX = "refresh:";

    public void store(String refreshToken, Long userId) {
        redisTemplate.opsForValue().set(PREFIX + refreshToken, String.valueOf(userId), 7, TimeUnit.DAYS);
    }

    public Long validate(String refreshToken) {
        String userIdStr = redisTemplate.opsForValue().get(PREFIX + refreshToken);
        return userIdStr != null ? Long.parseLong(userIdStr) : null;
    }

    public void delete(String refreshToken) {
        redisTemplate.delete(PREFIX + refreshToken);
    }
}
