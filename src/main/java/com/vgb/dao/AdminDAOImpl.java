package com.vgb.dao;

import com.vgb.config.DatabaseConfig;
import com.vgb.model.Admin;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * AdminDAOImpl: Implementation of AdminDAO interface
 */
@SuppressWarnings("unused")
public class AdminDAOImpl implements AdminDAO {
    private static final Logger logger = LoggerFactory.getLogger(AdminDAOImpl.class);
    private DatabaseConfig dbConfig = DatabaseConfig.getInstance();

    private static final String CREATE_ADMIN = 
        "INSERT INTO admin (username, password, pin, email, is_active) VALUES (?, ?, ?, ?, ?)";
    private static final String GET_ADMIN_BY_ID = 
        "SELECT * FROM admin WHERE admin_id = ?";
    private static final String GET_ADMIN_BY_USERNAME = 
        "SELECT * FROM admin WHERE username = ?";
    private static final String GET_ALL_ADMINS = 
        "SELECT * FROM admin ORDER BY created_at DESC";
    private static final String UPDATE_ADMIN = 
        "UPDATE admin SET username = ?, password = ?, pin = ?, email = ?, is_active = ? WHERE admin_id = ?";
    private static final String DELETE_ADMIN = 
        "DELETE FROM admin WHERE admin_id = ?";
    private static final String CHECK_USERNAME_EXISTS = 
        "SELECT COUNT(*) FROM admin WHERE username = ?";

    @Override
    public boolean create(Admin admin) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(CREATE_ADMIN);
            stmt.setString(1, admin.getUsername());
            stmt.setString(2, admin.getPassword());
            stmt.setString(3, admin.getPin() != null ? admin.getPin() : "1234");
            stmt.setString(4, admin.getEmail());
            stmt.setBoolean(5, admin.isActive());

            int result = stmt.executeUpdate();
            logger.info("Admin created: {}", admin.getUsername());
            return result > 0;

        } catch (SQLException e) {
            logger.error("Error creating admin", e);
            throw new Exception("Failed to create admin", e);
        } finally {
            DatabaseConfig.closeResources(null, stmt, conn);
        }
    }

    @Override
    public Admin getById(int adminId) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(GET_ADMIN_BY_ID);
            stmt.setInt(1, adminId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToAdmin(rs);
            }
            return null;

        } catch (SQLException e) {
            logger.error("Error fetching admin by ID: {}", adminId, e);
            throw new Exception("Failed to fetch admin", e);
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    @Override
    public Admin getByUsername(String username) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(GET_ADMIN_BY_USERNAME);
            stmt.setString(1, username);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToAdmin(rs);
            }
            return null;

        } catch (SQLException e) {
            logger.error("Error fetching admin by username: {}", username, e);
            throw new Exception("Failed to fetch admin", e);
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    @Override
    public List<Admin> getAll() throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Admin> admins = new ArrayList<>();

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(GET_ALL_ADMINS);
            rs = stmt.executeQuery();

            while (rs.next()) {
                admins.add(mapResultSetToAdmin(rs));
            }
            logger.info("Fetched {} admins", admins.size());
            return admins;

        } catch (SQLException e) {
            logger.error("Error fetching all admins", e);
            throw new Exception("Failed to fetch admins", e);
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    @Override
    public boolean update(Admin admin) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(UPDATE_ADMIN);
            stmt.setString(1, admin.getUsername());
            stmt.setString(2, admin.getPassword());
            stmt.setString(3, admin.getPin() != null ? admin.getPin() : "1234");
            stmt.setString(4, admin.getEmail());
            stmt.setBoolean(5, admin.isActive());
            stmt.setInt(6, admin.getAdminId());

            int result = stmt.executeUpdate();
            logger.info("Admin updated: {}", admin.getUsername());
            return result > 0;

        } catch (SQLException e) {
            logger.error("Error updating admin", e);
            throw new Exception("Failed to update admin", e);
        } finally {
            DatabaseConfig.closeResources(null, stmt, conn);
        }
    }

    @Override
    public boolean delete(int adminId) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(DELETE_ADMIN);
            stmt.setInt(1, adminId);

            int result = stmt.executeUpdate();
            logger.info("Admin deleted: {}", adminId);
            return result > 0;

        } catch (SQLException e) {
            logger.error("Error deleting admin", e);
            throw new Exception("Failed to delete admin", e);
        } finally {
            DatabaseConfig.closeResources(null, stmt, conn);
        }
    }

    @Override
    public boolean existsByUsername(String username) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(CHECK_USERNAME_EXISTS);
            stmt.setString(1, username);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;

        } catch (SQLException e) {
            logger.error("Error checking username existence", e);
            throw new Exception("Failed to check username", e);
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    /**
     * Map ResultSet row to Admin object
     */
    private Admin mapResultSetToAdmin(ResultSet rs) throws SQLException {
        Admin admin = new Admin();
        admin.setAdminId(rs.getInt("admin_id"));
        admin.setUsername(rs.getString("username"));
        admin.setPassword(rs.getString("password"));
        admin.setPin(rs.getString("pin")); // Map PIN field
        admin.setEmail(rs.getString("email"));
        admin.setActive(rs.getBoolean("is_active"));
        
        Timestamp timestamp = rs.getTimestamp("created_at");
        if (timestamp != null) {
            admin.setCreatedAt(timestamp.toLocalDateTime());
        }
        
        return admin;
    }
}
