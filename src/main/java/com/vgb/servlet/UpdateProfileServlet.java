package com.vgb.servlet;

import com.vgb.model.Customer;
import com.vgb.dao.CustomerDAOImpl;
import com.vgb.service.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * UpdateProfileServlet: Handles contact card, password, and transaction PIN profile updates
 */
@WebServlet(name = "UpdateProfileServlet", value = "/update-profile")
public class UpdateProfileServlet extends BaseServlet {
    private CustomerDAOImpl customerDAO = new CustomerDAOImpl();
    private AuthService authService = new AuthService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !isAuthenticated(request)) {
            sendErrorResponse(response, "Unauthorized access. Please login.", HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        boolean isAdminUser = isAdmin(request);
        Long customerId = !isAdminUser ? getUserId(request) : null;
        Integer adminId = isAdminUser ? getAdminId(request) : null;
        String action = getParameter(request, "action", "");

        try {
            if ("updateContact".equalsIgnoreCase(action)) {
                if (isAdminUser) {
                    sendErrorResponse(response, "Admin contact cards cannot be updated dynamically.", HttpServletResponse.SC_BAD_REQUEST);
                    return;
                }
                String firstName = getParameter(request, "firstName", "");
                String lastName = getParameter(request, "lastName", "");
                String email = getParameter(request, "email", "");
                String phoneNo = getParameter(request, "phoneNo", "");
                String address = getParameter(request, "address", "");
                String city = getParameter(request, "city", "");
                String state = getParameter(request, "state", "");
                String zipCode = getParameter(request, "zipCode", "");

                if (firstName.isEmpty() || lastName.isEmpty() || email.isEmpty() || phoneNo.isEmpty() || address.isEmpty() || city.isEmpty() || state.isEmpty() || zipCode.isEmpty()) {
                    sendErrorResponse(response, "All fields are required.", HttpServletResponse.SC_BAD_REQUEST);
                    return;
                }

                Customer customer = customerDAO.getById(customerId);
                if (customer == null) {
                    sendErrorResponse(response, "Customer profile not found.", HttpServletResponse.SC_NOT_FOUND);
                    return;
                }

                // Check unique email and phone if they changed
                if (!customer.getEmail().equalsIgnoreCase(email) && customerDAO.existsByEmail(email)) {
                    sendErrorResponse(response, "Email address is already in use by another profile.", HttpServletResponse.SC_BAD_REQUEST);
                    return;
                }
                if (!customer.getPhoneNo().equals(phoneNo) && customerDAO.existsByPhone(phoneNo)) {
                    sendErrorResponse(response, "Mobile number is already registered in our system.", HttpServletResponse.SC_BAD_REQUEST);
                    return;
                }

                customer.setFirstName(firstName);
                customer.setLastName(lastName);
                customer.setEmail(email);
                customer.setPhoneNo(phoneNo);
                customer.setAddress(address);
                customer.setCity(city);
                customer.setState(state);
                customer.setZipCode(zipCode);

                boolean result = customerDAO.update(customer);
                if (result) {
                    Map<String, String> data = new HashMap<>();
                    data.put("message", "Contact details updated successfully!");
                    sendJsonResponse(response, data, HttpServletResponse.SC_OK);
                } else {
                    sendErrorResponse(response, "Failed to update profile. Please try again.", HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                }

            } else if ("updatePassword".equalsIgnoreCase(action)) {
                String oldPassword = getParameter(request, "oldPassword", "");
                String newPassword = getParameter(request, "newPassword", "");

                if (oldPassword.isEmpty() || newPassword.isEmpty()) {
                    sendErrorResponse(response, "Old and new passwords are required.", HttpServletResponse.SC_BAD_REQUEST);
                    return;
                }

                boolean result;
                if (isAdminUser) {
                    result = authService.changeAdminPassword(adminId, oldPassword, newPassword);
                } else {
                    result = authService.updateCustomerPassword(customerId, oldPassword, newPassword);
                }

                if (result) {
                    Map<String, String> data = new HashMap<>();
                    data.put("message", "Password updated successfully! Please use it for your next login.");
                    sendJsonResponse(response, data, HttpServletResponse.SC_OK);
                } else {
                    sendErrorResponse(response, "Failed to update password. Verify that your old password is correct.", HttpServletResponse.SC_BAD_REQUEST);
                }

            } else if ("updatePin".equalsIgnoreCase(action)) {
                String newPin = getParameter(request, "newPin", "");

                if (newPin.isEmpty() || newPin.length() != 4 || !newPin.matches("^[0-9]{4}$")) {
                    sendErrorResponse(response, "Transaction PIN must be exactly 4 digits.", HttpServletResponse.SC_BAD_REQUEST);
                    return;
                }

                boolean result;
                if (isAdminUser) {
                    result = authService.changeAdminPIN(adminId, newPin);
                } else {
                    result = authService.updateCustomerPIN(customerId, newPin);
                }

                if (result) {
                    Map<String, String> data = new HashMap<>();
                    data.put("message", "Transaction PIN updated successfully!");
                    sendJsonResponse(response, data, HttpServletResponse.SC_OK);
                } else {
                    sendErrorResponse(response, "Failed to update Transaction PIN.", HttpServletResponse.SC_BAD_REQUEST);
                }

            } else {
                sendErrorResponse(response, "Invalid action request.", HttpServletResponse.SC_BAD_REQUEST);
            }
        } catch (Exception e) {
            logger.error("Error updating security profile details", e);
            sendErrorResponse(response, "System error: " + e.getMessage(), HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
