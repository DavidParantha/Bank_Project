package com.acebank.lite.models;

import java.util.Optional;

public record SignupResponse(
        boolean success,
        String message,
        Optional<LoginResult> details) {
}
