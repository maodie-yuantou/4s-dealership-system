package com.cardealership.modules.client.controller;

import com.cardealership.common.dto.Result;
import com.cardealership.modules.client.entity.AiChatHistory;
import com.cardealership.modules.client.entity.CsTicket;
import com.cardealership.modules.client.service.AiChatService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/client/chat")
@RequiredArgsConstructor
public class AiChatController {
    private final AiChatService aiChatService;

    /**
     * AI 聊天 — 核心接口
     * body: { "sessionId": "xxx", "customerId": 1, "message": "保养多少钱" }
     */
    @PostMapping
    public Result<Map<String, Object>> chat(@RequestBody Map<String, Object> body) {
        String sessionId = (String) body.getOrDefault("sessionId", "sess_" + System.currentTimeMillis());
        Long customerId = body.get("customerId") != null ? Long.valueOf(body.get("customerId").toString()) : null;
        String message = (String) body.get("message");
        return Result.success(aiChatService.chat(sessionId, customerId, message));
    }

    /**
     * 获取会话消息历史
     */
    @GetMapping("/history/{sessionId}")
    public Result<List<AiChatHistory>> history(@PathVariable String sessionId) {
        return Result.success(aiChatService.getSessionMessages(sessionId));
    }

    /**
     * 搜索 FAQ 知识库
     */
    @GetMapping("/faq/search")
    public Result<List<Map<String, String>>> searchFaq(@RequestParam String keyword) {
        return Result.success(aiChatService.searchFaq(keyword));
    }

    /**
     * 转人工客服 — 手动触发
     */
    @PostMapping("/transfer")
    public Result<CsTicket> transferToHuman(@RequestBody Map<String, Object> body) {
        Long customerId = Long.valueOf(body.get("customerId").toString());
        String question = (String) body.getOrDefault("question", "客户请求转人工");
        return Result.success(aiChatService.createTicket(customerId, question, List.of()));
    }

    // ========== B端 客服工单管理 ==========

    /**
     * 获取待处理工单列表
     */
    @GetMapping("/tickets/pending")
    public Result<List<CsTicket>> pendingTickets() {
        return Result.success(aiChatService.getPendingTickets());
    }

    /**
     * 分配工单给客服
     */
    @PutMapping("/tickets/{id}/assign")
    public Result<?> assignTicket(@PathVariable Long id, @RequestBody Map<String, Long> body) {
        aiChatService.assignTicket(id, body.get("assigneeId"));
        return Result.success();
    }

    /**
     * 解决工单
     */
    @PutMapping("/tickets/{id}/resolve")
    public Result<?> resolveTicket(@PathVariable Long id, @RequestBody Map<String, String> body) {
        aiChatService.resolveTicket(id, body.get("resolution"));
        return Result.success();
    }
}
