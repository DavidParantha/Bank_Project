package com.acebank.lite.controllers;

import com.acebank.lite.models.SignupResponse;
import com.acebank.lite.models.User;
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
import java.util.ArrayList;

@Log
@WebServlet("/signup")
public class SignUp extends HttpServlet {
    @Serial
    private static final long serialVersionUID = 1L;

    private final BankService bankService = new BankServiceImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String aadharStr = request.getParameter("aadharNumber");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            User newUser = new User(null, firstName, lastName, aadharStr, email, password, null);
            SignupResponse signupResponse = bankService.registerUser(newUser);

            if (signupResponse.success()) {
                var details = signupResponse.details().get();
                HttpSession session = request.getSession();

                session.setAttribute("accountNumber", details.accountNumber());
                session.setAttribute("firstName", details.firstName());
                session.setAttribute("email", details.email());
                session.setAttribute("balance", details.balance());
                session.setAttribute("transactionDetailsList", new ArrayList<>());

                response.sendRedirect(request.getContextPath() + "/home?welcome=true");
            } else {
                request.setAttribute("signupError", signupResponse.message());
                request.getRequestDispatcher("sign-up.jsp").forward(request, response);
            }

        } catch (Exception e) {
            log.severe("SignUp Servlet Error: " + e.getMessage());
            request.setAttribute("errorTitle", "System Error");
            request.setAttribute("errorMessage", "An unexpected error occurred. Please try again later.");
            request.setAttribute("errorCode", 500);
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("sign-up.jsp");
    }
}