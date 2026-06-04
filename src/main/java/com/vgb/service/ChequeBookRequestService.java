package com.vgb.service;

import com.vgb.constants.AppConstants;
import com.vgb.dao.AccountDAOImpl;
import com.vgb.dao.ChequeBookRequestDAOImpl;
import com.vgb.dao.TransactionDAOImpl;
import com.vgb.model.Account;
import com.vgb.model.ChequeBookRequest;
import com.vgb.model.Transaction;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

public class ChequeBookRequestService {
    private static final Logger logger = LoggerFactory.getLogger(ChequeBookRequestService.class);
    
    private ChequeBookRequestDAOImpl chequeBookDAO = new ChequeBookRequestDAOImpl();
    private AccountDAOImpl accountDAO = new AccountDAOImpl();
    private TransactionDAOImpl transactionDAO = new TransactionDAOImpl();

    public List<ChequeBookRequest> getCustomerRequests(long customerId) throws Exception {
        try {
            return chequeBookDAO.getByCustomerId(customerId);
        } catch (SQLException e) {
            logger.error("Error loading customer cheque book requests", e);
            throw new Exception("Failed to load cheque book requests: " + e.getMessage());
        }
    }

    public List<ChequeBookRequest> getAllRequests() throws Exception {
        try {
            return chequeBookDAO.getAll();
        } catch (SQLException e) {
            logger.error("Error loading all cheque book requests", e);
            throw new Exception("Failed to load all cheque book requests: " + e.getMessage());
        }
    }

    public ChequeBookRequest getRequestById(long requestId) throws Exception {
        try {
            return chequeBookDAO.getById(requestId);
        } catch (SQLException e) {
            logger.error("Error loading cheque book request by ID", e);
            throw new Exception("Failed to load request details: " + e.getMessage());
        }
    }

    /**
     * Apply for a new Cheque Book. Charges fee based on leaf count:
     * 25 leaves = ₹100
     * 50 leaves = ₹150
     * 100 leaves = ₹250
     * Fees are debited immediately from account balance.
     */
    public ChequeBookRequest applyForChequeBook(long customerId, long accountId, int leavesCount) throws Exception {
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

        // 2. Set charges based on leaf count
        BigDecimal charges;
        if (leavesCount == 25) {
            charges = new BigDecimal("100.0000");
        } else if (leavesCount == 50) {
            charges = new BigDecimal("150.0000");
        } else if (leavesCount == 100) {
            charges = new BigDecimal("250.0000");
        } else {
            throw new Exception("Invalid leaves count request. Choose 25, 50, or 100 leaves.");
        }

        // 3. Verify sufficient balance to pay the fee
        if (account.getBalance().compareTo(charges) < 0) {
            throw new Exception("Insufficient balance to pay VGB Cheque Book Issuance fee of ₹" + charges.setScale(2) + ".");
        }

        ChequeBookRequest request = new ChequeBookRequest();
        request.setAccountId(accountId);
        request.setCustomerId(customerId);
        request.setLeavesCount(leavesCount);
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
            transaction.setDescription("VGB " + leavesCount + " Leaves Cheque Book Issuance Fee");
            transaction.setStatus(AppConstants.TRANSACTION_STATUS_COMPLETED);
            transactionDAO.create(transaction);

            // Save cheque book request
            if (chequeBookDAO.create(request)) {
                logger.info("Cheque Book requested successfully! Request ID: {}, Account ID: {}", request.getRequestId(), request.getAccountId());
                return request;
            }
            throw new Exception("Failed to save cheque book request to database.");
        } catch (SQLException e) {
            logger.error("SQL Error applying for cheque book", e);
            throw new Exception("Database error applying for cheque book: " + e.getMessage());
        }
    }

    /**
     * Approve Cheque Book Request. Sets has_cheque_book = 1 in account.
     */
    public boolean approveRequest(long requestId) throws Exception {
        try {
            ChequeBookRequest request = chequeBookDAO.getById(requestId);
            if (request == null) {
                throw new Exception("Request not found.");
            }
            if (!"pending".equalsIgnoreCase(request.getStatus())) {
                throw new Exception("Request is not in pending status.");
            }

            // Update status of cheque_book_request to 'approved'
            boolean statusUpdated = chequeBookDAO.updateStatus(requestId, "approved");
            if (statusUpdated) {
                // Toggles has_cheque_book = 1 in account
                accountDAO.updateChequeBookStatus(request.getAccountId(), true);
                logger.info("Cheque book request approved: ID {}", requestId);
                return true;
            }
            return false;
        } catch (SQLException e) {
            logger.error("Error approving cheque book request", e);
            throw new Exception("Failed to approve request: " + e.getMessage());
        }
    }

    /**
     * Reject Cheque Book Request. Refunds charges back to client account.
     */
    public boolean rejectRequest(long requestId) throws Exception {
        try {
            ChequeBookRequest request = chequeBookDAO.getById(requestId);
            if (request == null) {
                throw new Exception("Request not found.");
            }
            if (!"pending".equalsIgnoreCase(request.getStatus())) {
                throw new Exception("Request is not in pending status.");
            }

            // Reject the request in DB
            boolean statusUpdated = chequeBookDAO.updateStatus(requestId, "rejected");
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
                        transaction.setDescription("Refund: VGB Cheque Book Application Rejection (" + request.getLeavesCount() + " Leaves)");
                        transaction.setStatus(AppConstants.TRANSACTION_STATUS_COMPLETED);
                        transactionDAO.create(transaction);

                        // Mark charges paid as false in request
                        chequeBookDAO.updateChargesPaidStatus(requestId, false);
                        logger.info("Refunded cheque book fee of ₹{} to account ID {} due to rejection.", request.getCharges(), account.getAccountId());
                    }
                }
                return true;
            }
            return false;
        } catch (SQLException e) {
            logger.error("Error rejecting cheque book request", e);
            throw new Exception("Failed to reject request: " + e.getMessage());
        }
    }
}
