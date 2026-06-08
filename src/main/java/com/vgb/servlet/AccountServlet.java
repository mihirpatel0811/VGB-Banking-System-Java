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
                case "update":
                    updateAccount(request, response);
                    break;
                case "createProcess":
                    createAccount(request, response);
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


            // Load administrative statistics for the metrics dashboard
            loadAdminStatistics(request);

            // Fetch list of registered customers to select as joint signatory
            try {
                request.setAttribute("customers", new com.vgb.service.CustomerService().getAllCustomers());
            } catch (Exception e) {
                logger.error("Failed to load customer directory in listAccounts", e);
            }

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

                    // Log transaction in ledger
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
        generateCSRFToken(request);
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

            // Load administrative statistics for the metrics dashboard
            loadAdminStatistics(request);

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

    private void loadAdminStatistics(HttpServletRequest request) {
        int totalCustomers = 0;
        int savingsSingleCustomers = 0;
        int savingsJointCustomers = 0;
        int currentCustomers = 0;
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseConfig.getInstance().getConnection();
            
            // 1. Total Customers
            String sql1 = "SELECT COUNT(*) FROM customer";
            stmt = conn.prepareStatement(sql1);
            rs = stmt.executeQuery();
            if (rs.next()) {
                totalCustomers = rs.getInt(1);
            }
            rs.close();
            stmt.close();
            
            // 2. Saving Account (Single User) Customers
            String sql2 = "SELECT COUNT(DISTINCT customer_id) FROM account_signatory WHERE account_id IN (SELECT account_id FROM account_savings WHERE holding_type = 'single')";
            stmt = conn.prepareStatement(sql2);
            rs = stmt.executeQuery();
            if (rs.next()) {
                savingsSingleCustomers = rs.getInt(1);
            }
            rs.close();
            stmt.close();
            
            // 3. Saving Account (Joining User) Customers
            String sql3 = "SELECT COUNT(DISTINCT customer_id) FROM account_signatory WHERE account_id IN (SELECT account_id FROM account_savings WHERE holding_type = 'joint')";
            stmt = conn.prepareStatement(sql3);
            rs = stmt.executeQuery();
            if (rs.next()) {
                savingsJointCustomers = rs.getInt(1);
            }
            rs.close();
            stmt.close();
            
            // 4. Current Account Customers
            String sql4 = "SELECT COUNT(DISTINCT customer_id) FROM account_signatory WHERE account_id IN (SELECT account_id FROM account_current)";
            stmt = conn.prepareStatement(sql4);
            rs = stmt.executeQuery();
            if (rs.next()) {
                currentCustomers = rs.getInt(1);
            }
        } catch (Exception e) {
            logger.error("Failed to load admin statistics", e);
        } finally {
            DatabaseConfig.closeResources(rs, stmt, conn);
        }
        
        request.setAttribute("totalCustomers", totalCustomers);
        request.setAttribute("savingsSingleCustomers", savingsSingleCustomers);
        request.setAttribute("savingsJointCustomers", savingsJointCustomers);
        request.setAttribute("currentCustomers", currentCustomers);
    }

    private void createAccount(HttpServletRequest request, HttpServletResponse response) throws Exception {
        if (getAdminId(request) == null) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Unauthorized Access");
            return;
        }

        if (!validateCSRFToken(request)) {
            request.getSession().setAttribute("error", "Failed security check: Invalid CSRF token");
            response.sendRedirect(request.getContextPath() + "/account?action=list");
            return;
        }

        Connection conn = null;
        try {
            conn = DatabaseConfig.getInstance().getConnection();
            conn.setAutoCommit(false);

            createCustomerAndAccountProcess(request, conn);

            conn.commit();
            request.getSession().setAttribute("success", "Account and customer signatories ledger successfully created!");
        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (Exception ex) {}
            }
            logger.error("Failed to process account onboarding counter transaction", e);
            request.getSession().setAttribute("error", "Onboarding Counter Failed: " + e.getMessage());
        } finally {
            if (conn != null) {
                try { conn.close(); } catch (Exception e) {}
            }
        }
        response.sendRedirect(request.getContextPath() + "/account?action=list");
    }

    private void createCustomerAndAccountProcess(HttpServletRequest request, Connection conn) throws Exception {
        // Read account type info
        String accountType = getParameter(request, "accountType", "savings").toLowerCase();
        String holdingType = getParameter(request, "holdingType", "single").toLowerCase();
        String ifscCode = getParameter(request, "ifscCode", "VGBK0000001").trim();

        // 1. Primary signatory parameters
        String firstName = getParameter(request, "firstName", "").trim();
        String middleName = getParameter(request, "middleName", "").trim();
        String lastName = getParameter(request, "lastName", "").trim();
        String dob = getParameter(request, "dob", "").trim();
        String gender = getParameter(request, "gender", "").trim();
        String maritalStatus = getParameter(request, "maritalStatus", "").trim();
        String fatherName = getParameter(request, "fatherName", "").trim();
        String motherName = getParameter(request, "motherName", "").trim();
        String email = getParameter(request, "email", "").trim();
        String phoneNo = getParameter(request, "phoneNo", "").trim();
        String altPhoneNo = getParameter(request, "altPhoneNo", "").trim();
        String address = getParameter(request, "address", "").trim();
        String permAddress = getParameter(request, "permAddress", "").trim();
        if (permAddress.isEmpty()) {
            permAddress = address;
        }
        String city = getParameter(request, "city", "").trim();
        String state = getParameter(request, "state", "").trim();
        String zipCode = getParameter(request, "zipCode", "").trim();
        String occupation = getParameter(request, "occupation", "").trim();
        String annualIncomeStr = getParameter(request, "annualIncome", "0.00").trim();
        BigDecimal annualIncome = new BigDecimal(annualIncomeStr.isEmpty() ? "0.00" : annualIncomeStr);
        String panCard = getParameter(request, "panCard", "").trim();
        String aadhaarCard = getParameter(request, "aadhaarCard", "").trim();
        
        String username = getParameter(request, "username", "").trim();
        String password = getParameter(request, "password", "").trim();
        String pin = getParameter(request, "pin", "").trim();

        // Validations
        if (firstName.isEmpty() || lastName.isEmpty() || email.isEmpty() || phoneNo.isEmpty() || address.isEmpty() || city.isEmpty() || state.isEmpty() || zipCode.isEmpty() || username.isEmpty() || password.isEmpty() || pin.isEmpty()) {
            throw new Exception("All primary personal, login, and security fields marked with * are required.");
        }

        if (dob.isEmpty()) {
            throw new Exception("Date of Birth is required.");
        }
        try {
            java.time.LocalDate dobLocalDate = java.time.LocalDate.parse(dob);
            java.time.LocalDate today = java.time.LocalDate.now();
            int age = java.time.Period.between(dobLocalDate, today).getYears();
            if (age < 8) {
                throw new Exception("Customer is below 8 years of age. An account cannot be opened.");
            }
        } catch (java.time.format.DateTimeParseException e) {
            throw new Exception("Invalid Date of Birth format. Please select a valid date.");
        }

        // Validate Username uniqueness
        String checkUserSql = "SELECT COUNT(*) FROM customer WHERE username = ?";
        try (PreparedStatement stmt = conn.prepareStatement(checkUserSql)) {
            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    throw new Exception("Username '" + username + "' is already taken. Please choose another login username.");
                }
            }
        }

        // Validate Email uniqueness
        String checkEmailSql = "SELECT COUNT(*) FROM customer WHERE email = ?";
        try (PreparedStatement stmt = conn.prepareStatement(checkEmailSql)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    throw new Exception("Email '" + email + "' is already registered to another signatory profile.");
                }
            }
        }

        // Validate Phone uniqueness
        String checkPhoneSql = "SELECT COUNT(*) FROM customer WHERE phone_no = ?";
        try (PreparedStatement stmt = conn.prepareStatement(checkPhoneSql)) {
            stmt.setString(1, phoneNo);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    throw new Exception("Phone number '" + phoneNo + "' is already associated with another signatory profile.");
                }
            }
        }

        // Validate Initial Deposit minimums
        BigDecimal initialDeposit = new BigDecimal(getParameter(request, "initialDeposit", "0.00"));
        BigDecimal minDeposit = BigDecimal.ZERO;
        if ("current".equalsIgnoreCase(accountType)) {
            minDeposit = new BigDecimal("1500.00");
        } else if ("savings".equalsIgnoreCase(accountType)) {
            if ("joint".equalsIgnoreCase(holdingType)) {
                minDeposit = new BigDecimal("1000.00");
            } else {
                minDeposit = new BigDecimal("500.00");
            }
        }
        if (initialDeposit.compareTo(minDeposit) < 0) {
            throw new Exception("Initial deposit cannot be less than ₹" + minDeposit.setScale(2) + " for " + accountType + " account.");
        }

        // A. Insert Primary Customer
        long primaryCustomerId = 0;
        String insertCustSql = "INSERT INTO customer (first_name, middle_name, last_name, dob, gender, marital_status, father_name, mother_name, email, phone_no, alt_phone_no, address, perm_address, city, state, zip_code, occupation, annual_income, pan_card, aadhaar_card, username, password, pin, status) " +
                               "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'active')";
        
        try (PreparedStatement stmtCust = conn.prepareStatement(insertCustSql, Statement.RETURN_GENERATED_KEYS)) {
            stmtCust.setString(1, firstName);
            stmtCust.setString(2, middleName);
            stmtCust.setString(3, lastName);
            if (dob.isEmpty()) {
                stmtCust.setNull(4, java.sql.Types.DATE);
            } else {
                stmtCust.setDate(4, java.sql.Date.valueOf(dob));
            }
            stmtCust.setString(5, gender);
            stmtCust.setString(6, maritalStatus);
            stmtCust.setString(7, fatherName);
            stmtCust.setString(8, motherName);
            stmtCust.setString(9, email);
            stmtCust.setString(10, phoneNo);
            stmtCust.setString(11, altPhoneNo);
            stmtCust.setString(12, address);
            stmtCust.setString(13, permAddress);
            stmtCust.setString(14, city);
            stmtCust.setString(15, state);
            stmtCust.setString(16, zipCode);
            stmtCust.setString(17, occupation);
            stmtCust.setBigDecimal(18, annualIncome);
            stmtCust.setString(19, panCard);
            stmtCust.setString(20, aadhaarCard);
            stmtCust.setString(21, username);
            stmtCust.setString(22, password);
            stmtCust.setString(23, pin);
            
            stmtCust.executeUpdate();
            try (ResultSet rsKeys = stmtCust.getGeneratedKeys()) {
                if (rsKeys.next()) {
                    primaryCustomerId = rsKeys.getLong(1);
                }
            }
        }

        if (primaryCustomerId == 0) {
            throw new Exception("Failed to register primary customer profile in database.");
        }

        // B. Upload Primary Customer Avatar
        try {
            Part primaryAvatarPart = request.getPart("primaryAvatarFile");
            saveAndSetCustomerAvatar(request, primaryCustomerId, primaryAvatarPart, conn);
        } catch (Exception e) {
            logger.error("Failed to parse primary avatar file part", e);
        }

        // C. Generate unique 12-digit Indian Account Number
        String accountNumber = "";
        boolean isUnique = false;
        String checkAccSql = "SELECT COUNT(*) FROM account WHERE account_number = ?";
        while (!isUnique) {
            accountNumber = generateIndianAccountNumber();
            try (PreparedStatement stmtAcc = conn.prepareStatement(checkAccSql)) {
                stmtAcc.setString(1, accountNumber);
                try (ResultSet rs = stmtAcc.executeQuery()) {
                    if (rs.next() && rs.getInt(1) == 0) {
                        isUnique = true;
                    }
                }
            }
        }

        // D. Insert parent account ledger
        long accountId = 0;
        boolean hasAtm = "1".equals(getParameter(request, "hasAtmCard", "0"));
        boolean hasCheque = "1".equals(getParameter(request, "hasChequeBook", "0"));
        boolean hasPassbook = "savings".equalsIgnoreCase(accountType);
        
        String insertAccSql = "INSERT INTO account (account_type, balance, ifsc_code, account_number, status, has_atm_card, has_cheque_book, has_passbook) " +
                              "VALUES (?, ?, ?, ?, 'active', ?, ?, ?)";
        try (PreparedStatement stmtAcc = conn.prepareStatement(insertAccSql, Statement.RETURN_GENERATED_KEYS)) {
            stmtAcc.setString(1, accountType);
            stmtAcc.setBigDecimal(2, initialDeposit);
            stmtAcc.setString(3, ifscCode);
            stmtAcc.setString(4, accountNumber);
            stmtAcc.setInt(5, hasAtm ? 1 : 0);
            stmtAcc.setInt(6, hasCheque ? 1 : 0);
            stmtAcc.setInt(7, hasPassbook ? 1 : 0);
            
            stmtAcc.executeUpdate();
            try (ResultSet rsKeys = stmtAcc.getGeneratedKeys()) {
                if (rsKeys.next()) {
                    accountId = rsKeys.getLong(1);
                }
            }
        }

        if (accountId == 0) {
            throw new Exception("Failed to open parent account ledger in database.");
        }

        // E. Map Primary signatory to the account
        String insertSignSql = "INSERT INTO account_signatory (account_id, customer_id, ownership_type) VALUES (?, ?, 'primary')";
        try (PreparedStatement stmtSign = conn.prepareStatement(insertSignSql)) {
            stmtSign.setLong(1, accountId);
            stmtSign.setLong(2, primaryCustomerId);
            stmtSign.executeUpdate();
        }

        // F. Handle Savings specifics
        if ("savings".equalsIgnoreCase(accountType)) {
            String nomineeName = getParameter(request, "nomineeName", "").trim();
            String limitStr = getParameter(request, "dailyWithdrawalLimit", "50000.00").trim();
            BigDecimal dailyLimit = new BigDecimal(limitStr.isEmpty() ? "50000.00" : limitStr);
            
            String insertSavingsSql = "INSERT INTO account_savings (account_id, nominee_name, holding_type, daily_withdrawal_limit) VALUES (?, ?, ?, ?)";
            try (PreparedStatement stmtSav = conn.prepareStatement(insertSavingsSql)) {
                stmtSav.setLong(1, accountId);
                stmtSav.setString(2, nomineeName);
                stmtSav.setString(3, holdingType);
                stmtSav.setBigDecimal(4, dailyLimit);
                stmtSav.executeUpdate();
            }

            // G. Handle Joint Signatory (Savings Joint only)
            if ("joint".equalsIgnoreCase(holdingType)) {
                String jointCustomerMode = getParameter(request, "jointCustomerMode", "existing");
                long jointCustomerId = 0;

                if ("existing".equalsIgnoreCase(jointCustomerMode)) {
                    String jointCustomerIdStr = getParameter(request, "jointCustomerId", "0");
                    jointCustomerId = Long.parseLong(jointCustomerIdStr.isEmpty() ? "0" : jointCustomerIdStr);
                    if (jointCustomerId == 0) {
                        throw new Exception("Existing customer ID is required for joint holding link.");
                    }
                } else {
                    // New joint customer registration
                    String jFirst = getParameter(request, "jointFirstName", "").trim();
                    String jLast = getParameter(request, "jointLastName", "").trim();
                    String jEmail = getParameter(request, "jointEmail", "").trim();
                    String jPhone = getParameter(request, "jointPhone", "").trim();
                    String jAddress = getParameter(request, "jointAddress", "").trim();
                    String jCity = getParameter(request, "jointCity", "").trim();
                    String jState = getParameter(request, "jointState", "").trim();
                    String jZip = getParameter(request, "jointZipCode", "").trim();
                    String jPan = getParameter(request, "jointPan", "").trim();
                    String jAadhaar = getParameter(request, "jointAadhaar", "").trim();

                    if (jFirst.isEmpty() || jLast.isEmpty() || jEmail.isEmpty() || jPhone.isEmpty() || jAddress.isEmpty() || jCity.isEmpty() || jState.isEmpty() || jZip.isEmpty() || jPan.isEmpty() || jAadhaar.isEmpty()) {
                        throw new Exception("All joint holder demographic fields are required.");
                    }

                    // Auto-generate credentials for joint customer
                    String jPin = String.format("%04d", new java.security.SecureRandom().nextInt(10000));
                    String jUsername = (jFirst.toLowerCase() + "_" + jLast.toLowerCase() + "_" + (System.currentTimeMillis() % 1000)).replaceAll("\\s+", "");
                    String jPassword = "Vgb@" + jPin + "@" + (System.currentTimeMillis() % 1000);

                    // Insert Joint Customer
                    String insertJointSql = "INSERT INTO customer (first_name, last_name, email, phone_no, address, perm_address, city, state, zip_code, pan_card, aadhaar_card, username, password, pin, status) " +
                                            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'active')";
                    try (PreparedStatement stmtJoint = conn.prepareStatement(insertJointSql, Statement.RETURN_GENERATED_KEYS)) {
                        stmtJoint.setString(1, jFirst);
                        stmtJoint.setString(2, jLast);
                        stmtJoint.setString(3, jEmail);
                        stmtJoint.setString(4, jPhone);
                        stmtJoint.setString(5, jAddress);
                        stmtJoint.setString(6, jAddress);
                        stmtJoint.setString(7, jCity);
                        stmtJoint.setString(8, jState);
                        stmtJoint.setString(9, jZip);
                        stmtJoint.setString(10, jPan);
                        stmtJoint.setString(11, jAadhaar);
                        stmtJoint.setString(12, jUsername);
                        stmtJoint.setString(13, jPassword);
                        stmtJoint.setString(14, jPin);
                        
                        stmtJoint.executeUpdate();
                        try (ResultSet rsKeys = stmtJoint.getGeneratedKeys()) {
                            if (rsKeys.next()) {
                                jointCustomerId = rsKeys.getLong(1);
                            }
                        }
                    }

                    if (jointCustomerId == 0) {
                        throw new Exception("Failed to register joint holder customer profile.");
                    }

                    // Upload joint avatar
                    try {
                        Part jAvatarPart = request.getPart("jointAvatarFile");
                        saveAndSetCustomerAvatar(request, jointCustomerId, jAvatarPart, conn);
                    } catch (Exception e) {
                        logger.error("Failed to parse joint avatar file part", e);
                    }

                    // Save credentials info to session for display
                    java.util.List<String> autoCreated = new java.util.ArrayList<>();
                    autoCreated.add(jFirst + " " + jLast + " (Username: " + jUsername + ", Password: " + jPassword + ", PIN: " + jPin + ")");
                    request.getSession().setAttribute("autoCreatedPartners", autoCreated);
                }

                // Map joint signatory to the account
                String mapSignSql = "INSERT INTO account_signatory (account_id, customer_id, ownership_type) VALUES (?, ?, 'joint_holder')";
                try (PreparedStatement stmtMap = conn.prepareStatement(mapSignSql)) {
                    stmtMap.setLong(1, accountId);
                    stmtMap.setLong(2, jointCustomerId);
                    stmtMap.executeUpdate();
                }
            }
        }
        // H. Handle Current Account specifics
        else if ("current".equalsIgnoreCase(accountType)) {
            String businessName = getParameter(request, "businessName", "").trim();
            String gstin = getParameter(request, "gstin", "").trim();
            String odLimitStr = getParameter(request, "overdraftLimit", "100000.00").trim();
            BigDecimal overdraftLimit = new BigDecimal(odLimitStr.isEmpty() ? "100000.00" : odLimitStr);
            String category = getParameter(request, "companyCategory", "").trim();
            String companyPhone = getParameter(request, "companyPhone", "").trim();
            String companyEmail = getParameter(request, "companyEmail", "").trim();
            String companyAddress = getParameter(request, "companyAddress", "").trim();
            String companyPan = getParameter(request, "companyPan", "").trim();
            String companyAadhaar = getParameter(request, "companyAadhaar", "").trim();

            if (businessName.isEmpty() || gstin.isEmpty()) {
                throw new Exception("Business Name and GSTIN ID are required for Corporate Current Account.");
            }

            // Insert Corporate Details
            String insertCurrentSql = "INSERT INTO account_current (account_id, business_name, gstin, overdraft_limit, company_category, company_phone, company_email, company_address, company_pan, company_aadhaar) " +
                                      "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement stmtCur = conn.prepareStatement(insertCurrentSql)) {
                stmtCur.setLong(1, accountId);
                stmtCur.setString(2, businessName);
                stmtCur.setString(3, gstin);
                stmtCur.setBigDecimal(4, overdraftLimit);
                stmtCur.setString(5, category);
                stmtCur.setString(6, companyPhone);
                stmtCur.setString(7, companyEmail);
                stmtCur.setString(8, companyAddress);
                stmtCur.setString(9, companyPan);
                stmtCur.setString(10, companyAadhaar);
                stmtCur.executeUpdate();
            }

            // Register dynamic partners if provided
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
                    logger.error("Failed to parse partner avatar parts", e);
                }

                java.util.List<String> autoCreated = new java.util.ArrayList<>();

                for (int i = 0; i < pFirstNames.length; i++) {
                    String pFirst = pFirstNames[i].trim();
                    String pLast = pLastNames[i].trim();
                    String pEmail = pEmails[i].trim();
                    String pPhone = pPhones[i].trim();
                    String pPan = pPans[i].trim();
                    String pAadhaar = pAadhaars[i].trim();

                    if (pFirst.isEmpty() || pLast.isEmpty() || pEmail.isEmpty() || pPhone.isEmpty() || pPan.isEmpty() || pAadhaar.isEmpty()) {
                        continue;
                    }

                    // Auto-generate credentials for partners
                    String pPin = String.format("%04d", new java.security.SecureRandom().nextInt(10000));
                    String pUsername = (pFirst.toLowerCase() + "_" + pLast.toLowerCase() + "_" + (System.currentTimeMillis() % 1000) + "_" + i).replaceAll("\\s+", "");
                    String pPassword = "Vgb@" + pPin + "@" + (System.currentTimeMillis() % 1000);

                    // Insert partner as customer
                    long partnerCustId = 0;
                    String insertPartnerSql = "INSERT INTO customer (first_name, last_name, email, phone_no, address, perm_address, city, state, zip_code, pan_card, aadhaar_card, username, password, pin, status) " +
                                              "VALUES (?, ?, ?, ?, ?, ?, 'BusinessHQ', 'BusinessHQ', '999999', ?, ?, ?, ?, ?, 'active')";
                    try (PreparedStatement stmtPart = conn.prepareStatement(insertPartnerSql, Statement.RETURN_GENERATED_KEYS)) {
                        stmtPart.setString(1, pFirst);
                        stmtPart.setString(2, pLast);
                        stmtPart.setString(3, pEmail);
                        stmtPart.setString(4, pPhone);
                        stmtPart.setString(5, companyAddress.isEmpty() ? address : companyAddress);
                        stmtPart.setString(6, companyAddress.isEmpty() ? address : companyAddress);
                        stmtPart.setString(7, pPan);
                        stmtPart.setString(8, pAadhaar);
                        stmtPart.setString(9, pUsername);
                        stmtPart.setString(10, pPassword);
                        stmtPart.setString(11, pPin);
                        
                        stmtPart.executeUpdate();
                        try (ResultSet rsKeys = stmtPart.getGeneratedKeys()) {
                            if (rsKeys.next()) {
                                partnerCustId = rsKeys.getLong(1);
                            }
                        }
                    }

                    if (partnerCustId > 0) {
                        // Map partner as joint holder signatory
                        String mapSignSql = "INSERT INTO account_signatory (account_id, customer_id, ownership_type) VALUES (?, ?, 'joint_holder')";
                        try (PreparedStatement stmtMap = conn.prepareStatement(mapSignSql)) {
                            stmtMap.setLong(1, accountId);
                            stmtMap.setLong(2, partnerCustId);
                            stmtMap.executeUpdate();
                        }

                        // Upload avatar if exists in list
                        if (i < partnerAvatarParts.size()) {
                            saveAndSetCustomerAvatar(request, partnerCustId, partnerAvatarParts.get(i), conn);
                        }

                        autoCreated.add(pFirst + " " + pLast + " (Username: " + pUsername + ", Password: " + pPassword + ", PIN: " + pPin + ")");
                    }
                }
                
                if (!autoCreated.isEmpty()) {
                    request.getSession().setAttribute("autoCreatedPartners", autoCreated);
                }
            }
        }

        // I. Record Initial Funding Ledger Deposit Transaction
        String refNo = "TXN" + System.currentTimeMillis() + String.format("%04d", new java.security.SecureRandom().nextInt(10000));
        String insertTxnSql = "INSERT INTO transaction (from_account_id, to_account_id, transaction_type, amount, reference_number, description, status) " +
                              "VALUES (NULL, ?, 'deposit', ?, ?, 'Initial Onboarding Counter Deposit', 'completed')";
        try (PreparedStatement stmtTx = conn.prepareStatement(insertTxnSql)) {
            stmtTx.setLong(1, accountId);
            stmtTx.setBigDecimal(2, initialDeposit);
            stmtTx.setString(3, refNo);
            stmtTx.executeUpdate();
        }

        // J. Register Card Request if Opted
        if (hasAtm) {
            String cardType = getParameter(request, "wizardCardType", "debit").toLowerCase();
            String cardProvider = getParameter(request, "wizardCardProvider", "visa").toLowerCase();
            
            java.security.SecureRandom r = new java.security.SecureRandom();
            String cNumber = "4589 " + String.format("%04d", r.nextInt(10000)) + " " + String.format("%04d", r.nextInt(10000)) + " " + String.format("%04d", r.nextInt(10000));
            String cvv = String.format("%03d", r.nextInt(1000));
            
            java.sql.Date expDate = java.sql.Date.valueOf(java.time.LocalDate.now().plusYears(5));
            BigDecimal cardFee = new BigDecimal("150.00");
            
            String insertCardSql = "INSERT INTO card (account_id, customer_id, card_number, card_type, card_provider, card_holder_name, cvv, expiry_date, status, daily_limit, card_fee, is_fee_paid) " +
                                   "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'pending', 50000.00, ?, 0)";
            try (PreparedStatement stmtCard = conn.prepareStatement(insertCardSql)) {
                stmtCard.setLong(1, accountId);
                stmtCard.setLong(2, primaryCustomerId);
                stmtCard.setString(3, cNumber);
                stmtCard.setString(4, cardType);
                stmtCard.setString(5, cardProvider);
                stmtCard.setString(6, firstName + " " + lastName);
                stmtCard.setString(7, cvv);
                stmtCard.setDate(8, expDate);
                stmtCard.setBigDecimal(9, cardFee);
                stmtCard.executeUpdate();
            }
        }

        // K. Register Cheque Book Request if Opted
        if (hasCheque) {
            String insertChequeSql = "INSERT INTO cheque_book_request (account_id, customer_id, leaves_count, status, charges, is_charges_paid) " +
                                     "VALUES (?, ?, 50, 'pending', 150.00, 0)";
            try (PreparedStatement stmtChq = conn.prepareStatement(insertChequeSql)) {
                stmtChq.setLong(1, accountId);
                stmtChq.setLong(2, primaryCustomerId);
                stmtChq.executeUpdate();
            }
        }

        // L. Register Passbook Request if Opted
        if (hasPassbook) {
            String insertPassbookSql = "INSERT INTO passbook_request (account_id, customer_id, request_type, status, charges, is_charges_paid) " +
                                       "VALUES (?, ?, 'new', 'pending', 100.00, 0)";
            try (PreparedStatement stmtPass = conn.prepareStatement(insertPassbookSql)) {
                stmtPass.setLong(1, accountId);
                stmtPass.setLong(2, primaryCustomerId);
                stmtPass.executeUpdate();
            }
        }
    }

    private String generateIndianAccountNumber() {
        java.security.SecureRandom random = new java.security.SecureRandom();
        long nextNum = 10000000L + random.nextInt(90000000);
        return "1000" + nextNum;
    }

    private void saveAndSetCustomerAvatar(HttpServletRequest request, long customerId, Part filePart, Connection conn) {
        if (filePart == null || filePart.getSize() == 0) {
            return;
        }
        
        try {
            String contentType = filePart.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) {
                return;
            }

            String uploadPath = request.getServletContext().getRealPath("/assest/img/avatars/");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            String originalName = getSubmittedFileName(filePart);
            if (originalName == null) {
                originalName = "avatar.png";
            }
            
            originalName = new File(originalName).getName();
            
            String ext = "png";
            if (originalName.contains(".")) {
                String potentialExt = originalName.substring(originalName.lastIndexOf(".") + 1).toLowerCase().trim();
                if (potentialExt.matches("^[a-zA-Z0-9]+$") && 
                    (potentialExt.equals("png") || potentialExt.equals("jpg") || potentialExt.equals("jpeg") || potentialExt.equals("gif"))) {
                    ext = potentialExt;
                }
            }

            String fileName = "avatar_" + customerId + "_" + System.currentTimeMillis() + "." + ext;
            String filePath = uploadPath + File.separator + fileName;
            
            filePart.write(filePath);
            
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
