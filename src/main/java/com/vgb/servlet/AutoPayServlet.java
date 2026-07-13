package com.vgb.servlet;

import com.vgb.constants.AppConstants;
import com.vgb.dao.NotificationDAO;
import com.vgb.model.Account;
import com.vgb.model.Card;
import com.vgb.model.Loan;
import com.vgb.model.AutoPayInstruction;
import com.vgb.model.AutoPayHistory;
import com.vgb.model.Notification;
import com.vgb.service.AccountService;
import com.vgb.service.CardService;
import com.vgb.service.LoanService;
import com.vgb.service.AutoPayService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.util.List;

@WebServlet(name = "AutoPayServlet", value = "/auto-pay")
public class AutoPayServlet extends BaseServlet {
    private static final long serialVersionUID = 1L;

    private final AutoPayService autoPayService = new AutoPayService();
    private final AccountService accountService = new AccountService();
    private final CardService cardService = new CardService();
    private final LoanService loanService = new LoanService();
    private final NotificationDAO notificationDAO = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = getParameter(request, "action", "dashboard");

        // Transfer session messages
        HttpSession session = request.getSession(false);
        if (session != null) {
            if (session.getAttribute("error") != null) {
                request.setAttribute("error", session.getAttribute("error"));
                session.removeAttribute("error");
            }
            if (session.getAttribute("success") != null) {
                request.setAttribute("success", session.getAttribute("success"));
                session.removeAttribute("success");
            }
        }

        try {
            Long customerId = getUserId(request);
            Integer adminId = getAdminId(request);

            if (customerId != null) {
                // Customer-facing actions
                if ("dashboard".equals(action)) {
                    showCustomerDashboard(request, response, customerId);
                } else if ("pause".equals(action)) {
                    handleToggleStatus(request, response, customerId, "paused");
                } else if ("resume".equals(action)) {
                    handleToggleStatus(request, response, customerId, "active");
                } else if ("cancel".equals(action)) {
                    handleCancel(request, response, customerId);
                } else if ("markRead".equals(action)) {
                    handleMarkNotificationsRead(request, response, customerId);
                } else {
                    response.sendRedirect(request.getContextPath() + "/customer-dashboard");
                }
            } else if (adminId != null) {
                // Admin-facing actions
                if ("adminDashboard".equals(action)) {
                    showAdminDashboard(request, response);
                } else if ("adminTriggerProcessor".equals(action)) {
                    handleAdminTrigger(request, response);
                } else if ("adminReport".equals(action)) {
                    handleAdminReport(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin-dashboard");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/login");
            }
        } catch (Exception e) {
            logger.error("Error in AutoPayServlet doGet", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = getParameter(request, "action", "create");

        try {
            Long customerId = getUserId(request);
            if (customerId == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            if (!validateCSRFToken(request)) {
                request.getSession().setAttribute("error", "CSRF validation failed. Please try again.");
                response.sendRedirect(request.getContextPath() + "/auto-pay?action=dashboard");
                return;
            }

            if ("create".equals(action)) {
                handleCreateInstruction(request, response, customerId);
            } else {
                response.sendRedirect(request.getContextPath() + "/auto-pay?action=dashboard");
            }
        } catch (Exception e) {
            logger.error("Error in AutoPayServlet doPost", e);
            request.getSession().setAttribute("error", "Error processing request: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/auto-pay?action=dashboard");
        }
    }

    private void showCustomerDashboard(HttpServletRequest request, HttpServletResponse response, long customerId) throws Exception {
        // Fetch active/paused rules
        List<AutoPayInstruction> instructions = autoPayService.getInstructionsByCustomer(customerId);
        
        // Fetch paginated history
        int page = 1;
        String pageStr = getParameter(request, "page", "1");
        try { page = Integer.parseInt(pageStr); } catch (NumberFormatException e) {}
        int limit = 10;
        int offset = (page - 1) * limit;
        int totalHistory = autoPayService.countHistoryByCustomer(customerId);
        int totalPages = (int) Math.ceil((double) totalHistory / limit);
        List<AutoPayHistory> historyList = autoPayService.getHistoryByCustomer(customerId, limit, offset);

        // Fetch user data for dropdown selection lists
        List<Account> accounts = accountService.getAccountsByCustomerId(customerId);
        // Filter only savings, checking, or current (not fixed deposits)
        accounts.removeIf(acc -> AppConstants.ACCOUNT_TYPE_FIXED_DEPOSIT.equalsIgnoreCase(acc.getAccountType()));
        
        List<Card> cards = cardService.getCardsByCustomerId(customerId);
        cards.removeIf(c -> !"credit".equalsIgnoreCase(c.getCardType()) || !"active".equalsIgnoreCase(c.getStatus()));
        
        List<Loan> loans = loanService.getLoansByCustomerId(customerId);
        loans.removeIf(l -> "closed".equalsIgnoreCase(l.getStatus()) || "pending_approval".equalsIgnoreCase(l.getStatus()) || "rejected".equalsIgnoreCase(l.getStatus()));

        // Fetch Notifications
        List<Notification> notifications = notificationDAO.getByCustomerId(customerId, 15);

        // CSRF Token
        String csrfToken = generateCSRFToken(request);

        request.setAttribute("instructions", instructions);
        request.setAttribute("historyList", historyList);
        request.setAttribute("accounts", accounts);
        request.setAttribute("cards", cards);
        request.setAttribute("loans", loans);
        request.setAttribute("notifications", notifications);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalHistory", totalHistory);
        request.setAttribute("csrfToken", csrfToken);

        request.getRequestDispatcher("/customer/auto_pay.jsp").forward(request, response);
    }

    private void handleCreateInstruction(HttpServletRequest request, HttpServletResponse response, long customerId) throws Exception {
        String targetType = getParameter(request, "targetType", null);
        String cardIdStr = getParameter(request, "cardId", null);
        String loanIdStr = getParameter(request, "loanId", null);
        String sourceAccountIdStr = getParameter(request, "sourceAccountId", null);
        String paymentType = getParameter(request, "paymentType", null);
        String startDateStr = getParameter(request, "startDate", null);

        try {
            if (targetType == null || sourceAccountIdStr == null || paymentType == null || startDateStr == null) {
                throw new Exception("Please fill out all required fields.");
            }

            AutoPayInstruction ins = new AutoPayInstruction();
            ins.setCustomerId(customerId);
            ins.setTargetType(targetType);
            ins.setSourceAccountId(Long.parseLong(sourceAccountIdStr));
            ins.setPaymentType(paymentType);
            ins.setNextPaymentDate(Date.valueOf(startDateStr));

            if ("credit_card".equals(targetType)) {
                if (cardIdStr == null || cardIdStr.isEmpty()) {
                    throw new Exception("Please select a target credit card.");
                }
                ins.setCardId(Long.parseLong(cardIdStr));
            } else if ("loan".equals(targetType)) {
                if (loanIdStr == null || loanIdStr.isEmpty()) {
                    throw new Exception("Please select a target loan.");
                }
                ins.setLoanId(Long.parseLong(loanIdStr));
            } else {
                throw new Exception("Invalid auto-pay target selection.");
            }

            boolean created = autoPayService.createInstruction(ins);
            if (created) {
                request.getSession().setAttribute("success", "Auto Pay configured successfully!");
            } else {
                request.getSession().setAttribute("error", "Failed to configure Auto Pay. Please try again.");
            }
        } catch (Exception e) {
            logger.warn("AutoPay creation validation failure: {}", e.getMessage());
            request.getSession().setAttribute("error", e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/auto-pay?action=dashboard");
    }

    private void handleToggleStatus(HttpServletRequest request, HttpServletResponse response, long customerId, String status) throws Exception {
        String idStr = getParameter(request, "id", null);
        if (idStr != null) {
            long autoPayId = Long.parseLong(idStr);
            try {
                autoPayService.updateStatus(customerId, autoPayId, status);
                request.getSession().setAttribute("success", "Auto Pay instructions updated successfully!");
            } catch (Exception e) {
                request.getSession().setAttribute("error", e.getMessage());
            }
        }
        response.sendRedirect(request.getContextPath() + "/auto-pay?action=dashboard");
    }

    private void handleCancel(HttpServletRequest request, HttpServletResponse response, long customerId) throws Exception {
        String idStr = getParameter(request, "id", null);
        if (idStr != null) {
            long autoPayId = Long.parseLong(idStr);
            try {
                autoPayService.cancelInstruction(customerId, autoPayId);
                request.getSession().setAttribute("success", "Auto Pay instruction has been deleted.");
            } catch (Exception e) {
                request.getSession().setAttribute("error", e.getMessage());
            }
        }
        response.sendRedirect(request.getContextPath() + "/auto-pay?action=dashboard");
    }

    private void handleMarkNotificationsRead(HttpServletRequest request, HttpServletResponse response, long customerId) throws Exception {
        notificationDAO.markAllAsRead(customerId);
        response.sendRedirect(request.getContextPath() + "/auto-pay?action=dashboard");
    }

    private void showAdminDashboard(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String search = getParameter(request, "search", "");
        String status = getParameter(request, "status", "");
        String type = getParameter(request, "type", "");

        // Paginate active instructions
        int insPage = 1;
        String insPageStr = getParameter(request, "insPage", "1");
        try { insPage = Integer.parseInt(insPageStr); } catch (NumberFormatException e) {}
        int limit = 10;
        int insOffset = (insPage - 1) * limit;
        int totalIns = autoPayService.countAllInstructions(search, status, type);
        int insTotalPages = (int) Math.ceil((double) totalIns / limit);
        List<AutoPayInstruction> instructions = autoPayService.getAllInstructions(search, status, type, limit, insOffset);

        // Paginate execution history
        int histPage = 1;
        String histPageStr = getParameter(request, "histPage", "1");
        try { histPage = Integer.parseInt(histPageStr); } catch (NumberFormatException e) {}
        int histOffset = (histPage - 1) * limit;
        int totalHist = autoPayService.countAllHistory(search, status, type);
        int histTotalPages = (int) Math.ceil((double) totalHist / limit);
        List<AutoPayHistory> historyList = autoPayService.getAllHistory(search, status, type, limit, histOffset);

        request.setAttribute("instructions", instructions);
        request.setAttribute("historyList", historyList);
        request.setAttribute("search", search);
        request.setAttribute("status", status);
        request.setAttribute("type", type);
        request.setAttribute("insPage", insPage);
        request.setAttribute("insTotalPages", insTotalPages);
        request.setAttribute("totalIns", totalIns);
        request.setAttribute("histPage", histPage);
        request.setAttribute("histTotalPages", histTotalPages);
        request.setAttribute("totalHist", totalHist);

        request.getRequestDispatcher("/admin/auto_pay.jsp").forward(request, response);
    }

    private void handleAdminTrigger(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int processed = autoPayService.processAutoPayments();
        request.getSession().setAttribute("success", "Auto-Pay batch processing triggered successfully! Processed " + processed + " due instructions.");
        response.sendRedirect(request.getContextPath() + "/auto-pay?action=adminDashboard");
    }

    private void handleAdminReport(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String reportType = getParameter(request, "type", "instructions");
        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=autopay_" + reportType + "_report.csv");

        PrintWriter writer = response.getWriter();
        if ("history".equalsIgnoreCase(reportType)) {
            writer.println("History ID,Auto Pay ID,Customer Name,Target Type,Payment Type,Billing Target,Source Account,Payment Date,Amount (INR),Status,Failure Reason,Txn Reference");
            List<AutoPayHistory> history = autoPayService.getAllHistory("", "", "", 5000, 0);
            for (AutoPayHistory h : history) {
                String target = "credit_card".equals(h.getTargetType()) ? h.getMaskedCardNumber() : "Loan ID " + h.getLoanType();
                writer.println(String.format("%d,%d,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s",
                    h.getHistoryId(),
                    h.getAutoPayId(),
                    escapeCsv(h.getCustomerName()),
                    h.getTargetType(),
                    h.getPaymentType(),
                    target,
                    h.getMaskedSourceAccountNumber(),
                    h.getPaymentDate(),
                    h.getAmount().setScale(2).toString(),
                    h.getStatus(),
                    escapeCsv(h.getFailureReason()),
                    h.getTransactionReference()
                ));
            }
        } else {
            writer.println("Auto Pay ID,Customer ID,Customer Name,Target Type,Billing Target,Source Account,Payment Type,Frequency,Next Payment Date,Status,Last Processed Date");
            List<AutoPayInstruction> list = autoPayService.getAllInstructions("", "", "", 5000, 0);
            for (AutoPayInstruction ins : list) {
                String target = "credit_card".equals(ins.getTargetType()) ? ins.getMaskedCardNumber() : "Loan ID " + ins.getLoanId();
                writer.println(String.format("%d,%d,%s,%s,%s,%s,%s,%s,%s,%s,%s",
                    ins.getAutoPayId(),
                    ins.getCustomerId(),
                    escapeCsv(ins.getCustomerName()),
                    ins.getTargetType(),
                    target,
                    ins.getMaskedSourceAccountNumber(),
                    ins.getPaymentType(),
                    ins.getPaymentFrequency(),
                    ins.getNextPaymentDate(),
                    ins.getStatus(),
                    ins.getLastProcessedDate() != null ? ins.getLastProcessedDate().toString() : "N/A"
                ));
            }
        }
        writer.flush();
    }

    private String escapeCsv(String val) {
        if (val == null) return "N/A";
        return "\"" + val.replace("\"", "\"\"").replace("\n", " ").trim() + "\"";
    }
}
