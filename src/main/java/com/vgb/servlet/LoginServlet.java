package com.vgb.servlet;

import com.vgb.constants.AppConstants;
import com.vgb.model.Admin;
import com.vgb.model.Account;
import com.vgb.service.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * LoginServlet: Handles user login (both admin and customer)
 */
@WebServlet(name = "LoginServlet", value = "/login")
public class LoginServlet extends BaseServlet {
    private AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Generate CSRF token
        generateCSRFToken(request);
        
        // Forward to login page
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!validateCSRFToken(request)) {
            request.setAttribute("error", "Security validation check failed: Invalid CSRF Token.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        String username = getParameter(request, "username", "");
        String loginMode = getParameter(request, "loginMode", "password");
        boolean isPinMode = "pin".equalsIgnoreCase(loginMode);
        String credential = isPinMode ? getParameter(request, "pin", "") : getParameter(request, "password", "");
        String userType = getParameter(request, "userType", "customer"); // admin or customer

        try {
            HttpSession session = request.getSession();
            
            if ("admin".equalsIgnoreCase(userType)) {
                // Admin login
                Admin admin;
                if (isPinMode) {
                    admin = authService.authenticateAdminByPIN(username, credential);
                } else {
                    admin = authService.authenticateAdmin(username, credential);
                }
                
                if (admin != null) {
                    session.setAttribute(AppConstants.ADMIN_SESSION_KEY, admin.getAdminId());
                    session.setAttribute(AppConstants.USER_ROLE_SESSION, AppConstants.ROLE_ADMIN);
                    session.setMaxInactiveInterval(AppConstants.SESSION_TIMEOUT_MINUTES * 60);
                    
                    logger.info("Admin login successful: {}", username);
                    response.sendRedirect(request.getContextPath() + AppConstants.PATH_ADMIN_DASHBOARD);
                } else {
                    logger.warn("Admin login failed: {}", username);
                    request.setAttribute("error", AppConstants.ERROR_INVALID_CREDENTIALS);
                    request.getRequestDispatcher("/login.jsp").forward(request, response);
                }
            } else {
                // Customer login
                Account account;
                if (isPinMode) {
                    account = authService.authenticateCustomerAccountByPIN(username, credential);
                } else {
                    account = authService.authenticateCustomerAccount(username, credential);
                }
                
                if (account != null) {
                    session.setAttribute(AppConstants.USER_SESSION_KEY, account.getCustomerId());
                    session.setAttribute("accountId", account.getAccountId());
                    session.setAttribute(AppConstants.USER_ROLE_SESSION, AppConstants.ROLE_CUSTOMER);
                    session.setMaxInactiveInterval(AppConstants.SESSION_TIMEOUT_MINUTES * 60);
                    
                    logger.info("Customer account login successful: {}", username);
                    response.sendRedirect(request.getContextPath() + AppConstants.PATH_CUSTOMER_DASHBOARD);
                } else {
                    logger.warn("Customer login failed: {}", username);
                    request.setAttribute("error", AppConstants.ERROR_INVALID_CREDENTIALS);
                    request.getRequestDispatcher("/login.jsp").forward(request, response);
                }
            }

        } catch (Exception e) {
            logger.error("Error during login", e);
            sendErrorResponse(response, AppConstants.ERROR_DATABASE_ERROR, HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
