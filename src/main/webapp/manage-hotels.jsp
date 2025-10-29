<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>Admin - Manage Hotels</title>
    <%-- Use the same stylesheet or styles as manage-flights.jsp --%>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/styles/admin.css"> <%-- Example CSS link --%>
    <style> /* Or paste the styles directly */
    body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; margin: 2rem; background-color: #f9f9f9; }
    h1, h2 { color: #333; }
    nav { margin-bottom: 2rem; }
    nav a { padding: 0.5rem 1rem; text-decoration: none; background-color: #007bff; color: white; border-radius: 4px; margin-right: 10px;}
    .container { display: flex; gap: 2rem; }
    .form-container, .table-container { background: #fff; padding: 2rem; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
    .form-container { flex: 1; }
    .table-container { flex: 2; }
    table { width: 100%; border-collapse: collapse; }
    th, td { border: 1px solid #ddd; padding: 0.75rem; text-align: left; }
    th { background-color: #f4f4f4; }
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
    <a href="${pageContext.request.contextPath}/admin/flights">Manage Flights</a>
    <a href="${pageContext.request.contextPath}/admin/hotels">Manage Hotels</a> <%-- Link to itself --%>
    <a href="${pageContext.request.contextPath}/logout">Logout</a>
</nav>

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
                <th>Rooms</th>
                <th>Action</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="hotel" items="${hotels}">
                <tr>
                    <td>${hotel.id}</td>
                    <td>${hotel.name}</td>
                    <td>${hotel.location}</td>
                    <td>$${hotel.pricePerNight}</td>
                    <td>${hotel.availableRooms}</td>
                    <td>
                        <form action="${pageContext.request.contextPath}/admin/hotels" method="POST" style="margin:0;">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="hotelId" value="${hotel.id}">
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