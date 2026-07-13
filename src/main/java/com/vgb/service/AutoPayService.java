package com.vgb.service;

import com.vgb.config.DatabaseConfig;
import com.vgb.dao.AutoPayDAO;
import com.vgb.dao.NotificationDAO;
import com.vgb.dao.AccountDAOImpl;
import com.vgb.dao.CardDAOImpl;
import com.vgb.dao.LoanDAO;
import com.vgb.dao.LoanDAOImpl;
import com.vgb.model.AutoPayInstruction;
import com.vgb.model.AutoPayHistory;
import com.vgb.model.Notification;
import com.vgb.model.Account;
import com.vgb.model.Card;
import com.vgb.model.Loan;
import com.vgb.model.CreditCardRepayment;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Connection;
import java.sql.Date;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;
import java.util.UUID;

public class AutoPayService {
    private static final Logger logger = LoggerFactory.getLogger(AutoPayService.class);

    private final AutoPayDAO autoPayDAO = new AutoPayDAO();
    private final NotificationDAO notificationDAO = new NotificationDAO();
    private final CardService cardService = new CardService();
    private final LoanService loanService = new LoanService();
    private final AccountDAOImpl accountDAO = new AccountDAOImpl();
    private final CardDAOImpl cardDAO = new CardDAOImpl();
    private final LoanDAO loanDAO = new LoanDAOImpl();

    public boolean createInstruction(AutoPayInstruction instruction) throws Exception {
        // Validate dates
        if (instruction.getNextPaymentDate() == null) {
            throw new Exception("Start/Next Payment date is required.");
        }
        
        // Check if duplicate instruction exists
        List<AutoPayInstruction> existing = autoPayDAO.getInstructionsByCustomerId(instruction.getCustomerId());
        for (AutoPayInstruction ins : existing) {
            if ("active".equalsIgnoreCase(ins.getStatus()) || "paused".equalsIgnoreCase(ins.getStatus())) {
                if ("credit_card".equalsIgnoreCase(instruction.getTargetType()) && "credit_card".equalsIgnoreCase(ins.getTargetType())) {
                    if (instruction.getCardId().equals(ins.getCardId())) {
                        throw new Exception("An active Auto Pay instruction already exists for this Credit Card.");
                    }
                }
                if ("loan".equalsIgnoreCase(instruction.getTargetType()) && "loan".equalsIgnoreCase(ins.getTargetType())) {
                    if (instruction.getLoanId().equals(ins.getLoanId())) {
                        throw new Exception("An active Auto Pay instruction already exists for this Loan.");
                    }
                }
            }
        }

        // Validate customer account ownership
        Account sourceAcc = accountDAO.getById(instruction.getSourceAccountId());
        if (sourceAcc == null || sourceAcc.getCustomerId() != instruction.getCustomerId()) {
            throw new Exception("Invalid source account selection.");
        }
        if (!"active".equalsIgnoreCase(sourceAcc.getStatus())) {
            throw new Exception("Source account must be active.");
        }

        // Set default frequency
        instruction.setPaymentFrequency("monthly");
        instruction.setStatus("active");

        boolean created = autoPayDAO.createInstruction(instruction);
        if (created) {
            // Create notification
            Notification notif = new Notification();
            notif.setCustomerId(instruction.getCustomerId());
            notif.setType("inapp");
            notif.setTitle("Auto Pay Configured");
            notif.setMessage("Auto Pay instruction has been successfully created for your " + 
                  ("credit_card".equals(instruction.getTargetType()) ? "Credit Card" : "Loan") + 
                  ". Next billing run: " + instruction.getNextPaymentDate());
            notificationDAO.create(notif);
        }
        return created;
    }

    public boolean updateStatus(long customerId, long autoPayId, String status) throws Exception {
        AutoPayInstruction ins = autoPayDAO.getInstructionById(autoPayId);
        if (ins == null) {
            throw new Exception("Auto Pay instruction not found.");
        }
        if (ins.getCustomerId() != customerId) {
            throw new Exception("Unauthorized request.");
        }
        if (!"active".equals(status) && !"paused".equals(status) && !"disabled".equals(status)) {
            throw new Exception("Invalid status selection.");
        }
        
        boolean updated = autoPayDAO.updateInstructionStatus(autoPayId, status);
        if (updated) {
            Notification notif = new Notification();
            notif.setCustomerId(customerId);
            notif.setType("inapp");
            notif.setTitle("Auto Pay Status Changed");
            notif.setMessage("Auto Pay instruction status has been updated to: " + status.toUpperCase());
            notificationDAO.create(notif);
        }
        return updated;
    }

    public boolean cancelInstruction(long customerId, long autoPayId) throws Exception {
        AutoPayInstruction ins = autoPayDAO.getInstructionById(autoPayId);
        if (ins == null) {
            throw new Exception("Auto Pay instruction not found.");
        }
        if (ins.getCustomerId() != customerId) {
            throw new Exception("Unauthorized request.");
        }
        
        boolean deleted = autoPayDAO.deleteInstruction(autoPayId);
        if (deleted) {
            Notification notif = new Notification();
            notif.setCustomerId(customerId);
            notif.setType("inapp");
            notif.setTitle("Auto Pay Cancelled");
            notif.setMessage("Auto Pay instruction has been cancelled.");
            notificationDAO.create(notif);
        }
        return deleted;
    }

    public List<AutoPayInstruction> getInstructionsByCustomer(long customerId) throws SQLException {
        return autoPayDAO.getInstructionsByCustomerId(customerId);
    }

    public List<AutoPayHistory> getHistoryByCustomer(long customerId, int limit, int offset) throws SQLException {
        return autoPayDAO.getHistoryByCustomerId(customerId, limit, offset);
    }

    public int countHistoryByCustomer(long customerId) throws SQLException {
        return autoPayDAO.countHistoryByCustomerId(customerId);
    }

    public List<AutoPayInstruction> getAllInstructions(String search, String status, String targetType, int limit, int offset) throws SQLException {
        return autoPayDAO.getAllInstructions(search, status, targetType, limit, offset);
    }

    public int countAllInstructions(String search, String status, String targetType) throws SQLException {
        return autoPayDAO.countAllInstructions(search, status, targetType);
    }

    public List<AutoPayHistory> getAllHistory(String search, String status, String type, int limit, int offset) throws SQLException {
        return autoPayDAO.getAllHistory(search, status, type, limit, offset);
    }

    public int countAllHistory(String search, String status, String type) throws SQLException {
        return autoPayDAO.countAllHistory(search, status, type);
    }

    /**
     * Master run processor triggered by scheduler or manually by administrator
     */
    public synchronized int processAutoPayments() {
        int processedCount = 0;
        Connection conn = null;
        try {
            conn = DatabaseConfig.getInstance().getConnection();
            Date today = new Date(System.currentTimeMillis());
            List<AutoPayInstruction> dueInstructions = autoPayDAO.getDueInstructions(conn, today);
            logger.info("AutoPay Engine: Found {} due auto-pay instructions for date: {}", dueInstructions.size(), today);

            // Release master connection before looping to avoid locking database during inner transactions
            DatabaseConfig.closeConnection(conn);
            conn = null;

            for (AutoPayInstruction ins : dueInstructions) {
                try {
                    processSingleAutoPay(ins);
                    processedCount++;
                } catch (Exception e) {
                    logger.error("AutoPay Engine: Failed to process auto-pay instruction ID: " + ins.getAutoPayId(), e);
                }
            }
        } catch (Exception e) {
            logger.error("AutoPay Engine Master Loop encountered fatal exception", e);
        } finally {
            if (conn != null) {
                DatabaseConfig.closeConnection(conn);
            }
        }
        return processedCount;
    }

    private void processSingleAutoPay(AutoPayInstruction ins) throws Exception {
        Connection conn = null;
        try {
            conn = DatabaseConfig.getInstance().getConnection();
            conn.setAutoCommit(false);

            // 1. Validate Source Account
            Account sourceAccount = accountDAO.getById(ins.getSourceAccountId());
            if (sourceAccount == null || !"active".equalsIgnoreCase(sourceAccount.getStatus())) {
                throw new Exception("Source bank account is inactive or not found.");
            }
            if (sourceAccount.getCustomerId() != ins.getCustomerId()) {
                throw new Exception("Source account customer mismatch.");
            }

            BigDecimal amountToPay = BigDecimal.ZERO;

            // 2. Validate Targets and Determine Amount
            if ("credit_card".equals(ins.getTargetType())) {
                Card card = cardDAO.getById(ins.getCardId());
                if (card == null || !"active".equalsIgnoreCase(card.getStatus())) {
                    throw new Exception("Target credit card is inactive or not found.");
                }
                if (card.getCustomerId() != ins.getCustomerId()) {
                    throw new Exception("Card ownership mismatch.");
                }

                BigDecimal outstanding = card.getOutstandingBalance();
                if (outstanding.compareTo(BigDecimal.ZERO) <= 0) {
                    // Capped payoff reached, skip payment, advance payment schedule date
                    ins.setNextPaymentDate(calculateNextPaymentDate(ins.getNextPaymentDate()));
                    ins.setLastProcessedDate(new Timestamp(System.currentTimeMillis()));
                    autoPayDAO.updateInstruction(conn, ins);
                    conn.commit();
                    logger.info("AutoPay Skip: No outstanding credit dues on Card ID: {}", ins.getCardId());
                    return;
                }

                if ("full_amount_due".equalsIgnoreCase(ins.getPaymentType())) {
                    amountToPay = outstanding;
                } else if ("minimum_due".equalsIgnoreCase(ins.getPaymentType())) {
                    amountToPay = outstanding.multiply(new BigDecimal("0.05")).setScale(2, RoundingMode.HALF_UP);
                    if (amountToPay.compareTo(new BigDecimal("500")) < 0) {
                        amountToPay = new BigDecimal("500");
                    }
                    if (amountToPay.compareTo(outstanding) > 0) {
                        amountToPay = outstanding;
                    }
                } else {
                    throw new Exception("Invalid auto pay payment type for credit card.");
                }
            } else if ("loan".equals(ins.getTargetType())) {
                Loan loan = loanDAO.getById(ins.getLoanId());
                if (loan == null || "closed".equalsIgnoreCase(loan.getStatus())) {
                    // If closed, disable configuration rules
                    ins.setStatus("disabled");
                    autoPayDAO.updateInstruction(conn, ins);
                    conn.commit();
                    logger.info("AutoPay Skip: Loan closed on Loan ID: {}", ins.getLoanId());
                    return;
                }
                if (loan.getCustomerId() != ins.getCustomerId()) {
                    throw new Exception("Loan ownership mismatch.");
                }

                BigDecimal remaining = loan.getRemainingBalance();
                if (remaining.compareTo(BigDecimal.ZERO) <= 0) {
                    ins.setStatus("disabled");
                    autoPayDAO.updateInstruction(conn, ins);
                    conn.commit();
                    return;
                }

                amountToPay = loan.getMonthlyEMI();
                if (amountToPay.compareTo(remaining) > 0) {
                    amountToPay = remaining;
                }
            } else {
                throw new Exception("Unsupported target module.");
            }

            // 3. Core balance checks
            if (sourceAccount.getBalance().compareTo(amountToPay) < 0) {
                throw new Exception("Insufficient funds. Available: ₹" + sourceAccount.getBalance().setScale(2) + ", Required: ₹" + amountToPay.setScale(2));
            }

            // 4. Release locks before entering nested Service transaction contexts
            conn.commit();
            DatabaseConfig.closeConnection(conn);
            conn = null;

            String transactionRef = "";
            if ("credit_card".equals(ins.getTargetType())) {
                CreditCardRepayment ccRepay = cardService.processCreditCardRepayment(
                    ins.getCustomerId(), ins.getCardId(), ins.getSourceAccountId(), amountToPay, ins.getPaymentType()
                );
                transactionRef = ccRepay.getTransactionReference();
            } else {
                loanService.processRepayment(ins.getLoanId(), ins.getCustomerId(), amountToPay, ins.getSourceAccountId());
                transactionRef = "REPAY-AP-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
            }

            // 5. Open new transaction to log history and shift dates
            conn = DatabaseConfig.getInstance().getConnection();
            conn.setAutoCommit(false);

            AutoPayHistory successHistory = new AutoPayHistory();
            successHistory.setAutoPayId(ins.getAutoPayId());
            successHistory.setAmount(amountToPay);
            successHistory.setStatus("completed");
            successHistory.setTransactionReference(transactionRef);
            autoPayDAO.createHistoryEntry(conn, successHistory);

            ins.setNextPaymentDate(calculateNextPaymentDate(ins.getNextPaymentDate()));
            ins.setLastProcessedDate(new Timestamp(System.currentTimeMillis()));
            autoPayDAO.updateInstruction(conn, ins);

            Notification notification = new Notification();
            notification.setCustomerId(ins.getCustomerId());
            notification.setType("inapp");
            notification.setTitle("Auto Pay Processed Successfully");
            notification.setMessage("Auto payment of ₹" + amountToPay.setScale(2) + 
                  " cleared successfully from account " + ins.getMaskedSourceAccountNumber() + 
                  " for " + ("credit_card".equals(ins.getTargetType()) ? "Credit Card " + ins.getMaskedCardNumber() : "Loan ID " + ins.getLoanId()) + 
                  ". Transaction reference: " + transactionRef);
            notificationDAO.create(conn, notification);

            // Simulation of mail and SMS dispatch logs
            logger.info("AutoPay: Dispatched alert emails and SMS to customer: {}", ins.getCustomerId());

            conn.commit();
        } catch (Exception e) {
            logger.error("AutoPay Failure on instruction ID " + ins.getAutoPayId() + ": " + e.getMessage());
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) {}
                DatabaseConfig.closeConnection(conn);
                conn = null;
            }

            // Open new connection to log failed attempt
            conn = DatabaseConfig.getInstance().getConnection();
            conn.setAutoCommit(false);
            try {
                AutoPayHistory failHistory = new AutoPayHistory();
                failHistory.setAutoPayId(ins.getAutoPayId());
                failHistory.setAmount(BigDecimal.ZERO);
                failHistory.setStatus("failed");
                failHistory.setFailureReason(e.getMessage());
                autoPayDAO.createHistoryEntry(conn, failHistory);

                Notification failNotification = new Notification();
                failNotification.setCustomerId(ins.getCustomerId());
                failNotification.setType("inapp");
                failNotification.setTitle("Auto Pay Failed");
                failNotification.setMessage("Auto payment processing failed: " + e.getMessage() + 
                      " for " + ("credit_card".equals(ins.getTargetType()) ? "Credit Card " + ins.getMaskedCardNumber() : "Loan ID " + ins.getLoanId()));
                notificationDAO.create(conn, failNotification);

                conn.commit();
            } catch (Exception ex) {
                logger.error("AutoPay Engine: Failed to log failure details in database", ex);
                if (conn != null) {
                    try { conn.rollback(); } catch (SQLException exc) {}
                }
            }
        } finally {
            if (conn != null) {
                DatabaseConfig.closeConnection(conn);
            }
        }
    }

    private Date calculateNextPaymentDate(Date current) {
        java.util.Calendar cal = java.util.Calendar.getInstance();
        cal.setTime(current);
        cal.add(java.util.Calendar.MONTH, 1);
        return new Date(cal.getTimeInMillis());
    }
}
