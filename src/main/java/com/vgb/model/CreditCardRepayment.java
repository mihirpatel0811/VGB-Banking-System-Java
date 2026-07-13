package com.vgb.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class CreditCardRepayment {
    private long repaymentId;
    private long cardId;
    private long customerId;
    private long accountId;
    private BigDecimal amountPaid;
    private String paymentOption; // 'minimum', 'full', 'custom'
    private String transactionReference;
    private Timestamp repaymentDate;
    private String status; // 'completed', 'failed'

    // Transient helper fields
    private String maskedCardNumber;
    private String cardHolderName;
    private String sourceAccountNumber;

    public CreditCardRepayment() {}

    public long getRepaymentId() {
        return repaymentId;
    }

    public void setRepaymentId(long repaymentId) {
        this.repaymentId = repaymentId;
    }

    public long getCardId() {
        return cardId;
    }

    public void setCardId(long cardId) {
        this.cardId = cardId;
    }

    public long getCustomerId() {
        return customerId;
    }

    public void setCustomerId(long customerId) {
        this.customerId = customerId;
    }

    public long getAccountId() {
        return accountId;
    }

    public void setAccountId(long accountId) {
        this.accountId = accountId;
    }

    public BigDecimal getAmountPaid() {
        return amountPaid;
    }

    public void setAmountPaid(BigDecimal amountPaid) {
        this.amountPaid = amountPaid;
    }

    public String getPaymentOption() {
        return paymentOption;
    }

    public void setPaymentOption(String paymentOption) {
        this.paymentOption = paymentOption;
    }

    public String getTransactionReference() {
        return transactionReference;
    }

    public void setTransactionReference(String transactionReference) {
        this.transactionReference = transactionReference;
    }

    public Timestamp getRepaymentDate() {
        return repaymentDate;
    }

    public void setRepaymentDate(Timestamp repaymentDate) {
        this.repaymentDate = repaymentDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    // Helpers
    public String getMaskedCardNumber() {
        return maskedCardNumber;
    }

    public void setMaskedCardNumber(String maskedCardNumber) {
        this.maskedCardNumber = maskedCardNumber;
    }

    public String getCardHolderName() {
        return cardHolderName;
    }

    public void setCardHolderName(String cardHolderName) {
        this.cardHolderName = cardHolderName;
    }

    public String getSourceAccountNumber() {
        return sourceAccountNumber;
    }

    public void setSourceAccountNumber(String sourceAccountNumber) {
        this.sourceAccountNumber = sourceAccountNumber;
    }
}
