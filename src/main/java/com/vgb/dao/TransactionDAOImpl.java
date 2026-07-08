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
        "INSERT INTO transaction (from_account_id, to_account_id, transaction_type, amount, reference_number, description, status, transfer_mode, sender_account_number, receiver_account_number, beneficiary_name, beneficiary_ifsc, beneficiary_bank, beneficiary_branch, performed_by_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
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
        try {
            conn = dbConfig.getConnection();
            return create(conn, transaction);
        } catch (SQLException e) {
            logger.error("Error creating transaction", e);
            throw new Exception("Failed to create transaction", e);
        } finally {
            DatabaseConfig.closeConnection(conn);
        }
    }

    public boolean create(Connection conn, Transaction transaction) throws SQLException {
        PreparedStatement stmt = null;
        try {
            stmt = conn.prepareStatement(CREATE_TRANSACTION, Statement.RETURN_GENERATED_KEYS);
            stmt.setObject(1, transaction.getFromAccountId(), Types.BIGINT);
            stmt.setObject(2, transaction.getToAccountId(), Types.BIGINT);
            stmt.setString(3, transaction.getTransactionType());
            stmt.setBigDecimal(4, transaction.getAmount());
            stmt.setString(5, transaction.getReferenceNumber());
            stmt.setString(6, transaction.getDescription());
            stmt.setString(7, transaction.getStatus());
            stmt.setString(8, transaction.getTransferMode());
            stmt.setString(9, transaction.getSenderAccountNumber());
            stmt.setString(10, transaction.getReceiverAccountNumber());
            stmt.setString(11, transaction.getBeneficiaryName());
            stmt.setString(12, transaction.getBeneficiaryIfsc());
            stmt.setString(13, transaction.getBeneficiaryBank());
            stmt.setString(14, transaction.getBeneficiaryBranch());
            stmt.setObject(15, transaction.getPerformedById(), Types.BIGINT);

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
        } finally {
            DatabaseConfig.closeStatement(stmt);
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

        try {
            transaction.setTransferMode(rs.getString("transfer_mode"));
            transaction.setSenderAccountNumber(rs.getString("sender_account_number"));
            transaction.setReceiverAccountNumber(rs.getString("receiver_account_number"));
            transaction.setBeneficiaryName(rs.getString("beneficiary_name"));
            transaction.setBeneficiaryIfsc(rs.getString("beneficiary_ifsc"));
            transaction.setBeneficiaryBank(rs.getString("beneficiary_bank"));
            transaction.setBeneficiaryBranch(rs.getString("beneficiary_branch"));
            Object perfBy = rs.getObject("performed_by_id");
            if (perfBy != null) {
                transaction.setPerformedById(rs.getLong("performed_by_id"));
            }
        } catch (SQLException e) {
            // Ignore if column doesn't exist
        }
        
        return transaction;
    }

    @Override
    public List<Transaction> searchTransactions(String customerName, String accountNumber, String transactionType, String status, String dateFilter, String startDateStr, String endDateStr, String queryText) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Transaction> transactions = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
            "SELECT DISTINCT t.* FROM transaction t " +
            "LEFT JOIN account a_from ON t.from_account_id = a_from.account_id " +
            "LEFT JOIN account_signatory sig_from ON a_from.account_id = sig_from.account_id " +
            "LEFT JOIN customer cust_from ON sig_from.customer_id = cust_from.customer_id " +
            "LEFT JOIN account_current curr_from ON a_from.account_id = curr_from.account_id " +
            "LEFT JOIN account a_to ON t.to_account_id = a_to.account_id " +
            "LEFT JOIN account_signatory sig_to ON a_to.account_id = sig_to.account_id " +
            "LEFT JOIN customer cust_to ON sig_to.customer_id = cust_to.customer_id " +
            "LEFT JOIN account_current curr_to ON a_to.account_id = curr_to.account_id " +
            "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        if (customerName != null && !customerName.trim().isEmpty()) {
            sql.append("AND (CONCAT(cust_from.first_name, ' ', cust_from.last_name) LIKE ? OR CONCAT(cust_to.first_name, ' ', cust_to.last_name) LIKE ? OR curr_from.business_name LIKE ? OR curr_to.business_name LIKE ?) ");
            String searchPattern = "%" + customerName.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }

        if (accountNumber != null && !accountNumber.trim().isEmpty()) {
            sql.append("AND (t.sender_account_number = ? OR t.receiver_account_number = ? OR a_from.account_number = ? OR a_to.account_number = ?) ");
            String accNum = accountNumber.trim();
            params.add(accNum);
            params.add(accNum);
            params.add(accNum);
            params.add(accNum);
        }

        if (transactionType != null && !transactionType.trim().isEmpty() && !"all".equalsIgnoreCase(transactionType)) {
            sql.append("AND t.transaction_type = ? ");
            params.add(transactionType.trim().toLowerCase());
        }

        if (status != null && !status.trim().isEmpty() && !"all".equalsIgnoreCase(status)) {
            sql.append("AND t.status = ? ");
            params.add(status.trim().toLowerCase());
        }

        if (dateFilter != null && !dateFilter.trim().isEmpty() && !"all".equalsIgnoreCase(dateFilter)) {
            if ("today".equalsIgnoreCase(dateFilter)) {
                sql.append("AND t.transaction_date >= CURDATE() ");
            } else if ("month".equalsIgnoreCase(dateFilter)) {
                sql.append("AND t.transaction_date >= DATE_FORMAT(CURDATE(), '%Y-%m-01') ");
            } else if ("year".equalsIgnoreCase(dateFilter)) {
                sql.append("AND t.transaction_date >= DATE_FORMAT(CURDATE(), '%Y-01-01') ");
            } else if ("custom".equalsIgnoreCase(dateFilter)) {
                if (startDateStr != null && !startDateStr.trim().isEmpty()) {
                    sql.append("AND t.transaction_date >= ? ");
                    params.add(Timestamp.valueOf(startDateStr.trim() + " 00:00:00"));
                }
                if (endDateStr != null && !endDateStr.trim().isEmpty()) {
                    sql.append("AND t.transaction_date <= ? ");
                    params.add(Timestamp.valueOf(endDateStr.trim() + " 23:59:59"));
                }
            }
        }

        if (queryText != null && !queryText.trim().isEmpty()) {
            sql.append("AND (t.transaction_id = ? OR t.reference_number = ?) ");
            String q = queryText.trim();
            long queryId = 0;
            try {
                queryId = Long.parseLong(q);
            } catch (NumberFormatException e) {
                // Not a number, ignore ID match
            }
            params.add(queryId);
            params.add(q);
        }

        sql.append("ORDER BY t.transaction_date DESC");

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            rs = stmt.executeQuery();

            while (rs.next()) {
                transactions.add(mapResultSetToTransaction(rs));
            }
            return transactions;
        } catch (SQLException e) {
            logger.error("Error executing searchTransactions", e);
            throw new Exception("Failed to query transactions ledger list: " + e.getMessage(), e);
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }
}
