package com.vgb.service;

import com.vgb.config.DatabaseConfig;
import com.vgb.constants.AppConstants;
import com.vgb.dao.AccountDAOImpl;
import com.vgb.dao.CardDAOImpl;
import com.vgb.dao.TransactionDAOImpl;
import com.vgb.model.Account;
import com.vgb.model.Card;
import com.vgb.model.Transaction;
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

        // 2. Set card fee based on Debit/Credit
        BigDecimal cardFee = "credit".equalsIgnoreCase(cardType) ? new java.math.BigDecimal("500.0000") : new java.math.BigDecimal("250.0000");

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
        card.setOutstandingBalance(BigDecimal.ZERO);
        card.setFeePaid(true); // paid upfront

        try {
            // Transaction deduct fee
            BigDecimal newBalance = account.getBalance().subtract(cardFee);
            accountDAO.updateBalance(accountId, newBalance);

            // Record transaction
            Transaction transaction = new Transaction();
            transaction.setFromAccountId(accountId);
            transaction.setTransactionType(AppConstants.TRANSACTION_TYPE_FEE);
            transaction.setAmount(cardFee);
            transaction.setReferenceNumber("TXN" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
            transaction.setDescription("VGB " + cardProvider.toUpperCase() + " " + cardType.toUpperCase() + " Card Issuance Fee");
            transaction.setStatus(AppConstants.TRANSACTION_STATUS_COMPLETED);
            transactionDAO.create(transaction);

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

            // Deduct fee
            BigDecimal newBalance = account.getBalance().subtract(renewalFee);
            accountDAO.updateBalance(accountId, newBalance);

            // Record transaction
            Transaction transaction = new Transaction();
            transaction.setFromAccountId(accountId);
            transaction.setTransactionType(AppConstants.TRANSACTION_TYPE_FEE);
            transaction.setAmount(renewalFee);
            transaction.setReferenceNumber("TXN" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
            transaction.setDescription("VGB " + card.getCardProvider().toUpperCase() + " " + card.getCardType().toUpperCase() + " Card Renewal Fee");
            transaction.setStatus(AppConstants.TRANSACTION_STATUS_COMPLETED);
            transactionDAO.create(transaction);

            // Expiry extend to 4 years from today
            LocalDate localExpiry = LocalDate.now().plusYears(4);
            Date newExpiry = Date.valueOf(localExpiry);

            // Set pending status upon paid renewal awaiting admin approval
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

        try {
            Card card = cardDAO.getById(cardId);
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

            Account account = accountDAO.getById(accountId);
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
            accountDAO.updateBalance(accountId, newBalance);

            // Reduce credit card outstanding balance
            BigDecimal newOutstanding = card.getOutstandingBalance().subtract(amount);
            cardDAO.updateOutstandingBalance(cardId, newOutstanding);

            // Record transaction
            Transaction transaction = new Transaction();
            transaction.setFromAccountId(accountId);
            transaction.setTransactionType(AppConstants.TRANSACTION_TYPE_TRANSFER);
            transaction.setAmount(amount);
            transaction.setReferenceNumber("TXN" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
            transaction.setDescription("VGB Credit Card Bill Payment (Card: " + card.getMaskedCardNumber() + ")");
            transaction.setStatus(AppConstants.TRANSACTION_STATUS_COMPLETED);
            transactionDAO.create(transaction);

            return true;
        } catch (SQLException e) {
            logger.error("SQL Error paying card dues", e);
            throw new Exception("Database error paying credit dues: " + e.getMessage());
        }
    }

    public boolean approveCard(long cardId) throws Exception {
        try {
            return cardDAO.updateStatus(cardId, "active");
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
                    transaction.setDescription("Refund: VGB Card Application Rejection (Card: " + card.getMaskedCardNumber() + ")");
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
}
