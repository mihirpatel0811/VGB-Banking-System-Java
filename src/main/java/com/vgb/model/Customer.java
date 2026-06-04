package com.vgb.model;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * Customer: Customer user model
 */
public class Customer implements Serializable {
    private static final long serialVersionUID = 1L;

    private long customerId;
    private String firstName;
    private String middleName;
    private String lastName;
    private String fatherName;
    private String motherName;
    private java.time.LocalDate dob;
    private String gender;
    private String maritalStatus;
    private String nationality;
    private String email;
    private String phoneNo;
    private String altPhoneNo;
    private String address;
    private String permAddress;
    private String city;
    private String state;
    private String zipCode;
    private String username;
    private String pin;
    private String password;
    private String status; // pending_kyc, active, suspended, closed
    private String panCard;
    private String aadhaarCard;
    private String avatarPath;
    private String occupation;
    private java.math.BigDecimal annualIncome;
    private LocalDateTime createdAt;

    // Constructors
    public Customer() {}

    public Customer(String firstName, String lastName, String email, String phoneNo) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.phoneNo = phoneNo;
    }

    // Getters and Setters
    public String getPanCard() { return panCard; }
    public void setPanCard(String panCard) { this.panCard = panCard; }

    public String getAadhaarCard() { return aadhaarCard; }
    public void setAadhaarCard(String aadhaarCard) { this.aadhaarCard = aadhaarCard; }

    // Getters and Setters
    public long getCustomerId() { return customerId; }
    public void setCustomerId(long customerId) { this.customerId = customerId; }

    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { this.firstName = firstName; }

    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { this.lastName = lastName; }

    public String getFullName() { return firstName + " " + lastName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhoneNo() { return phoneNo; }
    public void setPhoneNo(String phoneNo) { this.phoneNo = phoneNo; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }

    public String getState() { return state; }
    public void setState(String state) { this.state = state; }

    public String getZipCode() { return zipCode; }
    public void setZipCode(String zipCode) { this.zipCode = zipCode; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPin() { return pin; }
    public void setPin(String pin) { this.pin = pin; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public String getAvatarPath() { return avatarPath; }
    public void setAvatarPath(String avatarPath) { this.avatarPath = avatarPath; }

    public String getMiddleName() { return middleName; }
    public void setMiddleName(String middleName) { this.middleName = middleName; }

    public String getFatherName() { return fatherName; }
    public void setFatherName(String fatherName) { this.fatherName = fatherName; }

    public String getMotherName() { return motherName; }
    public void setMotherName(String motherName) { this.motherName = motherName; }

    public java.time.LocalDate getDob() { return dob; }
    public void setDob(java.time.LocalDate dob) { this.dob = dob; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public String getMaritalStatus() { return maritalStatus; }
    public void setMaritalStatus(String maritalStatus) { this.maritalStatus = maritalStatus; }

    public String getNationality() { return nationality; }
    public void setNationality(String nationality) { this.nationality = nationality; }

    public String getAltPhoneNo() { return altPhoneNo; }
    public void setAltPhoneNo(String altPhoneNo) { this.altPhoneNo = altPhoneNo; }

    public String getPermAddress() { return permAddress; }
    public void setPermAddress(String permAddress) { this.permAddress = permAddress; }

    public String getOccupation() { return occupation; }
    public void setOccupation(String occupation) { this.occupation = occupation; }

    public java.math.BigDecimal getAnnualIncome() { return annualIncome; }
    public void setAnnualIncome(java.math.BigDecimal annualIncome) { this.annualIncome = annualIncome; }

    @Override
    public String toString() {
        return "Customer{" +
                "customerId=" + customerId +
                ", firstName='" + firstName + '\'' +
                ", lastName='" + lastName + '\'' +
                ", email='" + email + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}
