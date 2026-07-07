package com.cardealership.common.annotation;

import java.lang.annotation.*;
import java.util.concurrent.TimeUnit;

@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface RateLimit {
    double permitsPerSecond() default 5.0;
    long timeout() default 500;
    TimeUnit timeUnit() default TimeUnit.MILLISECONDS;
    String message() default "请求过于频繁，请稍后重试";
}
