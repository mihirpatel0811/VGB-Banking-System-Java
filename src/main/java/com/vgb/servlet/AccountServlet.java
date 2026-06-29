package com.vgb.servlet;

import com.vgb.config.DatabaseConfig;
import com.vgb.model.Account;
import com.vgb.model.Customer;
import com.vgb.model.Transaction;
import com.vgb.service.AccountService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.UUID;

/**
 * AccountServlet: Handles administrative account management operations
 */
@WebServlet(name = "AccountServlet", value = "/account")
public class AccountServlet extends BaseServlet {
    private static final long serialVersionUID = 1L;

    private AccountService accountService = new AccountService();
    private com.vgb.dao.AccountDAOImpl accountDAO = new com.vgb.dao.AccountDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Long customerId = getUserId(request);
        Integer adminId = getAdminId(request);

        if (session == null || (customerId == null && adminId == null)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = getParameter(request, "action", "list");

        // Retrieve flash session alerts
        if (session.getAttribute("error") != null) {
            request.setAttribute("error", session.getAttribute("error"));
            session.removeAttribute("error");
        }
        if (session.getAttribute("success") != null) {
            request.setAttribute("success", session.getAttribute("success"));
            session.removeAttribute("success");
        }

        try {
            if (adminId != null) {
                // Admin Actions
                switch (action) {
                    case "details":
                        getAccountDetailsJsonAction(request, response);
                        break;
                    case "close":
                        closeAccountAction(request, response);
                        break;
                    case "delete":
                        deleteAccountAction(request, response);
                        break;
                    case "getTransactionsJson":
                        getTransactionsJsonAction(request, response);
                        break;
                    case "list":
                    default:
                        listAccounts(request, response);
                        break;
                }
            } else {
                // Customer Actions
                switch (action) {
                    case "transferPage":
                        showTransferPage(request, response, customerId);
                        break;
                    case "statement":
                    case "transactions":
                        showCustomerStatement(request, response, customerId);
                        break;
                    case "verifyBeneficiary":
                        verifyBeneficiaryAction(request, response, customerId);
                        break;
                    case "list":
                    default:
                        listCustomerAccounts(request, response, customerId);
                        break;
                }
            }
        } catch (Exception e) {
            logger.error("Error in AccountServlet doGet", e);
            response.setContentType("text/html;charset=UTF-8");
            try (java.io.PrintWriter out = response.getWriter()) {
                out.println("<!DOCTYPE html><html><head><title>System Error</title>");
                out.println("<style>body{font-family:sans-serif;background:#1e1e2e;color:#cdd6f4;padding:2rem;}pre{background:#11111b;padding:1.5rem;border-radius:8px;overflow-x:auto;border:1px solid #f38ba8;color:#f38ba8;}</style></head>");
                out.println("<body><h2>An Error Occurred in AccountServlet:</h2>");
                out.println("<p><b>Message:</b> " + e.getMessage() + "</p>");
                out.println("<h3>Stack Trace:</h3><pre>");
                e.printStackTrace(out);
                out.println("</pre></body></html>");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Long customerId = getUserId(request);
        Integer adminId = getAdminId(request);

        if (session == null || (customerId == null && adminId == null)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Unauthorized access");
            return;
        }

        String action = getParameter(request, "action", "");

        try {
            if (adminId != null) {
                // Admin POST actions
                if ("create".equalsIgnoreCase(action)) {
                    createAccountProcess(request, response);
                } else if ("edit".equalsIgnoreCase(action)) {
                    updateAccountProcess(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/account?action=list");
                }
            } else {
                // Customer POST actions
                switch (action) {
                    case "saveBeneficiary":
                        saveBeneficiaryAction(request, response, customerId);
                        break;
                    case "transfer":
                        processTransfer(request, response, customerId);
                        break;
                    case "withdraw":
                        processWithdraw(request, response, customerId);
                        break;
                    case "deposit":
                        processDeposit(request, response, customerId);
                        break;
                    default:
                        response.sendRedirect(request.getContextPath() + "/account?action=list");
                }
            }
        } catch (Exception e) {
            logger.error("Error in AccountServlet doPost for action: " + action, e);
            session.setAttribute("error", e.getMessage());
            String redirectUrl = getParameter(request, "redirectUrl", "/account?action=list");
            response.sendRedirect(request.getContextPath() + redirectUrl);
        }
    }

    private void updateAccountProcess(HttpServletRequest request, HttpServletResponse response) throws Exception {
        if (!validateCSRFToken(request)) {
            request.getSession().setAttribute("error", "Security validation check failed: Invalid CSRF Token.");
            response.sendRedirect(request.getContextPath() + "/account?action=list");
            return;
        }

        long accountId = Long.parseLong(getParameter(request, "accountId", "0"));
        String status = getParameter(request, "status", "active");
        String ifscCode = getParameter(request, "ifscCode", "");

        if (accountId <= 0 || ifscCode.isEmpty()) {
            request.getSession().setAttribute("error", "Invalid inputs for account update.");
            response.sendRedirect(request.getContextPath() + "/account?action=list");
            return;
        }

        Account account = accountService.getAccountById(accountId);
        if (account == null) {
            request.getSession().setAttribute("error", "Account not found.");
            response.sendRedirect(request.getContextPath() + "/account?action=list");
            return;
        }

        // Services Checkboxes
        boolean atmCard = "on".equalsIgnoreCase(request.getParameter("atmCard")) || "true".equalsIgnoreCase(request.getParameter("atmCard"));
        boolean chequeBook = "on".equalsIgnoreCase(request.getParameter("chequeBook")) || "true".equalsIgnoreCase(request.getParameter("chequeBook"));
        boolean passbook = "on".equalsIgnoreCase(request.getParameter("passbook")) || "true".equalsIgnoreCase(request.getParameter("passbook"));

        account.setStatus(status);
        account.setIfscCode(ifscCode);
        account.setHasAtmCard(atmCard);
        account.setHasChequeBook(chequeBook);
        account.setHasPassbook(passbook);

        // Read primary customer details
        String firstName = getParameter(request, "firstName", "");
        if (!firstName.isEmpty()) {
            account.setPrimaryFirstName(firstName);
            account.setPrimaryMiddleName(getParameter(request, "middleName", ""));
            account.setPrimaryLastName(getParameter(request, "lastName", ""));
            String dobStr = getParameter(request, "dob", "");
            if (!dobStr.isEmpty()) {
                account.setCustomerDob(LocalDate.parse(dobStr));
            }
            account.setPrimaryGender(getParameter(request, "gender", "male"));
            account.setPrimaryMaritalStatus(getParameter(request, "maritalStatus", "single"));
            account.setPrimaryEmail(getParameter(request, "email", ""));
            account.setPrimaryPhone(getParameter(request, "phone", ""));
            account.setPrimaryPan(getParameter(request, "pan", ""));
            account.setPrimaryAadhaar(getParameter(request, "aadhaar", ""));
            account.setPrimaryAddress(getParameter(request, "address", ""));
            account.setPrimaryCity(getParameter(request, "city", ""));
            account.setPrimaryState(getParameter(request, "state", ""));
            account.setPrimaryZip(getParameter(request, "zip", ""));
            account.setPrimaryOccupation(getParameter(request, "occupation", "Salaried"));
            String incomeStr = getParameter(request, "income", "300000");
            account.setPrimaryIncome(incomeStr.isEmpty() ? BigDecimal.ZERO : new BigDecimal(incomeStr));
        }

        if ("savings".equalsIgnoreCase(account.getAccountType())) {
            String nomineeName = getParameter(request, "nomineeName", "");
            String holdingType = getParameter(request, "holdingType", "single");
            String dailyLimitStr = getParameter(request, "dailyWithdrawalLimit", "50000.00");
            BigDecimal dailyLimit = dailyLimitStr.isEmpty() ? new BigDecimal("50000.00") : new BigDecimal(dailyLimitStr);

            account.setNomineeName(nomineeName);
            account.setHoldingType(holdingType);
            account.setDailyWithdrawalLimit(dailyLimit);

            // Read joint customer details
            if ("joint".equalsIgnoreCase(holdingType)) {
                account.setJointFirstName(getParameter(request, "joint_firstName", ""));
                account.setJointMiddleName(getParameter(request, "joint_middleName", ""));
                account.setJointLastName(getParameter(request, "joint_lastName", ""));
                String jDobStr = getParameter(request, "joint_dob", "");
                if (!jDobStr.isEmpty()) {
                    account.setJointDob(LocalDate.parse(jDobStr));
                }
                account.setJointGender(getParameter(request, "joint_gender", "male"));
                account.setJointMaritalStatus(getParameter(request, "joint_maritalStatus", "single"));
                account.setJointEmail(getParameter(request, "joint_email", ""));
                account.setJointPhone(getParameter(request, "joint_phone", ""));
                account.setJointPan(getParameter(request, "joint_pan", ""));
                account.setJointAadhaar(getParameter(request, "joint_aadhaar", ""));
                account.setJointAddress(getParameter(request, "joint_address", ""));
                account.setJointCity(getParameter(request, "joint_city", ""));
                account.setJointState(getParameter(request, "joint_state", ""));
                account.setJointZip(getParameter(request, "joint_zip", ""));
                account.setJointOccupation(getParameter(request, "joint_occupation", "Salaried"));
                String jIncomeStr = getParameter(request, "joint_income", "300000");
                account.setJointIncome(jIncomeStr.isEmpty() ? BigDecimal.ZERO : new BigDecimal(jIncomeStr));
            }
        } else if ("current".equalsIgnoreCase(account.getAccountType())) {
            String businessName = getParameter(request, "businessName", "");
            String gstin = getParameter(request, "gstin", "");
            String overdraftLimitStr = getParameter(request, "overdraftLimit", "100000.00");
            BigDecimal overdraftLimit = overdraftLimitStr.isEmpty() ? new BigDecimal("100000.00") : new BigDecimal(overdraftLimitStr);
            String companyCategory = getParameter(request, "companyCategory", "");
            String companyPhone = getParameter(request, "companyPhone", "");
            String companyEmail = getParameter(request, "companyEmail", "");
            String companyAddress = getParameter(request, "companyAddress", "");
            String companyPan = getParameter(request, "companyPan", "");
            String companyAadhaar = getParameter(request, "companyAadhaar", "");

            account.setBusinessName(businessName);
            account.setGstin(gstin);
            account.setOverdraftLimit(overdraftLimit);
            account.setCompanyCategory(companyCategory);
            account.setCompanyPhone(companyPhone);
            account.setCompanyEmail(companyEmail);
            account.setCompanyAddress(companyAddress);
            account.setCompanyPan(companyPan);
            account.setCompanyAadhaar(companyAadhaar);
        }

        if (accountDAO.update(account)) {
            request.getSession().setAttribute("success", "Account details updated successfully.");
        } else {
            request.getSession().setAttribute("error", "Failed to update account details.");
        }
        response.sendRedirect(request.getContextPath() + "/account?action=list");
    }

    private void listAccounts(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // Fetch dashboard statistics
        int totalCustomers = accountDAO.getTotalCustomersCount();
        int totalSavingsSingle = accountDAO.getSavingsSingleCustomersCount();
        int totalSavingsJoint = accountDAO.getSavingsJointCustomersCount();
        int totalCurrent = accountDAO.getCurrentCustomersCount();

        // Fetch all accounts
        List<Account> accounts = accountService.getAllAccounts();

        request.setAttribute("totalCustomers", totalCustomers);
        request.setAttribute("totalSavingsSingle", totalSavingsSingle);
        request.setAttribute("totalSavingsJoint", totalSavingsJoint);
        request.setAttribute("totalCurrent", totalCurrent);
        request.setAttribute("accounts", accounts);

        // Generate CSRF token for forms
        generateCSRFToken(request);

        request.getRequestDispatcher("/admin/account.jsp").forward(request, response);
    }

    private void closeAccountAction(HttpServletRequest request, HttpServletResponse response) throws Exception {
        long accountId = Long.parseLong(getParameter(request, "id", "0"));
        if (accountId > 0) {
            if (accountService.updateAccountStatus(accountId, "closed")) {
                request.getSession().setAttribute("success", "Account closed successfully.");
            } else {
                request.getSession().setAttribute("error", "Failed to close account.");
            }
        } else {
            request.getSession().setAttribute("error", "Invalid Account ID.");
        }
        response.sendRedirect(request.getContextPath() + "/account?action=list");
    }

    private void deleteAccountAction(HttpServletRequest request, HttpServletResponse response) throws Exception {
        long accountId = Long.parseLong(getParameter(request, "id", "0"));
        if (accountId > 0) {
            if (accountService.deleteAccount(accountId)) {
                request.getSession().setAttribute("success", "Account and associated signatory profiles deleted successfully.");
            } else {
                request.getSession().setAttribute("error", "Failed to delete account.");
            }
        } else {
            request.getSession().setAttribute("error", "Invalid Account ID.");
        }
        response.sendRedirect(request.getContextPath() + "/account?action=list");
    }

    private void createAccountProcess(HttpServletRequest request, HttpServletResponse response) throws Exception {
        if (!validateCSRFToken(request)) {
            request.getSession().setAttribute("error", "Security validation check failed: Invalid CSRF Token.");
            response.sendRedirect(request.getContextPath() + "/account?action=list");
            return;
        }

        String accountType = getParameter(request, "accountType", "savings"); // savings, current
        String holdingType = getParameter(request, "holdingType", "single"); // single, joint
        BigDecimal initialAmount = new BigDecimal(getParameter(request, "initialAmount", "0"));

        // Validate Minimum Balances
        BigDecimal minRequired = "current".equalsIgnoreCase(accountType) ? new BigDecimal("5000") : new BigDecimal("1000");
        if (initialAmount.compareTo(minRequired) < 0) {
            request.getSession().setAttribute("error", "Initial amount paid must be at least ₹" + minRequired + ".");
            response.sendRedirect(request.getContextPath() + "/account?action=list");
            return;
        }

        // Build list of customers (signatories) to create or fetch
        List<Customer> customerList = new ArrayList<>();

        if ("current".equalsIgnoreCase(accountType)) {
            // CURRENT ACCOUNT - Dynamic partners input
            String partnerCountStr = getParameter(request, "partnerCount", "1");
            int partnerCount = Integer.parseInt(partnerCountStr);
            for (int i = 1; i <= partnerCount; i++) {
                String firstName = getParameter(request, "partner_firstName_" + i, "");
                if (firstName.isEmpty()) continue;

                Customer cust = new Customer();
                cust.setFirstName(firstName);
                cust.setMiddleName(getParameter(request, "partner_middleName_" + i, ""));
                cust.setLastName(getParameter(request, "partner_lastName_" + i, ""));
                cust.setDob(LocalDate.parse(getParameter(request, "partner_dob_" + i, "2000-01-01")));
                cust.setGender(getParameter(request, "partner_gender_" + i, "male"));
                cust.setMaritalStatus(getParameter(request, "partner_maritalStatus_" + i, "single"));
                cust.setEmail(getParameter(request, "partner_email_" + i, ""));
                cust.setPhoneNo(getParameter(request, "partner_phone_" + i, ""));
                cust.setPanCard(getParameter(request, "partner_pan_" + i, ""));
                cust.setAadhaarCard(getParameter(request, "partner_aadhaar_" + i, ""));
                cust.setAddress(getParameter(request, "partner_address_" + i, ""));
                cust.setPermAddress(getParameter(request, "partner_address_" + i, ""));
                cust.setCity(getParameter(request, "partner_city_" + i, ""));
                cust.setState(getParameter(request, "partner_state_" + i, ""));
                cust.setZipCode(getParameter(request, "partner_zip_" + i, ""));
                cust.setUsername(getParameter(request, "partner_username_" + i, ""));
                cust.setPassword(getParameter(request, "partner_password_" + i, ""));
                cust.setPin(getParameter(request, "partner_pin_" + i, "1234"));
                cust.setOccupation(getParameter(request, "partner_occupation_" + i, "Business"));
                cust.setAnnualIncome(new BigDecimal(getParameter(request, "partner_income_" + i, "500000")));
                cust.setStatus("active");
                customerList.add(cust);
            }
        } else {
            // SAVINGS ACCOUNT - Primary customer details
            Customer primary = new Customer();
            primary.setFirstName(getParameter(request, "firstName", ""));
            primary.setMiddleName(getParameter(request, "middleName", ""));
            primary.setLastName(getParameter(request, "lastName", ""));
            primary.setDob(LocalDate.parse(getParameter(request, "dob", "2000-01-01")));
            primary.setGender(getParameter(request, "gender", "male"));
            primary.setMaritalStatus(getParameter(request, "maritalStatus", "single"));
            primary.setEmail(getParameter(request, "email", ""));
            primary.setPhoneNo(getParameter(request, "phone", ""));
            primary.setPanCard(getParameter(request, "pan", ""));
            primary.setAadhaarCard(getParameter(request, "aadhaar", ""));
            primary.setAddress(getParameter(request, "address", ""));
            primary.setPermAddress(getParameter(request, "address", ""));
            primary.setCity(getParameter(request, "city", ""));
            primary.setState(getParameter(request, "state", ""));
            primary.setZipCode(getParameter(request, "zip", ""));
            primary.setUsername(getParameter(request, "username", ""));
            primary.setPassword(getParameter(request, "password", ""));
            primary.setPin(getParameter(request, "pin", "1234"));
            primary.setOccupation(getParameter(request, "occupation", "Salaried"));
            primary.setAnnualIncome(new BigDecimal(getParameter(request, "income", "300000")));
            primary.setStatus("active");
            customerList.add(primary);

            // Joint customer details
            if ("joint".equalsIgnoreCase(holdingType)) {
                Customer joint = new Customer();
                joint.setFirstName(getParameter(request, "joint_firstName", ""));
                joint.setMiddleName(getParameter(request, "joint_middleName", ""));
                joint.setLastName(getParameter(request, "joint_lastName", ""));
                joint.setDob(LocalDate.parse(getParameter(request, "joint_dob", "2000-01-01")));
                joint.setGender(getParameter(request, "joint_gender", "male"));
                joint.setMaritalStatus(getParameter(request, "joint_maritalStatus", "single"));
                joint.setEmail(getParameter(request, "joint_email", ""));
                joint.setPhoneNo(getParameter(request, "joint_phone", ""));
                joint.setPanCard(getParameter(request, "joint_pan", ""));
                joint.setAadhaarCard(getParameter(request, "joint_aadhaar", ""));
                joint.setAddress(getParameter(request, "joint_address", ""));
                joint.setPermAddress(getParameter(request, "joint_address", ""));
                joint.setCity(getParameter(request, "joint_city", ""));
                joint.setState(getParameter(request, "joint_state", ""));
                joint.setZipCode(getParameter(request, "joint_zip", ""));
                joint.setUsername(getParameter(request, "joint_username", ""));
                joint.setPassword(getParameter(request, "joint_password", ""));
                joint.setPin(getParameter(request, "joint_pin", "1234"));
                joint.setOccupation(getParameter(request, "joint_occupation", "Salaried"));
                joint.setAnnualIncome(new BigDecimal(getParameter(request, "joint_income", "300000")));
                joint.setStatus("active");
                customerList.add(joint);
            }
        }

        // Validate customers input
        if (customerList.isEmpty()) {
            request.getSession().setAttribute("error", "At least one customer profile must be registered.");
            response.sendRedirect(request.getContextPath() + "/account?action=list");
            return;
        }

        // Banking services flags
        boolean atmSelected = "on".equalsIgnoreCase(request.getParameter("atmCard"));
        String cardProvider = getParameter(request, "cardProvider", "visa").toLowerCase();
        boolean chequeSelected = "on".equalsIgnoreCase(request.getParameter("chequeBook"));
        boolean passbookSelected = "savings".equalsIgnoreCase(accountType) || "on".equalsIgnoreCase(request.getParameter("passbook"));

        // Nominee details (savings only)
        String nomineeName = getParameter(request, "nomineeName", "No Nominee");

        // Company Details (current only)
        String businessName = getParameter(request, "businessName", "");
        String gstin = getParameter(request, "gstin", "");
        String companyCategory = getParameter(request, "companyCategory", "");
        String companyPhone = getParameter(request, "companyPhone", "");
        String companyEmail = getParameter(request, "companyEmail", "");
        String companyAddress = getParameter(request, "companyAddress", "");
        String companyPan = getParameter(request, "companyPan", "");
        String companyAadhaar = getParameter(request, "companyAadhaar", "");

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConfig.getInstance().getConnection();
            conn.setAutoCommit(false); // Begin database transaction

            List<Long> customerIds = new ArrayList<>();

            // 1. Create or retrieve each customer profile
            for (Customer customer : customerList) {
                // Check if customer already exists by Aadhaar, Email, or Phone to prevent constraint failures
                String checkSql = "SELECT customer_id FROM customer WHERE aadhaar_card = ? OR email = ? OR phone_no = ?";
                long existingId = 0;
                try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                    checkStmt.setString(1, customer.getAadhaarCard());
                    checkStmt.setString(2, customer.getEmail());
                    checkStmt.setString(3, customer.getPhoneNo());
                    try (ResultSet checkRs = checkStmt.executeQuery()) {
                        if (checkRs.next()) {
                            existingId = checkRs.getLong("customer_id");
                        }
                    }
                }

                if (existingId > 0) {
                    customerIds.add(existingId);
                    logger.info("Using existing customer ID: {}", existingId);
                } else {
                    // Validate credentials before creating new customer profile
                    String username = customer.getUsername();
                    if (username == null || username.trim().length() < 4) {
                        throw new Exception("Validation failed: Username for '" + customer.getFirstName() + "' must be at least 4 characters long.");
                    }
                    
                    // Query username existence using transaction connection
                    String checkUserSql = "SELECT COUNT(*) FROM customer WHERE username = ?";
                    try (PreparedStatement checkUserStmt = conn.prepareStatement(checkUserSql)) {
                        checkUserStmt.setString(1, username);
                        try (ResultSet checkUserRs = checkUserStmt.executeQuery()) {
                            if (checkUserRs.next() && checkUserRs.getInt(1) > 0) {
                                throw new Exception("Validation failed: Username '" + username + "' is already taken.");
                            }
                        }
                    }

                    String password = customer.getPassword();
                    if (password == null || password.trim().length() < 6) {
                        throw new Exception("Validation failed: Password for '" + customer.getFirstName() + "' must be at least 6 characters long.");
                    }

                    String pin = customer.getPin();
                    if (pin == null || pin.trim().length() != 4 || !pin.trim().matches("\\d+")) {
                        throw new Exception("Validation failed: Secure PIN for '" + customer.getFirstName() + "' must be exactly 4 numeric digits.");
                    }

                    // Create new customer profile
                    String createCustomerSql = 
                        "INSERT INTO customer (first_name, middle_name, last_name, father_name, mother_name, dob, gender, marital_status, nationality, email, pan_card, aadhaar_card, phone_no, alt_phone_no, address, perm_address, city, state, zip_code, username, pin, password, status, occupation, annual_income) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                    
                    try (PreparedStatement custStmt = conn.prepareStatement(createCustomerSql, Statement.RETURN_GENERATED_KEYS)) {
                        custStmt.setString(1, customer.getFirstName());
                        custStmt.setString(2, customer.getMiddleName());
                        custStmt.setString(3, customer.getLastName());
                        custStmt.setString(4, customer.getFirstName() + "'s Father");
                        custStmt.setString(5, customer.getFirstName() + "'s Mother");
                        custStmt.setDate(6, java.sql.Date.valueOf(customer.getDob()));
                        custStmt.setString(7, customer.getGender());
                        custStmt.setString(8, customer.getMaritalStatus());
                        custStmt.setString(9, "Indian");
                        custStmt.setString(10, customer.getEmail());
                        custStmt.setString(11, customer.getPanCard());
                        custStmt.setString(12, customer.getAadhaarCard());
                        custStmt.setString(13, customer.getPhoneNo());
                        custStmt.setString(14, "");
                        custStmt.setString(15, customer.getAddress());
                        custStmt.setString(16, customer.getAddress());
                        custStmt.setString(17, customer.getCity());
                        custStmt.setString(18, customer.getState());
                        custStmt.setString(19, customer.getZipCode());
                        custStmt.setString(20, customer.getUsername());
                        custStmt.setString(21, customer.getPin());
                        custStmt.setString(22, customer.getPassword());
                        custStmt.setString(23, "active");
                        custStmt.setString(24, customer.getOccupation());
                        custStmt.setBigDecimal(25, customer.getAnnualIncome());
                        
                        int affectedRows = custStmt.executeUpdate();
                        if (affectedRows == 0) {
                            throw new SQLException("Failed to create customer profile: no rows affected.");
                        }
                        
                        try (ResultSet generatedKeys = custStmt.getGeneratedKeys()) {
                            if (generatedKeys.next()) {
                                long newCustId = generatedKeys.getLong(1);
                                customerIds.add(newCustId);
                                logger.info("Created new customer ID: {}", newCustId);
                            } else {
                                throw new SQLException("Failed to create customer profile: no ID obtained.");
                            }
                        }
                    }
                }
            }

            // 2. Generate unique Account Number starting with Rajkot branch code prefix
            String accountNumber = "";
            Random rand = new Random();
            boolean accountNumUnique = false;
            while (!accountNumUnique) {
                // Generate a random 12-digit account number starting with "17193" (Rajkot Branch code)
                StringBuilder sb = new StringBuilder("17193");
                sb.append("savings".equalsIgnoreCase(accountType) ? "1" : "2"); // 1 for Savings, 2 for Current
                for (int i = 0; i < 6; i++) {
                    sb.append(rand.nextInt(10));
                }
                accountNumber = sb.toString();

                // Check uniqueness in database
                String checkAccSql = "SELECT COUNT(*) FROM account WHERE account_number = ?";
                try (PreparedStatement checkAccStmt = conn.prepareStatement(checkAccSql)) {
                    checkAccStmt.setString(1, accountNumber);
                    try (ResultSet checkAccRs = checkAccStmt.executeQuery()) {
                        if (checkAccRs.next() && checkAccRs.getInt(1) == 0) {
                            accountNumUnique = true;
                        }
                    }
                }
            }

            // 3. Create core Account
            String createAccountSql = 
                "INSERT INTO account (account_type, balance, ifsc_code, account_number, status, has_atm_card, has_cheque_book, has_passbook) " +
                "VALUES (?, ?, 'VGB0000171', ?, 'active', ?, ?, ?)";
            
            long accountId = 0;
            try (PreparedStatement accStmt = conn.prepareStatement(createAccountSql, Statement.RETURN_GENERATED_KEYS)) {
                accStmt.setString(1, accountType.toLowerCase());
                accStmt.setBigDecimal(2, initialAmount);
                accStmt.setString(3, accountNumber);
                accStmt.setInt(4, atmSelected ? 1 : 0);
                accStmt.setInt(5, chequeSelected ? 1 : 0);
                accStmt.setInt(6, passbookSelected ? 1 : 0);
                
                accStmt.executeUpdate();
                try (ResultSet generatedKeys = accStmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        accountId = generatedKeys.getLong(1);
                    } else {
                        throw new SQLException("Failed to create account: no ID obtained.");
                    }
                }
            }

            // 4. Create signatories mapping
            String createSignatorySql = "INSERT INTO account_signatory (account_id, customer_id, ownership_type) VALUES (?, ?, ?)";
            try (PreparedStatement sigStmt = conn.prepareStatement(createSignatorySql)) {
                for (int i = 0; i < customerIds.size(); i++) {
                    sigStmt.setLong(1, accountId);
                    sigStmt.setLong(2, customerIds.get(i));
                    sigStmt.setString(3, i == 0 ? "primary" : "joint_holder");
                    sigStmt.executeUpdate();
                }
            }

            // 5. Create Account detail subclass record
            if ("savings".equalsIgnoreCase(accountType)) {
                String createSavingsSql = "INSERT INTO account_savings (account_id, nominee_name, holding_type, daily_withdrawal_limit) VALUES (?, ?, ?, ?)";
                try (PreparedStatement savStmt = conn.prepareStatement(createSavingsSql)) {
                    savStmt.setLong(1, accountId);
                    savStmt.setString(2, nomineeName);
                    savStmt.setString(3, holdingType.toLowerCase());
                    savStmt.setBigDecimal(4, new BigDecimal("50000.00"));
                    savStmt.executeUpdate();
                }
            } else if ("current".equalsIgnoreCase(accountType)) {
                String createCurrentSql = 
                    "INSERT INTO account_current (account_id, business_name, gstin, overdraft_limit, company_category, company_phone, company_email, company_address, company_pan, company_aadhaar) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                try (PreparedStatement currStmt = conn.prepareStatement(createCurrentSql)) {
                    currStmt.setLong(1, accountId);
                    currStmt.setString(2, businessName.isEmpty() ? "Unnamed Business" : businessName);
                    currStmt.setString(3, gstin.isEmpty() ? "GST" + UUID.randomUUID().toString().substring(0, 12).toUpperCase() : gstin);
                    currStmt.setBigDecimal(4, new BigDecimal("100000.00")); // standard overdraft limit
                    currStmt.setString(5, companyCategory);
                    currStmt.setString(6, companyPhone);
                    currStmt.setString(7, companyEmail);
                    currStmt.setString(8, companyAddress);
                    currStmt.setString(9, companyPan);
                    currStmt.setString(10, companyAadhaar);
                    currStmt.executeUpdate();
                }
            }

            // 6. Record Initial Deposit transaction log
            String createTxnSql = 
                "INSERT INTO transaction (from_account_id, to_account_id, transaction_type, amount, reference_number, description, status) " +
                "VALUES (NULL, ?, 'deposit', ?, ?, 'Initial Account Opening Deposit', 'completed')";
            try (PreparedStatement txnStmt = conn.prepareStatement(createTxnSql)) {
                txnStmt.setLong(1, accountId);
                txnStmt.setBigDecimal(2, initialAmount);
                txnStmt.setString(3, "TXN" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
                txnStmt.executeUpdate();
            }

            // 7. Handle ATM Card service request creation
            if (atmSelected) {
                // Generate unique card number
                String cardNumber = "";
                boolean cardNumUnique = false;
                while (!cardNumUnique) {
                    String prefix = "4"; // default Visa
                    if ("mastercard".equalsIgnoreCase(cardProvider)) {
                        prefix = "5";
                    } else if ("rupay".equalsIgnoreCase(cardProvider)) {
                        prefix = "6";
                    }
                    
                    StringBuilder cardSb = new StringBuilder(prefix);
                    for (int i = 0; i < 15; i++) {
                        cardSb.append(rand.nextInt(10));
                    }
                    String rawCardNum = cardSb.toString();
                    cardNumber = rawCardNum.substring(0, 4) + " " + rawCardNum.substring(4, 8) + " " + rawCardNum.substring(8, 12) + " " + rawCardNum.substring(12, 16);

                    // Check card number uniqueness in DB
                    String checkCardSql = "SELECT COUNT(*) FROM card WHERE card_number = ?";
                    try (PreparedStatement checkCardStmt = conn.prepareStatement(checkCardSql)) {
                        checkCardStmt.setString(1, cardNumber);
                        try (ResultSet checkCardRs = checkCardStmt.executeQuery()) {
                            if (checkCardRs.next() && checkCardRs.getInt(1) == 0) {
                                cardNumUnique = true;
                            }
                        }
                    }
                }

                String cardHolderName = "savings".equalsIgnoreCase(accountType) ? 
                    (customerList.get(0).getFirstName() + " " + customerList.get(0).getLastName()).toUpperCase() :
                    businessName.toUpperCase();

                String cvv = String.format("%03d", 100 + rand.nextInt(900));
                Date expiryDate = Date.valueOf(LocalDate.now().plusYears(4));

                String createCardSql = 
                    "INSERT INTO card (account_id, customer_id, card_number, card_type, card_provider, card_holder_name, cvv, expiry_date, status, daily_limit, card_fee, outstanding_balance, is_fee_paid) " +
                    "VALUES (?, ?, ?, 'debit', ?, ?, ?, ?, 'pending', 50000.00, 250.00, 0.00, 0)";
                
                try (PreparedStatement cardStmt = conn.prepareStatement(createCardSql)) {
                    cardStmt.setLong(1, accountId);
                    cardStmt.setLong(2, customerIds.get(0)); // primary owner gets the card
                    cardStmt.setString(3, cardNumber);
                    cardStmt.setString(4, cardProvider);
                    cardStmt.setString(5, cardHolderName);
                    cardStmt.setString(6, cvv);
                    cardStmt.setDate(7, expiryDate);
                    cardStmt.executeUpdate();
                }
            }

            // 8. Handle Cheque Book request creation
            if (chequeSelected) {
                String createChequeSql = 
                    "INSERT INTO cheque_book_request (account_id, customer_id, leaves_count, status, charges, is_charges_paid) " +
                    "VALUES (?, ?, 50, 'pending', 150.00, 0)";
                try (PreparedStatement chequeStmt = conn.prepareStatement(createChequeSql)) {
                    chequeStmt.setLong(1, accountId);
                    chequeStmt.setLong(2, customerIds.get(0));
                    chequeStmt.executeUpdate();
                }
            }

            // 9. Handle Passbook booklet request creation (default/compulsory for savings, optional for current)
            if (passbookSelected) {
                String createPassbookSql = 
                    "INSERT INTO passbook_request (account_id, customer_id, request_type, status, charges, is_charges_paid) " +
                    "VALUES (?, ?, 'new', 'pending', 100.00, 0)";
                try (PreparedStatement pbStmt = conn.prepareStatement(createPassbookSql)) {
                    pbStmt.setLong(1, accountId);
                    pbStmt.setLong(2, customerIds.get(0));
                    pbStmt.executeUpdate();
                }
            }

            conn.commit(); // Success! Commit transaction.
            request.getSession().setAttribute("success", "Bank Account opening process finished successfully! Account Number: " + accountNumber);
            response.sendRedirect(request.getContextPath() + "/account?action=list");

        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback();
                    logger.warn("Transaction rolled back due to error during account registration.", e);
                } catch (SQLException ex) {
                    logger.error("Failed to rollback transaction", ex);
                }
            }
            throw e;
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
    }

    // Customer and Statement helper actions
    private void listCustomerAccounts(HttpServletRequest request, HttpServletResponse response, Long customerId) throws Exception {
        List<Account> accounts = accountService.getCustomerAccounts(customerId);
        request.setAttribute("accounts", accounts);
        request.getRequestDispatcher("/customer/account.jsp").forward(request, response);
    }

    private void showTransferPage(HttpServletRequest request, HttpServletResponse response, Long customerId) throws Exception {
        List<Account> accounts = accountService.getCustomerAccounts(customerId);
        List<com.vgb.model.Card> cards = new com.vgb.service.CardService().getCustomerCards(customerId);
        List<Account> beneficiaries = accountService.getSavedBeneficiaries(customerId);

        request.setAttribute("accounts", accounts);
        request.setAttribute("cards", cards);
        request.setAttribute("beneficiaries", beneficiaries);
        generateCSRFToken(request);

        request.getRequestDispatcher("/customer/transfer.jsp").forward(request, response);
    }

    private void showCustomerStatement(HttpServletRequest request, HttpServletResponse response, Long customerId) throws Exception {
        Customer customer = new com.vgb.service.CustomerService().getCustomerById(customerId);
        request.setAttribute("customer", customer);
        
        List<Account> accounts = accountService.getCustomerAccounts(customerId);
        request.setAttribute("accounts", accounts);

        if (!accounts.isEmpty()) {
            long selectedAccountId = Long.parseLong(getParameter(request, "accountId", "0"));
            Account selectedAccount = null;
            
            if (selectedAccountId > 0) {
                for (Account acc : accounts) {
                    if (acc.getAccountId() == selectedAccountId) {
                        selectedAccount = acc;
                        break;
                    }
                }
            }
            
            if (selectedAccount == null) {
                selectedAccount = accounts.get(0);
                selectedAccountId = selectedAccount.getAccountId();
            }

            List<Transaction> transactions = accountService.getAccountTransactions(selectedAccountId);
            computeRunningBalances(transactions, selectedAccountId, selectedAccount.getBalance());

            request.setAttribute("selectedAccountId", selectedAccountId);
            request.setAttribute("selectedAccount", selectedAccount);
            request.setAttribute("transactions", transactions);
        }
        
        // Get customer loans for the loan statement tab
        List<com.vgb.model.Loan> customerLoans = new com.vgb.service.LoanService().getLoansByCustomerId(customerId);
        request.setAttribute("customerLoans", customerLoans);
        
        long selectedLoanId = Long.parseLong(getParameter(request, "loanId", "0"));
        if (selectedLoanId > 0) {
            com.vgb.model.Loan selectedLoan = new com.vgb.service.LoanService().getLoanById(selectedLoanId);
            if (selectedLoan != null && selectedLoan.getCustomerId() == customerId) {
                request.setAttribute("selectedLoan", selectedLoan);
                request.setAttribute("selectedLoanId", selectedLoanId);
                List<com.vgb.model.Repayment> repayments = new com.vgb.service.LoanService().getLoanRepaymentHistory(selectedLoanId);
                request.setAttribute("repayments", repayments);
            }
        } else if (customerLoans != null && !customerLoans.isEmpty()) {
            com.vgb.model.Loan selectedLoan = customerLoans.get(0);
            request.setAttribute("selectedLoan", selectedLoan);
            request.setAttribute("selectedLoanId", selectedLoan.getLoanId());
            List<com.vgb.model.Repayment> repayments = new com.vgb.service.LoanService().getLoanRepaymentHistory(selectedLoan.getLoanId());
            request.setAttribute("repayments", repayments);
        }

        request.getRequestDispatcher("/customer/statment.jsp").forward(request, response);
    }

    private void verifyBeneficiaryAction(HttpServletRequest request, HttpServletResponse response, Long customerId) throws Exception {
        String beneficiaryType = getParameter(request, "beneficiaryType", "vgb");
        String accountNumber = getParameter(request, "accountNumber", "");
        String ifscCode = getParameter(request, "ifscCode", "");
        String holderName = getParameter(request, "holderName", "");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        java.io.PrintWriter out = response.getWriter();

        if (accountNumber.isEmpty() || ifscCode.isEmpty()) {
            out.print("{\"valid\":false,\"message\":\"Account number and IFSC Code are required.\"}");
            out.flush();
            return;
        }

        if ("vgb".equalsIgnoreCase(beneficiaryType)) {
            Account account = accountService.getAccountByNumber(accountNumber);
            if (account == null) {
                out.print("{\"valid\":false,\"message\":\"VGB Account number not found in core ledger records.\"}");
            } else if (!account.getIfscCode().equalsIgnoreCase(ifscCode)) {
                out.print("{\"valid\":false,\"message\":\"IFSC Code mismatch. Verified account belongs to IFSC " + account.getIfscCode() + "\"}");
            } else if (!"active".equalsIgnoreCase(account.getStatus())) {
                out.print("{\"valid\":false,\"message\":\"Verified VGB Account is in " + account.getStatus() + " status. Cannot route transfers.\"}");
            } else {
                out.print("{\"valid\":true,\"accountId\":" + account.getAccountId() + 
                          ",\"customerName\":\"" + escapeJson(account.getCustomerName()) + "\"" +
                          ",\"ifscCode\":\"" + escapeJson(account.getIfscCode()) + "\"" +
                          ",\"accountNumber\":\"" + escapeJson(account.getAccountNumber()) + "\"" +
                          ",\"accountType\":\"" + escapeJson(account.getAccountType()) + "\"}");
            }
        } else {
            if (holderName.isEmpty()) {
                out.print("{\"valid\":false,\"message\":\"Account holder name is required for other bank beneficiary.\"}");
            } else if (ifscCode.toUpperCase().startsWith("VGB")) {
                out.print("{\"valid\":false,\"message\":\"IFSC code indicates a local VGB account. Please select VGB Customer.\"}");
            } else {
                out.print("{\"valid\":true,\"accountId\":0" + 
                          ",\"customerName\":\"" + escapeJson(holderName) + "\"" +
                          ",\"ifscCode\":\"" + escapeJson(ifscCode) + "\"" +
                          ",\"accountNumber\":\"" + escapeJson(accountNumber) + "\"" +
                          ",\"accountType\":\"external\"}");
            }
        }
        out.flush();
    }

    private void saveBeneficiaryAction(HttpServletRequest request, HttpServletResponse response, Long customerId) throws Exception {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        java.io.PrintWriter out = response.getWriter();

        if (!validateCSRFToken(request)) {
            out.print("{\"success\":false,\"message\":\"Security validation check failed: Invalid CSRF Token.\"}");
            out.flush();
            return;
        }

        String beneficiaryType = getParameter(request, "beneficiaryType", "vgb");
        long beneficiaryAccountId = Long.parseLong(getParameter(request, "beneficiaryAccountId", "0"));
        String accountNumber = getParameter(request, "accountNumber", "");
        String ifscCode = getParameter(request, "ifscCode", "");
        String holderName = getParameter(request, "holderName", "");

        boolean success = false;
        String message = "";
        try {
            if ("vgb".equalsIgnoreCase(beneficiaryType)) {
                success = accountService.addBeneficiary(customerId, beneficiaryAccountId);
                message = "VGB Beneficiary account registered successfully.";
            } else {
                success = accountService.addBeneficiary(customerId, "other", null, accountNumber, ifscCode, holderName);
                message = "External bank beneficiary registered successfully.";
            }
        } catch (Exception e) {
            success = false;
            message = e.getMessage();
        }

        if (success) {
            out.print("{\"success\":true,\"message\":\"" + escapeJson(message) + "\"}");
        } else {
            out.print("{\"success\":false,\"message\":\"" + escapeJson(message) + "\"}");
        }
        out.flush();
    }

    private void processTransfer(HttpServletRequest request, HttpServletResponse response, Long customerId) throws Exception {
        HttpSession session = request.getSession();
        if (!validateCSRFToken(request)) {
            session.setAttribute("error", "Security validation check failed: Invalid CSRF Token.");
            response.sendRedirect(request.getContextPath() + "/account?action=transferPage");
            return;
        }

        long fromAccountId = Long.parseLong(getParameter(request, "fromAccountId", "0"));
        String destType = getParameter(request, "destType", "own");
        String toAccountIdStr = getParameter(request, "toAccountId", "");
        BigDecimal amount = new BigDecimal(getParameter(request, "amount", "0"));
        String description = getParameter(request, "description", "Fund Transfer");

        boolean useCard = "true".equalsIgnoreCase(getParameter(request, "useCard", "false"));

        if (useCard) {
            long cardId = Long.parseLong(getParameter(request, "cardId", "0"));
            String cvv = getParameter(request, "cvv", "");
            com.vgb.service.CardService cardService = new com.vgb.service.CardService();
            com.vgb.model.Card card = cardService.getCardById(cardId);
            if (card == null || card.getCustomerId() != customerId || !"active".equalsIgnoreCase(card.getStatus())) {
                throw new Exception("Selected ATM card is invalid or not active.");
            }
            if (!card.getCvv().equals(cvv)) {
                throw new Exception("Invalid Card CVV security code.");
            }
            fromAccountId = card.getAccountId();
        }

        List<Account> customerAccounts = accountService.getCustomerAccounts(customerId);
        boolean authorized = false;
        for (Account acc : customerAccounts) {
            if (acc.getAccountId() == fromAccountId) {
                authorized = true;
                break;
            }
        }
        if (!authorized) {
            throw new Exception("Unauthorized source account selection.");
        }

        boolean transferSuccess = false;
        if ("own".equalsIgnoreCase(destType)) {
            long toAccountId = Long.parseLong(toAccountIdStr);
            if (fromAccountId == toAccountId) {
                throw new Exception("Source and target accounts cannot be the same.");
            }
            transferSuccess = accountService.transfer(fromAccountId, toAccountId, amount, description);
        } else {
            if (toAccountIdStr.startsWith("ext_")) {
                long beneficiaryId = Long.parseLong(toAccountIdStr.substring(4));
                String[] details = accountService.getExternalBeneficiaryDetails(beneficiaryId);
                if (details == null) {
                    throw new Exception("Saved beneficiary details not found.");
                }
                transferSuccess = accountService.externalTransfer(fromAccountId, details[0], details[1], details[2], amount, description);
            } else {
                long toAccountId = Long.parseLong(toAccountIdStr);
                Account targetAcc = accountService.getAccountById(toAccountId);
                if (targetAcc == null) {
                    throw new Exception("Recipient account not found.");
                }
                transferSuccess = accountService.transfer(fromAccountId, targetAcc.getAccountId(), amount, description);
            }
        }

        if (transferSuccess) {
            session.setAttribute("success", "Fund transfer of ₹" + amount.setScale(2) + " processed successfully!");
        } else {
            session.setAttribute("error", "Fund transfer operation failed.");
        }

        response.sendRedirect(request.getContextPath() + "/account?action=transferPage");
    }

    private void processWithdraw(HttpServletRequest request, HttpServletResponse response, Long customerId) throws Exception {
        HttpSession session = request.getSession();
        if (!validateCSRFToken(request)) {
            session.setAttribute("error", "Security validation check failed: Invalid CSRF Token.");
            response.sendRedirect(request.getContextPath() + "/account?action=transferPage");
            return;
        }

        long accountId = Long.parseLong(getParameter(request, "accountId", "0"));
        BigDecimal amount = new BigDecimal(getParameter(request, "amount", "0"));
        String description = getParameter(request, "description", "Cash Withdrawal");

        boolean useCard = "true".equalsIgnoreCase(getParameter(request, "useCard", "false"));

        if (useCard) {
            long cardId = Long.parseLong(getParameter(request, "cardId", "0"));
            String cvv = getParameter(request, "cvv", "");
            com.vgb.service.CardService cardService = new com.vgb.service.CardService();
            com.vgb.model.Card card = cardService.getCardById(cardId);
            if (card == null || card.getCustomerId() != customerId || !"active".equalsIgnoreCase(card.getStatus())) {
                throw new Exception("Selected ATM card is invalid or not active.");
            }
            if (!card.getCvv().equals(cvv)) {
                throw new Exception("Invalid Card CVV security code.");
            }
            accountId = card.getAccountId();
        }

        List<Account> customerAccounts = accountService.getCustomerAccounts(customerId);
        boolean authorized = false;
        for (Account acc : customerAccounts) {
            if (acc.getAccountId() == accountId) {
                authorized = true;
                break;
            }
        }
        if (!authorized) {
            throw new Exception("Unauthorized account selection.");
        }

        boolean success = accountService.withdraw(accountId, amount, description);
        if (success) {
            session.setAttribute("success", "Counter cash withdrawal of ₹" + amount.setScale(2) + " processed successfully!");
        } else {
            session.setAttribute("error", "Withdrawal operation failed.");
        }

        response.sendRedirect(request.getContextPath() + "/account?action=transferPage");
    }

    private void processDeposit(HttpServletRequest request, HttpServletResponse response, Long customerId) throws Exception {
        HttpSession session = request.getSession();
        if (!validateCSRFToken(request)) {
            session.setAttribute("error", "Security validation check failed: Invalid CSRF Token.");
            response.sendRedirect(request.getContextPath() + "/account?action=transferPage");
            return;
        }

        long cardId = Long.parseLong(getParameter(request, "cardId", "0"));
        String cvv = getParameter(request, "cvv", "");
        BigDecimal amount = new BigDecimal(getParameter(request, "amount", "0"));
        String description = getParameter(request, "description", "Card Deposit");

        com.vgb.service.CardService cardService = new com.vgb.service.CardService();
        com.vgb.model.Card card = cardService.getCardById(cardId);
        if (card == null || card.getCustomerId() != customerId || !"active".equalsIgnoreCase(card.getStatus())) {
            throw new Exception("Selected ATM card is invalid or not active.");
        }
        if (!card.getCvv().equals(cvv)) {
            throw new Exception("Invalid Card CVV security code.");
        }

        long accountId = card.getAccountId();
        boolean success = accountService.deposit(accountId, amount, description);
        if (success) {
            session.setAttribute("success", "Card deposit of ₹" + amount.setScale(2) + " processed successfully!");
        } else {
            session.setAttribute("error", "Card deposit operation failed.");
        }

        response.sendRedirect(request.getContextPath() + "/account?action=transferPage");
    }

    private void getTransactionsJsonAction(HttpServletRequest request, HttpServletResponse response) throws Exception {
        long accountId = Long.parseLong(getParameter(request, "accountId", "0"));
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        java.io.PrintWriter out = response.getWriter();

        if (accountId <= 0) {
            out.print("[]");
            out.flush();
            return;
        }

        Account account = accountService.getAccountById(accountId);
        if (account == null) {
            out.print("[]");
            out.flush();
            return;
        }

        List<Transaction> transactions = accountService.getAccountTransactions(accountId);
        computeRunningBalances(transactions, accountId, account.getBalance());

        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < transactions.size(); i++) {
            Transaction t = transactions.get(i);
            if (i > 0) sb.append(",");
            sb.append("{")
              .append("\"transactionId\":").append(t.getTransactionId()).append(",")
              .append("\"fromAccountId\":").append(t.getFromAccountId() != null ? t.getFromAccountId() : "null").append(",")
              .append("\"toAccountId\":").append(t.getToAccountId() != null ? t.getToAccountId() : "null").append(",")
              .append("\"transactionType\":\"").append(escapeJson(t.getTransactionType())).append("\",")
              .append("\"amount\":").append(t.getAmount()).append(",")
              .append("\"referenceNumber\":\"").append(escapeJson(t.getReferenceNumber())).append("\",")
              .append("\"description\":\"").append(escapeJson(t.getDescription())).append("\",")
              .append("\"status\":\"").append(escapeJson(t.getStatus())).append("\",")
              .append("\"transactionDate\":\"").append(t.getTransactionDate() != null ? t.getTransactionDate().toString() : "").append("\",")
              .append("\"runningBalance\":").append(t.getRunningBalance() != null ? t.getRunningBalance() : "0")
              .append("}");
        }
        sb.append("]");
        out.print(sb.toString());
        out.flush();
    }

    private void computeRunningBalances(List<Transaction> txns, long accountId, BigDecimal currentBalance) {
        BigDecimal balance = currentBalance;
        for (int i = 0; i < txns.size(); i++) {
            Transaction txn = txns.get(i);
            txn.setRunningBalance(balance);
            
            if ("completed".equalsIgnoreCase(txn.getStatus())) {
                boolean isCredit = "deposit".equalsIgnoreCase(txn.getTransactionType()) ||
                                   "interest".equalsIgnoreCase(txn.getTransactionType()) ||
                                   ("transfer".equalsIgnoreCase(txn.getTransactionType()) && txn.getToAccountId() != null && txn.getToAccountId() == accountId);
                
                if (isCredit) {
                    balance = balance.subtract(txn.getAmount());
                } else {
                    balance = balance.add(txn.getAmount());
                }
            }
        }
    }

    private void getAccountDetailsJsonAction(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String accountNumber = getParameter(request, "accountNumber", "");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        java.io.PrintWriter out = response.getWriter();

        if (accountNumber.isEmpty()) {
            out.print("{\"error\":\"Account number is required\"}");
            out.flush();
            return;
        }

        Account account = accountService.getAccountByNumber(accountNumber);
        if (account == null) {
            out.print("{\"error\":\"Account not found\"}");
            out.flush();
            return;
        }

        Customer customer = new com.vgb.service.CustomerService().getCustomerById(account.getCustomerId());
        if (customer == null) {
            out.print("{\"error\":\"Customer details not found\"}");
            out.flush();
            return;
        }

        String fullName = customer.getFirstName() + (customer.getMiddleName() != null && !customer.getMiddleName().isEmpty() ? " " + customer.getMiddleName() : "") + " " + customer.getLastName();
        String fullAddress = customer.getAddress() + ", " + customer.getCity() + ", " + customer.getState() + " - " + customer.getZipCode();

        StringBuilder sb = new StringBuilder("{");
        sb.append("\"accountId\":").append(account.getAccountId()).append(",")
          .append("\"accountNumber\":\"").append(escapeJson(account.getAccountNumber())).append("\",")
          .append("\"accountType\":\"").append(escapeJson(account.getAccountType())).append("\",")
          .append("\"balance\":").append(account.getBalance()).append(",")
          .append("\"customerId\":").append(customer.getCustomerId()).append(",")
          .append("\"customerName\":\"").append(escapeJson(fullName)).append("\",")
          .append("\"email\":\"").append(escapeJson(customer.getEmail() != null ? customer.getEmail() : "")).append("\",")
          .append("\"phone\":\"").append(escapeJson(customer.getPhoneNo() != null ? customer.getPhoneNo() : "")).append("\",")
          .append("\"address\":\"").append(escapeJson(fullAddress)).append("\"")
          .append("}");

        out.print(sb.toString());
        out.flush();
    }

    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\b", "\\b")
                  .replace("\f", "\\f")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }
}
