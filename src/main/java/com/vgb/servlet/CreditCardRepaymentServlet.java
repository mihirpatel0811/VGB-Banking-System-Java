package com.vgb.servlet;

import com.vgb.constants.AppConstants;
import com.vgb.dao.CreditCardRepaymentDAO;
import com.vgb.model.Account;
import com.vgb.model.Card;
import com.vgb.model.CreditCardRepayment;
import com.vgb.service.AccountService;
import com.vgb.service.CardService;
import com.vgb.util.AccountContextUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet(name = "CreditCardRepaymentServlet", value = "/card-repayment")
public class CreditCardRepaymentServlet extends BaseServlet {
    private CardService cardService = new CardService();
    private AccountService accountService = new AccountService();
    private CreditCardRepaymentDAO repaymentDAO = new CreditCardRepaymentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = getParameter(request, "action", "history");
        
        HttpSession session = request.getSession(false);
        if (session == null) {
            redirectToLogin(request, response);
            return;
        }

        Long customerId = getUserId(request);
        Integer adminId = getAdminId(request);

        try {
            if (customerId != null) {
                try {
                    com.vgb.model.Customer customer = new com.vgb.service.CustomerService().getCustomerById(customerId);
                    request.setAttribute("customer", customer);
                } catch (Exception e) {
                    logger.warn("Failed to set customer attribute in CreditCardRepaymentServlet", e);
                }
            }

            switch (action) {
                case "repay":
                    if (customerId == null) {
                        redirectToLogin(request, response);
                        return;
                    }
                    showRepaymentForm(request, response, customerId);
                    break;
                case "receipt":
                    if (customerId == null) {
                        redirectToLogin(request, response);
                        return;
                    }
                    showReceipt(request, response, customerId);
                    break;
                case "history":
                    if (customerId == null) {
                        redirectToLogin(request, response);
                        return;
                    }
                    showHistory(request, response, customerId);
                    break;
                case "adminLogs":
                    if (adminId == null) {
                        redirectToLogin(request, response);
                        return;
                    }
                    showAdminLogs(request, response);
                    break;
                case "adminExport":
                    if (adminId == null || !isAdmin(request)) {
                        response.sendError(HttpServletResponse.SC_FORBIDDEN);
                        return;
                    }
                    exportAdminLogsCsv(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/card-repayment?action=history");
            }
        } catch (Exception e) {
            logger.error("Error in CreditCardRepaymentServlet doGet", e);
            request.getSession().setAttribute("error", "An error occurred: " + e.getMessage());
            if (isAdmin(request)) {
                response.sendRedirect(request.getContextPath() + "/admin-dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/card?action=list");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = getParameter(request, "action", "");
        
        HttpSession session = request.getSession(false);
        if (session == null || getUserId(request) == null) {
            redirectToLogin(request, response);
            return;
        }

        if (!validateCSRFToken(request)) {
            session.setAttribute("error", "Security validation check failed: Invalid CSRF Token.");
            response.sendRedirect(request.getContextPath() + "/card?action=list");
            return;
        }

        try {
            if ("repay".equals(action)) {
                processRepayment(request, response, getUserId(request));
            } else {
                response.sendRedirect(request.getContextPath() + "/card?action=list");
            }
        } catch (Exception e) {
            logger.error("Error in CreditCardRepaymentServlet doPost", e);
            session.setAttribute("error", "Failed to process payment: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/card?action=list");
        }
    }

    private void showRepaymentForm(HttpServletRequest request, HttpServletResponse response, long customerId) throws Exception {
        generateCSRFToken(request);
        long cardId = Long.parseLong(getParameter(request, "cardId", "0"));
        if (cardId == 0) {
            request.getSession().setAttribute("error", "No card selected for repayment.");
            response.sendRedirect(request.getContextPath() + "/card?action=list");
            return;
        }

        Card card = cardService.getCardById(cardId);
        if (card == null || card.getCustomerId() != customerId) {
            request.getSession().setAttribute("error", "Card not found or unauthorized access.");
            response.sendRedirect(request.getContextPath() + "/card?action=list");
            return;
        }

        if (!"credit".equalsIgnoreCase(card.getCardType())) {
            request.getSession().setAttribute("error", "Selected card is not a credit card.");
            response.sendRedirect(request.getContextPath() + "/card?action=list");
            return;
        }

        // Get customer accounts (savings/current only)
        List<Account> allAccounts = accountService.getCustomerAccounts(customerId);
        Account activeAccount = AccountContextUtil.resolveActiveAccount(request.getSession(false), allAccounts);
        // Filter accounts to only include savings and current
        List<Account> activeAccounts = allAccounts.stream()
                .filter(a -> "active".equalsIgnoreCase(a.getStatus()) && 
                            ("savings".equalsIgnoreCase(a.getAccountType()) || "current".equalsIgnoreCase(a.getAccountType())))
                .filter(a -> activeAccount == null || a.getAccountId() == activeAccount.getAccountId())
                .toList();

        // Dynamically compute statement details
        LocalDate today = LocalDate.now();
        LocalDate stmtLocalDate = today.withDayOfMonth(1);
        LocalDate dueLocalDate = stmtLocalDate.plusDays(19); // 20th of the month
        LocalDate startBilling = stmtLocalDate.minusMonths(1);
        LocalDate endBilling = stmtLocalDate.minusDays(1);

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd MMM yyyy");
        DateTimeFormatter cycleFormatter = DateTimeFormatter.ofPattern("dd MMM");

        String statementDate = stmtLocalDate.format(formatter);
        String dueDate = dueLocalDate.format(formatter);
        String billingCycle = startBilling.format(cycleFormatter) + " - " + endBilling.format(cycleFormatter) + " " + endBilling.getYear();

        BigDecimal outstanding = card.getOutstandingBalance();
        BigDecimal minimumDue = outstanding.multiply(new BigDecimal("0.05")); // 5% of outstanding
        if (minimumDue.compareTo(new BigDecimal("250.00")) < 0 && outstanding.compareTo(BigDecimal.ZERO) > 0) {
            minimumDue = outstanding.compareTo(new BigDecimal("250.00")) < 0 ? outstanding : new BigDecimal("250.00");
        }
        minimumDue = minimumDue.setScale(2, RoundingMode.HALF_UP);

        BigDecimal availableLimit = card.getOnlineLimit().subtract(outstanding);
        if (availableLimit.compareTo(BigDecimal.ZERO) < 0) {
            availableLimit = BigDecimal.ZERO;
        }

        request.setAttribute("card", card);
        request.setAttribute("accounts", activeAccounts);
        request.setAttribute("activeAccount", activeAccount);
        request.setAttribute("selectedAccountId", activeAccount != null ? activeAccount.getAccountId() : 0L);
        request.setAttribute("statementDate", statementDate);
        request.setAttribute("dueDate", dueDate);
        request.setAttribute("billingCycle", billingCycle);
        request.setAttribute("minimumDue", minimumDue);
        request.setAttribute("availableLimit", availableLimit);
        request.setAttribute("subView", "repay");

        request.getRequestDispatcher("/customer/card_repay.jsp").forward(request, response);
    }

    private void processRepayment(HttpServletRequest request, HttpServletResponse response, long customerId) throws Exception {
        long cardId = Long.parseLong(getParameter(request, "cardId", "0"));
        long accountId = Long.parseLong(getParameter(request, "accountId", "0"));
        String paymentOption = getParameter(request, "paymentOption", "custom");
        
        BigDecimal amount = BigDecimal.ZERO;
        Card card = cardService.getCardById(cardId);
        if (card == null || card.getCustomerId() != customerId) {
            throw new Exception("Credit card not found.");
        }

        BigDecimal outstanding = card.getOutstandingBalance();
        BigDecimal minimumDue = outstanding.multiply(new BigDecimal("0.05"));
        if (minimumDue.compareTo(new BigDecimal("250.00")) < 0 && outstanding.compareTo(BigDecimal.ZERO) > 0) {
            minimumDue = outstanding.compareTo(new BigDecimal("250.00")) < 0 ? outstanding : new BigDecimal("250.00");
        }
        minimumDue = minimumDue.setScale(2, RoundingMode.HALF_UP);

        if ("minimum".equalsIgnoreCase(paymentOption)) {
            amount = minimumDue;
        } else if ("full".equalsIgnoreCase(paymentOption)) {
            amount = outstanding;
        } else {
            String amtStr = getParameter(request, "amount", "0");
            amount = new BigDecimal(amtStr);
        }

        // Trigger transaction
        CreditCardRepayment repayment = cardService.processCreditCardRepayment(customerId, cardId, accountId, amount, paymentOption);

        if (repayment != null) {
            request.getSession().setAttribute("success", "Credit card repayment of ₹" + amount.setScale(2) + " processed successfully!");
            response.sendRedirect(request.getContextPath() + "/card-repayment?action=receipt&reference=" + repayment.getTransactionReference());
        } else {
            throw new Exception("Failed to execute transaction due to database error.");
        }
    }

    private void showReceipt(HttpServletRequest request, HttpServletResponse response, long customerId) throws Exception {
        String reference = getParameter(request, "reference", "");
        if (reference.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/card-repayment?action=history");
            return;
        }

        CreditCardRepayment repayment = repaymentDAO.getByTransactionReference(reference);
        if (repayment == null || repayment.getCustomerId() != customerId) {
            request.getSession().setAttribute("error", "Receipt not found or unauthorized access.");
            response.sendRedirect(request.getContextPath() + "/card-repayment?action=history");
            return;
        }

        // Fetch card details for current limit details
        Card card = cardService.getCardById(repayment.getCardId());
        
        request.setAttribute("subView", "receipt");
        request.setAttribute("repayment", repayment);
        request.setAttribute("card", card);
        request.getRequestDispatcher("/customer/card_repay.jsp").forward(request, response);
    }

    private void showHistory(HttpServletRequest request, HttpServletResponse response, long customerId) throws Exception {
        int page = 1;
        try {
            page = Integer.parseInt(getParameter(request, "page", "1"));
        } catch (NumberFormatException e) {}

        int limit = AppConstants.RECORDS_PER_PAGE;
        int offset = (page - 1) * limit;

        int totalCount = repaymentDAO.countByCustomerId(customerId);
        List<CreditCardRepayment> repayments = repaymentDAO.getByCustomerId(customerId, limit, offset);

        int totalPages = (int) Math.ceil((double) totalCount / limit);

        request.setAttribute("subView", "history");
        request.setAttribute("repayments", repayments);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalCount", totalCount);

        request.getRequestDispatcher("/customer/card_repay.jsp").forward(request, response);
    }

    private void showAdminLogs(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int page = 1;
        try {
            page = Integer.parseInt(getParameter(request, "page", "1"));
        } catch (NumberFormatException e) {}

        String search = getParameter(request, "search", "");
        String status = getParameter(request, "status", "all");
        String startDate = getParameter(request, "startDate", "");
        String endDate = getParameter(request, "endDate", "");

        int limit = AppConstants.RECORDS_PER_PAGE;
        int offset = (page - 1) * limit;

        int totalCount = repaymentDAO.countAllRepayments(search, status, startDate, endDate);
        List<CreditCardRepayment> repayments = repaymentDAO.getAllRepayments(search, status, startDate, endDate, limit, offset);
        java.util.Map<String, Object> stats = repaymentDAO.getRepaymentStats();

        int totalPages = (int) Math.ceil((double) totalCount / limit);

        request.setAttribute("repayments", repayments);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("search", search);
        request.setAttribute("status", status);
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);
        request.setAttribute("stats", stats);

        request.getRequestDispatcher("/admin/card_repayments.jsp").forward(request, response);
    }

    private void exportAdminLogsCsv(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String search = getParameter(request, "search", "");
        String status = getParameter(request, "status", "all");
        String startDate = getParameter(request, "startDate", "");
        String endDate = getParameter(request, "endDate", "");

        // Fetch up to 1000 records for export
        List<CreditCardRepayment> list = repaymentDAO.getAllRepayments(search, status, startDate, endDate, 1000, 0);

        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=\"VGB_CreditCard_Repayments_" + LocalDate.now() + ".csv\"");

        try (PrintWriter writer = response.getWriter()) {
            // CSV Header
            writer.println("Repayment ID,Customer ID,Holder Name,Card Number,Source Account,Amount Paid,Payment Option,Txn Reference,Date & Time,Status");

            for (CreditCardRepayment r : list) {
                StringBuilder row = new StringBuilder();
                row.append(r.getRepaymentId()).append(",");
                row.append(r.getCustomerId()).append(",");
                row.append("\"").append(r.getCardHolderName() != null ? r.getCardHolderName() : "").append("\",");
                row.append(r.getMaskedCardNumber() != null ? r.getMaskedCardNumber() : "").append(",");
                row.append(r.getSourceAccountNumber() != null ? r.getSourceAccountNumber() : "").append(",");
                row.append(r.getAmountPaid().setScale(2)).append(",");
                row.append(r.getPaymentOption().toUpperCase()).append(",");
                row.append(r.getTransactionReference()).append(",");
                row.append(r.getRepaymentDate()).append(",");
                row.append(r.getStatus().toUpperCase());
                writer.println(row.toString());
            }
            writer.flush();
        }
    }
}
