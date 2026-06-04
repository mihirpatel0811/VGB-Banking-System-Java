package com.vgb.dao;

import com.vgb.model.Repayment;
import java.util.List;

/**
 * RepaymentDAO Interface
 */
public interface RepaymentDAO {
    boolean create(Repayment repayment) throws Exception;
    Repayment getById(long repaymentId) throws Exception;
    List<Repayment> getByLoanId(long loanId) throws Exception;
    List<Repayment> getByCustomerId(long customerId) throws Exception;
    List<Repayment> getAll() throws Exception;
}
