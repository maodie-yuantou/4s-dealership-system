package com.cardealership.modules.stock.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("vehicle_video")
public class VehicleVideo {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long vehicleId;
    private String title;
    private String videoUrl;
    private String coverUrl;
    private String sourceType;   // LOCAL / LINK
    private Integer sortOrder;
    private Long createdBy;
    @TableLogic private Integer isDeleted;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
