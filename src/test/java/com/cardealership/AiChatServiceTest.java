package com.cardealership;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.cardealership.modules.client.entity.*;
import com.cardealership.modules.client.mapper.*;
import com.cardealership.modules.crm.entity.CrmCustomer;
import com.cardealership.modules.crm.mapper.CrmCustomerMapper;
import com.cardealership.modules.client.service.AiChatService;
import com.cardealership.service.EmbeddingService;
import com.cardealership.service.VectorSearchService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.*;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AiChatServiceTest {

    @Mock private KbFaqMapper faqMapper;
    @Mock private AiChatHistoryMapper chatHistoryMapper;
    @Mock private CsTicketMapper ticketMapper;
    @Mock private CrmCustomerMapper customerMapper;
    @Mock private EmbeddingService embeddingService;
    @Mock private VectorSearchService vectorSearchService;

    private AiChatService aiChatService;

    @BeforeEach
    void setUp() {
        aiChatService = new AiChatService(faqMapper, chatHistoryMapper, ticketMapper,
            customerMapper, embeddingService, vectorSearchService);
    }

    @Test
    void shouldFindFaqByKeyword() {
        KbFaq faq = new KbFaq();
        faq.setQuestion("首保什么时候做");
        faq.setAnswer("首保一般5000公里或6个月");
        faq.setCategory("MAINTENANCE");
        faq.setKeywords("首保,保养,时间");
        doReturn(List.of(faq)).when(faqMapper).selectList(any(LambdaQueryWrapper.class));

        List<Map<String, String>> results = aiChatService.searchFaq("首保");
        assertEquals(1, results.size());
        assertEquals("首保什么时候做", results.get(0).get("question"));
    }

    @Test
    void shouldReturnEmptyWhenNoFaqMatch() {
        KbFaq faq = new KbFaq();
        faq.setQuestion("营业时间");
        faq.setKeywords("营业时间");
        doReturn(List.of(faq)).when(faqMapper).selectList(any(LambdaQueryWrapper.class));

        List<Map<String, String>> results = aiChatService.searchFaq("x不相干");
        assertEquals(0, results.size());
    }

    @Test
    void shouldGetChatHistory() {
        AiChatHistory h = new AiChatHistory();
        h.setSessionId("s1");
        h.setContent("你好");
        h.setRole("USER");
        doReturn(List.of(h)).when(chatHistoryMapper).selectList(any(LambdaQueryWrapper.class));

        List<AiChatHistory> result = aiChatService.getHistory("s1", 10);
        assertEquals(1, result.size());
        assertEquals("USER", result.get(0).getRole());
    }

    @Test
    void shouldGetSessionMessages() {
        AiChatHistory h = new AiChatHistory();
        h.setSessionId("sess");
        h.setContent("test");
        doReturn(List.of(h)).when(chatHistoryMapper).selectList(any(LambdaQueryWrapper.class));

        List<AiChatHistory> result = aiChatService.getSessionMessages("sess");
        assertEquals("sess", result.get(0).getSessionId());
    }

    @Test
    void shouldGetPendingTickets() {
        CsTicket ticket = new CsTicket();
        ticket.setTicketNo("CS001");
        ticket.setStatus("PENDING");
        doReturn(List.of(ticket)).when(ticketMapper).selectList(any(LambdaQueryWrapper.class));

        List<CsTicket> result = aiChatService.getPendingTickets();
        assertEquals(1, result.size());
        assertEquals("PENDING", result.get(0).getStatus());
    }

    @Test
    void shouldAssignTicket() {
        aiChatService.assignTicket(1L, 2L);
        verify(ticketMapper).updateById(any(CsTicket.class));
    }

    @Test
    void shouldResolveTicket() {
        aiChatService.resolveTicket(1L, "已解决");
        verify(ticketMapper).updateById(any(CsTicket.class));
    }

    @Test
    void shouldCreateTicketWithCustomerInfo() {
        CrmCustomer customer = new CrmCustomer();
        customer.setId(78L);
        customer.setName("张三");
        customer.setPhone("13800001111");
        doReturn(customer).when(customerMapper).selectById(78L);

        CsTicket ticket = aiChatService.createTicket(78L, "需要救援", List.of());
        assertNotNull(ticket.getTicketNo());
        assertTrue(ticket.getTicketNo().startsWith("CS"));
        assertEquals("张三", ticket.getCustomerName());
        assertEquals("URGENT", ticket.getPriority());
    }
}
