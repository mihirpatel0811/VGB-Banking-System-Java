package com.vgb.servlet;

import com.vgb.model.Account;
import com.vgb.model.ChequeBookRequest;
import com.vgb.service.AccountService;
import com.vgb.service.ChequeBookRequestService;
import com.vgb.util.AccountContextUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ChequeBookServlet", value = "/chequebook")
public class ChequeBookServlet extends BaseServlet {
    private ChequeBookRequestService chequeBookService = new ChequeBookRequestService();
    private AccountService accountService = new AccountService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = getParameter(request, "action", "list");

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

            switch (action) {
                case "approve":
                    approveRequest(request, response, adminId);
                    break;
                case "reject":
                    rejectRequest(request, response, adminId);
                    break;
                default:
                    listRequests(request, response, customerId, adminId);
            }
        } catch (Exception e) {
            logger.error("Error in ChequeBookServlet doGet", e);
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            try {
                listRequests(request, response, getUserId(request), getAdminId(request));
            } catch (Exception ex) {
                logger.error("Error in error redirection of ChequeBookServlet doGet", ex);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = getParameter(request, "action", "");

        try {
            switch (action) {
                case "apply":
                case "renew":
                    applyChequeBook(request, response, action);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/chequebook");
            }
        } catch (Exception e) {
            logger.error("Error in ChequeBookServlet doPost", e);
            request.getSession().setAttribute("error", "Failed to process cheque book action: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/chequebook");
        }
    }

    private void listRequests(HttpServletRequest request, HttpServletResponse response, Long customerId, Integer adminId) throws Exception {
        generateCSRFToken(request);
        if (adminId != null) {
            // Admin lists all requests
            List<ChequeBookRequest> allRequests = chequeBookService.getAllRequests();
            request.setAttribute("requests", allRequests);
            request.getRequestDispatcher("/admin/chequebook.jsp").forward(request, response);
        } else if (customerId != null) {
            // Customer lists their requests and active accounts
            List<ChequeBookRequest> customerRequests = chequeBookService.getCustomerRequests(customerId);
            List<Account> accounts = accountService.getCustomerAccounts(customerId);
            Account activeAccount = AccountContextUtil.resolveActiveAccount(request.getSession(false), accounts);

            com.vgb.model.Customer customer = new com.vgb.service.CustomerService().getCustomerById(customerId);

            request.setAttribute("requests", customerRequests);
            request.setAttribute("accounts", (accounts != null && !accounts.isEmpty()) ? accounts : AccountContextUtil.onlyActiveAccount(accounts, activeAccount));
            request.setAttribute("activeAccount", activeAccount);
            request.setAttribute("selectedAccountId", activeAccount != null ? activeAccount.getAccountId() : 0L);
            request.setAttribute("customer", customer);
            request.getRequestDispatcher("/customer/chequebook.jsp").forward(request, response);
        } else {
            redirectToLogin(request, response);
        }
    }

    private void approveRequest(HttpServletRequest request, HttpServletResponse response, Integer adminId) throws Exception {
        if (adminId == null) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Unauthorized Access");
            return;
        }
        if (!validateCSRFToken(request)) {
            request.getSession().setAttribute("error", "Security validation check failed: Invalid CSRF Token.");
            response.sendRedirect(request.getContextPath() + "/chequebook");
            return;
        }

        long requestId = Long.parseLong(getParameter(request, "id", "0"));
        if (chequeBookService.approveRequest(requestId)) {
            request.getSession().setAttribute("success", "Cheque Book request has been approved successfully. Customer has been granted Cheque Book access.");
        } else {
            request.getSession().setAttribute("error", "Failed to approve Cheque Book request.");
        }
        response.sendRedirect(request.getContextPath() + "/chequebook");
    }

    private void rejectRequest(HttpServletRequest request, HttpServletResponse response, Integer adminId) throws Exception {
        if (adminId == null) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Unauthorized Access");
            return;
        }
        if (!validateCSRFToken(request)) {
            request.getSession().setAttribute("error", "Security validation check failed: Invalid CSRF Token.");
            response.sendRedirect(request.getContextPath() + "/chequebook");
            return;
        }

        long requestId = Long.parseLong(getParameter(request, "id", "0"));
        if (chequeBookService.rejectRequest(requestId)) {
            request.getSession().setAttribute("success", "Cheque Book request has been rejected successfully and charges have been refunded.");
        } else {
            request.getSession().setAttribute("error", "Failed to reject Cheque Book request.");
        }
        response.sendRedirect(request.getContextPath() + "/chequebook");
    }

    private void applyChequeBook(HttpServletRequest request, HttpServletResponse response, String actionType) throws Exception {
        Long customerId = getUserId(request);
        boolean requestFromAdmin = isAdmin(request);

        if (!validateCSRFToken(request)) {
            request.getSession().setAttribute("error", "Security validation check failed: Invalid CSRF Token.");
            response.sendRedirect(request.getContextPath() + "/chequebook");
            return;
        }

        long accountId = Long.parseLong(getParameter(request, "accountId", "0"));
        String accountNumber = getParameter(request, "accountNumber", "");
        int leavesCount = Integer.parseInt(getParameter(request, "leavesCount", "0"));

        Account targetAccount = null;
        if (accountId > 0) {
            targetAccount = accountService.getAccountById(accountId);
        } else if (!accountNumber.isEmpty()) {
            targetAccount = accountService.getAccountByNumber(accountNumber);
            if (targetAccount != null) {
                accountId = targetAccount.getAccountId();
            }
        }

        if (targetAccount != null) {
            if (requestFromAdmin || customerId == null) {
                customerId = targetAccount.getCustomerId();
            }
        }

        if (accountId == 0 || leavesCount == 0) {
            request.getSession().setAttribute("error", "Invalid account or leaves selection.");
            response.sendRedirect(request.getContextPath() + "/chequebook");
            return;
        }

        if (customerId == null) {
            request.getSession().setAttribute("error", "Could not determine target customer for cheque book request.");
            response.sendRedirect(request.getContextPath() + "/chequebook");
            return;
        }

        try {
            ChequeBookRequest req = chequeBookService.applyForChequeBook(customerId, accountId, leavesCount);
            if (req != null) {
                String actionText = "renew".equalsIgnoreCase(actionType) ? "renewal" : "issuance";
                request.getSession().setAttribute("success", "Cheque Book " + actionText + " request submitted successfully! Charged fee of ₹" + req.getCharges().setScale(2) + ". Awaiting Admin approval.");
            } else {
                request.getSession().setAttribute("error", "Failed to process Cheque Book request.");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("error", e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/chequebook");
    }
}
