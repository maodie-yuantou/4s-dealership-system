package com.cardealership.service;

import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
@RequiredArgsConstructor
public class VectorSearchService {
    private static final Logger log = LoggerFactory.getLogger(VectorSearchService.class);
    private final JdbcTemplate pgvectorJdbcTemplate;

    public List<FaqSearchResult> searchSimilar(float[] embedding, int limit) {
        try {
            String vectorStr = vectorToString(embedding);
            String sql = "SELECT f.id, f.question, f.answer, 1 - (v.embedding <=> ?::vector) AS similarity FROM kb_faq_vector v JOIN kb_faq f ON f.id = v.faq_id WHERE f.status = 1 ORDER BY similarity DESC LIMIT ?";
            List<Map<String, Object>> rows = pgvectorJdbcTemplate.queryForList(sql, vectorStr, limit);
            List<FaqSearchResult> results = new ArrayList<>();
            for (Map<String, Object> row : rows) {
                FaqSearchResult r = new FaqSearchResult();
                r.setId(((Number) row.get("id")).longValue());
                r.setQuestion((String) row.get("question"));
                r.setAnswer((String) row.get("answer"));
                r.setSimilarity(((Number) row.get("similarity")).doubleValue());
                results.add(r);
            }
            return results;
        } catch (Exception e) {
            log.debug("Vector search unavailable: {}", e.getMessage());
            return List.of();
        }
    }

    public void upsertFaqEmbedding(Long faqId, float[] embedding) {
        try {
            String v = vectorToString(embedding);
            pgvectorJdbcTemplate.update("INSERT INTO kb_faq_vector (faq_id, embedding) VALUES (?, ?::vector) ON CONFLICT (faq_id) DO UPDATE SET embedding = ?::vector, updated_at = NOW()", faqId, v, v);
        } catch (Exception e) { log.debug("Upsert FAQ vector failed: {}", e.getMessage()); }
    }

    public void deleteByFaqId(Long faqId) {
        try { pgvectorJdbcTemplate.update("DELETE FROM kb_faq_vector WHERE faq_id = ?", faqId); } catch (Exception e) {}
    }

    private String vectorToString(float[] embedding) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < embedding.length; i++) { if (i > 0) sb.append(","); sb.append(embedding[i]); }
        sb.append("]");
        return sb.toString();
    }

    public static class FaqSearchResult {
        private Long id; private String question; private String answer; private Double similarity;
        public Long getId() { return id; } public void setId(Long id) { this.id = id; }
        public String getQuestion() { return question; } public void setQuestion(String q) { this.question = q; }
        public String getAnswer() { return answer; } public void setAnswer(String a) { this.answer = a; }
        public Double getSimilarity() { return similarity; } public void setSimilarity(Double s) { this.similarity = s; }
    }
}
