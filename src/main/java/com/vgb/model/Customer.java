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

    // Minor Guardian details
    private String guardianName;
    private String guardianRelationship;
    private String guardianPhone;
    private String guardianAadhaar;
    private String guardianPan;
    private String guardianSignaturePath;
    private String birthCertificatePath;

    // Student details
    private String schoolCollegeName;
    private String studentId;
    private String course;
    private String admissionNumber;

    // Salary details
    private String companyName;
    private String employerName;
    private String employeeId;
    private String salaryFrequency;

    // Senior RM details
    private String relationshipManager;

    // Standard KYC proof paths and document numbers
    private String passportNo;
    private String drivingLicenseNo;
    private String voterIdNo;
    private String aadhaarProofPath;
    private String panProofPath;
    private String passportCopyPath;
    private String drivingLicenseCopyPath;
    private String voterIdCopyPath;
    private String signaturePath;

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

    public String getFullName() { 
        if (firstName == null && lastName == null) return null;
        return ((firstName != null ? firstName : "") + " " + (lastName != null ? lastName : "")).trim();
    }
    public void setFullName(String fullName) {
        if (fullName != null) {
            String[] parts = fullName.trim().split("\\s+", 2);
            this.firstName = parts[0];
            this.lastName = parts.length > 1 ? parts[1] : "";
        }
    }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhoneNo() { return phoneNo; }
    public void setPhoneNo(String phoneNo) { this.phoneNo = phoneNo; }

    public String getPhoneNumber() { return phoneNo; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNo = phoneNumber; }

    private String role = "CUSTOMER";
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

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

    public String getAvatarPath() { 
        if (avatarPath != null) {
            String trimmed = avatarPath.trim();
            if (!trimmed.isEmpty() && !"null".equalsIgnoreCase(trimmed)) {
                if (!trimmed.startsWith("/")) {
                    return "/" + trimmed;
                }
                return trimmed;
            }
        }
        return null; 
    }
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

    // Getters and Setters for Guardian Details
    public String getGuardianName() { return guardianName; }
    public void setGuardianName(String guardianName) { this.guardianName = guardianName; }

    public String getGuardianRelationship() { return guardianRelationship; }
    public void setGuardianRelationship(String guardianRelationship) { this.guardianRelationship = guardianRelationship; }

    public String getGuardianPhone() { return guardianPhone; }
    public void setGuardianPhone(String guardianPhone) { this.guardianPhone = guardianPhone; }

    public String getGuardianAadhaar() { return guardianAadhaar; }
    public void setGuardianAadhaar(String guardianAadhaar) { this.guardianAadhaar = guardianAadhaar; }

    public String getGuardianPan() { return guardianPan; }
    public void setGuardianPan(String guardianPan) { this.guardianPan = guardianPan; }

    public String getGuardianSignaturePath() { return guardianSignaturePath; }
    public void setGuardianSignaturePath(String guardianSignaturePath) { this.guardianSignaturePath = guardianSignaturePath; }

    public String getBirthCertificatePath() { return birthCertificatePath; }
    public void setBirthCertificatePath(String birthCertificatePath) { this.birthCertificatePath = birthCertificatePath; }

    // Getters and Setters for Student Details
    public String getSchoolCollegeName() { return schoolCollegeName; }
    public void setSchoolCollegeName(String schoolCollegeName) { this.schoolCollegeName = schoolCollegeName; }

    public String getStudentId() { return studentId; }
    public void setStudentId(String studentId) { this.studentId = studentId; }

    public String getCourse() { return course; }
    public void setCourse(String course) { this.course = course; }

    public String getAdmissionNumber() { return admissionNumber; }
    public void setAdmissionNumber(String admissionNumber) { this.admissionNumber = admissionNumber; }

    // Getters and Setters for Salary Details
    public String getCompanyName() { return companyName; }
    public void setCompanyName(String companyName) { this.companyName = companyName; }

    public String getEmployerName() { return employerName; }
    public void setEmployerName(String employerName) { this.employerName = employerName; }

    public String getEmployeeId() { return employeeId; }
    public void setEmployeeId(String employeeId) { this.employeeId = employeeId; }

    public String getSalaryFrequency() { return salaryFrequency; }
    public void setSalaryFrequency(String salaryFrequency) { this.salaryFrequency = salaryFrequency; }

    // Getters and Setters for Senior RM details
    public String getRelationshipManager() { return relationshipManager; }
    public void setRelationshipManager(String relationshipManager) { this.relationshipManager = relationshipManager; }

    // Getters and Setters for Standard KYC proof paths
    public String getAadhaarProofPath() { return aadhaarProofPath; }
    public void setAadhaarProofPath(String aadhaarProofPath) { this.aadhaarProofPath = aadhaarProofPath; }

    public String getPanProofPath() { return panProofPath; }
    public void setPanProofPath(String panProofPath) { this.panProofPath = panProofPath; }

    public String getPassportNo() { return passportNo; }
    public void setPassportNo(String passportNo) { this.passportNo = passportNo; }

    public String getDrivingLicenseNo() { return drivingLicenseNo; }
    public void setDrivingLicenseNo(String drivingLicenseNo) { this.drivingLicenseNo = drivingLicenseNo; }

    public String getVoterIdNo() { return voterIdNo; }
    public void setVoterIdNo(String voterIdNo) { this.voterIdNo = voterIdNo; }

    public String getPassportCopyPath() { return passportCopyPath; }
    public void setPassportCopyPath(String passportCopyPath) { this.passportCopyPath = passportCopyPath; }

    public String getDrivingLicenseCopyPath() { return drivingLicenseCopyPath; }
    public void setDrivingLicenseCopyPath(String drivingLicenseCopyPath) { this.drivingLicenseCopyPath = drivingLicenseCopyPath; }

    public String getVoterIdCopyPath() { return voterIdCopyPath; }
    public void setVoterIdCopyPath(String voterIdCopyPath) { this.voterIdCopyPath = voterIdCopyPath; }

    public String getSignaturePath() { return signaturePath; }
    public void setSignaturePath(String signaturePath) { this.signaturePath = signaturePath; }

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
