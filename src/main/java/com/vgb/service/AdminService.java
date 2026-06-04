package com.vgb.service;

import com.vgb.dao.AdminDAOImpl;
import com.vgb.model.Admin;
import com.vgb.util.SecurityUtil;
import com.vgb.util.ValidatorUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.util.List;

/**
 * AdminService: Handles admin-related business logic
 */
public class AdminService {
    private static final Logger logger = LoggerFactory.getLogger(AdminService.class);
    private AdminDAOImpl adminDAO = new AdminDAOImpl();

    /**
     * Create new admin (super admin only)
     */
    public Admin createAdmin(Admin admin) throws Exception {
        if (!ValidatorUtil.isValidUsername(admin.getUsername())) {
            throw new Exception("Invalid username format");
        }

        if (!ValidatorUtil.isValidEmail(admin.getEmail())) {
            throw new Exception("Invalid email format");
        }

        if (!SecurityUtil.isValidPasswordStrength(admin.getPassword())) {
            throw new Exception("Password does not meet strength requirements");
        }

        try {
            if (adminDAO.existsByUsername(admin.getUsername())) {
                throw new Exception("Username already exists");
            }

            // Hash password
            String hashedPassword = SecurityUtil.hashPassword(admin.getPassword());
            admin.setPassword(hashedPassword);

            if (adminDAO.create(admin)) {
                logger.info("Admin created: {}", admin.getUsername());
                return admin;
            }
            throw new Exception("Failed to create admin");

        } catch (Exception e) {
            logger.error("Error creating admin", e);
            throw e;
        }
    }

    /**
     * Get admin by ID
     */
    public Admin getAdminById(int adminId) throws Exception {
        try {
            return adminDAO.getById(adminId);
        } catch (Exception e) {
            logger.error("Error fetching admin", e);
            throw new Exception("Failed to fetch admin", e);
        }
    }

    /**
     * Get admin by username
     */
    public Admin getAdminByUsername(String username) throws Exception {
        try {
            return adminDAO.getByUsername(username);
        } catch (Exception e) {
            logger.error("Error fetching admin by username", e);
            throw new Exception("Failed to fetch admin", e);
        }
    }

    /**
     * Get all admins
     */
    public List<Admin> getAllAdmins() throws Exception {
        try {
            return adminDAO.getAll();
        } catch (Exception e) {
            logger.error("Error fetching admins", e);
            throw new Exception("Failed to fetch admins", e);
        }
    }

    /**
     * Update admin
     */
    public boolean updateAdmin(Admin admin) throws Exception {
        if (!ValidatorUtil.isValidEmail(admin.getEmail())) {
            throw new Exception("Invalid email format");
        }

        try {
            boolean result = adminDAO.update(admin);
            
            if (result) {
                logger.info("Admin updated: {}", admin.getAdminId());
            }
            return result;

        } catch (Exception e) {
            logger.error("Error updating admin", e);
            throw new Exception("Failed to update admin", e);
        }
    }

    /**
     * Deactivate admin
     */
    public boolean deactivateAdmin(int adminId) throws Exception {
        try {
            Admin admin = adminDAO.getById(adminId);
            
            if (admin == null) {
                throw new Exception("Admin not found");
            }

            admin.setActive(false);
            boolean result = adminDAO.update(admin);
            
            if (result) {
                logger.info("Admin deactivated: {}", adminId);
            }
            return result;

        } catch (Exception e) {
            logger.error("Error deactivating admin", e);
            throw new Exception("Failed to deactivate admin", e);
        }
    }

    /**
     * Activate admin
     */
    public boolean activateAdmin(int adminId) throws Exception {
        try {
            Admin admin = adminDAO.getById(adminId);
            
            if (admin == null) {
                throw new Exception("Admin not found");
            }

            admin.setActive(true);
            boolean result = adminDAO.update(admin);
            
            if (result) {
                logger.info("Admin activated: {}", adminId);
            }
            return result;

        } catch (Exception e) {
            logger.error("Error activating admin", e);
            throw new Exception("Failed to activate admin", e);
        }
    }

    /**
     * Delete admin (super admin only)
     */
    public boolean deleteAdmin(int adminId) throws Exception {
        try {
            return adminDAO.delete(adminId);
        } catch (Exception e) {
            logger.error("Error deleting admin", e);
            throw new Exception("Failed to delete admin", e);
        }
    }
}
