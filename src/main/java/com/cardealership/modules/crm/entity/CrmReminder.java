package com.cardealership.modules.crm.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("crm_reminder")
public class CrmReminder {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long customerId;
    private String reminderType;
    private LocalDateTime remindTime;
    private String status;
    private Long assigneeId;
    private String remark;
    @TableLogic
    private Integer isDeleted;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    @TableField(exist = false)
    private String customerName;
}
