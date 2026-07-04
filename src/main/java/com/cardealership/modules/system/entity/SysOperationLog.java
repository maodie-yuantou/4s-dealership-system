package com.cardealership.modules.system.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("sys_operation_log")
public class SysOperationLog {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long userId;
    private String username;
    private String module;
    private String action;
    private String method;
    private String requestUrl;
    private String requestMethod;
    private String requestParams;
    private String responseResult;
    private String ip;
    private Long duration;
    private Integer status;
    private String errorMsg;
    private LocalDateTime createdAt;
}
