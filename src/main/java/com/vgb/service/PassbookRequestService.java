package com.vgb.service;

import com.vgb.constants.AppConstants;
import com.vgb.dao.AccountDAOImpl;
import com.vgb.dao.PassbookRequestDAOImpl;
import com.vgb.dao.TransactionDAOImpl;
import com.vgb.model.Account;
import com.vgb.model.PassbookRequest;
import com.vgb.model.Transaction;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

public class PassbookRequestService {
    private static final Logger logger = LoggerFactory.getLogger(PassbookRequestService.class);

    private PassbookRequestDAOImpl passbookDAO = new PassbookRequestDAOImpl();
    private AccountDAOImpl accountDAO = new AccountDAOImpl();
    private TransactionDAOImpl transactionDAO = new TransactionDAOImpl();

    public List<PassbookRequest> getCustomerRequests(long customerId) throws Exception {
        try {
            return passbookDAO.getByCustomerId(customerId);
        } catch (SQLException e) {
            logger.error("Error loading customer passbook requests", e);
            throw new Exception("Failed to load passbook requests: " + e.getMessage());
        }
    }

    public List<PassbookRequest> getAllRequests() throws Exception {
        try {
            return passbookDAO.getAll();
        } catch (SQLException e) {
            logger.error("Error loading all passbook requests", e);
            throw new Exception("Failed to load all passbook requests: " + e.getMessage());
        }
    }

    public PassbookRequest getRequestById(long requestId) throws Exception {
        try {
            return passbookDAO.getById(requestId);
        } catch (SQLException e) {
            logger.error("Error loading passbook request by ID", e);
            throw new Exception("Failed to load request details: " + e.getMessage());
        }
    }

    /**
     * Apply for a new/renew Passbook. Nominal processing fee: ₹100.00
     */
    public PassbookRequest applyForPassbook(long customerId, long accountId, String requestType) throws Exception {
        // 1. Verify account is active and owned by the customer
        Account account;
        try {
            account = accountDAO.getById(accountId);
            if (account == null) {
                throw new Exception("Selected account not found.");
            }
            if (account.getCustomerId() != customerId) {
                // Joint account signatory check
                boolean isSignatory = false;
                try {
                    List<Account> myAccounts = accountDAO.getByCustomerId(customerId);
                    for (Account myAcc : myAccounts) {
                        if (myAcc.getAccountId() == accountId) {
                            isSignatory = true;
                            break;
                        }
                    }
                } catch (Exception e) {}
                if (!isSignatory) {
                    throw new Exception("Unauthorized account selected.");
                }
            }
            if (!AppConstants.ACCOUNT_STATUS_ACTIVE.equalsIgnoreCase(account.getStatus())) {
                throw new Exception("Selected account is not active.");
            }
        } catch (SQLException e) {
            throw new Exception("Database error checking account details: " + e.getMessage());
        }

        // 2. Set charges to ₹100.00
        BigDecimal charges = new BigDecimal("100.0000");

        // 3. Verify sufficient balance to pay the fee
        if (account.getBalance().compareTo(charges) < 0) {
            throw new Exception("Insufficient balance to pay VGB Passbook " + requestType + " fee of ₹" + charges.setScale(2) + ".");
        }

        PassbookRequest request = new PassbookRequest();
        request.setAccountId(accountId);
        request.setCustomerId(customerId);
        request.setRequestType(requestType);
        request.setStatus("pending");
        request.setCharges(charges);
        request.setChargesPaid(true);

        try {
            // Deduct fee
            BigDecimal newBalance = account.getBalance().subtract(charges);
            accountDAO.updateBalance(accountId, newBalance);

            // Record transaction fee
            Transaction transaction = new Transaction();
            transaction.setFromAccountId(accountId);
            transaction.setTransactionType(AppConstants.TRANSACTION_TYPE_FEE);
            transaction.setAmount(charges);
            transaction.setReferenceNumber("TXN" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
            transaction.setDescription("VGB Passbook " + (requestType.equalsIgnoreCase("renew") ? "Renewal" : "Issuance") + " Fee");
            transaction.setStatus(AppConstants.TRANSACTION_STATUS_COMPLETED);
            transactionDAO.create(transaction);

            // Save passbook request
            if (passbookDAO.create(request)) {
                logger.info("Passbook requested successfully! Request ID: {}, Account ID: {}", request.getRequestId(), request.getAccountId());
                return request;
            }
            throw new Exception("Failed to save passbook request to database.");
        } catch (SQLException e) {
            logger.error("SQL Error applying for passbook", e);
            throw new Exception("Database error applying for passbook: " + e.getMessage());
        }
    }

    /**
     * Approve Passbook Request. Sets has_passbook = 1 in account.
     */
    public boolean approveRequest(long requestId) throws Exception {
        try {
            PassbookRequest request = passbookDAO.getById(requestId);
            if (request == null) {
                throw new Exception("Request not found.");
            }
            if (!"pending".equalsIgnoreCase(request.getStatus())) {
                throw new Exception("Request is not in pending status.");
            }

            // Update status of passbook_request to 'approved'
            boolean statusUpdated = passbookDAO.updateStatus(requestId, "approved");
            if (statusUpdated) {
                // Toggles has_passbook = 1 in account
                accountDAO.updatePassbookStatus(request.getAccountId(), true);
                logger.info("Passbook request approved: ID {}", requestId);
                return true;
            }
            return false;
        } catch (SQLException e) {
            logger.error("Error approving passbook request", e);
            throw new Exception("Failed to approve request: " + e.getMessage());
        }
    }

    /**
     * Reject Passbook Request. Refunds charges back to client account.
     */
    public boolean rejectRequest(long requestId) throws Exception {
        try {
            PassbookRequest request = passbookDAO.getById(requestId);
            if (request == null) {
                throw new Exception("Request not found.");
            }
            if (!"pending".equalsIgnoreCase(request.getStatus())) {
                throw new Exception("Request is not in pending status.");
            }

            // Reject the request in DB
            boolean statusUpdated = passbookDAO.updateStatus(requestId, "rejected");
            if (statusUpdated) {
                // Refund charges
                if (request.isChargesPaid() && request.getCharges().compareTo(BigDecimal.ZERO) > 0) {
                    Account account = accountDAO.getById(request.getAccountId());
                    if (account != null) {
                        BigDecimal newBalance = account.getBalance().add(request.getCharges());
                        accountDAO.updateBalance(account.getAccountId(), newBalance);

                        // Record refund transaction
                        Transaction transaction = new Transaction();
                        transaction.setToAccountId(account.getAccountId());
                        transaction.setTransactionType(AppConstants.TRANSACTION_TYPE_DEPOSIT);
                        transaction.setAmount(request.getCharges());
                        transaction.setReferenceNumber("TXN" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
                        transaction.setDescription("Refund: VGB Passbook Application Rejection (" + (request.getRequestType().equalsIgnoreCase("renew") ? "Renewal" : "New") + ")");
                        transaction.setStatus(AppConstants.TRANSACTION_STATUS_COMPLETED);
                        transactionDAO.create(transaction);

                        // Mark charges paid as false in request
                        passbookDAO.updateChargesPaidStatus(requestId, false);
                        logger.info("Refunded passbook fee of ₹{} to account ID {} due to rejection.", request.getCharges(), account.getAccountId());
                    }
                }
                return true;
            }
            return false;
        } catch (SQLException e) {
            logger.error("Error rejecting passbook request", e);
            throw new Exception("Failed to reject request: " + e.getMessage());
        }
    }
}
