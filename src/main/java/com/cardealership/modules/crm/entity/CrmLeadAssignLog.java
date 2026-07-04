package com.cardealership.modules.crm.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("crm_lead_assign_log")
public class CrmLeadAssignLog {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long leadId;
    private Long fromUserId;
    private Long toUserId;
    private String assignType;
    private String remark;
    private Long createdBy;
    private LocalDateTime createdAt;
}
