package com.vgb.servlet;

import com.vgb.model.Customer;
import com.vgb.dao.CustomerDAOImpl;
import com.vgb.util.SecurityUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * ForgotPasswordServlet: Handles customer password recovery and reset
 */
@WebServlet(name = "ForgotPasswordServlet", value = "/forgot-password")
public class ForgotPasswordServlet extends BaseServlet {
    private CustomerDAOImpl customerDAO = new CustomerDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        generateCSRFToken(request);
        request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            if (!validateCSRFToken(request)) {
                sendErrorResponse(response, "Invalid request. Please try again.", HttpServletResponse.SC_BAD_REQUEST);
                return;
            }

            String username = getParameter(request, "username", "");
            String email = getParameter(request, "email", "");
            String pin = getParameter(request, "pin", "");
            String newPassword = getParameter(request, "newPassword", "");

            if (username.isEmpty() || email.isEmpty() || pin.isEmpty() || newPassword.isEmpty()) {
                request.setAttribute("error", "All fields are required.");
                request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
                return;
            }

            // Find customer by username
            Customer customer = customerDAO.getByUsername(username);

            if (customer == null) {
                // For security, do not disclose if username doesn't exist
                request.setAttribute("error", "Invalid username, email or security PIN.");
                request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
                return;
            }

            // Validate that the email matches and PIN matches
            if (!customer.getEmail().equalsIgnoreCase(email) || !customer.getPin().equals(pin)) {
                request.setAttribute("error", "Invalid username, email or security PIN.");
                request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
                return;
            }

            // Validate password strength
            if (!SecurityUtil.isValidPasswordStrength(newPassword)) {
                request.setAttribute("error", "New password does not meet complexity requirements. Minimum 8 characters, with uppercase, lowercase, number, and special character.");
                request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
                return;
            }

            // Hash new password and update database
            String hashedPassword = SecurityUtil.hashPassword(newPassword);
            boolean result = customerDAO.updatePassword(customer.getCustomerId(), hashedPassword);

            if (result) {
                logger.info("Password reset successfully for customer: {}", customer.getUsername());
                request.setAttribute("success", "Password reset successful! Please login with your new password.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Failed to reset password. Please try again.");
                request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
            }

        } catch (Exception e) {
            logger.error("Error during password reset", e);
            request.setAttribute("error", "An error occurred: " + (e.getMessage() != null ? e.getMessage() : "Password reset failed"));
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
        }
    }
}
