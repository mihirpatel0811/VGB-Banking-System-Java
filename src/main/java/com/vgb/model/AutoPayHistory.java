package com.vgb.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class AutoPayHistory {
    private Long historyId;
    private Long autoPayId;
    private Timestamp paymentDate;
    private BigDecimal amount;
    private String status; // 'completed', 'failed'
    private String failureReason;
    private String transactionReference;

    // Transient fields for UI logs
    private String customerName;
    private String targetType;
    private String paymentType;
    private String maskedCardNumber;
    private String loanType;
    private String maskedSourceAccountNumber;

    public Long getHistoryId() {
        return historyId;
    }

    public void setHistoryId(Long historyId) {
        this.historyId = historyId;
    }

    public Long getAutoPayId() {
        return autoPayId;
    }

    public void setAutoPayId(Long autoPayId) {
        this.autoPayId = autoPayId;
    }

    public Timestamp getPaymentDate() {
        return paymentDate;
    }

    public void setPaymentDate(Timestamp paymentDate) {
        this.paymentDate = paymentDate;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getFailureReason() {
        return failureReason;
    }

    public void setFailureReason(String failureReason) {
        this.failureReason = failureReason;
    }

    public String getTransactionReference() {
        return transactionReference;
    }

    public void setTransactionReference(String transactionReference) {
        this.transactionReference = transactionReference;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getTargetType() {
        return targetType;
    }

    public void setTargetType(String targetType) {
        this.targetType = targetType;
    }

    public String getPaymentType() {
        return paymentType;
    }

    public void setPaymentType(String paymentType) {
        this.paymentType = paymentType;
    }

    public String getMaskedCardNumber() {
        return maskedCardNumber;
    }

    public void setMaskedCardNumber(String maskedCardNumber) {
        this.maskedCardNumber = maskedCardNumber;
    }

    public String getLoanType() {
        return loanType;
    }

    public void setLoanType(String loanType) {
        this.loanType = loanType;
    }

    public String getMaskedSourceAccountNumber() {
        return maskedSourceAccountNumber;
    }

    public void setMaskedSourceAccountNumber(String maskedSourceAccountNumber) {
        this.maskedSourceAccountNumber = maskedSourceAccountNumber;
    }
}
