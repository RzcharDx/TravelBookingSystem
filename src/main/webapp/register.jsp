<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>Register - Travel Booking</title>
    <%-- 重用与 login.jsp 相同的样式 --%>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; display: grid; place-items: center; min-height: 90vh; background-color: #f4f7f6; }
        .container { width: 350px; padding: 2rem; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); background-color: #ffffff; }
        .form-group { margin-bottom: 1.5rem; }
        .form-group label { display: block; margin-bottom: 0.5rem; font-weight: 600; }
        .form-group input { width: 100%; box-sizing: border-box; padding: 0.75rem; border-radius: 4px; border: 1px solid #ccc; }
        .btn { width: 100%; padding: 0.75rem; border: none; border-radius: 4px; background-color: #28a745; color: white; font-size: 1rem; cursor: pointer; }
        .error { color: #D8000C; background-color: #FFD2D2; padding: 0.5rem; border-radius: 4px; }
        .footer-link { text-align: center; margin-top: 1.5rem; }
    </style>
</head>
<body>
<div class="container">
    <h2>创建您的帐户</h2>

    <%-- 1. 检查来自 RegisterServlet 的错误参数 --%>
    <c:if test="${param.error == 'mismatch'}">
        <p class="error">密码不匹配。请重试。</p>
    </c:if>
    <c:if test="${param.error == 'taken'}">
        <p class="error">该用户名已被占用。请选择其他名称。</p>
    </c:if>

    <%-- 2. 注册表单，提交到 RegisterServlet --%>
    <form action="${pageContext.request.contextPath}/register" method="POST">
        <div class="form-group">
            <label for="username">Username:</label>
            <input type="text" id="username" name="username" required>
        </div>
        <div class="form-group">
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required>
        </div>
        <div class="form-group">
            <label for="confirm_password">Confirm Password:</label>
            <input type="password" id="confirm_password" name="confirm_password" required>
        </div>
        <button type="submit" class="btn">Register</button>
    </form>

    <div class="footer-link">
        <p>已有帐户？ <a href="login.jsp">在此登录</a></p>
    </div>
</div>
</body>
</html>