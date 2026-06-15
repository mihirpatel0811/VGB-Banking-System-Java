package com.vgb.filter;

import com.vgb.constants.AppConstants;
import com.vgb.util.SecurityUtil;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * CSRFFilter: Pre-populates the CSRF token in the HTTP session on every request (except for static resources).
 * This ensures that JSP files accessed directly or other servlets always have a valid CSRF token available
 * via ${sessionScope.csrfToken}.
 */
@WebFilter("/*")
public class CSRFFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        if (request instanceof HttpServletRequest) {
            HttpServletRequest httpRequest = (HttpServletRequest) request;
            String path = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());
            
            // Bypass token generation for static assets to reduce overhead
            boolean isStaticResource = path.startsWith("/assest/") || 
                                       path.startsWith("/css/") || 
                                       path.startsWith("/js/") || 
                                       path.endsWith(".css") || 
                                       path.endsWith(".js") || 
                                       path.endsWith(".png") || 
                                       path.endsWith(".jpg") || 
                                       path.endsWith(".jpeg") || 
                                       path.endsWith(".gif") || 
                                       path.endsWith(".ico") || 
                                       path.endsWith(".svg") || 
                                       path.endsWith(".woff") || 
                                       path.endsWith(".woff2");

            if (!isStaticResource) {
                HttpSession session = httpRequest.getSession(true);
                String token = (String) session.getAttribute(AppConstants.CSRF_TOKEN_SESSION);
                if (token == null || token.trim().isEmpty()) {
                    token = SecurityUtil.generateCSRFToken();
                    session.setAttribute(AppConstants.CSRF_TOKEN_SESSION, token);
                }
            }
        }
        
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Cleanup if needed
    }
}
