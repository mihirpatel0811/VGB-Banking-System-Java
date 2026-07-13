package com.vgb.model;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;

public class AutoPayInstruction {
    private Long autoPayId;
    private Long customerId;
    private String targetType; // 'credit_card', 'loan'
    private Long cardId;
    private Long loanId;
    private Long sourceAccountId;
    private String paymentType; // 'full_amount_due', 'minimum_due', 'monthly_emi'
    private String paymentFrequency; // 'monthly'
    private Date nextPaymentDate;
    private String status; // 'active', 'paused', 'disabled'
    private Timestamp lastProcessedDate;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Transient fields for UI rendering
    private String customerName;
    private String maskedCardNumber;
    private String maskedSourceAccountNumber;
    private String loanType;
    private BigDecimal outstandingDues; // CC outstanding balance or Loan remaining balance

    public Long getAutoPayId() {
        return autoPayId;
    }

    public void setAutoPayId(Long autoPayId) {
        this.autoPayId = autoPayId;
    }

    public Long getCustomerId() {
        return customerId;
    }

    public void setCustomerId(Long customerId) {
        this.customerId = customerId;
    }

    public String getTargetType() {
        return targetType;
    }

    public void setTargetType(String targetType) {
        this.targetType = targetType;
    }

    public Long getCardId() {
        return cardId;
    }

    public void setCardId(Long cardId) {
        this.cardId = cardId;
    }

    public Long getLoanId() {
        return loanId;
    }

    public void setLoanId(Long loanId) {
        this.loanId = loanId;
    }

    public Long getSourceAccountId() {
        return sourceAccountId;
    }

    public void setSourceAccountId(Long sourceAccountId) {
        this.sourceAccountId = sourceAccountId;
    }

    public String getPaymentType() {
        return paymentType;
    }

    public void setPaymentType(String paymentType) {
        this.paymentType = paymentType;
    }

    public String getPaymentFrequency() {
        return paymentFrequency;
    }

    public void setPaymentFrequency(String paymentFrequency) {
        this.paymentFrequency = paymentFrequency;
    }

    public Date getNextPaymentDate() {
        return nextPaymentDate;
    }

    public void setNextPaymentDate(Date nextPaymentDate) {
        this.nextPaymentDate = nextPaymentDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getLastProcessedDate() {
        return lastProcessedDate;
    }

    public void setLastProcessedDate(Timestamp lastProcessedDate) {
        this.lastProcessedDate = lastProcessedDate;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getMaskedCardNumber() {
        return maskedCardNumber;
    }

    public void setMaskedCardNumber(String maskedCardNumber) {
        this.maskedCardNumber = maskedCardNumber;
    }

    public String getMaskedSourceAccountNumber() {
        return maskedSourceAccountNumber;
    }

    public void setMaskedSourceAccountNumber(String maskedSourceAccountNumber) {
        this.maskedSourceAccountNumber = maskedSourceAccountNumber;
    }

    public String getLoanType() {
        return loanType;
    }

    public void setLoanType(String loanType) {
        this.loanType = loanType;
    }

    public BigDecimal getOutstandingDues() {
        return outstandingDues;
    }

    public void setOutstandingDues(BigDecimal outstandingDues) {
        this.outstandingDues = outstandingDues;
    }
}
