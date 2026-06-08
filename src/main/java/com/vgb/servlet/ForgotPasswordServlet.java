package com.vgb.servlet;

import com.vgb.model.Customer;
import com.vgb.model.Admin;
import com.vgb.dao.CustomerDAOImpl;
import com.vgb.dao.AdminDAOImpl;
import com.vgb.util.SecurityUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * ForgotPasswordServlet: Handles password, PIN, and username recovery
 */
@WebServlet(name = "ForgotPasswordServlet", value = "/forgot-password")
public class ForgotPasswordServlet extends BaseServlet {
    private CustomerDAOImpl customerDAO = new CustomerDAOImpl();
    private AdminDAOImpl adminDAO = new AdminDAOImpl();

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

            String action = getParameter(request, "action", "resetPassword");
            request.setAttribute("activeTab", action);

            if ("resetPassword".equalsIgnoreCase(action)) {
                String userType = getParameter(request, "userType", "customer");
                String username = getParameter(request, "username", "");
                String email = getParameter(request, "email", "");
                String pin = getParameter(request, "pin", "");
                String newPassword = getParameter(request, "newPassword", "");

                if (username.isEmpty() || email.isEmpty() || pin.isEmpty() || newPassword.isEmpty()) {
                    request.setAttribute("error", "All fields are required.");
                    request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
                    return;
                }

                if (!SecurityUtil.isValidPasswordStrength(newPassword)) {
                    request.setAttribute("error", "New password does not meet complexity requirements. Minimum 4 characters.");
                    request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
                    return;
                }

                if ("admin".equalsIgnoreCase(userType)) {
                    Admin admin = adminDAO.getByUsername(username);
                    if (admin == null || !admin.getEmail().equalsIgnoreCase(email) || !admin.getPin().equals(pin)) {
                        request.setAttribute("error", "Invalid admin username, email or security PIN.");
                        request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
                        return;
                    }

                    String hashedPassword = SecurityUtil.hashPassword(newPassword);
                    admin.setPassword(hashedPassword);
                    boolean result = adminDAO.update(admin);
                    if (result) {
                        logger.info("Password reset successfully for admin: {}", admin.getUsername());
                        request.setAttribute("success", "Admin password reset successful! Please login with your new password.");
                        request.getRequestDispatcher("/login.jsp").forward(request, response);
                    } else {
                        request.setAttribute("error", "Failed to reset admin password. Please try again.");
                        request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
                    }
                } else {
                    Customer customer = customerDAO.getByUsername(username);
                    if (customer == null || !customer.getEmail().equalsIgnoreCase(email) || !customer.getPin().equals(pin)) {
                        request.setAttribute("error", "Invalid customer username, email or security PIN.");
                        request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
                        return;
                    }

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
                }
            } else if ("resetPIN".equalsIgnoreCase(action)) {
                String userType = getParameter(request, "userType", "customer");
                String username = getParameter(request, "username", "");
                String email = getParameter(request, "email", "");
                String password = getParameter(request, "password", "");
                String newPin = getParameter(request, "newPin", "");

                if (username.isEmpty() || email.isEmpty() || password.isEmpty() || newPin.isEmpty()) {
                    request.setAttribute("error", "All fields are required.");
                    request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
                    return;
                }

                if (!SecurityUtil.isValidPIN(newPin)) {
                    request.setAttribute("error", "Invalid PIN format. PIN must be exactly 4 digits.");
                    request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
                    return;
                }

                if ("admin".equalsIgnoreCase(userType)) {
                    Admin admin = adminDAO.getByUsername(username);
                    if (admin == null || !admin.getEmail().equalsIgnoreCase(email) || !SecurityUtil.verifyPassword(password, admin.getPassword())) {
                        request.setAttribute("error", "Invalid admin credentials or email.");
                        request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
                        return;
                    }

                    admin.setPin(newPin);
                    boolean result = adminDAO.update(admin);
                    if (result) {
                        logger.info("PIN reset successfully for admin: {}", admin.getUsername());
                        request.setAttribute("success", "Admin PIN reset successful! Please login with your new PIN.");
                        request.getRequestDispatcher("/login.jsp").forward(request, response);
                    } else {
                        request.setAttribute("error", "Failed to reset admin PIN. Please try again.");
                        request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
                    }
                } else {
                    Customer customer = customerDAO.getByUsername(username);
                    if (customer == null || !customer.getEmail().equalsIgnoreCase(email) || !SecurityUtil.verifyPassword(password, customer.getPassword())) {
                        request.setAttribute("error", "Invalid customer credentials or email.");
                        request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
                        return;
                    }

                    boolean result = customerDAO.updatePIN(customer.getCustomerId(), newPin);
                    if (result) {
                        logger.info("PIN reset successfully for customer: {}", customer.getUsername());
                        request.setAttribute("success", "PIN reset successful! Please login with your new PIN.");
                        request.getRequestDispatcher("/login.jsp").forward(request, response);
                    } else {
                        request.setAttribute("error", "Failed to reset PIN. Please try again.");
                        request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
                    }
                }
            } else if ("recoverUsername".equalsIgnoreCase(action)) {
                String firstName = getParameter(request, "firstName", "");
                String lastName = getParameter(request, "lastName", "");
                String email = getParameter(request, "email", "");
                String phone = getParameter(request, "phone", "");

                if (firstName.isEmpty() || lastName.isEmpty() || email.isEmpty() || phone.isEmpty()) {
                    request.setAttribute("error", "All fields are required.");
                    request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
                    return;
                }

                Customer customer = customerDAO.getByEmail(email);
                if (customer == null || !customer.getFirstName().equalsIgnoreCase(firstName) || 
                    !customer.getLastName().equalsIgnoreCase(lastName) || !customer.getPhoneNo().equals(phone)) {
                    request.setAttribute("error", "No customer matching these details could be found.");
                    request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
                    return;
                }

                request.setAttribute("success", "Username Retrieval Successful! Your username is: <strong>" + customer.getUsername() + "</strong>");
                request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Invalid action.");
                request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
            }

        } catch (Exception e) {
            logger.error("Error during credentials recovery", e);
            request.setAttribute("error", "An error occurred: " + (e.getMessage() != null ? e.getMessage() : "Operation failed"));
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
        }
    }
}
