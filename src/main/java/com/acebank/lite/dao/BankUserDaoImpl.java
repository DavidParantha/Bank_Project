package com.acebank.lite.dao;

import com.acebank.lite.models.AccountRecoveryDTO;
import com.acebank.lite.models.LoginResult;
import com.acebank.lite.models.Transaction;
import com.acebank.lite.models.User;
import com.acebank.lite.models.LoanRequest;
import com.acebank.lite.util.ConnectionManager;
import com.acebank.lite.util.QueryLoader;

import java.sql.*;
import java.util.Optional;

import lombok.extern.java.Log;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Log
public class BankUserDaoImpl implements BankUserDao {

    @Override
    public String getPasswordHash(int accountNo) throws SQLException {
        String sql = QueryLoader.get("user.get_password_by_acc");

        try (Connection conn = getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, accountNo);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("PASSWORD_HASH");
                }
            }
        }
        return null; // Account not found
    }

    private Connection getConnection() throws SQLException {
        return ConnectionManager.getConnection();
    }

    @Override
    public boolean login(int accountNo, String password) throws SQLException {
        try (Connection conn = getConnection();
                PreparedStatement pstmt = conn.prepareStatement(QueryLoader.get("user.login"))) {
            pstmt.setInt(1, accountNo);
            pstmt.setString(2, password);
            ResultSet rs = pstmt.executeQuery();
            return rs.next();
        }
    }

    @Override
    public LoginResult getUserDetails(int accountNo) throws SQLException {
        String sql = QueryLoader.get("user.get_details");

        try (Connection conn = getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, accountNo);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return new LoginResult(
                            rs.getString("FIRST_NAME"),
                            rs.getString("LAST_NAME"),
                            rs.getString("EMAIL"),
                            rs.getBigDecimal("BALANCE"),
                            rs.getInt("ACCOUNT_NO"));
                }
            }
        }
        throw new SQLException("User details not found for account: " + accountNo);
    }

    @Override
    public boolean signUp(User user, int accountNo) throws SQLException {
        try (Connection conn = getConnection()) {
            try {
                conn.setAutoCommit(false);

                PreparedStatement ps1 = conn.prepareStatement(QueryLoader.get("user.signup"),
                        Statement.RETURN_GENERATED_KEYS);
                ps1.setString(1, user.firstName());
                ps1.setString(2, user.lastName());
                ps1.setString(3, user.aadhaarNo());
                ps1.setString(4, user.email());
                ps1.setString(5, user.passwordHash());
                ps1.executeUpdate();

                ResultSet rs = ps1.getGeneratedKeys();
                if (rs.next()) {
                    PreparedStatement ps2 = conn.prepareStatement(QueryLoader.get("account.create"));
                    ps2.setInt(1, accountNo);
                    ps2.setInt(2, rs.getInt(1));
                    ps2.executeUpdate();
                }
                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                return false;
            }
        }
    }

    @Override
    public BigDecimal getDailyWithdrawalTotal(int accountNo) throws SQLException {
        String sql = QueryLoader.get("transaction.get_daily_withdrawal_total");
        try (Connection conn = getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, accountNo);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                BigDecimal total = rs.getBigDecimal(1);
                return total != null ? total : BigDecimal.ZERO;
            }
        }
        return BigDecimal.ZERO;
    }

    @Override
    public boolean withdraw(int accountNo, BigDecimal amount) throws SQLException {
        try (Connection conn = getConnection()) {
            try {
                conn.setAutoCommit(false); // Start transaction

                // 1. Deduct the balance
                try (PreparedStatement psUpdate = conn.prepareStatement(QueryLoader.get("account.withdraw_balance"))) {
                    psUpdate.setBigDecimal(1, amount);
                    psUpdate.setInt(2, accountNo);
                    psUpdate.setBigDecimal(3, amount); // Check balance >= amount in SQL

                    int rows = psUpdate.executeUpdate();
                    if (rows == 0) {
                        throw new SQLException("Insufficient funds or invalid account.");
                    }
                }

                // 2. Record in Transactions table
                try (PreparedStatement psLog = conn.prepareStatement(QueryLoader.get("transaction.log_withdrawal"))) {
                    psLog.setInt(1, accountNo);
                    psLog.setInt(2, accountNo); // Withdrawals involve only one account
                    psLog.setBigDecimal(3, amount);
                    psLog.executeUpdate();
                }

                conn.commit(); // Save both changes
                return true;
            } catch (SQLException e) {
                conn.rollback(); // Undo everything if any step fails
                log.severe("Withdrawal failed for " + accountNo + ": " + e.getMessage());
                throw e;
            }
        }
    }

    @Override
    public boolean transfer(int fromAcc, int toAcc, BigDecimal amount) throws SQLException {
        // Use try-with-resources for the connection to ensure it always closes
        try (Connection conn = getConnection()) {
            try {
                conn.setAutoCommit(false); // TRANSACTION START

                // 1. Debit from Sender (Using 'account.withdraw' from your YAML)
                try (PreparedStatement ps1 = conn.prepareStatement(QueryLoader.get("account.withdraw"))) {
                    ps1.setBigDecimal(1, amount);
                    ps1.setInt(2, fromAcc);
                    ps1.setBigDecimal(3, amount); // The third '?' is for BALANCE >= ?
                    int rowsAffected = ps1.executeUpdate();

                    // If 0 rows affected, it means insufficient balance!
                    if (rowsAffected == 0) {
                        conn.rollback();
                        return false;
                    }
                }

                // 2. Credit to Recipient (Using 'account.deposit' from your YAML)
                try (PreparedStatement ps2 = conn.prepareStatement(QueryLoader.get("account.deposit"))) {
                    ps2.setBigDecimal(1, amount);
                    ps2.setInt(2, toAcc);
                    ps2.executeUpdate();
                }

                // 3. Log the Transaction (Using 'transaction.log' from your YAML)
                try (PreparedStatement ps3 = conn.prepareStatement(QueryLoader.get("transaction.log"))) {
                    ps3.setInt(1, fromAcc);
                    ps3.setInt(2, toAcc);
                    ps3.setBigDecimal(3, amount);
                    ps3.setString(4, "TRANSFER");
                    ps3.setString(5, "Transfer to " + toAcc); // Added missing 5th parameter for REMARK
                    ps3.executeUpdate();
                }

                conn.commit(); // TRANSACTION SUCCESS
                return true;
            } catch (SQLException e) {
                conn.rollback(); // TRANSACTION REVERT
                log.severe("Transfer failed: " + e.getMessage());
                throw e;
            }
        }
    }

    @Override
    public List<Transaction> getStatement(int accountNo) throws SQLException {
        List<Transaction> txList = new ArrayList<>();
        try (Connection conn = getConnection();
                PreparedStatement pstmt = conn.prepareStatement(QueryLoader.get("transaction.statement"))) {
            pstmt.setInt(1, accountNo);
            pstmt.setInt(2, accountNo);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                txList.add(new Transaction(
                        rs.getInt("ID"), rs.getInt("SENDER_ACCOUNT"), rs.getInt("RECEIVER_ACCOUNT"),
                        rs.getBigDecimal("AMOUNT"), rs.getString("TX_TYPE"), rs.getString("REMARK"),
                        rs.getTimestamp("CREATED_AT").toLocalDateTime()));
            }
        }
        return txList;
    }

    @Override
    public boolean deposit(int accountNo, BigDecimal amount) throws SQLException {
        try (Connection conn = getConnection()) {
            try {
                conn.setAutoCommit(false);
                PreparedStatement ps1 = conn.prepareStatement(QueryLoader.get("account.deposit"));
                ps1.setBigDecimal(1, amount);
                ps1.setInt(2, accountNo);
                ps1.executeUpdate();

                PreparedStatement ps2 = conn.prepareStatement(QueryLoader.get("transaction.log"));
                ps2.setInt(1, accountNo);
                ps2.setInt(2, accountNo);
                ps2.setBigDecimal(3, amount);
                ps2.setString(4, "DEPOSIT");
                ps2.setString(5, "Self");
                ps2.executeUpdate();

                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                return false;
            }
        }
    }

    @Override
    public boolean changePassword(int accountNo, String oldPw, String newPw) throws SQLException {
        try (Connection conn = getConnection()) {
            // Use the correct query key: account.check_pw
            PreparedStatement ps1 = conn.prepareStatement(QueryLoader.get("account.check_pw"));
            ps1.setInt(1, accountNo);
            ResultSet rs = ps1.executeQuery();
            if (rs.next() && rs.getString("PASSWORD_HASH").equals(oldPw)) {
                // update_password expects (hash, accountNo)
                PreparedStatement ps2 = conn.prepareStatement(QueryLoader.get("user.update_password"));
                ps2.setString(1, newPw);
                ps2.setInt(2, accountNo);
                return ps2.executeUpdate() > 0;
            }
            return false;
        }
    }

    @Override
    public Optional<AccountRecoveryDTO> getRecoveryDetails(String email) throws SQLException {
        String sql = QueryLoader.get("user.recover_details");
        try (Connection conn = getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return Optional.of(new AccountRecoveryDTO(
                        rs.getString("FIRST_NAME"),
                        rs.getString("LAST_NAME"),
                        rs.getInt("ACCOUNT_NO")));
            }
        }
        return Optional.empty();
    }

    @Override
    public boolean accountExists(int accountNo) throws SQLException {
        String sql = "SELECT 1 FROM ACCOUNTS WHERE ACCOUNT_NO = ?";
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, accountNo);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    @Override
    public BigDecimal getBalance(int accountNo) throws SQLException {
        String sql = QueryLoader.get("account.get_balance");
        try (Connection conn = getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, accountNo);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal("BALANCE");
                }
            }
        }
        return BigDecimal.ZERO;
    }

    @Override
    public boolean resetPasswordByEmail(String email, String newHash) throws SQLException {
        String sql = QueryLoader.get("user.update_password_by_email");
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newHash);
            ps.setString(2, email);
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean saveLoanRequest(String fullName, String email, String phone, String loanType, BigDecimal amount)
            throws SQLException {
        String sql = QueryLoader.get("loan.insert");
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fullName);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setString(4, loanType);
            ps.setBigDecimal(5, amount);
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean emailExists(String email) throws SQLException {
        String sql = "SELECT 1 FROM USERS WHERE EMAIL = ?";
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    @Override
    public boolean aadhaarExists(String aadhaar) throws SQLException {
        String sql = "SELECT 1 FROM USERS WHERE AADHAAR_NO = ?";
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, aadhaar);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    @Override
    public Optional<Integer> getAccountNumberByEmail(String email) throws SQLException {
        String sql = "SELECT a.ACCOUNT_NO FROM ACCOUNTS a JOIN USERS u ON a.USER_ID = u.USER_ID WHERE u.EMAIL = ?";
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(rs.getInt("ACCOUNT_NO"));
                }
            }
        }
        return Optional.empty();
    }

    @Override
    public List<LoanRequest> getLoanRequestsRecord(String email) throws SQLException {
        List<LoanRequest> loanRequests = new ArrayList<>();
        String sql = QueryLoader.get("loan.get_by_email");
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    loanRequests.add(new LoanRequest(
                            rs.getInt("ID"),
                            rs.getString("FULL_NAME"),
                            rs.getString("EMAIL"),
                            rs.getString("PHONE"),
                            rs.getString("LOAN_TYPE"),
                            rs.getBigDecimal("AMOUNT"),
                            rs.getString("STATUS"),
                            rs.getTimestamp("CREATED_AT").toLocalDateTime()));
                }
            }
        }
        return loanRequests;
    }
}