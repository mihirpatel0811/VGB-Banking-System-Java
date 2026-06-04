package com.vgb.dao;

import com.vgb.model.Transaction;
import java.time.LocalDateTime;
import java.util.List;

/**
 * TransactionDAO Interface
 */
public interface TransactionDAO {
    boolean create(Transaction transaction) throws Exception;
    Transaction getById(long transactionId) throws Exception;
    List<Transaction> getByAccountId(long accountId) throws Exception;
    List<Transaction> getByDateRange(LocalDateTime startDate, LocalDateTime endDate) throws Exception;
    List<Transaction> getAll() throws Exception;
    boolean updateStatus(long transactionId, String status) throws Exception;
}
