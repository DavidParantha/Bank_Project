package com.acebank.lite.service;

import com.acebank.lite.models.LoginResult;
import com.acebank.lite.models.ServiceResponse;
import com.acebank.lite.models.SignupResponse;
import com.acebank.lite.models.Transaction;
import com.acebank.lite.models.User;
import com.acebank.lite.models.LoanRequest;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public interface BankService {
    Optional<LoginResult> authenticate(String loginId, String password) throws SQLException;

    boolean changePassword(int accountNo, String oldPlain, String newPlain) throws SQLException;

    boolean processDeposit(int accountNo, BigDecimal amount);

    BigDecimal getBalance(int accountNo);

    List<Transaction> getTransactionHistory(int accountNo);

    ServiceResponse processTransfer(int fromAcc, int toAcc, BigDecimal amount);

    String withdraw(int accountNo, BigDecimal amount);

    SignupResponse registerUser(User user);

    public boolean recoverAccount(String email);

    public boolean applyForLoan(String firstName, String email, String loanType);

    boolean resetPasswordByEmail(String email, String newPlainPassword);

    boolean saveLoanRequest(String fullName, String email, String phone, String loanType, java.math.BigDecimal amount);

    List<LoanRequest> getLoanRequests(String email);
}