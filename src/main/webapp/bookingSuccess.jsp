<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Booking Confirmed</title>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; text-align: center; margin-top: 5rem; }
        .container { background: #fff; padding: 2rem; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); display: inline-block; }
        h1 { color: #28a745; }
        a { text-decoration: none; color: #007bff; }
    </style>
</head>
<body>
<div class="container">
    <h1>✔ 预订成功！</h1>
    <p>您的预订已确认。</p>
    <p>
        <a href="${pageContext.request.contextPath}/profile.jsp">查看我的预订</a> |
        <a href="${pageContext.request.contextPath}/index.jsp">返回主页</a>
    </p>
</div>
</body>
</html>
