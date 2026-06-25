package com.vgb.dao;

import com.vgb.config.DatabaseConfig;
import com.vgb.model.PassbookRequest;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PassbookRequestDAOImpl {

    public boolean create(PassbookRequest request) throws SQLException {
        String sql = "INSERT INTO passbook_request (account_id, customer_id, request_type, status, charges, is_charges_paid) VALUES (?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DatabaseConfig.getInstance().getConnection();
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setLong(1, request.getAccountId());
            stmt.setLong(2, request.getCustomerId());
            stmt.setString(3, request.getRequestType());
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

    public PassbookRequest getById(long requestId) throws SQLException {
        String sql = "SELECT pr.*, a.account_number, a.account_type, a.ifsc_code, CONCAT(cust.first_name, ' ', cust.last_name) AS customer_name, cust.phone_no, COALESCE(sav.nominee_name, curr.business_name, 'None') AS nominee_name " +
                     "FROM passbook_request pr " +
                     "JOIN account a ON pr.account_id = a.account_id " +
                     "JOIN customer cust ON pr.customer_id = cust.customer_id " +
                     "LEFT JOIN account_savings sav ON a.account_id = sav.account_id " +
                     "LEFT JOIN account_current curr ON a.account_id = curr.account_id " +
                     "WHERE pr.request_id = ?";
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

    public List<PassbookRequest> getByCustomerId(long customerId) throws SQLException {
        String sql = "SELECT pr.*, a.account_number, a.account_type, a.ifsc_code, CONCAT(cust.first_name, ' ', cust.last_name) AS customer_name, cust.phone_no, COALESCE(sav.nominee_name, curr.business_name, 'None') AS nominee_name " +
                     "FROM passbook_request pr " +
                     "JOIN account a ON pr.account_id = a.account_id " +
                     "JOIN customer cust ON pr.customer_id = cust.customer_id " +
                     "LEFT JOIN account_savings sav ON a.account_id = sav.account_id " +
                     "LEFT JOIN account_current curr ON a.account_id = curr.account_id " +
                     "WHERE pr.customer_id = ? " +
                     "ORDER BY pr.requested_at DESC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<PassbookRequest> list = new ArrayList<>();
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

    public List<PassbookRequest> getAll() throws SQLException {
        String sql = "SELECT pr.*, a.account_number, a.account_type, a.ifsc_code, CONCAT(cust.first_name, ' ', cust.last_name) AS customer_name, cust.phone_no, COALESCE(sav.nominee_name, curr.business_name, 'None') AS nominee_name " +
                     "FROM passbook_request pr " +
                     "JOIN account a ON pr.account_id = a.account_id " +
                     "JOIN customer cust ON pr.customer_id = cust.customer_id " +
                     "LEFT JOIN account_savings sav ON a.account_id = sav.account_id " +
                     "LEFT JOIN account_current curr ON a.account_id = curr.account_id " +
                     "ORDER BY pr.requested_at DESC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<PassbookRequest> list = new ArrayList<>();
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
        String sql = "UPDATE passbook_request SET status = ? WHERE request_id = ?";
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
        String sql = "UPDATE passbook_request SET is_charges_paid = ? WHERE request_id = ?";
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

    private PassbookRequest mapResultSetToRequest(ResultSet rs) throws SQLException {
        PassbookRequest request = new PassbookRequest();
        request.setRequestId(rs.getLong("request_id"));
        request.setAccountId(rs.getLong("account_id"));
        request.setCustomerId(rs.getLong("customer_id"));
        request.setRequestType(rs.getString("request_type"));
        request.setStatus(rs.getString("status"));
        request.setCharges(rs.getBigDecimal("charges"));
        request.setChargesPaid(rs.getInt("is_charges_paid") == 1);
        request.setRequestedAt(rs.getTimestamp("requested_at"));

        try {
            request.setAccountNumber(rs.getString("account_number"));
            request.setAccountType(rs.getString("account_type"));
            request.setCustomerName(rs.getString("customer_name"));
            request.setIfscCode(rs.getString("ifsc_code"));
            request.setPhoneNo(rs.getString("phone_no"));
            request.setNomineeName(rs.getString("nominee_name"));
        } catch (SQLException e) {
            // Optional columns, skip if not mapped in SELECT
        }

        return request;
    }
}
