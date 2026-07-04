package com.cardealership.modules.sale.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("sale_order_approval")
public class SaleOrderApproval {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long orderId;
    private String approvalLevel;
    private Long approverId;
    private String status;
    private String comment;
    private LocalDateTime approvedAt;
    private LocalDateTime createdAt;
}
