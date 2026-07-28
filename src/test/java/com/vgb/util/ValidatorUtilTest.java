package com.vgb.util;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import java.math.BigDecimal;

import static org.junit.jupiter.api.Assertions.*;

public class ValidatorUtilTest {

    @Test
    @DisplayName("Test isValidAmount with positive, zero, and negative values")
    void testIsValidAmount() {
        assertTrue(ValidatorUtil.isValidAmount(new BigDecimal("100.00")));
        assertTrue(ValidatorUtil.isValidAmount(new BigDecimal("0.01")));
        assertFalse(ValidatorUtil.isValidAmount(BigDecimal.ZERO));
        assertFalse(ValidatorUtil.isValidAmount(new BigDecimal("-50.00")));
        assertFalse(ValidatorUtil.isValidAmount(null));
    }

    @Test
    @DisplayName("Test isValidAmount with minimum threshold")
    void testIsValidAmountWithMinimum() {
        assertTrue(ValidatorUtil.isValidAmount(new BigDecimal("500.00"), new BigDecimal("100.00")));
        assertTrue(ValidatorUtil.isValidAmount(new BigDecimal("100.00"), new BigDecimal("100.00")));
        assertFalse(ValidatorUtil.isValidAmount(new BigDecimal("50.00"), new BigDecimal("100.00")));
        assertFalse(ValidatorUtil.isValidAmount(null, new BigDecimal("100.00")));
    }

    @Test
    @DisplayName("Test string null and empty checks")
    void testIsNotNull() {
        assertTrue(ValidatorUtil.isNotNull("ValidString"));
        assertFalse(ValidatorUtil.isNotNull(""));
        assertFalse(ValidatorUtil.isNotNull("   "));
        assertFalse(ValidatorUtil.isNotNull(null));
    }

    @Test
    @DisplayName("Test string length range validation")
    void testIsValidLength() {
        assertTrue(ValidatorUtil.isValidLength("Password123", 6, 20));
        assertFalse(ValidatorUtil.isValidLength("Short", 6, 20));
        assertFalse(ValidatorUtil.isValidLength("ThisIsAVeryLongStringExceedingLimit", 6, 20));
        assertFalse(ValidatorUtil.isValidLength(null, 6, 20));
    }

    @Test
    @DisplayName("Test date format yyyy-MM-dd")
    void testIsValidDateFormat() {
        assertTrue(ValidatorUtil.isValidDateFormat("2026-12-31"));
        assertFalse(ValidatorUtil.isValidDateFormat("31-12-2026"));
        assertFalse(ValidatorUtil.isValidDateFormat("2026/12/31"));
        assertFalse(ValidatorUtil.isValidDateFormat("invalid-date"));
        assertFalse(ValidatorUtil.isValidDateFormat(null));
    }

    @Test
    @DisplayName("Test username format validation")
    void testIsValidUsername() {
        assertTrue(ValidatorUtil.isValidUsername("john_doe"));
        assertTrue(ValidatorUtil.isValidUsername("user123"));
        assertFalse(ValidatorUtil.isValidUsername("ab")); // too short
        assertFalse(ValidatorUtil.isValidUsername("user with spaces"));
        assertFalse(ValidatorUtil.isValidUsername(null));
    }

    @Test
    @DisplayName("Test account status validation")
    void testIsValidAccountStatus() {
        assertTrue(ValidatorUtil.isValidAccountStatus("ACTIVE"));
        assertTrue(ValidatorUtil.isValidAccountStatus("frozen"));
        assertTrue(ValidatorUtil.isValidAccountStatus("dormant"));
        assertTrue(ValidatorUtil.isValidAccountStatus("closed"));
        assertFalse(ValidatorUtil.isValidAccountStatus("invalid_status"));
        assertFalse(ValidatorUtil.isValidAccountStatus(null));
    }

    @Test
    @DisplayName("Test account type validation")
    void testIsValidAccountType() {
        assertTrue(ValidatorUtil.isValidAccountType("Savings"));
        assertTrue(ValidatorUtil.isValidAccountType("CHECKING"));
        assertTrue(ValidatorUtil.isValidAccountType("current"));
        assertTrue(ValidatorUtil.isValidAccountType("fixed_deposit"));
        assertFalse(ValidatorUtil.isValidAccountType("crypto"));
        assertFalse(ValidatorUtil.isValidAccountType(null));
    }

    @Test
    @DisplayName("Test email format validation")
    void testIsValidEmail() {
        assertTrue(ValidatorUtil.isValidEmail("user@vgb-bank.com"));
        assertTrue(ValidatorUtil.isValidEmail("customer.service@sub.domain.org"));
        assertFalse(ValidatorUtil.isValidEmail("plainaddress"));
        assertFalse(ValidatorUtil.isValidEmail("@missingusername.com"));
        assertFalse(ValidatorUtil.isValidEmail(null));
    }

    @Test
    @DisplayName("Test phone number validation")
    void testIsValidPhone() {
        assertTrue(ValidatorUtil.isValidPhone("9876543210"));
        assertTrue(ValidatorUtil.isValidPhone("+91-9876543210"));
        assertTrue(ValidatorUtil.isValidPhone("(123) 456-7890"));
        assertFalse(ValidatorUtil.isValidPhone("12345")); // too short
        assertFalse(ValidatorUtil.isValidPhone(null));
    }

    @Test
    @DisplayName("Test account number validation")
    void testIsValidAccountNumber() {
        assertTrue(ValidatorUtil.isValidAccountNumber("1000200030"));
        assertTrue(ValidatorUtil.isValidAccountNumber("123456789012345678"));
        assertFalse(ValidatorUtil.isValidAccountNumber("12345")); // too short
        assertFalse(ValidatorUtil.isValidAccountNumber("12345ABC6789"));
        assertFalse(ValidatorUtil.isValidAccountNumber(null));
    }
}
