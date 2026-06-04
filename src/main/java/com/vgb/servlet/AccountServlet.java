package com.vgb.servlet;

import com.vgb.constants.AppConstants;
import com.vgb.model.Account;
import com.vgb.model.Transaction;
import com.vgb.service.AccountService;
import com.vgb.util.ValidatorUtil;
import com.vgb.util.SecurityUtil;
import com.vgb.config.DatabaseConfig;
import com.vgb.model.Card;
import com.vgb.service.CardService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.*;
import java.util.List;

/**
 * AccountServlet: Handles account-related requests
 */
@WebServlet(name = "AccountServlet", value = "/account")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class AccountServlet extends BaseServlet {
    private AccountService accountService = new AccountService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = getParameter(request, "action", "list");
        Long customerId = getUserId(request);
        Integer adminId = getAdminId(request);

        if (adminId == null && customerId == null) {
            response.sendRedirect(request.getContextPath() + AppConstants.PATH_LOGIN);
            return;
        }
        
        try {
            switch (action) {
                case "list":
                    listAccounts(request, response, customerId, adminId);
                    break;
                case "transactions":
                    showTransactions(request, response);
                    break;
                case "statement":
                    showStatement(request, response);
                    break;
                case "verifyKyc":
                    verifyKyc(request, response);
                    break;
                case "getCustomerDetails":
                    getCustomerDetails(request, response);
                    break;
                case "transferPage":
                    showTransferPage(request, response, customerId);
                    break;
                case "verifyBeneficiary":
                    verifyBeneficiary(request, response, customerId);
                    break;
                default:
                    listAccounts(request, response, customerId, adminId);
            }
        } catch (Exception e) {
            logger.error("Error processing account request", e);
            if (response.isCommitted()) {
                return;
            }
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            // Provide a safe empty accounts list so JSP doesn't fail when rendering error view
            request.setAttribute("accounts", new java.util.ArrayList<com.vgb.model.Account>());
            request.getRequestDispatcher("/" + (adminId != null ? "admin" : "customer") + "/account.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = getParameter(request, "action", "");
        
        try {
            switch (action) {
                case "create":
                    createAccount(request, response);
                    break;
                case "createProcess":
                    createCustomerAndAccountProcess(request, response);
                    break;
                case "update":
                    updateAccount(request, response);
                    break;
                case "close":
                    closeAccount(request, response);
                    break;
                case "delete":
                    deleteAccount(request, response);
                    break;
                case "deposit":
                    processDeposit(request, response);
                    break;
                case "withdraw":
                    processWithdrawal(request, response);
                    break;
                case "transfer":
                    processTransfer(request, response);
                    break;
                case "saveBeneficiary":
                    saveBeneficiary(request, response, getUserId(request));
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + (getAdminId(request) != null ? "/admin-dashboard" : "/customer-dashboard"));
            }
        } catch (Exception e) {
            logger.error("Error processing account POST request", e);
            request.getSession().setAttribute("error", "An error occurred: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/account?action=list");
        }
    }

    private void listAccounts(HttpServletRequest request, HttpServletResponse response, Long customerId, Integer adminId) throws Exception {
        List<Account> accounts;
        generateCSRFToken(request);
        if (adminId != null) {
            // Admin viewing accounts
            String status = getParameter(request, "status", null);
            if (status != null) {
                accounts = accountService.getAccountsByStatus(status);
            } else {
                accounts = accountService.getAllAccounts();
            }
            // Load all registered customers for the account wizard dropdown
            List<com.vgb.model.Customer> customers = new com.vgb.service.CustomerService().getAllCustomers();
            request.setAttribute("customers", customers);

            // Identify all customers who have pending or active loans
            try {
                List<com.vgb.model.Loan> loans = new com.vgb.service.LoanService().getAllLoans();
                java.util.Set<Long> customersWithLoans = new java.util.HashSet<>();
                for (com.vgb.model.Loan loan : loans) {
                    if (!"closed".equalsIgnoreCase(loan.getStatus()) && 
                        !"rejected".equalsIgnoreCase(loan.getStatus()) && 
                        !"defaulted".equalsIgnoreCase(loan.getStatus())) {
                        customersWithLoans.add(loan.getCustomerId());
                    }
                }
                request.setAttribute("customersWithLoans", customersWithLoans);
            } catch (Exception e) {
                logger.error("Failed to load loans in listAccounts for loan check", e);
            }
        } else {
            // Customer viewing their own accounts
            accounts = accountService.getCustomerAccounts(customerId);
        }
        request.setAttribute("accounts", accounts);
        request.getRequestDispatcher("/" + (adminId != null ? "admin" : "customer") + "/account.jsp").forward(request, response);
    }

    private void showTransferPage(HttpServletRequest request, HttpServletResponse response, Long customerId) throws Exception {
        if (customerId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        List<Account> myAccounts = accountService.getCustomerAccounts(customerId);
        request.setAttribute("accounts", myAccounts);

        // Retrieve only manually saved beneficiaries
        List<Account> beneficiaries = accountService.getSavedBeneficiaries(customerId);
        request.setAttribute("beneficiaries", beneficiaries);

        // Retrieve customer's active cards
        try {
            request.setAttribute("cards", new CardService().getCustomerCards(customerId));
        } catch (Exception e) {
            logger.error("Failed to load customer cards in showTransferPage", e);
        }

        request.getRequestDispatcher("/customer/transfer.jsp").forward(request, response);
    }

    private void verifyBeneficiary(HttpServletRequest request, HttpServletResponse response, Long customerId) throws Exception {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        if (customerId == null) {
            response.getWriter().write("{\"valid\":false,\"message\":\"Session expired. Please login again.\"}");
            return;
        }

        String accountNumber = getParameter(request, "accountNumber", "").trim();
        String ifscCode = getParameter(request, "ifscCode", "").trim();
        String benType = getParameter(request, "beneficiaryType", "vgb").trim();

        if (accountNumber.isEmpty() || ifscCode.isEmpty()) {
            response.getWriter().write("{\"valid\":false,\"message\":\"Account number and IFSC are required.\"}");
            return;
        }

        try {
            if ("other".equalsIgnoreCase(benType)) {
                String holderName = getParameter(request, "holderName", "").trim();
                if (holderName.isEmpty()) {
                    response.getWriter().write("{\"valid\":false,\"message\":\"Account holder name is required for other bank beneficiaries.\"}");
                    return;
                }
                if (accountNumber.length() < 9 || accountNumber.length() > 18 || !accountNumber.matches("^[0-9]+$")) {
                    response.getWriter().write("{\"valid\":false,\"message\":\"Other bank account numbers must be between 9 and 18 numeric digits.\"}");
                    return;
                }
                if (ifscCode.length() != 11 || !ifscCode.matches("^[A-Za-z]{4}0[A-Za-z0-9]{6}$")) {
                    response.getWriter().write("{\"valid\":false,\"message\":\"Invalid IFSC code structure. (E.g. SBIN0001234)\"}");
                    return;
                }
                if (ifscCode.toUpperCase().startsWith("VGBK")) {
                    response.getWriter().write("{\"valid\":false,\"message\":\"VGB accounts must be registered under VGB Bank option.\"}");
                    return;
                }
                
                response.getWriter().write("{"
                    + "\"valid\":true,"
                    + "\"accountId\":0,"
                    + "\"accountNumber\":\"" + accountNumber + "\","
                    + "\"accountType\":\"external\","
                    + "\"ifscCode\":\"" + ifscCode.toUpperCase() + "\","
                    + "\"customerName\":\"" + holderName.replace("\"", "\\\"") + "\""
                    + "}");
                return;
            }

            Account target = accountService.getAccountByNumber(accountNumber);
            if (target == null) {
                response.getWriter().write("{\"valid\":false,\"message\":\"Account number not found.\"}");
                return;
            }

            if (!ifscCode.equalsIgnoreCase(target.getIfscCode())) {
                response.getWriter().write("{\"valid\":false,\"message\":\"Invalid IFSC routing code for this account.\"}");
                return;
            }

            if (!"active".equalsIgnoreCase(target.getStatus())) {
                response.getWriter().write("{\"valid\":false,\"message\":\"Account is not active.\"}");
                return;
            }

            // Block self-beneficiary registration
            List<Account> myAccounts = accountService.getCustomerAccounts(customerId);
            for (Account myAcc : myAccounts) {
                if (myAcc.getAccountId() == target.getAccountId()) {
                    response.getWriter().write("{\"valid\":false,\"message\":\"You cannot add your own account as a P2P beneficiary.\"}");
                    return;
                }
            }

            String holderName = target.getCustomerName();
            if (holderName == null || holderName.isEmpty() || "No Owner".equalsIgnoreCase(holderName)) {
                com.vgb.service.CustomerService custService = new com.vgb.service.CustomerService();
                com.vgb.model.Customer c = custService.getCustomerById(target.getCustomerId());
                if (c != null) {
                    holderName = c.getFirstName() + " " + c.getLastName();
                } else {
                    holderName = "Unknown Holder";
                }
            }

            response.getWriter().write("{"
                + "\"valid\":true,"
                + "\"accountId\":" + target.getAccountId() + ","
                + "\"accountNumber\":\"" + target.getAccountNumber() + "\","
                + "\"accountType\":\"" + target.getAccountType() + "\","
                + "\"ifscCode\":\"" + target.getIfscCode() + "\","
                + "\"customerName\":\"" + holderName.replace("\"", "\\\"") + "\""
                + "}");

        } catch (Exception e) {
            logger.error("Error validating beneficiary", e);
            response.getWriter().write("{\"valid\":false,\"message\":\"Validation failed: " + e.getMessage() + "\"}");
        }
    }

    private void saveBeneficiary(HttpServletRequest request, HttpServletResponse response, Long customerId) throws Exception {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        if (customerId == null) {
            response.getWriter().write("{\"success\":false,\"message\":\"Session expired. Please login again.\"}");
            return;
        }

        if (!validateCSRFToken(request)) {
            response.getWriter().write("{\"success\":false,\"message\":\"Security check failed: Invalid CSRF token.\"}");
            return;
        }

        String benType = getParameter(request, "beneficiaryType", "vgb");
        long beneficiaryAccountId = Long.parseLong(getParameter(request, "beneficiaryAccountId", "0"));
        String accountNumber = getParameter(request, "accountNumber", "").trim();
        String ifscCode = getParameter(request, "ifscCode", "").trim();
        String holderName = getParameter(request, "holderName", "").trim();
        String nickname = getParameter(request, "nickname", "").trim();
        
        if (nickname.isEmpty()) {
            nickname = holderName;
        }

        try {
            boolean saved;
            if ("other".equalsIgnoreCase(benType)) {
                if (accountNumber.isEmpty() || ifscCode.isEmpty() || holderName.isEmpty()) {
                    response.getWriter().write("{\"success\":false,\"message\":\"Missing required other-bank beneficiary details.\"}");
                    return;
                }
                saved = accountService.addBeneficiary(customerId, "other", null, accountNumber, ifscCode, holderName);
            } else {
                if (beneficiaryAccountId == 0) {
                    response.getWriter().write("{\"success\":false,\"message\":\"Invalid beneficiary account.\"}");
                    return;
                }
                saved = accountService.addBeneficiary(customerId, "vgb", beneficiaryAccountId, accountNumber, ifscCode, holderName);
            }
            
            if (saved) {
                response.getWriter().write("{\"success\":true,\"message\":\"Beneficiary registered successfully!\"}");
            } else {
                response.getWriter().write("{\"success\":false,\"message\":\"Failed to register beneficiary.\"}");
            }
        } catch (Exception e) {
            logger.error("Error saving beneficiary", e);
            response.getWriter().write("{\"success\":false,\"message\":\"Error: " + e.getMessage() + "\"}");
        }
    }

    private void createAccount(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // Admin only - for now we'll implement basic account creation
        Long customerId = Long.parseLong(getParameter(request, "customerId", "0"));
        String accountType = getParameter(request, "accountType", "");
        String ifscCode = getParameter(request, "ifscCode", "");
        String accountNumber = getParameter(request, "accountNumber", "");

        Account account = new Account(customerId, accountType, accountNumber);
        account.setIfscCode(ifscCode);
        
        if (accountService.createAccount(account) != null) {
            request.setAttribute("success", "Account created successfully");
        } else {
            request.setAttribute("error", "Failed to create account");
        }
        response.sendRedirect(request.getContextPath() + "/account?action=list");
    }

    private void processDeposit(HttpServletRequest request, HttpServletResponse response) throws Exception {
        long accountId = Long.parseLong(getParameter(request, "accountId", "0"));
        BigDecimal amount = new BigDecimal(getParameter(request, "amount", "0"));
        String description = getParameter(request, "description", "Deposit");

        boolean useCard = "1".equals(getParameter(request, "useCard", "0")) || "true".equals(getParameter(request, "useCard", "false"));
        long cardId = Long.parseLong(getParameter(request, "cardId", "0"));
        String cvv = getParameter(request, "cvv", "").trim();

        HttpSession session = request.getSession();

        try {
            if (useCard) {
                CardService cardService = new CardService();
                Card card = cardService.getCardById(cardId);
                if (card == null) {
                    throw new Exception("Selected card not found.");
                }
                if (!"active".equalsIgnoreCase(card.getStatus())) {
                    throw new Exception("Card is not active or has expired.");
                }
                if (!card.getCvv().equals(cvv)) {
                    throw new Exception("Security check failed: Invalid CVV.");
                }
                if (card.getDailyLimit().compareTo(amount) < 0) {
                    throw new Exception("Transaction declined: Amount exceeds card daily limit of ₹" + card.getDailyLimit().setScale(2) + ".");
                }

                // Override account with card account
                accountId = card.getAccountId();

                if ("credit".equalsIgnoreCase(card.getCardType())) {
                    BigDecimal newOutstanding = card.getOutstandingBalance().add(amount);
                    if (newOutstanding.compareTo(card.getDailyLimit()) > 0) {
                        throw new Exception("Transaction declined: Exceeds card credit limit. (Available Credit: ₹" + card.getDailyLimit().subtract(card.getOutstandingBalance()).setScale(2) + ")");
                    }

                    // Credit Card Cash Advance into Bank Account
                    new com.vgb.dao.CardDAOImpl().updateOutstandingBalance(cardId, newOutstanding);
                    if (accountService.deposit(accountId, amount, description + " (Cash Advance via VGB Credit Card - " + card.getMaskedCardNumber() + ")")) {
                        session.setAttribute("success", "Credit Card Cash Advance of ₹" + amount.setScale(2) + " deposited successfully into Account.");
                    } else {
                        throw new Exception("Cash advance deposit failed.");
                    }
                } else {
                    // Debit Card Deposit
                    if (accountService.deposit(accountId, amount, description + " (Deposited via VGB Debit Card - " + card.getMaskedCardNumber() + ")")) {
                        session.setAttribute("success", "Card deposit of ₹" + amount.setScale(2) + " completed successfully.");
                    } else {
                        throw new Exception("Card deposit failed.");
                    }
                }
            } else {
                // Standard Deposit
                if (accountService.deposit(accountId, amount, description)) {
                    session.setAttribute("success", "Cash deposit of ₹" + amount.setScale(2) + " completed successfully.");
                } else {
                    session.setAttribute("error", "Cash deposit failed.");
                }
            }
        } catch (Exception e) {
            session.setAttribute("error", "Deposit transaction failed: " + e.getMessage());
        }

        String redirectUrl = getParameter(request, "redirectUrl", "/account?action=list");
        response.sendRedirect(request.getContextPath() + redirectUrl);
    }

    private void processWithdrawal(HttpServletRequest request, HttpServletResponse response) throws Exception {
        long accountId = Long.parseLong(getParameter(request, "accountId", "0"));
        BigDecimal amount = new BigDecimal(getParameter(request, "amount", "0"));
        String description = getParameter(request, "description", "Withdrawal");

        boolean useCard = "1".equals(getParameter(request, "useCard", "0")) || "true".equals(getParameter(request, "useCard", "false"));
        long cardId = Long.parseLong(getParameter(request, "cardId", "0"));
        String cvv = getParameter(request, "cvv", "").trim();

        HttpSession session = request.getSession();

        try {
            if (useCard) {
                CardService cardService = new CardService();
                Card card = cardService.getCardById(cardId);
                if (card == null) {
                    throw new Exception("Selected card not found.");
                }
                if (!"active".equalsIgnoreCase(card.getStatus())) {
                    throw new Exception("Card is not active or has expired.");
                }
                if (!card.getCvv().equals(cvv)) {
                    throw new Exception("Security check failed: Invalid CVV.");
                }
                if (card.getDailyLimit().compareTo(amount) < 0) {
                    throw new Exception("Transaction declined: Amount exceeds card daily limit of ₹" + card.getDailyLimit().setScale(2) + ".");
                }

                // Override account with card account
                accountId = card.getAccountId();

                if ("credit".equalsIgnoreCase(card.getCardType())) {
                    BigDecimal newOutstanding = card.getOutstandingBalance().add(amount);
                    if (newOutstanding.compareTo(card.getDailyLimit()) > 0) {
                        throw new Exception("Transaction declined: Exceeds card credit limit. (Available Credit: ₹" + card.getDailyLimit().subtract(card.getOutstandingBalance()).setScale(2) + ")");
                    }

                    // Credit Card Withdrawal (increases outstanding dues, account balance remains untouched)
                    new com.vgb.dao.CardDAOImpl().updateOutstandingBalance(cardId, newOutstanding);

                    // Log audit transaction in ledger
                    Transaction transaction = new Transaction();
                    transaction.setFromAccountId(accountId);
                    transaction.setTransactionType(AppConstants.TRANSACTION_TYPE_WITHDRAWAL);
                    transaction.setAmount(amount);
                    transaction.setReferenceNumber("TXN" + java.util.UUID.randomUUID().toString().substring(0, 8).toUpperCase());
                    transaction.setDescription(description + " (ATM Withdrawal via VGB Credit Card - " + card.getMaskedCardNumber() + ")");
                    transaction.setStatus(AppConstants.TRANSACTION_STATUS_COMPLETED);
                    new com.vgb.dao.TransactionDAOImpl().create(transaction);

                    session.setAttribute("success", "ATM cash withdrawal of ₹" + amount.setScale(2) + " charged to VGB Credit Card successfully.");
                } else {
                    // Debit Card Withdrawal
                    if (accountService.withdraw(accountId, amount, description + " (ATM Withdrawal via VGB Debit Card - " + card.getMaskedCardNumber() + ")")) {
                        session.setAttribute("success", "Card cash withdrawal of ₹" + amount.setScale(2) + " completed successfully.");
                    } else {
                        throw new Exception("Card withdrawal failed.");
                    }
                }
            } else {
                // Standard counter withdrawal
                if (accountService.withdraw(accountId, amount, description)) {
                    session.setAttribute("success", "Cash withdrawal of ₹" + amount.setScale(2) + " completed successfully.");
                } else {
                    session.setAttribute("error", "Cash withdrawal failed.");
                }
            }
        } catch (Exception e) {
            session.setAttribute("error", "Withdrawal transaction failed: " + e.getMessage());
        }

        String redirectUrl = getParameter(request, "redirectUrl", "/account?action=list");
        response.sendRedirect(request.getContextPath() + redirectUrl);
    }

    private void processTransfer(HttpServletRequest request, HttpServletResponse response) throws Exception {
        long fromAccountId = Long.parseLong(getParameter(request, "fromAccountId", "0"));
        String toAccountIdParam = getParameter(request, "toAccountId", "0");
        BigDecimal amount = new BigDecimal(getParameter(request, "amount", "0"));
        String description = getParameter(request, "description", "Transfer");

        boolean useCard = "1".equals(getParameter(request, "useCard", "0")) || "true".equals(getParameter(request, "useCard", "false"));
        long cardId = Long.parseLong(getParameter(request, "cardId", "0"));
        String cvv = getParameter(request, "cvv", "").trim();

        HttpSession session = request.getSession();

        try {
            if (useCard) {
                CardService cardService = new CardService();
                Card card = cardService.getCardById(cardId);
                if (card == null) {
                    throw new Exception("Selected card not found.");
                }
                if (!"active".equalsIgnoreCase(card.getStatus())) {
                    throw new Exception("Card is not active or has expired.");
                }
                if (!card.getCvv().equals(cvv)) {
                    throw new Exception("Security check failed: Invalid CVV.");
                }
                if (card.getDailyLimit().compareTo(amount) < 0) {
                    throw new Exception("Transaction declined: Amount exceeds card daily limit of ₹" + card.getDailyLimit().setScale(2) + ".");
                }

                // Override fromAccountId with card account
                fromAccountId = card.getAccountId();

                if ("credit".equalsIgnoreCase(card.getCardType())) {
                    BigDecimal newOutstanding = card.getOutstandingBalance().add(amount);
                    if (newOutstanding.compareTo(card.getDailyLimit()) > 0) {
                        throw new Exception("Transaction declined: Exceeds card credit limit. (Available Credit: ₹" + card.getDailyLimit().subtract(card.getOutstandingBalance()).setScale(2) + ")");
                    }

                    if (toAccountIdParam.startsWith("ext_")) {
                        // External other bank transfer via VGB Credit Card
                        long beneficiaryId = Long.parseLong(toAccountIdParam.substring(4));
                        String[] details = accountService.getExternalBeneficiaryDetails(beneficiaryId);
                        if (details == null) {
                            throw new Exception("Selected external beneficiary details not found.");
                        }
                        String toAccNum = details[0];
                        String toIfsc = details[1];
                        String toName = details[2];

                        // Deduct card balance
                        new com.vgb.dao.CardDAOImpl().updateOutstandingBalance(cardId, newOutstanding);

                        // Record external transaction
                        Transaction transaction = new Transaction();
                        transaction.setFromAccountId(fromAccountId);
                        transaction.setToAccountId(null);
                        transaction.setTransactionType(AppConstants.TRANSACTION_TYPE_TRANSFER);
                        transaction.setAmount(amount);
                        transaction.setReferenceNumber("TXN" + java.util.UUID.randomUUID().toString().substring(0, 8).toUpperCase());
                        transaction.setDescription(description + " (Transfer to: " + toName + ", A/C: " + toAccNum + ", IFSC: " + toIfsc + " via VGB Credit Card - " + card.getMaskedCardNumber() + ")");
                        transaction.setStatus(AppConstants.TRANSACTION_STATUS_COMPLETED);
                        new com.vgb.dao.TransactionDAOImpl().create(transaction);

                        session.setAttribute("success", "Card funds transfer of ₹" + amount.setScale(2) + " charged to VGB Credit Card completed successfully.");
                    } else {
                        // Standard credit card transfer
                        long toAccountId = Long.parseLong(toAccountIdParam);
                        if (fromAccountId == toAccountId) {
                            throw new Exception("Source card account and destination account cannot be the same.");
                        }

                        new com.vgb.dao.CardDAOImpl().updateOutstandingBalance(cardId, newOutstanding);
                        
                        if (accountService.deposit(toAccountId, amount, description + " (Transfer received via VGB Credit Card - " + card.getMaskedCardNumber() + ")")) {
                            Transaction transaction = new Transaction();
                            transaction.setFromAccountId(fromAccountId);
                            transaction.setToAccountId(toAccountId);
                            transaction.setTransactionType(AppConstants.TRANSACTION_TYPE_TRANSFER);
                            transaction.setAmount(amount);
                            transaction.setReferenceNumber("TXN" + java.util.UUID.randomUUID().toString().substring(0, 8).toUpperCase());
                            transaction.setDescription(description + " (Transfer via VGB Credit Card - " + card.getMaskedCardNumber() + ")");
                            transaction.setStatus(AppConstants.TRANSACTION_STATUS_COMPLETED);
                            new com.vgb.dao.TransactionDAOImpl().create(transaction);

                            session.setAttribute("success", "Card funds transfer of ₹" + amount.setScale(2) + " charged to VGB Credit Card completed successfully.");
                        } else {
                            throw new Exception("Credit transfer failed.");
                        }
                    }
                } else {
                    // Debit Card Transfer
                    if (toAccountIdParam.startsWith("ext_")) {
                        long beneficiaryId = Long.parseLong(toAccountIdParam.substring(4));
                        String[] details = accountService.getExternalBeneficiaryDetails(beneficiaryId);
                        if (details == null) {
                            throw new Exception("Selected external beneficiary details not found.");
                        }
                        String toAccNum = details[0];
                        String toIfsc = details[1];
                        String toName = details[2];

                        if (accountService.externalTransfer(fromAccountId, toAccNum, toIfsc, toName, amount, description + " (P2P Transfer via VGB Debit Card - " + card.getMaskedCardNumber() + ")")) {
                            session.setAttribute("success", "Card funds transfer of ₹" + amount.setScale(2) + " completed successfully.");
                        } else {
                            throw new Exception("Card transfer failed.");
                        }
                    } else {
                        long toAccountId = Long.parseLong(toAccountIdParam);
                        if (fromAccountId == toAccountId) {
                            throw new Exception("Source card account and destination account cannot be the same.");
                        }

                        if (accountService.transfer(fromAccountId, toAccountId, amount, description + " (P2P Transfer via VGB Debit Card - " + card.getMaskedCardNumber() + ")")) {
                            session.setAttribute("success", "Card funds transfer of ₹" + amount.setScale(2) + " completed successfully.");
                        } else {
                            throw new Exception("Card transfer failed.");
                        }
                    }
                }
            } else {
                // Standard Transfer
                if (toAccountIdParam.startsWith("ext_")) {
                    long beneficiaryId = Long.parseLong(toAccountIdParam.substring(4));
                    String[] details = accountService.getExternalBeneficiaryDetails(beneficiaryId);
                    if (details == null) {
                        throw new Exception("Selected external beneficiary details not found.");
                    }
                    String toAccNum = details[0];
                    String toIfsc = details[1];
                    String toName = details[2];

                    if (accountService.externalTransfer(fromAccountId, toAccNum, toIfsc, toName, amount, description)) {
                        session.setAttribute("success", "External fund transfer of ₹" + amount.setScale(2) + " to " + toName + " completed successfully.");
                    } else {
                        session.setAttribute("error", "External transfer failed.");
                    }
                } else {
                    long toAccountId = Long.parseLong(toAccountIdParam);
                    if (fromAccountId == toAccountId) {
                        throw new Exception("Source account and destination account cannot be the same.");
                    }

                    if (accountService.transfer(fromAccountId, toAccountId, amount, description)) {
                        session.setAttribute("success", "Funds transfer of ₹" + amount.setScale(2) + " completed successfully.");
                    } else {
                        session.setAttribute("error", "Funds transfer failed.");
                    }
                }
            }
        } catch (Exception e) {
            session.setAttribute("error", "Transfer transaction failed: " + e.getMessage());
        }

        String redirectUrl = getParameter(request, "redirectUrl", "/account?action=list");
        response.sendRedirect(request.getContextPath() + redirectUrl);
    }

    private void showTransactions(HttpServletRequest request, HttpServletResponse response) throws Exception {
        long accountId = Long.parseLong(getParameter(request, "accountId", "0"));
        Long customerId = getUserId(request);
        Integer adminId = getAdminId(request);

        if (adminId == null && customerId != null) {
            List<Account> accounts = accountService.getCustomerAccounts(customerId);
            request.setAttribute("accounts", accounts);
            if (accountId == 0 && accounts != null && !accounts.isEmpty()) {
                accountId = accounts.get(0).getAccountId();
            }
            request.setAttribute("selectedAccountId", accountId);

            // Load customer's loans for Loan Statement tab
            try {
                com.vgb.service.LoanService loanService = new com.vgb.service.LoanService();
                List<com.vgb.model.Loan> customerLoans = loanService.getCustomerLoans(customerId);
                request.setAttribute("customerLoans", customerLoans);
                
                long loanId = Long.parseLong(getParameter(request, "loanId", "0"));
                if (loanId == 0 && customerLoans != null && !customerLoans.isEmpty()) {
                    loanId = customerLoans.get(0).getLoanId();
                }
                request.setAttribute("selectedLoanId", loanId);
                
                if (loanId > 0) {
                    List<com.vgb.model.Repayment> repayments = new com.vgb.dao.RepaymentDAOImpl().getByLoanId(loanId);
                    request.setAttribute("repayments", repayments);
                    
                    com.vgb.model.Loan selectedLoan = loanService.getLoanById(loanId);
                    request.setAttribute("selectedLoan", selectedLoan);
                }
            } catch (Exception ex) {
                logger.error("Failed to load customer loans/repayments in showTransactions", ex);
            }
        }

        List<Transaction> transactions = accountService.getAccountTransactions(accountId);
        Account currentAccount = accountService.getAccountById(accountId);
        
        if (currentAccount != null && transactions != null) {
            java.math.BigDecimal running = currentAccount.getBalance();
            for (Transaction txn : transactions) {
                txn.setRunningBalance(running);
                if ("completed".equalsIgnoreCase(txn.getStatus())) {
                    String type = txn.getTransactionType();
                    if ("deposit".equalsIgnoreCase(type) || "interest".equalsIgnoreCase(type)) {
                        running = running.subtract(txn.getAmount());
                    } else if ("withdrawal".equalsIgnoreCase(type) || "fee".equalsIgnoreCase(type)) {
                        running = running.add(txn.getAmount());
                    } else if ("transfer".equalsIgnoreCase(type)) {
                        if (txn.getToAccountId() != null && txn.getToAccountId().longValue() == accountId) {
                            // Incoming transfer (Credit) - subtract going backwards in time
                            running = running.subtract(txn.getAmount());
                        } else if (txn.getFromAccountId() != null && txn.getFromAccountId().longValue() == accountId) {
                            // Outgoing transfer (Debit) - add going backwards in time
                            running = running.add(txn.getAmount());
                        }
                    }
                }
            }
        }
        request.setAttribute("transactions", transactions);
        request.setAttribute("selectedAccount", currentAccount);
        
        if (adminId != null) {
            Account statementAccount = currentAccount;
            request.setAttribute("statementAccount", statementAccount);
            if (statementAccount != null) {
                com.vgb.service.CustomerService customerService = new com.vgb.service.CustomerService();
                com.vgb.model.Customer statementCustomer = customerService.getCustomerById(statementAccount.getCustomerId());
                request.setAttribute("statementCustomer", statementCustomer);
            }
            
            // Replicate listAccounts logic to load the Manage Accounts directory in the background
            List<Account> accounts;
            String status = getParameter(request, "status", null);
            if (status != null) {
                accounts = accountService.getAccountsByStatus(status);
            } else {
                accounts = accountService.getAllAccounts();
            }
            request.setAttribute("accounts", accounts);
            
            List<com.vgb.model.Customer> customers = new com.vgb.service.CustomerService().getAllCustomers();
            request.setAttribute("customers", customers);

            try {
                List<com.vgb.model.Loan> loans = new com.vgb.service.LoanService().getAllLoans();
                java.util.Set<Long> customersWithLoans = new java.util.HashSet<>();
                for (com.vgb.model.Loan loan : loans) {
                    if (!"closed".equalsIgnoreCase(loan.getStatus()) && 
                        !"rejected".equalsIgnoreCase(loan.getStatus()) && 
                        !"defaulted".equalsIgnoreCase(loan.getStatus())) {
                        customersWithLoans.add(loan.getCustomerId());
                    }
                }
                request.setAttribute("customersWithLoans", customersWithLoans);
            } catch (Exception e) {
                logger.error("Failed to load loans in showTransactions for loan check", e);
            }
            
            request.getRequestDispatcher("/admin/account.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/customer/statment.jsp").forward(request, response);
        }
    }

    private void showStatement(HttpServletRequest request, HttpServletResponse response) throws Exception {
        showTransactions(request, response);
    }

    /**
     * AJAX Endpoint: Verify if PAN or Aadhaar card already exists in database
     */
    private void verifyKyc(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String type = getParameter(request, "type", "");
        String value = getParameter(request, "value", "").trim();
        boolean exists = false;
        
        com.vgb.dao.CustomerDAOImpl customerDAO = new com.vgb.dao.CustomerDAOImpl();
        if ("pan".equalsIgnoreCase(type)) {
            exists = customerDAO.existsByPan(value);
        } else if ("aadhaar".equalsIgnoreCase(type)) {
            exists = customerDAO.existsByAadhaar(value);
        }
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"exists\":" + exists + "}");
    }

    /**
     * Safe SQL Transaction block to create a customer, open account, and log initial deposit
     */
    private void createCustomerAndAccountProcess(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // Admin spec check
        if (getAdminId(request) == null) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Unauthorized Access");
            return;
        }

        // Retrieve core account parameters
        String accountType = getParameter(request, "accountType", "savings");

        // Retrieve customer registration parameters
        String firstName = getParameter(request, "firstName", "").trim();
        String lastName = getParameter(request, "lastName", "").trim();
        String email = getParameter(request, "email", "").trim();
        String phoneNo = getParameter(request, "phoneNo", "").trim();
        String address = getParameter(request, "address", "").trim();
        String city = getParameter(request, "city", "").trim();
        String state = getParameter(request, "state", "").trim();
        String zipCode = getParameter(request, "zipCode", "").trim();
        String panCard = getParameter(request, "panCard", "").trim();
        String aadhaarCard = getParameter(request, "aadhaarCard", "").trim();

        // Retrieve demographic, address, and financial parameters from wizard step 2
        String middleName = getParameter(request, "middleName", "").trim();
        String fatherName = getParameter(request, "fatherName", "").trim();
        String motherName = getParameter(request, "motherName", "").trim();
        String dob = getParameter(request, "dob", "").trim();
        String gender = getParameter(request, "gender", "").trim();
        String maritalStatus = getParameter(request, "maritalStatus", "").trim();
        String nationality = getParameter(request, "nationality", "Indian").trim();
        String altPhoneNo = getParameter(request, "altPhoneNo", "").trim();
        String occupation = getParameter(request, "occupation", "").trim();
        String annualIncomeStr = getParameter(request, "annualIncome", "0.00").trim();
        String permAddress = getParameter(request, "permAddress", "").trim();

        // Retrieve login parameters
        String username = getParameter(request, "username", "").trim();
        String password = getParameter(request, "password", "");
        String pin = getParameter(request, "pin", "").trim();

        // Banking services options
        boolean hasAtmCard = "1".equals(getParameter(request, "hasAtmCard", "0"));
        String wizardCardType = getParameter(request, "wizardCardType", "debit");
        String wizardCardProvider = getParameter(request, "wizardCardProvider", "visa");
        boolean hasChequeBook = "1".equals(getParameter(request, "hasChequeBook", "0"));
        boolean hasPassbook = true; // Default locked

        // Subclass fields
        String nomineeName = getParameter(request, "nomineeName", "").trim();
        String holdingType = getParameter(request, "holdingType", "single");
        String dailyLimitStr = getParameter(request, "dailyWithdrawalLimit", "50000.00");
        String jointCustomerIdStr = getParameter(request, "jointCustomerId", null);

        // New Joint Signatory registration parameters
        String jointCustomerMode = getParameter(request, "jointCustomerMode", "existing");
        String jointFirstName = getParameter(request, "jointFirstName", "").trim();
        String jointLastName = getParameter(request, "jointLastName", "").trim();
        String jointEmail = getParameter(request, "jointEmail", "").trim();
        String jointPhone = getParameter(request, "jointPhone", "").trim();
        String jointPan = getParameter(request, "jointPan", "").trim();
        String jointAadhaar = getParameter(request, "jointAadhaar", "").trim();
        String jointAddress = getParameter(request, "jointAddress", "").trim();
        String jointCity = getParameter(request, "jointCity", "").trim();
        String jointState = getParameter(request, "jointState", "").trim();
        String jointZipCode = getParameter(request, "jointZipCode", "").trim();

        String businessName = getParameter(request, "businessName", "").trim();
        String gstin = getParameter(request, "gstin", "").trim();
        String overdraftLimitStr = getParameter(request, "overdraftLimit", "100000.00");
        String companyCategory = getParameter(request, "companyCategory", "").trim();
        String companyPhone = getParameter(request, "companyPhone", "").trim();
        String companyEmail = getParameter(request, "companyEmail", "").trim();
        String companyAddress = getParameter(request, "companyAddress", "").trim();
        String companyPan = getParameter(request, "companyPan", "").trim();
        String companyAadhaar = getParameter(request, "companyAadhaar", "").trim();

        BigDecimal initialDeposit = new BigDecimal(getParameter(request, "initialDeposit", "500"));
        String ifscCode = getParameter(request, "ifscCode", "VGBK0000001");

        // If current account, copy company details to representative details to avoid empty fields
        if ("current".equalsIgnoreCase(accountType)) {
            if (firstName.isEmpty()) firstName = businessName;
            if (lastName.isEmpty()) lastName = "Representative";
            if (email.isEmpty()) email = companyEmail;
            if (phoneNo.isEmpty()) phoneNo = companyPhone;
            if (address.isEmpty()) address = companyAddress;
            if (city.isEmpty()) city = "N/A";
            if (state.isEmpty()) state = "N/A";
            if (zipCode.isEmpty()) zipCode = "N/A";
            if (permAddress.isEmpty()) permAddress = companyAddress;
            if (!companyPan.isEmpty()) {
                panCard = companyPan;
            } else if (panCard.isEmpty() && gstin.length() >= 12) {
                panCard = gstin.substring(2, 12).toUpperCase();
            } else if (panCard.isEmpty()) {
                panCard = gstin;
            }
            if (!companyAadhaar.isEmpty()) {
                aadhaarCard = companyAadhaar;
            } else if (aadhaarCard.isEmpty()) {
                aadhaarCard = "000000000000";
            }
        }

        // Basic inputs validation with descriptive field logging and clear user feedback
        if (firstName.isEmpty() || lastName.isEmpty() || email.isEmpty() || phoneNo.isEmpty() || 
            address.isEmpty() || city.isEmpty() || state.isEmpty() || zipCode.isEmpty() || 
            username.isEmpty() || password.isEmpty() || pin.isEmpty()) {
            
            java.util.List<String> missingFields = new java.util.ArrayList<>();
            if (firstName.isEmpty()) missingFields.add("First Name");
            if (lastName.isEmpty()) missingFields.add("Last Name");
            if (email.isEmpty()) missingFields.add("Email");
            if (phoneNo.isEmpty()) missingFields.add("Phone Number");
            if (address.isEmpty()) missingFields.add("Address");
            if (city.isEmpty()) missingFields.add("City");
            if (state.isEmpty()) missingFields.add("State");
            if (zipCode.isEmpty()) missingFields.add("Zip Code");
            if (username.isEmpty()) missingFields.add("Username");
            if (password.isEmpty()) missingFields.add("Password");
            if (pin.isEmpty()) missingFields.add("Secure PIN");

            String errorMsg = "All personal, login, and security fields are required. Missing: " + String.join(", ", missingFields);
            logger.error("Validation failed during customer account opening: {}", errorMsg);
            
            request.setAttribute("error", errorMsg);
            reloadServletAttributes(request);
            request.getRequestDispatcher("/admin/account.jsp").forward(request, response);
            return;
        }

        if (!ValidatorUtil.isValidEmail(email)) {
            request.setAttribute("error", "Invalid email address format.");
            reloadServletAttributes(request);
            request.getRequestDispatcher("/admin/account.jsp").forward(request, response);
            return;
        }

        if (phoneNo.length() != 10 || !phoneNo.matches("\\d+")) {
            request.setAttribute("error", "Phone number must be exactly 10 digits.");
            reloadServletAttributes(request);
            request.getRequestDispatcher("/admin/account.jsp").forward(request, response);
            return;
        }

        if (!SecurityUtil.isValidPIN(pin)) {
            request.setAttribute("error", "Secure PIN must be exactly 4 numeric digits.");
            reloadServletAttributes(request);
            request.getRequestDispatcher("/admin/account.jsp").forward(request, response);
            return;
        }

        // Hash password
        String hashedPassword = SecurityUtil.hashPassword(password);
        String accountNumber = generateIndianAccountNumber();

        Connection conn = null;
        PreparedStatement stmtCheck = null;
        PreparedStatement stmtCust = null;
        PreparedStatement stmtAcc = null;
        PreparedStatement stmtSign = null;
        PreparedStatement stmtTxn = null;
        ResultSet rsCheck = null;

        try {
            conn = DatabaseConfig.getInstance().getConnection();
            conn.setAutoCommit(false); // Start Transaction

            // I. Verify unique constraints
            String checkExistSql = "SELECT " +
                                   "(SELECT COUNT(*) FROM customer WHERE email = ?) as email_count, " +
                                   "(SELECT COUNT(*) FROM customer WHERE phone_no = ?) as phone_count, " +
                                   "(SELECT COUNT(*) FROM customer WHERE username = ?) as user_count, " +
                                   "(SELECT COUNT(*) FROM customer WHERE pan_card = ? AND pan_card IS NOT NULL) as pan_count, " +
                                   "(SELECT COUNT(*) FROM customer WHERE aadhaar_card = ? AND aadhaar_card IS NOT NULL) as aadhaar_count";
            stmtCheck = conn.prepareStatement(checkExistSql);
            stmtCheck.setString(1, email);
            stmtCheck.setString(2, phoneNo);
            stmtCheck.setString(3, username);
            stmtCheck.setString(4, panCard.isEmpty() ? null : panCard);
            stmtCheck.setString(5, aadhaarCard.isEmpty() ? null : aadhaarCard);
            rsCheck = stmtCheck.executeQuery();
            if (rsCheck.next()) {
                if (rsCheck.getInt("email_count") > 0) {
                    throw new SQLException("Email address '" + email + "' is already registered.");
                }
                if (rsCheck.getInt("phone_count") > 0) {
                    throw new SQLException("Phone number '" + phoneNo + "' is already registered.");
                }
                if (rsCheck.getInt("user_count") > 0) {
                    throw new SQLException("Username '" + username + "' is already registered.");
                }
                if (rsCheck.getInt("pan_count") > 0) {
                    throw new SQLException("PAN Card '" + panCard + "' is already registered.");
                }
                if (rsCheck.getInt("aadhaar_count") > 0) {
                    throw new SQLException("Aadhaar Number '" + aadhaarCard + "' is already registered.");
                }
            }
            rsCheck.close();
            stmtCheck.close();

            // II. Determine if pan_card and aadhaar_card columns exist in the database table
            boolean hasKycColumns = false;
            DatabaseMetaData dbmd = conn.getMetaData();
            try (ResultSet rsCol = dbmd.getColumns(null, null, "customer", "pan_card")) {
                if (rsCol.next()) {
                    hasKycColumns = true;
                }
            }

            // III. Insert new customer profile
            long customerId = 0;
            String insertCust;
            if (hasKycColumns) {
                insertCust = "INSERT INTO customer (first_name, middle_name, last_name, father_name, mother_name, dob, gender, marital_status, nationality, email, pan_card, aadhaar_card, phone_no, alt_phone_no, address, perm_address, city, state, zip_code, username, pin, password, status, occupation, annual_income) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                stmtCust = conn.prepareStatement(insertCust, Statement.RETURN_GENERATED_KEYS);
                stmtCust.setString(1, firstName);
                stmtCust.setString(2, middleName.isEmpty() ? null : middleName);
                stmtCust.setString(3, lastName);
                stmtCust.setString(4, fatherName.isEmpty() ? null : fatherName);
                stmtCust.setString(5, motherName.isEmpty() ? null : motherName);
                stmtCust.setDate(6, dob.isEmpty() ? null : java.sql.Date.valueOf(dob));
                stmtCust.setString(7, gender.isEmpty() ? null : gender);
                stmtCust.setString(8, maritalStatus.isEmpty() ? null : maritalStatus);
                stmtCust.setString(9, nationality.isEmpty() ? "Indian" : nationality);
                stmtCust.setString(10, email);
                stmtCust.setString(11, panCard.isEmpty() ? null : panCard);
                stmtCust.setString(12, aadhaarCard.isEmpty() ? null : aadhaarCard);
                stmtCust.setString(13, phoneNo);
                stmtCust.setString(14, altPhoneNo.isEmpty() ? null : altPhoneNo);
                stmtCust.setString(15, address);
                stmtCust.setString(16, permAddress.isEmpty() ? null : permAddress);
                stmtCust.setString(17, city);
                stmtCust.setString(18, state);
                stmtCust.setString(19, zipCode);
                stmtCust.setString(20, username);
                stmtCust.setString(21, pin);
                stmtCust.setString(22, hashedPassword);
                stmtCust.setString(23, "active");
                stmtCust.setString(24, occupation.isEmpty() ? null : occupation);
                
                java.math.BigDecimal incomeVal = null;
                if (!annualIncomeStr.isEmpty()) {
                    String sanitized = annualIncomeStr.replaceAll("[^0-9.]", "");
                    if (!sanitized.isEmpty()) {
                        try {
                            incomeVal = new java.math.BigDecimal(sanitized);
                        } catch (NumberFormatException e) {
                            incomeVal = java.math.BigDecimal.ZERO;
                        }
                    }
                }
                stmtCust.setBigDecimal(25, incomeVal);
            } else {
                insertCust = "INSERT INTO customer (first_name, last_name, email, phone_no, address, city, state, zip_code, username, pin, password, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                stmtCust = conn.prepareStatement(insertCust, Statement.RETURN_GENERATED_KEYS);
                stmtCust.setString(1, firstName);
                stmtCust.setString(2, lastName);
                stmtCust.setString(3, email);
                stmtCust.setString(4, phoneNo);
                stmtCust.setString(5, address);
                stmtCust.setString(6, city);
                stmtCust.setString(7, state);
                stmtCust.setString(8, zipCode);
                stmtCust.setString(9, username);
                stmtCust.setString(10, pin);
                stmtCust.setString(11, hashedPassword);
                stmtCust.setString(12, "active");
            }

            stmtCust.executeUpdate();
            ResultSet rsCust = stmtCust.getGeneratedKeys();
            if (rsCust.next()) {
                customerId = rsCust.getLong(1);
            }
            rsCust.close();
            stmtCust.close();

            if (customerId == 0) {
                throw new SQLException("Failed to retrieve generated customer ID.");
            }

            // Save and set primary customer avatar
            try {
                Part primaryAvatarPart = request.getPart("primaryAvatarFile");
                saveAndSetCustomerAvatar(request, customerId, primaryAvatarPart, conn);
            } catch (Exception e) {
                logger.error("Failed to parse primary avatar file part", e);
            }

            // IV. Open core account (WITHOUT customer_id inside account - mapping goes in account_signatory)
            String insertAcc = "INSERT INTO account (account_type, balance, ifsc_code, account_number, status, has_atm_card, has_cheque_book, has_passbook) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            stmtAcc = conn.prepareStatement(insertAcc, Statement.RETURN_GENERATED_KEYS);
            stmtAcc.setString(1, accountType);
            stmtAcc.setBigDecimal(2, initialDeposit);
            stmtAcc.setString(3, ifscCode);
            stmtAcc.setString(4, accountNumber);
            stmtAcc.setString(5, "active");
            stmtAcc.setInt(6, hasAtmCard ? 1 : 0);
            stmtAcc.setInt(7, hasChequeBook ? 1 : 0);
            stmtAcc.setInt(8, hasPassbook ? 1 : 0);
            stmtAcc.executeUpdate();

            long accountId = 0;
            ResultSet rsAcc = stmtAcc.getGeneratedKeys();
            if (rsAcc.next()) {
                accountId = rsAcc.getLong(1);
            }
            rsAcc.close();
            stmtAcc.close();

            if (accountId == 0) {
                throw new SQLException("Failed to retrieve generated account ID.");
            }

            // V. Map signatories inside junction registry
            String insertSign = "INSERT INTO account_signatory (account_id, customer_id, ownership_type) VALUES (?, ?, ?)";
            stmtSign = conn.prepareStatement(insertSign);
            
            // Link Primary Signatory (Created Customer)
            stmtSign.setLong(1, accountId);
            stmtSign.setLong(2, customerId);
            stmtSign.setString(3, "primary");
            stmtSign.executeUpdate();

            // Link Joint Signatory / Partners
            if ("savings".equalsIgnoreCase(accountType) && "joint".equalsIgnoreCase(holdingType)) {
                long jointCustId = 0;
                if ("existing".equalsIgnoreCase(jointCustomerMode) && jointCustomerIdStr != null) {
                    jointCustId = Long.parseLong(jointCustomerIdStr);
                } else if ("new".equalsIgnoreCase(jointCustomerMode)) {
                    // Check if joint holder already exists by email, phone, PAN, or Aadhaar
                    String checkJointSql = "SELECT customer_id FROM customer WHERE email = ? OR phone_no = ? OR (pan_card = ? AND pan_card IS NOT NULL) OR (aadhaar_card = ? AND aadhaar_card IS NOT NULL)";
                    try (PreparedStatement stmtCheckJ = conn.prepareStatement(checkJointSql)) {
                        stmtCheckJ.setString(1, jointEmail);
                        stmtCheckJ.setString(2, jointPhone);
                        stmtCheckJ.setString(3, jointPan.isEmpty() ? null : jointPan);
                        stmtCheckJ.setString(4, jointAadhaar.isEmpty() ? null : jointAadhaar);
                        try (ResultSet rsCheckJ = stmtCheckJ.executeQuery()) {
                            if (rsCheckJ.next()) {
                                jointCustId = rsCheckJ.getLong("customer_id");
                            }
                        }
                    }

                    if (jointCustId == 0) {
                        // Auto-register brand new joint customer profile
                        String cleanFirst = jointFirstName.toLowerCase().replaceAll("[^a-z0-9]", "");
                        if (cleanFirst.isEmpty()) cleanFirst = "joint";
                        String baseUsername = "j_" + cleanFirst;
                        String jUsername = baseUsername;
                        boolean userExists = true;
                        int suffix = 1000 + new java.util.Random().nextInt(9000);
                        while (userExists) {
                            jUsername = baseUsername + "_" + suffix;
                            String checkUserSql = "SELECT COUNT(*) FROM customer WHERE username = ?";
                            try (PreparedStatement stmtCheckUser = conn.prepareStatement(checkUserSql)) {
                                stmtCheckUser.setString(1, jUsername);
                                try (ResultSet rsCheckUser = stmtCheckUser.executeQuery()) {
                                    if (rsCheckUser.next() && rsCheckUser.getInt(1) == 0) {
                                        userExists = false;
                                    } else {
                                        suffix = 1000 + new java.util.Random().nextInt(9000);
                                    }
                                }
                            }
                        }

                        String jPin = String.format("%04d", new java.util.Random().nextInt(10000));
                        String jDefaultPassword = "VgbJoint123!";
                        String jHashedPassword = com.vgb.util.SecurityUtil.hashPassword(jDefaultPassword);

                        String insertCustSql;
                        if (hasKycColumns) {
                            insertCustSql = "INSERT INTO customer (first_name, last_name, email, pan_card, aadhaar_card, phone_no, address, city, state, zip_code, username, pin, password, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                            try (PreparedStatement stmtCustNew = conn.prepareStatement(insertCustSql, Statement.RETURN_GENERATED_KEYS)) {
                                stmtCustNew.setString(1, jointFirstName);
                                stmtCustNew.setString(2, jointLastName);
                                stmtCustNew.setString(3, jointEmail);
                                stmtCustNew.setString(4, jointPan.isEmpty() ? null : jointPan);
                                stmtCustNew.setString(5, jointAadhaar.isEmpty() ? null : jointAadhaar);
                                stmtCustNew.setString(6, jointPhone);
                                stmtCustNew.setString(7, jointAddress);
                                stmtCustNew.setString(8, jointCity);
                                stmtCustNew.setString(9, jointState);
                                stmtCustNew.setString(10, jointZipCode);
                                stmtCustNew.setString(11, jUsername);
                                stmtCustNew.setString(12, jPin);
                                stmtCustNew.setString(13, jHashedPassword);
                                stmtCustNew.setString(14, "active");
                                stmtCustNew.executeUpdate();
                                try (ResultSet rsCustNew = stmtCustNew.getGeneratedKeys()) {
                                    if (rsCustNew.next()) {
                                        jointCustId = rsCustNew.getLong(1);
                                    }
                                }
                            }
                        } else {
                            insertCustSql = "INSERT INTO customer (first_name, last_name, email, phone_no, address, city, state, zip_code, username, pin, password, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                            try (PreparedStatement stmtCustNew = conn.prepareStatement(insertCustSql, Statement.RETURN_GENERATED_KEYS)) {
                                stmtCustNew.setString(1, jointFirstName);
                                stmtCustNew.setString(2, jointLastName);
                                stmtCustNew.setString(3, jointEmail);
                                stmtCustNew.setString(4, jointPhone);
                                stmtCustNew.setString(5, jointAddress);
                                stmtCustNew.setString(6, jointCity);
                                stmtCustNew.setString(7, jointState);
                                stmtCustNew.setString(8, jointZipCode);
                                stmtCustNew.setString(9, jUsername);
                                stmtCustNew.setString(10, jPin);
                                stmtCustNew.setString(11, jHashedPassword);
                                stmtCustNew.setString(12, "active");
                                stmtCustNew.executeUpdate();
                                try (ResultSet rsCustNew = stmtCustNew.getGeneratedKeys()) {
                                    if (rsCustNew.next()) {
                                        jointCustId = rsCustNew.getLong(1);
                                    }
                                }
                            }
                        }

                        if (jointCustId == 0) {
                            throw new SQLException("Failed to retrieve generated joint customer ID.");
                        }

                        // Save and set joint customer avatar
                        try {
                            Part jointAvatarPart = request.getPart("jointAvatarFile");
                            saveAndSetCustomerAvatar(request, jointCustId, jointAvatarPart, conn);
                        } catch (Exception e) {
                            logger.error("Failed to parse joint avatar file part", e);
                        }

                        java.util.List<String> autoCreated = new java.util.ArrayList<>();
                        autoCreated.add(jointFirstName + " " + jointLastName + " (Username: " + jUsername + ", PIN: " + jPin + ")");
                        request.getSession().setAttribute("autoCreatedPartners", autoCreated);
                    }
                }

                if (jointCustId > 0) {
                    stmtSign.setLong(1, accountId);
                    stmtSign.setLong(2, jointCustId);
                    stmtSign.setString(3, "joint_holder");
                    stmtSign.executeUpdate();
                }
            } else if ("current".equalsIgnoreCase(accountType)) {
                // Parse dynamic partner signatory details
                String[] pFirstNames = request.getParameterValues("partnerFirstName");
                String[] pLastNames = request.getParameterValues("partnerLastName");
                String[] pEmails = request.getParameterValues("partnerEmail");
                String[] pPhones = request.getParameterValues("partnerPhone");
                String[] pPans = request.getParameterValues("partnerPan");
                String[] pAadhaars = request.getParameterValues("partnerAadhaar");

                if (pFirstNames != null) {
                    java.util.List<Part> partnerAvatarParts = new java.util.ArrayList<>();
                    try {
                        for (Part part : request.getParts()) {
                            if ("partnerAvatarFile".equals(part.getName())) {
                                partnerAvatarParts.add(part);
                            }
                        }
                    } catch (Exception e) {
                        logger.error("Failed to parse request parts for partner avatars", e);
                    }

                    java.util.List<String> autoCreated = new java.util.ArrayList<>();
                    for (int i = 0; i < pFirstNames.length; i++) {
                        String pFirst = (i < pFirstNames.length && pFirstNames[i] != null) ? pFirstNames[i].trim() : "";
                        String pLast = (i < pLastNames.length && pLastNames[i] != null) ? pLastNames[i].trim() : "";
                        String pEmail = (i < pEmails.length && pEmails[i] != null) ? pEmails[i].trim() : "";
                        String pPhone = (i < pPhones.length && pPhones[i] != null) ? pPhones[i].trim() : "";
                        String pPan = (i < pPans.length && pPans[i] != null) ? pPans[i].trim() : "";
                        String pAadhaar = (i < pAadhaars.length && pAadhaars[i] != null) ? pAadhaars[i].trim() : "";

                        if (pFirst.isEmpty() || pLast.isEmpty() || pEmail.isEmpty() || pPhone.isEmpty()) {
                            continue; // Skip incomplete partner card inputs
                        }

                        long partnerCustId = 0;

                        // Check if partner already exists by email, phone, PAN, or Aadhaar
                        String checkPartnerSql = "SELECT customer_id FROM customer WHERE email = ? OR phone_no = ? OR (pan_card = ? AND pan_card IS NOT NULL) OR (aadhaar_card = ? AND aadhaar_card IS NOT NULL)";
                        try (PreparedStatement stmtCheckPart = conn.prepareStatement(checkPartnerSql)) {
                            stmtCheckPart.setString(1, pEmail);
                            stmtCheckPart.setString(2, pPhone);
                            stmtCheckPart.setString(3, pPan.isEmpty() ? null : pPan);
                            stmtCheckPart.setString(4, pAadhaar.isEmpty() ? null : pAadhaar);
                            try (ResultSet rsCheckPart = stmtCheckPart.executeQuery()) {
                                if (rsCheckPart.next()) {
                                    partnerCustId = rsCheckPart.getLong("customer_id");
                                }
                            }
                        }

                        if (partnerCustId == 0) {
                            // Auto-register partner
                            // 1. Generate unique username: p_firstname_xxxx
                            String cleanFirst = pFirst.toLowerCase().replaceAll("[^a-z0-9]", "");
                            if (cleanFirst.isEmpty()) cleanFirst = "partner";
                            String baseUsername = "p_" + cleanFirst;
                            String pUsername = baseUsername;
                            boolean userExists = true;
                            int suffix = 1000 + new java.util.Random().nextInt(9000);
                            while (userExists) {
                                pUsername = baseUsername + "_" + suffix;
                                String checkUserSql = "SELECT COUNT(*) FROM customer WHERE username = ?";
                                try (PreparedStatement stmtCheckUser = conn.prepareStatement(checkUserSql)) {
                                    stmtCheckUser.setString(1, pUsername);
                                    try (ResultSet rsCheckUser = stmtCheckUser.executeQuery()) {
                                        if (rsCheckUser.next() && rsCheckUser.getInt(1) == 0) {
                                            userExists = false;
                                        } else {
                                            suffix = 1000 + new java.util.Random().nextInt(9000);
                                        }
                                    }
                                }
                            }

                            // 2. Generate 4-digit PIN & Hashed secure default password
                            String pPin = String.format("%04d", new java.util.Random().nextInt(10000));
                            String pDefaultPassword = "VgbPartner123!";
                            String pHashedPassword = com.vgb.util.SecurityUtil.hashPassword(pDefaultPassword);

                            // 3. Insert partner into customer table
                            String insertCustSql;
                            if (hasKycColumns) {
                                insertCustSql = "INSERT INTO customer (first_name, last_name, email, pan_card, aadhaar_card, phone_no, address, city, state, zip_code, username, pin, password, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                                try (PreparedStatement stmtCustNew = conn.prepareStatement(insertCustSql, Statement.RETURN_GENERATED_KEYS)) {
                                    stmtCustNew.setString(1, pFirst);
                                    stmtCustNew.setString(2, pLast);
                                    stmtCustNew.setString(3, pEmail);
                                    stmtCustNew.setString(4, pPan.isEmpty() ? null : pPan);
                                    stmtCustNew.setString(5, pAadhaar.isEmpty() ? null : pAadhaar);
                                    stmtCustNew.setString(6, pPhone);
                                    stmtCustNew.setString(7, address); // Inherit address details
                                    stmtCustNew.setString(8, city);
                                    stmtCustNew.setString(9, state);
                                    stmtCustNew.setString(10, zipCode);
                                    stmtCustNew.setString(11, pUsername);
                                    stmtCustNew.setString(12, pPin);
                                    stmtCustNew.setString(13, pHashedPassword);
                                    stmtCustNew.setString(14, "active");
                                    stmtCustNew.executeUpdate();
                                    try (ResultSet rsCustNew = stmtCustNew.getGeneratedKeys()) {
                                        if (rsCustNew.next()) {
                                            partnerCustId = rsCustNew.getLong(1);
                                        }
                                    }
                                }
                            } else {
                                insertCustSql = "INSERT INTO customer (first_name, last_name, email, phone_no, address, city, state, zip_code, username, pin, password, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                                try (PreparedStatement stmtCustNew = conn.prepareStatement(insertCustSql, Statement.RETURN_GENERATED_KEYS)) {
                                    stmtCustNew.setString(1, pFirst);
                                    stmtCustNew.setString(2, pLast);
                                    stmtCustNew.setString(3, pEmail);
                                    stmtCustNew.setString(4, pPhone);
                                    stmtCustNew.setString(5, address);
                                    stmtCustNew.setString(6, city);
                                    stmtCustNew.setString(7, state);
                                    stmtCustNew.setString(8, zipCode);
                                    stmtCustNew.setString(9, pUsername);
                                    stmtCustNew.setString(10, pPin);
                                    stmtCustNew.setString(11, pHashedPassword);
                                    stmtCustNew.setString(12, "active");
                                    stmtCustNew.executeUpdate();
                                    try (ResultSet rsCustNew = stmtCustNew.getGeneratedKeys()) {
                                        if (rsCustNew.next()) {
                                            partnerCustId = rsCustNew.getLong(1);
                                        }
                                    }
                                }
                            }

                            if (partnerCustId == 0) {
                                throw new SQLException("Failed to retrieve generated partner customer ID.");
                            }

                            // Save and set partner customer avatar
                            try {
                                Part pAvatarPart = (i < partnerAvatarParts.size()) ? partnerAvatarParts.get(i) : null;
                                saveAndSetCustomerAvatar(request, partnerCustId, pAvatarPart, conn);
                            } catch (Exception e) {
                                logger.error("Failed to parse partner avatar file part at index " + i, e);
                            }

                            autoCreated.add(pFirst + " " + pLast + " (Username: " + pUsername + ", PIN: " + pPin + ")");
                        }

                        // Link partner signatory into junction registry
                        stmtSign.setLong(1, accountId);
                        stmtSign.setLong(2, partnerCustId);
                        stmtSign.setString(3, "joint_holder");
                        stmtSign.executeUpdate();
                    }

                    if (!autoCreated.isEmpty()) {
                        request.getSession().setAttribute("autoCreatedPartners", autoCreated);
                    }
                }
            }
            stmtSign.close();

            // VI. Map Sub-table subclass specifics
            if ("savings".equalsIgnoreCase(accountType)) {
                String insertSav = "INSERT INTO account_savings (account_id, nominee_name, holding_type, daily_withdrawal_limit) VALUES (?, ?, ?, ?)";
                try (PreparedStatement stmtSav = conn.prepareStatement(insertSav)) {
                    stmtSav.setLong(1, accountId);
                    stmtSav.setString(2, nomineeName.isEmpty() ? "No Nominee" : nomineeName);
                    stmtSav.setString(3, holdingType);
                    stmtSav.setBigDecimal(4, new BigDecimal(dailyLimitStr));
                    stmtSav.executeUpdate();
                }
            } else if ("current".equalsIgnoreCase(accountType)) {
                String insertCurr = "INSERT INTO account_current (account_id, business_name, gstin, overdraft_limit, company_category, company_phone, company_email, company_address, company_pan, company_aadhaar) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                try (PreparedStatement stmtCurr = conn.prepareStatement(insertCurr)) {
                    stmtCurr.setLong(1, accountId);
                    stmtCurr.setString(2, businessName.isEmpty() ? "Unnamed Business" : businessName);
                    stmtCurr.setString(3, gstin.isEmpty() ? "GST" + java.util.UUID.randomUUID().toString().substring(0, 10).toUpperCase() : gstin);
                    stmtCurr.setBigDecimal(4, new BigDecimal(overdraftLimitStr));
                    stmtCurr.setString(5, companyCategory);
                    stmtCurr.setString(6, companyPhone);
                    stmtCurr.setString(7, companyEmail);
                    stmtCurr.setString(8, companyAddress);
                    stmtCurr.setString(9, companyPan);
                    stmtCurr.setString(10, companyAadhaar);
                    stmtCurr.executeUpdate();
                }
            }

            // VII. Log initial counter deposit CREDIT transaction
            String insertTxn = "INSERT INTO transaction (from_account_id, to_account_id, transaction_type, amount, reference_number, description, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
            stmtTxn = conn.prepareStatement(insertTxn);
            stmtTxn.setNull(1, Types.BIGINT);
            stmtTxn.setLong(2, accountId);
            stmtTxn.setString(3, "deposit");
            stmtTxn.setBigDecimal(4, initialDeposit);
            stmtTxn.setString(5, "TXN" + java.util.UUID.randomUUID().toString().substring(0, 8).toUpperCase());
            stmtTxn.setString(6, "Initial account opening deposit (Credit)");
            stmtTxn.setString(7, "completed");
            stmtTxn.executeUpdate();
            stmtTxn.close();

            conn.commit(); // Transaction success!
            logger.info("Ledger created. Cust ID: {}, Account No: {}, Balance: ₹{}", customerId, accountNumber, initialDeposit);

            HttpSession session = request.getSession();
            StringBuilder successMsg = new StringBuilder();
            successMsg.append("Ledger successfully initialized! Customer profile '")
                      .append(firstName).append(" ").append(lastName)
                      .append("' registered with username '").append(username)
                      .append("'. Account No: '").append(accountNumber)
                      .append("' is active with initial deposit ₹").append(initialDeposit).append("!");
            
            @SuppressWarnings("unchecked")
            java.util.List<String> autoCreated = (java.util.List<String>) session.getAttribute("autoCreatedPartners");
            if (autoCreated != null && !autoCreated.isEmpty()) {
                if ("savings".equalsIgnoreCase(accountType)) {
                    successMsg.append(" The joint holder was auto-registered with default password 'VgbJoint123!': ");
                } else {
                    successMsg.append(" The following partners were auto-registered with default password 'VgbPartner123!': ");
                }
                for (int idx = 0; idx < autoCreated.size(); idx++) {
                    if (idx > 0) successMsg.append(", ");
                    successMsg.append(autoCreated.get(idx));
                }
                session.removeAttribute("autoCreatedPartners"); // Clean up session
            }

            // Auto-generate VGB card request if opted
            if (hasAtmCard) {
                try {
                    com.vgb.service.CardService cardService = new com.vgb.service.CardService();
                    String cardHolderName = (firstName + " " + lastName).trim().toUpperCase();
                    cardService.applyForCard(customerId, accountId, wizardCardType, wizardCardProvider, cardHolderName);
                    logger.info("Auto-registered pending VGB card for Account ID: {}", accountId);
                    successMsg.append(" Programmatic ATM card application generated successfully (Pending Approval).");
                } catch (Exception cardEx) {
                    logger.error("Failed to auto-generate VGB card during account setup", cardEx);
                    successMsg.append(" (Warning: ATM card generation failed: ").append(cardEx.getMessage()).append(")");
                }
            }

            session.setAttribute("success", successMsg.toString());
            response.sendRedirect(request.getContextPath() + "/account?action=list");

        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { logger.error("Rollback failed!", ex); }
            }
            logger.error("Unified customer & account transaction failed", e);
            request.setAttribute("error", "Database Transaction failed: " + e.getMessage());
            reloadServletAttributes(request);
            request.getRequestDispatcher("/admin/account.jsp").forward(request, response);
        } finally {
            DatabaseConfig.closeResources(rsCheck, stmtCheck, conn);
        }
    }

    /**
     * Helper to reload dashboard lists in error states
     */
    private void reloadServletAttributes(HttpServletRequest request) {
        try {
            List<com.vgb.model.Customer> customers = new com.vgb.service.CustomerService().getAllCustomers();
            request.setAttribute("customers", customers);
            List<Account> accounts = accountService.getAllAccounts();
            request.setAttribute("accounts", accounts);
        } catch (Exception ex) {}
    }

    /**
     * Update details of an existing customer (Admin only - Personal and Login details)
     */
    private void updateAccount(HttpServletRequest request, HttpServletResponse response) throws Exception {
        if (getAdminId(request) == null) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Unauthorized Access");
            return;
        }

        if (!validateCSRFToken(request)) {
            request.getSession().setAttribute("error", "Failed security check: Invalid CSRF token");
            response.sendRedirect(request.getContextPath() + "/account?action=list");
            return;
        }

        try {
            long customerId = Long.parseLong(getParameter(request, "customerId", "0"));
            long accountId = Long.parseLong(getParameter(request, "accountId", "0"));

            String firstName = getParameter(request, "firstName", "");
            String lastName = getParameter(request, "lastName", "");
            String email = getParameter(request, "email", "");
            String phoneNo = getParameter(request, "phoneNo", "");
            String address = getParameter(request, "address", "");
            String city = getParameter(request, "city", "");
            String state = getParameter(request, "state", "");
            String zipCode = getParameter(request, "zipCode", "");
            String pin = getParameter(request, "pin", "");
            String password = getParameter(request, "password", "");
            String panCard = getParameter(request, "panCard", "").trim();
            String aadhaarCard = getParameter(request, "aadhaarCard", "").trim();

            if (accountId > 0) {
                Account acc = accountService.getAccountById(accountId);
                if (acc != null && "current".equalsIgnoreCase(acc.getAccountType())) {
                    String companyPan = getParameter(request, "companyPan", "").trim();
                    String companyAadhaar = getParameter(request, "companyAadhaar", "").trim();
                    if (!companyPan.isEmpty()) {
                        panCard = companyPan;
                    }
                    if (!companyAadhaar.isEmpty()) {
                        aadhaarCard = companyAadhaar;
                    }
                }
            }

            com.vgb.service.CustomerService customerService = new com.vgb.service.CustomerService();
            com.vgb.model.Customer customer = customerService.getCustomerById(customerId);

            if (customer == null) {
                request.getSession().setAttribute("error", "Customer profile not found.");
                response.sendRedirect(request.getContextPath() + "/account?action=list");
                return;
            }

            // Update personal details
            customer.setFirstName(firstName);
            customer.setLastName(lastName);
            customer.setEmail(email);
            customer.setPhoneNo(phoneNo);
            customer.setAddress(address);
            customer.setCity(city);
            customer.setState(state);
            customer.setZipCode(zipCode);
            customer.setPanCard(panCard.isEmpty() ? null : panCard);
            customer.setAadhaarCard(aadhaarCard.isEmpty() ? null : aadhaarCard);

            boolean profileSuccess = customerService.updateCustomerProfile(customer);

            // Dynamically update pan_card & aadhaar_card in DB (KYC columns upgrade fallback)
            try (Connection conn = DatabaseConfig.getInstance().getConnection();
                 PreparedStatement stmtKyc = conn.prepareStatement("UPDATE customer SET pan_card = ?, aadhaar_card = ? WHERE customer_id = ?")) {
                stmtKyc.setString(1, panCard.isEmpty() ? null : panCard);
                stmtKyc.setString(2, aadhaarCard.isEmpty() ? null : aadhaarCard);
                stmtKyc.setLong(3, customerId);
                stmtKyc.executeUpdate();
            } catch (Exception ex) {
                logger.warn("Dynamic KYC columns update skipped: {}", ex.getMessage());
            }

            // Joint Holder Profile Update logic if present
            long jointCustomerId = Long.parseLong(getParameter(request, "jointCustomerId", "0"));
            if (jointCustomerId > 0) {
                com.vgb.model.Customer jointCustomer = customerService.getCustomerById(jointCustomerId);
                if (jointCustomer != null) {
                    jointCustomer.setFirstName(getParameter(request, "jointFirstName", ""));
                    jointCustomer.setLastName(getParameter(request, "jointLastName", ""));
                    jointCustomer.setEmail(getParameter(request, "jointEmail", ""));
                    jointCustomer.setPhoneNo(getParameter(request, "jointPhoneNo", ""));
                    jointCustomer.setAddress(getParameter(request, "jointAddress", ""));
                    jointCustomer.setCity(getParameter(request, "jointCity", ""));
                    jointCustomer.setState(getParameter(request, "jointState", ""));
                    jointCustomer.setZipCode(getParameter(request, "jointZipCode", ""));
                    
                    String jPan = getParameter(request, "jointPanCard", "").trim();
                    String jAadhaar = getParameter(request, "jointAadhaarCard", "").trim();
                    jointCustomer.setPanCard(jPan.isEmpty() ? null : jPan);
                    jointCustomer.setAadhaarCard(jAadhaar.isEmpty() ? null : jAadhaar);
                    
                    customerService.updateCustomerProfile(jointCustomer);
                    
                    // Fallback database update for KYC columns
                    try (Connection jConn = DatabaseConfig.getInstance().getConnection();
                         PreparedStatement stmtJKyc = jConn.prepareStatement("UPDATE customer SET pan_card = ?, aadhaar_card = ? WHERE customer_id = ?")) {
                        stmtJKyc.setString(1, jPan.isEmpty() ? null : jPan);
                        stmtJKyc.setString(2, jAadhaar.isEmpty() ? null : jAadhaar);
                        stmtJKyc.setLong(3, jointCustomerId);
                        stmtJKyc.executeUpdate();
                    } catch (Exception ex) {
                        logger.warn("Dynamic joint KYC columns update skipped: {}", ex.getMessage());
                    }
                }
            }

            // Update Banking Services & Sub-table properties
            if (accountId > 0) {
                Account account = accountService.getAccountById(accountId);
                if (account != null) {
                    boolean hasAtmCard = "1".equals(getParameter(request, "hasAtmCard", "0"));
                    boolean hasChequeBook = "1".equals(getParameter(request, "hasChequeBook", "0"));
                    account.setHasAtmCard(hasAtmCard);
                    account.setHasChequeBook(hasChequeBook);

                    if ("savings".equalsIgnoreCase(account.getAccountType())) {
                        String nominee = getParameter(request, "nomineeName", "");
                        String holding = getParameter(request, "holdingType", "single");
                        String limitStr = getParameter(request, "dailyWithdrawalLimit", "50000.00");
                        account.setNomineeName(nominee);
                        account.setHoldingType(holding);
                        account.setDailyWithdrawalLimit(new BigDecimal(limitStr));
                    } else if ("current".equalsIgnoreCase(account.getAccountType())) {
                        String busName = getParameter(request, "businessName", "");
                        String gst = getParameter(request, "gstin", "");
                        String odLimitStr = getParameter(request, "overdraftLimit", "100000.00");
                        account.setBusinessName(busName);
                        account.setGstin(gst);
                        account.setOverdraftLimit(new BigDecimal(odLimitStr));
                        
                        account.setCompanyCategory(getParameter(request, "companyCategory", ""));
                        account.setCompanyPhone(getParameter(request, "companyPhone", ""));
                        account.setCompanyEmail(getParameter(request, "companyEmail", ""));
                        account.setCompanyAddress(getParameter(request, "companyAddress", ""));
                        account.setCompanyPan(getParameter(request, "companyPan", ""));
                        account.setCompanyAadhaar(getParameter(request, "companyAadhaar", ""));
                    }
                    new com.vgb.dao.AccountDAOImpl().update(account);
                }
            }

            // Update PIN if provided and changed
            boolean pinSuccess = true;
            if (pin != null && !pin.trim().isEmpty() && !pin.equals(customer.getPin())) {
                com.vgb.service.AuthService authService = new com.vgb.service.AuthService();
                pinSuccess = authService.updateCustomerPIN(customerId, pin);
                if (!pinSuccess) {
                    throw new Exception("PIN must be exactly 4 digits.");
                }
            }

            // Update Password if optionally entered
            boolean pwdSuccess = true;
            if (password != null && !password.trim().isEmpty()) {
                if (!com.vgb.util.SecurityUtil.isValidPasswordStrength(password)) {
                    throw new Exception("Password must be at least 8 characters and contain uppercase, lowercase, digit, and special character.");
                }
                String hashedPassword = com.vgb.util.SecurityUtil.hashPassword(password);
                pwdSuccess = new com.vgb.dao.CustomerDAOImpl().updatePassword(customerId, hashedPassword);
            }

            if (profileSuccess && pinSuccess && pwdSuccess) {
                request.getSession().setAttribute("success", "Customer profiles, banking services, and account details updated successfully!");
            } else {
                request.getSession().setAttribute("error", "Failed to update customer details.");
            }
        } catch (Exception e) {
            logger.error("Error updating customer profile in servlet", e);
            request.getSession().setAttribute("error", "Error: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/account?action=list");
    }

    /**
     * Get complete details of a customer and their banking account as a JSON object (Admin only)
     */
    private void getCustomerDetails(HttpServletRequest request, HttpServletResponse response) throws Exception {
        if (getAdminId(request) == null) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Unauthorized Access");
            return;
        }

        Connection conn = null;
        try {
            long customerId = Long.parseLong(getParameter(request, "customerId", "0"));
            long accountId = Long.parseLong(getParameter(request, "accountId", "0"));

            com.vgb.service.CustomerService customerService = new com.vgb.service.CustomerService();
            com.vgb.model.Customer customer = customerService.getCustomerById(customerId);
            Account account = accountService.getAccountById(accountId);

            if (customer == null) {
                sendErrorResponse(response, "Customer not found", HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            java.util.Map<String, Object> data = new java.util.HashMap<>();
            // Personal Details
            data.put("customerId", customer.getCustomerId());
            data.put("firstName", customer.getFirstName());
            data.put("lastName", customer.getLastName());
            data.put("email", customer.getEmail());
            data.put("phoneNo", customer.getPhoneNo());
            data.put("address", customer.getAddress());
            data.put("city", customer.getCity());
            data.put("state", customer.getState());
            data.put("zipCode", customer.getZipCode());
            data.put("customerStatus", customer.getStatus());
            data.put("panCard", customer.getPanCard() != null ? customer.getPanCard() : "");
            data.put("aadhaarCard", customer.getAadhaarCard() != null ? customer.getAadhaarCard() : "");

            // Login Details
            data.put("username", customer.getUsername());
            data.put("pin", customer.getPin());

            // Banking Details
            if (account != null) {
                data.put("accountId", account.getAccountId());
                data.put("accountNumber", account.getAccountNumber());
                data.put("accountType", account.getAccountType());
                data.put("ifscCode", account.getIfscCode());
                data.put("balance", account.getBalance().toString());
                data.put("accountStatus", account.getStatus());
                data.put("createdAt", account.getCreatedAt() != null ? account.getCreatedAt().toString() : "N/A");
                
                // Services Preferences
                data.put("hasAtmCard", account.isHasAtmCard());
                data.put("hasChequeBook", account.isHasChequeBook());
                data.put("hasPassbook", account.isHasPassbook());

                // Savings fields
                data.put("nomineeName", account.getNomineeName() != null ? account.getNomineeName() : "");
                data.put("holdingType", account.getHoldingType() != null ? account.getHoldingType() : "single");
                data.put("dailyWithdrawalLimit", account.getDailyWithdrawalLimit() != null ? account.getDailyWithdrawalLimit().toString() : "50000.00");

                // Current fields
                data.put("businessName", account.getBusinessName() != null ? account.getBusinessName() : "");
                data.put("gstin", account.getGstin() != null ? account.getGstin() : "");
                data.put("overdraftLimit", account.getOverdraftLimit() != null ? account.getOverdraftLimit().toString() : "100000.00");
                data.put("companyCategory", account.getCompanyCategory() != null ? account.getCompanyCategory() : "");
                data.put("companyPhone", account.getCompanyPhone() != null ? account.getCompanyPhone() : "");
                data.put("companyEmail", account.getCompanyEmail() != null ? account.getCompanyEmail() : "");
                data.put("companyAddress", account.getCompanyAddress() != null ? account.getCompanyAddress() : "");
                data.put("companyPan", account.getCompanyPan() != null ? account.getCompanyPan() : "");
                data.put("companyAadhaar", account.getCompanyAadhaar() != null ? account.getCompanyAadhaar() : "");

                // Fetch signatory partners list
                List<java.util.Map<String, String>> partners = new java.util.ArrayList<>();
                com.vgb.model.Customer jointCustomer = null;
                conn = DatabaseConfig.getInstance().getConnection();
                String partnerSql = "SELECT c.customer_id, c.first_name, c.last_name, c.email, c.phone_no, s.ownership_type " +
                                     "FROM account_signatory s " +
                                     "JOIN customer c ON s.customer_id = c.customer_id " +
                                     "WHERE s.account_id = ?";
                try (PreparedStatement stmtPartner = conn.prepareStatement(partnerSql)) {
                    stmtPartner.setLong(1, accountId);
                    try (ResultSet rsPartner = stmtPartner.executeQuery()) {
                        while (rsPartner.next()) {
                            java.util.Map<String, String> partner = new java.util.HashMap<>();
                            long id = rsPartner.getLong("customer_id");
                            partner.put("customerId", String.valueOf(id));
                            partner.put("name", rsPartner.getString("first_name") + " " + rsPartner.getString("last_name"));
                            partner.put("email", rsPartner.getString("email"));
                            partner.put("phoneNo", rsPartner.getString("phone_no"));
                            String ownershipType = rsPartner.getString("ownership_type");
                            partner.put("ownershipType", ownershipType);
                            partners.add(partner);
                            
                            if ("joint_holder".equalsIgnoreCase(ownershipType)) {
                                jointCustomer = customerService.getCustomerById(id);
                            }
                        }
                    }
                }
                data.put("partners", partners);
                if (jointCustomer != null) {
                    java.util.Map<String, Object> jointData = new java.util.HashMap<>();
                    jointData.put("customerId", jointCustomer.getCustomerId());
                    jointData.put("firstName", jointCustomer.getFirstName());
                    jointData.put("lastName", jointCustomer.getLastName());
                    jointData.put("email", jointCustomer.getEmail());
                    jointData.put("phoneNo", jointCustomer.getPhoneNo());
                    jointData.put("address", jointCustomer.getAddress());
                    jointData.put("city", jointCustomer.getCity());
                    jointData.put("state", jointCustomer.getState());
                    jointData.put("zipCode", jointCustomer.getZipCode());
                    jointData.put("panCard", jointCustomer.getPanCard() != null ? jointCustomer.getPanCard() : "");
                    jointData.put("aadhaarCard", jointCustomer.getAadhaarCard() != null ? jointCustomer.getAadhaarCard() : "");
                    data.put("jointCustomer", jointData);
                }
            }

            sendJsonResponse(response, data, HttpServletResponse.SC_OK);
        } catch (Exception e) {
            logger.error("Error fetching customer details as JSON", e);
            sendErrorResponse(response, e.getMessage(), HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        } finally {
            if (conn != null) {
                try { conn.close(); } catch (Exception e) {}
            }
        }
    }

    /**
     * Terminate / soft-close an existing account (Admin only)
     */
    private void closeAccount(HttpServletRequest request, HttpServletResponse response) throws Exception {
        if (getAdminId(request) == null) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Unauthorized Access");
            return;
        }

        if (!validateCSRFToken(request)) {
            request.getSession().setAttribute("error", "Failed security check: Invalid CSRF token");
            response.sendRedirect(request.getContextPath() + "/account?action=list");
            return;
        }

        try {
            long accountId = Long.parseLong(getParameter(request, "accountId", "0"));

            boolean success = accountService.updateAccountStatus(accountId, AppConstants.ACCOUNT_STATUS_CLOSED);
            if (success) {
                request.getSession().setAttribute("success", "Account terminated / closed successfully!");
            } else {
                request.getSession().setAttribute("error", "Failed to close the account. Database rejected status change.");
            }
        } catch (Exception e) {
            logger.error("Error closing account in servlet", e);
            request.getSession().setAttribute("error", "Error: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/account?action=list");
    }

    /**
     * Permanently delete an existing account and associated customer (Admin only)
     */
    private void deleteAccount(HttpServletRequest request, HttpServletResponse response) throws Exception {
        if (getAdminId(request) == null) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Unauthorized Access");
            return;
        }

        if (!validateCSRFToken(request)) {
            request.getSession().setAttribute("error", "Failed security check: Invalid CSRF token");
            response.sendRedirect(request.getContextPath() + "/account?action=list");
            return;
        }

        try {
            long accountId = Long.parseLong(getParameter(request, "accountId", "0"));

            boolean success = accountService.deleteAccount(accountId);
            if (success) {
                request.getSession().setAttribute("success", "Account and associated customer data completely deleted successfully!");
            } else {
                request.getSession().setAttribute("error", "Failed to delete the account.");
            }
        } catch (Exception e) {
            logger.error("Error deleting account in servlet", e);
            request.getSession().setAttribute("error", "Error: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/account?action=list");
    }

    /**
     * Generate unique 12-digit Indian Banking Account Number format
     */
    private String generateIndianAccountNumber() {
        java.security.SecureRandom random = new java.security.SecureRandom();
        long nextNum = 10000000L + random.nextInt(90000000);
        return "1000" + nextNum;
    }

    /**
     * Helper to process profile avatar uploads for new primary, joint, or partner signatories
     */
    private void saveAndSetCustomerAvatar(HttpServletRequest request, long customerId, Part filePart, Connection conn) {
        if (filePart == null || filePart.getSize() == 0) {
            return;
        }
        
        try {
            String contentType = filePart.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) {
                return; // Only allow images
            }

            String uploadPath = request.getServletContext().getRealPath("/assest/img/avatars/");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // Get original file extension safely to prevent directory/path traversal (e.g. filename traversal)
            String originalName = getSubmittedFileName(filePart);
            if (originalName == null) {
                originalName = "avatar.png";
            }
            
            // Extract leaf name only, removing any directory components or path traversal sequences
            originalName = new File(originalName).getName();
            
            String ext = "png";
            if (originalName.contains(".")) {
                String potentialExt = originalName.substring(originalName.lastIndexOf(".") + 1).toLowerCase().trim();
                // Strict alphanumeric whitelisting to only allow safe image extensions, preventing traversal or malicious file execution
                if (potentialExt.matches("^[a-zA-Z0-9]+$") && 
                    (potentialExt.equals("png") || potentialExt.equals("jpg") || potentialExt.equals("jpeg") || potentialExt.equals("gif"))) {
                    ext = potentialExt;
                }
            }

            String fileName = "avatar_" + customerId + "_" + System.currentTimeMillis() + "." + ext;
            String filePath = uploadPath + File.separator + fileName;
            
            // Save file
            filePart.write(filePath);
            
            // Update in DB using transaction connection
            String relativePath = "/assest/img/avatars/" + fileName;
            String updateSql = "UPDATE customer SET avatar_path = ? WHERE customer_id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(updateSql)) {
                stmt.setString(1, relativePath);
                stmt.setLong(2, customerId);
                stmt.executeUpdate();
            }
            logger.info("Avatar successfully uploaded and set for customer ID: {}", customerId);

        } catch (Exception e) {
            logger.error("Failed to save and set customer avatar for ID " + customerId, e);
        }
    }

    private String getSubmittedFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "default.png";
    }
}
