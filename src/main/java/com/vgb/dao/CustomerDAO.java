package com.vgb.dao;

import com.vgb.model.Customer;
import java.util.List;

/**
 * CustomerDAO Interface: CRUD operations for Customer
 */
public interface CustomerDAO {
    
    /**
     * Create new customer
     */
    boolean create(Customer customer) throws Exception;

    /**
     * Get customer by ID
     */
    Customer getById(long customerId) throws Exception;

    /**
     * Get customer by username
     */
    Customer getByUsername(String username) throws Exception;

    /**
     * Get customer by email
     */
    Customer getByEmail(String email) throws Exception;

    /**
     * Get all customers
     */
    List<Customer> getAll() throws Exception;

    /**
     * Get customers with pagination
     */
    List<Customer> getByStatus(String status) throws Exception;

    /**
     * Update customer
     */
    boolean update(Customer customer) throws Exception;

    /**
     * Update customer status
     */
    boolean updateStatus(long customerId, String status) throws Exception;

    /**
     * Update customer password
     */
    boolean updatePassword(long customerId, String newPassword) throws Exception;

    /**
     * Update customer PIN
     */
    boolean updatePIN(long customerId, String newPIN) throws Exception;

    /**
     * Delete customer
     */
    boolean delete(long customerId) throws Exception;

    /**
     * Check if email exists
     */
    boolean existsByEmail(String email) throws Exception;

    /**
     * Check if username exists
     */
    boolean existsByUsername(String username) throws Exception;

    /**
     * Check if phone exists
     */
    boolean existsByPhone(String phone) throws Exception;

    /**
     * Check if PAN card exists
     */
    boolean existsByPan(String pan) throws Exception;

    /**
     * Check if Aadhaar card exists
     */
    boolean existsByAadhaar(String aadhaar) throws Exception;

    /**
     * Update customer avatar path
     */
    boolean updateAvatarPath(long customerId, String avatarPath) throws Exception;
}
