package com.cardealership.modules.client.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@TableName("valuation_request")
public class ValuationRequest {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long customerId;
    private Long vehicleId;
    private String brand;
    private String model;
    private Integer modelYear;
    private Integer mileage;
    private String licensePlate;
    private LocalDate purchaseDate;
    private BigDecimal estimatedPrice;
    private BigDecimal manualPrice;
    private String status;
    private Long evaluatorId;
    private String remark;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
