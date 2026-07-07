-- 为知识库FAQ表添加ngram全文索引，提升中文搜索匹配度
-- MySQL 8.0 ngram parser: 按2字分词进行全文搜索

ALTER TABLE kb_faq ADD FULLTEXT INDEX ft_faq_ngram (question, answer, keywords) WITH PARSER ngram;
