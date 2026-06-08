package com.vgb.servlet;

import com.vgb.model.Account;
import com.vgb.model.PassbookRequest;
import com.vgb.service.AccountService;
import com.vgb.service.PassbookRequestService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "PassbookServlet", value = "/passbook")
public class PassbookServlet extends BaseServlet {
    private PassbookRequestService passbookService = new PassbookRequestService();
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
            logger.error("Error in PassbookServlet doGet", e);
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            try {
                listRequests(request, response, getUserId(request), getAdminId(request));
            } catch (Exception ex) {
                logger.error("Error in error redirection of PassbookServlet doGet", ex);
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
                    applyPassbook(request, response, action);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/passbook");
            }
        } catch (Exception e) {
            logger.error("Error in PassbookServlet doPost", e);
            request.getSession().setAttribute("error", "Failed to process passbook action: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/passbook");
        }
    }

    private void listRequests(HttpServletRequest request, HttpServletResponse response, Long customerId, Integer adminId) throws Exception {
        generateCSRFToken(request);
        if (adminId != null) {
            // Admin lists all requests
            List<PassbookRequest> allRequests = passbookService.getAllRequests();
            request.setAttribute("requests", allRequests);
            request.getRequestDispatcher("/admin/passbook.jsp").forward(request, response);
        } else if (customerId != null) {
            // Customer lists their requests and active accounts
            List<PassbookRequest> customerRequests = passbookService.getCustomerRequests(customerId);
            List<Account> accounts = accountService.getCustomerAccounts(customerId);
            com.vgb.model.Customer customer = new com.vgb.service.CustomerService().getCustomerById(customerId);

            request.setAttribute("requests", customerRequests);
            request.setAttribute("accounts", accounts);
            request.setAttribute("customer", customer);
            request.getRequestDispatcher("/customer/passbook.jsp").forward(request, response);
        } else {
            redirectToLogin(request, response);
        }
    }

    private void approveRequest(HttpServletRequest request, HttpServletResponse response, Integer adminId) throws Exception {
        if (adminId == null) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Unauthorized Access");
            return;
        }

        long requestId = Long.parseLong(getParameter(request, "id", "0"));
        if (passbookService.approveRequest(requestId)) {
            request.getSession().setAttribute("success", "Passbook request has been approved successfully. Customer has been granted Passbook access.");
        } else {
            request.getSession().setAttribute("error", "Failed to approve Passbook request.");
        }
        response.sendRedirect(request.getContextPath() + "/passbook");
    }

    private void rejectRequest(HttpServletRequest request, HttpServletResponse response, Integer adminId) throws Exception {
        if (adminId == null) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Unauthorized Access");
            return;
        }

        long requestId = Long.parseLong(getParameter(request, "id", "0"));
        if (passbookService.rejectRequest(requestId)) {
            request.getSession().setAttribute("success", "Passbook request has been rejected successfully and charges have been refunded.");
        } else {
            request.getSession().setAttribute("error", "Failed to reject Passbook request.");
        }
        response.sendRedirect(request.getContextPath() + "/passbook");
    }

    private void applyPassbook(HttpServletRequest request, HttpServletResponse response, String actionType) throws Exception {
        Long customerId = getUserId(request);
        if (customerId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (!validateCSRFToken(request)) {
            request.getSession().setAttribute("error", "Security validation check failed: Invalid CSRF Token.");
            response.sendRedirect(request.getContextPath() + "/passbook");
            return;
        }

        long accountId = Long.parseLong(getParameter(request, "accountId", "0"));

        if (accountId == 0) {
            request.getSession().setAttribute("error", "Invalid account selection.");
            response.sendRedirect(request.getContextPath() + "/passbook");
            return;
        }

        try {
            PassbookRequest req = passbookService.applyForPassbook(customerId, accountId, actionType);
            if (req != null) {
                String actionText = "renew".equalsIgnoreCase(actionType) ? "renewal" : "issuance";
                request.getSession().setAttribute("success", "Passbook " + actionText + " request submitted successfully! Charged fee of ₹" + req.getCharges().setScale(2) + ". Awaiting Admin approval.");
            } else {
                request.getSession().setAttribute("error", "Failed to process Passbook request.");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("error", e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/passbook");
    }
}
