package com.vgb.model;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;

import static org.junit.jupiter.api.Assertions.*;

public class AccountTest {

    @Test
    @DisplayName("Test Account getters, setters, and status helpers")
    void testAccountModel() {
        Account account = new Account();
        account.setAccountId(1001L);
        account.setCustomerId(501L);
        account.setAccountNumber("VGB1000200030");
        account.setAccountType("savings");
        account.setBalance(new BigDecimal("15000.50"));
        account.setStatus("active");

        assertEquals(1001L, account.getAccountId());
        assertEquals(501L, account.getCustomerId());
        assertEquals("VGB1000200030", account.getAccountNumber());
        assertEquals("savings", account.getAccountType());
        assertEquals(new BigDecimal("15000.50"), account.getBalance());
        assertEquals("active", account.getStatus());
    }
}
