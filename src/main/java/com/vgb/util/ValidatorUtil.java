package com.vgb.util;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

/**
 * ValidatorUtil: Validates input data for business logic
 */
public class ValidatorUtil {

    /**
     * Validate amount (must be positive)
     */
    public static boolean isValidAmount(BigDecimal amount) {
        return amount != null && amount.compareTo(BigDecimal.ZERO) > 0;
    }

    /**
     * Validate amount (must be positive, minimum required)
     */
    public static boolean isValidAmount(BigDecimal amount, BigDecimal minimum) {
        return amount != null && minimum != null && amount.compareTo(minimum) >= 0;
    }

    /**
     * Validate string is not null and not empty
     */
    public static boolean isNotNull(String value) {
        return value != null && !value.trim().isEmpty();
    }

    /**
     * Validate string length
     */
    public static boolean isValidLength(String value, int minLength, int maxLength) {
        if (value == null) {
            return false;
        }
        int length = value.trim().length();
        return length >= minLength && length <= maxLength;
    }

    /**
     * Validate date format (yyyy-MM-dd)
     */
    public static boolean isValidDateFormat(String dateString) {
        if (!isNotNull(dateString)) {
            return false;
        }
        try {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            LocalDate.parse(dateString, formatter);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * Validate date is not in past
     */
    public static boolean isDateNotInPast(String dateString) {
        if (!isValidDateFormat(dateString)) {
            return false;
        }
        try {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            LocalDate date = LocalDate.parse(dateString, formatter);
            return !date.isBefore(LocalDate.now());
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * Validate username (alphanumeric, 3-30 characters)
     */
    public static boolean isValidUsername(String username) {
        if (!isNotNull(username)) {
            return false;
        }
        return username.matches("^[a-zA-Z0-9_@.\\-+!#\\$%&\\*\\?]{3,30}$");
    }

    /**
     * Validate name (letters and spaces only, 2-50 characters)
     */
    public static boolean isValidName(String name) {
        if (!isNotNull(name)) {
            return false;
        }
        return name.matches("^[a-zA-Z\\s]{2,50}$");
    }

    /**
     * Validate integer range
     */
    public static boolean isInRange(int value, int min, int max) {
        return value >= min && value <= max;
    }

    /**
     * Validate long range
     */
    public static boolean isInRange(long value, long min, long max) {
        return value >= min && value <= max;
    }

    /**
     * Validate account status
     */
    public static boolean isValidAccountStatus(String status) {
        return status != null && 
               (status.equalsIgnoreCase("active") || 
                status.equalsIgnoreCase("frozen") ||
                status.equalsIgnoreCase("dormant") ||
                status.equalsIgnoreCase("closed"));
    }

    /**
     * Validate account type
     */
    public static boolean isValidAccountType(String type) {
        return type != null &&
               (type.equalsIgnoreCase("savings") ||
                type.equalsIgnoreCase("checking") ||
                type.equalsIgnoreCase("current") ||
                type.equalsIgnoreCase("fixed_deposit"));
    }

    /**
     * Validate transaction type
     */
    public static boolean isValidTransactionType(String type) {
        return type != null &&
               (type.equalsIgnoreCase("deposit") ||
                type.equalsIgnoreCase("withdrawal") ||
                type.equalsIgnoreCase("transfer") ||
                type.equalsIgnoreCase("interest") ||
                type.equalsIgnoreCase("fee"));
    }

    /**
     * Validate loan type
     */
    public static boolean isValidLoanType(String type) {
        return type != null &&
               (type.equalsIgnoreCase("home") ||
                type.equalsIgnoreCase("car") ||
                type.equalsIgnoreCase("vehicle") ||
                type.equalsIgnoreCase("personal") ||
                type.equalsIgnoreCase("education") ||
                type.equalsIgnoreCase("business"));
    }

    /**
     * Validate interest rate (0-30%)
     */
    public static boolean isValidInterestRate(BigDecimal rate) {
        return rate != null && 
               rate.compareTo(BigDecimal.ZERO) >= 0 && 
               rate.compareTo(new BigDecimal("30")) <= 0;
    }

    /**
     * Validate term in months (1-360 months = 30 years)
     */
    public static boolean isValidTermMonths(int months) {
        return months >= 1 && months <= 360;
    }

    /**
     * Validate email format
     */
    public static boolean isValidEmail(String email) {
        return email != null && email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$");
    }

    /**
     * Validate phone number (10 to 15 digits, optional +, dashes, spaces, parentheses)
     */
    public static boolean isValidPhone(String phone) {
        if (phone == null || phone.trim().isEmpty()) {
            return false;
        }
        String cleanPhone = phone.replaceAll("[\\s+\\-()]+", "");
        return cleanPhone.matches("^[0-9]{10,15}$");
    }

    /**
     * Validate account number (10-18 digits)
     */
    public static boolean isValidAccountNumber(String accountNumber) {
        return accountNumber != null && accountNumber.matches("^[0-9]{10,18}$");
    }
}
