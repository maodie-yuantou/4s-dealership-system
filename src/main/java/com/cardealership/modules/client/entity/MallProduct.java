package com.cardealership.modules.client.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("mall_product")
public class MallProduct {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String productName;
    private String category;
    private String imageUrl;
    private BigDecimal originalPrice;
    private BigDecimal salePrice;
    private Integer stock;
    private Integer sales;
    private String description;
    private String detailImages;
    private String status;
    private Integer sortOrder;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
