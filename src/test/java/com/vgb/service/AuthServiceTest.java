package com.vgb.service;

import com.vgb.model.Customer;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class AuthServiceTest {

    private AuthService authService = new AuthService();

    @Test
    @DisplayName("Test null or empty input checks for login")
    void testLoginWithInvalidCredentials() {
        assertThrows(IllegalArgumentException.class, () -> authService.loginCustomer(null, "password"));
        assertThrows(IllegalArgumentException.class, () -> authService.loginCustomer("user", null));
        assertThrows(IllegalArgumentException.class, () -> authService.loginCustomer("   ", "password"));
    }

    @Test
    @DisplayName("Test customer model mapping during registration/login setup")
    void testCustomerCreationModel() {
        Customer customer = new Customer();
        customer.setCustomerId(101L);
        customer.setUsername("johndoe");
        customer.setEmail("john@vgb.com");
        customer.setFullName("John Doe");
        customer.setPhoneNumber("9876543210");
        customer.setRole("CUSTOMER");

        assertEquals("johndoe", customer.getUsername());
        assertEquals("john@vgb.com", customer.getEmail());
        assertEquals("John Doe", customer.getFullName());
        assertEquals("9876543210", customer.getPhoneNumber());
        assertEquals("CUSTOMER", customer.getRole());
    }
}
