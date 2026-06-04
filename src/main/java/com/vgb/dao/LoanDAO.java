package com.vgb.dao;

import com.vgb.model.Loan;
import java.util.List;

/**
  * LoanDAO Interface
  */
public interface LoanDAO {
   boolean create(Loan loan) throws Exception;
   Loan getById(long loanId) throws Exception;
   List<Loan> getByCustomerId(long customerId) throws Exception;
   List<Loan> getByCustomerIdAndStatus(long customerId, String status) throws Exception;
   List<Loan> getByStatus(String status) throws Exception;
   List<Loan> getAll() throws Exception;
   boolean update(Loan loan) throws Exception;
   boolean updateStatus(long loanId, String status) throws Exception;
   boolean updateRemainingBalance(long loanId, java.math.BigDecimal balance) throws Exception;
   boolean delete(long loanId) throws Exception;
}
