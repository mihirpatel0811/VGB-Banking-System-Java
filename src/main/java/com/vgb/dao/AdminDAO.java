package com.vgb.dao;

import com.vgb.model.Admin;
import java.util.List;

/**
 * AdminDAO Interface: CRUD operations for Admin
 */
public interface AdminDAO {
    
    /**
     * Create new admin
     */
    boolean create(Admin admin) throws Exception;

    /**
     * Get admin by ID
     */
    Admin getById(int adminId) throws Exception;

    /**
     * Get admin by username
     */
    Admin getByUsername(String username) throws Exception;

    /**
     * Get all admins
     */
    List<Admin> getAll() throws Exception;

    /**
     * Update admin
     */
    boolean update(Admin admin) throws Exception;

    /**
     * Delete admin
     */
    boolean delete(int adminId) throws Exception;

    /**
     * Check if admin exists by username
     */
    boolean existsByUsername(String username) throws Exception;
}
