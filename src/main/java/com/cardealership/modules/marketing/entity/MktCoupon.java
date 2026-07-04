package com.cardealership.modules.marketing.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@TableName("mkt_coupon")
public class MktCoupon {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String couponName;
    private String couponType;
    private BigDecimal faceValue;
    private BigDecimal thresholdAmount;
    private Integer totalQuantity;
    private Integer issuedQuantity;
    private Integer usedQuantity;
    private LocalDate validFrom;
    private LocalDate validTo;
    private String status;
    @TableLogic private Integer isDeleted;
    private Long createdBy;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
