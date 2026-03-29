package com.acebank.lite.controllers;

import com.acebank.lite.service.BankService;
import com.acebank.lite.service.BankServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.extern.java.Log;

import java.io.IOException;
import java.io.Serial;
import java.math.BigDecimal;

/**
 * Handles loan application submissions.
 * Saves the request to the LOAN_REQUESTS table and sends a confirmation email.
 * Requires the user to be logged in.
 */
@Log
@WebServlet("/loan-request")
public class LoanRequestServlet extends HttpServlet {

    @Serial
    private static final long serialVersionUID = 1L;

    private final BankService bankService = new BankServiceImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Guard: Must be logged in
        if (session == null || session.getAttribute("accountNumber") == null) {
            response.sendRedirect("login.jsp?error=unauthorized");
            return;
        }

        // Extract form parameters
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String loanType = request.getParameter("loanType");
        String amountStr = request.getParameter("amount");

        // Validation
        if (fullName == null || email == null || loanType == null || amountStr == null
                || fullName.trim().isEmpty() || email.trim().isEmpty()) {
            response.sendRedirect("LoanRequest.jsp?error=missing");
            return;
        }

        try {
            BigDecimal amount = new BigDecimal(amountStr);

            if (amount.compareTo(BigDecimal.ZERO) <= 0) {
                response.sendRedirect("LoanRequest.jsp?error=invalidamount");
                return;
            }

            // Save to DB and send email via service
            boolean success = bankService.saveLoanRequest(fullName, email, phone, loanType, amount);

            if (success) {
                log.info("Loan request saved for: " + email + " | Type: " + loanType);
                response.sendRedirect("LoanRequest.jsp?success=Loan+application+submitted+successfully");
            } else {
                response.sendRedirect("LoanRequest.jsp?error=failed");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect("LoanRequest.jsp?error=invalidamount");
        } catch (Exception e) {
            log.severe("Loan request error: " + e.getMessage());
            response.sendRedirect("LoanRequest.jsp?error=system");
        }
    }
}
