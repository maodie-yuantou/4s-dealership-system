package com.cardealership.modules.client.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.cardealership.modules.client.entity.*;
import com.cardealership.modules.client.mapper.*;
import com.cardealership.modules.crm.entity.CrmCustomer;
import com.cardealership.modules.crm.mapper.CrmCustomerMapper;
import com.cardealership.service.EmbeddingService;
import com.cardealership.service.VectorSearchService;
import dev.langchain4j.model.openai.OpenAiChatModel;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class AiChatService {

    private static final Logger log = LoggerFactory.getLogger(AiChatService.class);

    private final KbFaqMapper faqMapper;
    private final AiChatHistoryMapper chatHistoryMapper;
    private final CsTicketMapper ticketMapper;
    private final CrmCustomerMapper customerMapper;
    private final EmbeddingService embeddingService;
    private final VectorSearchService vectorSearchService;

    private static final String DEEPSEEK_API_KEY = System.getenv("DEEPSEEK_API_KEY") != null
        ? System.getenv("DEEPSEEK_API_KEY")
        : "your-deepseek-api-key";
    private static final String DEEPSEEK_BASE_URL = "https://api.deepseek.com/v1";
    private static final String DEEPSEEK_MODEL = "deepseek-chat";

    private static final String SYSTEM_PROMPT = """
            你是润达4S店的智能客服助手"小润"。你是一个热情友好、知识面广的客服。
            首先你是4S店客服，优先回答购车、保养、维修、保险、价格等问题。
            但你也乐于和客户聊任何话题，包括闲聊、评价名字、娱乐八卦、生活问题等，用友好幽默的语气回复。
            每次回复控制在200字以内，不要拒绝回答客户的任何问题。
            只有在客户明确说"转人工"或投诉时，回复末尾才加[TRANSFER_TO_HUMAN]标记。""";

    /**
     * AI 聊天核心方法
     */
    @Transactional
    public Map<String, Object> chat(String sessionId, Long customerId, String message) {
        // 1. 保存用户消息
        saveMessage(sessionId, customerId, "USER", message);

        // 2. 获取历史对话（最近10条）
        List<AiChatHistory> history = getHistory(sessionId, 10);

        // 3. 先查知识库
        String kbAnswer = searchKnowledgeBase(message);
        String aiAnswer;

        if (kbAnswer != null) {
            aiAnswer = kbAnswer;
        } else {
            // 4. 知识库未匹配，调用 DeepSeek LLM
            aiAnswer = callDeepSeekLLM(sessionId, history, message);
        }

        // 5. 检查是否需要转人工（关键词检测 + LLM标记）
        boolean transferToHuman = message.contains("转人工") || message.contains("人工客服")
                || message.contains("投诉") || aiAnswer.contains("[TRANSFER_TO_HUMAN]");
        if (transferToHuman) {
            aiAnswer = aiAnswer.replace("[TRANSFER_TO_HUMAN]", "").trim();
            if (aiAnswer.isBlank() || aiAnswer.length() < 10) {
                aiAnswer = "好的，正在为您转接人工客服，请稍候...";
            }
        }

        // 6. 保存AI回复
        saveMessage(sessionId, customerId, "AI", aiAnswer);

        // 7. 构建响应
        Map<String, Object> result = new HashMap<>();
        result.put("sessionId", sessionId);
        result.put("reply", aiAnswer);
        result.put("transferToHuman", transferToHuman);
        result.put("source", kbAnswer != null ? "KB" : "AI");

        if (transferToHuman) {
            // 自动创建客服工单
            CsTicket ticket = createTicket(customerId, message, history);
            result.put("ticketNo", ticket.getTicketNo());
            result.put("reply", aiAnswer + "\n\n已为您创建人工客服工单（" + ticket.getTicketNo() + "），请保持电话畅通，我们的客服专员将尽快与您联系。");
        }

        return result;
    }

    /**
     * 知识库搜索 — 关键词匹配 + 语义相似
     */
    private String searchKnowledgeBase(String question) {
        // 1. 向量语义检索
        try {
            float[] qv = embeddingService.embed(question);
            List<VectorSearchService.FaqSearchResult> results = vectorSearchService.searchSimilar(qv, 3);
            if (!results.isEmpty() && results.get(0).getSimilarity() > 0.6) {
                log.debug("Vector search matched FAQ id={}", results.get(0).getId());
                return results.get(0).getAnswer();
            }
        } catch (Exception e) { log.debug("Vector search fallback: {}", e.getMessage()); }

        List<KbFaq> allFaqs = faqMapper.selectList(
                new LambdaQueryWrapper<KbFaq>().eq(KbFaq::getStatus, 1));

        // 分词：提取问题中的关键词
        String q = question.toLowerCase();

        // 评分：匹配关键词和问题文本
        KbFaq bestMatch = null;
        int bestScore = 0;

        for (KbFaq faq : allFaqs) {
            int score = 0;
            // 关键词匹配
            if (faq.getKeywords() != null) {
                for (String kw : faq.getKeywords().split(",")) {
                    if (q.contains(kw.trim().toLowerCase())) {
                        score += 3;
                    }
                }
            }
            // 问题文本匹配（简单包含关系）
            String faqQ = faq.getQuestion().toLowerCase();
            for (String word : q.split("\\s+")) {
                if (word.length() >= 2 && faqQ.contains(word)) {
                    score += 1;
                }
            }
            // 问题整体相似（包含更多共同字符）
            score += commonChars(q, faqQ) / 2;

            if (score > bestScore) {
                bestScore = score;
                bestMatch = faq;
            }
        }

        // 阈值：至少4分才认为匹配
        return bestScore >= 4 ? bestMatch.getAnswer() : null;
    }

    private int commonChars(String a, String b) {
        int count = 0;
        for (int i = 0; i < a.length() - 1; i++) {
            if (b.contains(a.substring(i, Math.min(i + 2, a.length())))) {
                count++;
            }
        }
        return count;
    }

    /**
     * 调用 DeepSeek LLM（LangChain4j OpenAI 兼容模式）
     */
    private String callDeepSeekLLM(String sessionId, List<AiChatHistory> history, String question) {
        try {
            OpenAiChatModel model = OpenAiChatModel.builder()
                    .apiKey(DEEPSEEK_API_KEY)
                    .baseUrl(DEEPSEEK_BASE_URL)
                    .modelName(DEEPSEEK_MODEL)
                    .temperature(0.7)
                    .maxTokens(500)
                    .build();

            // 构建消息列表
            List<dev.langchain4j.data.message.ChatMessage> messages = new ArrayList<>();
            messages.add(dev.langchain4j.data.message.SystemMessage.from(SYSTEM_PROMPT));

            // 添加历史对话
            for (AiChatHistory h : history) {
                if ("USER".equals(h.getRole())) {
                    messages.add(dev.langchain4j.data.message.UserMessage.from(h.getContent()));
                } else if ("AI".equals(h.getRole())) {
                    messages.add(dev.langchain4j.data.message.AiMessage.from(h.getContent()));
                }
            }

            // 添加当前问题
            messages.add(dev.langchain4j.data.message.UserMessage.from(question));

            var chatRequest = dev.langchain4j.model.chat.request.ChatRequest.builder()
                    .messages(messages)
                    .build();
            dev.langchain4j.data.message.ChatMessage response = model.chat(chatRequest).aiMessage();
            String answer = ((dev.langchain4j.data.message.AiMessage) response).text();

            if (answer == null || answer.isBlank()) {
                return "抱歉，我暂时无法回答您的问题。您可以尝试换个方式提问，或者输入【转人工】联系我们的客服专员。";
            }

            return answer;
        } catch (Exception e) {
            // LangChain4j 调用失败，降级到知识库
            return "很抱歉，智能客服系统繁忙。您可以尝试以下方式：\n1. 换个关键词重新提问\n2. 输入【转人工】联系客服专员\n3. 拨打服务热线 400-xxx-xxxx";
        }
    }

    /**
     * 搜索知识库并返回匹配的FAQ列表（用于展示相关推荐）
     */
    public List<Map<String, String>> searchFaq(String keyword) {
        List<KbFaq> allFaqs = faqMapper.selectList(
                new LambdaQueryWrapper<KbFaq>().eq(KbFaq::getStatus, 1));

        List<Map<String, String>> results = new ArrayList<>();
        for (KbFaq faq : allFaqs) {
            int score = 0;
            String q = keyword.toLowerCase();
            if (faq.getKeywords() != null) {
                for (String kw : faq.getKeywords().split(",")) {
                    if (q.contains(kw.trim().toLowerCase())) score += 3;
                }
            }
            if (score > 0 || faq.getQuestion().toLowerCase().contains(q)) {
                Map<String, String> m = new HashMap<>();
                m.put("question", faq.getQuestion());
                m.put("answer", faq.getAnswer());
                m.put("category", faq.getCategory());
                results.add(m);
            }
        }
        return results;
    }

    // ========== 转人工客服 ==========

    @Transactional
    public CsTicket createTicket(Long customerId, String question, List<AiChatHistory> history) {
        CsTicket ticket = new CsTicket();
        ticket.setTicketNo("CS" + System.currentTimeMillis());
        ticket.setCustomerId(customerId);
        ticket.setQuestion(question);
        ticket.setStatus("PENDING");
        ticket.setPriority("NORMAL");

        // 紧急关键词检测
        String q = question.toLowerCase();
        if (q.contains("救援") || q.contains("事故") || q.contains("紧急")) {
            ticket.setPriority("URGENT");
        }

        // 保存对话上下文
        ticket.setChatContext(toJson(history));

        CrmCustomer customer = customerMapper.selectById(customerId);
        if (customer != null) {
            ticket.setCustomerName(customer.getName());
            ticket.setPhone(customer.getPhone());
        }

        ticketMapper.insert(ticket);
        return ticket;
    }

    public List<CsTicket> getPendingTickets() {
        return ticketMapper.selectList(
                new LambdaQueryWrapper<CsTicket>()
                        .in(CsTicket::getStatus, "PENDING", "ASSIGNED")
                        .orderByDesc(CsTicket::getPriority)
                        .orderByAsc(CsTicket::getCreatedAt));
    }

    @Transactional
    public void assignTicket(Long ticketId, Long assigneeId) {
        CsTicket t = new CsTicket();
        t.setId(ticketId);
        t.setAssigneeId(assigneeId);
        t.setStatus("PROCESSING");
        ticketMapper.updateById(t);
    }

    @Transactional
    public void resolveTicket(Long ticketId, String resolution) {
        CsTicket t = new CsTicket();
        t.setId(ticketId);
        t.setStatus("RESOLVED");
        t.setResolution(resolution);
        t.setResolvedAt(LocalDateTime.now());
        ticketMapper.updateById(t);
    }

    // ========== 历史记录 ==========

    public List<AiChatHistory> getHistory(String sessionId, int limit) {
        return chatHistoryMapper.selectList(
                new LambdaQueryWrapper<AiChatHistory>()
                        .eq(AiChatHistory::getSessionId, sessionId)
                        .orderByDesc(AiChatHistory::getCreatedAt)
                        .last("LIMIT " + limit));
    }

    public List<AiChatHistory> getSessionMessages(String sessionId) {
        return chatHistoryMapper.selectList(
                new LambdaQueryWrapper<AiChatHistory>()
                        .eq(AiChatHistory::getSessionId, sessionId)
                        .orderByAsc(AiChatHistory::getCreatedAt));
    }

    private void saveMessage(String sessionId, Long customerId, String role, String content) {
        AiChatHistory msg = new AiChatHistory();
        msg.setSessionId(sessionId);
        msg.setCustomerId(customerId);
        msg.setRole(role);
        msg.setContent(content);
        chatHistoryMapper.insert(msg);
    }

    private String toJson(List<AiChatHistory> history) {
        return history.stream()
                .map(h -> h.getRole() + ": " + h.getContent())
                .collect(Collectors.joining("\\n"));
    }
}
