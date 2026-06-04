package com.vgb.service;

import com.vgb.constants.AppConstants;
import com.vgb.dao.CustomerDAOImpl;
import com.vgb.model.Customer;
import com.vgb.util.SecurityUtil;
import com.vgb.util.ValidatorUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.util.List;

/**
 * CustomerService: Handles customer-related business logic
 */
public class CustomerService {
    private static final Logger logger = LoggerFactory.getLogger(CustomerService.class);
    private CustomerDAOImpl customerDAO = new CustomerDAOImpl();

    /**
     * Register new customer
     */
    public Customer registerCustomer(Customer customer) throws Exception {
        // Validate input
        if (!ValidatorUtil.isValidEmail(customer.getEmail())) {
            throw new Exception("Invalid email format");
        }

        if (!ValidatorUtil.isValidPhone(customer.getPhoneNo())) {
            throw new Exception("Invalid phone number format");
        }

        if (!ValidatorUtil.isValidUsername(customer.getUsername())) {
            throw new Exception("Invalid username format (3-30 alphanumeric characters)");
        }

        if (!SecurityUtil.isValidPasswordStrength(customer.getPassword())) {
            throw new Exception("Password must be at least 8 characters with uppercase, lowercase, digit, and special character");
        }

        if (!SecurityUtil.isValidPIN(customer.getPin())) {
            throw new Exception("PIN must be 4 digits");
        }

        try {
            // Check if email already exists
            if (customerDAO.existsByEmail(customer.getEmail())) {
                throw new Exception("Email already registered");
            }

            // Check if username already exists
            if (customerDAO.existsByUsername(customer.getUsername())) {
                throw new Exception("Username already taken");
            }

            // Check if phone already exists
            if (customerDAO.existsByPhone(customer.getPhoneNo())) {
                throw new Exception("Phone number already registered");
            }

            // Hash password
            String hashedPassword = SecurityUtil.hashPassword(customer.getPassword());
            customer.setPassword(hashedPassword);
            customer.setStatus(AppConstants.ACCOUNT_STATUS_ACTIVE);

            if (customerDAO.create(customer)) {
                logger.info("Customer registered successfully: {}", customer.getEmail());
                return customer;
            }
            throw new Exception("Failed to register customer");

        } catch (Exception e) {
            logger.error("Error registering customer", e);
            throw e;
        }
    }

    /**
     * Get customer by ID
     */
    public Customer getCustomerById(long customerId) throws Exception {
        try {
            return customerDAO.getById(customerId);
        } catch (Exception e) {
            logger.error("Error fetching customer", e);
            throw new Exception("Failed to fetch customer", e);
        }
    }

    /**
     * Get customer by username
     */
    public Customer getCustomerByUsername(String username) throws Exception {
        try {
            return customerDAO.getByUsername(username);
        } catch (Exception e) {
            logger.error("Error fetching customer by username", e);
            throw new Exception("Failed to fetch customer", e);
        }
    }

    /**
     * Get all customers
     */
    public List<Customer> getAllCustomers() throws Exception {
        try {
            return customerDAO.getAll();
        } catch (Exception e) {
            logger.error("Error fetching customers", e);
            throw new Exception("Failed to fetch customers", e);
        }
    }

    /**
     * Get customers by status
     */
    public List<Customer> getCustomersByStatus(String status) throws Exception {
        try {
            return customerDAO.getByStatus(status);
        } catch (Exception e) {
            logger.error("Error fetching customers by status", e);
            throw new Exception("Failed to fetch customers", e);
        }
    }

    /**
     * Update customer profile
     */
    public boolean updateCustomerProfile(Customer customer) throws Exception {
        if (!ValidatorUtil.isValidEmail(customer.getEmail())) {
            throw new Exception("Invalid email format");
        }

        if (!ValidatorUtil.isValidPhone(customer.getPhoneNo())) {
            throw new Exception("Invalid phone number format");
        }

        try {
            boolean result = customerDAO.update(customer);
            
            if (result) {
                logger.info("Customer profile updated: {}", customer.getCustomerId());
            }
            return result;

        } catch (Exception e) {
            logger.error("Error updating customer profile", e);
            throw new Exception("Failed to update profile", e);
        }
    }

    /**
     * Update customer status (admin only)
     */
    public boolean updateCustomerStatus(long customerId, String status) throws Exception {
        if (!ValidatorUtil.isNotNull(status)) {
            throw new Exception("Status cannot be empty");
        }

        try {
            boolean result = customerDAO.updateStatus(customerId, status);
            
            if (result) {
                logger.info("Customer status updated - ID: {}, Status: {}", customerId, status);
            }
            return result;

        } catch (Exception e) {
            logger.error("Error updating customer status", e);
            throw new Exception("Failed to update customer status", e);
        }
    }

    /**
     * Approve customer (change status from pending_kyc to active)
     */
    public boolean approveCustomer(long customerId) throws Exception {
        try {
            Customer customer = customerDAO.getById(customerId);
            
            if (customer == null) {
                throw new Exception("Customer not found");
            }

            if (!customer.getStatus().equalsIgnoreCase(AppConstants.ACCOUNT_STATUS_PENDING_KYC)) {
                throw new Exception("Customer is not in pending KYC status");
            }

            boolean result = customerDAO.updateStatus(customerId, AppConstants.ACCOUNT_STATUS_ACTIVE);
            
            if (result) {
                logger.info("Customer approved: {}", customerId);
            }
            return result;

        } catch (Exception e) {
            logger.error("Error approving customer", e);
            throw new Exception("Failed to approve customer", e);
        }
    }

    /**
     * Suspend customer account
     */
    public boolean suspendCustomer(long customerId) throws Exception {
        try {
            return customerDAO.updateStatus(customerId, AppConstants.ACCOUNT_STATUS_SUSPENDED);
        } catch (Exception e) {
            logger.error("Error suspending customer", e);
            throw new Exception("Failed to suspend customer", e);
        }
    }

    /**
     * Close customer account
     */
    public boolean closeCustomerAccount(long customerId) throws Exception {
        try {
            return customerDAO.updateStatus(customerId, AppConstants.ACCOUNT_STATUS_CLOSED);
        } catch (Exception e) {
            logger.error("Error closing customer account", e);
            throw new Exception("Failed to close account", e);
        }
    }

    /**
     * Delete customer (admin only)
     */
    public boolean deleteCustomer(long customerId) throws Exception {
        try {
            return customerDAO.delete(customerId);
        } catch (Exception e) {
            logger.error("Error deleting customer", e);
            throw new Exception("Failed to delete customer", e);
        }
    }

    /**
     * Update customer avatar path
     */
    public boolean updateCustomerAvatar(long customerId, String avatarPath) throws Exception {
        try {
            return customerDAO.updateAvatarPath(customerId, avatarPath);
        } catch (Exception e) {
            logger.error("Error updating customer avatar", e);
            throw new Exception("Failed to update avatar", e);
        }
    }
}
