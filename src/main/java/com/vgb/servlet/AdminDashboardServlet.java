package com.vgb.servlet;

import com.vgb.constants.AppConstants;
import com.vgb.model.Customer;
import com.vgb.model.Account;
import com.vgb.model.Loan;
import com.vgb.model.Transaction;
import com.vgb.service.AccountService;
import com.vgb.service.CustomerService;
import com.vgb.service.LoanService;
import com.vgb.dao.TransactionDAOImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

/**
 * AdminDashboardServlet: Handles admin dashboard requests and computes statistics
 */
@WebServlet(name = "AdminDashboardServlet", value = "/admin-dashboard")
public class AdminDashboardServlet extends BaseServlet {
    private CustomerService customerService = new CustomerService();
    private AccountService accountService = new AccountService();
    private LoanService loanService = new LoanService();
    private TransactionDAOImpl transactionDAO = new TransactionDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute(AppConstants.ADMIN_SESSION_KEY) == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // 1. Get pending approvals (required for the action tables)
            List<Loan> pendingLoans = loanService.getLoansByStatus(AppConstants.LOAN_STATUS_PENDING_APPROVAL);
            
            request.setAttribute("pendingLoans", pendingLoans);
            request.setAttribute("totalPendingLoans", pendingLoans.size());

            // 2. Compute Customer Statistics
            List<Customer> allCustomers = customerService.getAllCustomers();
            int totalCustomers = allCustomers.size();
            int totalActiveCustomers = 0;
            int totalSuspendedCustomers = 0;
            for (Customer c : allCustomers) {
                if (AppConstants.ACCOUNT_STATUS_ACTIVE.equalsIgnoreCase(c.getStatus())) {
                    totalActiveCustomers++;
                } else if (AppConstants.ACCOUNT_STATUS_SUSPENDED.equalsIgnoreCase(c.getStatus())) {
                    totalSuspendedCustomers++;
                }
            }
            request.setAttribute("totalCustomers", totalCustomers);
            request.setAttribute("totalActiveCustomers", totalActiveCustomers);
            request.setAttribute("totalSuspendedCustomers", totalSuspendedCustomers);

            // 3. Compute Account & Deposit Statistics
            List<Account> allAccounts = accountService.getAllAccounts();
            int totalAccounts = allAccounts.size();
            int totalSavingsAccounts = 0;
            int totalCheckingAccounts = 0;
            int totalCurrentAccounts = 0;
            int totalFdAccounts = 0;
            BigDecimal totalSystemDeposits = BigDecimal.ZERO;
            for (Account a : allAccounts) {
                if (a.getBalance() != null) {
                    totalSystemDeposits = totalSystemDeposits.add(a.getBalance());
                }
                if (AppConstants.ACCOUNT_TYPE_SAVINGS.equalsIgnoreCase(a.getAccountType())) {
                    totalSavingsAccounts++;
                } else if (AppConstants.ACCOUNT_TYPE_CHECKING.equalsIgnoreCase(a.getAccountType())) {
                    totalCheckingAccounts++;
                } else if (AppConstants.ACCOUNT_TYPE_CURRENT.equalsIgnoreCase(a.getAccountType())) {
                    totalCurrentAccounts++;
                } else if (AppConstants.ACCOUNT_TYPE_FIXED_DEPOSIT.equalsIgnoreCase(a.getAccountType())) {
                    totalFdAccounts++;
                }
            }
            request.setAttribute("totalAccounts", totalAccounts);
            request.setAttribute("totalSavingsAccounts", totalSavingsAccounts);
            request.setAttribute("totalCheckingAccounts", totalCheckingAccounts);
            request.setAttribute("totalCurrentAccounts", totalCurrentAccounts);
            request.setAttribute("totalFdAccounts", totalFdAccounts);
            request.setAttribute("totalSystemDeposits", totalSystemDeposits);

            // 4. Compute Loan & Credit Statistics
            List<Loan> allLoans = loanService.getAllLoans();
            int totalLoans = allLoans.size();
            int totalActiveLoans = 0;
            BigDecimal totalSystemCredit = BigDecimal.ZERO;
            for (Loan l : allLoans) {
                if (AppConstants.LOAN_STATUS_ACTIVE.equalsIgnoreCase(l.getStatus()) || 
                    AppConstants.LOAN_STATUS_APPROVED.equalsIgnoreCase(l.getStatus()) || 
                    AppConstants.LOAN_STATUS_DISBURSED.equalsIgnoreCase(l.getStatus())) {
                    totalActiveLoans++;
                    if (l.getPrincipalAmount() != null) {
                        totalSystemCredit = totalSystemCredit.add(l.getPrincipalAmount());
                    }
                }
            }
            request.setAttribute("totalLoans", totalLoans);
            request.setAttribute("totalActiveLoans", totalActiveLoans);
            request.setAttribute("totalSystemCredit", totalSystemCredit);

            // 5. Compute Transaction Statistics
            List<Transaction> allTransactions = transactionDAO.getAll();
            int totalTransactions = allTransactions.size();
            BigDecimal totalTransactionVolume = BigDecimal.ZERO;
            for (Transaction t : allTransactions) {
                if (AppConstants.TRANSACTION_STATUS_COMPLETED.equalsIgnoreCase(t.getStatus())) {
                    if (t.getAmount() != null) {
                        totalTransactionVolume = totalTransactionVolume.add(t.getAmount());
                    }
                }
            }
            request.setAttribute("totalTransactions", totalTransactions);
            request.setAttribute("totalTransactionVolume", totalTransactionVolume);
            
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            logger.error("Error loading admin dashboard", e);
            request.setAttribute("error", "Failed to load dashboard data");
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
        }
    }
}