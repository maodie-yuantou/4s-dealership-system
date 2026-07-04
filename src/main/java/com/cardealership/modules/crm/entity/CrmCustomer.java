package com.cardealership.modules.crm.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@TableName("crm_customer")
public class CrmCustomer {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String customerType;
    private String name;
    private String gender;
    private String phone;
    private String wechat;
    private String idCard;
    private String address;
    private String source;
    private String sourceChannel;
    private Long intentVehicleId;
    private String intentModel;
    private java.math.BigDecimal budget;
    private String competitorInfo;
    private String grade;
    private Long ownerVehicleId;
    private LocalDate purchaseDate;
    private String ownerVin;
    private LocalDate birthday;
    private LocalDate insuranceDueDate;
    private LocalDate inspectionDueDate;
    private Long assigneeId;
    private String remark;
    @TableLogic
    private Integer isDeleted;
    private Long createdBy;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    @TableField(exist = false)
    private String assigneeName;
}
