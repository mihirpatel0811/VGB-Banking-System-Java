package com.vgb.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class ChequeBookRequest {
    private long requestId;
    private long accountId;
    private long customerId;
    private int leavesCount;
    private String status; // 'pending', 'approved', 'rejected', 'delivered'
    private BigDecimal charges;
    private boolean isChargesPaid;
    private Timestamp requestedAt;

    // Transient helper fields for JSP rendering
    private String accountNumber;
    private String accountType;
    private String customerName;

    public ChequeBookRequest() {
        this.status = "pending";
        this.isChargesPaid = false;
    }

    public long getRequestId() {
        return requestId;
    }

    public void setRequestId(long requestId) {
        this.requestId = requestId;
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

    public int getLeavesCount() {
        return leavesCount;
    }

    public void setLeavesCount(int leavesCount) {
        this.leavesCount = leavesCount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public BigDecimal getCharges() {
        return charges;
    }

    public void setCharges(BigDecimal charges) {
        this.charges = charges;
    }

    public boolean isChargesPaid() {
        return isChargesPaid;
    }

    public void setChargesPaid(boolean chargesPaid) {
        this.isChargesPaid = chargesPaid;
    }

    public Timestamp getRequestedAt() {
        return requestedAt;
    }

    public void setRequestedAt(Timestamp requestedAt) {
        this.requestedAt = requestedAt;
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

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }
}
