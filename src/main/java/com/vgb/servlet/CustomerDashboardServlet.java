package com.vgb.servlet;

import com.vgb.constants.AppConstants;
import com.vgb.model.Account;
import com.vgb.model.Customer;
import com.vgb.service.AccountService;
import com.vgb.service.LoanService;
import com.vgb.service.CustomerService;
import com.vgb.util.AccountContextUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

/**
 * CustomerDashboardServlet: Handles customer dashboard requests
 */
@WebServlet(name = "CustomerDashboardServlet", value = "/customer-dashboard")
public class CustomerDashboardServlet extends BaseServlet {
    private AccountService accountService = new AccountService();
    private LoanService loanService = new LoanService();
    private CustomerService customerService = new CustomerService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute(AppConstants.USER_SESSION_KEY) == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Long customerId = getUserId(request);
        
        try {
            // Get customer profile and mock birth date details
            Customer customer = customerService.getCustomerById(customerId);
            String birthDate = "08/08/2002"; // Standard high-tech dev profile birth date
            
            // Get customer accounts
            List<Account> accounts = accountService.getCustomerAccounts(customerId);
            
            Account activeAccount = AccountContextUtil.resolveActiveAccount(session, accounts);
            BigDecimal activeBalance = AccountContextUtil.getBalance(activeAccount);
            
            // Get active loans
            List<com.vgb.model.Loan> activeLoans = loanService.getLoansByCustomerIdAndStatus(customerId, AppConstants.LOAN_STATUS_ACTIVE);
            
            request.setAttribute("accounts", accounts);
            request.setAttribute("activeAccount", activeAccount);
            request.setAttribute("activeBalance", activeBalance);
            request.setAttribute("totalBalance", activeBalance);
            request.setAttribute("activeLoans", activeLoans);
            request.setAttribute("customer", customer);
            request.setAttribute("birthDate", birthDate);
            
            request.getRequestDispatcher("/customer/dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            logger.error("Error loading customer dashboard", e);
            request.setAttribute("error", "Failed to load dashboard data");
            request.getRequestDispatcher("/customer/dashboard.jsp").forward(request, response);
        }
    }
}
