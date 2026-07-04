package com.cardealership.modules.client.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("customer_points")
public class CustomerPoints {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long customerId;
    private Integer totalPoints;
    private Integer totalGrowth;
    private String memberLevel;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
