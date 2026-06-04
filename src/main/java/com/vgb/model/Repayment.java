package com.vgb.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Repayment: Loan repayment model
 */
public class Repayment implements Serializable {
    private static final long serialVersionUID = 1L;

    private long repaymentId;
    private long loanId;
    private long customerId;
    private long transactionId;
    private BigDecimal amountPaid;
    private BigDecimal principalComponent;
    private BigDecimal interestComponent;
    private LocalDateTime repaymentDate;

    // Constructors
    public Repayment() {}

    public Repayment(long loanId, long customerId, BigDecimal amountPaid) {
        this.loanId = loanId;
        this.customerId = customerId;
        this.amountPaid = amountPaid;
    }

    // Getters and Setters
    public long getRepaymentId() { return repaymentId; }
    public void setRepaymentId(long repaymentId) { this.repaymentId = repaymentId; }

    public long getLoanId() { return loanId; }
    public void setLoanId(long loanId) { this.loanId = loanId; }

    public long getCustomerId() { return customerId; }
    public void setCustomerId(long customerId) { this.customerId = customerId; }

    public long getTransactionId() { return transactionId; }
    public void setTransactionId(long transactionId) { this.transactionId = transactionId; }

    public BigDecimal getAmountPaid() { return amountPaid; }
    public void setAmountPaid(BigDecimal amountPaid) { this.amountPaid = amountPaid; }

    public BigDecimal getPrincipalComponent() { return principalComponent; }
    public void setPrincipalComponent(BigDecimal principalComponent) { this.principalComponent = principalComponent; }

    public BigDecimal getInterestComponent() { return interestComponent; }
    public void setInterestComponent(BigDecimal interestComponent) { this.interestComponent = interestComponent; }

    public LocalDateTime getRepaymentDate() { return repaymentDate; }
    public void setRepaymentDate(LocalDateTime repaymentDate) { this.repaymentDate = repaymentDate; }

    public String getFormattedRepaymentDate() {
        if (repaymentDate == null) return "";
        java.time.format.DateTimeFormatter formatter = java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        return repaymentDate.format(formatter);
    }

    @Override
    public String toString() {
        return "Repayment{" +
                "repaymentId=" + repaymentId +
                ", loanId=" + loanId +
                ", amountPaid=" + amountPaid +
                ", repaymentDate=" + repaymentDate +
                '}';
    }
}
