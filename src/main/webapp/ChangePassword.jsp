<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Change Password | AceBank</title>
            <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/main.css" />
        </head>

        <body>

            <header class="navbar">
                <div class="brand">Ace<span>Bank</span></div>
                <div class="nav-actions">
                    <a href="<%= request.getContextPath() %>/home"><i data-lucide="layout-dashboard"
                            class="icon-inline"></i>Dashboard</a>
                    <button onclick="toggleTheme()" class="btn secondary"><i data-lucide="sun-moon"
                            style="width:16px;height:16px;vertical-align:-2px;margin-right:4px;"></i> Theme</button>
                    <a href="<%= request.getContextPath() %>/Logout" class="btn danger" style="font-size:13px;"><i
                            data-lucide="log-out"
                            style="width:14px;height:14px;vertical-align:-2px;margin-right:4px;"></i>Logout</a>
                </div>
            </header>

            <main class="auth-page">
                <div class="card auth-card">
                    <div class="auth-header">
                        <i data-lucide="shield-check" class="icon-auth"></i>
                        <h2>Change Password</h2>
                        <p>Keep your account secure with a strong password.</p>
                    </div>

                    <c:if test="${not empty param.success}">
                        <div class="alert alert-success">
                            <i data-lucide="check-circle"
                                style="width:16px;height:16px;vertical-align:-2px;margin-right:4px;"></i>
                            Password changed successfully!
                        </div>
                    </c:if>

                    <c:if test="${not empty param.error}">
                        <div class="alert alert-error">
                            <i data-lucide="alert-triangle"
                                style="width:16px;height:16px;vertical-align:-2px;margin-right:4px;"></i>
                            ${param.error == 'mismatch' ? 'New passwords do not match.' :
                            param.error == 'wrong' ? 'Current password is incorrect.' :
                            'Could not change password. Please try again.'}
                        </div>
                    </c:if>

                    <form action="ChangePassword" method="POST" class="form" style="grid-template-columns: 1fr;"
                        id="change-pw-form">
                        <label for="currentPassword">Current Password</label>
                        <input type="password" id="currentPassword" name="currentPassword" required
                            placeholder="Enter current password" />

                        <label for="newPassword">New Password</label>
                        <input type="password" id="newPassword" name="newPassword" required
                            placeholder="Min. 10 characters" minlength="10" />

                        <label for="confirmPassword">Confirm New Password</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" required
                            placeholder="Re-enter new password" minlength="10" />

                        <button class="btn" type="submit" style="width:100%; margin-top:8px;">
                            <i data-lucide="save"
                                style="width:16px;height:16px;vertical-align:-2px;margin-right:4px;"></i>Update Password
                        </button>
                    </form>

                    <div style="text-align: center; margin-top: 16px; font-size: 14px;">
                        <a href="<%= request.getContextPath() %>/home"><i data-lucide="arrow-left"
                                style="width:14px;height:14px;vertical-align:-2px;margin-right:2px;"></i> Back to
                            Dashboard</a>
                    </div>
                </div>
            </main>

            <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.min.js"></script>
            <script src="<%= request.getContextPath() %>/assets/js/ui.js"></script>
            <script>
                document.getElementById('change-pw-form').addEventListener('submit', function (e) {
                    const newPw = document.getElementById('newPassword').value;
                    const confirmPw = document.getElementById('confirmPassword').value;
                    if (newPw !== confirmPw) {
                        e.preventDefault();
                        if (typeof showToast === 'function') {
                            showToast('New passwords do not match!', 'error');
                        } else {
                            alert('New passwords do not match!');
                        }
                    }
                });
            </script>
        </body>

        </html>