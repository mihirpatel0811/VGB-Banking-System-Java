package com.vgb.service;

import com.vgb.constants.AppConstants;
import com.vgb.dao.*;
import com.vgb.model.Account;
import com.vgb.model.Loan;
import com.vgb.model.Repayment;
import com.vgb.model.Transaction;
import com.vgb.util.ValidatorUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;
import java.util.UUID;
import java.sql.*;


/**
 * LoanService: Handles loan-related business logic
 */
public class LoanService {
    private static final Logger logger = LoggerFactory.getLogger(LoanService.class);
    private LoanDAOImpl loanDAO = new LoanDAOImpl();
    private RepaymentDAOImpl repaymentDAO = new RepaymentDAOImpl();
    private TransactionDAOImpl transactionDAO = new TransactionDAOImpl();
    private AccountDAOImpl accountDAO = new AccountDAOImpl();

    /**
     * Request loan (customer)
     */
    public boolean applyForLoan(Loan loan) throws Exception {
        return requestLoan(loan) != null;
    }

    public Loan requestLoan(Loan loan) throws Exception {
        if (!ValidatorUtil.isValidLoanType(loan.getLoanType())) {
            throw new Exception("Invalid loan type");
        }

        if (!ValidatorUtil.isValidAmount(loan.getPrincipalAmount(), AppConstants.MIN_LOAN_AMOUNT)) {
            throw new Exception("Loan amount is below minimum");
        }

        try {
            loan.setStatus(AppConstants.LOAN_STATUS_PENDING_APPROVAL);
            if (loan.getStartDate() == null) {
                loan.setStartDate(java.time.LocalDate.now());
            }
            if (loan.getEndDate() == null) {
                loan.setEndDate(java.time.LocalDate.now().plusMonths(loan.getTermMonths()));
            }
            
            if (loanDAO.create(loan)) {
                logger.info("Loan requested - Customer: {}, Amount: {}", loan.getCustomerId(), loan.getPrincipalAmount());
                return loan;
            }
            throw new Exception("Failed to create loan request");

        } catch (Exception e) {
            logger.error("Error requesting loan", e);
            throw e;
        }
    }

    /**
     * Get loans by customer ID and status
     */
    public List<Loan> getLoansByCustomerIdAndStatus(long customerId, String status) throws Exception {
        try {
            return loanDAO.getByCustomerIdAndStatus(customerId, status);
        } catch (Exception e) {
            logger.error("Error fetching loans", e);
            throw new Exception("Failed to fetch loans", e);
        }
    }

    /**
     * Get loan by ID
     */
    public Loan getLoanById(long loanId) throws Exception {
        try {
            return loanDAO.getById(loanId);
        } catch (Exception e) {
            logger.error("Error fetching loan", e);
            throw new Exception("Failed to fetch loan", e);
        }
    }

    /**
     * Get customer's loans
     */
    public List<Loan> getCustomerLoans(long customerId) throws Exception {
        try {
            return loanDAO.getByCustomerId(customerId);
        } catch (Exception e) {
            logger.error("Error fetching customer loans", e);
            throw new Exception("Failed to fetch loans", e);
        }
    }

    /**
     * Get loans by status (admin)
     */
    public List<Loan> getLoansByStatus(String status) throws Exception {
        try {
            return loanDAO.getByStatus(status);
        } catch (Exception e) {
            logger.error("Error fetching loans by status", e);
            throw new Exception("Failed to fetch loans", e);
        }
    }

    /**
     * Approve loan (admin)
     */
    public boolean approveLoan(long loanId) throws Exception {
        try {
            Loan loan = loanDAO.getById(loanId);
            
            if (loan == null) {
                throw new Exception("Loan not found");
            }

            if (!loan.getStatus().equalsIgnoreCase(AppConstants.LOAN_STATUS_PENDING_APPROVAL)) {
                throw new Exception("Loan is not in pending approval status");
            }

            // Step 1: Update status to approved
            boolean result = loanDAO.updateStatus(loanId, AppConstants.LOAN_STATUS_APPROVED);
            
            if (result) {
                logger.info("Loan approved successfully: {}", loanId);
                
                // Step 2: Extract linkedAccountId for automatic instant transfer
                long targetAccountId = 0;
                String formDetails = loan.getFormDetails();
                
                if (formDetails != null && !formDetails.trim().isEmpty()) {
                    try {
                        com.google.gson.JsonObject json = com.google.gson.JsonParser.parseString(formDetails).getAsJsonObject();
                        if (json.has("linkedAccountId")) {
                            targetAccountId = json.get("linkedAccountId").getAsLong();
                        }
                    } catch (Exception ex) {
                        logger.error("Failed to parse linkedAccountId from formDetails for automatic instant transfer", ex);
                    }
                }
                
                // Fall back cleanly to the customer's first active VGB savings or checking account
                if (targetAccountId <= 0) {
                    try {
                        List<Account> customerAccounts = accountDAO.getByCustomerId(loan.getCustomerId());
                        for (Account acc : customerAccounts) {
                            if ("active".equalsIgnoreCase(acc.getStatus())) {
                                targetAccountId = acc.getAccountId();
                                break;
                            }
                        }
                    } catch (Exception ex) {
                        logger.error("Failed resolving customer accounts for fallback automatic instant transfer", ex);
                    }
                }
                
                if (targetAccountId > 0) {
                    try {
                        logger.info("Executing instant automatic disbursement to Account ID: {}", targetAccountId);
                        disburseLoan(loanId, targetAccountId);
                    } catch (Exception ex) {
                        logger.error("Failed executing instant automatic loan disbursement", ex);
                        throw new Exception("Loan approved, but automatic transfer failed: " + ex.getMessage());
                    }
                } else {
                    logger.warn("Could not find any linked or active account for instant loan disbursement customer ID: {}", loan.getCustomerId());
                    throw new Exception("Loan approved, but could not resolve linked bank account for instant transfer. Please disburse manually.");
                }
            }
            return result;

        } catch (Exception e) {
            logger.error("Error approving loan", e);
            throw new Exception(e.getMessage());
        }
    }

    /**
     * Disburse loan (admin - transfer amount to customer account)
     */
    public boolean disburseLoan(long loanId, long accountId) throws Exception {
        try {
            Loan loan = loanDAO.getById(loanId);
            Account account = accountDAO.getById(accountId);

            if (loan == null) {
                throw new Exception("Loan not found");
            }

            if (account == null) {
                throw new Exception("Account not found");
            }

            if (!loan.getStatus().equalsIgnoreCase(AppConstants.LOAN_STATUS_APPROVED)) {
                throw new Exception("Loan must be approved before disbursement");
            }

            // Transfer loan amount to customer account
            BigDecimal newBalance = account.getBalance().add(loan.getPrincipalAmount());
            accountDAO.updateBalance(accountId, newBalance);

            // Create transaction
            Transaction transaction = new Transaction();
            transaction.setToAccountId(accountId);
            transaction.setTransactionType(AppConstants.TRANSACTION_TYPE_TRANSFER);
            transaction.setAmount(loan.getPrincipalAmount());
            transaction.setReferenceNumber("LOAN" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
            transaction.setDescription("Loan Disbursement - Loan ID: " + loanId);
            transaction.setStatus(AppConstants.TRANSACTION_STATUS_COMPLETED);
            transactionDAO.create(transaction);

            // Update loan status
            boolean result = loanDAO.updateStatus(loanId, AppConstants.LOAN_STATUS_DISBURSED);
            
            if (result) {
                logger.info("Loan disbursed - Loan ID: {}, Account: {}, Amount: {}", loanId, accountId, loan.getPrincipalAmount());
            }
            return result;

        } catch (Exception e) {
            logger.error("Error disbursing loan", e);
            throw new Exception("Failed to disburse loan", e);
        }
    }

    /**
     * Process loan repayment
     */
    public boolean processRepayment(long loanId, long customerId, BigDecimal amount, long accountId) throws Exception {
        // Step 1: Pre-validation of payment amount
        if (!ValidatorUtil.isValidAmount(amount)) {
            throw new Exception("Invalid repayment amount");
        }

        Connection conn = null;
        PreparedStatement stmtCheck = null;
        PreparedStatement stmtDebit = null;
        PreparedStatement stmtTxn = null;
        PreparedStatement stmtRepay = null;
        PreparedStatement stmtLoanBal = null;
        PreparedStatement stmtLoanStat = null;
        ResultSet rsCheck = null;

        try {
            // Step 2: Establish connection and initiate database transaction block
            conn = com.vgb.config.DatabaseConfig.getInstance().getConnection();
            conn.setAutoCommit(false); // BEGIN TRANSACTION (Sets autocommit to false for atomic execution)

            // Step 3: Fetch active loan details inside the transaction scope
            BigDecimal remainingBalance = null;
            BigDecimal interestRate = null;
            String status = null;
            String fetchLoanSql = "SELECT remaining_balance, interest_rate, status FROM loan WHERE loan_id = ?";
            stmtCheck = conn.prepareStatement(fetchLoanSql);
            stmtCheck.setLong(1, loanId);
            rsCheck = stmtCheck.executeQuery();
            if (rsCheck.next()) {
                remainingBalance = rsCheck.getBigDecimal("remaining_balance");
                interestRate = rsCheck.getBigDecimal("interest_rate");
                status = rsCheck.getString("status");
            } else {
                throw new Exception("Loan not found");
            }
            rsCheck.close();
            stmtCheck.close();

            // Validate loan status and balance to prevent repayments on closed/inactive loans
            if ("closed".equalsIgnoreCase(status) || remainingBalance.compareTo(BigDecimal.ZERO) <= 0) {
                throw new Exception("This loan has already been fully repaid and closed.");
            }
            if ("pending_approval".equalsIgnoreCase(status) || "rejected".equalsIgnoreCase(status)) {
                throw new Exception("Repayment is only allowed on active or disbursed loans.");
            }

            // Step 4: Fetch bank account balance inside transaction scope
            BigDecimal accountBalance = null;
            String fetchAccSql = "SELECT balance FROM account WHERE account_id = ?";
            stmtCheck = conn.prepareStatement(fetchAccSql);
            stmtCheck.setLong(1, accountId);
            rsCheck = stmtCheck.executeQuery();
            if (rsCheck.next()) {
                accountBalance = rsCheck.getBigDecimal("balance");
            } else {
                throw new Exception("Account not found");
            }
            rsCheck.close();
            stmtCheck.close();

            // Resolve actual repayment amount and principal/interest components
            BigDecimal repaymentAmount = amount;
            BigDecimal principalComponent;
            BigDecimal interestComponent;

            if (repaymentAmount.compareTo(remainingBalance) >= 0) {
                // If payment amount exceeds or equals remaining balance, treat as full payoff
                repaymentAmount = remainingBalance;
                principalComponent = remainingBalance;
                interestComponent = BigDecimal.ZERO;
            } else {
                // Calculate components for partial payment
                principalComponent = calculatePrincipalComponent(repaymentAmount, interestRate, remainingBalance);
                if (principalComponent.compareTo(remainingBalance) > 0) {
                    principalComponent = remainingBalance;
                }
                interestComponent = repaymentAmount.subtract(principalComponent);
            }

            // Step 5: Core balance validation (Prevents overdrafts or illegal negative balances)
            if (accountBalance.compareTo(repaymentAmount) < 0) {
                throw new Exception("Insufficient balance");
            }

            // Step 7: Debit bank account balance in the database
            BigDecimal newBalance = accountBalance.subtract(repaymentAmount);
            String debitSql = "UPDATE account SET balance = ? WHERE account_id = ?";
            stmtDebit = conn.prepareStatement(debitSql);
            stmtDebit.setBigDecimal(1, newBalance);
            stmtDebit.setLong(2, accountId);
            stmtDebit.executeUpdate();
            stmtDebit.close();

            // Step 8: Log entry into the transactions ledger
            String insertTxnSql = "INSERT INTO transaction (from_account_id, to_account_id, transaction_type, amount, reference_number, description, status) VALUES (?, NULL, ?, ?, ?, ?, ?)";
            stmtTxn = conn.prepareStatement(insertTxnSql, Statement.RETURN_GENERATED_KEYS);
            stmtTxn.setLong(1, accountId);
            stmtTxn.setString(2, AppConstants.TRANSACTION_TYPE_TRANSFER);
            stmtTxn.setBigDecimal(3, repaymentAmount);
            stmtTxn.setString(4, "REPAY" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
            stmtTxn.setString(5, "Loan Repayment - Loan ID: " + loanId);
            stmtTxn.setString(6, AppConstants.TRANSACTION_STATUS_COMPLETED);
            stmtTxn.executeUpdate();

            // Step 9: Retrieve auto-generated transaction primary key for repayment linkage
            long transactionId = 0;
            try (ResultSet generatedKeys = stmtTxn.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    transactionId = generatedKeys.getLong(1);
                } else {
                    throw new SQLException("Failed to retrieve transaction ID for repayment.");
                }
            }
            stmtTxn.close();

            // Step 10: Create repayment history (loan_statement entry)
            String insertRepaySql = "INSERT INTO repayment (loan_id, customer_id, transaction_id, amount_paid, principal_component, interest_component) VALUES (?, ?, ?, ?, ?, ?)";
            stmtRepay = conn.prepareStatement(insertRepaySql);
            stmtRepay.setLong(1, loanId);
            stmtRepay.setLong(2, customerId);
            stmtRepay.setLong(3, transactionId);
            stmtRepay.setBigDecimal(4, repaymentAmount);
            stmtRepay.setBigDecimal(5, principalComponent);
            stmtRepay.setBigDecimal(6, interestComponent);
            stmtRepay.executeUpdate();
            stmtRepay.close();

            // Step 11: Reduce loans outstanding remaining balance in database
            BigDecimal newRemainingBalance = remainingBalance.subtract(principalComponent);
            String updateLoanBalSql = "UPDATE loan SET remaining_balance = ? WHERE loan_id = ?";
            stmtLoanBal = conn.prepareStatement(updateLoanBalSql);
            stmtLoanBal.setBigDecimal(1, newRemainingBalance);
            stmtLoanBal.setLong(2, loanId);
            stmtLoanBal.executeUpdate();
            stmtLoanBal.close();

            // Step 12: Evaluate if loan is fully repaid and update loans status accordingly
            if (newRemainingBalance.compareTo(BigDecimal.ZERO) <= 0) {
                String updateLoanStatSql = "UPDATE loan SET status = ? WHERE loan_id = ?";
                stmtLoanStat = conn.prepareStatement(updateLoanStatSql);
                stmtLoanStat.setString(1, AppConstants.LOAN_STATUS_CLOSED);
                stmtLoanStat.setLong(2, loanId);
                stmtLoanStat.executeUpdate();
                stmtLoanStat.close();
                logger.info("Loan closed via transaction - Loan ID: {}", loanId);
            }

            // Step 13: COMMIT (Executes all operations successfully as a single atomic unit)
            conn.commit(); 
            logger.info("Repayment processed cleanly inside database transaction - Loan: {}, Amount: {}, Principal: {}, Interest: {}", 
                    loanId, repaymentAmount, principalComponent, interestComponent);
            return true;

        } catch (Exception e) {
            // Step 14: ROLLBACK (If any step fails, rollback all database state changes cleanly)
            if (conn != null) {
                try {
                    conn.rollback();
                    logger.warn("Transaction rolled back for processRepayment due to error: {}", e.getMessage());
                } catch (SQLException ex) {
                    logger.error("Failed to rollback transaction", ex);
                }
            }
            logger.error("Error processing repayment in transaction", e);
            throw new Exception("Failed to process repayment: " + e.getMessage(), e);
        } finally {
            // Step 15: Safe resources clean-up
            com.vgb.config.DatabaseConfig.closeResources(rsCheck, stmtCheck, conn);
            try { if (stmtDebit != null) stmtDebit.close(); } catch (Exception e) {}
            try { if (stmtTxn != null) stmtTxn.close(); } catch (Exception e) {}
            try { if (stmtRepay != null) stmtRepay.close(); } catch (Exception e) {}
            try { if (stmtLoanBal != null) stmtLoanBal.close(); } catch (Exception e) {}
            try { if (stmtLoanStat != null) stmtLoanStat.close(); } catch (Exception e) {}
        }
    }

    /**
     * Get loan repayment history
     */
    public List<Repayment> getLoanRepaymentHistory(long loanId) throws Exception {
        try {
            return repaymentDAO.getByLoanId(loanId);
        } catch (Exception e) {
            logger.error("Error fetching repayment history", e);
            throw new Exception("Failed to fetch repayment history", e);
        }
    }

    /**
     * Reject loan (admin)
     */
    public boolean rejectLoan(long loanId) throws Exception {
        try {
            Loan loan = loanDAO.getById(loanId);
            
            if (loan == null) {
                throw new Exception("Loan not found");
            }

            boolean result = loanDAO.updateStatus(loanId, AppConstants.LOAN_STATUS_REJECTED);
            
            if (result) {
                logger.info("Loan rejected: {}", loanId);
            }
            return result;

        } catch (Exception e) {
            logger.error("Error rejecting loan", e);
            throw new Exception("Failed to reject loan", e);
        }
    }

    /**
     * Calculate principal component of repayment
     */
    private BigDecimal calculatePrincipalComponent(BigDecimal totalAmount, BigDecimal interestRate, BigDecimal remainingBalance) {
        // Monthly rate = interestRate / 12 / 100 = interestRate / 1200
        BigDecimal monthlyRate = interestRate.divide(new BigDecimal("1200"), 10, RoundingMode.HALF_UP);
        BigDecimal interestComponent = remainingBalance.multiply(monthlyRate).setScale(4, RoundingMode.HALF_UP);
        
        if (interestComponent.compareTo(totalAmount) >= 0) {
            return BigDecimal.ZERO;
        }
        return totalAmount.subtract(interestComponent);
    }

    /**
     * Get all loans in the system
     */
    public List<Loan> getAllLoans() throws Exception {
        try {
            return loanDAO.getAll();
        } catch (Exception e) {
            logger.error("Error fetching all loans", e);
            throw new Exception("Failed to fetch all loans", e);
        }
    }

    /**
     * Get loans by customer ID (alias for getCustomerLoans)
     */
    public List<Loan> getLoansByCustomerId(long customerId) throws Exception {
        return getCustomerLoans(customerId);
    }

    /**
     * Get all repayments in the system (admin)
     */
    public List<Repayment> getAllRepayments() throws Exception {
        try {
            List<Repayment> all = repaymentDAO.getAll();
            java.util.Map<Long, Repayment> aggregated = new java.util.LinkedHashMap<>();
            for (Repayment pay : all) {
                // Skip repayments associated with fully paid/closed loans
                Loan loan = loanDAO.getById(pay.getLoanId());
                if (loan != null && AppConstants.LOAN_STATUS_CLOSED.equalsIgnoreCase(loan.getStatus())) {
                    continue;
                }
                
                Long customerId = pay.getCustomerId();
                if (!aggregated.containsKey(customerId)) {
                    Repayment copy = new Repayment();
                    copy.setRepaymentId(pay.getRepaymentId());
                    copy.setLoanId(pay.getLoanId());
                    copy.setCustomerId(pay.getCustomerId());
                    copy.setTransactionId(pay.getTransactionId());
                    copy.setAmountPaid(pay.getAmountPaid());
                    copy.setPrincipalComponent(pay.getPrincipalComponent());
                    copy.setInterestComponent(pay.getInterestComponent());
                    copy.setRepaymentDate(pay.getRepaymentDate());
                    aggregated.put(customerId, copy);
                } else {
                    Repayment existing = aggregated.get(customerId);
                    existing.setAmountPaid(existing.getAmountPaid().add(pay.getAmountPaid()));
                    existing.setPrincipalComponent(existing.getPrincipalComponent().add(pay.getPrincipalComponent()));
                    existing.setInterestComponent(existing.getInterestComponent().add(pay.getInterestComponent()));
                }
            }
            return new java.util.ArrayList<>(aggregated.values());
        } catch (Exception e) {
            logger.error("Error fetching all repayments", e);
            throw new Exception("Failed to fetch all repayments", e);
        }
    }

    /**
     * Update loan details (admin)
     */
    public boolean updateLoan(Loan loan) throws Exception {
        try {
            return loanDAO.update(loan);
        } catch (Exception e) {
            logger.error("Error updating loan", e);
            throw new Exception("Failed to update loan details: " + e.getMessage(), e);
        }
    }

    /**
     * Process loan repayment using Cash at the Cash Counter
     */
    public boolean processCashRepayment(long loanId, long customerId, BigDecimal amount, Long performedById) throws Exception {
        if (!ValidatorUtil.isValidAmount(amount)) {
            throw new Exception("Invalid repayment amount");
        }

        Connection conn = null;
        PreparedStatement stmtCheck = null;
        PreparedStatement stmtTxn = null;
        PreparedStatement stmtRepay = null;
        PreparedStatement stmtLoanBal = null;
        PreparedStatement stmtLoanStat = null;
        ResultSet rsCheck = null;

        try {
            conn = com.vgb.config.DatabaseConfig.getInstance().getConnection();
            conn.setAutoCommit(false); // BEGIN TRANSACTION

            // Fetch active loan details
            BigDecimal remainingBalance = null;
            BigDecimal interestRate = null;
            String status = null;
            String fetchLoanSql = "SELECT remaining_balance, interest_rate, status FROM loan WHERE loan_id = ?";
            stmtCheck = conn.prepareStatement(fetchLoanSql);
            stmtCheck.setLong(1, loanId);
            rsCheck = stmtCheck.executeQuery();
            if (rsCheck.next()) {
                remainingBalance = rsCheck.getBigDecimal("remaining_balance");
                interestRate = rsCheck.getBigDecimal("interest_rate");
                status = rsCheck.getString("status");
            } else {
                throw new Exception("Loan not found");
            }
            rsCheck.close();
            stmtCheck.close();

            if ("closed".equalsIgnoreCase(status) || remainingBalance.compareTo(BigDecimal.ZERO) <= 0) {
                throw new Exception("This loan has already been fully repaid and closed.");
            }
            if ("pending_approval".equalsIgnoreCase(status) || "rejected".equalsIgnoreCase(status)) {
                throw new Exception("Repayment is only allowed on active or disbursed loans.");
            }

            BigDecimal repaymentAmount = amount;
            BigDecimal principalComponent;
            BigDecimal interestComponent;

            if (repaymentAmount.compareTo(remainingBalance) >= 0) {
                repaymentAmount = remainingBalance;
                principalComponent = remainingBalance;
                interestComponent = BigDecimal.ZERO;
            } else {
                principalComponent = calculatePrincipalComponent(repaymentAmount, interestRate, remainingBalance);
                if (principalComponent.compareTo(remainingBalance) > 0) {
                    principalComponent = remainingBalance;
                }
                interestComponent = repaymentAmount.subtract(principalComponent);
            }

            // Log entry into the transactions ledger
            String insertTxnSql = "INSERT INTO transaction (from_account_id, to_account_id, transaction_type, amount, reference_number, description, status, transfer_mode, performed_by_id) VALUES (NULL, NULL, ?, ?, ?, ?, ?, ?, ?)";
            stmtTxn = conn.prepareStatement(insertTxnSql, Statement.RETURN_GENERATED_KEYS);
            stmtTxn.setString(1, AppConstants.TRANSACTION_TYPE_TRANSFER);
            stmtTxn.setBigDecimal(2, repaymentAmount);
            stmtTxn.setString(3, "REPAY" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
            stmtTxn.setString(4, "Loan Repayment (Cash Counter) - Loan ID: " + loanId);
            stmtTxn.setString(5, AppConstants.TRANSACTION_STATUS_COMPLETED);
            stmtTxn.setString(6, "cash");
            stmtTxn.setObject(7, performedById, Types.BIGINT);
            stmtTxn.executeUpdate();

            long transactionId = 0;
            try (ResultSet generatedKeys = stmtTxn.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    transactionId = generatedKeys.getLong(1);
                } else {
                    throw new SQLException("Failed to retrieve transaction ID for repayment.");
                }
            }
            stmtTxn.close();

            // Create repayment history
            String insertRepaySql = "INSERT INTO repayment (loan_id, customer_id, transaction_id, amount_paid, principal_component, interest_component) VALUES (?, ?, ?, ?, ?, ?)";
            stmtRepay = conn.prepareStatement(insertRepaySql);
            stmtRepay.setLong(1, loanId);
            stmtRepay.setLong(2, customerId);
            stmtRepay.setLong(3, transactionId);
            stmtRepay.setBigDecimal(4, repaymentAmount);
            stmtRepay.setBigDecimal(5, principalComponent);
            stmtRepay.setBigDecimal(6, interestComponent);
            stmtRepay.executeUpdate();
            stmtRepay.close();

            // Reduce loans outstanding balance
            BigDecimal newRemainingBalance = remainingBalance.subtract(principalComponent);
            String updateLoanBalSql = "UPDATE loan SET remaining_balance = ? WHERE loan_id = ?";
            stmtLoanBal = conn.prepareStatement(updateLoanBalSql);
            stmtLoanBal.setBigDecimal(1, newRemainingBalance);
            stmtLoanBal.setLong(2, loanId);
            stmtLoanBal.executeUpdate();
            stmtLoanBal.close();

            if (newRemainingBalance.compareTo(BigDecimal.ZERO) <= 0) {
                String updateLoanStatSql = "UPDATE loan SET status = ? WHERE loan_id = ?";
                stmtLoanStat = conn.prepareStatement(updateLoanStatSql);
                stmtLoanStat.setString(1, AppConstants.LOAN_STATUS_CLOSED);
                stmtLoanStat.setLong(2, loanId);
                stmtLoanStat.executeUpdate();
                stmtLoanStat.close();
                logger.info("Loan closed via cash payment - Loan ID: {}", loanId);
            }

            conn.commit();
            logger.info("Cash repayment processed successfully - Loan: {}, Amount: {}", loanId, repaymentAmount);
            return true;

        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { logger.error("Rollback failed", ex); }
            }
            logger.error("Error processing cash repayment", e);
            throw new Exception("Failed to process cash repayment: " + e.getMessage(), e);
        } finally {
            com.vgb.config.DatabaseConfig.closeResources(rsCheck, stmtCheck, conn);
            try { if (stmtTxn != null) stmtTxn.close(); } catch (Exception e) {}
            try { if (stmtRepay != null) stmtRepay.close(); } catch (Exception e) {}
            try { if (stmtLoanBal != null) stmtLoanBal.close(); } catch (Exception e) {}
            try { if (stmtLoanStat != null) stmtLoanStat.close(); } catch (Exception e) {}
        }
    }

    /**
     * Process loan repayment using a VGB cheque
     */
    public boolean processChequeRepayment(long loanId, long customerId, BigDecimal amount, long accountId, String chequeBookNumber, String chequeNumber, Long performedById) throws Exception {
        if (!ValidatorUtil.isValidAmount(amount)) {
            throw new Exception("Invalid repayment amount");
        }

        Connection conn = null;
        PreparedStatement stmtCheck = null;
        PreparedStatement stmtDebit = null;
        PreparedStatement stmtTxn = null;
        PreparedStatement stmtRepay = null;
        PreparedStatement stmtLoanBal = null;
        PreparedStatement stmtLoanStat = null;
        ResultSet rsCheck = null;

        try {
            conn = com.vgb.config.DatabaseConfig.getInstance().getConnection();
            conn.setAutoCommit(false); // BEGIN TRANSACTION

            // 1. Verify and update cheque leaf status
            com.vgb.dao.ChequeBookDAOImpl cbDAO = new com.vgb.dao.ChequeBookDAOImpl();
            com.vgb.model.ChequeLeaf leaf = cbDAO.getChequeLeaf(chequeBookNumber, chequeNumber);
            if (leaf == null) {
                throw new Exception("Cheque leaf #" + chequeNumber + " not found or does not belong to Cheque Book " + chequeBookNumber + ".");
            }
            if (!"unused".equalsIgnoreCase(leaf.getStatus())) {
                throw new Exception("Cheque leaf #" + chequeNumber + " is already " + leaf.getStatus() + ".");
            }

            List<com.vgb.model.ChequeBook> activeBooks = cbDAO.getActiveChequeBooksByAccount(accountId);
            boolean belongs = false;
            for (com.vgb.model.ChequeBook cb : activeBooks) {
                if (cb.getChequebookId() == leaf.getChequebookId() && cb.getChequebookNumber().equals(chequeBookNumber)) {
                    belongs = true;
                    if (!"active".equalsIgnoreCase(cb.getStatus())) {
                        throw new Exception("Cheque Book " + chequeBookNumber + " is not active.");
                    }
                    break;
                }
            }
            if (!belongs) {
                throw new Exception("Cheque Book " + chequeBookNumber + " does not belong to the selected account.");
            }

            // Mark cheque leaf as used
            cbDAO.updateChequeLeafStatus(conn, leaf.getChequebookId(), chequeNumber, "used");

            // 2. Fetch active loan details
            BigDecimal remainingBalance = null;
            BigDecimal interestRate = null;
            String status = null;
            String fetchLoanSql = "SELECT remaining_balance, interest_rate, status FROM loan WHERE loan_id = ?";
            stmtCheck = conn.prepareStatement(fetchLoanSql);
            stmtCheck.setLong(1, loanId);
            rsCheck = stmtCheck.executeQuery();
            if (rsCheck.next()) {
                remainingBalance = rsCheck.getBigDecimal("remaining_balance");
                interestRate = rsCheck.getBigDecimal("interest_rate");
                status = rsCheck.getString("status");
            } else {
                throw new Exception("Loan not found");
            }
            rsCheck.close();
            stmtCheck.close();

            if ("closed".equalsIgnoreCase(status) || remainingBalance.compareTo(BigDecimal.ZERO) <= 0) {
                throw new Exception("This loan has already been fully repaid and closed.");
            }
            if ("pending_approval".equalsIgnoreCase(status) || "rejected".equalsIgnoreCase(status)) {
                throw new Exception("Repayment is only allowed on active or disbursed loans.");
            }

            // 3. Fetch bank account balance
            BigDecimal accountBalance = null;
            String fetchAccSql = "SELECT balance FROM account WHERE account_id = ?";
            stmtCheck = conn.prepareStatement(fetchAccSql);
            stmtCheck.setLong(1, accountId);
            rsCheck = stmtCheck.executeQuery();
            if (rsCheck.next()) {
                accountBalance = rsCheck.getBigDecimal("balance");
            } else {
                throw new Exception("Account not found");
            }
            rsCheck.close();
            stmtCheck.close();

            BigDecimal repaymentAmount = amount;
            BigDecimal principalComponent;
            BigDecimal interestComponent;

            if (repaymentAmount.compareTo(remainingBalance) >= 0) {
                repaymentAmount = remainingBalance;
                principalComponent = remainingBalance;
                interestComponent = BigDecimal.ZERO;
            } else {
                principalComponent = calculatePrincipalComponent(repaymentAmount, interestRate, remainingBalance);
                if (principalComponent.compareTo(remainingBalance) > 0) {
                    principalComponent = remainingBalance;
                }
                interestComponent = repaymentAmount.subtract(principalComponent);
            }

            if (accountBalance.compareTo(repaymentAmount) < 0) {
                throw new Exception("Insufficient balance");
            }

            // 4. Debit bank account balance
            BigDecimal newBalance = accountBalance.subtract(repaymentAmount);
            String debitSql = "UPDATE account SET balance = ? WHERE account_id = ?";
            stmtDebit = conn.prepareStatement(debitSql);
            stmtDebit.setBigDecimal(1, newBalance);
            stmtDebit.setLong(2, accountId);
            stmtDebit.executeUpdate();
            stmtDebit.close();

            // 5. Log entry into the transactions ledger
            String insertTxnSql = "INSERT INTO transaction (from_account_id, to_account_id, transaction_type, amount, reference_number, description, status, transfer_mode, performed_by_id) VALUES (?, NULL, ?, ?, ?, ?, ?, ?, ?)";
            stmtTxn = conn.prepareStatement(insertTxnSql, Statement.RETURN_GENERATED_KEYS);
            stmtTxn.setLong(1, accountId);
            stmtTxn.setString(2, AppConstants.TRANSACTION_TYPE_TRANSFER);
            stmtTxn.setBigDecimal(3, repaymentAmount);
            stmtTxn.setString(4, "REPAY" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
            stmtTxn.setString(5, "Loan Repayment (Cheque #" + chequeNumber + ") - Loan ID: " + loanId);
            stmtTxn.setString(6, AppConstants.TRANSACTION_STATUS_COMPLETED);
            stmtTxn.setString(7, "cheque");
            stmtTxn.setObject(8, performedById, Types.BIGINT);
            stmtTxn.executeUpdate();

            long transactionId = 0;
            try (ResultSet generatedKeys = stmtTxn.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    transactionId = generatedKeys.getLong(1);
                } else {
                    throw new SQLException("Failed to retrieve transaction ID for repayment.");
                }
            }
            stmtTxn.close();

            // 6. Create repayment history
            String insertRepaySql = "INSERT INTO repayment (loan_id, customer_id, transaction_id, amount_paid, principal_component, interest_component) VALUES (?, ?, ?, ?, ?, ?)";
            stmtRepay = conn.prepareStatement(insertRepaySql);
            stmtRepay.setLong(1, loanId);
            stmtRepay.setLong(2, customerId);
            stmtRepay.setLong(3, transactionId);
            stmtRepay.setBigDecimal(4, repaymentAmount);
            stmtRepay.setBigDecimal(5, principalComponent);
            stmtRepay.setBigDecimal(6, interestComponent);
            stmtRepay.executeUpdate();
            stmtRepay.close();

            // 7. Reduce loans outstanding balance
            BigDecimal newRemainingBalance = remainingBalance.subtract(principalComponent);
            String updateLoanBalSql = "UPDATE loan SET remaining_balance = ? WHERE loan_id = ?";
            stmtLoanBal = conn.prepareStatement(updateLoanBalSql);
            stmtLoanBal.setBigDecimal(1, newRemainingBalance);
            stmtLoanBal.setLong(2, loanId);
            stmtLoanBal.executeUpdate();
            stmtLoanBal.close();

            if (newRemainingBalance.compareTo(BigDecimal.ZERO) <= 0) {
                String updateLoanStatSql = "UPDATE loan SET status = ? WHERE loan_id = ?";
                stmtLoanStat = conn.prepareStatement(updateLoanStatSql);
                stmtLoanStat.setString(1, AppConstants.LOAN_STATUS_CLOSED);
                stmtLoanStat.setLong(2, loanId);
                stmtLoanStat.executeUpdate();
                stmtLoanStat.close();
                logger.info("Loan closed via cheque payment - Loan ID: {}", loanId);
            }

            conn.commit();
            logger.info("Cheque repayment processed successfully - Loan: {}, Cheque: {}, Amount: {}", loanId, chequeNumber, repaymentAmount);
            return true;

        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { logger.error("Rollback failed", ex); }
            }
            logger.error("Error processing cheque repayment", e);
            throw new Exception("Failed to process cheque repayment: " + e.getMessage(), e);
        } finally {
            com.vgb.config.DatabaseConfig.closeResources(rsCheck, stmtCheck, conn);
            try { if (stmtDebit != null) stmtDebit.close(); } catch (Exception e) {}
            try { if (stmtTxn != null) stmtTxn.close(); } catch (Exception e) {}
            try { if (stmtRepay != null) stmtRepay.close(); } catch (Exception e) {}
            try { if (stmtLoanBal != null) stmtLoanBal.close(); } catch (Exception e) {}
            try { if (stmtLoanStat != null) stmtLoanStat.close(); } catch (Exception e) {}
        }
    }
}
