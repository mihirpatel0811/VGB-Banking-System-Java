package com.vgb.filter;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class AdminSecurityFilterTest {

    @Test
    @DisplayName("Verify AdminSecurityFilter instantiation")
    void testFilterInitialization() {
        AdminSecurityFilter filter = new AdminSecurityFilter();
        assertNotNull(filter);
    }
}
