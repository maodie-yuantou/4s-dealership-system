package com.cardealership.modules.crm.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("crm_lead")
public class CrmLead {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String customerName;
    private String phone;
    private String source;
    private String sourceChannel;
    private Long intentVehicleId;
    private String intentModel;
    private String budgetRange;
    private String status;
    private Long assigneeId;
    private LocalDateTime assignTime;
    private Integer claimDays;
    private String lostReason;
    @TableLogic
    private Integer isDeleted;
    private Long createdBy;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    @TableField(exist = false)
    private String assigneeName;
}
