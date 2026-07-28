package com.vgb.filter;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class CSRFFilterTest {

    @Test
    @DisplayName("Verify CSRFFilter instantiation")
    void testFilterInitialization() {
        CSRFFilter filter = new CSRFFilter();
        assertNotNull(filter);
    }
}
