package com.cardealership.common.constant;

public class Constants {
    public static final String JWT_SECRET = "4SDealershipSecretKey2026ForJWTTokenGenerationAndValidation";
    public static final long JWT_EXPIRATION = 86400000;

    public static final String LOGIN_USER_KEY = "login_user:";

    public static final String ORDER_NO_PREFIX = "SO";
    public static final String WO_NO_PREFIX = "WO";
    public static final String IN_PREFIX = "IN";
    public static final String OUT_PREFIX = "OUT";
    public static final String PAYMENT_NO_PREFIX = "PAY";
    public static final String INVOICE_NO_PREFIX = "INV";
    public static final String REFUND_NO_PREFIX = "REF";
    public static final String CONTRACT_NO_PREFIX = "CT";
    public static final String CHECK_NO_PREFIX = "CK";
    public static final String COUPON_CODE_PREFIX = "CP";
    public static final String RECEIVABLE_NO_PREFIX = "AR";

    public static final int DEFAULT_STOCK_ALERT_DAYS = 90;
    public static final int DEFAULT_ACCESSORY_ALERT_QTY = 5;
    public static final int DEFAULT_LEAD_CLAIM_DAYS = 3;
    public static final int FOLLOW_UP_REMIND_DAYS = 3;
}
