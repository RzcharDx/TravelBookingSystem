<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>Admin - Manage Car Rentals</title>
    <%-- 使用与其他管理页面相同的样式 --%>
    <style>
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
    <a href="${pageContext.request.contextPath}/admin/hotels">Manage Hotels</a>
    <a href="${pageContext.request.contextPath}/admin/cars">Manage Cars</a> <%-- Link to itself --%>
    <a href="${pageContext.request.contextPath}/logout">Logout</a>
</nav>

<div class="container">
    <%-- Add New Car Form --%>
    <div class="form-container">
        <h2>Add New Car Rental</h2>
        <form action="${pageContext.request.contextPath}/admin/cars" method="POST">
            <input type="hidden" name="action" value="create">
            <div class="form-group">
                <label for="company">Company:</label>
                <input type="text" id="company" name="company" required>
            </div>
            <div class="form-group">
                <label for="model">Model:</label>
                <input type="text" id="model" name="model" required>
            </div>
            <div class="form-group">
                <label for="pickupLocation">Pickup Location:</label>
                <input type="text" id="pickupLocation" name="pickupLocation" required>
            </div>
            <div class="form-group">
                <label for="pricePerDay">Price per Day ($):</label>
                <input type="number" id="pricePerDay" name="pricePerDay" step="0.01" min="0" required>
            </div>
            <div class="form-group">
                <label for="availableCars">Available Cars:</label>
                <input type="number" id="availableCars" name="availableCars" min="0" required>
            </div>
            <button type="submit" class="btn">Add Car</button>
        </form>
    </div>

    <%-- Current Cars Table --%>
    <div class="table-container">
        <h2>Current Car Rentals</h2>
        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>Company</th>
                <th>Model</th>
                <th>Location</th>
                <th>Price/Day</th>
                <th>Available</th>
                <th>Action</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="car" items="${cars}">
                <tr>
                    <td>${car.id}</td>
                    <td>${car.company}</td>
                    <td>${car.model}</td>
                    <td>${car.pickupLocation}</td>
                    <td>$${car.pricePerDay}</td>
                    <td>${car.availableCars}</td>
                    <td>
                        <form action="${pageContext.request.contextPath}/admin/cars" method="POST" style="margin:0;">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="carId" value="${car.id}">
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
