package com.cardealership;

import com.cardealership.service.DataInitService;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.test.context.ActiveProfiles;

@SpringBootTest
@ActiveProfiles("test")
class ApplicationSmokeTest {

    @MockBean
    private DataInitService dataInitService;

    @Test
    void contextLoads() {
        // 验证 Spring 容器正常启动
    }
}
