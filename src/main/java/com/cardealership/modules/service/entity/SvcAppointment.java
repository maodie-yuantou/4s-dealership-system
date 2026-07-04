package com.cardealership.modules.service.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("svc_appointment")
public class SvcAppointment {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long customerId;
    private String customerName;
    private String phone;
    private String vehicleInfo;
    private LocalDateTime appointmentTime;
    private String serviceType;
    private String description;
    private String status;
    private Long serviceAdvisorId;
    private String remark;
    @TableLogic private Integer isDeleted;
    private Long createdBy;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
