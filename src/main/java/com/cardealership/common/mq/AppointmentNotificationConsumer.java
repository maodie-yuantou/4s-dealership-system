package com.cardealership.common.mq;

import com.cardealership.config.RabbitMQConfig;
import com.cardealership.service.NotificationService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.stereotype.Component;

import java.util.Map;

@Slf4j
@Component
@RequiredArgsConstructor
public class AppointmentNotificationConsumer {

    private final NotificationService notificationService;

    @SuppressWarnings("unchecked")
    @RabbitListener(queues = RabbitMQConfig.QUEUE_APPOINTMENT_NOTIFY)
    public void handle(Map<String, Object> notification) {
        Long userId = Long.valueOf(notification.get("userId").toString());
        String title = (String) notification.get("title");
        String content = (String) notification.get("content");
        notificationService.sendToUser(userId, title, content);
    }
}
