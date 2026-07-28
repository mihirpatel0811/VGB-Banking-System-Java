package com.vgb.model;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;

import static org.junit.jupiter.api.Assertions.*;

public class LoanTest {

    @Test
    @DisplayName("Test Loan calculations and properties")
    void testLoanModel() {
        Loan loan = new Loan();
        loan.setLoanId(201L);
        loan.setCustomerId(501L);
        loan.setLoanType("personal");
        loan.setPrincipalAmount(new BigDecimal("100000.00"));
        loan.setInterestRate(new BigDecimal("10.5"));
        loan.setTermMonths(24);
        loan.setStatus("approved");

        assertEquals(201L, loan.getLoanId());
        assertEquals("personal", loan.getLoanType());
        assertEquals(new BigDecimal("100000.00"), loan.getPrincipalAmount());
        assertEquals(24, loan.getTermMonths());
        assertEquals("approved", loan.getStatus());
    }
}
