package com.cardealership.service;

import lombok.RequiredArgsConstructor;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import java.util.Map;

@Service
@RequiredArgsConstructor
public class NotificationService {

    private final SimpMessagingTemplate messagingTemplate;

    public void sendToUser(Long userId, String title, String content) {
        messagingTemplate.convertAndSendToUser(
                userId.toString(),
                "/queue/notifications",
                Map.of("title", title, "content", content, "timestamp", System.currentTimeMillis())
        );
    }

    public void broadcast(String title, String content) {
        messagingTemplate.convertAndSend(
                "/topic/notifications",
                Map.of("title", title, "content", content, "timestamp", System.currentTimeMillis())
        );
    }
}
