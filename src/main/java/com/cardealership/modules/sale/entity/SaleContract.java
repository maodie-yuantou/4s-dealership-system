package com.cardealership.modules.sale.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("sale_contract")
public class SaleContract {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String contractNo;
    private Long orderId;
    private String contractContent;
    private String signedStatus;
    private LocalDateTime signedAt;
    private String filePath;
    @TableLogic private Integer isDeleted;
    private Long createdBy;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
