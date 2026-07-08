package com.vgb.model;

import java.sql.Timestamp;

public class ChequeLeaf {
    private long chequeId;
    private long chequebookId;
    private String chequeNumber;
    private String status;
    private Timestamp usedAt;

    public ChequeLeaf() {}

    public long getChequeId() {
        return chequeId;
    }

    public void setChequeId(long chequeId) {
        this.chequeId = chequeId;
    }

    public long getChequebookId() {
        return chequebookId;
    }

    public void setChequebookId(long chequebookId) {
        this.chequebookId = chequebookId;
    }

    public String getChequeNumber() {
        return chequeNumber;
    }

    public void setChequeNumber(String chequeNumber) {
        this.chequeNumber = chequeNumber;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getUsedAt() {
        return usedAt;
    }

    public void setUsedAt(Timestamp usedAt) {
        this.usedAt = usedAt;
    }
}
