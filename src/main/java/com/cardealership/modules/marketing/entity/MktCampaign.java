package com.cardealership.modules.marketing.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@TableName("mkt_campaign")
public class MktCampaign {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String campaignName;
    private String campaignType;
    private BigDecimal budget;
    private BigDecimal actualCost;
    private LocalDate startDate;
    private LocalDate endDate;
    private Integer expectedLeads;
    private Integer actualLeads;
    private String status;
    private String description;
    private Long responsibleId;
    @TableLogic private Integer isDeleted;
    private Long createdBy;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
