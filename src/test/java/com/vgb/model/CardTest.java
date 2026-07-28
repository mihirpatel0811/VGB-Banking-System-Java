package com.vgb.model;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;

import static org.junit.jupiter.api.Assertions.*;

public class CardTest {

    @Test
    @DisplayName("Test Card model properties")
    void testCardModel() {
        Card card = new Card();
        card.setCardId(301L);
        card.setAccountId(1001L);
        card.setCardNumber("4532000011112222");
        card.setCardType("debit");
        card.setDailyLimit(new BigDecimal("50000.00"));
        card.setStatus("active");
        card.setCvv("123");

        assertEquals(301L, card.getCardId());
        assertEquals("4532000011112222", card.getCardNumber());
        assertEquals("debit", card.getCardType());
        assertEquals("active", card.getStatus());
        assertEquals("123", card.getCvv());
    }
}
