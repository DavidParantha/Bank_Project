<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Forgot Password | AceBank</title>
            <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/main.css" />
        </head>

        <body>

            <header class="navbar">
                <div class="brand">Ace<span>Bank</span></div>
                <div class="nav-actions">
                    <a href="<%= request.getContextPath() %>/login.jsp"><i data-lucide="log-in"
                            class="icon-inline"></i>Login</a>
                    <a href="<%= request.getContextPath() %>/sign-up.jsp" class="btn"><i data-lucide="user-plus"
                            style="width:16px;height:16px;vertical-align:-2px;margin-right:4px;"></i>Join Now</a>
                </div>
            </header>

            <main class="auth-page">
                <div class="card auth-card">
                    <div class="auth-header">
                        <i data-lucide="key-round" class="icon-auth"></i>
                        <h2>Account Recovery</h2>
                        <p>Enter your registered email and we'll send your account details.</p>
                    </div>

                    <c:if test="${not empty param.success}">
                        <div class="alert alert-success">
                            <i data-lucide="check-circle"
                                style="width:16px;height:16px;vertical-align:-2px;margin-right:4px;"></i>
                            Recovery email sent! Check your inbox for your account details.
                        </div>
                    </c:if>

                    <c:if test="${not empty param.error}">
                        <div class="alert alert-error">
                            <i data-lucide="alert-triangle"
                                style="width:16px;height:16px;vertical-align:-2px;margin-right:4px;"></i>
                            ${param.error == 'notfound' ? 'No account found with that email address.' :
                            'Could not process recovery. Please try again.'}
                        </div>
                    </c:if>

                    <form action="ForgotPassword" method="POST" class="form" style="grid-template-columns: 1fr;">
                        <label for="recoveryEmail">Email Address</label>
                        <input type="email" id="recoveryEmail" name="email" required
                            placeholder="Enter your registered email" />

                        <button class="btn" type="submit" style="width:100%; margin-top:8px;">
                            <i data-lucide="mail"
                                style="width:16px;height:16px;vertical-align:-2px;margin-right:4px;"></i>Send Recovery
                            Email
                        </button>
                    </form>

                    <div style="display:flex; justify-content:space-between; margin-top:16px; font-size: 14px;">
                        <a href="<%= request.getContextPath() %>/login.jsp"><i data-lucide="arrow-left"
                                style="width:14px;height:14px;vertical-align:-2px;margin-right:2px;"></i> Back to
                            Login</a>
                        <a href="<%= request.getContextPath() %>/sign-up.jsp">Create an account</a>
                    </div>
                </div>
            </main>

            <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.min.js"></script>
            <script src="<%= request.getContextPath() %>/assets/js/ui.js"></script>
        </body>

        </html>