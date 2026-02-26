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
                    <a href="<%= request.getContextPath() %>/login.jsp"><i data-lucide="log-in"
                            class="icon-inline"></i>Login</a>
                    <a href="<%= request.getContextPath() %>/About.jsp"><i data-lucide="info"
                            class="icon-inline"></i>About</a>
                </div>
            </header>

            <main class="auth-page">
                <div class="card auth-card" style="padding-bottom: 32px;">

                    <!-- Step Progress Indicator -->
                    <div class="step-indicator" style="margin-top: 8px; margin-bottom: 36px;">
                        <div class="step-item">
                            <div class="step-circle ${empty param.step ? 'active' : 'completed'}">
                                <c:choose>
                                    <c:when test="${not empty param.step}"><i data-lucide="check"
                                            style="width:16px;height:16px;"></i></c:when>
                                    <c:otherwise>1</c:otherwise>
                                </c:choose>
                                <span class="step-label">Email</span>
                            </div>
                        </div>
                        <div class="step-line ${param.step == 'verify' || param.step == 'reset' ? 'active' : ''}"></div>
                        <div class="step-item">
                            <div
                                class="step-circle ${param.step == 'verify' ? 'active' : ''} ${param.step == 'reset' ? 'completed' : ''}">
                                <c:choose>
                                    <c:when test="${param.step == 'reset'}"><i data-lucide="check"
                                            style="width:16px;height:16px;"></i></c:when>
                                    <c:otherwise>2</c:otherwise>
                                </c:choose>
                                <span class="step-label">OTP</span>
                            </div>
                        </div>
                        <div class="step-line ${param.step == 'reset' ? 'active' : ''}"></div>
                        <div class="step-item">
                            <div class="step-circle ${param.step == 'reset' ? 'active' : ''}">
                                3
                                <span class="step-label">Reset</span>
                            </div>
                        </div>
                    </div>

                    <div class="auth-header" style="margin-bottom: 20px;">
                        <i data-lucide="key-round" class="icon-auth"></i>
                        <h2>
                            <c:choose>
                                <c:when test="${param.step == 'verify'}">Enter OTP</c:when>
                                <c:when test="${param.step == 'reset'}">Set New Password</c:when>
                                <c:otherwise>Account Recovery</c:otherwise>
                            </c:choose>
                        </h2>
                        <p>
                            <c:choose>
                                <c:when test="${param.step == 'verify'}">
                                    We've sent a 6-digit OTP to your registered email. It expires in 5 minutes.
                                </c:when>
                                <c:when test="${param.step == 'reset'}">
                                    OTP verified! Create a new strong password below.
                                </c:when>
                                <c:otherwise>
                                    Enter your registered email and we'll send you an OTP to reset your password.
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>

                    <%--==========ERROR ALERTS==========--%>
                        <c:if test="${not empty param.error}">
                            <div class="alert alert-error">
                                <i data-lucide="alert-triangle"
                                    style="width:16px;height:16px;vertical-align:-2px;margin-right:4px;"></i>
                                <c:choose>
                                    <c:when test="${param.error == 'notfound'}">No account found with that email
                                        address.</c:when>
                                    <c:when test="${param.error == 'sendfailed'}">Could not send OTP email. Please try
                                        again.</c:when>
                                    <c:when test="${param.error == 'expired'}">OTP has expired. Please request a new
                                        one.</c:when>
                                    <c:when test="${param.error == 'wrongotp'}">Incorrect OTP. Please try again.
                                    </c:when>
                                    <c:when test="${param.error == 'maxattempts'}">Too many failed attempts. Please
                                        request a new OTP.</c:when>
                                    <c:when test="${param.error == 'mismatch'}">New passwords do not match.</c:when>
                                    <c:when test="${param.error == 'tooshort'}">Password must be at least 10 characters.
                                    </c:when>
                                    <c:when test="${param.error == 'resetfailed'}">Password reset failed. Please try
                                        again.</c:when>
                                    <c:otherwise>Something went wrong. Please try again.</c:otherwise>
                                </c:choose>
                            </div>
                        </c:if>

                        <%--==========STEP 1: Enter Email==========--%>
                            <c:if test="${empty param.step}">
                                <form action="ForgotPassword" method="POST" class="form"
                                    style="grid-template-columns: 1fr;">
                                    <input type="hidden" name="action" value="sendOtp" />

                                    <label for="recoveryEmail">Email Address</label>
                                    <input type="email" id="recoveryEmail" name="email" required
                                        placeholder="Enter your registered email" />

                                    <button class="btn btn-shine" type="submit" style="width:100%; margin-top:8px;">
                                        <i data-lucide="send"
                                            style="width:16px;height:16px;vertical-align:-2px;margin-right:4px;"></i>Send
                                        OTP
                                    </button>
                                </form>
                            </c:if>

                            <%--==========STEP 2: Enter OTP==========--%>
                                <c:if test="${param.step == 'verify'}">
                                    <form action="ForgotPassword" method="POST" class="form"
                                        style="grid-template-columns: 1fr;">
                                        <input type="hidden" name="action" value="verifyOtp" />
                                        <input type="hidden" name="email" value="${param.email}" />

                                        <label for="otpCode">6-Digit OTP</label>
                                        <input type="text" id="otpCode" name="otp" required
                                            placeholder="Enter the OTP from your email" maxlength="6" pattern="[0-9]{6}"
                                            style="font-size: 24px; text-align: center; letter-spacing: 8px; font-weight: 700;" />

                                        <%-- Countdown timer --%>
                                            <div id="otp-timer" style="text-align:center; margin-top:4px;">
                                                <span class="muted">OTP expires in </span>
                                                <span id="countdown"
                                                    style="font-weight:700; color:var(--primary);">5:00</span>
                                            </div>

                                            <button class="btn btn-shine" type="submit"
                                                style="width:100%; margin-top:8px;">
                                                <i data-lucide="check-circle"
                                                    style="width:16px;height:16px;vertical-align:-2px;margin-right:4px;"></i>Verify
                                                OTP
                                            </button>
                                    </form>

                                    <div style="text-align: center; margin-top: 12px;">
                                        <form action="ForgotPassword" method="POST" style="display:inline;">
                                            <input type="hidden" name="action" value="sendOtp" />
                                            <input type="hidden" name="email" value="${param.email}" />
                                            <button type="submit" class="btn secondary" style="font-size:13px;">
                                                <i data-lucide="refresh-cw"
                                                    style="width:14px;height:14px;vertical-align:-2px;margin-right:2px;"></i>
                                                Resend OTP
                                            </button>
                                        </form>
                                    </div>
                                </c:if>

                                <%--==========STEP 3: Set New Password==========--%>
                                    <c:if test="${param.step == 'reset'}">
                                        <form action="ForgotPassword" method="POST" class="form"
                                            style="grid-template-columns: 1fr;" id="reset-pw-form">
                                            <input type="hidden" name="action" value="resetPassword" />
                                            <input type="hidden" name="email" value="${param.email}" />

                                            <label for="newPassword">New Password</label>
                                            <div class="password-wrap">
                                                <input type="password" id="newPassword" name="newPassword" required
                                                    placeholder="Min. 10 characters" minlength="10" />
                                                <button type="button" class="toggle-pw"
                                                    onclick="togglePassword('newPassword', this)">
                                                    <i data-lucide="eye" style="width:18px;height:18px;"></i>
                                                </button>
                                            </div>

                                            <label for="confirmPassword">Confirm New Password</label>
                                            <div class="password-wrap">
                                                <input type="password" id="confirmPassword" name="confirmPassword"
                                                    required placeholder="Re-enter new password" minlength="10" />
                                                <button type="button" class="toggle-pw"
                                                    onclick="togglePassword('confirmPassword', this)">
                                                    <i data-lucide="eye" style="width:18px;height:18px;"></i>
                                                </button>
                                            </div>

                                            <button class="btn btn-shine" type="submit"
                                                style="width:100%; margin-top:8px;">
                                                <i data-lucide="save"
                                                    style="width:16px;height:16px;vertical-align:-2px;margin-right:4px;"></i>Reset
                                                Password
                                            </button>
                                        </form>
                                    </c:if>

                                    <div
                                        style="display:flex; justify-content:space-between; margin-top:16px; font-size: 14px;">
                                        <a href="<%= request.getContextPath() %>/login.jsp"><i data-lucide="arrow-left"
                                                style="width:14px;height:14px;vertical-align:-2px;margin-right:2px;"></i>
                                            Back to Login</a>
                                        <a href="<%= request.getContextPath() %>/sign-up.jsp">Create an account</a>
                                    </div>
                </div>
            </main>

            <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.min.js"></script>
            <script src="<%= request.getContextPath() %>/assets/js/ui.js"></script>
            <script>
                // OTP Countdown Timer
                (function () {
                    const countdownEl = document.getElementById('countdown');
                    if (!countdownEl) return;

                    let timeLeft = 5 * 60; // 5 minutes in seconds

                    const timer = setInterval(() => {
                        timeLeft--;
                        const minutes = Math.floor(timeLeft / 60);
                        const seconds = timeLeft % 60;
                        countdownEl.textContent = minutes + ':' + (seconds < 10 ? '0' : '') + seconds;

                        if (timeLeft <= 60) {
                            countdownEl.style.color = 'var(--danger)';
                        }

                        if (timeLeft <= 0) {
                            clearInterval(timer);
                            countdownEl.textContent = 'Expired';
                            countdownEl.style.color = 'var(--danger)';
                        }
                    }, 1000);
                })();

                // Client-side password match validation for Step 3
                const resetForm = document.getElementById('reset-pw-form');
                if (resetForm) {
                    resetForm.addEventListener('submit', function (e) {
                        const newPw = document.getElementById('newPassword').value;
                        const confirmPw = document.getElementById('confirmPassword').value;
                        if (newPw !== confirmPw) {
                            e.preventDefault();
                            if (typeof showToast === 'function') {
                                showToast('Passwords do not match!', 'error');
                            } else {
                                alert('Passwords do not match!');
                            }
                        }
                    });
                }
            </script>
        </body>

        </html>