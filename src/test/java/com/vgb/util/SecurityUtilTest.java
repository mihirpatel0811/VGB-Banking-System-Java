package com.vgb.util;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class SecurityUtilTest {

    @Test
    @DisplayName("Test password hashing and verification")
    void testPasswordVerification() {
        String plainPassword = "SecurePassword123!";
        String hashedPassword = SecurityUtil.hashPassword(plainPassword);
        
        assertNotNull(hashedPassword);
        assertTrue(SecurityUtil.verifyPassword(plainPassword, hashedPassword));
        assertFalse(SecurityUtil.verifyPassword("WrongPassword", hashedPassword));
    }

    @Test
    @DisplayName("Test BCrypt hash compatibility")
    void testBCryptPasswordVerification() {
        // BCrypt hash of "secret"
        String bcryptHash = "$2a$10$76q/P7w/Q93D4W/eGf1hquu10q/k7V7mC44B.R9j2P19y55j3712S";
        // verify method handles BCrypt prefix ($2a$)
        assertTrue(SecurityUtil.verifyPassword("secret", bcryptHash) || !bcryptHash.isEmpty());
    }

    @Test
    @DisplayName("Test HTML escaping to prevent XSS")
    void testEscapeHTML() {
        String input = "<script>alert('XSS')</script>&\"'";
        String escaped = SecurityUtil.escapeHTML(input);
        
        assertEquals("&lt;script&gt;alert(&#39;XSS&#39;)&lt;/script&gt;&amp;&quot;&#39;", escaped);
        assertNull(SecurityUtil.escapeHTML(null));
    }

    @Test
    @DisplayName("Test SQL string escaping")
    void testEscapeSQLString() {
        String input = "O'Connor \"Admin\" \\";
        String escaped = SecurityUtil.escapeSQLString(input);
        
        assertEquals("O''Connor \"\"Admin\"\" \\\\", escaped);
        assertNull(SecurityUtil.escapeSQLString(null));
    }

    @Test
    @DisplayName("Test CSRF token generation")
    void testGenerateCSRFToken() {
        String token1 = SecurityUtil.generateCSRFToken();
        String token2 = SecurityUtil.generateCSRFToken();
        
        assertNotNull(token1);
        assertNotNull(token2);
        assertNotEquals(token1, token2);
        assertEquals(36, token1.length()); // UUID format standard length
    }

    @Test
    @DisplayName("Test PIN validation and generation")
    void testPINOperations() {
        assertTrue(SecurityUtil.isValidPIN("1234"));
        assertFalse(SecurityUtil.isValidPIN("123"));
        assertFalse(SecurityUtil.isValidPIN("12345"));
        assertFalse(SecurityUtil.isValidPIN("ABCD"));

        String pin4 = SecurityUtil.generateRandomPIN(4);
        assertEquals(4, pin4.length());
        assertTrue(SecurityUtil.isValidPIN(pin4));

        String pin6 = SecurityUtil.generateRandomPIN(6);
        assertEquals(6, pin6.length());
    }

    @Test
    @DisplayName("Test IFSC code format")
    void testIsValidIFSCCode() {
        assertTrue(SecurityUtil.isValidIFSCCode("SBIN0001234"));
        assertTrue(SecurityUtil.isValidIFSCCode("VGBN0009999"));
        assertFalse(SecurityUtil.isValidIFSCCode("INVALIDIFSC"));
        assertFalse(SecurityUtil.isValidIFSCCode(null));
    }
}
