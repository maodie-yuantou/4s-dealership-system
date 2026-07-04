package com.cardealership.modules.finance.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("fin_payment")
public class FinPayment {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String paymentNo;
    private String paymentType;
    private BigDecimal amount;
    private String paymentMethod;
    private String voucherNo;
    private Long orderId;
    private Long workOrderId;
    private Long customerId;
    private String payerName;
    private String remark;
    private String status;
    private Long receivedBy;
    private LocalDateTime paidAt;
    @TableLogic private Integer isDeleted;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
