package com.vgb.dao;

import com.vgb.config.DatabaseConfig;
import com.vgb.model.Card;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CardDAOImpl {
    private static final Logger logger = LoggerFactory.getLogger(CardDAOImpl.class);

    public boolean create(Card card) throws SQLException {
        String sql = "INSERT INTO card (account_id, customer_id, card_number, card_type, card_provider, card_holder_name, cvv, expiry_date, status, daily_limit, card_fee, outstanding_balance, is_fee_paid) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DatabaseConfig.getInstance().getConnection();
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setLong(1, card.getAccountId());
            stmt.setLong(2, card.getCustomerId());
            stmt.setString(3, card.getCardNumber());
            stmt.setString(4, card.getCardType());
            stmt.setString(5, card.getCardProvider());
            stmt.setString(6, card.getCardHolderName());
            stmt.setString(7, card.getCvv());
            stmt.setDate(8, card.getExpiryDate());
            stmt.setString(9, card.getStatus());
            stmt.setBigDecimal(10, card.getDailyLimit());
            stmt.setBigDecimal(11, card.getCardFee());
            stmt.setBigDecimal(12, card.getOutstandingBalance());
            stmt.setInt(13, card.isFeePaid() ? 1 : 0);

            int affected = stmt.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        card.setCardId(rs.getLong(1));
                    }
                }
                return true;
            }
            return false;
        } finally {
            DatabaseConfig.closeResources(null, stmt, conn);
        }
    }

    public Card getById(long cardId) throws SQLException {
        String sql = "SELECT c.*, a.account_number, a.account_type FROM card c JOIN account a ON c.account_id = a.account_id WHERE c.card_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DatabaseConfig.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setLong(1, cardId);
            rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToCard(rs);
            }
            return null;
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    public Card getByCardNumber(String cardNumber) throws SQLException {
        String sql = "SELECT c.*, a.account_number, a.account_type FROM card c JOIN account a ON c.account_id = a.account_id WHERE REPLACE(c.card_number, ' ', '') = REPLACE(?, ' ', '')";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DatabaseConfig.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, cardNumber);
            rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToCard(rs);
            }
            return null;
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    public List<Card> getByCustomerId(long customerId) throws SQLException {
        String sql = "SELECT c.*, a.account_number, a.account_type FROM card c JOIN account a ON c.account_id = a.account_id WHERE c.customer_id = ? ORDER BY c.created_at DESC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Card> list = new ArrayList<>();
        try {
            conn = DatabaseConfig.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setLong(1, customerId);
            rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToCard(rs));
            }
            return list;
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    public List<Card> getByAccountId(long accountId) throws SQLException {
        String sql = "SELECT c.*, a.account_number, a.account_type FROM card c JOIN account a ON c.account_id = a.account_id WHERE c.account_id = ? ORDER BY c.created_at DESC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Card> list = new ArrayList<>();
        try {
            conn = DatabaseConfig.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setLong(1, accountId);
            rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToCard(rs));
            }
            return list;
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    public List<Card> getAll() throws SQLException {
        String sql = "SELECT c.*, a.account_number, a.account_type FROM card c JOIN account a ON c.account_id = a.account_id ORDER BY c.created_at DESC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Card> list = new ArrayList<>();
        try {
            conn = DatabaseConfig.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToCard(rs));
            }
            return list;
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    public boolean updateStatus(long cardId, String status) throws SQLException {
        String sql = "UPDATE card SET status = ? WHERE card_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DatabaseConfig.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, status);
            stmt.setLong(2, cardId);
            return stmt.executeUpdate() > 0;
        } finally {
            DatabaseConfig.closeResources(null, stmt, conn);
        }
    }

    public boolean updateExpiryAndStatus(long cardId, Date expiryDate, String status) throws SQLException {
        String sql = "UPDATE card SET expiry_date = ?, status = ?, is_fee_paid = 1 WHERE card_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DatabaseConfig.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setDate(1, expiryDate);
            stmt.setString(2, status);
            stmt.setLong(3, cardId);
            return stmt.executeUpdate() > 0;
        } finally {
            DatabaseConfig.closeResources(null, stmt, conn);
        }
    }

    public boolean updateOutstandingBalance(long cardId, java.math.BigDecimal amount) throws SQLException {
        String sql = "UPDATE card SET outstanding_balance = ? WHERE card_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DatabaseConfig.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setBigDecimal(1, amount);
            stmt.setLong(2, cardId);
            return stmt.executeUpdate() > 0;
        } finally {
            DatabaseConfig.closeResources(null, stmt, conn);
        }
    }

    public boolean updateFeePaidStatus(long cardId, boolean isFeePaid) throws SQLException {
        String sql = "UPDATE card SET is_fee_paid = ? WHERE card_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DatabaseConfig.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, isFeePaid ? 1 : 0);
            stmt.setLong(2, cardId);
            return stmt.executeUpdate() > 0;
        } finally {
            DatabaseConfig.closeResources(null, stmt, conn);
        }
    }

    public void updateExpiredCardsStatus() throws SQLException {
        String sql = "UPDATE card SET status = 'expired' WHERE expiry_date < CURRENT_DATE() AND status = 'active'";
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DatabaseConfig.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            int updated = stmt.executeUpdate();
            if (updated > 0) {
                logger.info("Programmatic Expiry Sweep: marked {} cards as expired.", updated);
            }
        } finally {
            DatabaseConfig.closeResources(null, stmt, conn);
        }
    }

    private Card mapResultSetToCard(ResultSet rs) throws SQLException {
        Card card = new Card();
        card.setCardId(rs.getLong("card_id"));
        card.setAccountId(rs.getLong("account_id"));
        card.setCustomerId(rs.getLong("customer_id"));
        card.setCardNumber(rs.getString("card_number"));
        card.setCardType(rs.getString("card_type"));
        card.setCardProvider(rs.getString("card_provider"));
        card.setCardHolderName(rs.getString("card_holder_name"));
        card.setCvv(rs.getString("cvv"));
        card.setExpiryDate(rs.getDate("expiry_date"));
        card.setStatus(rs.getString("status"));
        card.setDailyLimit(rs.getBigDecimal("daily_limit"));
        card.setCardFee(rs.getBigDecimal("card_fee"));
        card.setOutstandingBalance(rs.getBigDecimal("outstanding_balance"));
        card.setFeePaid(rs.getInt("is_fee_paid") == 1);
        card.setCreatedAt(rs.getTimestamp("created_at"));

        // Transient fields
        try {
            card.setAccountNumber(rs.getString("account_number"));
            card.setAccountType(rs.getString("account_type"));
        } catch (SQLException e) {
            // Optional columns, skip if not queried
        }
        return card;
    }
}
