package com.vgb.servlet;

import com.vgb.constants.AppConstants;
import com.vgb.model.Account;
import com.vgb.model.Card;
import com.vgb.model.Loan;
import com.vgb.model.ChequeBook;
import com.vgb.service.AccountService;
import com.vgb.service.CardService;
import com.vgb.service.LoanService;
import com.vgb.dao.ChequeBookDAOImpl;
import com.vgb.dao.AccountDAOImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonSerializer;
import com.google.gson.JsonPrimitive;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * CashCounterServlet: Administrative servlet for teller actions
 */
@WebServlet(name = "CashCounterServlet", value = {"/cash-counter", "/cash_counter"})
public class CashCounterServlet extends BaseServlet {
    private static final long serialVersionUID = 1L;

    private AccountService accountService = new AccountService();
    private LoanService loanService = new LoanService();
    private CardService cardService = new CardService();
    private ChequeBookDAOImpl chequeBookDAO = new ChequeBookDAOImpl();
    private AccountDAOImpl accountDAO = new AccountDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute(AppConstants.ADMIN_SESSION_KEY) == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = getParameter(request, "action", "");
        if ("search".equalsIgnoreCase(action)) {
            handleSearch(request, response);
            return;
        }

        // Render main cash counter page
        request.setAttribute("csrfToken", generateCSRFToken(request));
        request.getRequestDispatcher("/admin/cashcounter.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute(AppConstants.ADMIN_SESSION_KEY) == null) {
            sendErrorResponse(response, "Unauthorized administrative access.", HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        if (!validateCSRFToken(request)) {
            sendErrorResponse(response, "Invalid CSRF security token.", HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String action = getParameter(request, "action", "");
        Integer adminIdInt = getAdminId(request);
        Long adminId = adminIdInt != null ? adminIdInt.longValue() : 0L;

        try {
            switch (action.toLowerCase()) {
                case "deposit":
                    handleDeposit(request, response, adminId);
                    break;
                case "withdraw":
                    handleWithdraw(request, response, adminId);
                    break;
                case "transfer":
                    handleTransfer(request, response, adminId);
                    break;
                case "loan-payment":
                    handleLoanPayment(request, response, adminId);
                    break;
                case "card-payment":
                    handleCardPayment(request, response, adminId);
                    break;
                default:
                    sendErrorResponse(response, "Invalid counter action requested.", HttpServletResponse.SC_BAD_REQUEST);
                    break;
            }
        } catch (Exception e) {
            logger.error("Error processing counter transaction", e);
            sendErrorResponse(response, e.getMessage(), HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void handleSearch(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String query = getParameter(request, "query", "");
        if (query.trim().isEmpty()) {
            sendJsonResponse(response, "[]", HttpServletResponse.SC_OK);
            return;
        }

        try {
            List<Map<String, Object>> searchResults = searchAccounts(query);
            List<Map<String, Object>> fullResults = new ArrayList<>();

            for (Map<String, Object> accountMap : searchResults) {
                long customerId = (long) accountMap.get("customerId");
                long accountId = (long) accountMap.get("accountId");

                // Get outstanding loans
                List<Loan> customerLoans = loanService.getCustomerLoans(customerId);
                List<Loan> activeLoans = new ArrayList<>();
                for (Loan loan : customerLoans) {
                    if ("active".equalsIgnoreCase(loan.getStatus()) || "disbursed".equalsIgnoreCase(loan.getStatus())) {
                        activeLoans.add(loan);
                    }
                }

                // Get active credit cards
                List<Card> customerCards = cardService.getCustomerCards(customerId);
                List<Card> activeCards = new ArrayList<>();
                for (Card card : customerCards) {
                    if ("credit".equalsIgnoreCase(card.getCardType()) && "active".equalsIgnoreCase(card.getStatus())) {
                        activeCards.add(card);
                    }
                }

                // Get active cheque books
                List<ChequeBook> chequeBooks = chequeBookDAO.getActiveChequeBooksByAccount(accountId);

                Map<String, Object> enriched = new HashMap<>(accountMap);
                enriched.put("loans", activeLoans);
                enriched.put("cards", activeCards);
                enriched.put("chequeBooks", chequeBooks);

                fullResults.add(enriched);
            }

            Gson gson = new GsonBuilder()
                .registerTypeAdapter(LocalDate.class, (JsonSerializer<LocalDate>) (src, typeOfSrc, context) -> 
                    new JsonPrimitive(src.format(DateTimeFormatter.ISO_LOCAL_DATE)))
                .registerTypeAdapter(LocalDateTime.class, (JsonSerializer<LocalDateTime>) (src, typeOfSrc, context) -> 
                    new JsonPrimitive(src.format(DateTimeFormatter.ISO_LOCAL_DATE_TIME)))
                .create();
            String json = gson.toJson(fullResults);
            sendJsonResponse(response, json, HttpServletResponse.SC_OK);

        } catch (Exception e) {
            logger.error("Search error in cash counter", e);
            sendErrorResponse(response, "Search failed: " + e.getMessage(), HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private List<Map<String, Object>> searchAccounts(String query) throws SQLException {
        List<Map<String, Object>> results = new ArrayList<>();
        String sql = "SELECT DISTINCT a.account_id, a.account_number, a.account_type, a.balance, a.status, " +
                     "c.customer_id, c.first_name, c.last_name, c.email, c.phone_no, c.avatar_path " +
                     "FROM account a " +
                     "JOIN account_signatory sig ON a.account_id = sig.account_id " +
                     "JOIN customer c ON sig.customer_id = c.customer_id " +
                     "WHERE (a.account_number = ? " +
                     "   OR c.phone_no = ? " +
                     "   OR c.email = ? " +
                     "   OR c.pan_card = ? " +
                     "   OR c.aadhaar_card = ? " +
                     "   OR CONCAT(c.first_name, ' ', c.last_name) LIKE ?) " +
                     "  AND LOWER(a.status) != 'closed'";

        try (Connection conn = com.vgb.config.DatabaseConfig.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, query.trim());
            stmt.setString(2, query.trim());
            stmt.setString(3, query.trim());
            stmt.setString(4, query.trim());
            stmt.setString(5, query.trim());
            stmt.setString(6, "%" + query.trim() + "%");

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("accountId", rs.getLong("account_id"));
                    map.put("accountNumber", rs.getString("account_number"));
                    map.put("accountType", rs.getString("account_type"));
                    map.put("balance", rs.getBigDecimal("balance"));
                    map.put("status", rs.getString("status"));
                    map.put("customerId", rs.getLong("customer_id"));
                    map.put("firstName", rs.getString("first_name"));
                    map.put("lastName", rs.getString("last_name"));
                    map.put("email", rs.getString("email"));
                    map.put("phoneNo", rs.getString("phone_no"));
                    map.put("avatarPath", rs.getString("avatar_path"));
                    results.add(map);
                }
            }
        }
        return results;
    }

    private void handleDeposit(HttpServletRequest request, HttpServletResponse response, Long adminId) throws Exception {
        long accountId = Long.parseLong(getParameter(request, "accountId", "0"));
        BigDecimal amount = getBigDecimalParameter(request, "amount", BigDecimal.ZERO);
        String description = getParameter(request, "description", "Cash Counter Deposit");
        String method = getParameter(request, "method", "cash");

        Account targetAcc = accountService.getAccountById(accountId);
        if (targetAcc == null || !"active".equalsIgnoreCase(targetAcc.getStatus())) {
            sendErrorResponse(response, "Operational transactions (deposit) are disabled for closed or non-active accounts.", HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        boolean success = false;
        if ("cash".equalsIgnoreCase(method)) {
            success = accountService.deposit(accountId, amount, description, adminId);
        } else if ("cheque".equalsIgnoreCase(method)) {
            String chequeSource = getParameter(request, "chequeSource", "external");
            String chequeNumber = getParameter(request, "chequeNumber", "");

            if ("internal".equalsIgnoreCase(chequeSource)) {
                long fromAccountId = Long.parseLong(getParameter(request, "fromAccountId", "0"));
                String chequeBookNumber = getParameter(request, "chequeBookNumber", "");
                success = accountService.transferWithCheque(fromAccountId, accountId, chequeBookNumber, chequeNumber, amount, description, adminId);
            } else {
                String bankName = getParameter(request, "bankName", "External Bank");
                success = accountService.chequeDeposit(accountId, bankName, chequeNumber, amount, description, adminId);
            }
        }

        if (success) {
            Map<String, String> data = new HashMap<>();
            data.put("message", "Deposit completed successfully!");
            sendJsonResponse(response, data, HttpServletResponse.SC_OK);
        } else {
            sendErrorResponse(response, "Deposit transaction failed.", HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void handleWithdraw(HttpServletRequest request, HttpServletResponse response, Long adminId) throws Exception {
        long accountId = Long.parseLong(getParameter(request, "accountId", "0"));
        BigDecimal amount = getBigDecimalParameter(request, "amount", BigDecimal.ZERO);
        String description = getParameter(request, "description", "Cash Counter Withdrawal");
        String method = getParameter(request, "method", "cash");

        Account srcAcc = accountService.getAccountById(accountId);
        if (srcAcc == null || !"active".equalsIgnoreCase(srcAcc.getStatus())) {
            sendErrorResponse(response, "Operational transactions (withdrawal) are disabled for closed or non-active accounts.", HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        boolean success = false;
        if ("cash".equalsIgnoreCase(method)) {
            success = accountService.withdraw(accountId, amount, description, adminId);
        } else if ("cheque".equalsIgnoreCase(method)) {
            String chequeBookNumber = getParameter(request, "chequeBookNumber", "");
            String chequeNumber = getParameter(request, "chequeNumber", "");
            success = accountService.withdrawWithCheque(accountId, chequeBookNumber, chequeNumber, amount, description, adminId);
        }

        if (success) {
            Map<String, String> data = new HashMap<>();
            data.put("message", "Withdrawal completed successfully!");
            sendJsonResponse(response, data, HttpServletResponse.SC_OK);
        } else {
            sendErrorResponse(response, "Withdrawal transaction failed.", HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void handleTransfer(HttpServletRequest request, HttpServletResponse response, Long adminId) throws Exception {
        long fromAccountId = Long.parseLong(getParameter(request, "fromAccountId", "0"));
        BigDecimal amount = getBigDecimalParameter(request, "amount", BigDecimal.ZERO);
        String description = getParameter(request, "description", "Cash Counter Transfer");
        String method = getParameter(request, "method", "cash");
        String targetType = getParameter(request, "targetType", "internal");

        Account fromAcc = accountService.getAccountById(fromAccountId);
        if (fromAcc == null || !"active".equalsIgnoreCase(fromAcc.getStatus())) {
            sendErrorResponse(response, "Operational transactions (transfer) are disabled for closed or non-active source accounts.", HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        boolean success = false;
        String toAccountNumber = getParameter(request, "toAccountNumber", "");

        if ("internal".equalsIgnoreCase(targetType)) {
            Account targetAccount = accountDAO.getByAccountNumber(toAccountNumber);
            if (targetAccount == null) {
                throw new Exception("Destination VGB account not found.");
            }
            long toAccountId = targetAccount.getAccountId();

            if ("cash".equalsIgnoreCase(method)) {
                success = accountService.transfer(fromAccountId, toAccountId, amount, description, adminId);
            } else {
                String chequeBookNumber = getParameter(request, "chequeBookNumber", "");
                String chequeNumber = getParameter(request, "chequeNumber", "");
                success = accountService.transferWithCheque(fromAccountId, toAccountId, chequeBookNumber, chequeNumber, amount, description, adminId);
            }
        } else {
            String toIfscCode = getParameter(request, "toIfscCode", "");
            String toHolderName = getParameter(request, "toHolderName", "");
            String toBankName = getParameter(request, "toBankName", "Other Bank");
            String toBranchName = getParameter(request, "toBranchName", "External Branch");

            if ("cash".equalsIgnoreCase(method)) {
                success = accountService.externalTransfer(fromAccountId, toAccountNumber, toIfscCode, toHolderName, toBankName, toBranchName, amount, description, adminId);
            } else {
                String chequeBookNumber = getParameter(request, "chequeBookNumber", "");
                String chequeNumber = getParameter(request, "chequeNumber", "");
                success = accountService.externalTransferWithCheque(fromAccountId, toAccountNumber, toIfscCode, toHolderName, toBankName, toBranchName, chequeBookNumber, chequeNumber, amount, description, adminId);
            }
        }

        if (success) {
            Map<String, String> data = new HashMap<>();
            data.put("message", "Transfer completed successfully!");
            sendJsonResponse(response, data, HttpServletResponse.SC_OK);
        } else {
            sendErrorResponse(response, "Transfer transaction failed.", HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void handleLoanPayment(HttpServletRequest request, HttpServletResponse response, Long adminId) throws Exception {
        long loanId = Long.parseLong(getParameter(request, "loanId", "0"));
        long customerId = Long.parseLong(getParameter(request, "customerId", "0"));
        BigDecimal amount = getBigDecimalParameter(request, "amount", BigDecimal.ZERO);
        String method = getParameter(request, "method", "cash");

        boolean success = false;
        if ("cash".equalsIgnoreCase(method)) {
            success = loanService.processCashRepayment(loanId, customerId, amount, adminId);
        } else if ("account".equalsIgnoreCase(method)) {
            long accountId = Long.parseLong(getParameter(request, "accountId", "0"));
            success = loanService.processRepayment(loanId, customerId, amount, accountId);
        } else if ("cheque".equalsIgnoreCase(method)) {
            long accountId = Long.parseLong(getParameter(request, "accountId", "0"));
            String chequeBookNumber = getParameter(request, "chequeBookNumber", "");
            String chequeNumber = getParameter(request, "chequeNumber", "");
            success = loanService.processChequeRepayment(loanId, customerId, amount, accountId, chequeBookNumber, chequeNumber, adminId);
        }

        if (success) {
            Map<String, String> data = new HashMap<>();
            data.put("message", "Loan repayment processed successfully!");
            sendJsonResponse(response, data, HttpServletResponse.SC_OK);
        } else {
            sendErrorResponse(response, "Loan repayment transaction failed.", HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void handleCardPayment(HttpServletRequest request, HttpServletResponse response, Long adminId) throws Exception {
        long cardId = Long.parseLong(getParameter(request, "cardId", "0"));
        BigDecimal amount = getBigDecimalParameter(request, "amount", BigDecimal.ZERO);
        String method = getParameter(request, "method", "cash");

        boolean success = false;
        if ("cash".equalsIgnoreCase(method)) {
            success = cardService.payCreditCardDuesWithCash(cardId, amount, adminId);
        } else if ("account".equalsIgnoreCase(method)) {
            long accountId = Long.parseLong(getParameter(request, "accountId", "0"));
            success = cardService.payCreditCardDues(cardId, accountId, amount);
        } else if ("cheque".equalsIgnoreCase(method)) {
            long accountId = Long.parseLong(getParameter(request, "accountId", "0"));
            String chequeBookNumber = getParameter(request, "chequeBookNumber", "");
            String chequeNumber = getParameter(request, "chequeNumber", "");
            success = cardService.payCreditCardDuesWithCheque(cardId, accountId, chequeBookNumber, chequeNumber, amount, adminId);
        }

        if (success) {
            Map<String, String> data = new HashMap<>();
            data.put("message", "Card bill payment completed successfully!");
            sendJsonResponse(response, data, HttpServletResponse.SC_OK);
        } else {
            sendErrorResponse(response, "Card dues payment transaction failed.", HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
