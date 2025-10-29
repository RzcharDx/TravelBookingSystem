<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>My Profile - Travel Booking</title>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; margin: 2rem; background-color: #f9f9f9; }
        .container { background: #fff; padding: 2rem; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); max-width: 800px; margin: auto; }
        h1, h2 { color: #333; }
        nav { margin-bottom: 2rem; }
        nav a { padding: 0.5rem 1rem; text-decoration: none; background-color: #007bff; color: white; border-radius: 4px; margin-right: 1rem; }
        table { width: 100%; border-collapse: collapse; margin-top: 1rem; }
        th, td { border: 1px solid #ddd; padding: 0.75rem; text-align: left; }
        th { background-color: #f4f4f4; }
        tr:nth-child(even) { background-color: #f9f9f9; }
        .user-info { margin-bottom: 2rem; }
    </style>
</head>
<body>
<div class="container">
    <h1>My Profile</h1>

    <nav>
        <a href="${pageContext.request.contextPath}/index.jsp">Home</a>
        <a href="${pageContext.request.contextPath}/logout">Logout</a>
    </nav>

    <%-- 1. 显示用户信息 (可以从 request 或 session 中获取) --%>
    <div class="user-info">
        <p><strong>Username:</strong> ${sessionScope.loggedInUser.username}</p>
        <p><strong>Role:</strong> ${sessionScope.loggedInUser.role}</p>
    </div>

    <h2>My Bookings</h2>

    <%-- 2. 检查是否有预订记录 --%>
    <c:if test="${empty bookings}">
        <p>You have no bookings yet.</p>
    </c:if>

    <%-- 3. 如果有预订，则显示表格 --%>
    <c:if test="${not empty bookings}">
        <table>
            <thead>
            <tr>
                <th>Booking ID</th>
                <th>Booking Date</th>
                <th>Total Price</th>
                    <%-- <th>Description</th> (如果您在 Booking.java 中添加了 description) --%>
            </tr>
            </thead>
            <tbody>
                <%-- 4. 循环遍历由 ProfileServlet 传入的 "bookings" 列表 --%>
            <c:forEach var="booking" items="${bookings}">
                <tr>
                    <td>${booking.id}</td>
                    <td>${booking.bookingDate}</td>
                    <td>$${booking.totalPrice}</td>
                        <%-- <td>${booking.description}</td> --%>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </c:if>
</div>
</body>
</html>
