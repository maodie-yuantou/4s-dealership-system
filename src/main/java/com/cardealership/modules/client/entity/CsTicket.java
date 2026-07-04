package com.cardealership.modules.client.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("cs_ticket")
public class CsTicket {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String ticketNo;
    private Long customerId;
    private String customerName;
    private String phone;
    private String category;
    private String question;
    private String chatContext;
    private String status;
    private Long assigneeId;
    private String resolution;
    private String priority;
    private LocalDateTime createdAt;
    private LocalDateTime resolvedAt;
    private LocalDateTime updatedAt;
}
