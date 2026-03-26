package com.acebank.lite.controllers;

import com.acebank.lite.models.Transaction;
import com.acebank.lite.util.MailUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.extern.java.Log;

import java.io.IOException;
import java.io.Serial;
import java.time.format.DateTimeFormatter;
import java.util.List;

/**
 * Sends the user's transaction history to their registered email.
 * Formats it as a clean text document.
 */
@Log
@WebServlet("/SendStatement")
public class SendStatementServlet extends HttpServlet {

    @Serial
    private static final long serialVersionUID = 1L;

    private static final DateTimeFormatter DATE_FMT = DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm");

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("accountNumber") == null) {
            response.sendRedirect("login.jsp?error=unauthorized");
            return;
        }

        String email = (String) session.getAttribute("email");
        String firstName = (String) session.getAttribute("firstName");
        String lastName = (String) session.getAttribute("lastName");
        int accountNumber = (int) session.getAttribute("accountNumber");

        @SuppressWarnings("unchecked")
        List<Transaction> transactions = (List<Transaction>) session.getAttribute("transactionDetailsList");

        if (email == null || email.isBlank()) {
            response.sendRedirect("home?error=No+email+on+file");
            return;
        }

        // Build the statement document
        StringBuilder doc = new StringBuilder();
        doc.append("==============================================\n");
        doc.append("        ACEBANK - TRANSACTION STATEMENT       \n");
        doc.append("==============================================\n\n");
        doc.append("Account Holder : ").append(firstName).append(" ").append(lastName).append("\n");
        doc.append("Account Number : ").append(accountNumber).append("\n");
        doc.append("Email          : ").append(email).append("\n");
        doc.append("Generated On   : ").append(java.time.LocalDateTime.now().format(DATE_FMT)).append("\n\n");
        doc.append("----------------------------------------------\n");
        doc.append(String.format("%-20s %-12s %-15s %s\n", "Date", "Type", "Reference", "Amount"));
        doc.append("----------------------------------------------\n");

        if (transactions != null && !transactions.isEmpty()) {
            for (Transaction tx : transactions) {
                String date = tx.createdAt() != null ? tx.createdAt().format(DATE_FMT) : "N/A";
                String type = tx.txType();
                String ref;
                if ("TRANSFER".equals(type)) {
                    if (tx.senderAccount() == accountNumber) {
                        ref = "To " + tx.receiverAccount();
                    } else {
                        ref = "From " + tx.senderAccount();
                    }
                } else {
                    ref = tx.remark() != null ? tx.remark() : "-";
                }
                String amount = "Rs. " + tx.amount();
                doc.append(String.format("%-20s %-12s %-15s %s\n", date, type, ref, amount));
            }
        } else {
            doc.append("  No transactions found.\n");
        }

        doc.append("----------------------------------------------\n\n");
        doc.append("This is a system-generated statement from AceBank.\n");
        doc.append("For queries, contact support@acebank.com\n");
        doc.append("==============================================\n");

        // Send the email asynchronously
        String subject = "Your AceBank Transaction Statement - Account #" + accountNumber;
        MailUtil.sendMailAsync(email, subject, doc.toString());

        log.info("Statement email queued for: " + email);
        response.sendRedirect(request.getContextPath() + "/home?success=Transaction+statement+sent+to+your+registered+email!");
    }
}
