package com.vgb.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Transaction: Bank transaction model
 */
public class Transaction implements Serializable {
    private static final long serialVersionUID = 1L;

    private long transactionId;
    private Long fromAccountId;
    private Long toAccountId;
    private String transactionType; // deposit, withdrawal, transfer, interest, fee
    private BigDecimal amount;
    private String referenceNumber;
    private String description;
    private String status; // pending, completed, failed, reversed
    private LocalDateTime transactionDate;
    private BigDecimal runningBalance;
    
    // Auditing and Beneficiary Fields
    private String transferMode;
    private String senderAccountNumber;
    private String receiverAccountNumber;
    private String beneficiaryName;
    private String beneficiaryIfsc;
    private String beneficiaryBank;
    private String beneficiaryBranch;
    private Long performedById;

    // Constructors
    public Transaction() {}

    public Transaction(String transactionType, BigDecimal amount, String referenceNumber) {
        this.transactionType = transactionType;
        this.amount = amount;
        this.referenceNumber = referenceNumber;
        this.status = "completed";
    }

    // Getters and Setters
    public long getTransactionId() { return transactionId; }
    public void setTransactionId(long transactionId) { this.transactionId = transactionId; }

    public Long getFromAccountId() { return fromAccountId; }
    public void setFromAccountId(Long fromAccountId) { this.fromAccountId = fromAccountId; }

    public Long getToAccountId() { return toAccountId; }
    public void setToAccountId(Long toAccountId) { this.toAccountId = toAccountId; }

    public String getTransactionType() { return transactionType; }
    public void setTransactionType(String transactionType) { this.transactionType = transactionType; }

    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }

    public String getReferenceNumber() { return referenceNumber; }
    public void setReferenceNumber(String referenceNumber) { this.referenceNumber = referenceNumber; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getTransactionDate() { return transactionDate; }
    public void setTransactionDate(LocalDateTime transactionDate) { this.transactionDate = transactionDate; }

    public BigDecimal getRunningBalance() { return runningBalance; }
    public void setRunningBalance(BigDecimal runningBalance) { this.runningBalance = runningBalance; }

    public String getTransferMode() { return transferMode; }
    public void setTransferMode(String transferMode) { this.transferMode = transferMode; }

    public String getSenderAccountNumber() { return senderAccountNumber; }
    public void setSenderAccountNumber(String senderAccountNumber) { this.senderAccountNumber = senderAccountNumber; }

    public String getReceiverAccountNumber() { return receiverAccountNumber; }
    public void setReceiverAccountNumber(String receiverAccountNumber) { this.receiverAccountNumber = receiverAccountNumber; }

    public String getBeneficiaryName() { return beneficiaryName; }
    public void setBeneficiaryName(String beneficiaryName) { this.beneficiaryName = beneficiaryName; }

    public String getBeneficiaryIfsc() { return beneficiaryIfsc; }
    public void setBeneficiaryIfsc(String beneficiaryIfsc) { this.beneficiaryIfsc = beneficiaryIfsc; }

    public String getBeneficiaryBank() { return beneficiaryBank; }
    public void setBeneficiaryBank(String beneficiaryBank) { this.beneficiaryBank = beneficiaryBank; }

    public String getBeneficiaryBranch() { return beneficiaryBranch; }
    public void setBeneficiaryBranch(String beneficiaryBranch) { this.beneficiaryBranch = beneficiaryBranch; }

    public Long getPerformedById() { return performedById; }
    public void setPerformedById(Long performedById) { this.performedById = performedById; }

    @Override
    public String toString() {
        return "Transaction{" +
                "transactionId=" + transactionId +
                ", transactionType='" + transactionType + '\'' +
                ", amount=" + amount +
                ", status='" + status + '\'' +
                ", transactionDate=" + transactionDate +
                '}';
    }
}
