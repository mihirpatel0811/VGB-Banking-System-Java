-- ==========================================
-- Database Information
-- ------------------------------------------
-- Database Tool Name : MySQL
-- Username : root
-- Password : 17193
-- Current System Date: 2026-05-23
-- ==========================================

-- ==========================================
-- 1. Database Creation & Initialization
-- ==========================================
CREATE DATABASE IF NOT EXISTS vgb_database;
USE vgb_database;

-- Drop dependent child tables first to avoid foreign key dependency conflicts on rebuild
DROP TABLE IF EXISTS repayment;
DROP TABLE IF EXISTS card;
DROP TABLE IF EXISTS cheque_leaf;
DROP TABLE IF EXISTS cheque_book;
DROP TABLE IF EXISTS cheque_book_request;
DROP TABLE IF EXISTS passbook_request;
DROP TABLE IF EXISTS loan;
DROP TABLE IF EXISTS transaction;
DROP TABLE IF EXISTS account_savings;
DROP TABLE IF EXISTS account_current;
DROP TABLE IF EXISTS beneficiary;
DROP TABLE IF EXISTS account_signatory;
DROP TABLE IF EXISTS account;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS admin;

-- ==========================================
-- 2. SYSTEM MANAGEMENT
-- ==========================================
CREATE TABLE admin (
                       admin_id INT AUTO_INCREMENT PRIMARY KEY,
                       username VARCHAR(50) NOT NULL UNIQUE,
                       password VARCHAR(255) NOT NULL, -- Plain text string allowed for development
                       pin VARCHAR(4) NOT NULL DEFAULT '1234', -- Added PIN support
                       email VARCHAR(100) NOT NULL UNIQUE,
                       is_active TINYINT(1) NOT NULL DEFAULT 1,
                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================
-- 3. CUSTOMER ENTITIES
-- ==========================================
CREATE TABLE customer (
                          customer_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                          first_name VARCHAR(50) NOT NULL,
                          middle_name VARCHAR(50) NULL,
                          last_name VARCHAR(50) NOT NULL,
                          father_name VARCHAR(100) NULL,
                          mother_name VARCHAR(100) NULL,
                          dob DATE NULL,
                          gender VARCHAR(20) NULL,
                          marital_status VARCHAR(20) NULL,
                          nationality VARCHAR(50) NULL DEFAULT 'Indian',
                          email VARCHAR(100) NOT NULL UNIQUE,
                          pan_card VARCHAR(10) NULL,
                          aadhaar_card VARCHAR(12) NULL,
                          phone_no VARCHAR(20) NOT NULL UNIQUE,
                          alt_phone_no VARCHAR(20) NULL,
                          address VARCHAR(255) NOT NULL,
                          district VARCHAR(50) NULL,
                          city VARCHAR(50) NOT NULL,
                          state VARCHAR(50) NOT NULL,
                          country VARCHAR(50) NULL DEFAULT 'India',
                          zip_code VARCHAR(20) NOT NULL,
                          perm_address VARCHAR(255) NULL,
                          perm_city VARCHAR(50) NULL,
                          perm_district VARCHAR(50) NULL,
                          perm_state VARCHAR(50) NULL,
                          perm_country VARCHAR(50) NULL DEFAULT 'India',
                          perm_zip VARCHAR(20) NULL,
                          emergency_contact_name VARCHAR(100) NULL,
                          emergency_contact_phone VARCHAR(20) NULL,
                          emergency_contact_relation VARCHAR(50) NULL,
                          passport_no VARCHAR(20) NULL,
                          driving_license_no VARCHAR(20) NULL,
                          voter_id_no VARCHAR(20) NULL,
                          aadhaar_proof_path VARCHAR(255) NULL,
                          pan_proof_path VARCHAR(255) NULL,
                          passport_copy_path VARCHAR(255) NULL,
                          driving_license_copy_path VARCHAR(255) NULL,
                          voter_id_copy_path VARCHAR(255) NULL,
                          -- Minor Guardian details
                          guardian_name VARCHAR(100) NULL,
                          guardian_relationship VARCHAR(50) NULL,
                          guardian_phone VARCHAR(20) NULL,
                          guardian_aadhaar VARCHAR(12) NULL,
                          guardian_pan VARCHAR(10) NULL,
                          guardian_signature_path VARCHAR(255) NULL,
                          birth_certificate_path VARCHAR(255) NULL,
                          -- Student details
                          school_college_name VARCHAR(150) NULL,
                          student_id VARCHAR(50) NULL,
                          course VARCHAR(100) NULL,
                          admission_number VARCHAR(50) NULL,
                          -- Salary details
                          company_name VARCHAR(150) NULL,
                          employer_name VARCHAR(100) NULL,
                          employee_id VARCHAR(50) NULL,
                          salary_frequency VARCHAR(50) NULL,
                          -- Senior RM details
                          relationship_manager VARCHAR(100) NULL,
                          username VARCHAR(50) NOT NULL UNIQUE,
                          pin CHAR(4) NOT NULL, -- Preserves leading zeros safely (e.g., '0432')
                          password VARCHAR(255) NOT NULL, -- Plain text string allowed for development
                          status ENUM('active', 'suspended', 'closed') NOT NULL DEFAULT 'active',
                          avatar_path VARCHAR(255) NULL DEFAULT '/assest/img/avatars/default.png',
                          occupation VARCHAR(100) NULL,
                          annual_income DECIMAL(15, 2) NULL,
                          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) AUTO_INCREMENT = 112501;

-- ==========================================
-- 4. CORE BANKING ACCOUNTS (PARENT LEDGER)
-- ==========================================
CREATE TABLE account (
                         account_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                         account_type ENUM('savings', 'current', 'salary', 'student', 'fd', 'rd') NOT NULL,
                         balance DECIMAL(15, 4) NOT NULL DEFAULT 0.0000,
                         ifsc_code VARCHAR(11) NOT NULL,
                         account_number VARCHAR(20) NOT NULL UNIQUE,
                         status ENUM('active', 'frozen', 'dormant', 'closed') NOT NULL DEFAULT 'active',
                         has_atm_card TINYINT(1) NOT NULL DEFAULT 0,
                         has_cheque_book TINYINT(1) NOT NULL DEFAULT 0,
                         has_passbook TINYINT(1) NOT NULL DEFAULT 1,
                         internet_banking_enabled TINYINT(1) NOT NULL DEFAULT 1,
                         mobile_banking_enabled TINYINT(1) NOT NULL DEFAULT 1,
                         sms_alerts_enabled TINYINT(1) NOT NULL DEFAULT 1,
                         username VARCHAR(50) NULL UNIQUE,
                         password VARCHAR(255) NULL,
                         pin CHAR(4) NULL,
                         -- FD / RD specific settings
                         fd_rd_tenure_months INT NULL,
                         fd_rd_interest_rate DECIMAL(5, 2) NULL,
                         fd_rd_maturity_amount DECIMAL(15, 4) NULL,
                         fd_rd_maturity_date DATE NULL,
                         fd_rd_payout_option VARCHAR(50) NULL,
                         fd_rd_auto_renewal TINYINT(1) NOT NULL DEFAULT 0,
                         fd_rd_auto_debit TINYINT(1) NOT NULL DEFAULT 0,
                         -- Core Banking generated identifiers
                         application_ref_no VARCHAR(50) NULL UNIQUE,
                         passbook_number VARCHAR(50) NULL UNIQUE,
                         atm_card_number VARCHAR(19) NULL UNIQUE,
                         is_pension_account TINYINT(1) NOT NULL DEFAULT 0,
                         refund_status ENUM('NOT_APPLICABLE', 'PENDING', 'COMPLETED', 'FAILED') NOT NULL DEFAULT 'NOT_APPLICABLE',
                         refund_amount DECIMAL(15, 4) NOT NULL DEFAULT 0.0000,
                         refund_target_account_id BIGINT NULL,
                         refund_completed_at TIMESTAMP NULL,
                         is_loan_servicing_account TINYINT(1) NOT NULL DEFAULT 0,
                         created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================
-- 4a. JOINT MEMBERSHIP MAPPING (Many-to-Many)
-- ==========================================
-- Links accounts to their owners. Allows single owners OR multiple joint members.
CREATE TABLE account_signatory (
                                   account_id BIGINT NOT NULL,
                                   customer_id BIGINT NOT NULL,
                                   ownership_type ENUM('primary', 'joint_holder') NOT NULL DEFAULT 'primary',
                                   PRIMARY KEY (account_id, customer_id),
                                   FOREIGN KEY (account_id) REFERENCES account(account_id) ON DELETE CASCADE,
                                   FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE RESTRICT
);

-- ==========================================
-- 4aa. SAVED CUSTOMER BENEFICIARIES
-- ==========================================
CREATE TABLE beneficiary (
                             beneficiary_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                             customer_id BIGINT NOT NULL,
                             account_id BIGINT NULL,
                             beneficiary_type VARCHAR(10) NOT NULL DEFAULT 'vgb',
                             account_number VARCHAR(50) NULL,
                             ifsc_code VARCHAR(20) NULL,
                             holder_name VARCHAR(100) NULL,
                             nickname VARCHAR(100) NULL,
                             created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                             FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE,
                             FOREIGN KEY (account_id) REFERENCES account(account_id) ON DELETE CASCADE,
                             UNIQUE KEY unique_beneficiary (customer_id, account_id)
);

-- ==========================================
-- 4b. DYNAMIC SUB-TABLE: SAVINGS ACCOUNTS
-- ==========================================
CREATE TABLE account_savings (
                                 account_id BIGINT PRIMARY KEY,
                                 nominee_name VARCHAR(100) NOT NULL,
                                 holding_type ENUM('single', 'joint') NOT NULL DEFAULT 'single',
                                 daily_withdrawal_limit DECIMAL(12, 2) NOT NULL DEFAULT 50000.00,
                                 FOREIGN KEY (account_id) REFERENCES account(account_id) ON DELETE CASCADE
);

-- ==========================================
-- 4c. DYNAMIC SUB-TABLE: CURRENT ACCOUNTS
-- ==========================================
CREATE TABLE account_current (
                                 account_id BIGINT PRIMARY KEY,
                                 business_name VARCHAR(150) NOT NULL,
                                 gstin VARCHAR(15) NOT NULL UNIQUE,
                                 overdraft_limit DECIMAL(15, 4) NOT NULL DEFAULT 100000.0000,
                                 company_category VARCHAR(100) NULL,
                                 company_phone VARCHAR(20) NULL,
                                 company_email VARCHAR(100) NULL,
                                 company_address VARCHAR(255) NULL,
                                 company_pan VARCHAR(10) NULL,
                                 company_aadhaar VARCHAR(12) NULL,
                                 FOREIGN KEY (account_id) REFERENCES account(account_id) ON DELETE CASCADE
);

-- ==========================================
-- 5. LEDGER TRANSACTIONS
-- ==========================================
CREATE TABLE transaction (
                             transaction_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                             from_account_id BIGINT NULL,
                             to_account_id BIGINT NULL,
                             transaction_type ENUM('deposit', 'withdrawal', 'transfer', 'interest', 'fee') NOT NULL,
                             amount DECIMAL(15, 4) NOT NULL,
                             reference_number VARCHAR(50) NOT NULL UNIQUE,
                             description VARCHAR(255),
                             status ENUM('pending', 'completed', 'failed', 'reversed') NOT NULL DEFAULT 'completed',
                             transfer_mode VARCHAR(50) NULL,
                             sender_account_number VARCHAR(20) NULL,
                             receiver_account_number VARCHAR(20) NULL,
                             beneficiary_name VARCHAR(100) NULL,
                             beneficiary_ifsc VARCHAR(20) NULL,
                             beneficiary_bank VARCHAR(100) NULL,
                             beneficiary_branch VARCHAR(100) NULL,
                             performed_by_id BIGINT NULL,
                             transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                             FOREIGN KEY (from_account_id) REFERENCES account(account_id) ON DELETE RESTRICT,
                             FOREIGN KEY (to_account_id) REFERENCES account(account_id) ON DELETE RESTRICT
);

-- ==========================================
-- 6. CREDIT & LENDING SYSTEM
-- ==========================================
CREATE TABLE loan (
                      loan_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                      customer_id BIGINT NOT NULL, -- The main applicant responsible for the loan
                      loan_type ENUM('home', 'car', 'personal', 'education') NOT NULL,
                      principal_amount DECIMAL(15, 4) NOT NULL,
                      remaining_balance DECIMAL(15, 4) NOT NULL,
                      interest_rate DECIMAL(5, 2) NOT NULL,
                      term_months INT NOT NULL,
                      start_date DATE NOT NULL,
                      end_date DATE NOT NULL,
                      status ENUM('pending_approval', 'approved', 'disbursed', 'active', 'rejected', 'closed', 'defaulted') NOT NULL DEFAULT 'pending_approval',
                      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                      FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE RESTRICT
);

CREATE TABLE repayment (
                           repayment_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                           loan_id BIGINT NOT NULL,
                           customer_id BIGINT NOT NULL,
                           transaction_id BIGINT NOT NULL,
                           amount_paid DECIMAL(15, 4) NOT NULL,
                           principal_component DECIMAL(15, 4) NOT NULL,
                           interest_component DECIMAL(15, 4) NOT NULL,
                           repayment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                           FOREIGN KEY (loan_id) REFERENCES loan(loan_id) ON DELETE RESTRICT,
                           FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE RESTRICT,
                           FOREIGN KEY (transaction_id) REFERENCES transaction(transaction_id) ON DELETE RESTRICT
);

CREATE TABLE card (
                      card_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                      account_id BIGINT NOT NULL,
                      customer_id BIGINT NOT NULL,
                      card_number VARCHAR(19) NOT NULL UNIQUE,
                      card_type ENUM('debit', 'credit') NOT NULL,
                      card_provider ENUM('visa', 'mastercard', 'rupay') NOT NULL DEFAULT 'visa',
                      card_holder_name VARCHAR(100) NOT NULL,
                      cvv CHAR(3) NOT NULL,
                      expiry_date DATE NOT NULL,
                      status ENUM('pending', 'active', 'closed', 'expired') NOT NULL DEFAULT 'pending',
                      daily_limit DECIMAL(15, 4) NOT NULL DEFAULT 50000.0000,
                      atm_limit DECIMAL(15, 4) NOT NULL DEFAULT 25000.0000,
                      online_limit DECIMAL(15, 4) NOT NULL DEFAULT 50000.0000,
                      international_enabled TINYINT(1) NOT NULL DEFAULT 0,
                      card_fee DECIMAL(15, 4) NOT NULL DEFAULT 250.0000,
                      outstanding_balance DECIMAL(15, 4) NOT NULL DEFAULT 0.0000,
                      is_fee_paid TINYINT(1) NOT NULL DEFAULT 0,
                      card_tier VARCHAR(20) NOT NULL DEFAULT 'classic',
                      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                      FOREIGN KEY (account_id) REFERENCES account(account_id) ON DELETE CASCADE,
                      FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE
);

-- ==========================================
-- 7. CHEQUE BOOK SERVICES
-- ==========================================
CREATE TABLE cheque_book_request (
    request_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    account_id BIGINT NOT NULL,
    customer_id BIGINT NOT NULL,
    leaves_count INT NOT NULL DEFAULT 50,
    status ENUM('pending', 'approved', 'rejected', 'delivered') NOT NULL DEFAULT 'pending',
    charges DECIMAL(15, 4) NOT NULL DEFAULT 150.0000,
    is_charges_paid TINYINT(1) NOT NULL DEFAULT 0,
    requested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (account_id) REFERENCES account(account_id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE
);

-- ==========================================
-- 7a. CHEQUE BOOK BOOKLET TRACKING
-- ==========================================
CREATE TABLE cheque_book (
    chequebook_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    account_id BIGINT NOT NULL,
    chequebook_number VARCHAR(50) NOT NULL UNIQUE,
    start_cheque_no INT NOT NULL,
    end_cheque_no INT NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (account_id) REFERENCES account(account_id) ON DELETE CASCADE
);

CREATE TABLE cheque_leaf (
    cheque_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    chequebook_id BIGINT NOT NULL,
    cheque_number VARCHAR(20) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'unused',
    used_at TIMESTAMP NULL,
    FOREIGN KEY (chequebook_id) REFERENCES cheque_book(chequebook_id) ON DELETE CASCADE,
    UNIQUE KEY unique_cheque (chequebook_id, cheque_number)
);

-- ==========================================
-- 7b. PASSBOOK BOOKLET SERVICES
-- ==========================================
CREATE TABLE passbook_request (
    request_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    account_id BIGINT NOT NULL,
    customer_id BIGINT NOT NULL,
    request_type ENUM('new', 'renew') NOT NULL DEFAULT 'new',
    status ENUM('pending', 'approved', 'rejected', 'delivered') NOT NULL DEFAULT 'pending',
    charges DECIMAL(15, 4) NOT NULL DEFAULT 100.0000,
    is_charges_paid TINYINT(1) NOT NULL DEFAULT 0,
    requested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (account_id) REFERENCES account(account_id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE
);

-- ==========================================
-- SAMPLE DATA INJECTION WITH JOINT ACCOUNTS
-- ==========================================

-- Admin entry
INSERT INTO admin (username, password, pin, email)
VALUES ('vgb@admin$17193', 'admin@17193$', '1234', 'admin@vgb.com');
