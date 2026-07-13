package com.vgb.dao;

import com.vgb.config.DatabaseConfig;
import com.vgb.model.Notification;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO {

    public boolean create(Connection conn, Notification notification) throws SQLException {
        String sql = "INSERT INTO notification (customer_id, type, title, message, is_read) VALUES (?, ?, ?, ?, ?)";
        PreparedStatement stmt = null;
        try {
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setLong(1, notification.getCustomerId());
            stmt.setString(2, notification.getType());
            stmt.setString(3, notification.getTitle());
            stmt.setString(4, notification.getMessage());
            stmt.setInt(5, notification.isRead() ? 1 : 0);

            int affected = stmt.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        notification.setNotificationId(rs.getLong(1));
                    }
                }
                return true;
            }
            return false;
        } finally {
            DatabaseConfig.closeStatement(stmt);
        }
    }

    public boolean create(Notification notification) throws SQLException {
        Connection conn = null;
        try {
            conn = DatabaseConfig.getInstance().getConnection();
            return create(conn, notification);
        } finally {
            DatabaseConfig.closeConnection(conn);
        }
    }

    public List<Notification> getByCustomerId(long customerId, int limit) throws SQLException {
        String sql = "SELECT * FROM notification WHERE customer_id = ? ORDER BY created_at DESC LIMIT ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DatabaseConfig.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setLong(1, customerId);
            stmt.setInt(2, limit);
            rs = stmt.executeQuery();
            List<Notification> list = new ArrayList<>();
            while (rs.next()) {
                Notification n = new Notification();
                n.setNotificationId(rs.getLong("notification_id"));
                n.setCustomerId(rs.getLong("customer_id"));
                n.setType(rs.getString("type"));
                n.setTitle(rs.getString("title"));
                n.setMessage(rs.getString("message"));
                n.setRead(rs.getInt("is_read") == 1);
                n.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(n);
            }
            return list;
        } finally {
            DatabaseConfig.closeResultSet(rs);
            DatabaseConfig.closeStatement(stmt);
            DatabaseConfig.closeConnection(conn);
        }
    }

    public boolean markAllAsRead(long customerId) throws SQLException {
        String sql = "UPDATE notification SET is_read = 1 WHERE customer_id = ? AND is_read = 0";
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DatabaseConfig.getInstance().getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setLong(1, customerId);
            return stmt.executeUpdate() > 0;
        } finally {
            DatabaseConfig.closeStatement(stmt);
            DatabaseConfig.closeConnection(conn);
        }
    }
}
