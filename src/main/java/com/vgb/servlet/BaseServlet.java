package com.vgb.servlet;

import com.vgb.constants.AppConstants;
import com.vgb.util.SecurityUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.google.gson.Gson;
import java.io.PrintWriter;

/**
 * BaseServlet: Base class for all servlets with common functionality
 */
public abstract class BaseServlet extends HttpServlet {
    protected static final Logger logger = LoggerFactory.getLogger(BaseServlet.class);
    protected Gson gson = new Gson();

    /**
     * Check if user is authenticated
     */
    protected boolean isAuthenticated(HttpServletRequest request) {
        return request.getSession().getAttribute(AppConstants.USER_SESSION_KEY) != null ||
               request.getSession().getAttribute(AppConstants.ADMIN_SESSION_KEY) != null;
    }

    /**
     * Check if user has admin role
     */
    protected boolean isAdmin(HttpServletRequest request) {
        String role = (String) request.getSession().getAttribute(AppConstants.USER_ROLE_SESSION);
        return AppConstants.ROLE_ADMIN.equalsIgnoreCase(role);
    }

    /**
     * Check if user has customer role
     */
    protected boolean isCustomer(HttpServletRequest request) {
        String role = (String) request.getSession().getAttribute(AppConstants.USER_ROLE_SESSION);
        return AppConstants.ROLE_CUSTOMER.equalsIgnoreCase(role);
    }

    /**
     * Get user ID from session
     */
    protected Long getUserId(HttpServletRequest request) {
        Object userId = request.getSession().getAttribute(AppConstants.USER_SESSION_KEY);
        if (userId != null) {
            return Long.parseLong(userId.toString());
        }
        return null;
    }

    /**
     * Get admin ID from session
     */
    protected Integer getAdminId(HttpServletRequest request) {
        Object adminId = request.getSession().getAttribute(AppConstants.ADMIN_SESSION_KEY);
        if (adminId != null) {
            return Integer.parseInt(adminId.toString());
        }
        return null;
    }

    /**
     * Redirect to login if not authenticated
     */
    protected void redirectToLogin(HttpServletRequest request, HttpServletResponse response) throws ServletException, java.io.IOException {
        response.sendRedirect(request.getContextPath() + "/login");
    }

    /**
     * Send JSON response
     */
    protected void sendJsonResponse(HttpServletResponse response, Object data, int status) throws java.io.IOException {
        response.setStatus(status);
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(data));
        out.flush();
    }

    /**
     * Send error response
     */
    protected void sendErrorResponse(HttpServletResponse response, String message, int status) throws java.io.IOException {
        response.setStatus(status);
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        String errorJson = "{\"error\": \"" + SecurityUtil.escapeHTML(message) + "\"}";
        out.print(errorJson);
        out.flush();
    }

    /**
     * Get request parameter with default value
     */
    protected String getParameter(HttpServletRequest request, String name, String defaultValue) {
        String value = request.getParameter(name);
        if (value == null && request.getContentType() != null && request.getContentType().startsWith("multipart/form-data")) {
            try {
                jakarta.servlet.http.Part part = request.getPart(name);
                if (part != null) {
                    try (java.io.InputStream is = part.getInputStream();
                         java.io.BufferedReader reader = new java.io.BufferedReader(new java.io.InputStreamReader(is, java.nio.charset.StandardCharsets.UTF_8))) {
                        StringBuilder sb = new StringBuilder();
                        String line;
                        while ((line = reader.readLine()) != null) {
                            sb.append(line);
                        }
                        value = sb.toString();
                    }
                }
            } catch (Exception e) {
                // Ignore parsing errors and fallback to default
            }
        }
        return value != null ? value.trim() : defaultValue;
    }


    /**
     * Validate CSRF token
     */
    protected boolean validateCSRFToken(HttpServletRequest request) {
        String sessionToken = (String) request.getSession().getAttribute(AppConstants.CSRF_TOKEN_SESSION);
        String requestToken = request.getParameter("csrfToken");
        
        return sessionToken != null && sessionToken.equals(requestToken);
    }

    /**
     * Generate CSRF token
     */
    protected String generateCSRFToken(HttpServletRequest request) {
        String token = SecurityUtil.generateCSRFToken();
        request.getSession().setAttribute(AppConstants.CSRF_TOKEN_SESSION, token);
        return token;
    }
}
