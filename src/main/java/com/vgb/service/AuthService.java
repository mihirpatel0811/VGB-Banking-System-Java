package com.vgb.service;

import com.vgb.constants.AppConstants;
import com.vgb.dao.AdminDAOImpl;
import com.vgb.dao.CustomerDAOImpl;
import com.vgb.dao.AccountDAOImpl;
import com.vgb.model.Admin;
import com.vgb.model.Customer;
import com.vgb.model.Account;
import com.vgb.util.SecurityUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * AuthService: Handles authentication and authorization
 */
public class AuthService {
    private static final Logger logger = LoggerFactory.getLogger(AuthService.class);
    private AdminDAOImpl adminDAO = new AdminDAOImpl();
    private CustomerDAOImpl customerDAO = new CustomerDAOImpl();
    private AccountDAOImpl accountDAO = new AccountDAOImpl();

    /**
     * Authenticate admin user
     */
    public Admin authenticateAdmin(String username, String password) throws Exception {
        if (username == null || password == null) {
            logger.warn("Null credentials provided for admin login");
            return null;
        }

        try {
            Admin admin = adminDAO.getByUsername(username);
            
            if (admin != null && admin.isActive() && SecurityUtil.verifyPassword(password, admin.getPassword())) {
                logger.info("Admin authenticated successfully: {}", username);
                return admin;
            }
            
            logger.warn("Admin authentication failed: {}", username);
            return null;

        } catch (Exception e) {
            logger.error("Error authenticating admin", e);
            throw new Exception("Authentication failed", e);
        }
    }

    /**
     * Authenticate customer user
     */
    public Customer authenticateCustomer(String username, String password) throws Exception {
        if (username == null || password == null) {
            logger.warn("Null credentials provided for customer login");
            return null;
        }

        try {
            Customer customer = customerDAO.getByUsername(username);
            
            if (customer != null && 
                customer.getStatus().equalsIgnoreCase(AppConstants.ACCOUNT_STATUS_ACTIVE) &&
                SecurityUtil.verifyPassword(password, customer.getPassword())) {
                
                logger.info("Customer authenticated successfully: {}", username);
                return customer;
            }
            
            logger.warn("Customer authentication failed: {}", username);
            return null;

        } catch (Exception e) {
            logger.error("Error authenticating customer", e);
            throw new Exception("Authentication failed", e);
        }
    }

    /**
     * Login customer user with credential validation
     */
    public Customer loginCustomer(String username, String password) throws Exception {
        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            throw new IllegalArgumentException("Username and password cannot be null or empty");
        }
        return authenticateCustomer(username, password);
    }


    /**
     * Authenticate admin user using PIN
     */
    public Admin authenticateAdminByPIN(String username, String pin) throws Exception {
        if (username == null || pin == null) {
            logger.warn("Null credentials provided for admin PIN login");
            return null;
        }

        try {
            Admin admin = adminDAO.getByUsername(username);
            
            if (admin != null && admin.isActive() && pin.equals(admin.getPin())) {
                logger.info("Admin PIN authenticated successfully: {}", username);
                return admin;
            }
            
            logger.warn("Admin PIN authentication failed: {}", username);
            return null;

        } catch (Exception e) {
            logger.error("Error authenticating admin by PIN", e);
            throw new Exception("PIN authentication failed", e);
        }
    }

    /**
     * Authenticate customer user using PIN
     */
    public Customer authenticateCustomerByPIN(String username, String pin) throws Exception {
        if (username == null || pin == null) {
            logger.warn("Null credentials provided for customer PIN login");
            return null;
        }

        try {
            Customer customer = customerDAO.getByUsername(username);
            
            if (customer != null && 
                customer.getStatus().equalsIgnoreCase(AppConstants.ACCOUNT_STATUS_ACTIVE) &&
                pin.equals(customer.getPin())) {
                
                logger.info("Customer PIN authenticated successfully: {}", username);
                return customer;
            }
            
            logger.warn("Customer PIN authentication failed: {}", username);
            return null;

        } catch (Exception e) {
            logger.error("Error authenticating customer by PIN", e);
            throw new Exception("PIN authentication failed", e);
        }
    }

    /**
     * Verify customer PIN
     */
    public boolean verifyCustomerPIN(long customerId, String pin) throws Exception {
        try {
            Customer customer = customerDAO.getById(customerId);
            
            if (customer != null && customer.getPin().equals(pin)) {
                logger.info("PIN verified for customer: {}", customerId);
                return true;
            }
            
            logger.warn("PIN verification failed for customer: {}", customerId);
            return false;

        } catch (Exception e) {
            logger.error("Error verifying PIN", e);
            throw new Exception("PIN verification failed", e);
        }
    }

    /**
     * Update customer password
     */
    public boolean updateCustomerPassword(long customerId, String oldPassword, String newPassword) throws Exception {
        if (!SecurityUtil.isValidPasswordStrength(newPassword)) {
            logger.warn("New password does not meet strength requirements");
            return false;
        }

        try {
            Customer customer = customerDAO.getById(customerId);
            
            if (customer != null && SecurityUtil.verifyPassword(oldPassword, customer.getPassword())) {
                String hashedPassword = SecurityUtil.hashPassword(newPassword);
                boolean result = customerDAO.updatePassword(customerId, hashedPassword);
                
                if (result) {
                    logger.info("Password updated for customer: {}", customerId);
                }
                return result;
            }
            
            logger.warn("Password update failed - incorrect old password for customer: {}", customerId);
            return false;

        } catch (Exception e) {
            logger.error("Error updating password", e);
            throw new Exception("Password update failed", e);
        }
    }

    /**
     * Update customer PIN
     */
    public boolean updateCustomerPIN(long customerId, String newPIN) throws Exception {
        if (!SecurityUtil.isValidPIN(newPIN)) {
            logger.warn("Invalid PIN format");
            return false;
        }

        try {
            boolean result = customerDAO.updatePIN(customerId, newPIN);
            
            if (result) {
                logger.info("PIN updated for customer: {}", customerId);
            }
            return result;

        } catch (Exception e) {
            logger.error("Error updating PIN", e);
            throw new Exception("PIN update failed", e);
        }
    }

    /**
      * Register new customer
      */
    public boolean registerCustomer(Customer customer) throws Exception {
        if (customer == null) {
            throw new Exception("Customer data is required");
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

            // Create customer with plaintext password (as per SQL schema requirement)
            customer.setStatus(AppConstants.ACCOUNT_STATUS_ACTIVE);
            
            boolean result = customerDAO.create(customer);
            
            if (result) {
                logger.info("Customer registered successfully: {}", customer.getEmail());
            }
            return result;

        } catch (Exception e) {
            logger.error("Error registering customer", e);
            throw new Exception("Registration failed: " + e.getMessage(), e);
        }
    }

    /**
     * Change admin password
     */
    public boolean changeAdminPassword(int adminId, String oldPassword, String newPassword) throws Exception {
        if (!SecurityUtil.isValidPasswordStrength(newPassword)) {
            logger.warn("New password does not meet strength requirements");
            return false;
        }

        try {
            Admin admin = adminDAO.getById(adminId);
            
            if (admin != null && SecurityUtil.verifyPassword(oldPassword, admin.getPassword())) {
                String hashedPassword = SecurityUtil.hashPassword(newPassword);
                admin.setPassword(hashedPassword);
                boolean result = adminDAO.update(admin);
                
                if (result) {
                    logger.info("Password updated for admin: {}", adminId);
                }
                return result;
            }
            
            logger.warn("Password update failed - incorrect old password for admin: {}", adminId);
            return false;

        } catch (Exception e) {
            logger.error("Error updating admin password", e);
            throw new Exception("Password update failed", e);
        }
    }

    /**
     * Change admin PIN
     */
    public boolean changeAdminPIN(int adminId, String newPIN) throws Exception {
        if (!SecurityUtil.isValidPIN(newPIN)) {
            logger.warn("Invalid PIN format for admin");
            return false;
        }

        try {
            Admin admin = adminDAO.getById(adminId);
            
            if (admin != null) {
                admin.setPin(newPIN);
                boolean result = adminDAO.update(admin);
                
                if (result) {
                    logger.info("PIN updated for admin: {}", adminId);
                }
                return result;
            }
            return false;

        } catch (Exception e) {
            logger.error("Error updating admin PIN", e);
            throw new Exception("PIN update failed", e);
        }
    }

    /**
     * Authenticate customer by account credentials
     */
    public Account authenticateCustomerAccount(String username, String password) throws Exception {
        if (username == null || password == null) {
            logger.warn("Null credentials provided for customer account login");
            return null;
        }

        try {
            Account account = accountDAO.getByUsername(username);
            
            if (account != null && 
                account.getStatus().equalsIgnoreCase(AppConstants.ACCOUNT_STATUS_ACTIVE) &&
                SecurityUtil.verifyPassword(password, account.getPassword())) {
                
                logger.info("Customer account authenticated successfully: {}", username);
                return account;
            }
            
            logger.warn("Customer account authentication failed: {}", username);
            return null;

        } catch (Exception e) {
            logger.error("Error authenticating customer account", e);
            throw new Exception("Authentication failed", e);
        }
    }

    /**
     * Authenticate customer by account PIN
     */
    public Account authenticateCustomerAccountByPIN(String username, String pin) throws Exception {
        if (username == null || pin == null) {
            logger.warn("Null credentials provided for customer account PIN login");
            return null;
        }

        try {
            Account account = accountDAO.getByUsername(username);
            
            if (account != null && 
                account.getStatus().equalsIgnoreCase(AppConstants.ACCOUNT_STATUS_ACTIVE) &&
                pin.equals(account.getPin())) {
                
                logger.info("Customer account PIN authenticated successfully: {}", username);
                return account;
            }
            
            logger.warn("Customer account PIN authentication failed: {}", username);
            return null;

        } catch (Exception e) {
            logger.error("Error authenticating customer account by PIN", e);
            throw new Exception("PIN authentication failed", e);
        }
    }
}

