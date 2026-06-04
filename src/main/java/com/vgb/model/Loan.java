package com.vgb.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Loan: Bank loan model
 */
public class Loan implements Serializable {
    private static final long serialVersionUID = 1L;

    private long loanId;
    private long customerId;
    private String loanType; // home, car, personal, education
    private BigDecimal principalAmount;
    private BigDecimal remainingBalance;
    private BigDecimal interestRate;
    private int termMonths;
    private LocalDate startDate;
    private LocalDate endDate;
    private String status; // pending_approval, approved, disbursed, active, rejected, closed, defaulted
    private LocalDateTime createdAt;
    private String formDetails;

    // Constructors
    public Loan() {}

    public Loan(long customerId, String loanType, BigDecimal principalAmount) {
        this.customerId = customerId;
        this.loanType = loanType;
        this.principalAmount = principalAmount;
        this.remainingBalance = principalAmount;
        this.status = "pending_approval";
    }

    // Getters and Setters
    public long getLoanId() { return loanId; }
    public void setLoanId(long loanId) { this.loanId = loanId; }

    public long getCustomerId() { return customerId; }
    public void setCustomerId(long customerId) { this.customerId = customerId; }

    public String getLoanType() { return loanType; }
    public void setLoanType(String loanType) { this.loanType = loanType; }

    public BigDecimal getPrincipalAmount() { return principalAmount; }
    public void setPrincipalAmount(BigDecimal principalAmount) { this.principalAmount = principalAmount; }

    public BigDecimal getRemainingBalance() { return remainingBalance; }
    public void setRemainingBalance(BigDecimal remainingBalance) { this.remainingBalance = remainingBalance; }

    public BigDecimal getInterestRate() { return interestRate; }
    public void setInterestRate(BigDecimal interestRate) { this.interestRate = interestRate; }

    public int getTermMonths() { return termMonths; }
    public void setTermMonths(int termMonths) { this.termMonths = termMonths; }

    public LocalDate getStartDate() { return startDate; }
    public void setStartDate(LocalDate startDate) { this.startDate = startDate; }

    public LocalDate getEndDate() { return endDate; }
    public void setEndDate(LocalDate endDate) { this.endDate = endDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    
    public String getFormDetails() { return formDetails; }
    public void setFormDetails(String formDetails) { this.formDetails = formDetails; }

    /**
     * Calculate monthly EMI for the loan dynamically
     */
    public BigDecimal getMonthlyEMI() {
        if (principalAmount == null || interestRate == null || termMonths <= 0) {
            return BigDecimal.ZERO;
        }
        double p = principalAmount.doubleValue();
        double r = (interestRate.doubleValue() / 12) / 100;
        int n = termMonths;
        if (r == 0) {
            return BigDecimal.valueOf(p / n).setScale(2, RoundingMode.HALF_UP);
        }
        double emi = (p * r * Math.pow(1 + r, n)) / (Math.pow(1 + r, n) - 1);
        return BigDecimal.valueOf(emi).setScale(2, RoundingMode.HALF_UP);
    }

    @Override
    public String toString() {
        return "Loan{" +
                "loanId=" + loanId +
                ", customerId=" + customerId +
                ", loanType='" + loanType + '\'' +
                ", principalAmount=" + principalAmount +
                ", status='" + status + '\'' +
                '}';
    }
}
