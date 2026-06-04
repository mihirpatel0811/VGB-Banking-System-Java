package com.vgb.model;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;

public class Card {
    private long cardId;
    private long accountId;
    private long customerId;
    private String cardNumber;
    private String cardType; // 'debit' or 'credit'
    private String cardProvider; // 'visa', 'mastercard', 'rupay'
    private String cardHolderName;
    private String cvv;
    private Date expiryDate;
    private String status; // 'pending', 'active', 'closed', 'expired'
    private BigDecimal dailyLimit;
    private BigDecimal cardFee;
    private BigDecimal outstandingBalance;
    private boolean isFeePaid;
    private Timestamp createdAt;

    // Additional transient helper fields (optional for JSP rendering)
    private String accountNumber;
    private String accountType;

    public Card() {
        this.dailyLimit = new BigDecimal("50000.0000");
        this.outstandingBalance = BigDecimal.ZERO;
        this.isFeePaid = false;
    }

    public long getCardId() {
        return cardId;
    }

    public void setCardId(long cardId) {
        this.cardId = cardId;
    }

    public long getAccountId() {
        return accountId;
    }

    public void setAccountId(long accountId) {
        this.accountId = accountId;
    }

    public long getCustomerId() {
        return customerId;
    }

    public void setCustomerId(long customerId) {
        this.customerId = customerId;
    }

    public String getCardNumber() {
        return cardNumber;
    }

    public void setCardNumber(String cardNumber) {
        this.cardNumber = cardNumber;
    }

    public String getCardType() {
        return cardType;
    }

    public void setCardType(String cardType) {
        this.cardType = cardType;
    }

    public String getCardProvider() {
        return cardProvider;
    }

    public void setCardProvider(String cardProvider) {
        this.cardProvider = cardProvider;
    }

    public String getCardHolderName() {
        return cardHolderName;
    }

    public void setCardHolderName(String cardHolderName) {
        this.cardHolderName = cardHolderName;
    }

    public String getCvv() {
        return cvv;
    }

    public void setCvv(String cvv) {
        this.cvv = cvv;
    }

    public Date getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(Date expiryDate) {
        this.expiryDate = expiryDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public BigDecimal getDailyLimit() {
        return dailyLimit;
    }

    public void setDailyLimit(BigDecimal dailyLimit) {
        this.dailyLimit = dailyLimit;
    }

    public BigDecimal getCardFee() {
        return cardFee;
    }

    public void setCardFee(BigDecimal cardFee) {
        this.cardFee = cardFee;
    }

    public BigDecimal getOutstandingBalance() {
        return outstandingBalance;
    }

    public void setOutstandingBalance(BigDecimal outstandingBalance) {
        this.outstandingBalance = outstandingBalance;
    }

    public boolean isFeePaid() {
        return isFeePaid;
    }

    public void setFeePaid(boolean isFeePaid) {
        this.isFeePaid = isFeePaid;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getAccountNumber() {
        return accountNumber;
    }

    public void setAccountNumber(String accountNumber) {
        this.accountNumber = accountNumber;
    }

    public String getAccountType() {
        return accountType;
    }

    public void setAccountType(String accountType) {
        this.accountType = accountType;
    }

    // Helper mask method
    public String getMaskedCardNumber() {
        if (cardNumber != null && cardNumber.length() >= 16) {
            String clean = cardNumber.replace(" ", "");
            return "****  ••••  ••••  " + clean.substring(clean.length() - 4);
        }
        return "••••  ••••  ••••  ••••";
    }
}
