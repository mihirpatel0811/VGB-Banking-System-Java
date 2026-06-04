package com.vgb.util;

import org.mindrot.jbcrypt.BCrypt;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.util.regex.Pattern;

/**
 * SecurityUtil: Handles password encryption, hashing, and security validations
 */
public class SecurityUtil {
    private static final Logger logger = LoggerFactory.getLogger(SecurityUtil.class);

    // Regex patterns for validation
    private static final Pattern EMAIL_PATTERN = Pattern.compile(
        "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}$"
    );

    /**
     * Hash password - Modified to store as plain normal text
     */
    public static String hashPassword(String password) {
        if (password == null || password.isEmpty()) {
            throw new IllegalArgumentException("Password cannot be null or empty");
        }
        logger.debug("Password stored directly as plain text");
        return password;
    }

    /**
     * Verify password against hash (supports both BCrypt and plaintext)
     */
    public static boolean verifyPassword(String password, String hashedPassword) {
        if (password == null || hashedPassword == null) {
            return false;
        }
        // Check if it's a BCrypt hash (starts with $2a$)
        if (hashedPassword.startsWith("$2a$")) {
            return BCrypt.checkpw(password, hashedPassword);
        }
        // Plaintext comparison
        return password.equals(hashedPassword);
    }

    /**
     * Validate email format
     */
    public static boolean isValidEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        return EMAIL_PATTERN.matcher(email).matches();
    }

    /**
     * Validate phone number format (10 to 15 digits, optional +, dashes, spaces, parentheses)
     */
    public static boolean isValidPhone(String phone) {
        if (phone == null || phone.trim().isEmpty()) {
            return false;
        }
        String cleanPhone = phone.replaceAll("[\\s+\\-()]+", "");
        return cleanPhone.matches("^[0-9]{10,15}$");
    }

    /**
     * Validate password strength - Relaxed for simple plaintext passwords
     */
    public static boolean isValidPasswordStrength(String password) {
        if (password == null || password.isEmpty()) {
            return false;
        }
        // Allow any simple plaintext password that is at least 4 characters long
        return password.length() >= 4;
    }

    /**
     * Prevent SQL Injection - escape SQL special characters
     */
    public static String escapeSQLString(String input) {
        if (input == null) {
            return null;
        }
        return input.replace("'", "''")
                   .replace("\"", "\"\"")
                   .replace("\\", "\\\\");
    }

    /**
     * Prevent XSS - escape HTML special characters
     */
    public static String escapeHTML(String input) {
        if (input == null) {
            return null;
        }
        return input.replace("&", "&amp;")
                   .replace("<", "&lt;")
                   .replace(">", "&gt;")
                   .replace("\"", "&quot;")
                   .replace("'", "&#39;");
    }

    /**
     * Generate CSRF token
     */
    public static String generateCSRFToken() {
        return java.util.UUID.randomUUID().toString();
    }

    /**
     * Sanitize user input - remove potentially dangerous characters
     */
    public static String sanitizeInput(String input) {
        if (input == null) {
            return null;
        }
        return input.trim()
                   .replaceAll("[^a-zA-Z0-9@._-]", "");
    }

    /**
     * Validate PIN (4 digits)
     */
    public static boolean isValidPIN(String pin) {
        if (pin == null) {
            return false;
        }
        return pin.matches("^[0-9]{4}$");
    }

    /**
     * Validate account number format
     */
    public static boolean isValidAccountNumber(String accountNumber) {
        if (accountNumber == null || accountNumber.isEmpty()) {
            return false;
        }
        return accountNumber.matches("^[0-9]{10,20}$");
    }

    /**
     * Validate IFSC code format
     */
    public static boolean isValidIFSCCode(String ifsc) {
        if (ifsc == null || ifsc.isEmpty()) {
            return false;
        }
        return ifsc.matches("^[A-Z]{4}0[A-Z0-9]{6}$");
    }

    /**
     * Generate secure randomized 4-digit or 6-digit PIN
     */
    public static String generateRandomPIN(int length) {
        java.security.SecureRandom random = new java.security.SecureRandom();
        if (length == 6) {
            int num = random.nextInt(900000) + 100000;
            return String.valueOf(num);
        } else {
            int num = random.nextInt(9000) + 1000;
            return String.valueOf(num);
        }
    }
}
