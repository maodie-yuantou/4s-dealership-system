package com.cardealership.common.mq;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@RequiredArgsConstructor
public class RabbitMQMessageProducer {

    private final RabbitTemplate rabbitTemplate;

    public void sendMessage(String queue, Object message) {
        log.debug("MQ send: queue={}", queue);
        rabbitTemplate.convertAndSend(queue, message);
    }
}
