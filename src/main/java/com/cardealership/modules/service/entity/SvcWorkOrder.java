package com.cardealership.modules.service.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("svc_work_order")
public class SvcWorkOrder {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String woNo;
    private Long appointmentId;
    private Long customerId;
    private String vehicleDesc;
    private Integer mileage;
    private String fuelLevel;
    private String exteriorCondition;
    private String customerComplaint;
    private String technicianFinding;
    private String serviceType;
    private String status;
    private Long serviceAdvisorId;
    private LocalDateTime startedAt;
    private LocalDateTime completedAt;
    @TableLogic private Integer isDeleted;
    private Long createdBy;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
