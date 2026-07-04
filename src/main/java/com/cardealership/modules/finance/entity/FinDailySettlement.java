package com.cardealership.modules.finance.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@TableName("fin_daily_settlement")
public class FinDailySettlement {
    @TableId(type = IdType.AUTO)
    private Long id;
    private LocalDate settleDate;
    private Long settleBy;
    private BigDecimal cashAmount;
    private BigDecimal cardAmount;
    private BigDecimal wechatAmount;
    private BigDecimal alipayAmount;
    private BigDecimal transferAmount;
    private BigDecimal totalAmount;
    private BigDecimal bankAmount;
    private BigDecimal diffAmount;
    private String status;
    private Long confirmedBy;
    private LocalDateTime confirmedAt;
    @TableLogic private Integer isDeleted;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
