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
                request.setAttribute("loginError", "Account Number or Email is required.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            // 1. Authenticate via Service (handles both Acc No and Email)
            Optional<LoginResult> loginResultOpt = bankService.authenticate(accStr, password);

            if (loginResultOpt.isPresent()) {
                var details = loginResultOpt.get();
                HttpSession session = request.getSession(true);
                int accountNo = details.accountNumber();

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
                log.warning("Authentication failed for login ID: " + accStr);
                request.setAttribute("loginError", "Invalid credentials. Please try again.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
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