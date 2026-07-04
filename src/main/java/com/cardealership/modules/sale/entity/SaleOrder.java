package com.cardealership.modules.sale.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@TableName("sale_order")
public class SaleOrder {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String orderNo;
    private Long customerId;
    private Long opportunityId;
    private Long vehicleModelId;
    private Long stockVehicleId;
    private BigDecimal guidePrice;
    private BigDecimal discount;
    private BigDecimal purchaseTax;
    private BigDecimal insuranceAmount;
    private BigDecimal licenseFee;
    private BigDecimal accessoryAmount;
    private BigDecimal totalPrice;
    private BigDecimal deposit;
    private String paymentMethod;
    private String status;
    private Long assigneeId;
    private LocalDate signingDate;
    private LocalDate expectedDeliveryDate;
    private String remark;
    @TableLogic private Integer isDeleted;
    private Long createdBy;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    @TableField(exist = false) private String customerName;
}
