package com.cardealership.modules.service.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("svc_settlement")
public class SvcSettlement {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long workOrderId;
    private BigDecimal laborFee;
    private BigDecimal partsFee;
    private BigDecimal materialFee;
    private BigDecimal outsourcedFee;
    private BigDecimal discount;
    private BigDecimal totalAmount;
    private String paymentMethod;
    private String paymentStatus;
    private BigDecimal paidAmount;
    private Long settledBy;
    private LocalDateTime settledAt;
    @TableLogic private Integer isDeleted;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
