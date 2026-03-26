package com.acebank.lite.controllers;

import com.acebank.lite.models.*;

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
import java.math.BigDecimal;
import java.util.List;

@Log
@WebServlet("/home") // This is the single entry point for the Dashboard
public class Home extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final BankService bankService = new BankServiceImpl();

    /**
     * GET: Responsible for fetching data and showing the dashboard.
     * Accessing this directly or via redirect will show the Home.jsp.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Security Check
        if (session == null || session.getAttribute("accountNumber") == null) {
            log.warning("Unauthorized access attempt to /home");
            response.sendRedirect("login.jsp");
            return;
        }

        int accountNumber = (int) session.getAttribute("accountNumber");
        String email = (String) session.getAttribute("email");

        try {
            // Always refresh data before painting the UI
            updateSessionData(session, accountNumber, email);

            // Forward to the hidden JSP in WEB-INF
            request.getRequestDispatcher("/WEB-INF/views/Home.jsp").forward(request, response);

        } catch (Exception e) {
            log.severe("Error rendering Home Dashboard: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Dashboard load failed.");
        }
    }

    /**
     * POST: Responsible for processing Actions (Deposit/Transfer).
     * After processing, it REDIRECTS to the GET method.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("accountNumber") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int accountNumber = (int) session.getAttribute("accountNumber");

        // Get form parameters
        String depositAmtStr = request.getParameter("deposit");
        String toAccountStr = request.getParameter("toAccount");
        String toAmountStr = request.getParameter("toAmount");
        String withdrawAmount = request.getParameter("withdraw");

        String redirectUrl = "home"; // Default redirect back to dashboard

        try {
            // --- ACTION 1: DEPOSIT ---
            if (depositAmtStr != null && !depositAmtStr.trim().isEmpty()) {
                BigDecimal amount = new BigDecimal(depositAmtStr);
                boolean status = bankService.processDeposit(accountNumber, amount);
                if (status) {
                    redirectUrl += "?success=Money+credited+to+your+account+from+Deposit";
                } else {
                    redirectUrl += "?error=Deposit+failed";
                }

            }
            // --- ACTION 2: WITHDRAW ---
            else if (withdrawAmount != null && !withdrawAmount.trim().isEmpty()) {
                BigDecimal amount = new BigDecimal(withdrawAmount);
                // Ensure your Service has this method matching the DAO rectification we did
                String status = bankService.withdraw(accountNumber, amount);
                log.info("Withdrawal Status: " + status);
                if ("SUCCESS".equals(status)) {
                    redirectUrl += "?success=Money+debited+from+your+account";
                } else {
                    redirectUrl += "?error=" + status.replace(" ", "+");
                }
            }

            // --- ACTION 3: TRANSFER ---
            else if (toAccountStr != null && toAmountStr != null && !toAccountStr.trim().isEmpty()) {
                int recipientAcc = Integer.parseInt(toAccountStr);
                BigDecimal amount = new BigDecimal(toAmountStr);
                ServiceResponse responseSrv = bankService.processTransfer(accountNumber, recipientAcc, amount);
                if (responseSrv.success()) {
                    redirectUrl += "?success=Transfer+successful.+Money+debited+from+your+account.";
                } else {
                    redirectUrl += "?error=" + responseSrv.message().replace(" ", "+");
                }
            }

        } catch (NumberFormatException e) {
            redirectUrl += "?error=Invalid+Amount+Format";
        } catch (Exception e) {
            log.severe("Transaction Error: " + e.getMessage());
            redirectUrl += "?error=Transaction+could+not+be+completed";
        }

        // The Redirect: This triggers the doGet() and prevents double-form submission
        response.sendRedirect(request.getContextPath() + "/" + redirectUrl);

    }

    private void updateSessionData(HttpSession session, int accountNumber, String email) {
        log.info("Refreshing session data for account: " + accountNumber);
        BigDecimal newBalance = bankService.getBalance(accountNumber);
        List<Transaction> newList = bankService.getTransactionHistory(accountNumber);
        List<LoanRequest> loanRequests = bankService.getLoanRequests(email);

        session.setAttribute("balance", newBalance);
        session.setAttribute("transactionDetailsList", newList);
        session.setAttribute("loanRequestsList", loanRequests);
    }
}