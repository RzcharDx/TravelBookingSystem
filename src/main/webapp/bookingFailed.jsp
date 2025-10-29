<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Booking Failed</title>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; text-align: center; margin-top: 5rem; }
        .container { background: #fff; padding: 2rem; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); display: inline-block; }
        h1 { color: #dc3545; }
        a { text-decoration: none; color: #007bff; }
    </style>
</head>
<body>
<div class="container">
    <h1>✖ 预订失败</h1>
    <p>抱歉，该项目可能已售罄或请求无效。</p>
    <p><a href="${pageContext.request.contextPath}/index.jsp">返回主页重试</a></p>
</div>
</body>
</html>
