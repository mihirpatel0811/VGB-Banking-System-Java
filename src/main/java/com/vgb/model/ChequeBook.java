package com.vgb.model;

import java.sql.Timestamp;

public class ChequeBook {
    private long chequebookId;
    private long accountId;
    private String chequebookNumber;
    private int startChequeNo;
    private int endChequeNo;
    private String status;
    private Timestamp createdAt;

    public ChequeBook() {}

    public long getChequebookId() {
        return chequebookId;
    }

    public void setChequebookId(long chequebookId) {
        this.chequebookId = chequebookId;
    }

    public long getAccountId() {
        return accountId;
    }

    public void setAccountId(long accountId) {
        this.accountId = accountId;
    }

    public String getChequebookNumber() {
        return chequebookNumber;
    }

    public void setChequebookNumber(String chequebookNumber) {
        this.chequebookNumber = chequebookNumber;
    }

    public int getStartChequeNo() {
        return startChequeNo;
    }

    public void setStartChequeNo(int startChequeNo) {
        this.startChequeNo = startChequeNo;
    }

    public int getEndChequeNo() {
        return endChequeNo;
    }

    public void setEndChequeNo(int endChequeNo) {
        this.endChequeNo = endChequeNo;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
