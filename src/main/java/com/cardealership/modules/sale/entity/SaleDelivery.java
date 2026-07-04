package com.cardealership.modules.sale.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("sale_delivery")
public class SaleDelivery {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long orderId;
    private Long stockVehicleId;
    private String pdiStatus;
    private Long pdiCheckerId;
    private LocalDateTime pdiTime;
    private String washStatus;
    private Integer documentPrepared;
    private LocalDateTime ceremonyTime;
    private String customerInterviewResult;
    private String deliveryStatus;
    private LocalDateTime deliveredAt;
    @TableLogic private Integer isDeleted;
    private Long createdBy;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
