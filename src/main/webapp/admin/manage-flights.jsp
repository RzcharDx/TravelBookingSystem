<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- 导入 JSTL 核心库，用于循环和 URL --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>Admin - Manage Flights</title>
    <%-- 基础样式，满足 UI 要求 [cite: 39] --%>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; margin: 2rem; background-color: #f9f9f9; }
        h1, h2 { color: #333; }
        nav { margin-bottom: 2rem; }
        nav a { padding: 0.5rem 1rem; text-decoration: none; background-color: #007bff; color: white; border-radius: 4px; }
        .container { display: flex; gap: 2rem; }
        .form-container, .table-container { background: #fff; padding: 2rem; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        .form-container { flex: 1; }
        .table-container { flex: 2; }
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid #ddd; padding: 0.75rem; text-align: left; }
        th { background-color: #f4f4f4; }
        tr:nth-child(even) { background-color: #f9f9f9; }
        .form-group { margin-bottom: 1rem; }
        .form-group label { display: block; margin-bottom: 0.5rem; font-weight: 600; }
        .form-group input { width: 95%; padding: 0.5rem; border-radius: 4px; border: 1px solid #ccc; }
        .btn { padding: 0.75rem 1.5rem; border: none; border-radius: 4px; background-color: #28a745; color: white; font-size: 1rem; cursor: pointer; }
        .btn-delete { background-color: #dc3545; padding: 0.25rem 0.5rem; font-size: 0.8rem; }
    </style>
</head>
<body>
<h1>Admin Dashboard</h1>

<nav>
    <%-- 确保使用 JSTL 的 <c:url> 或 contextPath 来构建 URL --%>
    <a href="${pageContext.request.contextPath}/logout">Logout</a>
    <%-- (您可以在此处添加指向 "Manage Hotels" 等的链接) --%>
</nav>

<div class="container">

    <%-- 1. 添加新航班的表单 --%>
    <div class="form-container">
        <h2>Add New Flight</h2>
        <form action="${pageContext.request.contextPath}/admin/flights" method="POST">
            <%-- 隐藏的 "action" 字段，用于告诉 Servlet 这是 "create" 操作 --%>
            <input type="hidden" name="action" value="create">

            <div class="form-group">
                <label for="airline">Airline:</label>
                <input type="text" id="airline" name="airline" required>
            </div>
            <div class="form-group">
                <label for="origin">Origin:</label>
                <input type="text" id="origin" name="origin" required>
            </div>
            <div class="form-group">
                <label for="destination">Destination:</label>
                <input type="text" id="destination" name="destination" required>
            </div>
            <div class="form-group">
                <label for="departureTime">Departure Time:</label>
                <input type="datetime-local" id="departureTime" name="departureTime" required>
            </div>
            <div class="form-group">
                <label for="price">Price ($):</label>
                <input type="number" id="price" name="price" step="0.01" min="0" required>
            </div>
            <div class="form-group">
                <label for="availableSeats">Available Seats:</label>
                <input type="number" id="availableSeats" name="availableSeats" min="0" required>
            </div>
            <button type="submit" class="btn">Add Flight</button>
        </form>
    </div>

    <%-- 2. 显示所有航班的表格 --%>
    <div class="table-container">
        <h2>Current Flights</h2>
        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>Airline</th>
                <th>Origin</th>
                <th>Destination</th>
                <th>Departure Time</th>
                <th>Price</th>
                <th>Seats</th>
                <th>Action</th>
            </tr>
            </thead>
            <tbody>
            <%--
               循环遍历由 Servlet 在 doGet() 中设置的 "flights" 列表
               [c:forEach]
            --%>
            <c:forEach var="flight" items="${flights}">
                <tr>
                    <td>${flight.id}</td>
                    <td>${flight.airline}</td>
                    <td>${flight.origin}</td>
                    <td>${flight.destination}</td>
                    <td>${flight.departureTime}</td>
                    <td>$${flight.price}</td>
                    <td>${flight.availableSeats}</td>
                    <td>
                            <%--
                               删除按钮位于其自己的小表单中。
                               这允许我们向 Servlet 发送一个 "delete" POST 请求。
                            --%>
                        <form action="${pageContext.request.contextPath}/admin/flights" method="POST" style="margin:0;">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="flightId" value="${flight.id}">
                            <button type="submit" class="btn btn-delete">Delete</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>