package com.vgb.dao;

import com.vgb.config.DatabaseConfig;
import com.vgb.model.CreditCardRepayment;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CreditCardRepaymentDAO {

    public boolean create(Connection conn, CreditCardRepayment repayment) throws SQLException {
        String sql = "INSERT INTO credit_card_repayment (card_id, customer_id, account_id, amount_paid, payment_option, transaction_reference, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        PreparedStatement stmt = null;
        try {
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setLong(1, repayment.getCardId());
            stmt.setLong(2, repayment.getCustomerId());
            stmt.setLong(3, repayment.getAccountId());
            stmt.setBigDecimal(4, repayment.getAmountPaid());
            stmt.setString(5, repayment.getPaymentOption());
            stmt.setString(6, repayment.getTransactionReference());
            stmt.setString(7, repayment.getStatus());

            int affected = stmt.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        repayment.setRepaymentId(rs.getLong(1));
                    }
                }
                return true;
            }
            return false;
        } finally {
            DatabaseConfig.closeStatement(stmt);
        }
    }

    public CreditCardRepayment getById(long repaymentId) throws SQLException {
        String sql = "SELECT r.*, c.card_number, c.card_holder_name, a.account_number " +
                     "FROM credit_card_repayment r " +
                     "JOIN card c ON r.card_id = c.card_id " +
                     "LEFT JOIN account a ON r.account_id = a.account_id " +
                     "WHERE r.repayment_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DatabaseConfig.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setLong(1, repaymentId);
            rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToRepayment(rs);
            }
            return null;
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    public CreditCardRepayment getByTransactionReference(String reference) throws SQLException {
        String sql = "SELECT r.*, c.card_number, c.card_holder_name, a.account_number " +
                     "FROM credit_card_repayment r " +
                     "JOIN card c ON r.card_id = c.card_id " +
                     "LEFT JOIN account a ON r.account_id = a.account_id " +
                     "WHERE r.transaction_reference = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DatabaseConfig.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, reference);
            rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToRepayment(rs);
            }
            return null;
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    public List<CreditCardRepayment> getByCustomerId(long customerId, int limit, int offset) throws SQLException {
        String sql = "SELECT r.*, c.card_number, c.card_holder_name, a.account_number " +
                     "FROM credit_card_repayment r " +
                     "JOIN card c ON r.card_id = c.card_id " +
                     "LEFT JOIN account a ON r.account_id = a.account_id " +
                     "WHERE r.customer_id = ? " +
                     "ORDER BY r.repayment_date DESC LIMIT ? OFFSET ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<CreditCardRepayment> list = new ArrayList<>();
        try {
            conn = DatabaseConfig.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setLong(1, customerId);
            stmt.setInt(2, limit);
            stmt.setInt(3, offset);
            rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToRepayment(rs));
            }
            return list;
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    public int countByCustomerId(long customerId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM credit_card_repayment WHERE customer_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DatabaseConfig.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setLong(1, customerId);
            rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    public List<CreditCardRepayment> getAllRepayments(String search, String status, String startDate, String endDate, int limit, int offset) throws SQLException {
        StringBuilder sql = new StringBuilder(
            "SELECT r.*, c.card_number, c.card_holder_name, a.account_number " +
            "FROM credit_card_repayment r " +
            "JOIN card c ON r.card_id = c.card_id " +
            "LEFT JOIN account a ON r.account_id = a.account_id " +
            "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (r.customer_id = ? OR c.card_number LIKE ? OR r.transaction_reference LIKE ? OR c.card_holder_name LIKE ?) ");
            String searchPattern = "%" + search.trim() + "%";
            try {
                params.add(Long.parseLong(search.trim()));
            } catch (NumberFormatException e) {
                params.add(-1L); // Not a customer ID
            }
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }

        if (status != null && !status.trim().isEmpty() && !"all".equalsIgnoreCase(status)) {
            sql.append("AND r.status = ? ");
            params.add(status.trim().toLowerCase());
        }

        if (startDate != null && !startDate.trim().isEmpty()) {
            sql.append("AND r.repayment_date >= ? ");
            params.add(Timestamp.valueOf(startDate.trim() + " 00:00:00"));
        }

        if (endDate != null && !endDate.trim().isEmpty()) {
            sql.append("AND r.repayment_date <= ? ");
            params.add(Timestamp.valueOf(endDate.trim() + " 23:59:59"));
        }

        sql.append("ORDER BY r.repayment_date DESC LIMIT ? OFFSET ?");
        params.add(limit);
        params.add(offset);

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<CreditCardRepayment> list = new ArrayList<>();
        try {
            conn = DatabaseConfig.getInstance().getConnection();
            stmt = conn.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToRepayment(rs));
            }
            return list;
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    public int countAllRepayments(String search, String status, String startDate, String endDate) throws SQLException {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) " +
            "FROM credit_card_repayment r " +
            "JOIN card c ON r.card_id = c.card_id " +
            "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (r.customer_id = ? OR c.card_number LIKE ? OR r.transaction_reference LIKE ? OR c.card_holder_name LIKE ?) ");
            String searchPattern = "%" + search.trim() + "%";
            try {
                params.add(Long.parseLong(search.trim()));
            } catch (NumberFormatException e) {
                params.add(-1L);
            }
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }

        if (status != null && !status.trim().isEmpty() && !"all".equalsIgnoreCase(status)) {
            sql.append("AND r.status = ? ");
            params.add(status.trim().toLowerCase());
        }

        if (startDate != null && !startDate.trim().isEmpty()) {
            sql.append("AND r.repayment_date >= ? ");
            params.add(Timestamp.valueOf(startDate.trim() + " 00:00:00"));
        }

        if (endDate != null && !endDate.trim().isEmpty()) {
            sql.append("AND r.repayment_date <= ? ");
            params.add(Timestamp.valueOf(endDate.trim() + " 23:59:59"));
        }

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DatabaseConfig.getInstance().getConnection();
            stmt = conn.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    private CreditCardRepayment mapResultSetToRepayment(ResultSet rs) throws SQLException {
        CreditCardRepayment r = new CreditCardRepayment();
        r.setRepaymentId(rs.getLong("repayment_id"));
        r.setCardId(rs.getLong("card_id"));
        r.setCustomerId(rs.getLong("customer_id"));
        r.setAccountId(rs.getLong("account_id"));
        r.setAmountPaid(rs.getBigDecimal("amount_paid"));
        r.setPaymentOption(rs.getString("payment_option"));
        r.setTransactionReference(rs.getString("transaction_reference"));
        r.setRepaymentDate(rs.getTimestamp("repayment_date"));
        r.setStatus(rs.getString("status"));

        try {
            String rawCard = rs.getString("card_number");
            if (rawCard != null && rawCard.length() >= 16) {
                String clean = rawCard.replace(" ", "");
                r.setMaskedCardNumber("****  ••••  ••••  " + clean.substring(clean.length() - 4));
            } else {
                r.setMaskedCardNumber("••••  ••••  ••••  ••••");
            }
        } catch (SQLException e) {
            // Field optional
        }

        try {
            r.setCardHolderName(rs.getString("card_holder_name"));
        } catch (SQLException e) {
            // Field optional
        }

        try {
            String rawAcc = rs.getString("account_number");
            if (rawAcc != null && rawAcc.length() >= 4) {
                r.setSourceAccountNumber("••••" + rawAcc.substring(rawAcc.length() - 4));
            } else {
                r.setSourceAccountNumber("••••");
            }
        } catch (SQLException e) {
            // Field optional
        }

        return r;
    }

    public java.util.Map<String, Object> getRepaymentStats() throws SQLException {
        String sql = "SELECT COUNT(*) as total_count, " +
                     "SUM(CASE WHEN status = 'completed' THEN amount_paid ELSE 0 END) as total_amount, " +
                     "COUNT(CASE WHEN status = 'completed' THEN 1 END) as completed_count, " +
                     "COUNT(CASE WHEN status = 'failed' THEN 1 END) as failed_count " +
                     "FROM credit_card_repayment";
        java.util.Map<String, Object> stats = new java.util.HashMap<>();
        stats.put("totalCount", 0);
        stats.put("totalAmount", java.math.BigDecimal.ZERO);
        stats.put("completedCount", 0);
        stats.put("failedCount", 0);
        
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        try {
            conn = DatabaseConfig.getInstance().getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            if (rs.next()) {
                stats.put("totalCount", rs.getInt("total_count"));
                java.math.BigDecimal amt = rs.getBigDecimal("total_amount");
                stats.put("totalAmount", amt != null ? amt : java.math.BigDecimal.ZERO);
                stats.put("completedCount", rs.getInt("completed_count"));
                stats.put("failedCount", rs.getInt("failed_count"));
            }
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
        return stats;
    }
}
