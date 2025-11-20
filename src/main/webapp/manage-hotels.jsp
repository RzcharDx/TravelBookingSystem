<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<html>
<head>
    <title>Admin - Manage Hotels</title>
    <%-- 使用与其他管理页面相同的样式 --%>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; margin: 2rem; background-color: #f9f9f9; }
        h1, h2 { color: #333; }
        nav { margin-bottom: 2rem; }
        nav a { padding: 0.5rem 1rem; text-decoration: none; background-color: #007bff; color: white; border-radius: 4px; margin-right: 10px;}
        .container { display: flex; gap: 2rem; flex-wrap: wrap; }
        .form-container { background: #fff; padding: 2rem; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); flex: 1; min-width: 300px; }
        .table-container { background: #fff; padding: 2rem; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); flex: 2; min-width: 600px; overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid #ddd; padding: 0.75rem; text-align: left; white-space: nowrap; }
        th { background-color: #f4f4f4; }
        .form-group { margin-bottom: 1rem; }
        .form-group label { display: block; margin-bottom: 0.5rem; font-weight: 600; }
        .form-group input { width: 95%; padding: 0.5rem; border-radius: 4px; border: 1px solid #ccc; }
        .btn { padding: 0.75rem 1.5rem; border: none; border-radius: 4px; background-color: #28a745; color: white; font-size: 1rem; cursor: pointer; }
        .btn-delete { background-color: #dc3545; padding: 0.25rem 0.5rem; font-size: 0.8rem; }
        .error-message { color: #D8000C; background-color: #FFD2D2; padding: 0.7rem; border-radius: 4px; margin-bottom: 1rem; border: 1px solid #D8000C;}
    </style>
</head>
<body>
<h1>Admin Dashboard</h1>
<nav>
    <a href="${pageContext.request.contextPath}/admin/flights">Manage Flights</a>
    <a href="${pageContext.request.contextPath}/admin/hotels">Manage Hotels</a>
    <a href="${pageContext.request.contextPath}/admin/cars">Manage Cars</a>
    <a href="${pageContext.request.contextPath}/logout">Logout</a>
</nav>

<%-- 显示来自 Servlet 的错误消息 --%>
<c:if test="${not empty errorMessage}">
    <p class="error-message">${errorMessage}</p>
</c:if>

<div class="container">
    <%-- Add New Hotel Form --%>
    <div class="form-container">
        <h2>Add New Hotel</h2>
        <form action="${pageContext.request.contextPath}/admin/hotels" method="POST">
            <input type="hidden" name="action" value="create">
            <div class="form-group">
                <label for="name">Hotel Name:</label>
                <input type="text" id="name" name="name" required>
            </div>
            <div class="form-group">
                <label for="location">Location:</label>
                <input type="text" id="location" name="location" required>
            </div>
            <div class="form-group">
                <label for="pricePerNight">Price per Night ($):</label>
                <input type="number" id="pricePerNight" name="pricePerNight" step="0.01" min="0" required>
            </div>
            <div class="form-group">
                <label for="availableRooms">Available Rooms:</label>
                <input type="number" id="availableRooms" name="availableRooms" min="0" required>
            </div>
            <%-- 新增 Max Guests --%>
            <div class="form-group">
                <label for="maxGuestsPerRoom">Max Guests per Room:</label>
                <input type="number" id="maxGuestsPerRoom" name="maxGuestsPerRoom" min="1" value="2" required> <%-- 默认值为 2 --%>
            </div>
            <button type="submit" class="btn">Add Hotel</button>
        </form>
    </div>

    <%-- Current Hotels Table --%>
    <div class="table-container">
        <h2>Current Hotels</h2>
        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Location</th>
                <th>Price/Night</th>
                <th>Rooms Avail.</th>
                <th>Max Guests</th> <%-- 新增 --%>
                <th>Action</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="hotel" items="${hotels}">
                <tr>
                    <td>${hotel.id}</td>
                    <td>${fn:escapeXml(hotel.name)}</td>
                    <td>${fn:escapeXml(hotel.location)}</td>
                    <td>$<fmt:formatNumber value="${hotel.pricePerNight}" type="currency" currencySymbol="" maxFractionDigits="2" minFractionDigits="2"/></td>
                    <td>${hotel.availableRooms}</td>
                    <td>${hotel.maxGuestsPerRoom}</td> <%-- 新增 --%>
                    <td>
                        <form action="${pageContext.request.contextPath}/admin/hotels" method="POST" style="margin:0;">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="hotelId" value="${hotel.id}">
                            <button type="submit" class="btn btn-delete">Delete</button>
                        </form>
                            <%-- (可以在此添加 "Edit" 按钮和逻辑) --%>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>