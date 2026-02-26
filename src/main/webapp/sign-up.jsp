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

        <!-- Particle Canvas Background -->
        <canvas id="particle-canvas"></canvas>

        <!-- Floating Parallax Orbs -->
        <div class="orb orb-1"></div>
        <div class="orb orb-2"></div>
        <div class="orb orb-3"></div>

        <header class="navbar">
            <a href="<%= request.getContextPath() %>/About.jsp" class="brand">
                <img src="<%= request.getContextPath() %>/assets/images/logo.png" alt="AceBank Logo" class="brand-logo">
                Ace<span>Bank</span>
            </a>
            <div class="nav-actions">
                <a href="<%= request.getContextPath() %>/index.jsp"><i data-lucide="home"
                        class="icon-inline"></i>Home</a>
                <a href="<%= request.getContextPath() %>/About.jsp"><i data-lucide="info"
                        class="icon-inline"></i>About</a>
                <a href="<%= request.getContextPath() %>/login.jsp" class="btn secondary"><i data-lucide="log-in"
                        style="width:16px;height:16px;vertical-align:-2px;margin-right:4px;"></i>Login</a>
            </div>
        </header>

        <main class="container"
            style="min-height: calc(100vh - 80px); display: flex; align-items: center; justify-content: center; padding: 40px 20px;">
            <div class="signup-container card card-animate"
                style="max-width: 1000px; width: 100%; display: grid; grid-template-columns: 1fr 1.2fr; overflow: hidden; padding: 0; border: none;">

                <!-- Left Side: Welcome & Features -->
                <div class="signup-info"
                    style="background: linear-gradient(145deg, var(--primary), #8b5cf6); padding: 48px; color: #fff; position: relative; overflow: hidden; display: flex; flex-direction: column; justify-content: center;">
                    <div class="cta-glow"
                        style="background: radial-gradient(circle at 30% 30%, rgba(255,255,255,0.2), transparent);">
                    </div>

                    <div class="badge"
                        style="background: rgba(255,255,255,0.15); color: #fff; border-color: rgba(255,255,255,0.3); width: fit-content; margin-bottom: 24px;">
                        <i data-lucide="sparkles"
                            style="width:14px;height:14px;vertical-align:-2px;margin-right:4px;"></i>
                        The Future of Banking
                    </div>

                    <h1 style="font-size: 42px; font-weight: 800; line-height: 1.1; margin-bottom: 24px;">Join
                        the<br>AceBank<br>Community</h1>
                    <p style="font-size: 16px; opacity: 0.9; margin-bottom: 40px; line-height: 1.6;">
                        Join over 40,000 people who open an AceBank account every week. Manage, spend, and save your
                        money with bank-grade security.
                    </p>

                    <div style="display: flex; flex-direction: column; gap: 24px;">
                        <div style="display: flex; gap: 16px; align-items: center;">
                            <div
                                style="width: 44px; height: 44px; border-radius: 12px; background: rgba(255,255,255,0.15); display: flex; align-items: center; justify-content: center;">
                                <i data-lucide="shield-check" style="width: 24px; height: 24px;"></i>
                            </div>
                            <div>
                                <h4 style="margin: 0; font-size: 16px; font-weight: 700;">Bank-Grade Security</h4>
                                <p style="margin: 0; font-size: 14px; opacity: 0.7;">Your data is protected with elite
                                    encryption.</p>
                            </div>
                        </div>
                        <div style="display: flex; gap: 16px; align-items: center;">
                            <div
                                style="width: 44px; height: 44px; border-radius: 12px; background: rgba(255,255,255,0.15); display: flex; align-items: center; justify-content: center;">
                                <i data-lucide="zap" style="width: 24px; height: 24px;"></i>
                            </div>
                            <div>
                                <h4 style="margin: 0; font-size: 16px; font-weight: 700;">Instant Setup</h4>
                                <p style="margin: 0; font-size: 14px; opacity: 0.7;">Create your account in under 2
                                    minutes.</p>
                            </div>
                        </div>
                        <div style="display: flex; gap: 16px; align-items: center;">
                            <div
                                style="width: 44px; height: 44px; border-radius: 12px; background: rgba(255,255,255,0.15); display: flex; align-items: center; justify-content: center;">
                                <i data-lucide="globe" style="width: 24px; height: 24px;"></i>
                            </div>
                            <div>
                                <h4 style="margin: 0; font-size: 16px; font-weight: 700;">Global Access</h4>
                                <p style="margin: 0; font-size: 14px; opacity: 0.7;">Manage your money from anywhere,
                                    anytime.</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right Side: Form -->
                <div style="padding: 48px; background: var(--card-bg);">
                    <div style="margin-bottom: 32px;">
                        <h2 style="font-size: 28px; font-weight: 800; color: var(--text-heading);">Create Account</h2>
                        <p class="muted">Enter your details to get started.</p>
                    </div>

                    <form action="signup" method="POST" id="signup-form" class="form"
                        style="display: flex; flex-direction: column; gap: 20px;">

                        <% if (request.getAttribute("signupError") !=null) { %>
                            <div class="alert alert-error"
                                style="background: rgba(239, 68, 68, 0.1); border: 1px solid var(--danger); color: var(--danger); padding: 12px; border-radius: 8px; display: flex; align-items: center; gap: 10px; font-size: 14px;">
                                <i data-lucide="alert-circle" style="width: 18px; height: 18px;"></i>
                                <span>
                                    <%= request.getAttribute("signupError") %>
                                </span>
                            </div>
                            <% } %>
                                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
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
                                </div>

                                <div>
                                    <label for="aadharNumber">Aadhaar Number</label>
                                    <div style="position: relative;">
                                        <i data-lucide="fingerprint" class="icon-inline"
                                            style="position: absolute; left: 12px; top: 12px; color: var(--muted); width: 16px;"></i>
                                        <input type="text" name="aadharNumber" id="aadharNumber"
                                            placeholder="12-digit Aadhaar" pattern="[0-9]{12}" required
                                            style="width:100%; margin-top:6px; padding-left: 40px;">
                                    </div>
                                </div>

                                <div>
                                    <label for="email">Email Address</label>
                                    <div style="position: relative;">
                                        <i data-lucide="mail" class="icon-inline"
                                            style="position: absolute; left: 12px; top: 12px; color: var(--muted); width: 16px;"></i>
                                        <input type="email" name="email" id="email" placeholder="john@example.com"
                                            required style="width:100%; margin-top:6px; padding-left: 40px;">
                                    </div>
                                </div>

                                <div>
                                    <label for="password">Strong Password</label>
                                    <div class="password-wrap" style="margin-top:6px;">
                                        <i data-lucide="lock"
                                            style="position: absolute; left: 12px; top: 12px; color: var(--muted); width: 16px; z-index: 1;"></i>
                                        <input type="password" name="password" id="password"
                                            placeholder="Min. 10 characters" minlength="10" required
                                            style="width:100%; padding-left: 40px;">
                                        <button type="button" class="toggle-pw"
                                            onclick="togglePassword('password', this)">
                                            <i data-lucide="eye" style="width:18px;height:18px;"></i>
                                        </button>
                                    </div>
                                    <div class="pw-strength">
                                        <div class="pw-strength-bar" id="pw-bar"></div>
                                    </div>
                                </div>

                                <div style="margin-top: 12px;">
                                    <button class="btn btn-shine" type="submit" id="submit-btn"
                                        style="width:100%; padding: 14px; font-size: 16px;">
                                        <i data-lucide="user-plus"
                                            style="width:18px;height:18px;vertical-align:-4px;margin-right:8px;"></i>
                                        Create My
                                        Account
                                    </button>
                                </div>

                                <div style="text-align: center; margin-top: 16px; font-size: 14px;">
                                    <span class="muted">Already have an account?</span>
                                    <a href="<%= request.getContextPath() %>/login.jsp"
                                        style="font-weight: 700; margin-left: 4px; color: var(--primary);">Sign In</a>
                                </div>
                    </form>
                </div>
            </div>
        </main>

        <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.min.js"></script>
        <script src="<%= request.getContextPath() %>/assets/js/ui.js"></script>
        <script>
            // Password strength indicator
            const pwInput = document.getElementById('password');
            const pwBar = document.getElementById('pw-bar');
            if (pwInput && pwBar) {
                pwInput.addEventListener('input', function () {
                    const val = this.value;
                    let strength = 0;
                    if (val.length >= 8) strength++;
                    if (/[A-Z]/.test(val) && /[a-z]/.test(val)) strength++;
                    if (/[0-9]/.test(val) && /[^A-Za-z0-9]/.test(val)) strength++;
                    pwBar.className = 'pw-strength-bar ' + ['', 'weak', 'medium', 'strong'][strength];
                });
            }
        </script>
        <style>
            @media (max-width: 800px) {
                .signup-container {
                    grid-template-columns: 1fr !important;
                }

                .signup-info {
                    display: none !important;
                }
            }
        </style>
    </body>

    </html>