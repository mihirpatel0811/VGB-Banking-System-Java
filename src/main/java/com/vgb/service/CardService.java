package com.vgb.service;

import com.vgb.config.DatabaseConfig;
import com.vgb.constants.AppConstants;
import com.vgb.dao.AccountDAOImpl;
import com.vgb.dao.CardDAOImpl;
import com.vgb.dao.TransactionDAOImpl;
import com.vgb.model.Account;
import com.vgb.model.Card;
import com.vgb.model.Transaction;
import com.vgb.model.CreditCardRepayment;
import com.vgb.dao.CreditCardRepaymentDAO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;
import java.util.Random;
import java.util.UUID;

public class CardService {
    private static final Logger logger = LoggerFactory.getLogger(CardService.class);
    private CardDAOImpl cardDAO = new CardDAOImpl();
    private AccountDAOImpl accountDAO = new AccountDAOImpl();
    private TransactionDAOImpl transactionDAO = new TransactionDAOImpl();
    private CreditCardRepaymentDAO repaymentDAO = new CreditCardRepaymentDAO();
    private Random random = new Random();

    /**
     * Helper to run self-healing expiry sweep before other operations
     */
    private void runExpiryCheck() {
        try {
            cardDAO.updateExpiredCardsStatus();
        } catch (SQLException e) {
            logger.error("Error executing self-healing card expiry check", e);
        }
    }

    public List<Card> getCustomerCards(long customerId) throws Exception {
        runExpiryCheck();
        try {
            return cardDAO.getByCustomerId(customerId);
        } catch (SQLException e) {
            logger.error("Error loading customer cards", e);
            throw new Exception("Failed to load cards: " + e.getMessage());
        }
    }

    /**
     * Backward-compatible alias for Auto Pay and other modules.
     */
    public List<Card> getCardsByCustomerId(long customerId) throws Exception {
        return getCustomerCards(customerId);
    }

    public List<Card> getAllCards() throws Exception {
        runExpiryCheck();
        try {
            return cardDAO.getAll();
        } catch (SQLException e) {
            logger.error("Error loading all cards", e);
            throw new Exception("Failed to load all cards: " + e.getMessage());
        }
    }

    public Card getCardById(long cardId) throws Exception {
        runExpiryCheck();
        try {
            return cardDAO.getById(cardId);
        } catch (SQLException e) {
            logger.error("Error loading card by ID", e);
            throw new Exception("Failed to load card details: " + e.getMessage());
        }
    }

    public Card getByCardNumber(String cardNumber) throws Exception {
        runExpiryCheck();
        try {
            return cardDAO.getByCardNumber(cardNumber);
        } catch (SQLException e) {
            logger.error("Error loading card by number", e);
            throw new Exception("Failed to find card details: " + e.getMessage());
        }
    }

    /**
     * Apply for a new VGB Card. The card fee is paid immediately from the bank account balance.
     */
    public Card applyForCard(long customerId, long accountId, String cardType, String cardProvider, String cardHolderName) throws Exception {
        String defaultTier = "credit".equalsIgnoreCase(cardType) ? "royale" : "classic";
        return applyForCard(customerId, accountId, cardType, cardProvider, cardHolderName, defaultTier);
    }

    public Card applyForCard(long customerId, long accountId, String cardType, String cardProvider, String cardHolderName, String cardTier) throws Exception {
        runExpiryCheck();
        
        // 1. Verify account is active and owned by the customer
        Account account;
        try {
            account = accountDAO.getById(accountId);
            if (account == null) {
                throw new Exception("Selected account not found.");
            }
            // Check if customer is the primary owner or a joint signatory
            boolean isAuthorized = false;
            // Get the primary customer ID for this account from account_signatory table
            try (Connection conn = DatabaseConfig.getInstance().getConnection();
                 PreparedStatement stmt = conn.prepareStatement("SELECT customer_id FROM account_signatory WHERE account_id = ? AND ownership_type = 'primary'")) {
                stmt.setLong(1, accountId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        long primaryCustomerId = rs.getLong("customer_id");
                        if (primaryCustomerId == customerId) {
                            isAuthorized = true;
                        }
                    }
                }
            }
            // If not primary, check if customer is in joint holders list
            if (!isAuthorized) {
                try (Connection conn = DatabaseConfig.getInstance().getConnection();
                     PreparedStatement stmt = conn.prepareStatement("SELECT COUNT(*) FROM account_signatory WHERE account_id = ? AND customer_id = ?")) {
                    stmt.setLong(1, accountId);
                    stmt.setLong(2, customerId);
                    try (ResultSet rs = stmt.executeQuery()) {
                        if (rs.next() && rs.getInt(1) > 0) {
                            isAuthorized = true;
                        }
                    }
                }
            }
            if (!isAuthorized) {
                throw new Exception("Unauthorized account selected.");
            }
            if (!"active".equalsIgnoreCase(account.getStatus())) {
                throw new Exception("Selected account is not active.");
            }
        } catch (SQLException e) {
            throw new Exception("Database error checking account details: " + e.getMessage());
        }

        // 2. Set card fee and limits based on selected card product tier
        BigDecimal cardFee = BigDecimal.ZERO;
        BigDecimal dailyLimit = new BigDecimal("50000.0000");
        BigDecimal atmLimit = new BigDecimal("25000.0000");
        BigDecimal onlineLimit = new BigDecimal("50000.0000");

        if ("premium".equalsIgnoreCase(cardTier)) {
            cardFee = new BigDecimal("500.0000");
            dailyLimit = new BigDecimal("200000.0000");
            atmLimit = new BigDecimal("50000.0000");
            onlineLimit = new BigDecimal("150000.0000");
        } else if ("royale".equalsIgnoreCase(cardTier)) {
            cardFee = new BigDecimal("500.0000");
            dailyLimit = new BigDecimal("50000.0000"); // Credit limit
            atmLimit = new BigDecimal("25000.0000");
            onlineLimit = new BigDecimal("50000.0000");
        } else if ("infinite".equalsIgnoreCase(cardTier)) {
            cardFee = new BigDecimal("2000.0000");
            dailyLimit = new BigDecimal("500000.0000"); // Credit limit
            atmLimit = new BigDecimal("50000.0000");
            onlineLimit = new BigDecimal("450000.0000");
        } else { // "classic" or default
            cardFee = new BigDecimal("250.0000");
            dailyLimit = new BigDecimal("50000.0000");
            atmLimit = new BigDecimal("25000.0000");
            onlineLimit = new BigDecimal("50000.0000");
        }

        // 3. Verify sufficient balance in selected account to pay the card fee
        if (account.getBalance().compareTo(cardFee) < 0) {
            throw new Exception("Insufficient balance to pay VGB Card Issuance fee of ₹" + cardFee.setScale(2) + ".");
        }

        // 4. Generate unique 16-digit card number
        String cardNumber = generateUniqueCardNumber(cardProvider);
        String cvv = String.format("%03d", 100 + random.nextInt(900));

        // 5. Expiry Date is 4 years from today
        LocalDate localExpiry = LocalDate.now().plusYears(4);
        Date expiryDate = Date.valueOf(localExpiry);

        Card card = new Card();
        card.setAccountId(accountId);
        card.setCustomerId(customerId);
        card.setCardNumber(cardNumber);
        card.setCardType(cardType.toLowerCase());
        card.setCardProvider(cardProvider.toLowerCase());
        card.setCardHolderName(cardHolderName.trim().toUpperCase());
        card.setCvv(cvv);
        card.setExpiryDate(expiryDate);
        card.setStatus("pending"); // Awaiting admin approval
        card.setCardFee(cardFee);
        card.setDailyLimit(dailyLimit);
        card.setAtmLimit(atmLimit);
        card.setOnlineLimit(onlineLimit);
        card.setOutstandingBalance(BigDecimal.ZERO);
        card.setFeePaid(false); // fee will be paid on approval
        card.setCardTier(cardTier.toLowerCase());

        try {
            // Create card record
            if (cardDAO.create(card)) {
                logger.info("Card applied successfully! Card ID: {}, Card Number: {}", card.getCardId(), card.getCardNumber());
                return card;
            }
            throw new Exception("Failed to save card application to database.");
        } catch (SQLException e) {
            logger.error("SQL Error applying for card", e);
            throw new Exception("Database error applying for card: " + e.getMessage());
        }
    }

    /**
     * Renew an expired or closed VGB card for another 4 years (charges fee again).
     */
    public boolean renewCard(long cardId, long accountId) throws Exception {
        runExpiryCheck();
        
        try {
            Card card = cardDAO.getById(cardId);
            if (card == null) {
                throw new Exception("Card not found.");
            }
            if ("active".equalsIgnoreCase(card.getStatus()) && card.getExpiryDate().after(Date.valueOf(LocalDate.now()))) {
                throw new Exception("Card is currently active and does not require renewal.");
            }

            Account account = accountDAO.getById(accountId);
            if (account == null) {
                throw new Exception("Account not found.");
            }
            if (!"active".equalsIgnoreCase(account.getStatus())) {
                throw new Exception("Account is not active.");
            }

            BigDecimal renewalFee = card.getCardFee();
            if (account.getBalance().compareTo(renewalFee) < 0) {
                throw new Exception("Insufficient balance to pay card renewal fee of ₹" + renewalFee.setScale(2) + ".");
            }

            // Expiry extend to 4 years from today
            LocalDate localExpiry = LocalDate.now().plusYears(4);
            Date newExpiry = Date.valueOf(localExpiry);

            // Set pending status and reset fee paid to false upon renewal awaiting admin approval
            cardDAO.updateFeePaidStatus(cardId, false);
            return cardDAO.updateExpiryAndStatus(cardId, newExpiry, "pending");
        } catch (SQLException e) {
            logger.error("SQL Error renewing card", e);
            throw new Exception("Database error renewing card: " + e.getMessage());
        }
    }

    /**
     * Clear Credit Card outstanding balance using a selected bank account.
     */
    public boolean payCreditCardDues(long cardId, long accountId, BigDecimal amount) throws Exception {
        runExpiryCheck();

        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new Exception("Invalid payment amount.");
        }

        Connection conn = null;
        try {
            conn = DatabaseConfig.getInstance().getConnection();
            conn.setAutoCommit(false); // Begin Transaction!

            Card card = cardDAO.getById(conn, cardId);
            if (card == null) {
                throw new Exception("Card not found.");
            }
            if (!"credit".equalsIgnoreCase(card.getCardType())) {
                throw new Exception("This is not a credit card.");
            }
            if (card.getOutstandingBalance().compareTo(BigDecimal.ZERO) <= 0) {
                throw new Exception("No outstanding dues to pay for this card.");
            }
            if (amount.compareTo(card.getOutstandingBalance()) > 0) {
                throw new Exception("Cannot pay more than the outstanding balance of ₹" + card.getOutstandingBalance().setScale(2) + ".");
            }

            Account account = accountDAO.getById(conn, accountId);
            if (account == null) {
                throw new Exception("Source account not found.");
            }
            if (!"active".equalsIgnoreCase(account.getStatus())) {
                throw new Exception("Source account is not active.");
            }
            if (account.getBalance().compareTo(amount) < 0) {
                throw new Exception("Insufficient balance in selected account to pay card dues.");
            }

            // Deduct from account balance
            BigDecimal newBalance = account.getBalance().subtract(amount);
            accountDAO.updateBalance(conn, accountId, newBalance);

            // Reduce credit card outstanding balance
            BigDecimal newOutstanding = card.getOutstandingBalance().subtract(amount);
            cardDAO.updateOutstandingBalance(conn, cardId, newOutstanding);

            // Record transaction
            Transaction transaction = new Transaction();
            transaction.setFromAccountId(accountId);
            transaction.setTransactionType(AppConstants.TRANSACTION_TYPE_TRANSFER);
            transaction.setAmount(amount);
            transaction.setReferenceNumber("TXN" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
            transaction.setDescription("VGB " + card.getCardTier().toUpperCase() + " Credit Card Bill Payment (Card: " + card.getMaskedCardNumber() + ")");
            transaction.setStatus(AppConstants.TRANSACTION_STATUS_COMPLETED);
            transactionDAO.create(conn, transaction);

            // Create Credit Card Repayment log
            CreditCardRepayment repayment = new CreditCardRepayment();
            repayment.setCardId(cardId);
            repayment.setCustomerId(card.getCustomerId());
            repayment.setAccountId(accountId);
            repayment.setAmountPaid(amount);
            repayment.setPaymentOption("account");
            repayment.setTransactionReference(transaction.getReferenceNumber());
            repayment.setStatus("completed");
            repaymentDAO.create(conn, repayment);

            conn.commit();
            logger.info("Card dues account payment successful - Card: {}, Account: {}, Amount: {}", cardId, accountId, amount);
            return true;
        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { logger.error("Rollback failed", ex); }
            }
            logger.error("Error paying card dues from account", e);
            throw new Exception("Failed to pay card dues: " + e.getMessage(), e);
        } finally {
            DatabaseConfig.closeConnection(conn);
        }
    }

    public boolean approveCard(long cardId) throws Exception {
        try {
            Card card = cardDAO.getById(cardId);
            if (card == null) {
                throw new Exception("Card not found.");
            }
            if ("active".equalsIgnoreCase(card.getStatus())) {
                return true;
            }

            // Debit fee at approval time if not already paid
            if (!card.isFeePaid() && card.getCardFee().compareTo(BigDecimal.ZERO) > 0) {
                Account account = accountDAO.getById(card.getAccountId());
                if (account == null) {
                    throw new Exception("Linked account not found.");
                }
                if (!"active".equalsIgnoreCase(account.getStatus())) {
                    throw new Exception("Linked account is not active.");
                }
                if (account.getBalance().compareTo(card.getCardFee()) < 0) {
                    throw new Exception("Insufficient account balance to pay Card Issuance/Renewal fee of ₹" + card.getCardFee().setScale(2) + ".");
                }

                // Deduct fee
                BigDecimal newBalance = account.getBalance().subtract(card.getCardFee());
                accountDAO.updateBalance(card.getAccountId(), newBalance);

                // Record transaction fee
                Transaction transaction = new Transaction();
                transaction.setFromAccountId(card.getAccountId());
                transaction.setTransactionType(AppConstants.TRANSACTION_TYPE_FEE);
                transaction.setAmount(card.getCardFee());
                transaction.setReferenceNumber("TXN" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
                transaction.setDescription("VGB " + card.getCardProvider().toUpperCase() + " " + card.getCardTier().toUpperCase() + " " + card.getCardType().toUpperCase() + " Card Fee");
                transaction.setStatus(AppConstants.TRANSACTION_STATUS_COMPLETED);
                transactionDAO.create(transaction);

                // Update fee paid status in DB
                cardDAO.updateFeePaidStatus(cardId, true);
            }

            boolean statusUpdated = cardDAO.updateStatus(cardId, "active");
            if (statusUpdated) {
                accountDAO.updateAtmCardStatus(card.getAccountId(), true);
            }
            return statusUpdated;
        } catch (SQLException e) {
            logger.error("Error approving card", e);
            throw new Exception("Failed to approve card: " + e.getMessage());
        }
    }

    public boolean closeCard(long cardId) throws Exception {
        runExpiryCheck();
        try {
            Card card = cardDAO.getById(cardId);
            if (card == null) {
                throw new Exception("Card not found.");
            }

            // If the card is currently in "pending" status, it represents a card request rejection.
            // The card fee paid upfront (₹250 or ₹500) must be refunded back to the linked account.
            if ("pending".equalsIgnoreCase(card.getStatus()) && card.isFeePaid() && card.getCardFee().compareTo(BigDecimal.ZERO) > 0) {
                Account account = accountDAO.getById(card.getAccountId());
                if (account != null) {
                    // Calculate and update the new balance
                    BigDecimal newBalance = account.getBalance().add(card.getCardFee());
                    accountDAO.updateBalance(account.getAccountId(), newBalance);

                    // Record a refund/deposit transaction in the ledger
                    Transaction transaction = new Transaction();
                    transaction.setToAccountId(account.getAccountId());
                    transaction.setTransactionType(AppConstants.TRANSACTION_TYPE_DEPOSIT);
                    transaction.setAmount(card.getCardFee());
                    transaction.setReferenceNumber("TXN" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
                    transaction.setDescription("Refund: VGB " + card.getCardTier().toUpperCase() + " " + card.getCardType().toUpperCase() + " Card Application Rejection (Card: " + card.getMaskedCardNumber() + ")");
                    transaction.setStatus(AppConstants.TRANSACTION_STATUS_COMPLETED);
                    transactionDAO.create(transaction);

                    // Mark fee as refunded (is_fee_paid = false) in the card table
                    cardDAO.updateFeePaidStatus(cardId, false);

                    logger.info("Refunded card fee of ₹{} to account ID {} due to rejection of card ID {}.", card.getCardFee(), account.getAccountId(), cardId);
                }
            }

            return cardDAO.updateStatus(cardId, "closed");
        } catch (SQLException e) {
            logger.error("Error closing card", e);
            throw new Exception("Failed to close card: " + e.getMessage());
        }
    }
    public boolean updateLimits(long cardId, BigDecimal dailyLimit, BigDecimal atmLimit, BigDecimal onlineLimit, boolean internationalEnabled) throws Exception {
        runExpiryCheck();
        try {
            return cardDAO.updateLimits(cardId, dailyLimit, atmLimit, onlineLimit, internationalEnabled);
        } catch (SQLException e) {
            logger.error("Error updating card limits", e);
            throw new Exception("Failed to update card limits: " + e.getMessage());
        }
    }

    private String generateUniqueCardNumber(String provider) throws SQLException {
        String prefix = "4"; // default Visa
        if ("mastercard".equalsIgnoreCase(provider)) {
            prefix = "5";
        } else if ("rupay".equalsIgnoreCase(provider)) {
            prefix = "6";
        }

        while (true) {
            StringBuilder sb = new StringBuilder(prefix);
            for (int i = 0; i < 15; i++) {
                sb.append(random.nextInt(10));
            }
            
            // Format card number with spaces (e.g. 4589 7321 6048 2190)
            String raw = sb.toString();
            String formatted = raw.substring(0, 4) + " " + raw.substring(4, 8) + " " + raw.substring(8, 12) + " " + raw.substring(12, 16);

            if (cardDAO.getByCardNumber(formatted) == null) {
                return formatted;
            }
        }
    }

    /**
     * Pay credit card outstanding dues using Cash at the Cash Counter
     */
    public boolean payCreditCardDuesWithCash(long cardId, BigDecimal amount, Long performedById) throws Exception {
        runExpiryCheck();

        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new Exception("Invalid payment amount.");
        }

        Connection conn = null;
        try {
            conn = DatabaseConfig.getInstance().getConnection();
            conn.setAutoCommit(false); // Begin Transaction!

            Card card = cardDAO.getById(conn, cardId);
            if (card == null) {
                throw new Exception("Card not found.");
            }
            if (!"credit".equalsIgnoreCase(card.getCardType())) {
                throw new Exception("This is not a credit card.");
            }
            if (card.getOutstandingBalance().compareTo(BigDecimal.ZERO) <= 0) {
                throw new Exception("No outstanding dues to pay for this card.");
            }
            if (amount.compareTo(card.getOutstandingBalance()) > 0) {
                throw new Exception("Cannot pay more than the outstanding balance of ₹" + card.getOutstandingBalance().setScale(2) + ".");
            }

            // Reduce credit card outstanding balance
            BigDecimal newOutstanding = card.getOutstandingBalance().subtract(amount);
            cardDAO.updateOutstandingBalance(conn, cardId, newOutstanding);

            // Record transaction
            Transaction transaction = new Transaction();
            transaction.setFromAccountId(null);
            transaction.setToAccountId(null);
            transaction.setTransactionType(AppConstants.TRANSACTION_TYPE_TRANSFER);
            transaction.setAmount(amount);
            transaction.setReferenceNumber("TXN" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
            transaction.setDescription("VGB " + card.getCardTier().toUpperCase() + " Credit Card Cash Counter Bill Payment (Card: " + card.getMaskedCardNumber() + ")");
            transaction.setStatus(AppConstants.TRANSACTION_STATUS_COMPLETED);
            transaction.setTransferMode("cash");
            transaction.setPerformedById(performedById);
            transactionDAO.create(conn, transaction);

            // Create Credit Card Repayment log
            CreditCardRepayment repayment = new CreditCardRepayment();
            repayment.setCardId(cardId);
            repayment.setCustomerId(card.getCustomerId());
            repayment.setAccountId(0L); // No account for cash payment
            repayment.setAmountPaid(amount);
            repayment.setPaymentOption("cash");
            repayment.setTransactionReference(transaction.getReferenceNumber());
            repayment.setStatus("completed");
            repaymentDAO.create(conn, repayment);

            conn.commit();
            logger.info("Card dues cash payment successful - Card: {}, Amount: {}", cardId, amount);
            return true;
        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { logger.error("Rollback failed", ex); }
            }
            logger.error("Error paying card dues with cash", e);
            throw new Exception("Failed to pay card dues: " + e.getMessage(), e);
        } finally {
            DatabaseConfig.closeConnection(conn);
        }
    }

    /**
     * Pay credit card outstanding dues using a VGB cheque
     */
    public boolean payCreditCardDuesWithCheque(long cardId, long accountId, String chequeBookNumber, String chequeNumber, BigDecimal amount, Long performedById) throws Exception {
        runExpiryCheck();

        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new Exception("Invalid payment amount.");
        }

        Connection conn = null;
        try {
            conn = DatabaseConfig.getInstance().getConnection();
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

            // 2. Card verification
            Card card = cardDAO.getById(conn, cardId);
            if (card == null) {
                throw new Exception("Card not found.");
            }
            if (!"credit".equalsIgnoreCase(card.getCardType())) {
                throw new Exception("This is not a credit card.");
            }
            if (card.getOutstandingBalance().compareTo(BigDecimal.ZERO) <= 0) {
                throw new Exception("No outstanding dues to pay for this card.");
            }
            if (amount.compareTo(card.getOutstandingBalance()) > 0) {
                throw new Exception("Cannot pay more than the outstanding balance of ₹" + card.getOutstandingBalance().setScale(2) + ".");
            }

            // 3. Account verification and balance check
            Account account = accountDAO.getById(conn, accountId);
            if (account == null) {
                throw new Exception("Source account not found.");
            }
            if (!"active".equalsIgnoreCase(account.getStatus())) {
                throw new Exception("Source account is not active.");
            }
            if (account.getBalance().compareTo(amount) < 0) {
                throw new Exception("Insufficient balance in selected account to pay card dues.");
            }

            // Deduct from account balance
            BigDecimal newBalance = account.getBalance().subtract(amount);
            accountDAO.updateBalance(conn, accountId, newBalance);

            // Reduce credit card outstanding balance
            BigDecimal newOutstanding = card.getOutstandingBalance().subtract(amount);
            cardDAO.updateOutstandingBalance(conn, cardId, newOutstanding);

            // Record transaction
            Transaction transaction = new Transaction();
            transaction.setFromAccountId(accountId);
            transaction.setToAccountId(null);
            transaction.setTransactionType(AppConstants.TRANSACTION_TYPE_TRANSFER);
            transaction.setAmount(amount);
            transaction.setReferenceNumber("TXN" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
            transaction.setDescription("VGB " + card.getCardTier().toUpperCase() + " Credit Card Bill Payment (Cheque #" + chequeNumber + ")");
            transaction.setStatus(AppConstants.TRANSACTION_STATUS_COMPLETED);
            transaction.setTransferMode("cheque");
            transaction.setPerformedById(performedById);
            transactionDAO.create(conn, transaction);

            // Create Credit Card Repayment log
            CreditCardRepayment repayment = new CreditCardRepayment();
            repayment.setCardId(cardId);
            repayment.setCustomerId(card.getCustomerId());
            repayment.setAccountId(accountId);
            repayment.setAmountPaid(amount);
            repayment.setPaymentOption("cheque");
            repayment.setTransactionReference(transaction.getReferenceNumber());
            repayment.setStatus("completed");
            repaymentDAO.create(conn, repayment);

            conn.commit();
            logger.info("Card dues cheque payment successful - Card: {}, Cheque: {}, Amount: {}", cardId, chequeNumber, amount);
            return true;
        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { logger.error("Rollback failed", ex); }
            }
            logger.error("Error paying card dues with cheque", e);
            throw new Exception("Failed to pay card dues: " + e.getMessage(), e);
        } finally {
            DatabaseConfig.closeConnection(conn);
        }
    }

    /**
     * Process a customer credit card bill repayment atomically using a single DB transaction.
     */
    public CreditCardRepayment processCreditCardRepayment(long customerId, long cardId, long accountId, BigDecimal amount, String paymentOption) throws Exception {
        runExpiryCheck();

        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new Exception("Repayment amount must be greater than zero.");
        }

        Connection conn = null;
        try {
            conn = DatabaseConfig.getInstance().getConnection();
            conn.setAutoCommit(false); // Start Transaction

            // 1. Fetch and validate card
            Card card = cardDAO.getById(cardId);
            if (card == null) {
                throw new Exception("Credit card not found.");
            }
            if (card.getCustomerId() != customerId) {
                throw new Exception("Unauthorized: You can only repay your own credit card bill.");
            }
            if (!"credit".equalsIgnoreCase(card.getCardType())) {
                throw new Exception("Selected card is not a credit card.");
            }
            if (!"active".equalsIgnoreCase(card.getStatus())) {
                throw new Exception("This credit card is not active.");
            }
            if (card.getOutstandingBalance().compareTo(BigDecimal.ZERO) <= 0) {
                throw new Exception("This card has no outstanding balance.");
            }
            if (amount.compareTo(card.getOutstandingBalance()) > 0) {
                throw new Exception("Repayment amount of ₹" + amount.setScale(2) + " exceeds outstanding balance of ₹" + card.getOutstandingBalance().setScale(2));
            }

            // 2. Fetch and validate account
            Account account = accountDAO.getById(accountId);
            if (account == null) {
                throw new Exception("Source account not found.");
            }
            if (!"active".equalsIgnoreCase(account.getStatus())) {
                throw new Exception("Selected source account is not active.");
            }
            if (account.getBalance().compareTo(amount) < 0) {
                throw new Exception("Insufficient funds in selected account. Available balance: ₹" + account.getBalance().setScale(2));
            }

            // 3. Perform Debits & Credits
            BigDecimal newAccountBalance = account.getBalance().subtract(amount);
            accountDAO.updateBalance(conn, accountId, newAccountBalance);

            BigDecimal newCardOutstanding = card.getOutstandingBalance().subtract(amount);
            cardDAO.updateOutstandingBalance(conn, cardId, newCardOutstanding);

            // Generate unique txn reference
            String txRef = "TXN-CC-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase() + "-" + (1000 + random.nextInt(9000));

            // 4. Create general ledger transaction
            Transaction transaction = new Transaction();
            transaction.setFromAccountId(accountId);
            transaction.setToAccountId(null);
            transaction.setTransactionType(AppConstants.TRANSACTION_TYPE_TRANSFER);
            transaction.setAmount(amount);
            transaction.setReferenceNumber(txRef);
            transaction.setDescription("VGB " + card.getCardTier().toUpperCase() + " Credit Card Repayment (Card: " + card.getMaskedCardNumber() + ")");
            transaction.setStatus(AppConstants.TRANSACTION_STATUS_COMPLETED);
            transaction.setTransferMode("debit_account");
            transaction.setPerformedById(customerId);
            transactionDAO.create(conn, transaction);

            // 5. Create Credit Card Repayment log
            CreditCardRepayment repayment = new CreditCardRepayment();
            repayment.setCardId(cardId);
            repayment.setCustomerId(customerId);
            repayment.setAccountId(accountId);
            repayment.setAmountPaid(amount);
            repayment.setPaymentOption(paymentOption);
            repayment.setTransactionReference(txRef);
            repayment.setStatus("completed");
            repaymentDAO.create(conn, repayment);

            // Commit!
            conn.commit();
            logger.info("Credit card repayment successfully processed. Txn: {}", txRef);
            
            // Set transient fields for receipt rendering
            repayment.setMaskedCardNumber(card.getMaskedCardNumber());
            repayment.setCardHolderName(card.getCardHolderName());
            repayment.setSourceAccountNumber("••••" + account.getAccountNumber().substring(account.getAccountNumber().length() - 4));
            
            return repayment;
        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    logger.error("Failed to rollback transaction", ex);
                }
            }
            logger.error("Transaction failed during credit card repayment", e);
            throw e;
        } finally {
            DatabaseConfig.closeConnection(conn);
        }
    }

    /**
     * Charge credit card outstanding balance for local transfer to another VGB account
     */
    public boolean processCreditCardTransfer(long cardId, long toAccountId, BigDecimal amount, String description, Long performedById) throws Exception {
        runExpiryCheck();
        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new Exception("Invalid transfer amount.");
        }

        Connection conn = null;
        try {
            conn = DatabaseConfig.getInstance().getConnection();
            conn.setAutoCommit(false); // Begin Transaction!

            Card card = cardDAO.getById(conn, cardId);
            if (card == null || !"active".equalsIgnoreCase(card.getStatus()) || !"credit".equalsIgnoreCase(card.getCardType())) {
                throw new Exception("Selected credit card is invalid or not active.");
            }

            BigDecimal availableCredit = card.getOnlineLimit().subtract(card.getOutstandingBalance());
            if (amount.compareTo(availableCredit) > 0) {
                throw new Exception("Insufficient credit card limit. Available: ₹" + availableCredit.setScale(2));
            }

            Account toAccount = accountDAO.getById(conn, toAccountId);
            if (toAccount == null || !"active".equalsIgnoreCase(toAccount.getStatus())) {
                throw new Exception("Destination account is invalid or not active.");
            }

            // 1. Increase credit card outstanding balance
            BigDecimal newOutstanding = card.getOutstandingBalance().add(amount);
            cardDAO.updateOutstandingBalance(conn, cardId, newOutstanding);

            // 2. Increase recipient account balance
            BigDecimal newBalance = toAccount.getBalance().add(amount);
            accountDAO.updateBalance(conn, toAccountId, newBalance);

            // 3. Record transaction
            Transaction transaction = new Transaction();
            transaction.setFromAccountId(null);
            transaction.setToAccountId(toAccountId);
            transaction.setTransactionType(AppConstants.TRANSACTION_TYPE_TRANSFER);
            transaction.setAmount(amount);
            transaction.setReferenceNumber("TXN" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
            transaction.setDescription(description + " (Card: " + card.getMaskedCardNumber() + ")");
            transaction.setStatus(AppConstants.TRANSACTION_STATUS_COMPLETED);
            transaction.setTransferMode("card");
            transaction.setPerformedById(performedById);
            transactionDAO.create(conn, transaction);

            conn.commit();
            logger.info("Credit card transfer successful - Card: {}, To Account: {}, Amount: {}", cardId, toAccountId, amount);
            return true;
        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { logger.error("Rollback failed", ex); }
            }
            logger.error("Error processing credit card transfer", e);
            throw new Exception("Transfer failed: " + e.getMessage(), e);
        } finally {
            DatabaseConfig.closeConnection(conn);
        }
    }

    /**
     * Charge credit card outstanding balance for external transfer to another bank
     */
    public boolean processCreditCardExternalTransfer(long cardId, String toAccountNumber, String toIfscCode, String toHolderName, String toBankName, String toBranchName, BigDecimal amount, String description, Long performedById) throws Exception {
        runExpiryCheck();
        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new Exception("Invalid transfer amount.");
        }

        Connection conn = null;
        try {
            conn = DatabaseConfig.getInstance().getConnection();
            conn.setAutoCommit(false); // Begin Transaction!

            Card card = cardDAO.getById(conn, cardId);
            if (card == null || !"active".equalsIgnoreCase(card.getStatus()) || !"credit".equalsIgnoreCase(card.getCardType())) {
                throw new Exception("Selected credit card is invalid or not active.");
            }

            BigDecimal availableCredit = card.getOnlineLimit().subtract(card.getOutstandingBalance());
            if (amount.compareTo(availableCredit) > 0) {
                throw new Exception("Insufficient credit card limit. Available: ₹" + availableCredit.setScale(2));
            }

            // 1. Increase credit card outstanding balance
            BigDecimal newOutstanding = card.getOutstandingBalance().add(amount);
            cardDAO.updateOutstandingBalance(conn, cardId, newOutstanding);

            // 2. Record transaction (toAccountId = null represents external recipient)
            Transaction transaction = new Transaction();
            transaction.setFromAccountId(null);
            transaction.setToAccountId(null);
            transaction.setTransactionType(AppConstants.TRANSACTION_TYPE_TRANSFER);
            transaction.setAmount(amount);
            transaction.setReferenceNumber("TXN" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
            transaction.setDescription(description + " (To: " + toHolderName + ", A/C: " + toAccountNumber + ", IFSC: " + toIfscCode + " - Card: " + card.getMaskedCardNumber() + ")");
            transaction.setStatus(AppConstants.TRANSACTION_STATUS_COMPLETED);
            transaction.setTransferMode("external");
            transaction.setReceiverAccountNumber(toAccountNumber);
            transaction.setBeneficiaryName(toHolderName);
            transaction.setBeneficiaryIfsc(toIfscCode);
            transaction.setBeneficiaryBank(toBankName);
            transaction.setBeneficiaryBranch(toBranchName);
            transaction.setPerformedById(performedById);

            transactionDAO.create(conn, transaction);

            conn.commit();
            logger.info("Credit card external transfer successful - Card: {}, To External A/C: {}, Amount: {}", cardId, toAccountNumber, amount);
            return true;
        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { logger.error("Rollback failed", ex); }
            }
            logger.error("Error processing credit card external transfer", e);
            throw new Exception("External transfer failed: " + e.getMessage(), e);
        } finally {
            DatabaseConfig.closeConnection(conn);
        }
    }

    /**
     * Charge credit card outstanding balance for counter cash withdrawal
     */
    public boolean processCreditCardWithdrawal(long cardId, BigDecimal amount, String description, Long performedById) throws Exception {
        runExpiryCheck();
        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new Exception("Invalid withdrawal amount.");
        }

        Connection conn = null;
        try {
            conn = DatabaseConfig.getInstance().getConnection();
            conn.setAutoCommit(false); // Begin Transaction!

            Card card = cardDAO.getById(conn, cardId);
            if (card == null || !"active".equalsIgnoreCase(card.getStatus()) || !"credit".equalsIgnoreCase(card.getCardType())) {
                throw new Exception("Selected credit card is invalid or not active.");
            }

            BigDecimal availableCredit = card.getAtmLimit().subtract(card.getOutstandingBalance());
            if (amount.compareTo(availableCredit) > 0) {
                throw new Exception("Insufficient cash limit. Available: ₹" + availableCredit.setScale(2));
            }

            // 1. Increase credit card outstanding balance
            BigDecimal newOutstanding = card.getOutstandingBalance().add(amount);
            cardDAO.updateOutstandingBalance(conn, cardId, newOutstanding);

            // 2. Record transaction
            Transaction transaction = new Transaction();
            transaction.setFromAccountId(null);
            transaction.setToAccountId(null);
            transaction.setTransactionType(AppConstants.TRANSACTION_TYPE_WITHDRAWAL);
            transaction.setAmount(amount);
            transaction.setReferenceNumber("TXN" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
            transaction.setDescription(description + " (Card: " + card.getMaskedCardNumber() + ")");
            transaction.setStatus(AppConstants.TRANSACTION_STATUS_COMPLETED);
            transaction.setTransferMode("card");
            transaction.setPerformedById(performedById);

            transactionDAO.create(conn, transaction);

            conn.commit();
            logger.info("Credit card withdrawal successful - Card: {}, Amount: {}", cardId, amount);
            return true;
        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { logger.error("Rollback failed", ex); }
            }
            logger.error("Error processing credit card withdrawal", e);
            throw new Exception("Withdrawal failed: " + e.getMessage(), e);
        } finally {
            DatabaseConfig.closeConnection(conn);
        }
    }
}
