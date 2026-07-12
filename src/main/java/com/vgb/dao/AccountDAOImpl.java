package com.vgb.dao;

import com.vgb.config.DatabaseConfig;
import com.vgb.model.Account;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * AccountDAOImpl: Implementation of AccountDAO interface
 */
public class AccountDAOImpl implements AccountDAO {
    private static final Logger logger = LoggerFactory.getLogger(AccountDAOImpl.class);
    private DatabaseConfig dbConfig = DatabaseConfig.getInstance();

    private static final String ACCOUNT_SELECT_FIELDS = 
        "SELECT a.*, " +
        "COALESCE(GROUP_CONCAT(CONCAT(c.first_name, ' ', c.last_name) ORDER BY s.ownership_type DESC SEPARATOR ' & '), 'No Owner') as customer_name, " +
        "COALESCE(MIN(CASE WHEN s.ownership_type = 'primary' THEN s.customer_id END), 0) as customer_id, " +
        "MIN(CASE WHEN s.ownership_type = 'primary' THEN c.dob END) as customer_dob, " +
        
        // Primary Customer fields
        "MAX(CASE WHEN s.ownership_type = 'primary' THEN c.first_name END) as primary_first_name, " +
        "MAX(CASE WHEN s.ownership_type = 'primary' THEN c.middle_name END) as primary_middle_name, " +
        "MAX(CASE WHEN s.ownership_type = 'primary' THEN c.last_name END) as primary_last_name, " +
        "MAX(CASE WHEN s.ownership_type = 'primary' THEN c.father_name END) as primary_father_name, " +
        "MAX(CASE WHEN s.ownership_type = 'primary' THEN c.mother_name END) as primary_mother_name, " +
        "MAX(CASE WHEN s.ownership_type = 'primary' THEN c.nationality END) as primary_nationality, " +
        "MAX(CASE WHEN s.ownership_type = 'primary' THEN c.email END) as primary_email, " +
        "MAX(CASE WHEN s.ownership_type = 'primary' THEN c.phone_no END) as primary_phone, " +
        "MAX(CASE WHEN s.ownership_type = 'primary' THEN c.alt_phone_no END) as primary_alt_phone, " +
        "MAX(CASE WHEN s.ownership_type = 'primary' THEN c.address END) as primary_address, " +
        "MAX(CASE WHEN s.ownership_type = 'primary' THEN c.perm_address END) as primary_perm_address, " +
        "MAX(CASE WHEN s.ownership_type = 'primary' THEN c.city END) as primary_city, " +
        "MAX(CASE WHEN s.ownership_type = 'primary' THEN c.state END) as primary_state, " +
        "MAX(CASE WHEN s.ownership_type = 'primary' THEN c.zip_code END) as primary_zip, " +
        "MAX(CASE WHEN s.ownership_type = 'primary' THEN c.pan_card END) as primary_pan, " +
        "MAX(CASE WHEN s.ownership_type = 'primary' THEN c.aadhaar_card END) as primary_aadhaar, " +
        "MAX(CASE WHEN s.ownership_type = 'primary' THEN c.gender END) as primary_gender, " +
        "MAX(CASE WHEN s.ownership_type = 'primary' THEN c.marital_status END) as primary_marital_status, " +
        "MAX(CASE WHEN s.ownership_type = 'primary' THEN c.occupation END) as primary_occupation, " +
        "MAX(CASE WHEN s.ownership_type = 'primary' THEN c.annual_income END) as primary_income, " +
        "MAX(CASE WHEN s.ownership_type = 'primary' THEN c.guardian_name END) as primary_guardian_name, " +
        "MAX(CASE WHEN s.ownership_type = 'primary' THEN c.guardian_relationship END) as primary_guardian_relationship, " +
        "MAX(CASE WHEN s.ownership_type = 'primary' THEN c.guardian_phone END) as primary_guardian_phone, " +
        "MAX(CASE WHEN s.ownership_type = 'primary' THEN c.guardian_aadhaar END) as primary_guardian_aadhaar, " +
        "MAX(CASE WHEN s.ownership_type = 'primary' THEN c.guardian_pan END) as primary_guardian_pan, " +
        "MAX(CASE WHEN s.ownership_type = 'primary' THEN c.guardian_signature_path END) as primary_guardian_signature_path, " +
        "MAX(CASE WHEN s.ownership_type = 'primary' THEN c.birth_certificate_path END) as primary_birth_certificate_path, " +
        "MAX(CASE WHEN s.ownership_type = 'primary' THEN c.school_college_name END) as primary_school_college_name, " +
        "MAX(CASE WHEN s.ownership_type = 'primary' THEN c.student_id END) as primary_student_id, " +
        "MAX(CASE WHEN s.ownership_type = 'primary' THEN c.course END) as primary_course, " +
        "MAX(CASE WHEN s.ownership_type = 'primary' THEN c.admission_number END) as primary_admission_number, " +
        "MAX(CASE WHEN s.ownership_type = 'primary' THEN c.company_name END) as primary_company_name, " +
        "MAX(CASE WHEN s.ownership_type = 'primary' THEN c.employer_name END) as primary_employer_name, " +
        "MAX(CASE WHEN s.ownership_type = 'primary' THEN c.employee_id END) as primary_employee_id, " +
        "MAX(CASE WHEN s.ownership_type = 'primary' THEN c.salary_frequency END) as primary_salary_frequency, " +
        "MAX(CASE WHEN s.ownership_type = 'primary' THEN c.relationship_manager END) as primary_relationship_manager, " +
        
        
        // Joint Customer fields
        "COALESCE(MIN(CASE WHEN s.ownership_type = 'joint_holder' THEN s.customer_id END), 0) as joint_customer_id, " +
        "MAX(CASE WHEN s.ownership_type = 'joint_holder' THEN c.first_name END) as joint_first_name, " +
        "MAX(CASE WHEN s.ownership_type = 'joint_holder' THEN c.middle_name END) as joint_middle_name, " +
        "MAX(CASE WHEN s.ownership_type = 'joint_holder' THEN c.last_name END) as joint_last_name, " +
        "MAX(CASE WHEN s.ownership_type = 'joint_holder' THEN c.father_name END) as joint_father_name, " +
        "MAX(CASE WHEN s.ownership_type = 'joint_holder' THEN c.mother_name END) as joint_mother_name, " +
        "MAX(CASE WHEN s.ownership_type = 'joint_holder' THEN c.nationality END) as joint_nationality, " +
        "MAX(CASE WHEN s.ownership_type = 'joint_holder' THEN c.email END) as joint_email, " +
        "MAX(CASE WHEN s.ownership_type = 'joint_holder' THEN c.phone_no END) as joint_phone, " +
        "MAX(CASE WHEN s.ownership_type = 'joint_holder' THEN c.alt_phone_no END) as joint_alt_phone, " +
        "MIN(CASE WHEN s.ownership_type = 'joint_holder' THEN c.dob END) as joint_dob, " +
        "MAX(CASE WHEN s.ownership_type = 'joint_holder' THEN c.gender END) as joint_gender, " +
        "MAX(CASE WHEN s.ownership_type = 'joint_holder' THEN c.marital_status END) as joint_marital_status, " +
        "MAX(CASE WHEN s.ownership_type = 'joint_holder' THEN c.pan_card END) as joint_pan, " +
        "MAX(CASE WHEN s.ownership_type = 'joint_holder' THEN c.aadhaar_card END) as joint_aadhaar, " +
        "MAX(CASE WHEN s.ownership_type = 'joint_holder' THEN c.address END) as joint_address, " +
        "MAX(CASE WHEN s.ownership_type = 'joint_holder' THEN c.perm_address END) as joint_perm_address, " +
        "MAX(CASE WHEN s.ownership_type = 'joint_holder' THEN c.city END) as joint_city, " +
        "MAX(CASE WHEN s.ownership_type = 'joint_holder' THEN c.state END) as joint_state, " +
        "MAX(CASE WHEN s.ownership_type = 'joint_holder' THEN c.zip_code END) as joint_zip, " +
        "MAX(CASE WHEN s.ownership_type = 'joint_holder' THEN c.occupation END) as joint_occupation, " +
        "MAX(CASE WHEN s.ownership_type = 'joint_holder' THEN c.annual_income END) as joint_income, " +
        
        "MAX(sav.nominee_name) as nominee_name, MAX(sav.holding_type) as holding_type, MAX(sav.daily_withdrawal_limit) as daily_withdrawal_limit, " +
        "MAX(curr.business_name) as business_name, MAX(curr.gstin) as gstin, MAX(curr.overdraft_limit) as overdraft_limit, MAX(curr.company_category) as company_category, MAX(curr.company_phone) as company_phone, MAX(curr.company_email) as company_email, MAX(curr.company_address) as company_address, MAX(curr.company_pan) as company_pan, MAX(curr.company_aadhaar) as company_aadhaar ";

    private static final String GET_ACCOUNT_BY_ID = 
        ACCOUNT_SELECT_FIELDS + 
        "FROM account a " +
        "LEFT JOIN account_signatory s ON a.account_id = s.account_id " +
        "LEFT JOIN customer c ON s.customer_id = c.customer_id " +
        "LEFT JOIN account_savings sav ON a.account_id = sav.account_id " +
        "LEFT JOIN account_current curr ON a.account_id = curr.account_id " +
        "WHERE a.account_id = ? " +
        "GROUP BY a.account_id";
    private static final String GET_ACCOUNT_BY_NUMBER = 
        ACCOUNT_SELECT_FIELDS + 
        "FROM account a " +
        "LEFT JOIN account_signatory s ON a.account_id = s.account_id " +
        "LEFT JOIN customer c ON s.customer_id = c.customer_id " +
        "LEFT JOIN account_savings sav ON a.account_id = sav.account_id " +
        "LEFT JOIN account_current curr ON a.account_id = curr.account_id " +
        "WHERE a.account_number = ? " +
        "GROUP BY a.account_id";
    private static final String GET_ACCOUNTS_BY_CUSTOMER = 
        ACCOUNT_SELECT_FIELDS + 
        "FROM account a " +
        "LEFT JOIN account_signatory s ON a.account_id = s.account_id " +
        "LEFT JOIN customer c ON s.customer_id = c.customer_id " +
        "LEFT JOIN account_savings sav ON a.account_id = sav.account_id " +
        "LEFT JOIN account_current curr ON a.account_id = curr.account_id " +
        "WHERE a.account_id IN (SELECT account_id FROM account_signatory WHERE customer_id = ?) " +
        "GROUP BY a.account_id " +
        "ORDER BY a.created_at DESC";
    private static final String GET_ALL_ACCOUNTS = 
        ACCOUNT_SELECT_FIELDS + 
        "FROM account a " +
        "LEFT JOIN account_signatory s ON a.account_id = s.account_id " +
        "LEFT JOIN customer c ON s.customer_id = c.customer_id " +
        "LEFT JOIN account_savings sav ON a.account_id = sav.account_id " +
        "LEFT JOIN account_current curr ON a.account_id = curr.account_id " +
        "GROUP BY a.account_id " +
        "ORDER BY a.created_at DESC";
    private static final String UPDATE_ACCOUNT = 
        "UPDATE account SET account_type = ?, ifsc_code = ?, status = ?, has_atm_card = ?, has_cheque_book = ?, has_passbook = ?, username = ?, password = ?, pin = ?, " +
        "fd_rd_tenure_months = ?, fd_rd_interest_rate = ?, fd_rd_maturity_amount = ?, fd_rd_maturity_date = ?, fd_rd_payout_option = ?, fd_rd_auto_renewal = ?, fd_rd_auto_debit = ?, is_pension_account = ? " +
        "WHERE account_id = ?";
    private static final String UPDATE_ACCOUNT_BALANCE = 
        "UPDATE account SET balance = ? WHERE account_id = ?";
    private static final String UPDATE_ACCOUNT_STATUS = 
        "UPDATE account SET status = ? WHERE account_id = ?";
    private static final String DELETE_ACCOUNT = 
        "DELETE FROM account WHERE account_id = ?";
    private static final String CHECK_ACCOUNT_NUMBER_EXISTS = 
        "SELECT COUNT(*) FROM account WHERE account_number = ?";
    private static final String GET_ACCOUNT_COUNT = 
        "SELECT COUNT(*) FROM account_signatory WHERE customer_id = ?";

    @Override
    public boolean create(Account account) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        PreparedStatement stmtSign = null;

        try {
            conn = dbConfig.getConnection();
            conn.setAutoCommit(false); // Start Transaction

            // 1. Insert core account
            String createAccountSql = "INSERT INTO account (account_type, balance, ifsc_code, account_number, status, has_atm_card, has_cheque_book, has_passbook, username, password, pin) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(createAccountSql, Statement.RETURN_GENERATED_KEYS);
            stmt.setString(1, account.getAccountType());
            stmt.setBigDecimal(2, account.getBalance());
            stmt.setString(3, account.getIfscCode());
            stmt.setString(4, account.getAccountNumber());
            stmt.setString(5, account.getStatus());
            stmt.setInt(6, account.isHasAtmCard() ? 1 : 0);
            stmt.setInt(7, account.isHasChequeBook() ? 1 : 0);
            stmt.setInt(8, account.isHasPassbook() ? 1 : 0);
            stmt.setString(9, account.getUsername());
            stmt.setString(10, account.getPassword());
            stmt.setString(11, account.getPin());

            int result = stmt.executeUpdate();
            if (result == 0) {
                throw new SQLException("Creating account failed, no rows affected.");
            }

            long accountId = 0;
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    accountId = generatedKeys.getLong(1);
                    account.setAccountId(accountId);
                } else {
                    throw new SQLException("Creating account failed, no ID obtained.");
                }
            }

            // 2. Insert primary signatory mapping
            String createSignatorySql = "INSERT INTO account_signatory (account_id, customer_id, ownership_type) VALUES (?, ?, 'primary')";
            stmtSign = conn.prepareStatement(createSignatorySql);
            stmtSign.setLong(1, accountId);
            stmtSign.setLong(2, account.getCustomerId());
            stmtSign.executeUpdate();
            stmtSign.close();

            // Insert joint holder if present via jointCustomerId
            if (account.getJointCustomerId() != null && account.getJointCustomerId() > 0) {
                String createJointSignatorySql = "INSERT INTO account_signatory (account_id, customer_id, ownership_type) VALUES (?, ?, 'joint_holder')";
                try (PreparedStatement stmtJoint = conn.prepareStatement(createJointSignatorySql)) {
                    stmtJoint.setLong(1, accountId);
                    stmtJoint.setLong(2, account.getJointCustomerId());
                    stmtJoint.executeUpdate();
                }
            }

            // Insert other joint holders / partners if present via list
            if (account.getJointCustomerIds() != null && !account.getJointCustomerIds().isEmpty()) {
                String createJointSignatorySql = "INSERT INTO account_signatory (account_id, customer_id, ownership_type) VALUES (?, ?, 'joint_holder')";
                try (PreparedStatement stmtJointList = conn.prepareStatement(createJointSignatorySql)) {
                    for (Long jointCustId : account.getJointCustomerIds()) {
                        if (jointCustId != null && jointCustId > 0 && !jointCustId.equals(account.getJointCustomerId()) && !jointCustId.equals(account.getCustomerId())) {
                            stmtJointList.setLong(1, accountId);
                            stmtJointList.setLong(2, jointCustId);
                            stmtJointList.executeUpdate();
                        }
                    }
                }
            }

            // 3. Insert subclass specific detail tables
            if (!"current".equalsIgnoreCase(account.getAccountType())) {
                String createSavingsSql = "INSERT INTO account_savings (account_id, nominee_name, holding_type, daily_withdrawal_limit) VALUES (?, ?, ?, ?)";
                try (PreparedStatement stmtSav = conn.prepareStatement(createSavingsSql)) {
                    stmtSav.setLong(1, accountId);
                    stmtSav.setString(2, account.getNomineeName() != null ? account.getNomineeName() : "No Nominee");
                    stmtSav.setString(3, account.getHoldingType() != null ? account.getHoldingType() : "single");
                    stmtSav.setBigDecimal(4, account.getDailyWithdrawalLimit() != null ? account.getDailyWithdrawalLimit() : new BigDecimal("50000.00"));
                    stmtSav.executeUpdate();
                }
            } else if ("current".equalsIgnoreCase(account.getAccountType())) {
                String createCurrentSql = "INSERT INTO account_current (account_id, business_name, gstin, overdraft_limit, company_category, company_phone, company_email, company_address, company_pan, company_aadhaar) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                try (PreparedStatement stmtCurr = conn.prepareStatement(createCurrentSql)) {
                    stmtCurr.setLong(1, accountId);
                    stmtCurr.setString(2, account.getBusinessName() != null ? account.getBusinessName() : "Unnamed Business");
                    stmtCurr.setString(3, account.getGstin() != null ? account.getGstin() : "GST" + java.util.UUID.randomUUID().toString().substring(0, 12).toUpperCase());
                    stmtCurr.setBigDecimal(4, account.getOverdraftLimit() != null ? account.getOverdraftLimit() : new BigDecimal("100000.00"));
                    stmtCurr.setString(5, account.getCompanyCategory());
                    stmtCurr.setString(6, account.getCompanyPhone());
                    stmtCurr.setString(7, account.getCompanyEmail());
                    stmtCurr.setString(8, account.getCompanyAddress());
                    stmtCurr.setString(9, account.getCompanyPan());
                    stmtCurr.setString(10, account.getCompanyAadhaar());
                    stmtCurr.executeUpdate();
                }
            }

            conn.commit(); // Commit Transaction
            logger.info("Account created successfully: {}", account.getAccountNumber());
            return true;

        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) {}
            }
            logger.error("Error creating account", e);
            throw new Exception("Failed to create account", e);
        } finally {
            DatabaseConfig.closeResources(null, stmt, conn);
            try { if (stmtSign != null) stmtSign.close(); } catch (Exception e) {}
        }
    }

    @Override
    public Account getById(long accountId) throws Exception {
        Connection conn = null;
        try {
            conn = dbConfig.getConnection();
            return getById(conn, accountId);
        } catch (SQLException e) {
            logger.error("Error fetching account by ID: {}", accountId, e);
            throw new Exception("Failed to fetch account", e);
        } finally {
            DatabaseConfig.closeConnection(conn);
        }
    }

    public Account getById(Connection conn, long accountId) throws SQLException {
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            stmt = conn.prepareStatement(GET_ACCOUNT_BY_ID);
            stmt.setLong(1, accountId);
            rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToAccount(rs);
            }
            return null;
        } finally {
            DatabaseConfig.closeResources(rs, stmt, null);
        }
    }

    @Override
    public Account getByAccountNumber(String accountNumber) throws Exception {
        Connection conn = null;
        try {
            conn = dbConfig.getConnection();
            return getByAccountNumber(conn, accountNumber);
        } catch (SQLException e) {
            logger.error("Error fetching account by number: {}", accountNumber, e);
            throw new Exception("Failed to fetch account", e);
        } finally {
            DatabaseConfig.closeConnection(conn);
        }
    }

    public Account getByAccountNumber(Connection conn, String accountNumber) throws SQLException {
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            stmt = conn.prepareStatement(GET_ACCOUNT_BY_NUMBER);
            stmt.setString(1, accountNumber);
            rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToAccount(rs);
            }
            return null;
        } finally {
            DatabaseConfig.closeResources(rs, stmt, null);
        }
    }

    @Override
    public List<Account> getByCustomerId(long customerId) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Account> accounts = new ArrayList<>();

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(GET_ACCOUNTS_BY_CUSTOMER);
            stmt.setLong(1, customerId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                accounts.add(mapResultSetToAccount(rs));
            }
            logger.info("Fetched {} accounts for customer: {}", accounts.size(), customerId);
            return accounts;

        } catch (SQLException e) {
            logger.error("Error fetching accounts by customer", e);
            throw new Exception("Failed to fetch accounts", e);
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    @Override
    public List<Account> getAll() throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Account> accounts = new ArrayList<>();

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(GET_ALL_ACCOUNTS);
            rs = stmt.executeQuery();

            while (rs.next()) {
                accounts.add(mapResultSetToAccount(rs));
            }
            logger.info("Fetched {} active accounts", accounts.size());
            return accounts;

        } catch (SQLException e) {
            logger.error("Error fetching all accounts", e);
            throw new Exception("Failed to fetch accounts", e);
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    @Override
    public boolean update(Account account) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = dbConfig.getConnection();
            conn.setAutoCommit(false); // Start Transaction

            stmt = conn.prepareStatement(UPDATE_ACCOUNT);
            stmt.setString(1, account.getAccountType());
            stmt.setString(2, account.getIfscCode());
            stmt.setString(3, account.getStatus());
            stmt.setInt(4, account.isHasAtmCard() ? 1 : 0);
            stmt.setInt(5, account.isHasChequeBook() ? 1 : 0);
            stmt.setInt(6, account.isHasPassbook() ? 1 : 0);
            stmt.setString(7, account.getUsername());
            stmt.setString(8, account.getPassword());
            stmt.setString(9, account.getPin());
            
            if (account.getFdRdTenureMonths() != null) {
                stmt.setInt(10, account.getFdRdTenureMonths());
            } else {
                stmt.setNull(10, java.sql.Types.INTEGER);
            }
            stmt.setBigDecimal(11, account.getFdRdInterestRate());
            stmt.setBigDecimal(12, account.getFdRdMaturityAmount());
            stmt.setDate(13, account.getFdRdMaturityDate() != null ? java.sql.Date.valueOf(account.getFdRdMaturityDate()) : null);
            stmt.setString(14, account.getFdRdPayoutOption());
            stmt.setInt(15, account.isFdRdAutoRenewal() ? 1 : 0);
            stmt.setInt(16, account.isFdRdAutoDebit() ? 1 : 0);
            stmt.setInt(17, account.isPensionAccount() ? 1 : 0);
            
            stmt.setLong(18, account.getAccountId());

            int result = stmt.executeUpdate();

            // Update primary customer details if provided
            if (account.getPrimaryFirstName() != null) {
                String updatePrimarySql = "UPDATE customer SET first_name = ?, middle_name = ?, last_name = ?, dob = ?, gender = ?, marital_status = ?, email = ?, phone_no = ?, pan_card = ?, aadhaar_card = ?, address = ?, perm_address = ?, city = ?, state = ?, zip_code = ?, occupation = ?, annual_income = ?, father_name = ?, mother_name = ?, nationality = ?, alt_phone_no = ?, " +
                                          "guardian_name = ?, guardian_relationship = ?, guardian_phone = ?, guardian_aadhaar = ?, guardian_pan = ?, " +
                                          "school_college_name = ?, student_id = ?, course = ?, admission_number = ?, " +
                                          "company_name = ?, employer_name = ?, employee_id = ?, salary_frequency = ?, relationship_manager = ? " +
                                          "WHERE customer_id = ?";
                try (PreparedStatement stmtPrim = conn.prepareStatement(updatePrimarySql)) {
                    stmtPrim.setString(1, account.getPrimaryFirstName());
                    stmtPrim.setString(2, account.getPrimaryMiddleName());
                    stmtPrim.setString(3, account.getPrimaryLastName());
                    stmtPrim.setDate(4, account.getCustomerDob() != null ? java.sql.Date.valueOf(account.getCustomerDob()) : null);
                    stmtPrim.setString(5, account.getPrimaryGender());
                    stmtPrim.setString(6, account.getPrimaryMaritalStatus());
                    stmtPrim.setString(7, account.getPrimaryEmail());
                    stmtPrim.setString(8, account.getPrimaryPhone());
                    stmtPrim.setString(9, account.getPrimaryPan());
                    stmtPrim.setString(10, account.getPrimaryAadhaar());
                    stmtPrim.setString(11, account.getPrimaryAddress());
                    stmtPrim.setString(12, account.getPrimaryPermAddress());
                    stmtPrim.setString(13, account.getPrimaryCity());
                    stmtPrim.setString(14, account.getPrimaryState());
                    stmtPrim.setString(15, account.getPrimaryZip());
                    stmtPrim.setString(16, account.getPrimaryOccupation());
                    stmtPrim.setBigDecimal(17, account.getPrimaryIncome());
                    stmtPrim.setString(18, account.getPrimaryFatherName());
                    stmtPrim.setString(19, account.getPrimaryMotherName());
                    stmtPrim.setString(20, account.getPrimaryNationality());
                    stmtPrim.setString(21, account.getPrimaryAltPhone());
                    
                    stmtPrim.setString(22, account.getPrimaryGuardianName());
                    stmtPrim.setString(23, account.getPrimaryGuardianRelationship());
                    stmtPrim.setString(24, account.getPrimaryGuardianPhone());
                    stmtPrim.setString(25, account.getPrimaryGuardianAadhaar());
                    stmtPrim.setString(26, account.getPrimaryGuardianPan());
                    stmtPrim.setString(27, account.getPrimarySchoolCollegeName());
                    stmtPrim.setString(28, account.getPrimaryStudentId());
                    stmtPrim.setString(29, account.getPrimaryCourse());
                    stmtPrim.setString(30, account.getPrimaryAdmissionNumber());
                    stmtPrim.setString(31, account.getPrimaryCompanyName());
                    stmtPrim.setString(32, account.getPrimaryEmployerName());
                    stmtPrim.setString(33, account.getPrimaryEmployeeId());
                    stmtPrim.setString(34, account.getPrimarySalaryFrequency());
                    stmtPrim.setString(35, account.getPrimaryRelationshipManager());
                    
                    stmtPrim.setLong(36, account.getCustomerId());
                    stmtPrim.executeUpdate();
                }
            }

            // Update sub-table depending on account type
            if (!"current".equalsIgnoreCase(account.getAccountType())) {
                String updateSavingsSql = "INSERT INTO account_savings (account_id, nominee_name, holding_type, daily_withdrawal_limit) VALUES (?, ?, ?, ?) " +
                                          "ON DUPLICATE KEY UPDATE nominee_name = ?, holding_type = ?, daily_withdrawal_limit = ?";
                try (PreparedStatement stmtSav = conn.prepareStatement(updateSavingsSql)) {
                    stmtSav.setLong(1, account.getAccountId());
                    stmtSav.setString(2, account.getNomineeName() != null ? account.getNomineeName() : "No Nominee");
                    stmtSav.setString(3, account.getHoldingType() != null ? account.getHoldingType() : "single");
                    stmtSav.setBigDecimal(4, account.getDailyWithdrawalLimit() != null ? account.getDailyWithdrawalLimit() : new BigDecimal("50000.00"));
                    
                    stmtSav.setString(5, account.getNomineeName() != null ? account.getNomineeName() : "No Nominee");
                    stmtSav.setString(6, account.getHoldingType() != null ? account.getHoldingType() : "single");
                    stmtSav.setBigDecimal(7, account.getDailyWithdrawalLimit() != null ? account.getDailyWithdrawalLimit() : new BigDecimal("50000.00"));
                    stmtSav.executeUpdate();
                }

                // Handle Joint Customer Updates
                if ("joint".equalsIgnoreCase(account.getHoldingType())) {
                    if (account.getJointCustomerId() != null && account.getJointCustomerId() > 0) {
                        // Update existing joint customer
                        String updateJointSql = "UPDATE customer SET first_name = ?, middle_name = ?, last_name = ?, dob = ?, gender = ?, marital_status = ?, email = ?, phone_no = ?, pan_card = ?, aadhaar_card = ?, address = ?, perm_address = ?, city = ?, state = ?, zip_code = ?, occupation = ?, annual_income = ?, father_name = ?, mother_name = ?, nationality = ?, alt_phone_no = ? WHERE customer_id = ?";
                        try (PreparedStatement stmtJnt = conn.prepareStatement(updateJointSql)) {
                            stmtJnt.setString(1, account.getJointFirstName());
                            stmtJnt.setString(2, account.getJointMiddleName());
                            stmtJnt.setString(3, account.getJointLastName());
                            stmtJnt.setDate(4, account.getJointDob() != null ? java.sql.Date.valueOf(account.getJointDob()) : null);
                            stmtJnt.setString(5, account.getJointGender());
                            stmtJnt.setString(6, account.getJointMaritalStatus());
                            stmtJnt.setString(7, account.getJointEmail());
                            stmtJnt.setString(8, account.getJointPhone());
                            stmtJnt.setString(9, account.getJointPan());
                            stmtJnt.setString(10, account.getJointAadhaar());
                            stmtJnt.setString(11, account.getJointAddress());
                            stmtJnt.setString(12, account.getJointPermAddress());
                            stmtJnt.setString(13, account.getJointCity());
                            stmtJnt.setString(14, account.getJointState());
                            stmtJnt.setString(15, account.getJointZip());
                            stmtJnt.setString(16, account.getJointOccupation());
                            stmtJnt.setBigDecimal(17, account.getJointIncome());
                            stmtJnt.setString(18, account.getJointFatherName());
                            stmtJnt.setString(19, account.getJointMotherName());
                            stmtJnt.setString(20, account.getJointNationality());
                            stmtJnt.setString(21, account.getJointAltPhone());
                            stmtJnt.setLong(22, account.getJointCustomerId());
                            stmtJnt.executeUpdate();
                        }
                    } else {
                        // Create new joint customer profile
                        String insertJointSql = "INSERT INTO customer (first_name, middle_name, last_name, father_name, mother_name, dob, gender, marital_status, nationality, email, pan_card, aadhaar_card, phone_no, alt_phone_no, address, perm_address, city, state, zip_code, username, pin, password, status, occupation, annual_income) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                        long newJointId = 0;
                        try (PreparedStatement stmtIns = conn.prepareStatement(insertJointSql, Statement.RETURN_GENERATED_KEYS)) {
                            stmtIns.setString(1, account.getJointFirstName());
                            stmtIns.setString(2, account.getJointMiddleName());
                            stmtIns.setString(3, account.getJointLastName());
                            stmtIns.setString(4, account.getJointFatherName());
                            stmtIns.setString(5, account.getJointMotherName());
                            stmtIns.setDate(6, account.getJointDob() != null ? java.sql.Date.valueOf(account.getJointDob()) : null);
                            stmtIns.setString(7, account.getJointGender());
                            stmtIns.setString(8, account.getJointMaritalStatus());
                            stmtIns.setString(9, account.getJointNationality());
                            stmtIns.setString(10, account.getJointEmail());
                            stmtIns.setString(11, account.getJointPan());
                            stmtIns.setString(12, account.getJointAadhaar());
                            stmtIns.setString(13, account.getJointPhone());
                            stmtIns.setString(14, account.getJointAltPhone());
                            stmtIns.setString(15, account.getJointAddress());
                            stmtIns.setString(16, account.getJointPermAddress());
                            stmtIns.setString(17, account.getJointCity());
                            stmtIns.setString(18, account.getJointState());
                            stmtIns.setString(19, account.getJointZip());
                            
                            // Generate default credentials
                            String randUser = "j_" + account.getAccountNumber() + "_" + (10 + new java.util.Random().nextInt(90));
                            stmtIns.setString(20, randUser);
                            stmtIns.setString(21, "1234");
                            stmtIns.setString(22, "Vgb@1234");
                            stmtIns.setString(23, "active");
                            stmtIns.setString(24, account.getJointOccupation());
                            stmtIns.setBigDecimal(25, account.getJointIncome() != null ? account.getJointIncome() : new BigDecimal("300000.00"));
                            
                            stmtIns.executeUpdate();
                            try (ResultSet gk = stmtIns.getGeneratedKeys()) {
                                if (gk.next()) {
                                    newJointId = gk.getLong(1);
                                }
                            }
                        }
                        if (newJointId > 0) {
                            String linkSignatorySql = "INSERT INTO account_signatory (account_id, customer_id, ownership_type) VALUES (?, ?, 'joint_holder')";
                            try (PreparedStatement stmtLink = conn.prepareStatement(linkSignatorySql)) {
                                stmtLink.setLong(1, account.getAccountId());
                                stmtLink.setLong(2, newJointId);
                                stmtLink.executeUpdate();
                            }
                            account.setJointCustomerId(newJointId);
                        }
                    }
                } else {
                    // Changed from joint to single: delete joint holder signatory mapping
                    String deleteJointSigSql = "DELETE FROM account_signatory WHERE account_id = ? AND ownership_type = 'joint_holder'";
                    try (PreparedStatement stmtDelSig = conn.prepareStatement(deleteJointSigSql)) {
                        stmtDelSig.setLong(1, account.getAccountId());
                        stmtDelSig.executeUpdate();
                    }
                }
            } else if ("current".equalsIgnoreCase(account.getAccountType())) {
                String updateCurrentSql = "INSERT INTO account_current (account_id, business_name, gstin, overdraft_limit, company_category, company_phone, company_email, company_address, company_pan, company_aadhaar) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?) " +
                                           "ON DUPLICATE KEY UPDATE business_name = ?, gstin = ?, overdraft_limit = ?, company_category = ?, company_phone = ?, company_email = ?, company_address = ?, company_pan = ?, company_aadhaar = ?";
                try (PreparedStatement stmtCurr = conn.prepareStatement(updateCurrentSql)) {
                    stmtCurr.setLong(1, account.getAccountId());
                    stmtCurr.setString(2, account.getBusinessName());
                    stmtCurr.setString(3, account.getGstin());
                    stmtCurr.setBigDecimal(4, account.getOverdraftLimit());
                    stmtCurr.setString(5, account.getCompanyCategory());
                    stmtCurr.setString(6, account.getCompanyPhone());
                    stmtCurr.setString(7, account.getCompanyEmail());
                    stmtCurr.setString(8, account.getCompanyAddress());
                    stmtCurr.setString(9, account.getCompanyPan());
                    stmtCurr.setString(10, account.getCompanyAadhaar());
                    
                    stmtCurr.setString(11, account.getBusinessName());
                    stmtCurr.setString(12, account.getGstin());
                    stmtCurr.setBigDecimal(13, account.getOverdraftLimit());
                    stmtCurr.setString(14, account.getCompanyCategory());
                    stmtCurr.setString(15, account.getCompanyPhone());
                    stmtCurr.setString(16, account.getCompanyEmail());
                    stmtCurr.setString(17, account.getCompanyAddress());
                    stmtCurr.setString(18, account.getCompanyPan());
                    stmtCurr.setString(19, account.getCompanyAadhaar());
                    stmtCurr.executeUpdate();
                }
            }

            conn.commit(); // Commit Transaction
            logger.info("Account updated: {}", account.getAccountId());
            return result > 0;

        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) {}
            }
            logger.error("Error updating account", e);
            throw new Exception("Failed to update account", e);
        } finally {
            DatabaseConfig.closeResources(null, stmt, conn);
        }
    }

    @Override
    public boolean updateBalance(long accountId, BigDecimal balance) throws Exception {
        Connection conn = null;
        try {
            conn = dbConfig.getConnection();
            return updateBalance(conn, accountId, balance);
        } catch (SQLException e) {
            logger.error("Error updating account balance", e);
            throw new Exception("Failed to update balance", e);
        } finally {
            DatabaseConfig.closeConnection(conn);
        }
    }

    public boolean updateBalance(Connection conn, long accountId, BigDecimal balance) throws SQLException {
        PreparedStatement stmt = null;
        try {
            stmt = conn.prepareStatement(UPDATE_ACCOUNT_BALANCE);
            stmt.setBigDecimal(1, balance);
            stmt.setLong(2, accountId);
            int result = stmt.executeUpdate();
            logger.info("Account balance updated - ID: {}, Balance: {}", accountId, balance);
            return result > 0;
        } finally {
            DatabaseConfig.closeStatement(stmt);
        }
    }

    @Override
    public boolean updateStatus(long accountId, String status) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(UPDATE_ACCOUNT_STATUS);
            stmt.setString(1, status);
            stmt.setLong(2, accountId);

            int result = stmt.executeUpdate();
            logger.info("Account status updated - ID: {}, Status: {}", accountId, status);
            return result > 0;

        } catch (SQLException e) {
            logger.error("Error updating account status", e);
            throw new Exception("Failed to update account status", e);
        } finally {
            DatabaseConfig.closeResources(null, stmt, conn);
        }
    }

    @Override
    public boolean updateChequeBookStatus(long accountId, boolean hasChequeBook) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        String sql = "UPDATE account SET has_cheque_book = ? WHERE account_id = ?";

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, hasChequeBook ? 1 : 0);
            stmt.setLong(2, accountId);

            int result = stmt.executeUpdate();
            logger.info("Account cheque book status updated - ID: {}, hasChequeBook: {}", accountId, hasChequeBook);
            return result > 0;

        } catch (SQLException e) {
            logger.error("Error updating account cheque book status", e);
            throw new Exception("Failed to update account cheque book status", e);
        } finally {
            DatabaseConfig.closeResources(null, stmt, conn);
        }
    }

    @Override
    public boolean updatePassbookStatus(long accountId, boolean hasPassbook) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        String sql = "UPDATE account SET has_passbook = ? WHERE account_id = ?";

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, hasPassbook ? 1 : 0);
            stmt.setLong(2, accountId);

            int result = stmt.executeUpdate();
            logger.info("Account passbook status updated - ID: {}, hasPassbook: {}", accountId, hasPassbook);
            return result > 0;

        } catch (SQLException e) {
            logger.error("Error updating account passbook status", e);
            throw new Exception("Failed to update account passbook status", e);
        } finally {
            DatabaseConfig.closeResources(null, stmt, conn);
        }
    }

    @Override
    public boolean updateAtmCardStatus(long accountId, boolean hasAtmCard) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        String sql = "UPDATE account SET has_atm_card = ? WHERE account_id = ?";

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, hasAtmCard ? 1 : 0);
            stmt.setLong(2, accountId);

            int result = stmt.executeUpdate();
            logger.info("Account ATM card status updated - ID: {}, hasAtmCard: {}", accountId, hasAtmCard);
            return result > 0;

        } catch (SQLException e) {
            logger.error("Error updating account ATM card status", e);
            throw new Exception("Failed to update account ATM card status", e);
        } finally {
            DatabaseConfig.closeResources(null, stmt, conn);
        }
    }

    @Override
    public boolean delete(long accountId) throws Exception {
        Connection conn = null;
        PreparedStatement stmtGetSignatories = null;
        PreparedStatement stmtUpdateTxnFrom = null;
        PreparedStatement stmtUpdateTxnTo = null;
        PreparedStatement stmtDelCards = null;
        PreparedStatement stmtDelBeneficiaries = null;
        PreparedStatement stmtDelSignatories = null;
        PreparedStatement stmtDelSavings = null;
        PreparedStatement stmtDelCurrent = null;
        PreparedStatement stmtDelAccount = null;
        
        ResultSet rsSig = null;
        List<Long> customerIds = new ArrayList<>();
        int accountDeleted = 0;

        try {
            conn = dbConfig.getConnection();
            conn.setAutoCommit(false); // start transaction

            // 1. Get all customer IDs mapped to this account before deleting signatory records
            String selectSignatoriesSql = "SELECT customer_id FROM account_signatory WHERE account_id = ?";
            stmtGetSignatories = conn.prepareStatement(selectSignatoriesSql);
            stmtGetSignatories.setLong(1, accountId);
            rsSig = stmtGetSignatories.executeQuery();
            while (rsSig.next()) {
                customerIds.add(rsSig.getLong("customer_id"));
            }
            rsSig.close();
            stmtGetSignatories.close();

            // 2. Set transaction linkages to NULL to bypass ON DELETE RESTRICT
            String updateTxnFromSql = "UPDATE transaction SET from_account_id = NULL WHERE from_account_id = ?";
            stmtUpdateTxnFrom = conn.prepareStatement(updateTxnFromSql);
            stmtUpdateTxnFrom.setLong(1, accountId);
            stmtUpdateTxnFrom.executeUpdate();
            stmtUpdateTxnFrom.close();

            String updateTxnToSql = "UPDATE transaction SET to_account_id = NULL WHERE to_account_id = ?";
            stmtUpdateTxnTo = conn.prepareStatement(updateTxnToSql);
            stmtUpdateTxnTo.setLong(1, accountId);
            stmtUpdateTxnTo.executeUpdate();
            stmtUpdateTxnTo.close();

            // 3. Delete Cards associated with this account
            String deleteCardsSql = "DELETE FROM card WHERE account_id = ?";
            stmtDelCards = conn.prepareStatement(deleteCardsSql);
            stmtDelCards.setLong(1, accountId);
            stmtDelCards.executeUpdate();
            stmtDelCards.close();

            // 4. Delete Beneficiary records associated with this account
            String deleteBeneficiarySql = "DELETE FROM beneficiary WHERE account_id = ?";
            stmtDelBeneficiaries = conn.prepareStatement(deleteBeneficiarySql);
            stmtDelBeneficiaries.setLong(1, accountId);
            stmtDelBeneficiaries.executeUpdate();
            stmtDelBeneficiaries.close();

            // 5. Delete Account Signatories
            String deleteSignatoriesSql = "DELETE FROM account_signatory WHERE account_id = ?";
            stmtDelSignatories = conn.prepareStatement(deleteSignatoriesSql);
            stmtDelSignatories.setLong(1, accountId);
            stmtDelSignatories.executeUpdate();
            stmtDelSignatories.close();

            // 6. Delete Savings sub-table
            String deleteSavingsSql = "DELETE FROM account_savings WHERE account_id = ?";
            stmtDelSavings = conn.prepareStatement(deleteSavingsSql);
            stmtDelSavings.setLong(1, accountId);
            stmtDelSavings.executeUpdate();
            stmtDelSavings.close();

            // 7. Delete Current sub-table
            String deleteCurrentSql = "DELETE FROM account_current WHERE account_id = ?";
            stmtDelCurrent = conn.prepareStatement(deleteCurrentSql);
            stmtDelCurrent.setLong(1, accountId);
            stmtDelCurrent.executeUpdate();
            stmtDelCurrent.close();

            // 8. Delete Account itself
            stmtDelAccount = conn.prepareStatement(DELETE_ACCOUNT);
            stmtDelAccount.setLong(1, accountId);
            accountDeleted = stmtDelAccount.executeUpdate();
            stmtDelAccount.close();

            // 9. Check and clean up customer records if they have no other accounts
            for (Long customerId : customerIds) {
                // Check if customer has any other active signatory accounts
                String checkOtherAccountsSql = "SELECT COUNT(*) FROM account_signatory WHERE customer_id = ?";
                try (PreparedStatement stmtCheckOther = conn.prepareStatement(checkOtherAccountsSql)) {
                    stmtCheckOther.setLong(1, customerId);
                    try (ResultSet rsCheckOther = stmtCheckOther.executeQuery()) {
                        if (rsCheckOther.next() && rsCheckOther.getInt(1) == 0) {
                            // No other accounts linked to this customer! Let's clean them up.
                            
                            // A. Delete repayments
                            String deleteRepaymentsSql = "DELETE FROM repayment WHERE customer_id = ?";
                            try (PreparedStatement stmtDelRepayments = conn.prepareStatement(deleteRepaymentsSql)) {
                                stmtDelRepayments.setLong(1, customerId);
                                stmtDelRepayments.executeUpdate();
                            }
                            
                            // B. Delete loans
                            String deleteLoansSql = "DELETE FROM loan WHERE customer_id = ?";
                            try (PreparedStatement stmtDelLoans = conn.prepareStatement(deleteLoansSql)) {
                                stmtDelLoans.setLong(1, customerId);
                                stmtDelLoans.executeUpdate();
                            }

                            // C. Delete cards
                            String deleteCustCardsSql = "DELETE FROM card WHERE customer_id = ?";
                            try (PreparedStatement stmtDelCustCards = conn.prepareStatement(deleteCustCardsSql)) {
                                stmtDelCustCards.setLong(1, customerId);
                                stmtDelCustCards.executeUpdate();
                            }

                            // D. Delete beneficiaries
                            String deleteCustBeneficiariesSql = "DELETE FROM beneficiary WHERE customer_id = ?";
                            try (PreparedStatement stmtDelCustBeneficiaries = conn.prepareStatement(deleteCustBeneficiariesSql)) {
                                stmtDelCustBeneficiaries.setLong(1, customerId);
                                stmtDelCustBeneficiaries.executeUpdate();
                            }

                            // E. Delete the customer
                            String deleteCustomerSql = "DELETE FROM customer WHERE customer_id = ?";
                            try (PreparedStatement stmtDelCustomer = conn.prepareStatement(deleteCustomerSql)) {
                                stmtDelCustomer.setLong(1, customerId);
                                stmtDelCustomer.executeUpdate();
                            }
                            
                            logger.info("Associated customer {} deleted completely from database.", customerId);
                        }
                    }
                }
            }

            conn.commit();
            logger.info("Account {} and associated signatories deleted successfully.", accountId);
            return accountDeleted > 0;

        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { logger.error("Rollback failed!", ex); }
            }
            logger.error("Error deleting account and signatories: {}", accountId, e);
            throw new Exception("Failed to delete account and customer: " + e.getMessage(), e);
        } finally {
            if (rsSig != null) { try { rsSig.close(); } catch (Exception e) {} }
            if (stmtGetSignatories != null) { try { stmtGetSignatories.close(); } catch (Exception e) {} }
            if (stmtUpdateTxnFrom != null) { try { stmtUpdateTxnFrom.close(); } catch (Exception e) {} }
            if (stmtUpdateTxnTo != null) { try { stmtUpdateTxnTo.close(); } catch (Exception e) {} }
            if (stmtDelCards != null) { try { stmtDelCards.close(); } catch (Exception e) {} }
            if (stmtDelBeneficiaries != null) { try { stmtDelBeneficiaries.close(); } catch (Exception e) {} }
            if (stmtDelSignatories != null) { try { stmtDelSignatories.close(); } catch (Exception e) {} }
            if (stmtDelSavings != null) { try { stmtDelSavings.close(); } catch (Exception e) {} }
            if (stmtDelCurrent != null) { try { stmtDelCurrent.close(); } catch (Exception e) {} }
            if (stmtDelAccount != null) { try { stmtDelAccount.close(); } catch (Exception e) {} }
            if (conn != null) { try { conn.close(); } catch (Exception e) {} }
        }
    }

    @Override
    public boolean existsByAccountNumber(String accountNumber) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(CHECK_ACCOUNT_NUMBER_EXISTS);
            stmt.setString(1, accountNumber);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;

        } catch (SQLException e) {
            logger.error("Error checking account number existence", e);
            throw new Exception("Failed to check account number", e);
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    @Override
    public int getAccountCountByCustomerId(long customerId) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(GET_ACCOUNT_COUNT);
            stmt.setLong(1, customerId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;

        } catch (SQLException e) {
            logger.error("Error getting account count", e);
            throw new Exception("Failed to get account count", e);
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    @Override
    public List<Account> getSavedBeneficiaries(long customerId) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Account> beneficiaries = new ArrayList<>();

        String sql = 
            "SELECT b.beneficiary_id, b.beneficiary_type, b.account_id, " +
            "       COALESCE(a.account_number, b.account_number) as account_number, " +
            "       COALESCE(a.ifsc_code, b.ifsc_code) as ifsc_code, " +
            "       COALESCE(b.holder_name, (SELECT GROUP_CONCAT(CONCAT(c.first_name, ' ', c.last_name) SEPARATOR ' & ') " +
            "                                FROM account_signatory s " +
            "                                JOIN customer c ON s.customer_id = c.customer_id " +
            "                                WHERE s.account_id = a.account_id)) as customer_name, " +
            "       COALESCE(a.account_type, 'external') as account_type, " +
            "       b.nickname " +
            "FROM beneficiary b " +
            "LEFT JOIN account a ON b.account_id = a.account_id " +
            "WHERE b.customer_id = ? " +
            "ORDER BY b.created_at DESC";

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setLong(1, customerId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                Account acc = new Account();
                String type = rs.getString("beneficiary_type");
                long benId = rs.getLong("beneficiary_id");
                
                if ("other".equalsIgnoreCase(type)) {
                    acc.setAccountId(-benId); // negative ID indicates external bank
                    acc.setNomineeName("ext_" + benId);
                } else {
                    acc.setAccountId(rs.getLong("account_id"));
                    acc.setNomineeName(String.valueOf(rs.getLong("account_id")));
                }
                
                acc.setAccountNumber(rs.getString("account_number"));
                acc.setIfscCode(rs.getString("ifsc_code"));
                
                String holderName = rs.getString("customer_name");
                if (holderName == null || holderName.trim().isEmpty()) {
                    holderName = rs.getString("nickname");
                }
                if (holderName == null || holderName.trim().isEmpty()) {
                    holderName = "Unknown Holder";
                }
                acc.setCustomerName(holderName);
                acc.setAccountType(rs.getString("account_type"));
                
                beneficiaries.add(acc);
            }
            logger.info("Fetched {} saved beneficiaries for customer: {}", beneficiaries.size(), customerId);
            return beneficiaries;

        } catch (SQLException e) {
            logger.error("Error fetching saved beneficiaries", e);
            throw new Exception("Failed to fetch saved beneficiaries", e);
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    @Override
    public boolean addBeneficiary(long customerId, long beneficiaryAccountId) throws Exception {
        Account target = getById(beneficiaryAccountId);
        if (target == null) {
            throw new Exception("Account not found");
        }
        String holderName = target.getCustomerName();
        if (holderName == null || holderName.trim().isEmpty() || "No Owner".equalsIgnoreCase(holderName)) {
            com.vgb.model.Customer c = new com.vgb.dao.CustomerDAOImpl().getById(target.getCustomerId());
            if (c != null) {
                holderName = c.getFirstName() + " " + c.getLastName();
            } else {
                holderName = "Unknown Holder";
            }
        }
        return addBeneficiary(customerId, "vgb", beneficiaryAccountId, target.getAccountNumber(), target.getIfscCode(), holderName);
    }

    @Override
    public boolean addBeneficiary(long customerId, String beneficiaryType, Long beneficiaryAccountId, String accountNumber, String ifscCode, String holderName) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        String sql = "INSERT INTO beneficiary (customer_id, beneficiary_type, account_id, account_number, ifsc_code, holder_name) VALUES (?, ?, ?, ?, ?, ?) " +
                     "ON DUPLICATE KEY UPDATE account_number = VALUES(account_number), ifsc_code = VALUES(ifsc_code), holder_name = VALUES(holder_name)";

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setLong(1, customerId);
            stmt.setString(2, beneficiaryType);
            if (beneficiaryAccountId == null || beneficiaryAccountId == 0) {
                stmt.setNull(3, java.sql.Types.BIGINT);
            } else {
                stmt.setLong(3, beneficiaryAccountId);
            }
            stmt.setString(4, accountNumber);
            stmt.setString(5, ifscCode);
            stmt.setString(6, holderName);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            logger.error("Error adding beneficiary in DAO", e);
            throw new Exception("Failed to add beneficiary", e);
        } finally {
            DatabaseConfig.closeResources(null, stmt, conn);
        }
    }

    @Override
    public String[] getExternalBeneficiaryDetails(long beneficiaryId) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        String sql = "SELECT account_number, ifsc_code, holder_name FROM beneficiary WHERE beneficiary_id = ?";
        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setLong(1, beneficiaryId);
            rs = stmt.executeQuery();
            if (rs.next()) {
                return new String[]{
                    rs.getString("account_number"),
                    rs.getString("ifsc_code"),
                    rs.getString("holder_name")
                };
            }
            return null;
        } catch (SQLException e) {
            logger.error("Error fetching external beneficiary details", e);
            throw new Exception("Failed to fetch external beneficiary details", e);
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    /**
     * Map ResultSet row to Account object
     */
    private Account mapResultSetToAccount(ResultSet rs) throws SQLException {
        Account account = new Account();
        account.setAccountId(rs.getLong("account_id"));
        account.setCustomerId(rs.getLong("customer_id"));
        account.setAccountType(rs.getString("account_type"));
        account.setBalance(rs.getBigDecimal("balance"));
        account.setIfscCode(rs.getString("ifsc_code"));
        account.setAccountNumber(rs.getString("account_number"));
        account.setStatus(rs.getString("status"));
        
        try {
            account.setUsername(rs.getString("username"));
            account.setPassword(rs.getString("password"));
            account.setPin(rs.getString("pin"));
        } catch (SQLException e) {
            // ignore
        }
        
        // Banking Services
        account.setHasAtmCard(rs.getInt("has_atm_card") == 1);
        account.setHasChequeBook(rs.getInt("has_cheque_book") == 1);
        account.setHasPassbook(rs.getInt("has_passbook") == 1);

        try {
            account.setFdRdTenureMonths(rs.getObject("fd_rd_tenure_months") != null ? rs.getInt("fd_rd_tenure_months") : null);
            account.setFdRdInterestRate(rs.getBigDecimal("fd_rd_interest_rate"));
            account.setFdRdMaturityAmount(rs.getBigDecimal("fd_rd_maturity_amount"));
            Date fdRdMaturityDate = rs.getDate("fd_rd_maturity_date");
            if (fdRdMaturityDate != null) {
                account.setFdRdMaturityDate(fdRdMaturityDate.toLocalDate());
            }
            account.setFdRdPayoutOption(rs.getString("fd_rd_payout_option"));
            account.setFdRdAutoRenewal(rs.getInt("fd_rd_auto_renewal") == 1);
            account.setFdRdAutoDebit(rs.getInt("fd_rd_auto_debit") == 1);
            account.setApplicationRefNo(rs.getString("application_ref_no"));
            account.setPassbookNumber(rs.getString("passbook_number"));
            account.setAtmCardNumber(rs.getString("atm_card_number"));
            account.setPensionAccount(rs.getInt("is_pension_account") == 1);
        } catch (SQLException e) {
            // ignore
        }
        
        try {
            String custName = rs.getString("customer_name");
            if (custName != null) {
                account.setCustomerName(custName);
            }
        } catch (SQLException e) {
            // Column not in result set for plain non-join queries
        }

        try {
            Date dobDate = rs.getDate("customer_dob");
            if (dobDate != null) {
                account.setCustomerDob(dobDate.toLocalDate());
            }
        } catch (SQLException e) {
            // Column not in result set for plain non-join queries
        }
        
        // Map sub-type fields dynamically if present in ResultSet
        try {
            account.setNomineeName(rs.getString("nominee_name"));
            account.setHoldingType(rs.getString("holding_type"));
            account.setDailyWithdrawalLimit(rs.getBigDecimal("daily_withdrawal_limit"));
        } catch (SQLException e) {
            // Not a savings account or columns not fetched
        }

        try {
            account.setBusinessName(rs.getString("business_name"));
            account.setGstin(rs.getString("gstin"));
            account.setOverdraftLimit(rs.getBigDecimal("overdraft_limit"));
            account.setCompanyCategory(rs.getString("company_category"));
            account.setCompanyPhone(rs.getString("company_phone"));
            account.setCompanyEmail(rs.getString("company_email"));
            account.setCompanyAddress(rs.getString("company_address"));
            account.setCompanyPan(rs.getString("company_pan"));
            account.setCompanyAadhaar(rs.getString("company_aadhaar"));
        } catch (SQLException e) {
            // Not a current account or columns not fetched
        }

        // Map primary customer details
        try {
            account.setPrimaryFirstName(rs.getString("primary_first_name"));
            account.setPrimaryMiddleName(rs.getString("primary_middle_name"));
            account.setPrimaryLastName(rs.getString("primary_last_name"));
            account.setPrimaryFatherName(rs.getString("primary_father_name"));
            account.setPrimaryMotherName(rs.getString("primary_mother_name"));
            account.setPrimaryNationality(rs.getString("primary_nationality"));
            account.setPrimaryEmail(rs.getString("primary_email"));
            account.setPrimaryPhone(rs.getString("primary_phone"));
            account.setPrimaryAltPhone(rs.getString("primary_alt_phone"));
            account.setPrimaryAddress(rs.getString("primary_address"));
            account.setPrimaryPermAddress(rs.getString("primary_perm_address"));
            account.setPrimaryCity(rs.getString("primary_city"));
            account.setPrimaryState(rs.getString("primary_state"));
            account.setPrimaryZip(rs.getString("primary_zip"));
            account.setPrimaryPan(rs.getString("primary_pan"));
            account.setPrimaryAadhaar(rs.getString("primary_aadhaar"));
            account.setPrimaryGender(rs.getString("primary_gender"));
            account.setPrimaryMaritalStatus(rs.getString("primary_marital_status"));
            account.setPrimaryOccupation(rs.getString("primary_occupation"));
            account.setPrimaryIncome(rs.getBigDecimal("primary_income"));
            account.setPrimaryGuardianName(rs.getString("primary_guardian_name"));
            account.setPrimaryGuardianRelationship(rs.getString("primary_guardian_relationship"));
            account.setPrimaryGuardianPhone(rs.getString("primary_guardian_phone"));
            account.setPrimaryGuardianAadhaar(rs.getString("primary_guardian_aadhaar"));
            account.setPrimaryGuardianPan(rs.getString("primary_guardian_pan"));
            account.setPrimarySchoolCollegeName(rs.getString("primary_school_college_name"));
            account.setPrimaryStudentId(rs.getString("primary_student_id"));
            account.setPrimaryCourse(rs.getString("primary_course"));
            account.setPrimaryAdmissionNumber(rs.getString("primary_admission_number"));
            account.setPrimaryCompanyName(rs.getString("primary_company_name"));
            account.setPrimaryEmployerName(rs.getString("primary_employer_name"));
            account.setPrimaryEmployeeId(rs.getString("primary_employee_id"));
            account.setPrimarySalaryFrequency(rs.getString("primary_salary_frequency"));
            account.setPrimaryRelationshipManager(rs.getString("primary_relationship_manager"));
        } catch (SQLException e) {
            // ignore
        }

        // Map joint customer details
        try {
            long jointId = rs.getLong("joint_customer_id");
            if (jointId > 0) {
                account.setJointCustomerId(jointId);
                account.setJointFirstName(rs.getString("joint_first_name"));
                account.setJointMiddleName(rs.getString("joint_middle_name"));
                account.setJointLastName(rs.getString("joint_last_name"));
                account.setJointFatherName(rs.getString("joint_father_name"));
                account.setJointMotherName(rs.getString("joint_mother_name"));
                account.setJointNationality(rs.getString("joint_nationality"));
                account.setJointEmail(rs.getString("joint_email"));
                account.setJointPhone(rs.getString("joint_phone"));
                account.setJointAltPhone(rs.getString("joint_alt_phone"));
                Date jDob = rs.getDate("joint_dob");
                if (jDob != null) {
                    account.setJointDob(jDob.toLocalDate());
                }
                account.setJointGender(rs.getString("joint_gender"));
                account.setJointMaritalStatus(rs.getString("joint_marital_status"));
                account.setJointPan(rs.getString("joint_pan"));
                account.setJointAadhaar(rs.getString("joint_aadhaar"));
                account.setJointAddress(rs.getString("joint_address"));
                account.setJointPermAddress(rs.getString("joint_perm_address"));
                account.setJointCity(rs.getString("joint_city"));
                account.setJointState(rs.getString("joint_state"));
                account.setJointZip(rs.getString("joint_zip"));
                account.setJointOccupation(rs.getString("joint_occupation"));
                account.setJointIncome(rs.getBigDecimal("joint_income"));
            }
        } catch (SQLException e) {
            // ignore
        }

        Timestamp timestamp = rs.getTimestamp("created_at");
        if (timestamp != null) {
            account.setCreatedAt(timestamp.toLocalDateTime());
        }
        
        return account;
    }

    @Override
    public int getTotalCustomersCount() throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement("SELECT COUNT(*) FROM customer");
            rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        } catch (SQLException e) {
            logger.error("Error getting total customers count", e);
            throw new Exception("Failed to get total customers count", e);
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    @Override
    public int getSavingsSingleCustomersCount() throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(
                "SELECT COUNT(DISTINCT s.customer_id) " +
                "FROM account_savings sav " +
                "JOIN account_signatory s ON sav.account_id = s.account_id " +
                "WHERE sav.holding_type = 'single'"
            );
            rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        } catch (SQLException e) {
            logger.error("Error getting single savings customers count", e);
            throw new Exception("Failed to get single savings customers count", e);
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    @Override
    public int getSavingsJointCustomersCount() throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(
                "SELECT COUNT(DISTINCT s.customer_id) " +
                "FROM account_savings sav " +
                "JOIN account_signatory s ON sav.account_id = s.account_id " +
                "WHERE sav.holding_type = 'joint'"
            );
            rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        } catch (SQLException e) {
            logger.error("Error getting joint savings customers count", e);
            throw new Exception("Failed to get joint savings customers count", e);
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    @Override
    public int getCurrentCustomersCount() throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(
                "SELECT COUNT(DISTINCT s.customer_id) " +
                "FROM account_current curr " +
                "JOIN account_signatory s ON curr.account_id = s.account_id"
            );
            rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        } catch (SQLException e) {
            logger.error("Error getting current customers count", e);
            throw new Exception("Failed to get current customers count", e);
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }
}
