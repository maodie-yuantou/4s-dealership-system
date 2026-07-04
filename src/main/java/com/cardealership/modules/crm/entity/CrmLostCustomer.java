package com.cardealership.modules.crm.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("crm_lost_customer")
public class CrmLostCustomer {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long customerId;
    private Long leadId;
    private String lostReason;
    private String detail;
    private String reviewStatus;
    private Long reviewerId;
    private String reviewComment;
    private Long createdBy;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    @TableField(exist = false)
    private String customerName;
}
