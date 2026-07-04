package com.cardealership.modules.sale.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@TableName("sale_opportunity")
public class SaleOpportunity {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long customerId;
    private Long leadId;
    private Long vehicleModelId;
    private String intentColor;
    private String intentConfig;
    private String paymentMethod;
    private String status;
    private LocalDate expectedCloseDate;
    private Long assigneeId;
    private String remark;
    @TableLogic private Integer isDeleted;
    private Long createdBy;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    @TableField(exist = false) private String customerName;
    @TableField(exist = false) private String assigneeName;
}
