<% response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate" ); response.setHeader("Pragma", "no-cache"
    ); response.setDateHeader("Expires", 0); %>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Dashboard | AceBank</title>
                <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/main.css" />
            </head>

            <body>

                <header class="navbar">
                    <div class="brand">Ace<span>Bank</span></div>
                    <nav class="nav-actions">
                        <a href="<%= request.getContextPath() %>/index.jsp"><i data-lucide="home"
                                class="icon-inline"></i>Home</a>
                        <a href="<%= request.getContextPath() %>/ChangePassword.jsp"><i data-lucide="key-round"
                                class="icon-inline"></i>Change Password</a>
                        <button onclick="toggleTheme()" class="btn secondary"><i data-lucide="sun-moon"
                                style="width:16px;height:16px;vertical-align:-2px;margin-right:4px;"></i> Theme</button>
                        <a href="<%= request.getContextPath() %>/Logout" class="btn danger" style="font-size:13px;"><i
                                data-lucide="log-out"
                                style="width:14px;height:14px;vertical-align:-2px;margin-right:4px;"></i>Logout</a>
                    </nav>
                </header>

                <main class="container fade-in-up">

                    <!-- Profile Header -->
                    <section class="card card-animate" style="margin-bottom: 20px;">
                        <div class="profile-header">
                            <div>
                                <h2>Hello, ${sessionScope.firstName}</h2>
                                <p class="badge" style="margin-top: 8px;"><i data-lucide="hash"
                                        style="width:12px;height:12px;vertical-align:-1px;margin-right:2px;"></i>Account:
                                    ${sessionScope.accountNumber}</p>
                            </div>
                            <i data-lucide="landmark" class="icon-profile"></i>
                        </div>
                    </section>

                    <div class="grid">
                        <!-- Balance Card -->
                        <div class="card card-animate">
                            <div class="balance">
                                <div>
                                    <h3><i data-lucide="wallet" class="icon-inline"></i>Total Balance</h3>
                                    <p class="muted">Available for transactions</p>
                                </div>
                                <span class="badge"
                                    style="background: rgba(34,197,94,.15); color: #22c55e; border-color: rgba(34,197,94,.3);">
                                    <i data-lucide="check-circle"
                                        style="width:12px;height:12px;vertical-align:-1px;margin-right:2px;"></i>Active
                                </span>
                            </div>
                            <div class="amount" style="margin-top: 16px;">
                                ₹ <span id="balance-counter">${sessionScope.balance}</span>
                            </div>
                        </div>

                        <!-- Quick Deposit -->
                        <div class="card card-animate">
                            <h3><i data-lucide="plus-circle" class="icon-inline"></i> Quick Deposit</h3>
                            <p class="muted" style="margin-bottom: 12px;">Add money to your account instantly</p>
                            <form action="home" method="post" class="form">
                                <input type="number" step="0.01" min="1" name="deposit" placeholder="Amount (₹)"
                                    required />
                                <button class="btn success" type="submit"><i data-lucide="arrow-down-circle"
                                        style="width:16px;height:16px;vertical-align:-2px;margin-right:4px;"></i>Add</button>
                            </form>
                        </div>

                        <!-- Send Money -->
                        <div class="card card-animate">
                            <h3><i data-lucide="send" class="icon-inline"></i> Send Money</h3>
                            <p class="muted" style="margin-bottom: 12px;">Transfer to another AceBank account</p>
                            <form action="home" method="post" class="form" style="grid-template-columns: 1fr 1fr auto;">
                                <input type="number" name="toAccount" placeholder="Recipient Acc No" required />
                                <input type="number" step="0.01" min="1" name="toAmount" placeholder="Amount (₹)"
                                    required />
                                <button class="btn" type="submit"><i data-lucide="arrow-right-circle"
                                        style="width:16px;height:16px;vertical-align:-2px;margin-right:4px;"></i>Send</button>
                            </form>
                        </div>

                        <!-- Withdraw -->
                        <div class="card card-animate">
                            <h3><i data-lucide="banknote" class="icon-inline"></i> Withdraw Money</h3>
                            <p class="muted" style="margin-bottom: 12px;">Daily limit: ₹500.00</p>
                            <form action="home" method="post" class="form">
                                <input type="number" step="0.01" min="1" name="withdraw" placeholder="Amount (₹)"
                                    required />
                                <button class="btn danger" type="submit"><i data-lucide="arrow-up-circle"
                                        style="width:16px;height:16px;vertical-align:-2px;margin-right:4px;"></i>Withdraw</button>
                            </form>
                        </div>
                    </div>

                    <!-- Transactions -->
                    <section class="card card-animate" style="margin-top: 20px;">
                        <div class="footer-actions" style="margin-top: 0; margin-bottom: 8px;">
                            <h3><i data-lucide="clipboard-list" class="icon-inline"></i> Recent Transactions</h3>
                        </div>

                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Date</th>
                                    <th>Type</th>
                                    <th>Reference</th>
                                    <th>Amount</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty sessionScope.transactionDetailsList}">
                                        <c:forEach var="tx" items="${sessionScope.transactionDetailsList}">
                                            <tr>
                                                <td>${tx.createdAt()}</td>
                                                <td><span class="tag ${tx.txType().toLowerCase()}">${tx.txType()}</span>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${tx.txType() == 'TRANSFER'}">
                                                            ${tx.senderAccount() == sessionScope.accountNumber ? 'To' :
                                                            'From'}
                                                            ${tx.senderAccount() == sessionScope.accountNumber ?
                                                            tx.receiverAccount() : tx.senderAccount()}
                                                        </c:when>
                                                        <c:otherwise>
                                                            ${tx.remark()}
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td style="font-weight: 600;">₹ ${tx.amount()}</td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="4"
                                                style="text-align:center; padding: 32px; color: var(--muted);">
                                                <i data-lucide="inbox"
                                                    style="width:24px;height:24px;display:block;margin:0 auto 8px;opacity:.5;"></i>
                                                No transactions yet. Make your first deposit!
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </section>

                </main>

                <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.min.js"></script>
                <script src="<%= request.getContextPath() %>/assets/js/ui.js"></script>
            </body>

            </html>