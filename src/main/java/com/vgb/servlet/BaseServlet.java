package com.vgb.servlet;

import com.vgb.constants.AppConstants;
import com.vgb.util.SecurityUtil;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * BaseServlet: Base class for all servlets providing standard helpers and utilities.
 */
public abstract class BaseServlet extends HttpServlet {
    protected final Logger logger = LoggerFactory.getLogger(getClass());

    protected String generateCSRFToken(HttpServletRequest request) {
        HttpSession session = request.getSession();
        String token = (String) session.getAttribute(AppConstants.CSRF_TOKEN_SESSION);
        if (token == null || token.trim().isEmpty()) {
            token = SecurityUtil.generateCSRFToken();
            session.setAttribute(AppConstants.CSRF_TOKEN_SESSION, token);
        }
        return token;
    }

    protected boolean validateCSRFToken(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        String sessionToken = (String) session.getAttribute(AppConstants.CSRF_TOKEN_SESSION);
        String requestToken = getParameter(request, "csrfToken", null);
        if (requestToken == null) {
            requestToken = request.getHeader("X-CSRF-Token");
        }
        return sessionToken != null && sessionToken.equals(requestToken);
    }

    protected String getParameter(HttpServletRequest request, String name, String defaultValue) {
        String value = request.getParameter(name);
        if (value == null) {
            String contentType = request.getContentType();
            if (contentType != null && contentType.toLowerCase().startsWith("multipart/form-data")) {
                try {
                    jakarta.servlet.http.Part part = request.getPart(name);
                    if (part != null && (part.getSubmittedFileName() == null || part.getSubmittedFileName().trim().isEmpty())) {
                        try (java.io.BufferedReader reader = new java.io.BufferedReader(
                                new java.io.InputStreamReader(part.getInputStream(), java.nio.charset.StandardCharsets.UTF_8))) {
                            value = reader.lines().collect(java.util.stream.Collectors.joining("\n"));
                        }
                    }
                } catch (Exception e) {
                    // Ignore exception if request.getPart fails
                }
            }
        }
        return (value != null && !value.trim().isEmpty()) ? value.trim() : defaultValue;
    }

    protected Long getUserId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        Object userId = session.getAttribute(AppConstants.USER_SESSION_KEY);
        if (userId instanceof Long) {
            return (Long) userId;
        } else if (userId instanceof Integer) {
            return ((Integer) userId).longValue();
        } else if (userId instanceof String) {
            try {
                return Long.parseLong((String) userId);
            } catch (NumberFormatException e) {
                return null;
            }
        }
        return null;
    }

    protected Integer getAdminId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        Object adminId = session.getAttribute(AppConstants.ADMIN_SESSION_KEY);
        if (adminId instanceof Integer) {
            return (Integer) adminId;
        } else if (adminId instanceof Long) {
            return ((Long) adminId).intValue();
        } else if (adminId instanceof String) {
            try {
                return Integer.parseInt((String) adminId);
            } catch (NumberFormatException e) {
                return null;
            }
        }
        return null;
    }

    protected boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        String role = (String) session.getAttribute(AppConstants.USER_ROLE_SESSION);
        return AppConstants.ROLE_ADMIN.equalsIgnoreCase(role);
    }

    protected boolean isAuthenticated(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        return session.getAttribute(AppConstants.USER_SESSION_KEY) != null || 
               session.getAttribute(AppConstants.ADMIN_SESSION_KEY) != null;
    }

    protected void redirectToLogin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.sendRedirect(request.getContextPath() + "/login");
    }

    protected void sendErrorResponse(HttpServletResponse response, String message, int statusCode) throws IOException {
        response.setStatus(statusCode);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.print("{\"error\":\"" + escapeJson(message) + "\"}");
            out.flush();
        }
    }

    protected void sendJsonResponse(HttpServletResponse response, Object data, int statusCode) throws IOException {
        response.setStatus(statusCode);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        try (PrintWriter out = response.getWriter()) {
            if (data instanceof java.util.Map) {
                out.print(mapToJson((java.util.Map<?, ?>) data));
            } else if (data instanceof String) {
                out.print((String) data);
            } else {
                out.print("{\"message\":\"success\"}");
            }
            out.flush();
        }
    }

    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\b", "\\b")
                  .replace("\f", "\\f")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }

    private String mapToJson(java.util.Map<?, ?> map) {
        StringBuilder sb = new StringBuilder("{");
        boolean first = true;
        for (java.util.Map.Entry<?, ?> entry : map.entrySet()) {
            if (!first) sb.append(",");
            first = false;
            sb.append("\"").append(escapeJson(String.valueOf(entry.getKey()))).append("\":");
            Object val = entry.getValue();
            if (val instanceof Number || val instanceof Boolean) {
                sb.append(val);
            } else {
                sb.append("\"").append(escapeJson(String.valueOf(val))).append("\"");
            }
        }
        sb.append("}");
        return sb.toString();
    }
}
