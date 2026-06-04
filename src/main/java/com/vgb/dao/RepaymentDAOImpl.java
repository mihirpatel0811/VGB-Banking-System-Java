package com.vgb.dao;

import com.vgb.config.DatabaseConfig;
import com.vgb.model.Repayment;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.sql.*;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

/**
 * RepaymentDAOImpl: Implementation of RepaymentDAO
 */
public class RepaymentDAOImpl implements RepaymentDAO {
    private static final Logger logger = LoggerFactory.getLogger(RepaymentDAOImpl.class);
    private DatabaseConfig dbConfig = DatabaseConfig.getInstance();

    private static final String CREATE_REPAYMENT = 
        "INSERT INTO repayment (loan_id, customer_id, transaction_id, amount_paid, principal_component, interest_component) VALUES (?, ?, ?, ?, ?, ?)";
    private static final String GET_REPAYMENT_BY_ID = 
        "SELECT * FROM repayment WHERE repayment_id = ?";
    private static final String GET_REPAYMENTS_BY_LOAN = 
        "SELECT * FROM repayment WHERE loan_id = ? ORDER BY repayment_date DESC";
    private static final String GET_REPAYMENTS_BY_CUSTOMER = 
        "SELECT * FROM repayment WHERE customer_id = ? ORDER BY repayment_date DESC";
    private static final String GET_ALL_REPAYMENTS = 
        "SELECT * FROM repayment ORDER BY repayment_date DESC";

    @Override
    public boolean create(Repayment repayment) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(CREATE_REPAYMENT);
            stmt.setLong(1, repayment.getLoanId());
            stmt.setLong(2, repayment.getCustomerId());
            stmt.setLong(3, repayment.getTransactionId());
            stmt.setBigDecimal(4, repayment.getAmountPaid());
            stmt.setBigDecimal(5, repayment.getPrincipalComponent());
            stmt.setBigDecimal(6, repayment.getInterestComponent());

            int result = stmt.executeUpdate();
            logger.info("Repayment created - Loan: {}, Amount: {}", repayment.getLoanId(), repayment.getAmountPaid());
            return result > 0;

        } catch (SQLException e) {
            logger.error("Error creating repayment", e);
            throw new Exception("Failed to create repayment", e);
        } finally {
            DatabaseConfig.closeResources(null, stmt, conn);
        }
    }

    @Override
    public Repayment getById(long repaymentId) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(GET_REPAYMENT_BY_ID);
            stmt.setLong(1, repaymentId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToRepayment(rs);
            }
            return null;

        } catch (SQLException e) {
            logger.error("Error fetching repayment", e);
            throw new Exception("Failed to fetch repayment", e);
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    @Override
    public List<Repayment> getByLoanId(long loanId) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Repayment> repayments = new ArrayList<>();

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(GET_REPAYMENTS_BY_LOAN);
            stmt.setLong(1, loanId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                repayments.add(mapResultSetToRepayment(rs));
            }
            logger.info("Fetched {} repayments for loan: {}", repayments.size(), loanId);
            return repayments;

        } catch (SQLException e) {
            logger.error("Error fetching repayments by loan", e);
            throw new Exception("Failed to fetch repayments", e);
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    @Override
    public List<Repayment> getByCustomerId(long customerId) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Repayment> repayments = new ArrayList<>();

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(GET_REPAYMENTS_BY_CUSTOMER);
            stmt.setLong(1, customerId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                repayments.add(mapResultSetToRepayment(rs));
            }
            return repayments;

        } catch (SQLException e) {
            logger.error("Error fetching repayments by customer", e);
            throw new Exception("Failed to fetch repayments", e);
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    @Override
    public List<Repayment> getAll() throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Repayment> repayments = new ArrayList<>();

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(GET_ALL_REPAYMENTS);
            rs = stmt.executeQuery();

            while (rs.next()) {
                repayments.add(mapResultSetToRepayment(rs));
            }
            return repayments;

        } catch (SQLException e) {
            logger.error("Error fetching all repayments", e);
            throw new Exception("Failed to fetch repayments", e);
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    private Repayment mapResultSetToRepayment(ResultSet rs) throws SQLException {
        Repayment repayment = new Repayment();
        repayment.setRepaymentId(rs.getLong("repayment_id"));
        repayment.setLoanId(rs.getLong("loan_id"));
        repayment.setCustomerId(rs.getLong("customer_id"));
        repayment.setTransactionId(rs.getLong("transaction_id"));
        
        BigDecimal amountPaid = rs.getBigDecimal("amount_paid");
        repayment.setAmountPaid(amountPaid != null ? amountPaid : BigDecimal.ZERO);
        
        BigDecimal principalComponent = rs.getBigDecimal("principal_component");
        repayment.setPrincipalComponent(principalComponent != null ? principalComponent : BigDecimal.ZERO);
        
        BigDecimal interestComponent = rs.getBigDecimal("interest_component");
        repayment.setInterestComponent(interestComponent != null ? interestComponent : BigDecimal.ZERO);
        
        Timestamp timestamp = rs.getTimestamp("repayment_date");
        if (timestamp != null) {
            repayment.setRepaymentDate(timestamp.toLocalDateTime());
        }
        
        return repayment;
    }
}
