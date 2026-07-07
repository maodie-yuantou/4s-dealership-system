package com.cardealership.common.mq;

import com.cardealership.config.RabbitMQConfig;
import com.cardealership.modules.client.entity.AiChatHistory;
import com.cardealership.modules.client.mapper.AiChatHistoryMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Component
@RequiredArgsConstructor
public class ChatHistoryConsumer {

    private final AiChatHistoryMapper chatHistoryMapper;

    @RabbitListener(queues = RabbitMQConfig.QUEUE_CHAT_HISTORY)
    @Transactional
    public void handle(AiChatHistory message) {
        chatHistoryMapper.insert(message);
    }
}
