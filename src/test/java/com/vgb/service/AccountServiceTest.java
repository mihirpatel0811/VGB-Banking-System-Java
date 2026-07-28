package com.vgb.service;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;

import static org.junit.jupiter.api.Assertions.*;

public class AccountServiceTest {

    private AccountService accountService = new AccountService();

    @Test
    @DisplayName("Test transfer input validation")
    void testTransferValidation() {
        // Zero or negative amount transfer should fail
        assertThrows(Exception.class, () -> 
            accountService.transfer(101L, 102L, new BigDecimal("0.00"), "Zero transfer")
        );

        assertThrows(Exception.class, () -> 
            accountService.transfer(101L, 102L, new BigDecimal("-50.00"), "Negative transfer")
        );

        // Same account transfer or non-existent account should fail
        assertThrows(Exception.class, () -> 
            accountService.transfer(101L, 101L, new BigDecimal("100.00"), "Self transfer")
        );
    }
}
