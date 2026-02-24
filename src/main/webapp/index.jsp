<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>AceBank – Smart Banking for Everyone</title>
        <meta name="description"
            content="AceBank - Modern banking made easy. Open an account, transfer money instantly, and manage your finances with confidence." />
        <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/main.css" />
    </head>

    <body>

        <header class="navbar">
            <div class="brand">Ace<span>Bank</span></div>
            <div class="nav-actions">
                <a href="<%= request.getContextPath() %>/login.jsp"><i data-lucide="log-in"
                        class="icon-inline"></i>Login</a>
                <a href="<%= request.getContextPath() %>/sign-up.jsp" class="btn"><i data-lucide="user-plus"
                        style="width:16px;height:16px;vertical-align:-2px;margin-right:4px;"></i>Open Account</a>
            </div>
        </header>

        <main class="container">

            <!-- HERO -->
            <section class="hero fade-in-up">
                <div class="badge" style="margin-bottom: 20px;"><i data-lucide="sparkles"
                        style="width:14px;height:14px;vertical-align:-2px;margin-right:4px;"></i> Trusted by 2M+ Users
                    Worldwide</div>
                <h1 class="hero-title">
                    Banking Made<br><span class="gradient-text">Effortlessly Simple</span>
                </h1>
                <p class="hero-subtitle">
                    Join over 40,000 people who open an AceBank account every week.
                    Manage, spend, and save your money with bank-grade security and a beautiful interface.
                </p>
                <div class="hero-actions">
                    <a href="<%= request.getContextPath() %>/sign-up.jsp" class="btn"><i data-lucide="rocket"
                            style="width:16px;height:16px;vertical-align:-2px;margin-right:4px;"></i> Open Free
                        Account</a>
                    <a href="#features" class="btn secondary">Explore Features</a>
                </div>
            </section>

            <!-- STATS -->
            <section class="stats-row fade-in-up">
                <div class="stat-item card card-animate">
                    <div class="stat-number">2M+</div>
                    <div class="stat-label">Happy Customers</div>
                </div>
                <div class="stat-item card card-animate">
                    <div class="stat-number">₹50Cr+</div>
                    <div class="stat-label">Transactions Processed</div>
                </div>
                <div class="stat-item card card-animate">
                    <div class="stat-number">99.9%</div>
                    <div class="stat-label">Uptime Guarantee</div>
                </div>
            </section>

            <!-- FEATURES -->
            <section id="features" class="fade-in-up" style="margin-top: 32px;">
                <div style="text-align: center; margin-bottom: 32px;">
                    <h2 style="font-size: 32px; font-weight: 800; color: var(--text-heading);">Why Choose AceBank?</h2>
                    <p class="muted" style="margin-top: 8px;">Everything you need for modern banking, all in one place.
                    </p>
                </div>

                <div class="features-grid">
                    <div class="card card-animate feature-card">
                        <i data-lucide="zap" class="icon-feature"></i>
                        <h3>Instant Transfers</h3>
                        <p>Move money between accounts in real time with bank-grade encryption and zero fees.</p>
                    </div>
                    <div class="card card-animate feature-card">
                        <i data-lucide="shield-check" class="icon-feature"></i>
                        <h3>Secure Vault</h3>
                        <p>Your data is protected with BCrypt encryption, session management, and secure protocols.</p>
                    </div>
                    <div class="card card-animate feature-card">
                        <i data-lucide="bar-chart-3" class="icon-feature"></i>
                        <h3>Smart Insights</h3>
                        <p>Track spending, deposits, and withdrawals with real-time balance updates and history.</p>
                    </div>
                    <div class="card card-animate feature-card">
                        <i data-lucide="credit-card" class="icon-feature"></i>
                        <h3>Easy Deposits</h3>
                        <p>Add money to your account instantly with our streamlined deposit system.</p>
                    </div>
                    <div class="card card-animate feature-card">
                        <i data-lucide="bell-ring" class="icon-feature"></i>
                        <h3>Email Alerts</h3>
                        <p>Receive instant email notifications for every transaction and account activity.</p>
                    </div>
                    <div class="card card-animate feature-card">
                        <i data-lucide="moon" class="icon-feature"></i>
                        <h3>Dark Mode</h3>
                        <p>Beautiful dark and light themes that are easy on your eyes, day or night.</p>
                    </div>
                </div>
            </section>

            <!-- CTA -->
            <section class="card card-animate fade-in-up"
                style="text-align: center; margin-top: 48px; padding: 48px 24px;">
                <h2 style="font-size: 28px; font-weight: 800; color: var(--text-heading); margin-bottom: 12px;">
                    Ready to Get Started?
                </h2>
                <p class="muted" style="margin-bottom: 24px; max-width: 460px; margin-left: auto; margin-right: auto;">
                    Open your free AceBank account in under 2 minutes. No paperwork, no hassle.
                </p>
                <div class="hero-actions">
                    <a href="<%= request.getContextPath() %>/sign-up.jsp" class="btn">Create Account</a>
                    <a href="<%= request.getContextPath() %>/login.jsp" class="btn secondary">Sign In</a>
                </div>
            </section>

            <!-- FOOTER -->
            <footer style="text-align: center; padding: 32px 0 16px; margin-top: 48px;">
                <p class="muted" style="font-size: 13px;">&copy; 2026 AceBank. All rights reserved. Built with <i
                        data-lucide="heart"
                        style="width:14px;height:14px;vertical-align:-2px;color:var(--danger);fill:var(--danger);"></i>
                    in India.</p>
            </footer>
        </main>

        <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.min.js"></script>
        <script src="<%= request.getContextPath() %>/assets/js/ui.js"></script>
    </body>

    </html>