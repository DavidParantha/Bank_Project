<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${errorTitle != null ? errorTitle : 'Error'} - AceBank</title>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/main.css" />
    </head>

    <body>

        <header class="navbar">
            <div class="brand">Ace<span>Bank</span></div>
            <div class="nav-actions">
                <a href="${pageContext.request.contextPath}/home"><i data-lucide="layout-dashboard"
                        class="icon-inline"></i>Dashboard</a>
                <a href="${pageContext.request.contextPath}/login.jsp"><i data-lucide="log-in"
                        class="icon-inline"></i>Login</a>
            </div>
        </header>

        <main class="error-page">
            <div class="card error-card">
                <i data-lucide="alert-octagon" class="icon-error"></i>

                <div class="error-code">
                    ${errorCode != null ? errorCode : '?'}
                </div>

                <h2>${errorTitle != null ? errorTitle : 'Something Went Wrong'}</h2>

                <p class="muted" style="margin: 12px 0 0;">
                    ${errorMessage != null ? errorMessage : 'An unexpected error occurred. Please try again later.'}
                </p>

                <div class="error-actions">
                    <a class="btn secondary" href="${pageContext.request.contextPath}/home">
                        <i data-lucide="arrow-left"
                            style="width:16px;height:16px;vertical-align:-2px;margin-right:4px;"></i>Return to Dashboard
                    </a>
                    <a class="btn" href="${pageContext.request.contextPath}/login.jsp">
                        <i data-lucide="log-in"
                            style="width:16px;height:16px;vertical-align:-2px;margin-right:4px;"></i>Login
                    </a>
                </div>
            </div>
        </main>

        <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.min.js"></script>
        <script src="<%= request.getContextPath() %>/assets/js/ui.js"></script>
    </body>

    </html>