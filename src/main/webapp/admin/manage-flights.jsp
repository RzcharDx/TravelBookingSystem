<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<html>
<head>
    <title>Admin - Manage Flights</title>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; margin: 2rem; background-color: #f9f9f9; }
        h1, h2 { color: #333; }
        nav { margin-bottom: 2rem; }
        nav a { padding: 0.5rem 1rem; text-decoration: none; background-color: #007bff; color: white; border-radius: 4px; margin-right: 10px; }
        .container { display: flex; gap: 2rem; flex-wrap: wrap; }
        .form-container { background: #fff; padding: 2rem; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); flex: 1; min-width: 300px; }
        .table-container { background: #fff; padding: 2rem; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); flex: 2; min-width: 600px; overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid #ddd; padding: 0.75rem; text-align: left; white-space: nowrap; }
        th { background-color: #f4f4f4; }
        .form-group { margin-bottom: 1rem; }
        .form-group label { display: block; margin-bottom: 0.5rem; font-weight: 600; }
        .form-group input[type="text"],
        .form-group input[type="datetime-local"],
        .form-group input[type="number"] { width: 95%; padding: 0.5rem; border-radius: 4px; border: 1px solid #ccc; }
        .form-group input[type="checkbox"] { width: auto; margin-right: 0.5rem;}
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
    <%-- 1. 更新后的添加航班表单 --%>
    <div class="form-container">
        <h2>Add New Flight</h2>
        <form action="${pageContext.request.contextPath}/admin/flights" method="POST">
            <input type="hidden" name="action" value="create">

            <div class="form-group"><label for="airline">Airline:</label><input type="text" id="airline" name="airline" required></div>
            <div class="form-group"><label for="flightNumber">Flight Number:</label><input type="text" id="flightNumber" name="flightNumber" placeholder="e.g., BA101"></div>
            <div class="form-group"><label for="origin">Origin:</label><input type="text" id="origin" name="origin" required></div>
            <div class="form-group"><label for="destination">Destination:</label><input type="text" id="destination" name="destination" required></div>
            <div class="form-group"><label for="departureTime">Departure Time:</label><input type="datetime-local" id="departureTime" name="departureTime" required></div>
            <div class="form-group"><label for="arrivalTime">Arrival Time (Optional):</label><input type="datetime-local" id="arrivalTime" name="arrivalTime"></div>
            <div class="form-group"><label for="price">Price ($):</label><input type="number" id="price" name="price" step="0.01" min="0" required></div>
            <div class="form-group"><label for="availableSeats">Available Seats:</label><input type="number" id="availableSeats" name="availableSeats" min="0" required></div>
            <div class="form-group"><label for="cabinClass">Cabin Class:</label><input type="text" id="cabinClass" name="cabinClass" placeholder="e.g., Economy"></div>
            <div class="form-group"><input type="checkbox" id="isDirect" name="isDirect"><label for="isDirect" style="display: inline;">Direct Flight</label></div>

            <button type="submit" class="btn">Add Flight</button>
        </form>
    </div>

    <%-- 2. 更新后的航班表格 --%>
    <div class="table-container">
        <h2>Current Flights</h2>
        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>Airline</th>
                <th>Flight No.</th> <%-- 新增 --%>
                <th>Origin</th>
                <th>Destination</th>
                <th>Departure</th>
                <th>Arrival</th>   <%-- 新增 --%>
                <th>Price</th>
                <th>Seats</th>
                <th>Cabin</th>
                <th>Direct</th>
                <th>Action</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="flight" items="${flights}">
                <tr>
                    <td>${flight.id}</td>
                    <td>${flight.airline}</td>
                    <td>${flight.flightNumber}</td> <%-- 新增 --%>
                    <td>${flight.origin}</td>
                    <td>${flight.destination}</td>
                    <td>${fn:replace(flight.departureTime.toString(), 'T', ' ')}</td>
                    <td>${fn:replace(flight.arrivalTime.toString(), 'T', ' ')}</td> <%-- 新增 --%>
                    <td>$${flight.price}</td>
                    <td>${flight.availableSeats}</td>
                    <td>${flight.cabinClass}</td>
                    <td>${flight.direct ? 'Yes' : 'No'}</td>
                    <td>
                        <form action="${pageContext.request.contextPath}/admin/flights" method="POST" style="margin:0;">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="flightId" value="${flight.id}">
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