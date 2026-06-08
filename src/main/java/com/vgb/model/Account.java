package com.vgb.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Account: Bank account model
 */
public class Account implements Serializable {
    private static final long serialVersionUID = 1L;

    private long accountId;
    private long customerId;
    private String accountType; // savings, checking, current, fixed_deposit
    private BigDecimal balance;
    private String ifscCode;
    private String accountNumber;
    private String status; // active, frozen, dormant, closed
    private String customerName; // Transitive property for JOIN query display
    private LocalDateTime createdAt;
    private java.time.LocalDate customerDob;

    // Banking Services options
    private boolean hasAtmCard;
    private boolean hasChequeBook;
    private boolean hasPassbook = true;

    // Sub-table: Savings Accounts fields
    private String nomineeName;
    private String holdingType; // single, joint
    private BigDecimal dailyWithdrawalLimit;

    // Sub-table: Current Business Accounts fields
    private String businessName;
    private String gstin;
    private BigDecimal overdraftLimit;
    private String companyCategory;
    private String companyPhone;
    private String companyEmail;
    private String companyAddress;
    private String companyPan;
    private String companyAadhaar;

    // Constructors
    public Account() {}

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public java.time.LocalDate getCustomerDob() { return customerDob; }
    public void setCustomerDob(java.time.LocalDate customerDob) { this.customerDob = customerDob; }

    public String getAgeCategory() {
        if (customerDob == null) {
            return "";
        }
        int age = java.time.Period.between(customerDob, java.time.LocalDate.now()).getYears();
        return age >= 18 ? "Major Account" : "Minor Account";
    }

    public Account(long customerId, String accountType, String accountNumber) {
        this.customerId = customerId;
        this.accountType = accountType;
        this.accountNumber = accountNumber;
        this.balance = BigDecimal.ZERO;
        this.status = "active";
    }

    // Getters and Setters
    public long getAccountId() { return accountId; }
    public void setAccountId(long accountId) { this.accountId = accountId; }

    public long getCustomerId() { return customerId; }
    public void setCustomerId(long customerId) { this.customerId = customerId; }

    public String getAccountType() { return accountType; }
    public void setAccountType(String accountType) { this.accountType = accountType; }

    public BigDecimal getBalance() { return balance; }
    public void setBalance(BigDecimal balance) { this.balance = balance; }

    public String getIfscCode() { return ifscCode; }
    public void setIfscCode(String ifscCode) { this.ifscCode = ifscCode; }

    public String getAccountNumber() { return accountNumber; }
    public void setAccountNumber(String accountNumber) { this.accountNumber = accountNumber; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public boolean isHasAtmCard() { return hasAtmCard; }
    public void setHasAtmCard(boolean hasAtmCard) { this.hasAtmCard = hasAtmCard; }

    public boolean isHasChequeBook() { return hasChequeBook; }
    public void setHasChequeBook(boolean hasChequeBook) { this.hasChequeBook = hasChequeBook; }

    public boolean isHasPassbook() { return hasPassbook; }
    public void setHasPassbook(boolean hasPassbook) { this.hasPassbook = hasPassbook; }

    public String getNomineeName() { return nomineeName; }
    public void setNomineeName(String nomineeName) { this.nomineeName = nomineeName; }

    public String getHoldingType() { return holdingType; }
    public void setHoldingType(String holdingType) { this.holdingType = holdingType; }

    public BigDecimal getDailyWithdrawalLimit() { return dailyWithdrawalLimit; }
    public void setDailyWithdrawalLimit(BigDecimal dailyWithdrawalLimit) { this.dailyWithdrawalLimit = dailyWithdrawalLimit; }

    public String getBusinessName() { return businessName; }
    public void setBusinessName(String businessName) { this.businessName = businessName; }

    public String getGstin() { return gstin; }
    public void setGstin(String gstin) { this.gstin = gstin; }

    public BigDecimal getOverdraftLimit() { return overdraftLimit; }
    public void setOverdraftLimit(BigDecimal overdraftLimit) { this.overdraftLimit = overdraftLimit; }

    public String getCompanyCategory() { return companyCategory; }
    public void setCompanyCategory(String companyCategory) { this.companyCategory = companyCategory; }

    public String getCompanyPhone() { return companyPhone; }
    public void setCompanyPhone(String companyPhone) { this.companyPhone = companyPhone; }

    public String getCompanyEmail() { return companyEmail; }
    public void setCompanyEmail(String companyEmail) { this.companyEmail = companyEmail; }

    public String getCompanyAddress() { return companyAddress; }
    public void setCompanyAddress(String companyAddress) { this.companyAddress = companyAddress; }

    public String getCompanyPan() { return companyPan; }
    public void setCompanyPan(String companyPan) { this.companyPan = companyPan; }

    public String getCompanyAadhaar() { return companyAadhaar; }
    public void setCompanyAadhaar(String companyAadhaar) { this.companyAadhaar = companyAadhaar; }

    @Override
    public String toString() {
        return "Account{" +
                "accountId=" + accountId +
                ", customerId=" + customerId +
                ", accountType='" + accountType + '\'' +
                ", balance=" + balance +
                ", accountNumber='" + accountNumber + '\'' +
                ", status='" + status + '\'' +
                ", hasAtmCard=" + hasAtmCard +
                ", hasChequeBook=" + hasChequeBook +
                ", hasPassbook=" + hasPassbook +
                ", companyPan='" + companyPan + '\'' +
                ", companyAadhaar='" + companyAadhaar + '\'' +
                '}';
    }
}
