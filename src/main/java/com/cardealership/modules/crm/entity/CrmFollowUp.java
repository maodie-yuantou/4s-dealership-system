package com.cardealership.modules.crm.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("crm_follow_up")
public class CrmFollowUp {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long customerId;
    private String followMethod;
    private String summary;
    private String result;
    private LocalDateTime nextFollowTime;
    private Long followBy;
    @TableLogic
    private Integer isDeleted;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    @TableField(exist = false)
    private String customerName;
    @TableField(exist = false)
    private String followByName;
}
