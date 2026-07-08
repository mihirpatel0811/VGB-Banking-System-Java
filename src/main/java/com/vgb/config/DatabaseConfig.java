package com.vgb.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.sql.*;

/**
 * DatabaseConfig: Manages database connection pooling and initialization
 * Provides singleton instance of database connections
 */
public class DatabaseConfig {
    private static final Logger logger = LoggerFactory.getLogger(DatabaseConfig.class);

    // Database credentials
    private static final String DB_DRIVER = "com.mysql.cj.jdbc.Driver";
    private static final String DB_URL = "jdbc:mysql://localhost:3306/vgb_database?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "17193";

    // Connection pool
    private static DatabaseConfig instance;

    private DatabaseConfig() {
        initializeDriver();
        verifyAndUpgradeSchema();
    }

    /**
     * Verify database schema and upgrade if necessary (add pan_card and
     * aadhaar_card to customer table)
     */
    private void verifyAndUpgradeSchema() {
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        try {
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            stmt = conn.createStatement();
            DatabaseMetaData metaData = conn.getMetaData();

            // 1. Upgrade customer table if needed (pan_card / aadhaar_card)
            rs = metaData.getColumns(null, null, "customer", "pan_card");
            if (!rs.next()) {
                logger.info("Upgrading schema: Adding pan_card and aadhaar_card to customer table");
                stmt.execute("ALTER TABLE customer ADD COLUMN pan_card VARCHAR(10) UNIQUE AFTER email");
                stmt.execute("ALTER TABLE customer ADD COLUMN aadhaar_card VARCHAR(12) UNIQUE AFTER pan_card");
                logger.info("Customer schema upgraded successfully!");
            } else {
                logger.debug("Schema verification: customer KYC columns are present.");
            }
            rs.close();

            // 1b. Upgrade customer table for Minor, Student, Salary, and RM details
            rs = metaData.getColumns(null, null, "customer", "guardian_name");
            if (!rs.next()) {
                logger.info("Upgrading schema: Adding guardian, student, salary, and relationship manager columns to customer table");
                stmt.execute("ALTER TABLE customer ADD COLUMN guardian_name VARCHAR(100) NULL AFTER voter_id_copy_path");
                stmt.execute("ALTER TABLE customer ADD COLUMN guardian_relationship VARCHAR(50) NULL AFTER guardian_name");
                stmt.execute("ALTER TABLE customer ADD COLUMN guardian_phone VARCHAR(20) NULL AFTER guardian_relationship");
                stmt.execute("ALTER TABLE customer ADD COLUMN guardian_aadhaar VARCHAR(12) NULL AFTER guardian_phone");
                stmt.execute("ALTER TABLE customer ADD COLUMN guardian_pan VARCHAR(10) NULL AFTER guardian_aadhaar");
                stmt.execute("ALTER TABLE customer ADD COLUMN guardian_signature_path VARCHAR(255) NULL AFTER guardian_pan");
                stmt.execute("ALTER TABLE customer ADD COLUMN birth_certificate_path VARCHAR(255) NULL AFTER guardian_signature_path");
                stmt.execute("ALTER TABLE customer ADD COLUMN school_college_name VARCHAR(150) NULL AFTER birth_certificate_path");
                stmt.execute("ALTER TABLE customer ADD COLUMN student_id VARCHAR(50) NULL AFTER school_college_name");
                stmt.execute("ALTER TABLE customer ADD COLUMN course VARCHAR(100) NULL AFTER student_id");
                stmt.execute("ALTER TABLE customer ADD COLUMN admission_number VARCHAR(50) NULL AFTER course");
                stmt.execute("ALTER TABLE customer ADD COLUMN company_name VARCHAR(150) NULL AFTER admission_number");
                stmt.execute("ALTER TABLE customer ADD COLUMN employer_name VARCHAR(100) NULL AFTER company_name");
                stmt.execute("ALTER TABLE customer ADD COLUMN employee_id VARCHAR(50) NULL AFTER employer_name");
                stmt.execute("ALTER TABLE customer ADD COLUMN salary_frequency VARCHAR(50) NULL AFTER employee_id");
                stmt.execute("ALTER TABLE customer ADD COLUMN relationship_manager VARCHAR(100) NULL AFTER salary_frequency");
                logger.info("Customer table minor/student/salary schema upgraded successfully!");
            }
            rs.close();

            // 2. Upgrade account table if needed (has_atm_card, has_cheque_book,
            // has_passbook)
            rs = metaData.getColumns(null, null, "account", "has_atm_card");
            if (!rs.next()) {
                logger.info(
                        "Upgrading schema: Adding services columns (has_atm_card, has_cheque_book, has_passbook) to account table");
                stmt.execute("ALTER TABLE account ADD COLUMN has_atm_card TINYINT(1) NOT NULL DEFAULT 0 AFTER status");
                stmt.execute(
                        "ALTER TABLE account ADD COLUMN has_cheque_book TINYINT(1) NOT NULL DEFAULT 0 AFTER has_atm_card");
                stmt.execute(
                        "ALTER TABLE account ADD COLUMN has_passbook TINYINT(1) NOT NULL DEFAULT 1 AFTER has_cheque_book");
                logger.info("Account services schema upgraded successfully!");
            } else {
                logger.debug("Schema verification: account services columns are present.");
            }
            rs.close();

            // 2b. Upgrade account table for FD/RD, pension, and generated CBS values
            rs = metaData.getColumns(null, null, "account", "fd_rd_tenure_months");
            if (!rs.next()) {
                logger.info("Upgrading schema: Adding FD/RD settings and CBS identifiers to account table");
                stmt.execute("ALTER TABLE account ADD COLUMN fd_rd_tenure_months INT NULL AFTER pin");
                stmt.execute("ALTER TABLE account ADD COLUMN fd_rd_interest_rate DECIMAL(5, 2) NULL AFTER fd_rd_tenure_months");
                stmt.execute("ALTER TABLE account ADD COLUMN fd_rd_maturity_amount DECIMAL(15, 4) NULL AFTER fd_rd_interest_rate");
                stmt.execute("ALTER TABLE account ADD COLUMN fd_rd_maturity_date DATE NULL AFTER fd_rd_maturity_amount");
                stmt.execute("ALTER TABLE account ADD COLUMN fd_rd_payout_option VARCHAR(50) NULL AFTER fd_rd_maturity_date");
                stmt.execute("ALTER TABLE account ADD COLUMN fd_rd_auto_renewal TINYINT(1) NOT NULL DEFAULT 0 AFTER fd_rd_payout_option");
                stmt.execute("ALTER TABLE account ADD COLUMN fd_rd_auto_debit TINYINT(1) NOT NULL DEFAULT 0 AFTER fd_rd_auto_renewal");
                stmt.execute("ALTER TABLE account ADD COLUMN application_ref_no VARCHAR(50) NULL UNIQUE AFTER fd_rd_auto_debit");
                stmt.execute("ALTER TABLE account ADD COLUMN passbook_number VARCHAR(50) NULL UNIQUE AFTER application_ref_no");
                stmt.execute("ALTER TABLE account ADD COLUMN atm_card_number VARCHAR(19) NULL UNIQUE AFTER passbook_number");
                stmt.execute("ALTER TABLE account ADD COLUMN is_pension_account TINYINT(1) NOT NULL DEFAULT 0 AFTER atm_card_number");
                logger.info("Account table FD/RD and CBS fields schema upgraded successfully!");
            }
            rs.close();

            // 3. Upgrade account_current table if needed (company category and contact
            // details)
            rs = metaData.getColumns(null, null, "account_current", "company_category");
            if (!rs.next()) {
                logger.info("Upgrading schema: Adding business details columns to account_current table");
                stmt.execute(
                        "ALTER TABLE account_current ADD COLUMN company_category VARCHAR(100) NULL AFTER overdraft_limit");
                stmt.execute(
                        "ALTER TABLE account_current ADD COLUMN company_phone VARCHAR(20) NULL AFTER company_category");
                stmt.execute(
                        "ALTER TABLE account_current ADD COLUMN company_email VARCHAR(100) NULL AFTER company_phone");
                stmt.execute(
                        "ALTER TABLE account_current ADD COLUMN company_address VARCHAR(255) NULL AFTER company_email");
                logger.info("Account current details schema upgraded successfully!");
            } else {
                logger.debug("Schema verification: account_current business columns are present.");
            }

            // 3b. Upgrade account_current table to add company_pan and company_aadhaar if needed
            rs = metaData.getColumns(null, null, "account_current", "company_pan");
            if (!rs.next()) {
                logger.info("Upgrading schema: Adding company_pan and company_aadhaar to account_current table");
                stmt.execute(
                        "ALTER TABLE account_current ADD COLUMN company_pan VARCHAR(10) NULL AFTER company_address");
                stmt.execute(
                        "ALTER TABLE account_current ADD COLUMN company_aadhaar VARCHAR(12) NULL AFTER company_pan");
                logger.info("Account current PAN/Aadhaar schema upgraded successfully!");
            } else {
                logger.debug("Schema verification: account_current PAN/Aadhaar columns are present.");
            }

            // 5. Create beneficiary table if needed
            try {
                rs = metaData.getTables(null, null, "beneficiary", null);
                if (!rs.next()) {
                    logger.info("Upgrading schema: Creating beneficiary table");
                    stmt.execute(
                        "CREATE TABLE beneficiary (" +
                        "    beneficiary_id BIGINT AUTO_INCREMENT PRIMARY KEY, " +
                        "    customer_id BIGINT NOT NULL, " +
                        "    account_id BIGINT NULL, " +
                        "    beneficiary_type VARCHAR(10) NOT NULL DEFAULT 'vgb', " +
                        "    account_number VARCHAR(50) NULL, " +
                        "    ifsc_code VARCHAR(20) NULL, " +
                        "    holder_name VARCHAR(100) NULL, " +
                        "    nickname VARCHAR(100) NULL, " +
                        "    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                        "    FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE, " +
                        "    FOREIGN KEY (account_id) REFERENCES account(account_id) ON DELETE CASCADE, " +
                        "    UNIQUE KEY unique_beneficiary (customer_id, account_id)" +
                        ")"
                    );
                    logger.info("Beneficiary table created successfully!");
                } else {
                    logger.debug("Schema verification: beneficiary table is present.");
                }
            } catch (SQLException ex) {
                logger.warn("Beneficiary table creation error: {}", ex.getMessage());
            } finally {
                if (rs != null) {
                    try { rs.close(); } catch (SQLException e) {}
                }
            }

            // 6. Create card table if needed
            try {
                rs = metaData.getTables(null, null, "card", null);
                if (!rs.next()) {
                    logger.info("Upgrading schema: Creating card table");
                    stmt.execute(
                        "CREATE TABLE card (" +
                        "    card_id BIGINT AUTO_INCREMENT PRIMARY KEY, " +
                        "    account_id BIGINT NOT NULL, " +
                        "    customer_id BIGINT NOT NULL, " +
                        "    card_number VARCHAR(19) NOT NULL UNIQUE, " +
                        "    card_type ENUM('debit', 'credit') NOT NULL, " +
                        "    card_provider ENUM('visa', 'mastercard', 'rupay') NOT NULL DEFAULT 'visa', " +
                        "    card_holder_name VARCHAR(100) NOT NULL, " +
                        "    cvv CHAR(3) NOT NULL, " +
                        "    expiry_date DATE NOT NULL, " +
    "    status ENUM('pending', 'active', 'closed', 'expired') NOT NULL DEFAULT 'pending', " +
    "    daily_limit DECIMAL(15, 4) NOT NULL DEFAULT 50000.0000, " +
                        "    atm_limit DECIMAL(15, 4) NOT NULL DEFAULT 25000.0000, " +
                        "    online_limit DECIMAL(15, 4) NOT NULL DEFAULT 50000.0000, " +
                        "    international_enabled TINYINT(1) NOT NULL DEFAULT 0, " +
                        "    card_fee DECIMAL(15, 4) NOT NULL DEFAULT 250.0000, " +
                        "    outstanding_balance DECIMAL(15, 4) NOT NULL DEFAULT 0.0000, " +
                        "    is_fee_paid TINYINT(1) NOT NULL DEFAULT 0, " +
                        "    card_tier VARCHAR(20) NOT NULL DEFAULT 'classic', " +
                        "    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                        "    FOREIGN KEY (account_id) REFERENCES account(account_id) ON DELETE CASCADE, " +
                        "    FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE" +
                        ")"
                    );
                    logger.info("Card table created successfully!");
                } else {
                    logger.debug("Schema verification: card table is present.");
                    try (ResultSet cols = metaData.getColumns(null, null, "card", "atm_limit")) {
                        if (!cols.next()) {
                            logger.info("Migrating schema: adding limit columns to card table");
                            stmt.execute("ALTER TABLE card ADD COLUMN atm_limit DECIMAL(15, 4) NOT NULL DEFAULT 25000.0000");
                            stmt.execute("ALTER TABLE card ADD COLUMN online_limit DECIMAL(15, 4) NOT NULL DEFAULT 50000.0000");
                            stmt.execute("ALTER TABLE card ADD COLUMN international_enabled TINYINT(1) NOT NULL DEFAULT 0");
                            logger.info("Card table limits migration completed successfully.");
                        }
                    }
                    try (ResultSet cols = metaData.getColumns(null, null, "card", "card_tier")) {
                        if (!cols.next()) {
                            logger.info("Migrating schema: adding card_tier column to card table");
                            stmt.execute("ALTER TABLE card ADD COLUMN card_tier VARCHAR(20) NOT NULL DEFAULT 'classic'");
                            logger.info("Card table card_tier migration completed successfully.");
                        }
                    }
                }
            } catch (SQLException ex) {
                logger.warn("Card table creation error: {}", ex.getMessage());
            } finally {
                if (rs != null) {
                    try { rs.close(); } catch (SQLException e) {}
                }
            }

            // 3c. Create cheque_book_request table if needed
            try {
                rs = metaData.getTables(null, null, "cheque_book_request", null);
                if (!rs.next()) {
                    logger.info("Upgrading schema: Creating cheque_book_request table");
                    stmt.execute(
                        "CREATE TABLE cheque_book_request (" +
                        "    request_id BIGINT AUTO_INCREMENT PRIMARY KEY, " +
                        "    account_id BIGINT NOT NULL, " +
                        "    customer_id BIGINT NOT NULL, " +
                        "    leaves_count INT NOT NULL DEFAULT 50, " +
                        "    status ENUM('pending', 'approved', 'rejected', 'delivered') NOT NULL DEFAULT 'pending', " +
                        "    charges DECIMAL(15, 4) NOT NULL DEFAULT 150.0000, " +
                        "    is_charges_paid TINYINT(1) NOT NULL DEFAULT 0, " +
                        "    requested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                        "    FOREIGN KEY (account_id) REFERENCES account(account_id) ON DELETE CASCADE, " +
                        "    FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE" +
                        ")"
                    );
                    logger.info("Cheque book request table created successfully!");
                } else {
                    logger.debug("Schema verification: cheque_book_request table is present.");
                }
            } catch (SQLException ex) {
                logger.warn("Cheque book request table creation error: {}", ex.getMessage());
            } finally {
                if (rs != null) {
                    try { rs.close(); } catch (SQLException e) {}
                }
            }

            // 3ca. Create passbook_request table if needed
            try {
                rs = metaData.getTables(null, null, "passbook_request", null);
                if (!rs.next()) {
                    logger.info("Upgrading schema: Creating passbook_request table");
                    stmt.execute(
                        "CREATE TABLE passbook_request (" +
                        "    request_id BIGINT AUTO_INCREMENT PRIMARY KEY, " +
                        "    account_id BIGINT NOT NULL, " +
                        "    customer_id BIGINT NOT NULL, " +
                        "    request_type ENUM('new', 'renew') NOT NULL DEFAULT 'new', " +
                        "    status ENUM('pending', 'approved', 'rejected', 'delivered') NOT NULL DEFAULT 'pending', " +
                        "    charges DECIMAL(15, 4) NOT NULL DEFAULT 100.0000, " +
                        "    is_charges_paid TINYINT(1) NOT NULL DEFAULT 0, " +
                        "    requested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                        "    FOREIGN KEY (account_id) REFERENCES account(account_id) ON DELETE CASCADE, " +
                        "    FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE" +
                        ")"
                    );
                    logger.info("Passbook request table created successfully!");
                } else {
                    logger.debug("Schema verification: passbook_request table is present.");
                }
            } catch (SQLException ex) {
                logger.warn("Passbook request table creation error: {}", ex.getMessage());
            } finally {
                if (rs != null) {
                    try { rs.close(); } catch (SQLException e) {}
                }
            }

            // 3c. Modify loan_type in loan table to support more types like Business Loan and Vehicle Loan
            try {
                stmt.execute("ALTER TABLE loan MODIFY COLUMN loan_type VARCHAR(50) NOT NULL");
                logger.info("Loan loan_type column modified successfully to VARCHAR(50)!");
            } catch (SQLException ex) {
                logger.debug("Column loan_type alteration skipped: {}", ex.getMessage());
            }

            // 3d. Upgrade loan table to add form_details if needed
            rs = metaData.getColumns(null, null, "loan", "form_details");
            if (!rs.next()) {
                logger.info("Upgrading schema: Adding form_details column to loan table");
                stmt.execute("ALTER TABLE loan ADD COLUMN form_details TEXT NULL");
                logger.info("Loan schema upgraded successfully!");
            }
            rs.close();

            // 3e. Upgrade customer table to add avatar_path if needed
            rs = metaData.getColumns(null, null, "customer", "avatar_path");
            if (!rs.next()) {
                logger.info("Upgrading schema: Adding avatar_path column to customer table");
                stmt.execute("ALTER TABLE customer ADD COLUMN avatar_path VARCHAR(255) NULL");
                logger.info("Customer schema upgraded successfully!");
            }
            rs.close();

            // 3f. Upgrade admin table to add pin if needed
            rs = metaData.getColumns(null, null, "admin", "pin");
            if (!rs.next()) {
                logger.info("Upgrading schema: Adding pin column to admin table");
                stmt.execute("ALTER TABLE admin ADD COLUMN pin VARCHAR(4) NOT NULL DEFAULT '1234'");
                logger.info("Admin schema upgraded successfully with default pin '1234'!");
            }
            rs.close();

            // 3g. Upgrade beneficiary table to allow null account_id and add other-bank columns if needed
            try {
                stmt.execute("ALTER TABLE beneficiary ALTER COLUMN account_id BIGINT NULL");
                logger.info("Modified beneficiary account_id to NULLABLE (H2 style)");
            } catch (SQLException ex) {
                try {
                    stmt.execute("ALTER TABLE beneficiary MODIFY COLUMN account_id BIGINT NULL");
                    logger.info("Modified beneficiary account_id to NULLABLE (MySQL style)");
                } catch (SQLException ex2) {
                    logger.debug("Failed to modify beneficiary account_id: {}", ex2.getMessage());
                }
            }

            rs = metaData.getColumns(null, null, "beneficiary", "beneficiary_type");
            if (!rs.next()) {
                logger.info("Upgrading schema: Adding beneficiary_type column to beneficiary table");
                stmt.execute("ALTER TABLE beneficiary ADD COLUMN beneficiary_type VARCHAR(10) NOT NULL DEFAULT 'vgb'");
            }
            rs.close();

            rs = metaData.getColumns(null, null, "beneficiary", "account_number");
            if (!rs.next()) {
                logger.info("Upgrading schema: Adding account_number column to beneficiary table");
                stmt.execute("ALTER TABLE beneficiary ADD COLUMN account_number VARCHAR(50) NULL");
            }
            rs.close();

            rs = metaData.getColumns(null, null, "beneficiary", "ifsc_code");
            if (!rs.next()) {
                logger.info("Upgrading schema: Adding ifsc_code column to beneficiary table");
                stmt.execute("ALTER TABLE beneficiary ADD COLUMN ifsc_code VARCHAR(20) NULL");
            }
            rs.close();

            rs = metaData.getColumns(null, null, "beneficiary", "holder_name");
            if (!rs.next()) {
                logger.info("Upgrading schema: Adding holder_name column to beneficiary table");
                stmt.execute("ALTER TABLE beneficiary ADD COLUMN holder_name VARCHAR(100) NULL");
            }
            rs.close();

            // 3h. Upgrade transaction table for additional transfer/withdrawal details
            rs = metaData.getColumns(null, null, "transaction", "transfer_mode");
            if (!rs.next()) {
                logger.info("Upgrading schema: Adding transfer_mode and beneficiary columns to transaction table");
                stmt.execute("ALTER TABLE transaction ADD COLUMN transfer_mode VARCHAR(50) NULL");
                stmt.execute("ALTER TABLE transaction ADD COLUMN sender_account_number VARCHAR(20) NULL");
                stmt.execute("ALTER TABLE transaction ADD COLUMN receiver_account_number VARCHAR(20) NULL");
                stmt.execute("ALTER TABLE transaction ADD COLUMN beneficiary_name VARCHAR(100) NULL");
                stmt.execute("ALTER TABLE transaction ADD COLUMN beneficiary_ifsc VARCHAR(20) NULL");
                stmt.execute("ALTER TABLE transaction ADD COLUMN beneficiary_bank VARCHAR(100) NULL");
                stmt.execute("ALTER TABLE transaction ADD COLUMN beneficiary_branch VARCHAR(100) NULL");
                stmt.execute("ALTER TABLE transaction ADD COLUMN performed_by_id BIGINT NULL");
                logger.info("Transaction table schema upgraded successfully!");
            }
            rs.close();

            // 3i. Upgrade database with cheque_book and cheque_leaf tables if missing
            rs = metaData.getTables(null, null, "cheque_book", null);
            if (!rs.next()) {
                logger.info("Upgrading schema: Creating cheque_book and cheque_leaf tables");
                stmt.execute("CREATE TABLE cheque_book (" +
                             "chequebook_id BIGINT AUTO_INCREMENT PRIMARY KEY, " +
                             "account_id BIGINT NOT NULL, " +
                             "chequebook_number VARCHAR(50) NOT NULL UNIQUE, " +
                             "start_cheque_no INT NOT NULL, " +
                             "end_cheque_no INT NOT NULL, " +
                             "status VARCHAR(20) NOT NULL DEFAULT 'active', " +
                             "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                             "FOREIGN KEY (account_id) REFERENCES account(account_id) ON DELETE CASCADE)");

                stmt.execute("CREATE TABLE cheque_leaf (" +
                             "cheque_id BIGINT AUTO_INCREMENT PRIMARY KEY, " +
                             "chequebook_id BIGINT NOT NULL, " +
                             "cheque_number VARCHAR(20) NOT NULL, " +
                             "status VARCHAR(20) NOT NULL DEFAULT 'unused', " +
                             "used_at TIMESTAMP NULL, " +
                             "FOREIGN KEY (chequebook_id) REFERENCES cheque_book(chequebook_id) ON DELETE CASCADE, " +
                             "UNIQUE KEY unique_cheque (chequebook_id, cheque_number))");
                logger.info("Cheque book tracking tables created successfully!");
            }
            rs.close();

            // 4. Upgrade decimal columns in database if they are too small
            upgradeColumnDecimalIfNeeded(conn, stmt, metaData, "transaction", "amount", "DECIMAL(15, 4) NOT NULL");
            upgradeColumnDecimalIfNeeded(conn, stmt, metaData, "account", "balance", "DECIMAL(15, 4) NOT NULL DEFAULT 0.0000");
            upgradeColumnDecimalIfNeeded(conn, stmt, metaData, "loan", "principal_amount", "DECIMAL(15, 4) NOT NULL");
            upgradeColumnDecimalIfNeeded(conn, stmt, metaData, "loan", "remaining_balance", "DECIMAL(15, 4) NOT NULL");
            upgradeColumnDecimalIfNeeded(conn, stmt, metaData, "repayment", "amount_paid", "DECIMAL(15, 4) NOT NULL");
            upgradeColumnDecimalIfNeeded(conn, stmt, metaData, "repayment", "principal_component", "DECIMAL(15, 4) NOT NULL");
            upgradeColumnDecimalIfNeeded(conn, stmt, metaData, "repayment", "interest_component", "DECIMAL(15, 4) NOT NULL");
        } catch (SQLException e) {
            logger.warn("Database schema verification/upgrade skipped or encountered a non-critical error: {}",
                    e.getMessage());
        } finally {
            try {
                if (rs != null)
                    rs.close();
            } catch (SQLException e) {
            }
            try {
                if (stmt != null)
                    stmt.close();
            } catch (SQLException e) {
            }
            try {
                if (conn != null)
                    conn.close();
            } catch (SQLException e) {
            }
        }
    }

    /**
     * Check if a column needs upgrade and modify it programmatically
     */
    private void upgradeColumnDecimalIfNeeded(Connection conn, Statement stmt, DatabaseMetaData metaData, String tableName, String columnName, String columnDefinition) {
        ResultSet rs = null;
        try {
            rs = metaData.getColumns(null, null, tableName, columnName);
            if (rs.next()) {
                int size = rs.getInt("COLUMN_SIZE");
                int decimalDigits = rs.getInt("DECIMAL_DIGITS");
                if (size < 15) {
                    logger.info("Upgrading column {}.{} from DECIMAL({}, {}) to {}", tableName, columnName, size, decimalDigits, columnDefinition);
                    stmt.execute("ALTER TABLE " + tableName + " MODIFY COLUMN " + columnName + " " + columnDefinition);
                    logger.info("Column {}.{} upgraded successfully!", tableName, columnName);
                }
            }
        } catch (SQLException e) {
            logger.warn("Could not check/upgrade column {}.{}: {}", tableName, columnName, e.getMessage());
        } finally {
            if (rs != null) {
                try { rs.close(); } catch (SQLException e) {}
            }
        }
    }

    /**
     * Get singleton instance
     */
    public static synchronized DatabaseConfig getInstance() {
        if (instance == null) {
            instance = new DatabaseConfig();
        }
        return instance;
    }

    /**
     * Initialize JDBC driver
     */
    private void initializeDriver() {
        try {
            Class.forName(DB_DRIVER);
            logger.info("Database driver loaded successfully");
        } catch (ClassNotFoundException e) {
            logger.error("Failed to load database driver: {}", DB_DRIVER, e);
            throw new RuntimeException("Database driver not found", e);
        }
    }

    /**
     * Get database connection
     */
    public Connection getConnection() throws SQLException {
        try {
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            logger.debug("Database connection established");
            return conn;
        } catch (SQLException e) {
            logger.error("Failed to establish database connection", e);
            throw e;
        }
    }

    /**
     * Close connection safely
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
                logger.debug("Database connection closed");
            } catch (SQLException e) {
                logger.warn("Error closing connection", e);
            }
        }
    }

    /**
     * Close prepared statement safely
     */
    public static void closeStatement(PreparedStatement stmt) {
        if (stmt != null) {
            try {
                stmt.close();
            } catch (SQLException e) {
                logger.warn("Error closing statement", e);
            }
        }
    }

    /**
     * Close result set safely
     */
    public static void closeResultSet(ResultSet rs) {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
                logger.warn("Error closing result set", e);
            }
        }
    }

    /**
     * Close all resources safely
     */
    public static void closeResources(ResultSet rs, PreparedStatement stmt, Connection conn) {
        closeResultSet(rs);
        closeStatement(stmt);
        closeConnection(conn);
    }
}
