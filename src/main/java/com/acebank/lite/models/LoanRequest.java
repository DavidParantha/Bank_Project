package com.acebank.lite.models;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public record LoanRequest(
        int id,
        String fullName,
        String email,
        String phone,
        String loanType,
        BigDecimal amount,
        String status,
        LocalDateTime createdAt) {
}
