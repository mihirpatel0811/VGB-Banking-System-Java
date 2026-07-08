package com.vgb.dao;

import com.vgb.config.DatabaseConfig;
import com.vgb.model.ChequeBook;
import com.vgb.model.ChequeLeaf;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ChequeBookDAOImpl {

    public boolean createChequeBook(Connection conn, ChequeBook cb) throws SQLException {
        String sql = "INSERT INTO cheque_book (account_id, chequebook_number, start_cheque_no, end_cheque_no, status) VALUES (?, ?, ?, ?, ?)";
        PreparedStatement stmt = null;
        try {
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setLong(1, cb.getAccountId());
            stmt.setString(2, cb.getChequebookNumber());
            stmt.setInt(3, cb.getStartChequeNo());
            stmt.setInt(4, cb.getEndChequeNo());
            stmt.setString(5, cb.getStatus());

            int affected = stmt.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        cb.setChequebookId(rs.getLong(1));
                    }
                }
                return true;
            }
            return false;
        } finally {
            DatabaseConfig.closeStatement(stmt);
        }
    }

    public boolean createChequeLeaves(Connection conn, List<ChequeLeaf> leaves) throws SQLException {
        String sql = "INSERT INTO cheque_leaf (chequebook_id, cheque_number, status) VALUES (?, ?, ?)";
        PreparedStatement stmt = null;
        try {
            stmt = conn.prepareStatement(sql);
            for (ChequeLeaf leaf : leaves) {
                stmt.setLong(1, leaf.getChequebookId());
                stmt.setString(2, leaf.getChequeNumber());
                stmt.setString(3, leaf.getStatus());
                stmt.addBatch();
            }
            int[] results = stmt.executeBatch();
            return results.length == leaves.size();
        } finally {
            DatabaseConfig.closeStatement(stmt);
        }
    }

    public List<ChequeBook> getActiveChequeBooksByAccount(long accountId) throws SQLException {
        String sql = "SELECT * FROM cheque_book WHERE account_id = ? AND status = 'active' ORDER BY created_at DESC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<ChequeBook> list = new ArrayList<>();
        try {
            conn = DatabaseConfig.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setLong(1, accountId);
            rs = stmt.executeQuery();
            while (rs.next()) {
                ChequeBook cb = new ChequeBook();
                cb.setChequebookId(rs.getLong("chequebook_id"));
                cb.setAccountId(rs.getLong("account_id"));
                cb.setChequebookNumber(rs.getString("chequebook_number"));
                cb.setStartChequeNo(rs.getInt("start_cheque_no"));
                cb.setEndChequeNo(rs.getInt("end_cheque_no"));
                cb.setStatus(rs.getString("status"));
                cb.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(cb);
            }
            return list;
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    public List<ChequeLeaf> getUnusedLeavesByChequeBook(long chequebookId) throws SQLException {
        String sql = "SELECT * FROM cheque_leaf WHERE chequebook_id = ? AND status = 'unused' ORDER BY cheque_number ASC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<ChequeLeaf> list = new ArrayList<>();
        try {
            conn = DatabaseConfig.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setLong(1, chequebookId);
            rs = stmt.executeQuery();
            while (rs.next()) {
                ChequeLeaf leaf = new ChequeLeaf();
                leaf.setChequeId(rs.getLong("cheque_id"));
                leaf.setChequebookId(rs.getLong("chequebook_id"));
                leaf.setChequeNumber(rs.getString("cheque_number"));
                leaf.setStatus(rs.getString("status"));
                leaf.setUsedAt(rs.getTimestamp("used_at"));
                list.add(leaf);
            }
            return list;
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    public ChequeLeaf getChequeLeaf(String chequeBookNumber, String chequeNumber) throws SQLException {
        String sql = "SELECT cl.* FROM cheque_leaf cl " +
                     "JOIN cheque_book cb ON cl.chequebook_id = cb.chequebook_id " +
                     "WHERE cb.chequebook_number = ? AND cl.cheque_number = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DatabaseConfig.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, chequeBookNumber);
            stmt.setString(2, chequeNumber);
            rs = stmt.executeQuery();
            if (rs.next()) {
                ChequeLeaf leaf = new ChequeLeaf();
                leaf.setChequeId(rs.getLong("cheque_id"));
                leaf.setChequebookId(rs.getLong("chequebook_id"));
                leaf.setChequeNumber(rs.getString("cheque_number"));
                leaf.setStatus(rs.getString("status"));
                leaf.setUsedAt(rs.getTimestamp("used_at"));
                return leaf;
            }
            return null;
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    public boolean updateChequeLeafStatus(Connection conn, long chequebookId, String chequeNumber, String status) throws SQLException {
        String sql = "UPDATE cheque_leaf SET status = ?, used_at = ? WHERE chequebook_id = ? AND cheque_number = ?";
        PreparedStatement stmt = null;
        try {
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, status);
            stmt.setTimestamp(2, "used".equalsIgnoreCase(status) ? new Timestamp(System.currentTimeMillis()) : null);
            stmt.setLong(3, chequebookId);
            stmt.setString(4, chequeNumber);
            return stmt.executeUpdate() > 0;
        } finally {
            DatabaseConfig.closeStatement(stmt);
        }
    }

    public int getMaxChequeNumberForAccount(long accountId) throws SQLException {
        String sql = "SELECT MAX(end_cheque_no) FROM cheque_book WHERE account_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DatabaseConfig.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setLong(1, accountId);
            rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }
}
