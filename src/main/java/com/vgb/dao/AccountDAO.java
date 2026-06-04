package com.vgb.dao;

import com.vgb.model.Account;
import java.util.List;

/**
 * AccountDAO Interface: CRUD operations for Account
 */
public interface AccountDAO {
    
    /**
     * Create new account
     */
    boolean create(Account account) throws Exception;

    /**
     * Get account by ID
     */
    Account getById(long accountId) throws Exception;

    /**
     * Get account by account number
     */
    Account getByAccountNumber(String accountNumber) throws Exception;

    /**
     * Get all accounts of a customer
     */
    List<Account> getByCustomerId(long customerId) throws Exception;

    /**
     * Get all active accounts
     */
    List<Account> getAll() throws Exception;

    /**
     * Update account
     */
    boolean update(Account account) throws Exception;

    /**
     * Update account balance
     */
    boolean updateBalance(long accountId, java.math.BigDecimal balance) throws Exception;

    /**
     * Update account status
     */
    boolean updateStatus(long accountId, String status) throws Exception;

    /**
     * Update cheque book status
     */
    boolean updateChequeBookStatus(long accountId, boolean hasChequeBook) throws Exception;

    /**
     * Delete account
     */
    boolean delete(long accountId) throws Exception;

    /**
     * Check if account number exists
     */
    boolean existsByAccountNumber(String accountNumber) throws Exception;

    /**
     * Get account count by customer ID
     */
    int getAccountCountByCustomerId(long customerId) throws Exception;

    /**
     * Get list of saved beneficiaries for a customer
     */
    List<Account> getSavedBeneficiaries(long customerId) throws Exception;

    /**
     * Save a verified beneficiary for a customer
     */
    boolean addBeneficiary(long customerId, long beneficiaryAccountId) throws Exception;

    /**
     * Save a verified beneficiary (local VGB or external bank) with details for a customer
     */
    boolean addBeneficiary(long customerId, String beneficiaryType, Long beneficiaryAccountId, String accountNumber, String ifscCode, String holderName) throws Exception;

    /**
     * Retrieve details of an external other-bank beneficiary by beneficiary ID
     */
    String[] getExternalBeneficiaryDetails(long beneficiaryId) throws Exception;
}
