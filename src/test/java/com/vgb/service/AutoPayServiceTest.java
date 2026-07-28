package com.vgb.service;

import com.vgb.model.AutoPayInstruction;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.sql.Date;

import static org.junit.jupiter.api.Assertions.*;

public class AutoPayServiceTest {

    private AutoPayService autoPayService = new AutoPayService();

    @Test
    @DisplayName("Test AutoPay instruction creation with null next payment date")
    void testCreateAutoPay_NullNextPaymentDate() {
        AutoPayInstruction invalidInstruction = new AutoPayInstruction();
        invalidInstruction.setCustomerId(1L);
        invalidInstruction.setSourceAccountId(101L);
        invalidInstruction.setTargetType("credit_card");
        invalidInstruction.setCardId(1L);
        invalidInstruction.setNextPaymentDate(null);

        assertThrows(Exception.class, () -> 
            autoPayService.createInstruction(invalidInstruction)
        );
    }

    @Test
    @DisplayName("Test AutoPay instruction creation with invalid source account")
    void testCreateAutoPay_InvalidSourceAccount() {
        Date futureDate = new Date(System.currentTimeMillis() + 86400000L);

        AutoPayInstruction invalidInstruction = new AutoPayInstruction();
        invalidInstruction.setCustomerId(1L);
        invalidInstruction.setSourceAccountId(999999L);
        invalidInstruction.setTargetType("credit_card");
        invalidInstruction.setCardId(1L);
        invalidInstruction.setNextPaymentDate(futureDate);

        assertThrows(Exception.class, () -> 
            autoPayService.createInstruction(invalidInstruction)
        );
    }
}
