package com.vgb.dao;

import com.vgb.config.DatabaseConfig;
import com.vgb.model.Customer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * CustomerDAOImpl: Implementation of CustomerDAO interface
 */
public class CustomerDAOImpl implements CustomerDAO {
    private static final Logger logger = LoggerFactory.getLogger(CustomerDAOImpl.class);
    private DatabaseConfig dbConfig = DatabaseConfig.getInstance();

    private static final String CREATE_CUSTOMER = 
        "INSERT INTO customer (first_name, middle_name, last_name, father_name, mother_name, dob, gender, marital_status, nationality, email, pan_card, aadhaar_card, phone_no, alt_phone_no, address, perm_address, city, state, zip_code, username, pin, password, status, occupation, annual_income) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    private static final String GET_CUSTOMER_BY_ID = 
        "SELECT * FROM customer WHERE customer_id = ?";
    private static final String GET_CUSTOMER_BY_USERNAME = 
        "SELECT * FROM customer WHERE username = ?";
    private static final String GET_CUSTOMER_BY_EMAIL = 
        "SELECT * FROM customer WHERE email = ?";
    private static final String GET_ALL_CUSTOMERS = 
        "SELECT * FROM customer ORDER BY created_at DESC";
    private static final String GET_CUSTOMERS_BY_STATUS = 
        "SELECT * FROM customer WHERE status = ? ORDER BY created_at DESC";
    private static final String UPDATE_CUSTOMER = 
        "UPDATE customer SET first_name = ?, middle_name = ?, last_name = ?, father_name = ?, mother_name = ?, dob = ?, gender = ?, marital_status = ?, nationality = ?, email = ?, phone_no = ?, alt_phone_no = ?, address = ?, perm_address = ?, city = ?, state = ?, zip_code = ?, occupation = ?, annual_income = ? WHERE customer_id = ?";
    private static final String UPDATE_CUSTOMER_STATUS = 
        "UPDATE customer SET status = ? WHERE customer_id = ?";
    private static final String UPDATE_CUSTOMER_PASSWORD = 
        "UPDATE customer SET password = ? WHERE customer_id = ?";
    private static final String UPDATE_CUSTOMER_PIN = 
        "UPDATE customer SET pin = ? WHERE customer_id = ?";
    private static final String UPDATE_CUSTOMER_AVATAR = 
        "UPDATE customer SET avatar_path = ? WHERE customer_id = ?";
    private static final String UPDATE_CUSTOMER_USERNAME = 
        "UPDATE customer SET username = ? WHERE customer_id = ?";
    private static final String DELETE_CUSTOMER = 
        "DELETE FROM customer WHERE customer_id = ?";
    private static final String CHECK_EMAIL_EXISTS = 
        "SELECT COUNT(*) FROM customer WHERE email = ?";
    private static final String CHECK_USERNAME_EXISTS = 
        "SELECT COUNT(*) FROM customer WHERE username = ?";
    private static final String CHECK_PHONE_EXISTS = 
        "SELECT COUNT(*) FROM customer WHERE phone_no = ?";
    private static final String CHECK_PAN_EXISTS = 
        "SELECT COUNT(*) FROM customer WHERE pan_card = ?";
    private static final String CHECK_AADHAAR_EXISTS = 
        "SELECT COUNT(*) FROM customer WHERE aadhaar_card = ?";

    @Override
    public boolean create(Customer customer) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(CREATE_CUSTOMER);
            stmt.setString(1, customer.getFirstName());
            stmt.setString(2, customer.getMiddleName());
            stmt.setString(3, customer.getLastName());
            stmt.setString(4, customer.getFatherName());
            stmt.setString(5, customer.getMotherName());
            stmt.setDate(6, customer.getDob() != null ? java.sql.Date.valueOf(customer.getDob()) : null);
            stmt.setString(7, customer.getGender());
            stmt.setString(8, customer.getMaritalStatus());
            stmt.setString(9, customer.getNationality() != null ? customer.getNationality() : "Indian");
            stmt.setString(10, customer.getEmail());
            stmt.setString(11, customer.getPanCard());
            stmt.setString(12, customer.getAadhaarCard());
            stmt.setString(13, customer.getPhoneNo());
            stmt.setString(14, customer.getAltPhoneNo());
            stmt.setString(15, customer.getAddress());
            stmt.setString(16, customer.getPermAddress());
            stmt.setString(17, customer.getCity());
            stmt.setString(18, customer.getState());
            stmt.setString(19, customer.getZipCode());
            stmt.setString(20, customer.getUsername());
            stmt.setString(21, customer.getPin());
            stmt.setString(22, customer.getPassword());
            stmt.setString(23, customer.getStatus() != null ? customer.getStatus() : "active");
            stmt.setString(24, customer.getOccupation());
            stmt.setBigDecimal(25, customer.getAnnualIncome());

            int result = stmt.executeUpdate();
            logger.info("Customer created: {}", customer.getEmail());
            return result > 0;

        } catch (SQLException e) {
            logger.error("Error creating customer", e);
            throw new Exception("Failed to create customer", e);
        } finally {
            DatabaseConfig.closeResources(null, stmt, conn);
        }
    }

    @Override
    public Customer getById(long customerId) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(GET_CUSTOMER_BY_ID);
            stmt.setLong(1, customerId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToCustomer(rs);
            }
            return null;

        } catch (SQLException e) {
            logger.error("Error fetching customer by ID: {}", customerId, e);
            throw new Exception("Failed to fetch customer", e);
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    @Override
    public Customer getByUsername(String username) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(GET_CUSTOMER_BY_USERNAME);
            stmt.setString(1, username);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToCustomer(rs);
            }
            return null;

        } catch (SQLException e) {
            logger.error("Error fetching customer by username: {}", username, e);
            throw new Exception("Failed to fetch customer", e);
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    @Override
    public Customer getByEmail(String email) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(GET_CUSTOMER_BY_EMAIL);
            stmt.setString(1, email);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToCustomer(rs);
            }
            return null;

        } catch (SQLException e) {
            logger.error("Error fetching customer by email: {}", email, e);
            throw new Exception("Failed to fetch customer", e);
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    @Override
    public List<Customer> getAll() throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Customer> customers = new ArrayList<>();

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(GET_ALL_CUSTOMERS);
            rs = stmt.executeQuery();

            while (rs.next()) {
                customers.add(mapResultSetToCustomer(rs));
            }
            logger.info("Fetched {} customers", customers.size());
            return customers;

        } catch (SQLException e) {
            logger.error("Error fetching all customers", e);
            throw new Exception("Failed to fetch customers", e);
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    @Override
    public List<Customer> getByStatus(String status) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Customer> customers = new ArrayList<>();

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(GET_CUSTOMERS_BY_STATUS);
            stmt.setString(1, status);
            rs = stmt.executeQuery();

            while (rs.next()) {
                customers.add(mapResultSetToCustomer(rs));
            }
            logger.info("Fetched {} customers with status: {}", customers.size(), status);
            return customers;

        } catch (SQLException e) {
            logger.error("Error fetching customers by status", e);
            throw new Exception("Failed to fetch customers", e);
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    @Override
    public boolean update(Customer customer) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(UPDATE_CUSTOMER);
            stmt.setString(1, customer.getFirstName());
            stmt.setString(2, customer.getMiddleName());
            stmt.setString(3, customer.getLastName());
            stmt.setString(4, customer.getFatherName());
            stmt.setString(5, customer.getMotherName());
            stmt.setDate(6, customer.getDob() != null ? java.sql.Date.valueOf(customer.getDob()) : null);
            stmt.setString(7, customer.getGender());
            stmt.setString(8, customer.getMaritalStatus());
            stmt.setString(9, customer.getNationality());
            stmt.setString(10, customer.getEmail());
            stmt.setString(11, customer.getPhoneNo());
            stmt.setString(12, customer.getAltPhoneNo());
            stmt.setString(13, customer.getAddress());
            stmt.setString(14, customer.getPermAddress());
            stmt.setString(15, customer.getCity());
            stmt.setString(16, customer.getState());
            stmt.setString(17, customer.getZipCode());
            stmt.setString(18, customer.getOccupation());
            stmt.setBigDecimal(19, customer.getAnnualIncome());
            stmt.setLong(20, customer.getCustomerId());

            int result = stmt.executeUpdate();
            logger.info("Customer updated: {}", customer.getCustomerId());
            return result > 0;

        } catch (SQLException e) {
            logger.error("Error updating customer", e);
            throw new Exception("Failed to update customer", e);
        } finally {
            DatabaseConfig.closeResources(null, stmt, conn);
        }
    }

    @Override
    public boolean updateStatus(long customerId, String status) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(UPDATE_CUSTOMER_STATUS);
            stmt.setString(1, status);
            stmt.setLong(2, customerId);

            int result = stmt.executeUpdate();
            logger.info("Customer status updated - ID: {}, Status: {}", customerId, status);
            return result > 0;

        } catch (SQLException e) {
            logger.error("Error updating customer status", e);
            throw new Exception("Failed to update customer status", e);
        } finally {
            DatabaseConfig.closeResources(null, stmt, conn);
        }
    }

    @Override
    public boolean updatePassword(long customerId, String newPassword) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(UPDATE_CUSTOMER_PASSWORD);
            stmt.setString(1, newPassword);
            stmt.setLong(2, customerId);

            int result = stmt.executeUpdate();
            logger.info("Customer password updated: {}", customerId);
            return result > 0;

        } catch (SQLException e) {
            logger.error("Error updating customer password", e);
            throw new Exception("Failed to update password", e);
        } finally {
            DatabaseConfig.closeResources(null, stmt, conn);
        }
    }

    @Override
    public boolean updatePIN(long customerId, String newPIN) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(UPDATE_CUSTOMER_PIN);
            stmt.setString(1, newPIN);
            stmt.setLong(2, customerId);

            int result = stmt.executeUpdate();
            logger.info("Customer PIN updated: {}", customerId);
            return result > 0;

        } catch (SQLException e) {
            logger.error("Error updating customer PIN", e);
            throw new Exception("Failed to update PIN", e);
        } finally {
            DatabaseConfig.closeResources(null, stmt, conn);
        }
    }

    @Override
    public boolean updateAvatarPath(long customerId, String avatarPath) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(UPDATE_CUSTOMER_AVATAR);
            stmt.setString(1, avatarPath);
            stmt.setLong(2, customerId);

            int result = stmt.executeUpdate();
            logger.info("Customer avatar path updated: {}", customerId);
            return result > 0;

        } catch (SQLException e) {
            logger.error("Error updating customer avatar path", e);
            throw new Exception("Failed to update avatar path", e);
        } finally {
            DatabaseConfig.closeResources(null, stmt, conn);
        }
    }

    @Override
    public boolean updateUsername(long customerId, String newUsername) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(UPDATE_CUSTOMER_USERNAME);
            stmt.setString(1, newUsername);
            stmt.setLong(2, customerId);

            int result = stmt.executeUpdate();
            logger.info("Customer username updated: {}", customerId);
            return result > 0;

        } catch (SQLException e) {
            logger.error("Error updating customer username", e);
            throw new Exception("Failed to update username", e);
        } finally {
            DatabaseConfig.closeResources(null, stmt, conn);
        }
    }

    @Override
    public boolean delete(long customerId) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(DELETE_CUSTOMER);
            stmt.setLong(1, customerId);

            int result = stmt.executeUpdate();
            logger.info("Customer deleted: {}", customerId);
            return result > 0;

        } catch (SQLException e) {
            logger.error("Error deleting customer", e);
            throw new Exception("Failed to delete customer", e);
        } finally {
            DatabaseConfig.closeResources(null, stmt, conn);
        }
    }

    @Override
    public boolean existsByEmail(String email) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(CHECK_EMAIL_EXISTS);
            stmt.setString(1, email);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;

        } catch (SQLException e) {
            logger.error("Error checking email existence", e);
            throw new Exception("Failed to check email", e);
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    @Override
    public boolean existsByUsername(String username) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(CHECK_USERNAME_EXISTS);
            stmt.setString(1, username);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;

        } catch (SQLException e) {
            logger.error("Error checking username existence", e);
            throw new Exception("Failed to check username", e);
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    @Override
    public boolean existsByPhone(String phone) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(CHECK_PHONE_EXISTS);
            stmt.setString(1, phone);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;

        } catch (SQLException e) {
            logger.error("Error checking phone existence", e);
            throw new Exception("Failed to check phone", e);
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    @Override
    public boolean existsByPan(String pan) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(CHECK_PAN_EXISTS);
            stmt.setString(1, pan);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;

        } catch (SQLException e) {
            logger.error("Error checking PAN existence", e);
            throw new Exception("Failed to check PAN", e);
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    @Override
    public boolean existsByAadhaar(String aadhaar) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbConfig.getConnection();
            stmt = conn.prepareStatement(CHECK_AADHAAR_EXISTS);
            stmt.setString(1, aadhaar);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;

        } catch (SQLException e) {
            logger.error("Error checking Aadhaar existence", e);
            throw new Exception("Failed to check Aadhaar", e);
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    /**
     * Map ResultSet row to Customer object
     */
    private Customer mapResultSetToCustomer(ResultSet rs) throws SQLException {
        Customer customer = new Customer();
        customer.setCustomerId(rs.getLong("customer_id"));
        customer.setFirstName(rs.getString("first_name"));
        customer.setMiddleName(rs.getString("middle_name"));
        customer.setLastName(rs.getString("last_name"));
        customer.setFatherName(rs.getString("father_name"));
        customer.setMotherName(rs.getString("mother_name"));
        
        Date dobDate = rs.getDate("dob");
        if (dobDate != null) {
            customer.setDob(dobDate.toLocalDate());
        }
        
        customer.setGender(rs.getString("gender"));
        customer.setMaritalStatus(rs.getString("marital_status"));
        customer.setNationality(rs.getString("nationality"));
        customer.setEmail(rs.getString("email"));
        customer.setPanCard(rs.getString("pan_card"));
        customer.setAadhaarCard(rs.getString("aadhaar_card"));
        customer.setPhoneNo(rs.getString("phone_no"));
        customer.setAltPhoneNo(rs.getString("alt_phone_no"));
        customer.setAddress(rs.getString("address"));
        customer.setPermAddress(rs.getString("perm_address"));
        customer.setCity(rs.getString("city"));
        customer.setState(rs.getString("state"));
        customer.setZipCode(rs.getString("zip_code"));
        customer.setUsername(rs.getString("username"));
        customer.setPin(rs.getString("pin"));
        customer.setPassword(rs.getString("password"));
        customer.setStatus(rs.getString("status"));
        customer.setAvatarPath(rs.getString("avatar_path"));
        customer.setOccupation(rs.getString("occupation"));
        customer.setAnnualIncome(rs.getBigDecimal("annual_income"));
        
        try {
            customer.setGuardianName(rs.getString("guardian_name"));
            customer.setGuardianRelationship(rs.getString("guardian_relationship"));
            customer.setGuardianPhone(rs.getString("guardian_phone"));
            customer.setGuardianAadhaar(rs.getString("guardian_aadhaar"));
            customer.setGuardianPan(rs.getString("guardian_pan"));
            customer.setGuardianSignaturePath(rs.getString("guardian_signature_path"));
            customer.setBirthCertificatePath(rs.getString("birth_certificate_path"));
            customer.setSchoolCollegeName(rs.getString("school_college_name"));
            customer.setStudentId(rs.getString("student_id"));
            customer.setCourse(rs.getString("course"));
            customer.setAdmissionNumber(rs.getString("admission_number"));
            customer.setCompanyName(rs.getString("company_name"));
            customer.setEmployerName(rs.getString("employer_name"));
            customer.setEmployeeId(rs.getString("employee_id"));
            customer.setSalaryFrequency(rs.getString("salary_frequency"));
            customer.setRelationshipManager(rs.getString("relationship_manager"));
            customer.setAadhaarProofPath(rs.getString("aadhaar_proof_path"));
            customer.setPanProofPath(rs.getString("pan_proof_path"));
            customer.setPassportCopyPath(rs.getString("passport_copy_path"));
            customer.setDrivingLicenseCopyPath(rs.getString("driving_license_copy_path"));
            customer.setVoterIdCopyPath(rs.getString("voter_id_copy_path"));
        } catch (SQLException e) {
            // ignore if columns don't exist
        }

        Timestamp timestamp = rs.getTimestamp("created_at");
        if (timestamp != null) {
            customer.setCreatedAt(timestamp.toLocalDateTime());
        }
        
        return customer;
    }
}
