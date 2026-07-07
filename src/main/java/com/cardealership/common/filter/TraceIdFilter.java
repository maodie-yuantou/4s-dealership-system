package com.cardealership.common.filter;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.MDC;

import java.io.IOException;
import java.util.UUID;

public class TraceIdFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        String traceId = UUID.randomUUID().toString().replace("-", "").substring(0, 16);
        MDC.put("traceId", traceId);
        try {
            if (response instanceof HttpServletResponse httpResp) {
                httpResp.setHeader("X-Trace-Id", traceId);
            }
            chain.doFilter(request, response);
        } finally {
            MDC.remove("traceId");
        }
    }
}
