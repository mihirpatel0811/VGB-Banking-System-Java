package com.vgb.servlet;

import com.vgb.model.Account;
import com.vgb.model.Card;
import com.vgb.service.AccountService;
import com.vgb.service.CardService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name = "CardServlet", value = "/card")
public class CardServlet extends BaseServlet {
    private CardService cardService = new CardService();
    private AccountService accountService = new AccountService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = getParameter(request, "action", "list");

        // Transfer session messages
        HttpSession session = request.getSession(false);
        if (session != null) {
            if (session.getAttribute("error") != null) {
                request.setAttribute("error", session.getAttribute("error"));
                session.removeAttribute("error");
            }
            if (session.getAttribute("success") != null) {
                request.setAttribute("success", session.getAttribute("success"));
                session.removeAttribute("success");
            }
        }

        try {
            Long customerId = getUserId(request);
            Integer adminId = getAdminId(request);

            switch (action) {
                case "approve":
                    approveCard(request, response, adminId);
                    break;
                case "close":
                    closeCard(request, response, customerId, adminId);
                    break;
                default:
                    listCards(request, response, customerId, adminId);
            }
        } catch (Exception e) {
            logger.error("Error in CardServlet doGet", e);
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            try {
                listCards(request, response, getUserId(request), getAdminId(request));
            } catch (Exception ex) {
                logger.error("Error in error redirection of CardServlet doGet", ex);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = getParameter(request, "action", "");

        try {
            switch (action) {
                case "apply":
                    applyCard(request, response);
                    break;
                case "renew":
                    renewCard(request, response);
                    break;
                case "payDues":
                    payDues(request, response);
                    break;
                case "updateLimits":
                    updateLimits(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/card");
            }
        } catch (Exception e) {
            logger.error("Error in CardServlet doPost", e);
            request.getSession().setAttribute("error", "Failed to process card action: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/card");
        }
    }

    private void listCards(HttpServletRequest request, HttpServletResponse response, Long customerId, Integer adminId) throws Exception {
        generateCSRFToken(request);
        if (adminId != null) {
            // Admin list
            List<Card> allCards = cardService.getAllCards();
            request.setAttribute("cards", allCards);
            request.getRequestDispatcher("/admin/cards.jsp").forward(request, response);
        } else if (customerId != null) {
            // Customer list
            List<Card> customerCards = cardService.getCustomerCards(customerId);
            List<Account> accounts = accountService.getCustomerAccounts(customerId);
            com.vgb.model.Customer customer = new com.vgb.service.CustomerService().getCustomerById(customerId);
            
            request.setAttribute("cards", customerCards);
            request.setAttribute("accounts", accounts);
            request.setAttribute("customer", customer);
            request.getRequestDispatcher("/customer/cards.jsp").forward(request, response);
        } else {
            redirectToLogin(request, response);
        }
    }

    private void approveCard(HttpServletRequest request, HttpServletResponse response, Integer adminId) throws Exception {
        if (adminId == null) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Unauthorized Access");
            return;
        }
        if (!validateCSRFToken(request)) {
            request.getSession().setAttribute("error", "Security validation check failed: Invalid CSRF Token.");
            response.sendRedirect(request.getContextPath() + "/card");
            return;
        }

        long cardId = Long.parseLong(getParameter(request, "id", "0"));
        if (cardService.approveCard(cardId)) {
            request.getSession().setAttribute("success", "Card applied has been approved successfully and is now active.");
        } else {
            request.getSession().setAttribute("error", "Failed to approve card.");
        }
        response.sendRedirect(request.getContextPath() + "/card");
    }

    private void closeCard(HttpServletRequest request, HttpServletResponse response, Long customerId, Integer adminId) throws Exception {
        if (customerId == null && adminId == null) {
            redirectToLogin(request, response);
            return;
        }
        if (!validateCSRFToken(request)) {
            request.getSession().setAttribute("error", "Security validation check failed: Invalid CSRF Token.");
            response.sendRedirect(request.getContextPath() + "/card");
            return;
        }

        long cardId = Long.parseLong(getParameter(request, "id", "0"));
        Card card = cardService.getCardById(cardId);
        
        if (card == null) {
            request.getSession().setAttribute("error", "Card not found.");
            response.sendRedirect(request.getContextPath() + "/card");
            return;
        }

        // Verify customer owns the card
        if (adminId == null && card.getCustomerId() != customerId) {
            request.getSession().setAttribute("error", "Unauthorized access.");
            response.sendRedirect(request.getContextPath() + "/card");
            return;
        }

        if (cardService.closeCard(cardId)) {
            request.getSession().setAttribute("success", "Card #" + cardId + " has been closed successfully.");
        } else {
            request.getSession().setAttribute("error", "Failed to close card.");
        }
        response.sendRedirect(request.getContextPath() + "/card");
    }

    private void applyCard(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Long customerId = getUserId(request);
        boolean requestFromAdmin = isAdmin(request);

        if (!validateCSRFToken(request)) {
            request.getSession().setAttribute("error", "Security validation check failed: Invalid CSRF Token.");
            response.sendRedirect(request.getContextPath() + "/card");
            return;
        }

        long accountId = Long.parseLong(getParameter(request, "accountId", "0"));
        String accountNumber = getParameter(request, "accountNumber", "");
        String cardType = getParameter(request, "cardType", "");
        String cardProvider = getParameter(request, "cardProvider", "");
        String cardHolderName = getParameter(request, "cardHolderName", "");
        String cardTier = getParameter(request, "cardTier", "classic");

        if (requestFromAdmin) {
            if (accountId != 0) {
                try {
                    Account account = accountService.getAccountById(accountId);
                    if (account != null) {
                        customerId = account.getCustomerId();
                    }
                } catch (Exception e) {
                    logger.error("Failed to find account by ID for admin card application: " + accountId, e);
                }
            } else if (!accountNumber.isEmpty()) {
                try {
                    Account account = accountService.getAccountByNumber(accountNumber);
                    if (account != null) {
                        accountId = account.getAccountId();
                        customerId = account.getCustomerId();
                    }
                } catch (Exception e) {
                    logger.error("Failed to find account by number for admin card application: " + accountNumber, e);
                }
            }
        } else if (accountId == 0 && !accountNumber.isEmpty()) {
            try {
                Account account = accountService.getAccountByNumber(accountNumber);
                if (account != null) {
                    accountId = account.getAccountId();
                }
            } catch (Exception e) {
                logger.error("Failed to find account by number: " + accountNumber, e);
            }
        }

        if (accountId == 0 || cardType.isEmpty() || cardProvider.isEmpty() || cardHolderName.isEmpty()) {
            request.getSession().setAttribute("error", "All fields are required to apply for a card.");
            response.sendRedirect(request.getContextPath() + "/card");
            return;
        }

        if (customerId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            Card card = cardService.applyForCard(customerId, accountId, cardType, cardProvider, cardHolderName, cardTier);
            if (card != null) {
                request.getSession().setAttribute("success", "Card application submitted successfully! Charged card fee of ₹" + card.getCardFee().setScale(2) + ". Awaiting Admin approval.");
            } else {
                request.getSession().setAttribute("error", "Failed to apply for card.");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("error", e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/card");
    }

    private void renewCard(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Long customerId = getUserId(request);
        boolean requestFromAdmin = isAdmin(request);

        if (!requestFromAdmin && customerId == null) {
            redirectToLogin(request, response);
            return;
        }

        if (!validateCSRFToken(request)) {
            request.getSession().setAttribute("error", "Security validation check failed: Invalid CSRF Token.");
            response.sendRedirect(request.getContextPath() + "/card");
            return;
        }

        long cardId = Long.parseLong(getParameter(request, "cardId", "0"));
        long accountId = Long.parseLong(getParameter(request, "accountId", "0"));

        if (cardId == 0) {
            request.getSession().setAttribute("error", "Invalid inputs for card renewal.");
            response.sendRedirect(request.getContextPath() + "/card");
            return;
        }

        try {
            Card card = cardService.getCardById(cardId);
            if (card == null) {
                throw new Exception("Card not found.");
            }
            if (accountId == 0) {
                accountId = card.getAccountId();
            }

            // Verify ownership
            if (!requestFromAdmin && card.getCustomerId() != customerId) {
                request.getSession().setAttribute("error", "Unauthorized access.");
                response.sendRedirect(request.getContextPath() + "/card");
                return;
            }

            if (cardService.renewCard(cardId, accountId)) {
                request.getSession().setAttribute("success", "Card renewal request submitted successfully! Paid renewal fee. Awaiting Admin approval.");
            } else {
                request.getSession().setAttribute("error", "Failed to renew card.");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("error", e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/card");
    }

    private void payDues(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Long customerId = getUserId(request);
        if (customerId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (!validateCSRFToken(request)) {
            request.getSession().setAttribute("error", "Security validation check failed: Invalid CSRF Token.");
            response.sendRedirect(request.getContextPath() + "/card");
            return;
        }

        long cardId = Long.parseLong(getParameter(request, "cardId", "0"));
        long accountId = Long.parseLong(getParameter(request, "accountId", "0"));
        BigDecimal amount = new BigDecimal(getParameter(request, "amount", "0"));

        if (cardId == 0 || accountId == 0 || amount.compareTo(BigDecimal.ZERO) <= 0) {
            request.getSession().setAttribute("error", "Invalid inputs for paying card dues.");
            response.sendRedirect(request.getContextPath() + "/card");
            return;
        }

        try {
            if (cardService.payCreditCardDues(cardId, accountId, amount)) {
                request.getSession().setAttribute("success", "Credit card bill payment of ₹" + amount.setScale(2) + " processed successfully! Card outstanding dues reduced.");
            } else {
                request.getSession().setAttribute("error", "Failed to clear dues.");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("error", e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/card");
    }

    private void updateLimits(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Long customerId = getUserId(request);
        if (customerId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (!validateCSRFToken(request)) {
            request.getSession().setAttribute("error", "Security validation check failed: Invalid CSRF Token.");
            response.sendRedirect(request.getContextPath() + "/card");
            return;
        }

        long cardId = Long.parseLong(getParameter(request, "cardId", "0"));
        BigDecimal dailyLimit = new BigDecimal(getParameter(request, "dailyLimit", "0"));
        BigDecimal atmLimit = new BigDecimal(getParameter(request, "atmLimit", "0"));
        BigDecimal onlineLimit = new BigDecimal(getParameter(request, "onlineLimit", "0"));
        boolean internationalEnabled = "true".equals(getParameter(request, "internationalEnabled", "false"));

        if (cardId == 0) {
            request.getSession().setAttribute("error", "Invalid card ID.");
            response.sendRedirect(request.getContextPath() + "/card");
            return;
        }

        // Verify ownership
        Card card = cardService.getCardById(cardId);
        if (card == null || card.getCustomerId() != customerId) {
            request.getSession().setAttribute("error", "Unauthorized access.");
            response.sendRedirect(request.getContextPath() + "/card");
            return;
        }

        if (dailyLimit.compareTo(BigDecimal.ZERO) < 0 || atmLimit.compareTo(BigDecimal.ZERO) < 0 || onlineLimit.compareTo(BigDecimal.ZERO) < 0) {
            request.getSession().setAttribute("error", "Limits cannot be negative values.");
            response.sendRedirect(request.getContextPath() + "/card");
            return;
        }

        try {
            if (cardService.updateLimits(cardId, dailyLimit, atmLimit, onlineLimit, internationalEnabled)) {
                request.getSession().setAttribute("success", "Card limits updated successfully!");
            } else {
                request.getSession().setAttribute("error", "Failed to update card limits.");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("error", e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/card");
    }
}
