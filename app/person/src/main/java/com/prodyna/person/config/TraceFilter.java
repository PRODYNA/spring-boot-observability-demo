package com.prodyna.person.config;

import io.opentelemetry.api.trace.Span;
import io.opentelemetry.api.trace.SpanContext;
import jakarta.servlet.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.MDC;

import java.io.IOException;

public class TraceFilter implements Filter {

  private static final Logger LOGGER = LoggerFactory.getLogger(TraceFilter.class);

  @Override
  public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
      throws IOException, ServletException {
    Span currentSpan = Span.current();
    SpanContext spanContext = currentSpan.getSpanContext();
    if (spanContext.isValid()) {
      MDC.put("traceId", spanContext.getTraceId());
      MDC.put("spanId", spanContext.getSpanId());
    } else {
      LOGGER.warn(
          "SpanContext is not valid traceId: {} spanId: {}",
          spanContext.getTraceId(),
          spanContext.getSpanId());
    }
    try {
      chain.doFilter(request, response);
    } finally {
      MDC.clear();
    }
  }
}
