package com.vgb.servlet;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * LogoutServlet: Handles user logout
 */
@WebServlet(name = "LogoutServlet", value = "/logout")
public class LogoutServlet extends BaseServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            HttpSession session = request.getSession(false);
            
            if (session != null) {
                logger.info("User logging out from session");
                session.invalidate();
            }

            response.sendRedirect(request.getContextPath() + "/login");

        } catch (Exception e) {
            logger.error("Error during logout", e);
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }
}
