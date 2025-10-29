<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- 导入 JSTL 核心标签库，用于处理 URL 和条件逻辑 --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>Login - Travel Booking</title>
    <%-- 项目要求：一个可用、美观的 UI [cite: 43, 46]。添加一些基本样式。 --%>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; display: grid; place-items: center; min-height: 90vh; background-color: #f4f7f6; }
        .container { width: 350px; padding: 2rem; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); background-color: #ffffff; }
        .form-group { margin-bottom: 1.5rem; }
        .form-group label { display: block; margin-bottom: 0.5rem; font-weight: 600; }
        .form-group input { width: 100%; box-sizing: border-box; padding: 0.75rem; border-radius: 4px; border: 1px solid #ccc; }
        .btn { width: 100%; padding: 0.75rem; border: none; border-radius: 4px; background-color: #007bff; color: white; font-size: 1rem; cursor: pointer; }
        .error { color: #D8000C; background-color: #FFD2D2; padding: 0.5rem; border-radius: 4px; }
        .success { color: #4F8A10; background-color: #DFF2BF; padding: 0.5rem; border-radius: 4px; }
        .footer-link { text-align: center; margin-top: 1.5rem; }
    </style>
</head>
<body>
<div class="container">
    <h2>Travel Booking Login</h2>

    <%-- 1. 检查来自 LoginServlet 的错误参数 --%>
    <c:if test="${param.error == 'true'}">
        <p class="error">用户名或密码无效。请重试。</p>
    </c:if>

    <%-- 2. 检查来自 RegisterServlet 的成功参数 --%>
    <c:if test="${param.success == 'true'}">
        <p class="success">注册成功！请登录。</p>
    </c:if>

    <%-- 3. 登录表单，提交到 LoginServlet --%>
    <form action="${pageContext.request.contextPath}/login" method="POST">
        <div class="form-group">
            <label for="username">Username:</label>
            <input type="text" id="username" name="username" required>
        </div>
        <div class="form-group">
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required>
        </div>
        <button type="submit" class="btn">Login</button>
    </form>

    <div class="footer-link">
        <p>没有帐户？ <a href="register.jsp">在此注册</a></p>
    </div>
</div>
</body>
</html>
