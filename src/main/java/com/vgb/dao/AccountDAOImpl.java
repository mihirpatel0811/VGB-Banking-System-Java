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

    private static final String GET_ACCOUNT_BY_ID = 
        "SELECT a.*, " +
        "COALESCE(GROUP_CONCAT(CONCAT(c.first_name, ' ', c.last_name) ORDER BY s.ownership_type DESC SEPARATOR ' & '), 'No Owner') as customer_name, " +
        "COALESCE(MIN(CASE WHEN s.ownership_type = 'primary' THEN s.customer_id END), 0) as customer_id, " +
        "sav.nominee_name, sav.holding_type, sav.daily_withdrawal_limit, " +
        "curr.business_name, curr.gstin, curr.overdraft_limit, curr.company_category, curr.company_phone, curr.company_email, curr.company_address, curr.company_pan, curr.company_aadhaar " +
        "FROM account a " +
        "LEFT JOIN account_signatory s ON a.account_id = s.account_id " +
        "LEFT JOIN customer c ON s.customer_id = c.customer_id " +
        "LEFT JOIN account_savings sav ON a.account_id = sav.account_id " +
        "LEFT JOIN account_current curr ON a.account_id = curr.account_id " +
        "WHERE a.account_id = ? " +
        "GROUP BY a.account_id";
    private static final String GET_ACCOUNT_BY_NUMBER = 
        "SELECT a.*, " +
        "COALESCE(GROUP_CONCAT(CONCAT(c.first_name, ' ', c.last_name) ORDER BY s.ownership_type DESC SEPARATOR ' & '), 'No Owner') as customer_name, " +
        "COALESCE(MIN(CASE WHEN s.ownership_type = 'primary' THEN s.customer_id END), 0) as customer_id, " +
        "sav.nominee_name, sav.holding_type, sav.daily_withdrawal_limit, " +
        "curr.business_name, curr.gstin, curr.overdraft_limit, curr.company_category, curr.company_phone, curr.company_email, curr.company_address, curr.company_pan, curr.company_aadhaar " +
        "FROM account a " +
        "LEFT JOIN account_signatory s ON a.account_id = s.account_id " +
        "LEFT JOIN customer c ON s.customer_id = c.customer_id " +
        "LEFT JOIN account_savings sav ON a.account_id = sav.account_id " +
        "LEFT JOIN account_current curr ON a.account_id = curr.account_id " +
        "WHERE a.account_number = ? " +
        "GROUP BY a.account_id";
    private static final String GET_ACCOUNTS_BY_CUSTOMER = 
        "SELECT a.*, " +
        "COALESCE(GROUP_CONCAT(CONCAT(c.first_name, ' ', c.last_name) ORDER BY s.ownership_type DESC SEPARATOR ' & '), 'No Owner') as customer_name, " +
        "COALESCE(MIN(CASE WHEN s.ownership_type = 'primary' THEN s.customer_id END), 0) as customer_id, " +
        "sav.nominee_name, sav.holding_type, sav.daily_withdrawal_limit, " +
        "curr.business_name, curr.gstin, curr.overdraft_limit, curr.company_category, curr.company_phone, curr.company_email, curr.company_address, curr.company_pan, curr.company_aadhaar " +
        "FROM account a " +
        "LEFT JOIN account_signatory s ON a.account_id = s.account_id " +
        "LEFT JOIN customer c ON s.customer_id = c.customer_id " +
        "LEFT JOIN account_savings sav ON a.account_id = sav.account_id " +
        "LEFT JOIN account_current curr ON a.account_id = curr.account_id " +
        "WHERE a.account_id IN (SELECT account_id FROM account_signatory WHERE customer_id = ?) " +
        "GROUP BY a.account_id " +
        "ORDER BY a.created_at DESC";
    private static final String GET_ALL_ACCOUNTS = 
        "SELECT a.*, " +
        "COALESCE(GROUP_CONCAT(CONCAT(c.first_name, ' ', c.last_name) ORDER BY s.ownership_type DESC SEPARATOR ' & '), 'No Owner') as customer_name, " +
        "COALESCE(MIN(CASE WHEN s.ownership_type = 'primary' THEN s.customer_id END), 0) as customer_id, " +
        "sav.nominee_name, sav.holding_type, sav.daily_withdrawal_limit, " +
        "curr.business_name, curr.gstin, curr.overdraft_limit, curr.company_category, curr.company_phone, curr.company_email, curr.company_address, curr.company_pan, curr.company_aadhaar " +
        "FROM account a " +
        "LEFT JOIN account_signatory s ON a.account_id = s.account_id " +
        "LEFT JOIN customer c ON s.customer_id = c.customer_id " +
        "LEFT JOIN account_savings sav ON a.account_id = sav.account_id " +
        "LEFT JOIN account_current curr ON a.account_id = curr.account_id " +
        "GROUP BY a.account_id " +
        "ORDER BY a.created_at DESC";
    private static final String UPDATE_ACCOUNT = 
        "UPDATE account SET account_type = ?, ifsc_code = ?, status = ?, has_atm_card = ?, has_cheque_book = ?, has_passbook = ? WHERE account_id = ?";
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
            String createAccountSql = "INSERT INTO account (account_type, balance, ifsc_code, account_number, status, has_atm_card, has_cheque_book, has_passbook) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(createAccountSql, Statement.RETURN_GENERATED_KEYS);
            stmt.setString(1, account.getAccountType());
            stmt.setBigDecimal(2, account.getBalance());
            stmt.setString(3, account.getIfscCode());
            stmt.setString(4, account.getAccountNumber());
            stmt.setString(5, account.getStatus());
            stmt.setInt(6, account.isHasAtmCard() ? 1 : 0);
            stmt.setInt(7, account.isHasChequeBook() ? 1 : 0);
            stmt.setInt(8, account.isHasPassbook() ? 1 : 0);

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

            // 3. Insert subclass specific detail tables
            if ("savings".equalsIgnoreCase(account.getAccountType())) {
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
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(GET_ACCOUNT_BY_ID);
            stmt.setLong(1, accountId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToAccount(rs);
            }
            return null;

        } catch (SQLException e) {
            logger.error("Error fetching account by ID: {}", accountId, e);
            throw new Exception("Failed to fetch account", e);
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    @Override
    public Account getByAccountNumber(String accountNumber) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(GET_ACCOUNT_BY_NUMBER);
            stmt.setString(1, accountNumber);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToAccount(rs);
            }
            return null;

        } catch (SQLException e) {
            logger.error("Error fetching account by number: {}", accountNumber, e);
            throw new Exception("Failed to fetch account", e);
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
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
            stmt.setLong(7, account.getAccountId());

            int result = stmt.executeUpdate();

            // Update sub-table depending on account type
            if ("savings".equalsIgnoreCase(account.getAccountType())) {
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
        PreparedStatement stmt = null;

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(UPDATE_ACCOUNT_BALANCE);
            stmt.setBigDecimal(1, balance);
            stmt.setLong(2, accountId);

            int result = stmt.executeUpdate();
            logger.info("Account balance updated - ID: {}, Balance: {}", accountId, balance);
            return result > 0;

        } catch (SQLException e) {
            logger.error("Error updating account balance", e);
            throw new Exception("Failed to update balance", e);
        } finally {
            DatabaseConfig.closeResources(null, stmt, conn);
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
        
        // Banking Services
        account.setHasAtmCard(rs.getInt("has_atm_card") == 1);
        account.setHasChequeBook(rs.getInt("has_cheque_book") == 1);
        account.setHasPassbook(rs.getInt("has_passbook") == 1);
        
        try {
            String custName = rs.getString("customer_name");
            if (custName != null) {
                account.setCustomerName(custName);
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

        Timestamp timestamp = rs.getTimestamp("created_at");
        if (timestamp != null) {
            account.setCreatedAt(timestamp.toLocalDateTime());
        }
        
        return account;
    }
}
