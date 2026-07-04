package com.cardealership.modules.stock.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@TableName("stock_check")
public class StockCheck {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String checkNo;
    private String checkType;
    private LocalDate checkDate;
    private String status;
    private String profitLossSummary;
    private Long createdBy;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
