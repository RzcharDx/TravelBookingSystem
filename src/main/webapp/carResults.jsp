<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>Car Rental Search Results</title>
    <%-- 使用与其他结果页面相同的样式 --%>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; margin: 2rem; background-color: #f9f9f9; }
        h2 { color: #333; }
        .container { background: #fff; padding: 2rem; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid #ddd; padding: 0.75rem; text-align: left; }
        th { background-color: #f4f4f4; }
        .btn-book { padding: 0.25rem 0.5rem; background-color: #007bff; color: white; text-decoration: none; border-radius: 4px; font-size: 0.8rem; }
        .no-results { color: #555; font-style: italic; }
        .back-link { margin-top: 1.5rem; display: inline-block; }
    </style>
</head>
<body>
<div class="container">
    <h2>Available Car Rentals</h2>
    <c:if test="${empty cars}">
        <p class="no-results">Sorry, no cars found for your search criteria.</p>
    </c:if>
    <c:if test="${not empty cars}">
        <table>
            <thead>
            <tr>
                <th>Company</th>
                <th>Model</th>
                <th>Pickup Location</th>
                <th>Price/Day</th>
                <th>Action</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="car" items="${cars}">
                <tr>
                    <td>${car.company}</td>
                    <td>${car.model}</td>
                    <td>${car.pickupLocation}</td>
                    <td>$${car.pricePerDay}</td>
                    <td>
                            <%-- 链接到 BookingServlet --%>
                        <a href="${pageContext.request.contextPath}/book?type=car&id=${car.id}" class="btn-book">
                            Book Now
                        </a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </c:if>
    <a href="index.jsp" class="back-link">← Back to Search</a>
</div>
</body>
</html>
