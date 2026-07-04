package com.cardealership.modules.stock.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("stock_accessory")
public class StockAccessory {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String accessoryCode;
    private String accessoryName;
    private String category;
    private String unit;
    private BigDecimal price;
    private Integer quantity;
    private Integer alertQuantity;
    private Integer status;
    @TableLogic private Integer isDeleted;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
