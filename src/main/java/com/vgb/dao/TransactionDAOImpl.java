package com.vgb.dao;

import com.vgb.config.DatabaseConfig;
import com.vgb.model.Transaction;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * TransactionDAOImpl: Implementation of TransactionDAO
 */
public class TransactionDAOImpl implements TransactionDAO {
    private static final Logger logger = LoggerFactory.getLogger(TransactionDAOImpl.class);
    private DatabaseConfig dbConfig = DatabaseConfig.getInstance();

    private static final String CREATE_TRANSACTION = 
        "INSERT INTO transaction (from_account_id, to_account_id, transaction_type, amount, reference_number, description, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
    private static final String GET_TRANSACTION_BY_ID = 
        "SELECT * FROM transaction WHERE transaction_id = ?";
    private static final String GET_TRANSACTIONS_BY_ACCOUNT = 
        "SELECT * FROM transaction WHERE from_account_id = ? OR to_account_id = ? ORDER BY transaction_date DESC";
    private static final String GET_TRANSACTIONS_BY_DATE_RANGE = 
        "SELECT * FROM transaction WHERE transaction_date BETWEEN ? AND ? ORDER BY transaction_date DESC";
    private static final String GET_ALL_TRANSACTIONS = 
        "SELECT * FROM transaction ORDER BY transaction_date DESC";
    private static final String UPDATE_TRANSACTION_STATUS = 
        "UPDATE transaction SET status = ? WHERE transaction_id = ?";

    @Override
    public boolean create(Transaction transaction) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(CREATE_TRANSACTION, Statement.RETURN_GENERATED_KEYS);
            stmt.setObject(1, transaction.getFromAccountId(), Types.BIGINT);
            stmt.setObject(2, transaction.getToAccountId(), Types.BIGINT);
            stmt.setString(3, transaction.getTransactionType());
            stmt.setBigDecimal(4, transaction.getAmount());
            stmt.setString(5, transaction.getReferenceNumber());
            stmt.setString(6, transaction.getDescription());
            stmt.setString(7, transaction.getStatus());

            int result = stmt.executeUpdate();
            if (result > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        transaction.setTransactionId(generatedKeys.getLong(1));
                    }
                }
            }
            logger.info("Transaction created: {}", transaction.getReferenceNumber());
            return result > 0;

        } catch (SQLException e) {
            logger.error("Error creating transaction", e);
            throw new Exception("Failed to create transaction", e);
        } finally {
            DatabaseConfig.closeResources(null, stmt, conn);
        }
    }

    @Override
    public Transaction getById(long transactionId) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(GET_TRANSACTION_BY_ID);
            stmt.setLong(1, transactionId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToTransaction(rs);
            }
            return null;

        } catch (SQLException e) {
            logger.error("Error fetching transaction", e);
            throw new Exception("Failed to fetch transaction", e);
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    @Override
    public List<Transaction> getByAccountId(long accountId) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Transaction> transactions = new ArrayList<>();

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(GET_TRANSACTIONS_BY_ACCOUNT);
            stmt.setLong(1, accountId);
            stmt.setLong(2, accountId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                transactions.add(mapResultSetToTransaction(rs));
            }
            logger.info("Fetched {} transactions for account: {}", transactions.size(), accountId);
            return transactions;

        } catch (SQLException e) {
            logger.error("Error fetching transactions by account", e);
            throw new Exception("Failed to fetch transactions", e);
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    @Override
    public List<Transaction> getByDateRange(LocalDateTime startDate, LocalDateTime endDate) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Transaction> transactions = new ArrayList<>();

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(GET_TRANSACTIONS_BY_DATE_RANGE);
            stmt.setTimestamp(1, Timestamp.valueOf(startDate));
            stmt.setTimestamp(2, Timestamp.valueOf(endDate));
            rs = stmt.executeQuery();

            while (rs.next()) {
                transactions.add(mapResultSetToTransaction(rs));
            }
            return transactions;

        } catch (SQLException e) {
            logger.error("Error fetching transactions by date range", e);
            throw new Exception("Failed to fetch transactions", e);
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    @Override
    public List<Transaction> getAll() throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Transaction> transactions = new ArrayList<>();

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(GET_ALL_TRANSACTIONS);
            rs = stmt.executeQuery();

            while (rs.next()) {
                transactions.add(mapResultSetToTransaction(rs));
            }
            return transactions;

        } catch (SQLException e) {
            logger.error("Error fetching all transactions", e);
            throw new Exception("Failed to fetch transactions", e);
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    @Override
    public boolean updateStatus(long transactionId, String status) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(UPDATE_TRANSACTION_STATUS);
            stmt.setString(1, status);
            stmt.setLong(2, transactionId);

            int result = stmt.executeUpdate();
            logger.info("Transaction status updated - ID: {}, Status: {}", transactionId, status);
            return result > 0;

        } catch (SQLException e) {
            logger.error("Error updating transaction status", e);
            throw new Exception("Failed to update status", e);
        } finally {
            DatabaseConfig.closeResources(null, stmt, conn);
        }
    }

    private Transaction mapResultSetToTransaction(ResultSet rs) throws SQLException {
        Transaction transaction = new Transaction();
        transaction.setTransactionId(rs.getLong("transaction_id"));
        
        Object fromId = rs.getObject("from_account_id");
        if (fromId != null) {
            transaction.setFromAccountId(rs.getLong("from_account_id"));
        }
        
        Object toId = rs.getObject("to_account_id");
        if (toId != null) {
            transaction.setToAccountId(rs.getLong("to_account_id"));
        }
        
        transaction.setTransactionType(rs.getString("transaction_type"));
        transaction.setAmount(rs.getBigDecimal("amount"));
        transaction.setReferenceNumber(rs.getString("reference_number"));
        transaction.setDescription(rs.getString("description"));
        transaction.setStatus(rs.getString("status"));
        
        Timestamp timestamp = rs.getTimestamp("transaction_date");
        if (timestamp != null) {
            transaction.setTransactionDate(timestamp.toLocalDateTime());
        }
        
        return transaction;
    }
}
