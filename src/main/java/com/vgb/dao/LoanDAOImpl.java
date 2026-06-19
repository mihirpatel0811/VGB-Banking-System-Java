package com.vgb.dao;

import com.vgb.config.DatabaseConfig;
import com.vgb.model.Loan;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * LoanDAOImpl: Implementation of LoanDAO
 */
public class LoanDAOImpl implements LoanDAO {
    private static final Logger logger = LoggerFactory.getLogger(LoanDAOImpl.class);
    private DatabaseConfig dbConfig = DatabaseConfig.getInstance();

    private static final String CREATE_LOAN = 
        "INSERT INTO loan (customer_id, loan_type, principal_amount, remaining_balance, interest_rate, term_months, start_date, end_date, status, form_details) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    private static final String GET_LOAN_BY_ID = 
        "SELECT * FROM loan WHERE loan_id = ?";
    private static final String GET_LOANS_BY_CUSTOMER = 
        "SELECT * FROM loan WHERE customer_id = ? ORDER BY created_at DESC";
    private static final String GET_LOANS_BY_CUSTOMER_AND_STATUS = 
        "SELECT * FROM loan WHERE customer_id = ? AND status = ? ORDER BY created_at DESC";
    private static final String GET_LOANS_BY_STATUS = 
        "SELECT * FROM loan WHERE status = ? ORDER BY created_at DESC";
    private static final String GET_ALL_LOANS = 
        "SELECT * FROM loan ORDER BY created_at DESC";
    private static final String UPDATE_LOAN = 
        "UPDATE loan SET principal_amount = ?, remaining_balance = ?, interest_rate = ?, term_months = ?, form_details = ?, loan_type = ? WHERE loan_id = ?";
    private static final String UPDATE_LOAN_STATUS = 
        "UPDATE loan SET status = ? WHERE loan_id = ?";
    private static final String UPDATE_REMAINING_BALANCE = 
        "UPDATE loan SET remaining_balance = ? WHERE loan_id = ?";
    private static final String DELETE_LOAN = 
        "DELETE FROM loan WHERE loan_id = ?";

    @Override
    public boolean create(Loan loan) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(CREATE_LOAN);
            stmt.setLong(1, loan.getCustomerId());
            stmt.setString(2, loan.getLoanType());
            stmt.setBigDecimal(3, loan.getPrincipalAmount());
            stmt.setBigDecimal(4, loan.getRemainingBalance());
            stmt.setBigDecimal(5, loan.getInterestRate());
            stmt.setInt(6, loan.getTermMonths());
            stmt.setDate(7, Date.valueOf(loan.getStartDate()));
            stmt.setDate(8, Date.valueOf(loan.getEndDate()));
            stmt.setString(9, loan.getStatus());
            stmt.setString(10, loan.getFormDetails());

            int result = stmt.executeUpdate();
            logger.info("Loan created: {}", loan.getLoanId());
            return result > 0;

        } catch (SQLException e) {
            logger.error("Error creating loan", e);
            throw new Exception("Failed to create loan", e);
        } finally {
            DatabaseConfig.closeResources(null, stmt, conn);
        }
    }

    @Override
    public Loan getById(long loanId) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(GET_LOAN_BY_ID);
            stmt.setLong(1, loanId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToLoan(rs);
            }
            return null;

        } catch (SQLException e) {
            logger.error("Error fetching loan", e);
            throw new Exception("Failed to fetch loan", e);
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    @Override
    public List<Loan> getByCustomerId(long customerId) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Loan> loans = new ArrayList<>();

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(GET_LOANS_BY_CUSTOMER);
            stmt.setLong(1, customerId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                loans.add(mapResultSetToLoan(rs));
            }
            logger.info("Fetched {} loans for customer: {}", loans.size(), customerId);
            return loans;

        } catch (SQLException e) {
            logger.error("Error fetching loans by customer", e);
            throw new Exception("Failed to fetch loans", e);
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    @Override
    public List<Loan> getByCustomerIdAndStatus(long customerId, String status) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Loan> loans = new ArrayList<>();

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(GET_LOANS_BY_CUSTOMER_AND_STATUS);
            stmt.setLong(1, customerId);
            stmt.setString(2, status);
            rs = stmt.executeQuery();

            while (rs.next()) {
                loans.add(mapResultSetToLoan(rs));
            }
            return loans;

        } catch (SQLException e) {
            logger.error("Error fetching loans by customer and status", e);
            throw new Exception("Failed to fetch loans", e);
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    @Override
    public List<Loan> getByStatus(String status) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Loan> loans = new ArrayList<>();

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(GET_LOANS_BY_STATUS);
            stmt.setString(1, status);
            rs = stmt.executeQuery();

            while (rs.next()) {
                loans.add(mapResultSetToLoan(rs));
            }
            return loans;

        } catch (SQLException e) {
            logger.error("Error fetching loans by status", e);
            throw new Exception("Failed to fetch loans", e);
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    @Override
    public List<Loan> getAll() throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Loan> loans = new ArrayList<>();

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(GET_ALL_LOANS);
            rs = stmt.executeQuery();

            while (rs.next()) {
                loans.add(mapResultSetToLoan(rs));
            }
            return loans;

        } catch (SQLException e) {
            logger.error("Error fetching all loans", e);
            throw new Exception("Failed to fetch loans", e);
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    @Override
    public boolean update(Loan loan) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(UPDATE_LOAN);
            stmt.setBigDecimal(1, loan.getPrincipalAmount());
            stmt.setBigDecimal(2, loan.getRemainingBalance());
            stmt.setBigDecimal(3, loan.getInterestRate());
            stmt.setInt(4, loan.getTermMonths());
            stmt.setString(5, loan.getFormDetails());
            stmt.setString(6, loan.getLoanType());
            stmt.setLong(7, loan.getLoanId());

            int result = stmt.executeUpdate();
            logger.info("Loan updated: {}", loan.getLoanId());
            return result > 0;

        } catch (SQLException e) {
            logger.error("Error updating loan", e);
            throw new Exception("Failed to update loan", e);
        } finally {
            DatabaseConfig.closeResources(null, stmt, conn);
        }
    }

    @Override
    public boolean updateStatus(long loanId, String status) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(UPDATE_LOAN_STATUS);
            stmt.setString(1, status);
            stmt.setLong(2, loanId);

            int result = stmt.executeUpdate();
            logger.info("Loan status updated - ID: {}, Status: {}", loanId, status);
            return result > 0;

        } catch (SQLException e) {
            logger.error("Error updating loan status", e);
            throw new Exception("Failed to update loan status", e);
        } finally {
            DatabaseConfig.closeResources(null, stmt, conn);
        }
    }

    @Override
    public boolean updateRemainingBalance(long loanId, BigDecimal balance) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(UPDATE_REMAINING_BALANCE);
            stmt.setBigDecimal(1, balance);
            stmt.setLong(2, loanId);

            int result = stmt.executeUpdate();
            logger.info("Loan balance updated - ID: {}, Balance: {}", loanId, balance);
            return result > 0;

        } catch (SQLException e) {
            logger.error("Error updating loan balance", e);
            throw new Exception("Failed to update loan balance", e);
        } finally {
            DatabaseConfig.closeResources(null, stmt, conn);
        }
    }

    @Override
    public boolean delete(long loanId) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(DELETE_LOAN);
            stmt.setLong(1, loanId);

            int result = stmt.executeUpdate();
            logger.info("Loan deleted: {}", loanId);
            return result > 0;

        } catch (SQLException e) {
            logger.error("Error deleting loan", e);
            throw new Exception("Failed to delete loan", e);
        } finally {
            DatabaseConfig.closeResources(null, stmt, conn);
        }
    }

    private Loan mapResultSetToLoan(ResultSet rs) throws SQLException {
        Loan loan = new Loan();
        loan.setLoanId(rs.getLong("loan_id"));
        loan.setCustomerId(rs.getLong("customer_id"));
        loan.setLoanType(rs.getString("loan_type"));
        loan.setPrincipalAmount(rs.getBigDecimal("principal_amount"));
        loan.setRemainingBalance(rs.getBigDecimal("remaining_balance"));
        loan.setInterestRate(rs.getBigDecimal("interest_rate"));
        loan.setTermMonths(rs.getInt("term_months"));
        loan.setStartDate(rs.getDate("start_date").toLocalDate());
        loan.setEndDate(rs.getDate("end_date").toLocalDate());
        loan.setStatus(rs.getString("status"));
        loan.setFormDetails(rs.getString("form_details"));
        
        Timestamp timestamp = rs.getTimestamp("created_at");
        if (timestamp != null) {
            loan.setCreatedAt(timestamp.toLocalDateTime());
        }
        
        return loan;
    }
}
