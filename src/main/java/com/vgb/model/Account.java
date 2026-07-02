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

    // Account Credentials
    private String username;
    private String password;
    private String pin;

    // Banking Services options
    private boolean hasAtmCard;
    private boolean hasChequeBook;
    private boolean hasPassbook = true;

    // Sub-table: Savings Accounts fields
    private String nomineeName;
    private String holdingType; // single, joint
    private BigDecimal dailyWithdrawalLimit;
    private Long jointCustomerId;
    private java.util.List<Long> jointCustomerIds;

    public Long getJointCustomerId() { return jointCustomerId; }
    public void setJointCustomerId(Long jointCustomerId) { this.jointCustomerId = jointCustomerId; }

    public java.util.List<Long> getJointCustomerIds() { return jointCustomerIds; }
    public void setJointCustomerIds(java.util.List<Long> jointCustomerIds) { this.jointCustomerIds = jointCustomerIds; }

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

    // Primary Customer fields
    private String primaryFirstName;
    private String primaryMiddleName;
    private String primaryLastName;
    private String primaryEmail;
    private String primaryPhone;
    private String primaryAddress;
    private String primaryCity;
    private String primaryState;
    private String primaryZip;
    private String primaryPan;
    private String primaryAadhaar;
    private String primaryGender;
    private String primaryMaritalStatus;
    private String primaryOccupation;
    private BigDecimal primaryIncome;

    // Joint Customer fields
    private String jointFirstName;
    private String jointMiddleName;
    private String jointLastName;
    private String jointEmail;
    private String jointPhone;
    private java.time.LocalDate jointDob;
    private String jointGender;
    private String jointMaritalStatus;
    private String jointPan;
    private String jointAadhaar;
    private String jointAddress;
    private String jointCity;
    private String jointState;
    private String jointZip;
    private String jointOccupation;
    private BigDecimal jointIncome;

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

    // Getters and Setters for Primary Customer details
    public String getPrimaryFirstName() { return primaryFirstName; }
    public void setPrimaryFirstName(String primaryFirstName) { this.primaryFirstName = primaryFirstName; }

    public String getPrimaryMiddleName() { return primaryMiddleName; }
    public void setPrimaryMiddleName(String primaryMiddleName) { this.primaryMiddleName = primaryMiddleName; }

    public String getPrimaryLastName() { return primaryLastName; }
    public void setPrimaryLastName(String primaryLastName) { this.primaryLastName = primaryLastName; }

    public String getPrimaryEmail() { return primaryEmail; }
    public void setPrimaryEmail(String primaryEmail) { this.primaryEmail = primaryEmail; }

    public String getPrimaryPhone() { return primaryPhone; }
    public void setPrimaryPhone(String primaryPhone) { this.primaryPhone = primaryPhone; }

    public String getPrimaryAddress() { return primaryAddress; }
    public void setPrimaryAddress(String primaryAddress) { this.primaryAddress = primaryAddress; }

    public String getPrimaryCity() { return primaryCity; }
    public void setPrimaryCity(String primaryCity) { this.primaryCity = primaryCity; }

    public String getPrimaryState() { return primaryState; }
    public void setPrimaryState(String primaryState) { this.primaryState = primaryState; }

    public String getPrimaryZip() { return primaryZip; }
    public void setPrimaryZip(String primaryZip) { this.primaryZip = primaryZip; }

    public String getPrimaryPan() { return primaryPan; }
    public void setPrimaryPan(String primaryPan) { this.primaryPan = primaryPan; }

    public String getPrimaryAadhaar() { return primaryAadhaar; }
    public void setPrimaryAadhaar(String primaryAadhaar) { this.primaryAadhaar = primaryAadhaar; }

    public String getPrimaryGender() { return primaryGender; }
    public void setPrimaryGender(String primaryGender) { this.primaryGender = primaryGender; }

    public String getPrimaryMaritalStatus() { return primaryMaritalStatus; }
    public void setPrimaryMaritalStatus(String primaryMaritalStatus) { this.primaryMaritalStatus = primaryMaritalStatus; }

    public String getPrimaryOccupation() { return primaryOccupation; }
    public void setPrimaryOccupation(String primaryOccupation) { this.primaryOccupation = primaryOccupation; }

    public BigDecimal getPrimaryIncome() { return primaryIncome; }
    public void setPrimaryIncome(BigDecimal primaryIncome) { this.primaryIncome = primaryIncome; }

    // Getters and Setters for Joint Customer details
    public String getJointFirstName() { return jointFirstName; }
    public void setJointFirstName(String jointFirstName) { this.jointFirstName = jointFirstName; }

    public String getJointMiddleName() { return jointMiddleName; }
    public void setJointMiddleName(String jointMiddleName) { this.jointMiddleName = jointMiddleName; }

    public String getJointLastName() { return jointLastName; }
    public void setJointLastName(String jointLastName) { this.jointLastName = jointLastName; }

    public String getJointEmail() { return jointEmail; }
    public void setJointEmail(String jointEmail) { this.jointEmail = jointEmail; }

    public String getJointPhone() { return jointPhone; }
    public void setJointPhone(String jointPhone) { this.jointPhone = jointPhone; }

    public java.time.LocalDate getJointDob() { return jointDob; }
    public void setJointDob(java.time.LocalDate jointDob) { this.jointDob = jointDob; }

    public String getJointGender() { return jointGender; }
    public void setJointGender(String jointGender) { this.jointGender = jointGender; }

    public String getJointMaritalStatus() { return jointMaritalStatus; }
    public void setJointMaritalStatus(String jointMaritalStatus) { this.jointMaritalStatus = jointMaritalStatus; }

    public String getJointPan() { return jointPan; }
    public void setJointPan(String jointPan) { this.jointPan = jointPan; }

    public String getJointAadhaar() { return jointAadhaar; }
    public void setJointAadhaar(String jointAadhaar) { this.jointAadhaar = jointAadhaar; }

    public String getJointAddress() { return jointAddress; }
    public void setJointAddress(String jointAddress) { this.jointAddress = jointAddress; }

    public String getJointCity() { return jointCity; }
    public void setJointCity(String jointCity) { this.jointCity = jointCity; }

    public String getJointState() { return jointState; }
    public void setJointState(String jointState) { this.jointState = jointState; }

    public String getJointZip() { return jointZip; }
    public void setJointZip(String jointZip) { this.jointZip = jointZip; }

    public String getJointOccupation() { return jointOccupation; }
    public void setJointOccupation(String jointOccupation) { this.jointOccupation = jointOccupation; }

    public BigDecimal getJointIncome() { return jointIncome; }
    public void setJointIncome(BigDecimal jointIncome) { this.jointIncome = jointIncome; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getPin() { return pin; }
    public void setPin(String pin) { this.pin = pin; }

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
