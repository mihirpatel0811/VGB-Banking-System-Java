package com.vgb.servlet;

import com.vgb.constants.AppConstants;
import com.vgb.model.Admin;
import com.vgb.model.Customer;
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
        try {
            // Validate CSRF token
            if (!validateCSRFToken(request)) {
                sendErrorResponse(response, "Invalid request. Please try again.", HttpServletResponse.SC_BAD_REQUEST);
                return;
            }

            String username = getParameter(request, "username", null);
            String loginMode = getParameter(request, "loginMode", "password");
            String userType = getParameter(request, "userType", "customer");

            boolean isPinMode = "pin".equalsIgnoreCase(loginMode);
            String credential = isPinMode ? getParameter(request, "pin", null) : getParameter(request, "password", null);

            if (username == null || credential == null) {
                sendErrorResponse(response, "Username and credential are required", HttpServletResponse.SC_BAD_REQUEST);
                return;
            }

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
                Customer customer;
                if (isPinMode) {
                    customer = authService.authenticateCustomerByPIN(username, credential);
                } else {
                    customer = authService.authenticateCustomer(username, credential);
                }
                
                if (customer != null) {
                    session.setAttribute(AppConstants.USER_SESSION_KEY, customer.getCustomerId());
                    session.setAttribute(AppConstants.USER_ROLE_SESSION, AppConstants.ROLE_CUSTOMER);
                    session.setMaxInactiveInterval(AppConstants.SESSION_TIMEOUT_MINUTES * 60);
                    
                    logger.info("Customer login successful: {}", username);
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
