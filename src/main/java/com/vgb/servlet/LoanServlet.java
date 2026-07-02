package com.vgb.servlet;

import com.vgb.model.Loan;
import com.vgb.service.LoanService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;

/**
 * LoanServlet: Handles loan-related requests
 */
@WebServlet(name = "LoanServlet", value = "/loan")
public class LoanServlet extends BaseServlet {
    private LoanService loanService = new LoanService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = getParameter(request, "action", "list");
        
        // Transfer session error/success to request attributes for JSP rendering
        jakarta.servlet.http.HttpSession session = request.getSession(false);
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
                case "apply":
                    showApplyForm(request, response);
                    break;
                case "view":
                    viewLoan(request, response, customerId, adminId);
                    break;
                case "approve":
                    approveLoan(request, response);
                    break;
                case "reject":
                    rejectLoan(request, response);
                    break;
                case "repayment":
                    showRepayment(request, response);
                    break;
                case "statement":
                    showStatement(request, response);
                    break;
                default:
                    listLoans(request, response, customerId, adminId);
            }
        } catch (Exception e) {
            logger.error("Error in loan doGet", e);
            request.setAttribute("error", e.getMessage());
            try {
                listLoans(request, response, getUserId(request), getAdminId(request));
            } catch (Exception ex) {
                logger.error("Failed to list loans in doGet error handler", ex);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!validateCSRFToken(request)) {
            request.getSession().setAttribute("error", "Failed security check: Invalid CSRF token");
            String redirectUrl = getParameter(request, "redirectUrl", "/loan");
            response.sendRedirect(request.getContextPath() + redirectUrl);
            return;
        }

        String action = getParameter(request, "action", "");
        
        try {
            switch (action) {
                case "apply":
                    applyLoan(request, response);
                    break;
                case "repayment":
                    processRepayment(request, response);
                    break;
                case "disburse":
                    disburseLoan(request, response);
                    break;
                case "update":
                    updateLoan(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/loan");
            }
        } catch (Exception e) {
            logger.error("Error in loan doPost", e);
            request.setAttribute("error", e.getMessage());
            try {
                listLoans(request, response, getUserId(request), getAdminId(request));
            } catch (Exception ex) {
                logger.error("Failed to list loans in doPost error handler", ex);
            }
        }
    }

    private void updateLoan(HttpServletRequest request, HttpServletResponse response) throws Exception {
        long loanId = Long.parseLong(getParameter(request, "loanId", "0"));
        Loan loan = loanService.getLoanById(loanId);
        if (loan == null) {
            throw new IllegalArgumentException("Loan not found for ID: " + loanId);
        }

        BigDecimal amount = new BigDecimal(getParameter(request, "amount", "0"));
        int termMonths = Integer.parseInt(getParameter(request, "termMonths", "120"));
        BigDecimal interestRate = new BigDecimal(getParameter(request, "interestRate", "7.5"));
        String formDetails = getParameter(request, "formDetails", "");
        String loanType = getParameter(request, "loanType", loan.getLoanType());

        loan.setPrincipalAmount(amount);
        // Sync remaining balance with principal if the loan has not been disbursed or is pending
        if ("pending_approval".equalsIgnoreCase(loan.getStatus()) || "approved".equalsIgnoreCase(loan.getStatus())) {
            loan.setRemainingBalance(amount);
        }
        loan.setInterestRate(interestRate);
        loan.setTermMonths(termMonths);
        loan.setFormDetails(formDetails);
        loan.setLoanType(loanType);

        if (loanService.updateLoan(loan)) {
            request.getSession().setAttribute("success", "Loan details for #LN-" + loanId + " updated successfully!");
        } else {
            request.getSession().setAttribute("error", "Failed to update loan details.");
        }
        response.sendRedirect(request.getContextPath() + "/loan");
    }

    private void listLoans(HttpServletRequest request, HttpServletResponse response, Long customerId, Integer adminId) throws Exception {
        generateCSRFToken(request);
        if (adminId != null) {
            request.setAttribute("loans", loanService.getAllLoans());
            request.setAttribute("repayments", loanService.getAllRepayments());
            populateCustomerNames(request);
            try {
                request.setAttribute("accounts", new com.vgb.service.AccountService().getAllAccounts());
            } catch (Exception e) {
                logger.error("Failed to load accounts in listLoans", e);
            }
            request.getRequestDispatcher("/admin/loan.jsp").forward(request, response);
        } else {
            request.setAttribute("loans", loanService.getLoansByCustomerId(customerId));
            try {
                com.vgb.model.Customer customer = new com.vgb.service.CustomerService().getCustomerById(customerId);
                request.setAttribute("customer", customer);
                request.setAttribute("accounts", new com.vgb.service.AccountService().getCustomerAccounts(customerId));
            } catch (Exception e) {
                logger.error("Failed to load customer profile or accounts in LoanServlet listLoans", e);
            }
            request.getRequestDispatcher("/customer/loan.jsp").forward(request, response);
        }
    }

    private void disburseLoan(HttpServletRequest request, HttpServletResponse response) throws Exception {
        long loanId = Long.parseLong(getParameter(request, "id", "0"));
        long accountId = Long.parseLong(getParameter(request, "accountId", "0"));
        
        try {
            if (loanService.disburseLoan(loanId, accountId)) {
                request.getSession().setAttribute("success", "Loan #" + loanId + " disbursed successfully to Account #" + accountId + ".");
            } else {
                request.getSession().setAttribute("error", "Failed to disburse loan #" + loanId + ".");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Failed to disburse loan: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/loan");
    }

    private void showStatement(HttpServletRequest request, HttpServletResponse response) throws Exception {
        generateCSRFToken(request);
        long loanId = Long.parseLong(getParameter(request, "id", "0"));
        Loan loan = loanService.getLoanById(loanId);
        
        if (loan != null) {
            request.setAttribute("statementLoan", loan);
            request.setAttribute("statementRepayments", loanService.getLoanRepaymentHistory(loanId));
            try {
                com.vgb.dao.CustomerDAOImpl customerDAO = new com.vgb.dao.CustomerDAOImpl();
                request.setAttribute("statementCustomer", customerDAO.getById(loan.getCustomerId()));
            } catch (Exception e) {
                logger.error("Failed to load customer for loan statement", e);
            }
        }
        
        // Populate standard list attributes for loan.jsp display
        request.setAttribute("loans", loanService.getAllLoans());
        request.setAttribute("repayments", loanService.getAllRepayments());
        populateCustomerNames(request);
        try {
            request.setAttribute("accounts", new com.vgb.service.AccountService().getAllAccounts());
        } catch (Exception e) {
            logger.error("Failed to load accounts in showStatement", e);
        }
        
        request.getRequestDispatcher("/admin/loan.jsp").forward(request, response);
    }

    private void populateCustomerNames(HttpServletRequest request) {
        try {
            java.util.List<com.vgb.model.Customer> customersList = new com.vgb.service.CustomerService().getAllCustomers();
            java.util.Map<Long, String> customerNames = new java.util.HashMap<>();
            java.util.Map<Long, String> customerPhones = new java.util.HashMap<>();
            java.util.Map<Long, String> customerAadhaars = new java.util.HashMap<>();
            java.util.Map<Long, String> customerPans = new java.util.HashMap<>();
            for (com.vgb.model.Customer c : customersList) {
                customerNames.put(c.getCustomerId(), c.getFullName());
                customerPhones.put(c.getCustomerId(), c.getPhoneNo());
                customerAadhaars.put(c.getCustomerId(), c.getAadhaarCard());
                customerPans.put(c.getCustomerId(), c.getPanCard());
            }
            request.setAttribute("customerNames", customerNames);
            request.setAttribute("customerPhones", customerPhones);
            request.setAttribute("customerAadhaars", customerAadhaars);
            request.setAttribute("customerPans", customerPans);
            request.setAttribute("customers", customersList);
        } catch (Exception e) {
            logger.error("Failed to load customer metadata maps in LoanServlet", e);
        }
    }

    private void showApplyForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/customer/loan.jsp").forward(request, response);
    }

    private void applyLoan(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Long customerId = getUserId(request);
        if (customerId == null && getAdminId(request) != null) {
            String custIdParam = getParameter(request, "customerId", "");
            if (!custIdParam.isEmpty()) {
                customerId = Long.parseLong(custIdParam);
            }
        }

        if (customerId == null) {
            throw new IllegalArgumentException("Customer ID is required to apply for a loan.");
        }

        String loanType = getParameter(request, "loanType", "");
        BigDecimal amount = new BigDecimal(getParameter(request, "amount", "0"));
        int termMonths = Integer.parseInt(getParameter(request, "termMonths", "120"));
        BigDecimal interestRate = new BigDecimal(getParameter(request, "interestRate", "7.5"));
        String formDetails = getParameter(request, "formDetails", "");

        Loan loan = new Loan();
        loan.setCustomerId(customerId);
        loan.setLoanType(loanType);
        loan.setPrincipalAmount(amount);
        loan.setRemainingBalance(amount);
        loan.setInterestRate(interestRate);
        loan.setTermMonths(termMonths);
        loan.setFormDetails(formDetails);

        if (loanService.applyForLoan(loan)) {
            request.getSession().setAttribute("success", "Loan application form submitted successfully!");
        } else {
            request.getSession().setAttribute("error", "Failed to submit loan application form.");
        }
        response.sendRedirect(request.getContextPath() + "/loan");
    }

    private void viewLoan(HttpServletRequest request, HttpServletResponse response, Long customerId, Integer adminId) throws Exception {
        long loanId = Long.parseLong(getParameter(request, "id", "0"));
        Loan loan = loanService.getLoanById(loanId);
        request.setAttribute("loan", loan);
        request.getRequestDispatcher("/" + (adminId != null ? "admin" : "customer") + "/loan.jsp").forward(request, response);
    }

    private void approveLoan(HttpServletRequest request, HttpServletResponse response) throws Exception {
        long loanId = Long.parseLong(getParameter(request, "id", "0"));
        if (loanService.approveLoan(loanId)) {
            request.setAttribute("success", "Loan approved successfully");
        } else {
            request.setAttribute("error", "Failed to approve loan");
        }
        response.sendRedirect(request.getContextPath() + "/loan");
    }

    private void rejectLoan(HttpServletRequest request, HttpServletResponse response) throws Exception {
        long loanId = Long.parseLong(getParameter(request, "id", "0"));
        if (loanService.rejectLoan(loanId)) {
            request.setAttribute("success", "Loan rejected");
        } else {
            request.setAttribute("error", "Failed to reject loan");
        }
        response.sendRedirect(request.getContextPath() + "/loan");
    }

    private void showRepayment(HttpServletRequest request, HttpServletResponse response) throws Exception {
        long loanId = Long.parseLong(getParameter(request, "id", "0"));
        request.setAttribute("loan", loanService.getLoanById(loanId));
        request.getRequestDispatcher("/customer/loan.jsp").forward(request, response);
    }

    private void processRepayment(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Long customerId = getUserId(request);
        long loanId = Long.parseLong(getParameter(request, "loanId", "0"));
        BigDecimal amount = new BigDecimal(getParameter(request, "amount", "0"));
        long accountId = Long.parseLong(getParameter(request, "accountId", "0"));

        if (customerId == null) {
            String custIdParam = getParameter(request, "customerId", "");
            if (!custIdParam.isEmpty()) {
                customerId = Long.parseLong(custIdParam);
            } else {
                Loan loan = loanService.getLoanById(loanId);
                if (loan != null) {
                    customerId = loan.getCustomerId();
                }
            }
        }

        try {
            if (customerId != null && loanService.processRepayment(loanId, customerId, amount, accountId)) {
                request.getSession().setAttribute("success", "Repayment processed successfully");
            } else {
                request.getSession().setAttribute("error", "Repayment failed");
            }
        } catch (Exception e) {
            logger.error("Error processing repayment in LoanServlet", e);
            request.getSession().setAttribute("error", e.getMessage());
        }
        String redirectUrl = getParameter(request, "redirectUrl", "/loan");
        response.sendRedirect(request.getContextPath() + redirectUrl);
    }
}