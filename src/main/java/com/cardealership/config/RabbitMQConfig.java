package com.cardealership.config;

import org.springframework.amqp.core.Queue;
import org.springframework.amqp.support.converter.Jackson2JsonMessageConverter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;

@Configuration
@Profile("!test")
public class RabbitMQConfig {

    public static final String QUEUE_CHAT_HISTORY = "queue.chat.history";
    public static final String QUEUE_APPOINTMENT_NOTIFY = "queue.appointment.notify";

    @Bean
    public Queue chatHistoryQueue() {
        return new Queue(QUEUE_CHAT_HISTORY, true);
    }

    @Bean
    public Queue appointmentNotifyQueue() {
        return new Queue(QUEUE_APPOINTMENT_NOTIFY, true);
    }

    @Bean
    public Jackson2JsonMessageConverter messageConverter() {
        return new Jackson2JsonMessageConverter();
    }
}
