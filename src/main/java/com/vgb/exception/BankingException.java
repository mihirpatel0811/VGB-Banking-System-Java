package com.vgb.exception;

/**
 * BankingException: Base exception for banking operations
 */
public class BankingException extends Exception {
    protected String errorCode;

    public BankingException(String message) {
        super(message);
    }

    public BankingException(String message, Throwable cause) {
        super(message, cause);
    }

    public BankingException(String message, String errorCode) {
        super(message);
        this.errorCode = errorCode;
    }

    public String getErrorCode() {
        return errorCode;
    }
}

/**
 * AuthenticationException: Thrown when authentication fails
 */
class AuthenticationException extends BankingException {
    public AuthenticationException(String message) {
        super(message, "AUTH_ERROR");
    }
}

/**
 * AuthorizationException: Thrown when user doesn't have permission
 */
class AuthorizationException extends BankingException {
    public AuthorizationException(String message) {
        super(message, "AUTHZ_ERROR");
    }
}

/**
 * ResourceNotFoundException: Thrown when resource is not found
 */
class ResourceNotFoundException extends BankingException {
    public ResourceNotFoundException(String message) {
        super(message, "NOT_FOUND");
    }
}

/**
 * InvalidInputException: Thrown for invalid input data
 */
class InvalidInputException extends BankingException {
    public InvalidInputException(String message) {
        super(message, "INVALID_INPUT");
    }
}

/**
 * InsufficientBalanceException: Thrown when account has insufficient balance
 */
class InsufficientBalanceException extends BankingException {
    public InsufficientBalanceException(String message) {
        super(message, "INSUFFICIENT_BALANCE");
    }
}

/**
 * TransactionException: Thrown during transaction failures
 */
class TransactionException extends BankingException {
    public TransactionException(String message) {
        super(message, "TRANSACTION_ERROR");
    }
}

/**
 * AccountException: Thrown for account-related errors
 */
class AccountException extends BankingException {
    public AccountException(String message) {
        super(message, "ACCOUNT_ERROR");
    }
}

/**
 * LoanException: Thrown for loan-related errors
 */
class LoanException extends BankingException {
    public LoanException(String message) {
        super(message, "LOAN_ERROR");
    }
}

/**
 * DatabaseException: Thrown for database operation errors
 */
class DatabaseException extends BankingException {
    public DatabaseException(String message, Throwable cause) {
        super(message, cause);
        this.errorCode = "DB_ERROR";
    }
}
