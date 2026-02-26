package com.acebank.lite.controllers;

import com.acebank.lite.dao.BankUserDao;
import com.acebank.lite.dao.BankUserDaoImpl;
import com.acebank.lite.models.AccountRecoveryDTO;
import com.acebank.lite.service.BankService;
import com.acebank.lite.service.BankServiceImpl;
import com.acebank.lite.util.OtpService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.java.Log;

import java.io.IOException;
import java.io.Serial;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Optional;

/**
 * Handles the multi-step Forgot Password flow using OTP verification.
 *
 * Step 1: User enters email → OTP is generated, stored in DB, and emailed
 * Step 2: User enters OTP → Verified against DB (expiry + retry limits)
 * Step 3: User enters new password → Password is updated in DB
 */
@Log
@WebServlet("/ForgotPassword")
public class ForgotPasswordServlet extends HttpServlet {

    @Serial
    private static final long serialVersionUID = 1L;

    private final BankService bankService = new BankServiceImpl();
    private final BankUserDao userDao = new BankUserDaoImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect("ForgotPassword.jsp?error=invalid");
            return;
        }

        switch (action) {
            case "sendOtp" -> handleSendOtp(request, response);
            case "verifyOtp" -> handleVerifyOtp(request, response);
            case "resetPassword" -> handleResetPassword(request, response);
            default -> response.sendRedirect("ForgotPassword.jsp?error=invalid");
        }
    }

    /**
     * Step 1: Validate the email exists, then generate and send OTP.
     */
    private void handleSendOtp(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String email = request.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            response.sendRedirect("ForgotPassword.jsp?error=invalid");
            return;
        }

        try {
            // Check if the email is registered
            Optional<AccountRecoveryDTO> details = userDao.getRecoveryDetails(email);
            if (details.isEmpty()) {
                response.sendRedirect("ForgotPassword.jsp?error=notfound");
                return;
            }

            // Generate and send OTP
            boolean sent = OtpService.generateAndSend(email);

            if (sent) {
                // Move to Step 2: OTP entry
                String encodedEmail = URLEncoder.encode(email, StandardCharsets.UTF_8);
                response.sendRedirect("ForgotPassword.jsp?step=verify&email=" + encodedEmail);
            } else {
                response.sendRedirect("ForgotPassword.jsp?error=sendfailed");
            }

        } catch (Exception e) {
            log.severe("Error in sendOtp: " + e.getMessage());
            response.sendRedirect("ForgotPassword.jsp?error=system");
        }
    }

    /**
     * Step 2: Verify the OTP code entered by the user.
     * Checks expiry and attempt limits.
     */
    private void handleVerifyOtp(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String email = request.getParameter("email");
        String otpCode = request.getParameter("otp");

        if (email == null || otpCode == null) {
            response.sendRedirect("ForgotPassword.jsp?error=invalid");
            return;
        }

        OtpService.OtpResult result = OtpService.verify(email, otpCode);
        String encodedEmail = URLEncoder.encode(email, StandardCharsets.UTF_8);

        switch (result) {
            case SUCCESS -> {
                // Move to Step 3: New password form
                response.sendRedirect("ForgotPassword.jsp?step=reset&email=" + encodedEmail);
            }
            case EXPIRED -> {
                response.sendRedirect("ForgotPassword.jsp?step=verify&email=" + encodedEmail + "&error=expired");
            }
            case MAX_ATTEMPTS -> {
                // Clean up and force restart
                OtpService.cleanup(email);
                response.sendRedirect("ForgotPassword.jsp?error=maxattempts");
            }
            case WRONG_CODE -> {
                response.sendRedirect("ForgotPassword.jsp?step=verify&email=" + encodedEmail + "&error=wrongotp");
            }
            default -> {
                response.sendRedirect("ForgotPassword.jsp?error=notfound");
            }
        }
    }

    /**
     * Step 3: Reset the password after successful OTP verification.
     */
    private void handleResetPassword(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String email = request.getParameter("email");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (email == null || newPassword == null || confirmPassword == null) {
            response.sendRedirect("ForgotPassword.jsp?error=invalid");
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            String encodedEmail = URLEncoder.encode(email, StandardCharsets.UTF_8);
            response.sendRedirect("ForgotPassword.jsp?step=reset&email=" + encodedEmail + "&error=mismatch");
            return;
        }

        if (newPassword.length() < 10) {
            String encodedEmail = URLEncoder.encode(email, StandardCharsets.UTF_8);
            response.sendRedirect("ForgotPassword.jsp?step=reset&email=" + encodedEmail + "&error=tooshort");
            return;
        }

        boolean success = bankService.resetPasswordByEmail(email, newPassword);

        if (success) {
            OtpService.cleanup(email); // Clean up all OTPs
            log.info("Password reset successful for: " + email);
            response.sendRedirect("login.jsp?success=reset");
        } else {
            response.sendRedirect("ForgotPassword.jsp?error=resetfailed");
        }
    }
}
