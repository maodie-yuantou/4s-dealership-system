package com.cardealership.modules.client.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("rescue_order")
public class RescueOrder {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String rescueNo;
    private Long customerId;
    private Long vehicleId;
    private String contactName;
    private String contactPhone;
    private BigDecimal latitude;
    private BigDecimal longitude;
    private String address;
    private String rescueType;
    private String description;
    private String status;
    private Long dispatcherId;
    private String rescueCompany;
    private LocalDateTime arrivedAt;
    private LocalDateTime completedAt;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
