package com.vgb.service;

import com.vgb.exception.BankingException;
import com.vgb.model.Loan;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;

import static org.junit.jupiter.api.Assertions.*;

public class LoanServiceTest {

    private LoanService loanService = new LoanService();

    @Test
    @DisplayName("Test loan application validation for negative or zero amounts")
    void testApplyLoanValidation() {
        Loan loanZero = new Loan();
        loanZero.setCustomerId(1L);
        loanZero.setLoanType("personal");
        loanZero.setPrincipalAmount(new BigDecimal("0"));
        loanZero.setTermMonths(12);
        loanZero.setFormDetails("Salary Slip");

        assertThrows(BankingException.class, () -> 
            loanService.applyForLoan(loanZero)
        );

        Loan loanNegative = new Loan();
        loanNegative.setCustomerId(1L);
        loanNegative.setLoanType("personal");
        loanNegative.setPrincipalAmount(new BigDecimal("-1000"));
        loanNegative.setTermMonths(12);
        loanNegative.setFormDetails("Salary Slip");

        assertThrows(BankingException.class, () -> 
            loanService.applyForLoan(loanNegative)
        );
    }
}
