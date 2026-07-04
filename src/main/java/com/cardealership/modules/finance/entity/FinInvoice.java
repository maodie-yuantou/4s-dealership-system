package com.cardealership.modules.finance.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("fin_invoice")
public class FinInvoice {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String invoiceNo;
    private String invoiceType;
    private Long orderId;
    private Long workOrderId;
    private String customerName;
    private BigDecimal amount;
    private BigDecimal taxAmount;
    private BigDecimal totalAmount;
    private String status;
    private Long issuedBy;
    private LocalDateTime issuedAt;
    private LocalDateTime voidedAt;
    private String voidReason;
    private String filePath;
    @TableLogic private Integer isDeleted;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
