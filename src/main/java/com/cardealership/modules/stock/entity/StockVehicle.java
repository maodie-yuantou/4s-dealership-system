package com.cardealership.modules.stock.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@TableName("stock_vehicle")
public class StockVehicle {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String vin;
    private String engineNo;
    private String brand;
    private String model;
    private Integer modelYear;
    private String vehicleType;
    private String color;
    private String imageUrl;
    private String configDetail;
    private LocalDate productionDate;
    private BigDecimal guidePrice;
    private BigDecimal costPrice;
    private String status;
    private String location;
    private LocalDate inboundDate;
    private LocalDate outboundDate;
    @TableLogic private Integer isDeleted;
    private Long createdBy;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
