package com.cardealership.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.cardealership.modules.client.entity.KbFaq;
import com.cardealership.modules.client.mapper.KbFaqMapper;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.CommandLineRunner;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
@Order(2)
@RequiredArgsConstructor
public class FaqEmbeddingInitializer implements CommandLineRunner {
    private static final Logger log = LoggerFactory.getLogger(FaqEmbeddingInitializer.class);
    private final KbFaqMapper faqMapper;
    private final EmbeddingService embeddingService;
    private final VectorSearchService vectorSearchService;

    @Override
    public void run(String... args) {
        try {
            List<KbFaq> faqs = faqMapper.selectList(new LambdaQueryWrapper<KbFaq>().eq(KbFaq::getStatus, 1));
            if (faqs.isEmpty()) { log.info("FaqEmbedding: no FAQ records"); return; }
            int count = 0;
            for (KbFaq faq : faqs) {
                try {
                    String text = faq.getQuestion() + (faq.getKeywords() != null ? " " + faq.getKeywords() : "");
                    float[] embedding = embeddingService.embed(text);
                    vectorSearchService.upsertFaqEmbedding(faq.getId(), embedding);
                    count++;
                } catch (Exception e) { log.warn("FaqEmbedding: FAQ#{} failed: {}", faq.getId(), e.getMessage()); }
            }
            log.info("FaqEmbedding: indexed {} FAQs", count);
        } catch (Exception e) { log.warn("FaqEmbedding: pgvector not available, skipping"); }
    }
}
