package com.vgb.constants;

/**
 * AppConstants: Application-wide constants
 */
public class AppConstants {

    // ===== SESSION ATTRIBUTES =====
    public static final String USER_SESSION_KEY = "user";
    public static final String ADMIN_SESSION_KEY = "admin";
    public static final String CSRF_TOKEN_SESSION = "csrfToken";
    public static final String USER_ROLE_SESSION = "userRole";

    // ===== USER ROLES =====
    public static final String ROLE_ADMIN = "ADMIN";
    public static final String ROLE_CUSTOMER = "CUSTOMER";

    // ===== ACCOUNT STATUS =====
    public static final String ACCOUNT_STATUS_PENDING_KYC = "pending_kyc";
    public static final String ACCOUNT_STATUS_ACTIVE = "active";
    public static final String ACCOUNT_STATUS_SUSPENDED = "suspended";
    public static final String ACCOUNT_STATUS_CLOSED = "closed";

    // ===== ACCOUNT TYPES =====
    public static final String ACCOUNT_TYPE_SAVINGS = "savings";
    public static final String ACCOUNT_TYPE_CHECKING = "checking";
    public static final String ACCOUNT_TYPE_CURRENT = "current";
    public static final String ACCOUNT_TYPE_FIXED_DEPOSIT = "fixed_deposit";

    // ===== TRANSACTION TYPES =====
    public static final String TRANSACTION_TYPE_DEPOSIT = "deposit";
    public static final String TRANSACTION_TYPE_WITHDRAWAL = "withdrawal";
    public static final String TRANSACTION_TYPE_TRANSFER = "transfer";
    public static final String TRANSACTION_TYPE_INTEREST = "interest";
    public static final String TRANSACTION_TYPE_FEE = "fee";

    // ===== TRANSACTION STATUS =====
    public static final String TRANSACTION_STATUS_PENDING = "pending";
    public static final String TRANSACTION_STATUS_COMPLETED = "completed";
    public static final String TRANSACTION_STATUS_FAILED = "failed";
    public static final String TRANSACTION_STATUS_REVERSED = "reversed";

    // ===== LOAN TYPES =====
    public static final String LOAN_TYPE_HOME = "home";
    public static final String LOAN_TYPE_CAR = "car";
    public static final String LOAN_TYPE_PERSONAL = "personal";
    public static final String LOAN_TYPE_EDUCATION = "education";

    // ===== LOAN STATUS =====
    public static final String LOAN_STATUS_PENDING_APPROVAL = "pending_approval";
    public static final String LOAN_STATUS_APPROVED = "approved";
    public static final String LOAN_STATUS_DISBURSED = "disbursed";
    public static final String LOAN_STATUS_ACTIVE = "active";
    public static final String LOAN_STATUS_REJECTED = "rejected";
    public static final String LOAN_STATUS_CLOSED = "closed";
    public static final String LOAN_STATUS_DEFAULTED = "defaulted";

    // ===== VALIDATION CONSTRAINTS =====
    public static final int MIN_PASSWORD_LENGTH = 8;
    public static final int MIN_USERNAME_LENGTH = 3;
    public static final int MAX_USERNAME_LENGTH = 30;
    public static final int PIN_LENGTH = 4;
    public static final int IFSC_CODE_LENGTH = 11;

    // ===== MONETARY CONSTRAINTS =====
    public static final java.math.BigDecimal MIN_DEPOSIT_AMOUNT = new java.math.BigDecimal("500.0");
    public static final java.math.BigDecimal MIN_TRANSFER_AMOUNT = new java.math.BigDecimal("100.0");
    public static final java.math.BigDecimal MAX_TRANSFER_AMOUNT = new java.math.BigDecimal("1000000.0");
    public static final java.math.BigDecimal MIN_LOAN_AMOUNT = new java.math.BigDecimal("50000.0");
    public static final java.math.BigDecimal MAX_LOAN_AMOUNT = new java.math.BigDecimal("50000000.0");

    // ===== INTEREST RATES (Annual) =====
    public static final double SAVINGS_INTEREST_RATE = 3.5;
    public static final double CHECKING_INTEREST_RATE = 0.5;
    public static final double HOME_LOAN_RATE = 7.5;
    public static final double CAR_LOAN_RATE = 8.5;
    public static final double PERSONAL_LOAN_RATE = 12.0;
    public static final double EDUCATION_LOAN_RATE = 6.5;

    // ===== SESSION TIMEOUT =====
    public static final int SESSION_TIMEOUT_MINUTES = 30;

    // ===== PAGINATION =====
    public static final int RECORDS_PER_PAGE = 10;
    public static final int MAX_RECORDS_PER_PAGE = 100;

    // ===== ERROR MESSAGES =====
    public static final String ERROR_INVALID_CREDENTIALS = "Invalid username or password";
    public static final String ERROR_ACCOUNT_NOT_FOUND = "Account not found";
    public static final String ERROR_INSUFFICIENT_BALANCE = "Insufficient balance";
    public static final String ERROR_INVALID_INPUT = "Invalid input provided";
    public static final String ERROR_UNAUTHORIZED_ACCESS = "Unauthorized access";
    public static final String ERROR_SESSION_EXPIRED = "Session expired. Please login again.";
    public static final String ERROR_DATABASE_ERROR = "Database error occurred";

    // ===== SUCCESS MESSAGES =====
    public static final String SUCCESS_LOGIN = "Login successful";
    public static final String SUCCESS_ACCOUNT_CREATED = "Account created successfully";
    public static final String SUCCESS_TRANSFER_COMPLETED = "Transfer completed successfully";
    public static final String SUCCESS_WITHDRAWAL_COMPLETED = "Withdrawal completed successfully";

    // ===== PATHS =====
    public static final String PATH_LOGIN = "/login";
    public static final String PATH_ADMIN_DASHBOARD = "/admin-dashboard";
    public static final String PATH_CUSTOMER_DASHBOARD = "/customer-dashboard";
}
