package com.cardealership.modules.client.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("ai_chat_history")
public class AiChatHistory {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String sessionId;
    private Long customerId;
    private String role;
    private String content;
    private LocalDateTime createdAt;
}
