package com.cardealership.modules.client.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("kb_faq")
public class KbFaq {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String category;
    private String question;
    private String answer;
    private String keywords;
    private Integer sortOrder;
    private Integer status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
