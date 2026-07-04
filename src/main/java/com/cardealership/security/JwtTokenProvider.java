package com.cardealership.security;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.util.Base64;
import java.util.Date;
import java.util.List;

@Component
public class JwtTokenProvider {

    private static final String SECRET = "NFNEZWFsZXJzaGlwU2VjcmV0S2V5MjAyNkZvckpXVFRva2VuR2VuZXJhdGlvbkFuZFZhbGlkYXRpb24=";
    private static final long EXPIRATION = 86400000;

    private final SecretKey key;

    public JwtTokenProvider() {
        byte[] keyBytes = Base64.getDecoder().decode(SECRET);
        this.key = Keys.hmacShaKeyFor(keyBytes);
    }

    public String generateToken(Long userId, String username, List<String> roles) {
        Date now = new Date();
        Date expiryDate = new Date(now.getTime() + EXPIRATION);

        return Jwts.builder()
                .subject(username)
                .claim("userId", userId)
                .claim("roles", String.join(",", roles))
                .issuedAt(now)
                .expiration(expiryDate)
                .signWith(key)
                .compact();
    }

    public String getUsernameFromToken(String token) {
        return getClaims(token).getSubject();
    }

    public Long getUserIdFromToken(String token) {
        return getClaims(token).get("userId", Long.class);
    }

    @SuppressWarnings("unchecked")
    public List<String> getRolesFromToken(String token) {
        String roles = getClaims(token).get("roles", String.class);
        if (roles == null || roles.isEmpty()) {
            return List.of();
        }
        return List.of(roles.split(","));
    }

    public boolean validateToken(String token) {
        try {
            getClaims(token);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    private Claims getClaims(String token) {
        return Jwts.parser()
                .verifyWith(key)
                .build()
                .parseSignedClaims(token)
                .getPayload();
    }
}
