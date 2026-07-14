package com.vgb.service;

import com.vgb.constants.AppConstants;
import com.vgb.dao.*;
import com.vgb.model.Account;
import com.vgb.model.Transaction;
import com.vgb.util.ValidatorUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

/**
 * AccountService: Handles account-related business logic
 */
public class AccountService {
    private static final Logger logger = LoggerFactory.getLogger(AccountService.class);
    private AccountDAOImpl accountDAO = new AccountDAOImpl();
    private TransactionDAOImpl transactionDAO = new TransactionDAOImpl();

    /**
     * Create new account
     */
    public Account createAccount(Account account) throws Exception {
        if (!ValidatorUtil.isValidAccountType(account.getAccountType())) {
            throw new Exception("Invalid account type");
        }

        if (!ValidatorUtil.isValidAccountNumber(account.getAccountNumber())) {
            throw new Exception("Invalid account number");
        }

        if (accountDAO.existsByAccountNumber(account.getAccountNumber())) {
            throw new Exception("Account number already exists");
        }

        try {
            account.setStatus(AppConstants.ACCOUNT_STATUS_ACTIVE);
            account.setBalance(BigDecimal.ZERO);
            
            if (accountDAO.create(account)) {
                logger.info("Account created successfully for customer: {}", account.getCustomerId());
                return account;
            }
            throw new Exception("Failed to create account");

        } catch (Exception e) {
            logger.error("Error creating account", e);
            throw e;
        }
    }

    /**
     * Get account by ID
     */
    public Account getAccountById(long accountId) throws Exception {
        try {
            return accountDAO.getById(accountId);
        } catch (Exception e) {
            logger.error("Error fetching account", e);
            throw new Exception("Failed to fetch account", e);
        }
    }

    /**
     * Get all accounts for customer
     */
    public List<Account> getCustomerAccounts(long customerId) throws Exception {
        try {
            return accountDAO.getByCustomerId(customerId);
        } catch (Exception e) {
            logger.error("Error fetching customer accounts", e);
            throw new Exception("Failed to fetch accounts", e);
        }
    }

    /**
     * Returns all accounts for the specified customer.
     * Backward-compatible alias for existing modules such as Auto Pay.
     */
    public List<Account> getAccountsByCustomerId(long customerId) throws Exception {
        return getCustomerAccounts(customerId);
    }

    /**
     * Deposit money into account (legacy backward-compatible method)
     */
    public boolean deposit(long accountId, BigDecimal amount, String description) throws Exception {
        try {
            Account account = getAccountById(accountId);
            long customerId = account != null ? account.getCustomerId() : 0L;
            return deposit(accountId, amount, description, customerId);
        } catch (Exception e) {
            throw new Exception("Deposit failed: " + e.getMessage(), e);
        }
    }

    /**
     * Deposit money into account (transactional with performedById)
     */
    public boolean deposit(long accountId, BigDecimal amount, String description, Long performedById) throws Exception {
        if (!ValidatorUtil.isValidAmount(amount, new BigDecimal("100"))) {
            throw new Exception("Deposit amount must be at least 100");
        }

        Connection conn = null;
        try {
            conn = com.vgb.config.DatabaseConfig.getInstance().getConnection();
            conn.setAutoCommit(false); // Begin Transaction!

            Account account = accountDAO.getById(conn, accountId);
            if (account == null) {
                throw new Exception("Account not found");
            }

            // Update account balance
            BigDecimal newBalance = account.getBalance().add(amount);
            accountDAO.updateBalance(conn, accountId, newBalance);

            // Record transaction
            Transaction transaction = new Transaction();
            transaction.setToAccountId(accountId);
            transaction.setTransactionType(AppConstants.TRANSACTION_TYPE_DEPOSIT);
            transaction.setAmount(amount);
            transaction.setReferenceNumber("TXN" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
            transaction.setDescription(description);
            transaction.setStatus(AppConstants.TRANSACTION_STATUS_COMPLETED);

            // Audit and routing fields
            transaction.setTransferMode("cash");
            transaction.setReceiverAccountNumber(account.getAccountNumber());
            transaction.setPerformedById(performedById);

            transactionDAO.create(conn, transaction);

            conn.commit(); // Commit Transaction!
            logger.info("Deposit successful - Account: {}, Amount: {}", accountId, amount);
            return true;

        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { logger.error("Rollback failed", ex); }
            }
            logger.error("Error processing deposit", e);
            throw new Exception("Deposit failed: " + e.getMessage(), e);
        } finally {
            com.vgb.config.DatabaseConfig.closeConnection(conn);
        }
    }

    /**
     * Withdraw money from account (legacy backward-compatible method)
     */
    public boolean withdraw(long accountId, BigDecimal amount, String description) throws Exception {
        try {
            Account account = getAccountById(accountId);
            long customerId = account != null ? account.getCustomerId() : 0L;
            return withdraw(accountId, amount, description, customerId);
        } catch (Exception e) {
            throw new Exception("Withdrawal failed: " + e.getMessage(), e);
        }
    }

    /**
     * Withdraw money from account (transactional with performedById)
     */
    public boolean withdraw(long accountId, BigDecimal amount, String description, Long performedById) throws Exception {
        if (!ValidatorUtil.isValidAmount(amount, new BigDecimal("100"))) {
            throw new Exception("Withdrawal amount must be at least 100");
        }

        Connection conn = null;
        try {
            conn = com.vgb.config.DatabaseConfig.getInstance().getConnection();
            conn.setAutoCommit(false); // Begin Transaction!

            Account account = accountDAO.getById(conn, accountId);
            if (account == null) {
                throw new Exception("Account not found");
            }

            if (account.getBalance().compareTo(amount) < 0) {
                throw new Exception("Insufficient balance");
            }

            // Update account balance
            BigDecimal newBalance = account.getBalance().subtract(amount);
            accountDAO.updateBalance(conn, accountId, newBalance);

            // Record transaction
            Transaction transaction = new Transaction();
            transaction.setFromAccountId(accountId);
            transaction.setTransactionType(AppConstants.TRANSACTION_TYPE_WITHDRAWAL);
            transaction.setAmount(amount);
            transaction.setReferenceNumber("TXN" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
            transaction.setDescription(description);
            transaction.setStatus(AppConstants.TRANSACTION_STATUS_COMPLETED);

            // Audit and routing fields
            transaction.setTransferMode("cash");
            transaction.setSenderAccountNumber(account.getAccountNumber());
            transaction.setPerformedById(performedById);

            transactionDAO.create(conn, transaction);

            conn.commit(); // Commit Transaction!
            logger.info("Withdrawal successful - Account: {}, Amount: {}", accountId, amount);
            return true;

        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { logger.error("Rollback failed", ex); }
            }
            logger.error("Error processing withdrawal", e);
            throw new Exception("Withdrawal failed: " + e.getMessage(), e);
        } finally {
            com.vgb.config.DatabaseConfig.closeConnection(conn);
        }
    }

    /**
     * Transfer money between accounts (legacy backward-compatible method)
     */
    public boolean transfer(long fromAccountId, long toAccountId, BigDecimal amount, String description) throws Exception {
        try {
            Account account = getAccountById(fromAccountId);
            long customerId = account != null ? account.getCustomerId() : 0L;
            return transfer(fromAccountId, toAccountId, amount, description, customerId);
        } catch (Exception e) {
            throw new Exception("Transfer failed: " + e.getMessage(), e);
        }
    }

    /**
     * Transfer money between accounts (transactional with performedById)
     */
    public boolean transfer(long fromAccountId, long toAccountId, BigDecimal amount, String description, Long performedById) throws Exception {
        if (!ValidatorUtil.isValidAmount(amount, AppConstants.MIN_TRANSFER_AMOUNT != null ? AppConstants.MIN_TRANSFER_AMOUNT : BigDecimal.ZERO)) {
            throw new Exception("Transfer amount is invalid");
        }

        Connection conn = null;
        try {
            conn = com.vgb.config.DatabaseConfig.getInstance().getConnection();
            conn.setAutoCommit(false); // Begin Transaction!

            Account fromAccount = accountDAO.getById(conn, fromAccountId);
            Account toAccount = accountDAO.getById(conn, toAccountId);

            if (fromAccount == null || toAccount == null) {
                throw new Exception("One or both accounts not found");
            }

            if (fromAccount.getBalance().compareTo(amount) < 0) {
                throw new Exception("Insufficient balance");
            }

            if (!fromAccount.getStatus().equalsIgnoreCase(AppConstants.ACCOUNT_STATUS_ACTIVE) ||
                !toAccount.getStatus().equalsIgnoreCase(AppConstants.ACCOUNT_STATUS_ACTIVE)) {
                throw new Exception("One or both accounts are not active");
            }

            // Update balances
            BigDecimal fromNewBalance = fromAccount.getBalance().subtract(amount);
            BigDecimal toNewBalance = toAccount.getBalance().add(amount);
            
            accountDAO.updateBalance(conn, fromAccountId, fromNewBalance);
            accountDAO.updateBalance(conn, toAccountId, toNewBalance);

            // Record transaction
            Transaction transaction = new Transaction();
            transaction.setFromAccountId(fromAccountId);
            transaction.setToAccountId(toAccountId);
            transaction.setTransactionType(AppConstants.TRANSACTION_TYPE_TRANSFER);
            transaction.setAmount(amount);
            transaction.setReferenceNumber("TXN" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
            transaction.setDescription(description);
            transaction.setStatus(AppConstants.TRANSACTION_STATUS_COMPLETED);

            // Audit and routing fields
            transaction.setTransferMode("internal");
            transaction.setSenderAccountNumber(fromAccount.getAccountNumber());
            transaction.setReceiverAccountNumber(toAccount.getAccountNumber());
            transaction.setPerformedById(performedById);

            transactionDAO.create(conn, transaction);

            conn.commit(); // Commit Transaction!
            logger.info("Transfer successful - From: {}, To: {}, Amount: {}", fromAccountId, toAccountId, amount);
            return true;

        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { logger.error("Rollback failed", ex); }
            }
            logger.error("Error processing transfer", e);
            throw new Exception("Transfer failed: " + e.getMessage(), e);
        } finally {
            com.vgb.config.DatabaseConfig.closeConnection(conn);
        }
    }

    /**
     * Get account balance
     */
    public BigDecimal getAccountBalance(long accountId) throws Exception {
        try {
            Account account = accountDAO.getById(accountId);
            if (account == null) {
                throw new Exception("Account not found");
            }
            return account.getBalance();
        } catch (Exception e) {
            logger.error("Error fetching account balance", e);
            throw new Exception("Failed to fetch balance", e);
        }
    }

    /**
     * Get account transactions
     */
    public List<Transaction> getAccountTransactions(long accountId) throws Exception {
        try {
            return transactionDAO.getByAccountId(accountId);
        } catch (Exception e) {
            logger.error("Error fetching account transactions", e);
            throw new Exception("Failed to fetch transactions", e);
        }
    }

    /**
     * Update account status
     */
    public boolean updateAccountStatus(long accountId, String status) throws Exception {
        if (!ValidatorUtil.isValidAccountStatus(status)) {
            throw new Exception("Invalid account status");
        }

        try {
            return accountDAO.updateStatus(accountId, status);
        } catch (Exception e) {
            logger.error("Error updating account status", e);
            throw new Exception("Failed to update account status", e);
        }
    }

    /**
     * Update account details (type, IFSC code, status)
     */
    public boolean updateAccount(long accountId, String accountType, String ifscCode, String status) throws Exception {
        if (!ValidatorUtil.isValidAccountType(accountType)) {
            throw new Exception("Invalid account type: " + accountType);
        }
        if (!ValidatorUtil.isValidAccountStatus(status)) {
            throw new Exception("Invalid account status: " + status);
        }
        if (ifscCode == null || ifscCode.trim().length() != com.vgb.constants.AppConstants.IFSC_CODE_LENGTH) {
            throw new Exception("Invalid IFSC code length. Must be " + com.vgb.constants.AppConstants.IFSC_CODE_LENGTH + " characters.");
        }

        try {
            Account account = accountDAO.getById(accountId);
            if (account == null) {
                throw new Exception("Account not found");
            }
            
            account.setAccountType(accountType);
            account.setIfscCode(ifscCode);
            account.setStatus(status);
            
            return accountDAO.update(account);
        } catch (Exception e) {
            logger.error("Error updating account details", e);
            throw new Exception("Failed to update account details", e);
        }
    }

    /**
     * Get all accounts
     */
    public List<Account> getAllAccounts() throws Exception {
        try {
            return accountDAO.getAll();
        } catch (Exception e) {
            logger.error("Error fetching all accounts", e);
            throw new Exception("Failed to fetch all accounts", e);
        }
    }

    /**
     * Get accounts by status
     */
    public List<Account> getAccountsByStatus(String status) throws Exception {
        try {
            List<Account> allAccounts = accountDAO.getAll();
            List<Account> filtered = new java.util.ArrayList<>();
            for (Account acc : allAccounts) {
                if (acc.getStatus() != null && acc.getStatus().equalsIgnoreCase(status)) {
                    filtered.add(acc);
                }
            }
            return filtered;
        } catch (Exception e) {
            logger.error("Error fetching accounts by status", e);
            throw new Exception("Failed to fetch accounts by status", e);
        }
    }

    /**
     * Get list of saved beneficiaries for a customer
     */
    public List<Account> getSavedBeneficiaries(long customerId) throws Exception {
        try {
            return accountDAO.getSavedBeneficiaries(customerId);
        } catch (Exception e) {
            logger.error("Error in service fetching saved beneficiaries", e);
            throw new Exception("Failed to fetch saved beneficiaries", e);
        }
    }

    /**
     * Save a verified beneficiary for a customer
     */
    public boolean addBeneficiary(long customerId, long beneficiaryAccountId) throws Exception {
        try {
            return accountDAO.addBeneficiary(customerId, beneficiaryAccountId);
        } catch (Exception e) {
            logger.error("Error in service adding beneficiary", e);
            throw new Exception("Failed to save beneficiary", e);
        }
    }

    /**
     * Save a verified beneficiary (local VGB or external bank) with details for a customer
     */
    public boolean addBeneficiary(long customerId, String beneficiaryType, Long beneficiaryAccountId, String accountNumber, String ifscCode, String holderName) throws Exception {
        try {
            return accountDAO.addBeneficiary(customerId, beneficiaryType, beneficiaryAccountId, accountNumber, ifscCode, holderName);
        } catch (Exception e) {
            logger.error("Error in service adding beneficiary", e);
            throw new Exception("Failed to save beneficiary", e);
        }
    }

    /**
     * Retrieve details of an external other-bank beneficiary by beneficiary ID
     */
    public String[] getExternalBeneficiaryDetails(long beneficiaryId) throws Exception {
        try {
            return accountDAO.getExternalBeneficiaryDetails(beneficiaryId);
        } catch (Exception e) {
            logger.error("Error in service fetching external beneficiary details", e);
            throw new Exception("Failed to fetch external beneficiary details", e);
        }
    }

    /**
     * Transfer money to an external other-bank account (legacy backward-compatible method)
     */
    public boolean externalTransfer(long fromAccountId, String toAccountNumber, String toIfscCode, String toHolderName, BigDecimal amount, String description) throws Exception {
        try {
            Account account = getAccountById(fromAccountId);
            long customerId = account != null ? account.getCustomerId() : 0L;
            return externalTransfer(fromAccountId, toAccountNumber, toIfscCode, toHolderName, "Other Bank", "Unknown Branch", amount, description, customerId);
        } catch (Exception e) {
            throw new Exception("External transfer failed: " + e.getMessage(), e);
        }
    }

    /**
     * Transfer money to an external other-bank account (transactional with performedById)
     */
    public boolean externalTransfer(long fromAccountId, String toAccountNumber, String toIfscCode, String toHolderName, String toBankName, String toBranchName, BigDecimal amount, String description, Long performedById) throws Exception {
        if (!ValidatorUtil.isValidAmount(amount, AppConstants.MIN_TRANSFER_AMOUNT != null ? AppConstants.MIN_TRANSFER_AMOUNT : BigDecimal.ZERO)) {
            throw new Exception("Transfer amount is invalid");
        }

        Connection conn = null;
        try {
            conn = com.vgb.config.DatabaseConfig.getInstance().getConnection();
            conn.setAutoCommit(false); // Begin Transaction!

            Account fromAccount = accountDAO.getById(conn, fromAccountId);

            if (fromAccount == null) {
                throw new Exception("Source account not found");
            }

            if (fromAccount.getBalance().compareTo(amount) < 0) {
                throw new Exception("Insufficient balance");
            }

            if (!fromAccount.getStatus().equalsIgnoreCase(AppConstants.ACCOUNT_STATUS_ACTIVE)) {
                throw new Exception("Source account is not active");
            }

            // Update source balance
            BigDecimal fromNewBalance = fromAccount.getBalance().subtract(amount);
            accountDAO.updateBalance(conn, fromAccountId, fromNewBalance);

            // Record transaction (toAccountId = null represents external recipient)
            Transaction transaction = new Transaction();
            transaction.setFromAccountId(fromAccountId);
            transaction.setToAccountId(null);
            transaction.setTransactionType(AppConstants.TRANSACTION_TYPE_TRANSFER);
            transaction.setAmount(amount);
            transaction.setReferenceNumber("TXN" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
            transaction.setDescription(description + " (To: " + toHolderName + ", A/C: " + toAccountNumber + ", IFSC: " + toIfscCode + ")");
            transaction.setStatus(AppConstants.TRANSACTION_STATUS_COMPLETED);

            // Audit and routing fields
            transaction.setTransferMode("external");
            transaction.setSenderAccountNumber(fromAccount.getAccountNumber());
            transaction.setReceiverAccountNumber(toAccountNumber);
            transaction.setBeneficiaryName(toHolderName);
            transaction.setBeneficiaryIfsc(toIfscCode);
            transaction.setBeneficiaryBank(toBankName);
            transaction.setBeneficiaryBranch(toBranchName);
            transaction.setPerformedById(performedById);

            transactionDAO.create(conn, transaction);

            conn.commit(); // Commit Transaction!
            logger.info("External transfer successful - From: {}, To External A/C: {}, Amount: {}", fromAccountId, toAccountNumber, amount);
            return true;

        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { logger.error("Rollback failed", ex); }
            }
            logger.error("Error processing external transfer", e);
            throw new Exception("External transfer failed: " + e.getMessage(), e);
        } finally {
            com.vgb.config.DatabaseConfig.closeConnection(conn);
        }
    }

    /**
     * Withdraw money from account using a checkbook and check number
     */
    public boolean withdrawWithCheque(long accountId, String chequeBookNumber, String chequeNumber, BigDecimal amount, String description, Long performedById) throws Exception {
        if (!ValidatorUtil.isValidAmount(amount, new BigDecimal("100"))) {
            throw new Exception("Withdrawal amount must be at least 100");
        }

        Connection conn = null;
        try {
            conn = com.vgb.config.DatabaseConfig.getInstance().getConnection();
            conn.setAutoCommit(false); // Begin Transaction!

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

            // 2. Account verification and update
            Account account = accountDAO.getById(conn, accountId);
            if (account == null) {
                throw new Exception("Account not found.");
            }
            if (!AppConstants.ACCOUNT_STATUS_ACTIVE.equalsIgnoreCase(account.getStatus())) {
                throw new Exception("Account is not active.");
            }
            if (account.getBalance().compareTo(amount) < 0) {
                throw new Exception("Insufficient balance.");
            }

            BigDecimal newBalance = account.getBalance().subtract(amount);
            accountDAO.updateBalance(conn, accountId, newBalance);

            // Record transaction
            Transaction transaction = new Transaction();
            transaction.setFromAccountId(accountId);
            transaction.setTransactionType(AppConstants.TRANSACTION_TYPE_WITHDRAWAL);
            transaction.setAmount(amount);
            transaction.setReferenceNumber("TXN" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
            transaction.setDescription(description + " (Cheque #" + chequeNumber + ")");
            transaction.setStatus(AppConstants.TRANSACTION_STATUS_COMPLETED);
            transaction.setTransferMode("cheque");
            transaction.setSenderAccountNumber(account.getAccountNumber());
            transaction.setPerformedById(performedById);

            transactionDAO.create(conn, transaction);

            conn.commit();
            logger.info("Cheque withdrawal successful - Account: {}, Cheque: {}, Amount: {}", accountId, chequeNumber, amount);
            return true;
        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { logger.error("Rollback failed", ex); }
            }
            logger.error("Error processing cheque withdrawal", e);
            throw new Exception("Cheque withdrawal failed: " + e.getMessage(), e);
        } finally {
            com.vgb.config.DatabaseConfig.closeConnection(conn);
        }
    }

    /**
     * Transfer money between internal accounts using a checkbook and check number
     */
    public boolean transferWithCheque(long fromAccountId, long toAccountId, String chequeBookNumber, String chequeNumber, BigDecimal amount, String description, Long performedById) throws Exception {
        if (!ValidatorUtil.isValidAmount(amount, AppConstants.MIN_TRANSFER_AMOUNT != null ? AppConstants.MIN_TRANSFER_AMOUNT : BigDecimal.ZERO)) {
            throw new Exception("Transfer amount is invalid");
        }

        Connection conn = null;
        try {
            conn = com.vgb.config.DatabaseConfig.getInstance().getConnection();
            conn.setAutoCommit(false); // Begin Transaction!

            // 1. Verify and update cheque leaf status
            com.vgb.dao.ChequeBookDAOImpl cbDAO = new com.vgb.dao.ChequeBookDAOImpl();
            com.vgb.model.ChequeLeaf leaf = cbDAO.getChequeLeaf(chequeBookNumber, chequeNumber);
            if (leaf == null) {
                throw new Exception("Cheque leaf #" + chequeNumber + " not found or does not belong to Cheque Book " + chequeBookNumber + ".");
            }
            if (!"unused".equalsIgnoreCase(leaf.getStatus())) {
                throw new Exception("Cheque leaf #" + chequeNumber + " is already " + leaf.getStatus() + ".");
            }

            List<com.vgb.model.ChequeBook> activeBooks = cbDAO.getActiveChequeBooksByAccount(fromAccountId);
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
                throw new Exception("Cheque Book " + chequeBookNumber + " does not belong to the selected source account.");
            }

            // Mark cheque leaf as used
            cbDAO.updateChequeLeafStatus(conn, leaf.getChequebookId(), chequeNumber, "used");

            // 2. Perform transfer operation
            Account fromAccount = accountDAO.getById(conn, fromAccountId);
            Account toAccount = accountDAO.getById(conn, toAccountId);

            if (fromAccount == null || toAccount == null) {
                throw new Exception("One or both accounts not found.");
            }
            if (!fromAccount.getStatus().equalsIgnoreCase(AppConstants.ACCOUNT_STATUS_ACTIVE) ||
                !toAccount.getStatus().equalsIgnoreCase(AppConstants.ACCOUNT_STATUS_ACTIVE)) {
                throw new Exception("One or both accounts are not active.");
            }
            if (fromAccount.getBalance().compareTo(amount) < 0) {
                throw new Exception("Insufficient balance.");
            }

            BigDecimal fromNewBalance = fromAccount.getBalance().subtract(amount);
            BigDecimal toNewBalance = toAccount.getBalance().add(amount);

            accountDAO.updateBalance(conn, fromAccountId, fromNewBalance);
            accountDAO.updateBalance(conn, toAccountId, toNewBalance);

            // Record transaction
            Transaction transaction = new Transaction();
            transaction.setFromAccountId(fromAccountId);
            transaction.setToAccountId(toAccountId);
            transaction.setTransactionType(AppConstants.TRANSACTION_TYPE_TRANSFER);
            transaction.setAmount(amount);
            transaction.setReferenceNumber("TXN" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
            transaction.setDescription(description + " (Cheque #" + chequeNumber + ")");
            transaction.setStatus(AppConstants.TRANSACTION_STATUS_COMPLETED);
            transaction.setTransferMode("cheque");
            transaction.setSenderAccountNumber(fromAccount.getAccountNumber());
            transaction.setReceiverAccountNumber(toAccount.getAccountNumber());
            transaction.setPerformedById(performedById);

            transactionDAO.create(conn, transaction);

            conn.commit();
            logger.info("Cheque transfer successful - From: {}, To: {}, Cheque: {}, Amount: {}", fromAccountId, toAccountId, chequeNumber, amount);
            return true;
        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { logger.error("Rollback failed", ex); }
            }
            logger.error("Error processing cheque transfer", e);
            throw new Exception("Cheque transfer failed: " + e.getMessage(), e);
        } finally {
            com.vgb.config.DatabaseConfig.closeConnection(conn);
        }
    }

    /**
     * Transfer money to an external bank using a checkbook and check number
     */
    public boolean externalTransferWithCheque(long fromAccountId, String toAccountNumber, String toIfscCode, String toHolderName, String toBankName, String toBranchName, String chequeBookNumber, String chequeNumber, BigDecimal amount, String description, Long performedById) throws Exception {
        if (!ValidatorUtil.isValidAmount(amount, AppConstants.MIN_TRANSFER_AMOUNT != null ? AppConstants.MIN_TRANSFER_AMOUNT : BigDecimal.ZERO)) {
            throw new Exception("Transfer amount is invalid");
        }

        Connection conn = null;
        try {
            conn = com.vgb.config.DatabaseConfig.getInstance().getConnection();
            conn.setAutoCommit(false); // Begin Transaction!

            // 1. Verify and update cheque leaf status
            com.vgb.dao.ChequeBookDAOImpl cbDAO = new com.vgb.dao.ChequeBookDAOImpl();
            com.vgb.model.ChequeLeaf leaf = cbDAO.getChequeLeaf(chequeBookNumber, chequeNumber);
            if (leaf == null) {
                throw new Exception("Cheque leaf #" + chequeNumber + " not found or does not belong to Cheque Book " + chequeBookNumber + ".");
            }
            if (!"unused".equalsIgnoreCase(leaf.getStatus())) {
                throw new Exception("Cheque leaf #" + chequeNumber + " is already " + leaf.getStatus() + ".");
            }

            List<com.vgb.model.ChequeBook> activeBooks = cbDAO.getActiveChequeBooksByAccount(fromAccountId);
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
                throw new Exception("Cheque Book " + chequeBookNumber + " does not belong to the selected source account.");
            }

            // Mark cheque leaf as used
            cbDAO.updateChequeLeafStatus(conn, leaf.getChequebookId(), chequeNumber, "used");

            // 2. Perform external transfer operation
            Account fromAccount = accountDAO.getById(conn, fromAccountId);
            if (fromAccount == null) {
                throw new Exception("Source account not found.");
            }
            if (!fromAccount.getStatus().equalsIgnoreCase(AppConstants.ACCOUNT_STATUS_ACTIVE)) {
                throw new Exception("Source account is not active.");
            }
            if (fromAccount.getBalance().compareTo(amount) < 0) {
                throw new Exception("Insufficient balance.");
            }

            BigDecimal fromNewBalance = fromAccount.getBalance().subtract(amount);
            accountDAO.updateBalance(conn, fromAccountId, fromNewBalance);

            // Record transaction
            Transaction transaction = new Transaction();
            transaction.setFromAccountId(fromAccountId);
            transaction.setToAccountId(null);
            transaction.setTransactionType(AppConstants.TRANSACTION_TYPE_TRANSFER);
            transaction.setAmount(amount);
            transaction.setReferenceNumber("TXN" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
            transaction.setDescription(description + " (Cheque #" + chequeNumber + ", To: " + toHolderName + ", A/C: " + toAccountNumber + ", IFSC: " + toIfscCode + ")");
            transaction.setStatus(AppConstants.TRANSACTION_STATUS_COMPLETED);
            transaction.setTransferMode("cheque");
            transaction.setSenderAccountNumber(fromAccount.getAccountNumber());
            transaction.setReceiverAccountNumber(toAccountNumber);
            transaction.setBeneficiaryName(toHolderName);
            transaction.setBeneficiaryIfsc(toIfscCode);
            transaction.setBeneficiaryBank(toBankName);
            transaction.setBeneficiaryBranch(toBranchName);
            transaction.setPerformedById(performedById);

            transactionDAO.create(conn, transaction);

            conn.commit();
            logger.info("Cheque external transfer successful - From: {}, To External A/C: {}, Cheque: {}, Amount: {}", fromAccountId, toAccountNumber, chequeNumber, amount);
            return true;
        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { logger.error("Rollback failed", ex); }
            }
            logger.error("Error processing cheque external transfer", e);
            throw new Exception("Cheque external transfer failed: " + e.getMessage(), e);
        } finally {
            com.vgb.config.DatabaseConfig.closeConnection(conn);
        }
    }

    /**
     * Fetch account details by account number
     */
    public Account getAccountByNumber(String accountNumber) throws Exception {
        try {
            return accountDAO.getByAccountNumber(accountNumber);
        } catch (Exception e) {
            logger.error("Error in service fetching account by number", e);
            throw new Exception("Failed to fetch account details", e);
        }
    }

    /**
     * Delete account and associated customer completely (Admin only)
     */
    public boolean deleteAccount(long accountId) throws Exception {
        try {
            return accountDAO.delete(accountId);
        } catch (Exception e) {
            logger.error("Error in service deleting account: {}", accountId, e);
            throw new Exception("Failed to delete account: " + e.getMessage(), e);
        }
    }

    /**
     * Deposit money via external cheque
     */
    public boolean chequeDeposit(long accountId, String bankName, String chequeNumber, BigDecimal amount, String description, Long performedById) throws Exception {
        if (!ValidatorUtil.isValidAmount(amount, new java.math.BigDecimal("100"))) {
            throw new Exception("Deposit amount must be at least 100");
        }

        Connection conn = null;
        try {
            conn = com.vgb.config.DatabaseConfig.getInstance().getConnection();
            conn.setAutoCommit(false);

            Account account = accountDAO.getById(conn, accountId);
            if (account == null) {
                throw new Exception("Account not found");
            }

            // Update account balance
            BigDecimal newBalance = account.getBalance().add(amount);
            accountDAO.updateBalance(conn, accountId, newBalance);

            // Record transaction
            Transaction transaction = new Transaction();
            transaction.setToAccountId(accountId);
            transaction.setTransactionType(AppConstants.TRANSACTION_TYPE_DEPOSIT);
            transaction.setAmount(amount);
            transaction.setReferenceNumber("TXN" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
            transaction.setDescription(description + " (Cheque #" + chequeNumber + " - " + bankName + ")");
            transaction.setStatus(AppConstants.TRANSACTION_STATUS_COMPLETED);

            // Audit and routing fields
            transaction.setTransferMode("cheque");
            transaction.setReceiverAccountNumber(account.getAccountNumber());
            transaction.setBeneficiaryBank(bankName);
            transaction.setPerformedById(performedById);

            transactionDAO.create(conn, transaction);

            conn.commit();
            logger.info("Cheque deposit successful - Account: {}, Amount: {}, Cheque: {}", accountId, amount, chequeNumber);
            return true;
        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { logger.error("Rollback failed", ex); }
            }
            logger.error("Error processing cheque deposit", e);
            throw new Exception("Cheque deposit failed: " + e.getMessage(), e);
        } finally {
            com.vgb.config.DatabaseConfig.closeConnection(conn);
        }
    }
}
