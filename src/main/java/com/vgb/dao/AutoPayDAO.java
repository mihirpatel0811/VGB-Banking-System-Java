package com.vgb.dao;

import com.vgb.config.DatabaseConfig;
import com.vgb.model.AutoPayInstruction;
import com.vgb.model.AutoPayHistory;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AutoPayDAO {

    public boolean createInstruction(AutoPayInstruction instruction) throws SQLException {
        String sql = "INSERT INTO auto_pay_instruction (customer_id, target_type, card_id, loan_id, source_account_id, payment_type, payment_frequency, next_payment_date, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DatabaseConfig.getInstance().getConnection();
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setLong(1, instruction.getCustomerId());
            stmt.setString(2, instruction.getTargetType());
            if (instruction.getCardId() != null) {
                stmt.setLong(3, instruction.getCardId());
            } else {
                stmt.setNull(3, Types.BIGINT);
            }
            if (instruction.getLoanId() != null) {
                stmt.setLong(4, instruction.getLoanId());
            } else {
                stmt.setNull(4, Types.BIGINT);
            }
            stmt.setLong(5, instruction.getSourceAccountId());
            stmt.setString(6, instruction.getPaymentType());
            stmt.setString(7, instruction.getPaymentFrequency());
            stmt.setDate(8, instruction.getNextPaymentDate());
            stmt.setString(9, instruction.getStatus());

            int affected = stmt.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        instruction.setAutoPayId(rs.getLong(1));
                    }
                }
                return true;
            }
            return false;
        } finally {
            DatabaseConfig.closeStatement(stmt);
            DatabaseConfig.closeConnection(conn);
        }
    }

    public boolean updateInstruction(Connection conn, AutoPayInstruction instruction) throws SQLException {
        String sql = "UPDATE auto_pay_instruction SET source_account_id = ?, payment_type = ?, next_payment_date = ?, status = ?, last_processed_date = ? WHERE auto_pay_id = ?";
        PreparedStatement stmt = null;
        try {
            stmt = conn.prepareStatement(sql);
            stmt.setLong(1, instruction.getSourceAccountId());
            stmt.setString(2, instruction.getPaymentType());
            stmt.setDate(3, instruction.getNextPaymentDate());
            stmt.setString(4, instruction.getStatus());
            stmt.setTimestamp(5, instruction.getLastProcessedDate());
            stmt.setLong(6, instruction.getAutoPayId());
            return stmt.executeUpdate() > 0;
        } finally {
            DatabaseConfig.closeStatement(stmt);
        }
    }

    public boolean updateInstructionStatus(long autoPayId, String status) throws SQLException {
        String sql = "UPDATE auto_pay_instruction SET status = ? WHERE auto_pay_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DatabaseConfig.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, status);
            stmt.setLong(2, autoPayId);
            return stmt.executeUpdate() > 0;
        } finally {
            DatabaseConfig.closeStatement(stmt);
            DatabaseConfig.closeConnection(conn);
        }
    }

    public boolean deleteInstruction(long autoPayId) throws SQLException {
        String sql = "DELETE FROM auto_pay_instruction WHERE auto_pay_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DatabaseConfig.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setLong(1, autoPayId);
            return stmt.executeUpdate() > 0;
        } finally {
            DatabaseConfig.closeStatement(stmt);
            DatabaseConfig.closeConnection(conn);
        }
    }

    public AutoPayInstruction getInstructionById(long autoPayId) throws SQLException {
        String sql = "SELECT api.*, c.card_number, c.card_holder_name, c.outstanding_balance AS card_outstanding, " +
                     "l.loan_type, l.remaining_balance AS loan_remaining, " +
                     "a.account_number AS source_account_number, cust.first_name, cust.last_name " +
                     "FROM auto_pay_instruction api " +
                     "JOIN customer cust ON api.customer_id = cust.customer_id " +
                     "JOIN account a ON api.source_account_id = a.account_id " +
                     "LEFT JOIN card c ON api.card_id = c.card_id " +
                     "LEFT JOIN loan l ON api.loan_id = l.loan_id " +
                     "WHERE api.auto_pay_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DatabaseConfig.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setLong(1, autoPayId);
            rs = stmt.executeQuery();
            if (rs.next()) {
                return mapInstruction(rs);
            }
            return null;
        } finally {
            DatabaseConfig.closeResultSet(rs);
            DatabaseConfig.closeStatement(stmt);
            DatabaseConfig.closeConnection(conn);
        }
    }

    public List<AutoPayInstruction> getInstructionsByCustomerId(long customerId) throws SQLException {
        String sql = "SELECT api.*, c.card_number, c.card_holder_name, c.outstanding_balance AS card_outstanding, " +
                     "l.loan_type, l.remaining_balance AS loan_remaining, " +
                     "a.account_number AS source_account_number, cust.first_name, cust.last_name " +
                     "FROM auto_pay_instruction api " +
                     "JOIN customer cust ON api.customer_id = cust.customer_id " +
                     "JOIN account a ON api.source_account_id = a.account_id " +
                     "LEFT JOIN card c ON api.card_id = c.card_id " +
                     "LEFT JOIN loan l ON api.loan_id = l.loan_id " +
                     "WHERE api.customer_id = ? " +
                     "ORDER BY api.created_at DESC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DatabaseConfig.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setLong(1, customerId);
            rs = stmt.executeQuery();
            List<AutoPayInstruction> list = new ArrayList<>();
            while (rs.next()) {
                list.add(mapInstruction(rs));
            }
            return list;
        } finally {
            DatabaseConfig.closeResultSet(rs);
            DatabaseConfig.closeStatement(stmt);
            DatabaseConfig.closeConnection(conn);
        }
    }

    public List<AutoPayInstruction> getDueInstructions(Connection conn, Date date) throws SQLException {
        String sql = "SELECT api.*, c.card_number, c.card_holder_name, c.outstanding_balance AS card_outstanding, " +
                     "l.loan_type, l.remaining_balance AS loan_remaining, " +
                     "a.account_number AS source_account_number, cust.first_name, cust.last_name " +
                     "FROM auto_pay_instruction api " +
                     "JOIN customer cust ON api.customer_id = cust.customer_id " +
                     "JOIN account a ON api.source_account_id = a.account_id " +
                     "LEFT JOIN card c ON api.card_id = c.card_id " +
                     "LEFT JOIN loan l ON api.loan_id = l.loan_id " +
                     "WHERE api.status = 'active' AND api.next_payment_date <= ?";
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            stmt = conn.prepareStatement(sql);
            stmt.setDate(1, date);
            rs = stmt.executeQuery();
            List<AutoPayInstruction> list = new ArrayList<>();
            while (rs.next()) {
                list.add(mapInstruction(rs));
            }
            return list;
        } finally {
            DatabaseConfig.closeResultSet(rs);
            DatabaseConfig.closeStatement(stmt);
        }
    }

    public boolean createHistoryEntry(Connection conn, AutoPayHistory entry) throws SQLException {
        String sql = "INSERT INTO auto_pay_history (auto_pay_id, amount, status, failure_reason, transaction_reference) VALUES (?, ?, ?, ?, ?)";
        PreparedStatement stmt = null;
        try {
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setLong(1, entry.getAutoPayId());
            stmt.setBigDecimal(2, entry.getAmount());
            stmt.setString(3, entry.getStatus());
            stmt.setString(4, entry.getFailureReason());
            stmt.setString(5, entry.getTransactionReference());

            int affected = stmt.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        entry.setHistoryId(rs.getLong(1));
                    }
                }
                return true;
            }
            return false;
        } finally {
            DatabaseConfig.closeStatement(stmt);
        }
    }

    public List<AutoPayHistory> getHistoryByCustomerId(long customerId, int limit, int offset) throws SQLException {
        String sql = "SELECT h.*, api.target_type, api.payment_type, c.card_number, l.loan_type, " +
                     "a.account_number AS source_account_number, cust.first_name, cust.last_name " +
                     "FROM auto_pay_history h " +
                     "JOIN auto_pay_instruction api ON h.auto_pay_id = api.auto_pay_id " +
                     "JOIN customer cust ON api.customer_id = cust.customer_id " +
                     "JOIN account a ON api.source_account_id = a.account_id " +
                     "LEFT JOIN card c ON api.card_id = c.card_id " +
                     "LEFT JOIN loan l ON api.loan_id = l.loan_id " +
                     "WHERE api.customer_id = ? " +
                     "ORDER BY h.payment_date DESC " +
                     "LIMIT ? OFFSET ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DatabaseConfig.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setLong(1, customerId);
            stmt.setInt(2, limit);
            stmt.setInt(3, offset);
            rs = stmt.executeQuery();
            List<AutoPayHistory> list = new ArrayList<>();
            while (rs.next()) {
                list.add(mapHistory(rs));
            }
            return list;
        } finally {
            DatabaseConfig.closeResultSet(rs);
            DatabaseConfig.closeStatement(stmt);
            DatabaseConfig.closeConnection(conn);
        }
    }

    public int countHistoryByCustomerId(long customerId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM auto_pay_history h " +
                     "JOIN auto_pay_instruction api ON h.auto_pay_id = api.auto_pay_id " +
                     "WHERE api.customer_id = ?";
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
            DatabaseConfig.closeResultSet(rs);
            DatabaseConfig.closeStatement(stmt);
            DatabaseConfig.closeConnection(conn);
        }
    }

    public List<AutoPayInstruction> getAllInstructions(String search, String status, String targetType, int limit, int offset) throws SQLException {
        StringBuilder sql = new StringBuilder(
            "SELECT api.*, c.card_number, c.card_holder_name, c.outstanding_balance AS card_outstanding, " +
            "l.loan_type, l.remaining_balance AS loan_remaining, " +
            "a.account_number AS source_account_number, cust.first_name, cust.last_name " +
            "FROM auto_pay_instruction api " +
            "JOIN customer cust ON api.customer_id = cust.customer_id " +
            "JOIN account a ON api.source_account_id = a.account_id " +
            "LEFT JOIN card c ON api.card_id = c.card_id " +
            "LEFT JOIN loan l ON api.loan_id = l.loan_id " +
            "WHERE 1=1 "
        );
        List<Object> params = new ArrayList<>();
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (cust.first_name LIKE ? OR cust.last_name LIKE ? OR c.card_number LIKE ? OR a.account_number LIKE ?) ");
            String likeParam = "%" + search.trim() + "%";
            params.add(likeParam);
            params.add(likeParam);
            params.add(likeParam);
            params.add(likeParam);
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND api.status = ? ");
            params.add(status.trim());
        }
        if (targetType != null && !targetType.trim().isEmpty()) {
            sql.append("AND api.target_type = ? ");
            params.add(targetType.trim());
        }
        sql.append("ORDER BY api.created_at DESC LIMIT ? OFFSET ?");

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DatabaseConfig.getInstance().getConnection();
            stmt = conn.prepareStatement(sql.toString());
            int idx = 1;
            for (Object param : params) {
                stmt.setObject(idx++, param);
            }
            stmt.setInt(idx++, limit);
            stmt.setInt(idx++, offset);
            rs = stmt.executeQuery();
            List<AutoPayInstruction> list = new ArrayList<>();
            while (rs.next()) {
                list.add(mapInstruction(rs));
            }
            return list;
        } finally {
            DatabaseConfig.closeResultSet(rs);
            DatabaseConfig.closeStatement(stmt);
            DatabaseConfig.closeConnection(conn);
        }
    }

    public int countAllInstructions(String search, String status, String targetType) throws SQLException {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) FROM auto_pay_instruction api " +
            "JOIN customer cust ON api.customer_id = cust.customer_id " +
            "LEFT JOIN card c ON api.card_id = c.card_id " +
            "JOIN account a ON api.source_account_id = a.account_id " +
            "WHERE 1=1 "
        );
        List<Object> params = new ArrayList<>();
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (cust.first_name LIKE ? OR cust.last_name LIKE ? OR c.card_number LIKE ? OR a.account_number LIKE ?) ");
            String likeParam = "%" + search.trim() + "%";
            params.add(likeParam);
            params.add(likeParam);
            params.add(likeParam);
            params.add(likeParam);
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND api.status = ? ");
            params.add(status.trim());
        }
        if (targetType != null && !targetType.trim().isEmpty()) {
            sql.append("AND api.target_type = ? ");
            params.add(targetType.trim());
        }

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DatabaseConfig.getInstance().getConnection();
            stmt = conn.prepareStatement(sql.toString());
            int idx = 1;
            for (Object param : params) {
                stmt.setObject(idx++, param);
            }
            rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        } finally {
            DatabaseConfig.closeResultSet(rs);
            DatabaseConfig.closeStatement(stmt);
            DatabaseConfig.closeConnection(conn);
        }
    }

    public List<AutoPayHistory> getAllHistory(String search, String status, String type, int limit, int offset) throws SQLException {
        StringBuilder sql = new StringBuilder(
            "SELECT h.*, api.target_type, api.payment_type, c.card_number, l.loan_type, " +
            "a.account_number AS source_account_number, cust.first_name, cust.last_name " +
            "FROM auto_pay_history h " +
            "JOIN auto_pay_instruction api ON h.auto_pay_id = api.auto_pay_id " +
            "JOIN customer cust ON api.customer_id = cust.customer_id " +
            "JOIN account a ON api.source_account_id = a.account_id " +
            "LEFT JOIN card c ON api.card_id = c.card_id " +
            "LEFT JOIN loan l ON api.loan_id = l.loan_id " +
            "WHERE 1=1 "
        );
        List<Object> params = new ArrayList<>();
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (cust.first_name LIKE ? OR cust.last_name LIKE ? OR c.card_number LIKE ? OR h.transaction_reference LIKE ?) ");
            String likeParam = "%" + search.trim() + "%";
            params.add(likeParam);
            params.add(likeParam);
            params.add(likeParam);
            params.add(likeParam);
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND h.status = ? ");
            params.add(status.trim());
        }
        if (type != null && !type.trim().isEmpty()) {
            sql.append("AND api.target_type = ? ");
            params.add(type.trim());
        }
        sql.append("ORDER BY h.payment_date DESC LIMIT ? OFFSET ?");

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DatabaseConfig.getInstance().getConnection();
            stmt = conn.prepareStatement(sql.toString());
            int idx = 1;
            for (Object param : params) {
                stmt.setObject(idx++, param);
            }
            stmt.setInt(idx++, limit);
            stmt.setInt(idx++, offset);
            rs = stmt.executeQuery();
            List<AutoPayHistory> list = new ArrayList<>();
            while (rs.next()) {
                list.add(mapHistory(rs));
            }
            return list;
        } finally {
            DatabaseConfig.closeResultSet(rs);
            DatabaseConfig.closeStatement(stmt);
            DatabaseConfig.closeConnection(conn);
        }
    }

    public int countAllHistory(String search, String status, String type) throws SQLException {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) FROM auto_pay_history h " +
            "JOIN auto_pay_instruction api ON h.auto_pay_id = api.auto_pay_id " +
            "JOIN customer cust ON api.customer_id = cust.customer_id " +
            "LEFT JOIN card c ON api.card_id = c.card_id " +
            "WHERE 1=1 "
        );
        List<Object> params = new ArrayList<>();
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (cust.first_name LIKE ? OR cust.last_name LIKE ? OR c.card_number LIKE ? OR h.transaction_reference LIKE ?) ");
            String likeParam = "%" + search.trim() + "%";
            params.add(likeParam);
            params.add(likeParam);
            params.add(likeParam);
            params.add(likeParam);
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND h.status = ? ");
            params.add(status.trim());
        }
        if (type != null && !type.trim().isEmpty()) {
            sql.append("AND api.target_type = ? ");
            params.add(type.trim());
        }

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DatabaseConfig.getInstance().getConnection();
            stmt = conn.prepareStatement(sql.toString());
            int idx = 1;
            for (Object param : params) {
                stmt.setObject(idx++, param);
            }
            rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        } finally {
            DatabaseConfig.closeResultSet(rs);
            DatabaseConfig.closeStatement(stmt);
            DatabaseConfig.closeConnection(conn);
        }
    }

    private AutoPayInstruction mapInstruction(ResultSet rs) throws SQLException {
        AutoPayInstruction ins = new AutoPayInstruction();
        ins.setAutoPayId(rs.getLong("auto_pay_id"));
        ins.setCustomerId(rs.getLong("customer_id"));
        ins.setTargetType(rs.getString("target_type"));
        ins.setCardId(rs.getLong("card_id"));
        if (rs.wasNull()) ins.setCardId(null);
        ins.setLoanId(rs.getLong("loan_id"));
        if (rs.wasNull()) ins.setLoanId(null);
        ins.setSourceAccountId(rs.getLong("source_account_id"));
        ins.setPaymentType(rs.getString("payment_type"));
        ins.setPaymentFrequency(rs.getString("payment_frequency"));
        ins.setNextPaymentDate(rs.getDate("next_payment_date"));
        ins.setStatus(rs.getString("status"));
        ins.setLastProcessedDate(rs.getTimestamp("last_processed_date"));
        ins.setCreatedAt(rs.getTimestamp("created_at"));
        ins.setUpdatedAt(rs.getTimestamp("updated_at"));

        // Join properties
        ins.setCustomerName(rs.getString("first_name") + " " + rs.getString("last_name"));
        String sourceAcc = rs.getString("source_account_number");
        if (sourceAcc != null && sourceAcc.length() >= 4) {
            ins.setMaskedSourceAccountNumber("••••" + sourceAcc.substring(sourceAcc.length() - 4));
        } else {
            ins.setMaskedSourceAccountNumber(sourceAcc);
        }

        if ("credit_card".equals(ins.getTargetType())) {
            String cNo = rs.getString("card_number");
            if (cNo != null && cNo.length() >= 4) {
                ins.setMaskedCardNumber("•••• " + cNo.substring(cNo.length() - 4));
            }
            ins.setOutstandingDues(rs.getBigDecimal("card_outstanding"));
        } else {
            ins.setLoanType(rs.getString("loan_type"));
            ins.setOutstandingDues(rs.getBigDecimal("loan_remaining"));
        }
        return ins;
    }

    private AutoPayHistory mapHistory(ResultSet rs) throws SQLException {
        AutoPayHistory h = new AutoPayHistory();
        h.setHistoryId(rs.getLong("history_id"));
        h.setAutoPayId(rs.getLong("auto_pay_id"));
        h.setPaymentDate(rs.getTimestamp("payment_date"));
        h.setAmount(rs.getBigDecimal("amount"));
        h.setStatus(rs.getString("status"));
        h.setFailureReason(rs.getString("failure_reason"));
        h.setTransactionReference(rs.getString("transaction_reference"));

        h.setCustomerName(rs.getString("first_name") + " " + rs.getString("last_name"));
        h.setTargetType(rs.getString("target_type"));
        h.setPaymentType(rs.getString("payment_type"));
        
        String sourceAcc = rs.getString("source_account_number");
        if (sourceAcc != null && sourceAcc.length() >= 4) {
            h.setMaskedSourceAccountNumber("••••" + sourceAcc.substring(sourceAcc.length() - 4));
        }

        if ("credit_card".equals(h.getTargetType())) {
            String cNo = rs.getString("card_number");
            if (cNo != null && cNo.length() >= 4) {
                h.setMaskedCardNumber("•••• " + cNo.substring(cNo.length() - 4));
            }
        } else {
            h.setLoanType(rs.getString("loan_type"));
        }
        return h;
    }
}
