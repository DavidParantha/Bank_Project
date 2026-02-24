<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Create Account | AceBank</title>
        <meta name="description" content="Open your free AceBank account in under 2 minutes." />
        <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/main.css" />
    </head>

    <body>

        <header class="navbar">
            <div class="brand">Ace<span>Bank</span></div>
            <div class="nav-actions">
                <a href="<%= request.getContextPath() %>/index.jsp"><i data-lucide="home"
                        class="icon-inline"></i>Home</a>
                <a href="<%= request.getContextPath() %>/login.jsp" class="btn secondary"><i data-lucide="log-in"
                        style="width:16px;height:16px;vertical-align:-2px;margin-right:4px;"></i>Login</a>
            </div>
        </header>

        <main class="auth-page">
            <div class="card auth-card wide">
                <div class="auth-header">
                    <i data-lucide="user-plus" class="icon-auth"></i>
                    <h2>Create Your Account</h2>
                    <p>Join thousands of users managing money smarter with AceBank.</p>
                </div>

                <form action="signup" method="POST" id="signup-form" class="form"
                    style="grid-template-columns: 1fr 1fr;">
                    <div>
                        <label for="firstName">First Name</label>
                        <input type="text" name="firstName" id="firstName" placeholder="John" required
                            style="width:100%; margin-top:6px;">
                    </div>
                    <div>
                        <label for="lastName">Last Name</label>
                        <input type="text" name="lastName" id="lastName" placeholder="Doe" required
                            style="width:100%; margin-top:6px;">
                    </div>

                    <div>
                        <label for="aadharNumber">Aadhaar Number</label>
                        <input type="text" name="aadharNumber" id="aadharNumber" placeholder="12-digit Aadhaar"
                            pattern="[0-9]{12}" required style="width:100%; margin-top:6px;">
                    </div>
                    <div>
                        <label for="email">Email Address</label>
                        <input type="email" name="email" id="email" placeholder="john@example.com" required
                            style="width:100%; margin-top:6px;">
                    </div>

                    <div style="grid-column: 1 / -1;">
                        <label for="password">Password</label>
                        <input type="password" name="password" id="password" placeholder="Min. 10 characters"
                            minlength="10" required style="width:100%; margin-top:6px;">
                    </div>

                    <div style="grid-column: 1 / -1; margin-top: 8px;">
                        <button class="btn" type="submit" id="submit-btn" style="width:100%;">
                            <i data-lucide="rocket"
                                style="width:16px;height:16px;vertical-align:-2px;margin-right:4px;"></i> Create Account
                        </button>
                    </div>
                </form>

                <div style="text-align: center; margin-top: 16px; font-size: 14px;">
                    <span class="muted">Already have an account?</span>
                    <a href="<%= request.getContextPath() %>/login.jsp" style="margin-left: 4px;">Sign In</a>
                </div>
            </div>
        </main>

        <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.min.js"></script>
        <script src="<%= request.getContextPath() %>/assets/js/ui.js"></script>
    </body>

    </html>