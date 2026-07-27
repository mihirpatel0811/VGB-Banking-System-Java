package com.vgb.util;

import com.vgb.model.Account;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public final class AccountContextUtil {
    public static final String SESSION_ACCOUNT_ID = "accountId";

    private AccountContextUtil() {
    }

    public static Account resolveActiveAccount(HttpSession session, List<Account> accounts) {
        if (accounts == null || accounts.isEmpty()) {
            return null;
        }

        Long activeAccountId = getSessionAccountId(session);
        Account fallback = null;

        for (Account account : accounts) {
            if (account == null || "closed".equalsIgnoreCase(account.getStatus())) {
                continue;
            }
            if (fallback == null) {
                fallback = account;
            }
            if (activeAccountId != null && account.getAccountId() == activeAccountId.longValue()) {
                return account;
            }
        }

        storeActiveAccount(session, fallback);
        return fallback;
    }

    public static List<Account> filterOpenAccounts(List<Account> accounts) {
        if (accounts == null || accounts.isEmpty()) {
            return Collections.emptyList();
        }
        List<Account> openList = new ArrayList<>();
        for (Account acc : accounts) {
            if (acc != null && !"closed".equalsIgnoreCase(acc.getStatus())) {
                openList.add(acc);
            }
        }
        return openList;
    }

    public static Long getSessionAccountId(HttpSession session) {
        if (session == null) {
            return null;
        }

        Object value = session.getAttribute(SESSION_ACCOUNT_ID);
        if (value instanceof Number) {
            return ((Number) value).longValue();
        }
        if (value instanceof String) {
            try {
                return Long.parseLong(((String) value).trim());
            } catch (NumberFormatException ignored) {
                return null;
            }
        }
        return null;
    }

    public static void storeActiveAccount(HttpSession session, Account activeAccount) {
        if (session != null && activeAccount != null) {
            session.setAttribute(SESSION_ACCOUNT_ID, activeAccount.getAccountId());
        }
    }

    public static List<Account> onlyActiveAccount(List<Account> accounts, Account activeAccount) {
        if (accounts == null || accounts.isEmpty() || activeAccount == null) {
            return Collections.emptyList();
        }

        List<Account> activeOnly = new ArrayList<>();
        for (Account account : accounts) {
            if (account != null && account.getAccountId() == activeAccount.getAccountId()) {
                activeOnly.add(account);
                break;
            }
        }
        return activeOnly;
    }

    public static BigDecimal getBalance(Account account) {
        return account != null && account.getBalance() != null ? account.getBalance() : BigDecimal.ZERO;
    }
}
