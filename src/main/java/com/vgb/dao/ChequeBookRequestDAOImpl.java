package com.vgb.dao;

import com.vgb.config.DatabaseConfig;
import com.vgb.model.ChequeBookRequest;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ChequeBookRequestDAOImpl {

    public boolean create(ChequeBookRequest request) throws SQLException {
        String sql = "INSERT INTO cheque_book_request (account_id, customer_id, leaves_count, status, charges, is_charges_paid) VALUES (?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DatabaseConfig.getInstance().getConnection();
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setLong(1, request.getAccountId());
            stmt.setLong(2, request.getCustomerId());
            stmt.setInt(3, request.getLeavesCount());
            stmt.setString(4, request.getStatus());
            stmt.setBigDecimal(5, request.getCharges());
            stmt.setInt(6, request.isChargesPaid() ? 1 : 0);

            int affected = stmt.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        request.setRequestId(rs.getLong(1));
                    }
                }
                return true;
            }
            return false;
        } finally {
            DatabaseConfig.closeResources(null, stmt, conn);
        }
    }

    public ChequeBookRequest getById(long requestId) throws SQLException {
        String sql = "SELECT cbr.*, a.account_number, a.account_type, CONCAT(cust.first_name, ' ', cust.last_name) AS customer_name " +
                     "FROM cheque_book_request cbr " +
                     "JOIN account a ON cbr.account_id = a.account_id " +
                     "JOIN customer cust ON cbr.customer_id = cust.customer_id " +
                     "WHERE cbr.request_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DatabaseConfig.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setLong(1, requestId);
            rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToRequest(rs);
            }
            return null;
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    public List<ChequeBookRequest> getByCustomerId(long customerId) throws SQLException {
        String sql = "SELECT cbr.*, a.account_number, a.account_type, CONCAT(cust.first_name, ' ', cust.last_name) AS customer_name " +
                     "FROM cheque_book_request cbr " +
                     "JOIN account a ON cbr.account_id = a.account_id " +
                     "JOIN customer cust ON cbr.customer_id = cust.customer_id " +
                     "WHERE cbr.customer_id = ? " +
                     "ORDER BY cbr.requested_at DESC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<ChequeBookRequest> list = new ArrayList<>();
        try {
            conn = DatabaseConfig.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setLong(1, customerId);
            rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToRequest(rs));
            }
            return list;
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    public List<ChequeBookRequest> getByAccountId(long accountId) throws SQLException {
        String sql = "SELECT cbr.*, a.account_number, a.account_type, CONCAT(cust.first_name, ' ', cust.last_name) AS customer_name " +
                     "FROM cheque_book_request cbr " +
                     "JOIN account a ON cbr.account_id = a.account_id " +
                     "JOIN customer cust ON cbr.customer_id = cust.customer_id " +
                     "WHERE cbr.account_id = ? " +
                     "ORDER BY cbr.requested_at DESC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<ChequeBookRequest> list = new ArrayList<>();
        try {
            conn = DatabaseConfig.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setLong(1, accountId);
            rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToRequest(rs));
            }
            return list;
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    public List<ChequeBookRequest> getAll() throws SQLException {
        String sql = "SELECT cbr.*, a.account_number, a.account_type, CONCAT(cust.first_name, ' ', cust.last_name) AS customer_name " +
                     "FROM cheque_book_request cbr " +
                     "JOIN account a ON cbr.account_id = a.account_id " +
                     "JOIN customer cust ON cbr.customer_id = cust.customer_id " +
                     "ORDER BY cbr.requested_at DESC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<ChequeBookRequest> list = new ArrayList<>();
        try {
            conn = DatabaseConfig.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToRequest(rs));
            }
            return list;
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    public boolean updateStatus(long requestId, String status) throws SQLException {
        String sql = "UPDATE cheque_book_request SET status = ? WHERE request_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DatabaseConfig.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, status);
            stmt.setLong(2, requestId);
            return stmt.executeUpdate() > 0;
        } finally {
            DatabaseConfig.closeResources(null, stmt, conn);
        }
    }

    public boolean updateChargesPaidStatus(long requestId, boolean isChargesPaid) throws SQLException {
        String sql = "UPDATE cheque_book_request SET is_charges_paid = ? WHERE request_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DatabaseConfig.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, isChargesPaid ? 1 : 0);
            stmt.setLong(2, requestId);
            return stmt.executeUpdate() > 0;
        } finally {
            DatabaseConfig.closeResources(null, stmt, conn);
        }
    }

    private ChequeBookRequest mapResultSetToRequest(ResultSet rs) throws SQLException {
        ChequeBookRequest request = new ChequeBookRequest();
        request.setRequestId(rs.getLong("request_id"));
        request.setAccountId(rs.getLong("account_id"));
        request.setCustomerId(rs.getLong("customer_id"));
        request.setLeavesCount(rs.getInt("leaves_count"));
        request.setStatus(rs.getString("status"));
        request.setCharges(rs.getBigDecimal("charges"));
        request.setChargesPaid(rs.getInt("is_charges_paid") == 1);
        request.setRequestedAt(rs.getTimestamp("requested_at"));

        try {
            request.setAccountNumber(rs.getString("account_number"));
            request.setAccountType(rs.getString("account_type"));
            request.setCustomerName(rs.getString("customer_name"));
        } catch (SQLException e) {
            // Optional, skip if not mapped in the result set
        }

        return request;
    }
}
