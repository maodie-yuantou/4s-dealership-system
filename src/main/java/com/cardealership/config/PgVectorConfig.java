package com.cardealership.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.DriverManagerDataSource;

@Configuration
public class PgVectorConfig {
    @Value("${pgvector.datasource.url:jdbc:postgresql://localhost:5432/cardealership_vectors}")
    private String url;
    @Value("${pgvector.datasource.username:vectoruser}")
    private String username;
    @Value("${pgvector.datasource.password:vectorpass}")
    private String password;
    @Value("${pgvector.datasource.driver-class-name:org.postgresql.Driver}")
    private String driverClassName;

    @Bean
    public JdbcTemplate pgvectorJdbcTemplate() {
        DriverManagerDataSource ds = new DriverManagerDataSource();
        ds.setUrl(url); ds.setUsername(username); ds.setPassword(password); ds.setDriverClassName(driverClassName);
        return new JdbcTemplate(ds);
    }
}
