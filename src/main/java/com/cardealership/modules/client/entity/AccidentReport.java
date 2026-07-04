package com.cardealership.modules.client.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("accident_report")
public class AccidentReport {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String reportNo;
    private Long customerId;
    private Long vehicleId;
    private LocalDateTime accidentTime;
    private String accidentLocation;
    private String accidentType;
    private String description;
    private String damageImages;
    private Integer insuranceClaimed;
    private String insuranceClaimNo;
    private String status;
    private Long workOrderId;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
