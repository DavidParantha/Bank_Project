<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title>AceBank – Smart Banking for Everyone</title>
            <meta name="description"
                content="AceBank - Modern banking made easy. Open an account, transfer money instantly, and manage your finances with confidence." />
            <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/main.css" />
            <script src="https://unpkg.com/@dotlottie/player-component@latest/dist/dotlottie-player.mjs" type="module"></script>
        </head>

        <body>

            <!-- Particle Canvas Background -->
            <canvas id="particle-canvas"></canvas>

            <!-- Floating Parallax Orbs -->
            <div class="orb orb-1"></div>
            <div class="orb orb-2"></div>
            <div class="orb orb-3"></div>

            <header class="navbar">
                <a href="<%= request.getContextPath() %>/About.jsp" class="brand">
                    <img src="<%= request.getContextPath() %>/assets/images/logo.png" alt="AceBank Logo"
                        class="brand-logo">
                    Ace<span>Bank</span>
                </a>
                <div class="nav-actions">
                    <c:choose>
                        <c:when test="${not empty sessionScope.firstName}">
                            <a href="<%= request.getContextPath() %>/home"><i data-lucide="layout-dashboard"
                                    class="icon-inline"></i>Dashboard</a>
                            <a href="<%= request.getContextPath() %>/LoanRequest.jsp"><i data-lucide="landmark"
                                    class="icon-inline"></i>Loans</a>
                            <a href="<%= request.getContextPath() %>/Settings.jsp"><i data-lucide="settings"
                                    class="icon-inline"></i>Settings</a>
                            <a href="<%= request.getContextPath() %>/About.jsp"><i data-lucide="info"
                                    class="icon-inline"></i>About</a>
                            <div class="avatar-wrap">
                                <button class="avatar-btn" id="avatarBtn" onclick="toggleAvatarDropdown()">
                                    ${sessionScope.firstName.substring(0,1)}
                                </button>
                                <div class="avatar-dropdown" id="avatarDropdown">
                                    <div class="avatar-dropdown-header">
                                        <div class="avatar-dropdown-email">${sessionScope.email}</div>
                                        <div class="avatar-lg">${sessionScope.firstName.substring(0,1)}</div>
                                        <div class="avatar-dropdown-hi">Hi, ${sessionScope.firstName}!</div>
                                        <a href="<%= request.getContextPath() %>/Settings.jsp"
                                            class="manage-acc-btn">Manage your AceBank Account</a>
                                    </div>
                                    <div class="switcher-section">
                                        <div class="switcher-item">
                                            <div class="switcher-icon">
                                                <i data-lucide="user"></i>
                                            </div>
                                            <div class="switcher-info">
                                                <div class="switcher-name">${sessionScope.firstName}
                                                    ${sessionScope.lastName}</div>
                                                <div class="switcher-email">${sessionScope.email}</div>
                                            </div>
                                            <i data-lucide="check" style="color: var(--success); width: 16px;"></i>
                                        </div>
                                        <a href="<%= request.getContextPath() %>/login.jsp" class="switcher-item">
                                            <div class="switcher-icon">
                                                <i data-lucide="user-plus"></i>
                                            </div>
                                            <div class="switcher-info">
                                                <div class="switcher-name">Add another account</div>
                                            </div>
                                        </a>
                                    </div>
                                    <div class="avatar-dropdown-footer">
                                        <a href="<%= request.getContextPath() %>/Logout" class="signout-all-btn">
                                            <i data-lucide="log-out" style="width: 16px;"></i>
                                            Sign out of all accounts
                                        </a>
                                        <div
                                            style="display: flex; justify-content: center; gap: 12px; font-size: 11px; color: var(--muted); padding-top: 8px;">
                                            <a href="#" style="color: inherit; text-decoration: none;">Privacy
                                                Policy</a>
                                            <span>•</span>
                                            <a href="#" style="color: inherit; text-decoration: none;">Terms of
                                                Service</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <a href="<%= request.getContextPath() %>/login.jsp"><i data-lucide="log-in"
                                    class="icon-inline"></i>Login</a>
                            <a href="<%= request.getContextPath() %>/About.jsp"><i data-lucide="info"
                                    class="icon-inline"></i>About</a>
                            <a href="<%= request.getContextPath() %>/sign-up.jsp" class="btn"><i data-lucide="user-plus"
                                    style="width:16px;height:16px;vertical-align:-2px;margin-right:4px;"></i>Open
                                Account</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </header>

            <main class="container">

                <!-- HERO -->
                <section class="hero hero-split">
                    <div class="hero-content">
                        <div class="badge hero-badge pulse-glow" style="margin-bottom: 20px;">
                            <i data-lucide="sparkles"
                                style="width:14px;height:14px;vertical-align:-2px;margin-right:4px;"></i>
                            Trusted by 2M+ Users Worldwide
                        </div>
                        <h1 class="hero-title scroll-reveal">
                            Banking Made<br><span class="gradient-text">Effortlessly Simple</span>
                        </h1>
                        <p class="hero-subtitle">
                            Join over 40,000 people who open an AceBank account every week.
                            Manage, spend, and save your money with bank-grade security and a beautiful interface.
                        </p>
                        <div class="hero-actions scroll-reveal" style="animation-delay:.3s">
                            <c:choose>
                                <c:when test="${not empty sessionScope.firstName}">
                                    <a href="<%= request.getContextPath() %>/home" class="btn btn-shine">
                                        <i data-lucide="layout-dashboard"
                                            style="width:16px;height:16px;vertical-align:-2px;margin-right:4px;"></i>
                                        Go to Dashboard
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <a href="<%= request.getContextPath() %>/sign-up.jsp" class="btn btn-shine">
                                        <i data-lucide="rocket"
                                            style="width:16px;height:16px;vertical-align:-2px;margin-right:4px;"></i>
                                        Open Free Account
                                    </a>
                                    <a href="#features" class="btn secondary">Explore Features</a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="hero-visual scroll-reveal" style="animation-delay:.4s">
                        <dotlottie-player 
                            src="https://assets-v2.lottiefiles.com/a/43c5dbb8-1189-11ee-9213-9311bc01c8b8/cgJsC0U8qu.lottie" 
                            background="transparent" 
                            speed="1" 
                            style="width: 100%; height: auto; max-width: 450px; filter: drop-shadow(0 0 30px var(--primary-glow));" 
                            loop 
                            autoplay>
                        </dotlottie-player>
                    </div>
                </section>

                <!-- STATS -->
                <section class="stats-row">
                    <div class="stat-item card card-animate scroll-reveal" style="animation-delay:.1s">
                        <div class="stat-number" data-count="2000000" data-suffix="+">0</div>
                        <div class="stat-label">Happy Customers</div>
                    </div>
                    <div class="stat-item card card-animate scroll-reveal" style="animation-delay:.2s">
                        <div class="stat-number" data-count="50" data-prefix="₹" data-suffix="Cr+">0</div>
                        <div class="stat-label">Transactions Processed</div>
                    </div>
                    <div class="stat-item card card-animate scroll-reveal" style="animation-delay:.3s">
                        <div class="stat-number" data-count="99.9" data-suffix="%" data-decimals="1">0</div>
                        <div class="stat-label">Uptime Guarantee</div>
                    </div>
                </section>

                <!-- FEATURES -->
                <section id="features" style="margin-top: 32px;">
                    <div style="text-align: center; margin-bottom: 32px;" class="scroll-reveal">
                        <h2 style="font-size: 32px; font-weight: 800; color: var(--text-heading);">Why Choose AceBank?
                        </h2>
                        <p class="muted" style="margin-top: 8px;">Everything you need for modern banking, all in one
                            place.
                        </p>
                    </div>

                    <div class="features-grid">
                        <div class="card card-animate feature-card scroll-reveal" style="animation-delay:.05s">
                            <div class="icon-feature-wrap"><i data-lucide="zap" class="icon-feature"></i></div>
                            <h3>Instant Transfers</h3>
                            <p>Move money between accounts in real time with bank-grade encryption and zero fees.</p>
                        </div>
                        <div class="card card-animate feature-card scroll-reveal" style="animation-delay:.12s">
                            <div class="icon-feature-wrap"><i data-lucide="shield-check" class="icon-feature"></i></div>
                            <h3>Secure Vault</h3>
                            <p>Your data is protected with BCrypt encryption, session management, and secure protocols.
                            </p>
                        </div>
                        <div class="card card-animate feature-card scroll-reveal" style="animation-delay:.19s">
                            <div class="icon-feature-wrap"><i data-lucide="bar-chart-3" class="icon-feature"></i></div>
                            <h3>Smart Insights</h3>
                            <p>Track spending, deposits, and withdrawals with real-time balance updates and history.</p>
                        </div>
                        <div class="card card-animate feature-card scroll-reveal" style="animation-delay:.26s">
                            <div class="icon-feature-wrap"><i data-lucide="credit-card" class="icon-feature"></i></div>
                            <h3>Easy Deposits</h3>
                            <p>Add money to your account instantly with our streamlined deposit system.</p>
                        </div>
                        <div class="card card-animate feature-card scroll-reveal" style="animation-delay:.33s">
                            <div class="icon-feature-wrap"><i data-lucide="bell-ring" class="icon-feature"></i></div>
                            <h3>Email Alerts</h3>
                            <p>Receive instant email notifications for every transaction and account activity.</p>
                        </div>
                        <div class="card card-animate feature-card scroll-reveal" style="animation-delay:.4s">
                            <div class="icon-feature-wrap"><i data-lucide="moon" class="icon-feature"></i></div>
                            <h3>Dark Mode</h3>
                            <p>Beautiful dark and light themes that are easy on your eyes, day or night.</p>
                        </div>
                    </div>
                </section>

                <!-- CTA -->
                <section class="card card-animate scroll-reveal"
                    style="text-align: center; margin-top: 48px; padding: 48px 24px; position: relative; overflow: hidden;">
                    <div class="cta-glow"></div>
                    <h2 style="font-size: 28px; font-weight: 800; color: var(--text-heading); margin-bottom: 12px;">
                        Ready to Get Started?
                    </h2>
                    <p class="muted"
                        style="margin-bottom: 24px; max-width: 460px; margin-left: auto; margin-right: auto;">
                        Open your free AceBank account in under 2 minutes. No paperwork, no hassle.
                    </p>
                    <div class="hero-actions">
                        <c:choose>
                            <c:when test="${not empty sessionScope.firstName}">
                                <a href="<%= request.getContextPath() %>/home" class="btn btn-shine">Back to
                                    Dashboard</a>
                                <a href="<%= request.getContextPath() %>/Settings.jsp" class="btn secondary">Manage
                                    Account</a>
                            </c:when>
                            <c:otherwise>
                                <a href="<%= request.getContextPath() %>/sign-up.jsp" class="btn btn-shine">Create
                                    Account</a>
                                <a href="<%= request.getContextPath() %>/login.jsp" class="btn secondary">Sign In</a>
                            </c:otherwise>
                        </c:choose>
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