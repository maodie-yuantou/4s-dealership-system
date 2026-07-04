package com.cardealership.modules.client.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@TableName("customer_vehicle")
public class CustomerVehicle {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long customerId;
    private String vin;
    private String licensePlate;
    private String brand;
    private String model;
    private Integer modelYear;
    private Integer mileage;
    private String engineNo;
    private String insuranceCompany;
    private LocalDate insuranceDueDate;
    private LocalDate inspectionDueDate;
    private Integer isDefault;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
