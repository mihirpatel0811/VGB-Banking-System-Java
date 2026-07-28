package com.vgb.util;

import com.vgb.model.Account;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

public class AccountContextUtilTest {

    @Test
    @DisplayName("Test resolveActiveAccount fallback when session is empty")
    void testResolveActiveAccountFallback() {
        List<Account> accounts = new ArrayList<>();
        Account acc1 = new Account();
        acc1.setAccountId(101L);
        acc1.setAccountType("savings");
        acc1.setStatus("active");
        acc1.setBalance(new BigDecimal("5000.00"));

        Account acc2 = new Account();
        acc2.setAccountId(102L);
        acc2.setAccountType("checking");
        acc2.setStatus("closed");
        acc2.setBalance(new BigDecimal("0.00"));

        accounts.add(acc1);
        accounts.add(acc2);

        Account resolved = AccountContextUtil.resolveActiveAccount(null, accounts);
        assertNotNull(resolved);
        assertEquals(101L, resolved.getAccountId());
    }

    @Test
    @DisplayName("Test filterOpenAccounts excludes closed accounts")
    void testFilterOpenAccounts() {
        List<Account> accounts = new ArrayList<>();
        Account openAcc = new Account();
        openAcc.setAccountId(1L);
        openAcc.setStatus("active");

        Account closedAcc = new Account();
        closedAcc.setAccountId(2L);
        closedAcc.setStatus("closed");

        accounts.add(openAcc);
        accounts.add(closedAcc);

        List<Account> openOnly = AccountContextUtil.filterOpenAccounts(accounts);
        assertEquals(1, openOnly.size());
        assertEquals(1L, openOnly.get(0).getAccountId());
    }

    @Test
    @DisplayName("Test getBalance returns balance or zero for null account")
    void testGetBalance() {
        Account acc = new Account();
        acc.setBalance(new BigDecimal("1250.75"));
        assertEquals(new BigDecimal("1250.75"), AccountContextUtil.getBalance(acc));

        Account nullBalanceAcc = new Account();
        assertEquals(BigDecimal.ZERO, AccountContextUtil.getBalance(nullBalanceAcc));

        assertEquals(BigDecimal.ZERO, AccountContextUtil.getBalance(null));
    }
}
