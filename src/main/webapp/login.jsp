<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Login | AceBank</title>
            <meta name="description" content="Log in to your AceBank account to manage your finances." />
            <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/main.css" />
        </head>

        <body>

            <header class="navbar">
                <div class="brand">Ace<span>Bank</span></div>
                <div class="nav-actions">
                    <a href="<%= request.getContextPath() %>/index.jsp"><i data-lucide="home"
                            class="icon-inline"></i>Home</a>
                    <a href="<%= request.getContextPath() %>/sign-up.jsp" class="btn"><i data-lucide="user-plus"
                            style="width:16px;height:16px;vertical-align:-2px;margin-right:4px;"></i>Join Now</a>
                </div>
            </header>

            <main class="auth-page">
                <div class="card auth-card">
                    <div class="auth-header">
                        <i data-lucide="log-in" class="icon-auth"></i>
                        <h2>Welcome Back</h2>
                        <p>Enter your credentials to access your account.</p>
                    </div>

                    <c:if test="${param.error == 'unauthorized'}">
                        <div class="alert alert-error">
                            <i data-lucide="alert-triangle"
                                style="width:16px;height:16px;vertical-align:-2px;margin-right:4px;"></i>
                            Please log in first to access that page.
                        </div>
                    </c:if>

                    <form action="Login" method="POST" class="form" style="grid-template-columns: 1fr;">
                        <label for="accNo">Account Number</label>
                        <input type="number" id="accNo" name="accountNumber" value="${savedAccount}" required
                            placeholder="Enter your account number" />

                        <label for="pass">Password</label>
                        <input type="password" id="pass" name="password" required placeholder="Enter your password" />

                        <label style="display:flex; align-items:center; gap:8px; margin-top:4px;">
                            <input type="checkbox" name="rememberMe" id="remember" ${not empty savedAccount ? 'checked'
                                : '' }>
                            <span class="muted">Remember Me</span>
                        </label>

                        <button class="btn" type="submit" style="width:100%; margin-top:8px;">
                            <i data-lucide="arrow-right"
                                style="width:16px;height:16px;vertical-align:-2px;margin-right:4px;"></i>Login
                        </button>
                    </form>

                    <div style="display:flex; justify-content:space-between; margin-top:16px; font-size: 14px;">
                        <a href="<%= request.getContextPath() %>/ForgotPassword.jsp">Forgot Password?</a>
                        <a href="<%= request.getContextPath() %>/sign-up.jsp">Create an account</a>
                    </div>
                </div>
            </main>

            <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.min.js"></script>
            <script src="<%= request.getContextPath() %>/assets/js/ui.js"></script>
        </body>

        </html>