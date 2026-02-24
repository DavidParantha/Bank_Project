package com.acebank.lite.controllers;

import java.io.IOException;
import java.io.Serial;
import java.util.List;
import java.util.Optional;

import com.acebank.lite.dao.BankUserDao;
import com.acebank.lite.dao.BankUserDaoImpl;
import com.acebank.lite.models.LoginResult;
import com.acebank.lite.models.Transaction;
import com.acebank.lite.service.BankService;
import com.acebank.lite.service.BankServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import lombok.extern.java.Log;

@Log
@WebServlet(name = "Login", urlPatterns = "/Login")
public class Login extends HttpServlet {

    @Serial
    private static final long serialVersionUID = 1L;

    private final BankService bankService = new BankServiceImpl();
    private final BankUserDao userDao = new BankUserDaoImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accStr = request.getParameter("accountNumber");
        String password = request.getParameter("password");
        // String rememberMe = request.getParameter("rememberMe");

        try {

            // ✅ Validate input first
            if (accStr == null || accStr.trim().isEmpty()) {
                request.setAttribute("errorTitle", "Login Failed");
                request.setAttribute("errorMessage", "Account number is required.");
                request.setAttribute("errorCode", 400);
                request.getRequestDispatcher("error.jsp").forward(request, response);
                return;
            }

            // ✅ Reject email explicitly (prevents 500)
            if (accStr.contains("@")) {
                request.setAttribute("errorTitle", "Login Failed");
                request.setAttribute("errorMessage", "Please login using your Account Number, not Email.");
                request.setAttribute("errorCode", 400);
                request.getRequestDispatcher("error.jsp").forward(request, response);
                return;
            }

            int accountNo;

            try {
                accountNo = Integer.parseInt(accStr);
            } catch (NumberFormatException nfe) {
                request.setAttribute("errorTitle", "Login Failed");
                request.setAttribute("errorMessage", "Account number must be numeric.");
                request.setAttribute("errorCode", 400);
                request.getRequestDispatcher("error.jsp").forward(request, response);
                return;
            }

            // 1. Authenticate via Service
            Optional<LoginResult> loginResultOpt = bankService.authenticate(accountNo, password);

            if (loginResultOpt.isPresent()) {
                var details = loginResultOpt.get();
                HttpSession session = request.getSession(true);

                // 2. Populate Session Attributes
                session.setAttribute("accountNumber", accountNo);
                session.setAttribute("firstName", details.firstName());
                session.setAttribute("lastName", details.lastName());
                session.setAttribute("email", details.email());
                session.setAttribute("balance", details.balance());

                // 3. Fetch Transaction History for the Dashboard
                List<Transaction> statement = userDao.getStatement(accountNo);
                session.setAttribute("transactionDetailsList", statement);

                log.info("User " + accountNo + " logged in successfully.");

                // PRG Pattern
                response.sendRedirect(request.getContextPath() + "/home");
            } else {
                log.warning("Authentication failed for account: " + accStr);
                request.setAttribute("errorTitle", "Login Failed");
                request.setAttribute("errorMessage", "Invalid account number or password. Please try again.");
                request.setAttribute("errorCode", 401);
                request.getRequestDispatcher("error.jsp").forward(request, response);
            }

        } catch (Exception e) {
            log.severe("Login Error: \n" + e.getMessage());
            request.setAttribute("errorTitle", "System Error");
            request.setAttribute("errorMessage",
                    "We encountered an unexpected error while trying to log you in. Please try again later.");
            request.setAttribute("errorCode", 500);
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("Login.jsp");
    }
}