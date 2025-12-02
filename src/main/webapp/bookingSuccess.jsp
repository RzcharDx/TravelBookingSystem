<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Booking Confirmed</title>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; text-align: center; margin-top: 5rem; background-color: #f4f7f6; }
        .container { background: #fff; padding: 3rem; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); display: inline-block; max-width: 600px; width: 90%; }
        h1 { color: #00a698; margin-bottom: 0.5rem; }
        .order-id { color: #666; font-size: 0.9rem; margin-bottom: 2rem; text-transform: uppercase; letter-spacing: 1px; }
        .details-box { background: #f8f9fa; padding: 1.5rem; border-radius: 6px; text-align: left; margin-bottom: 2rem; border-left: 4px solid #00a698; }
        .details-box h3 { margin-top: 0; color: #333; }
        .details-row { display: flex; justify-content: space-between; margin-bottom: 0.5rem; }
        .label { color: #666; font-weight: 500; }
        .value { font-weight: 700; color: #111; }
        .btn { display: inline-block; padding: 0.8rem 1.5rem; background-color: #0770e3; color: white; text-decoration: none; border-radius: 4px; font-weight: 600; transition: background 0.2s; }
        .btn:hover { background-color: #0056b3; }
        .link-secondary { display: block; margin-top: 1rem; color: #666; text-decoration: none; font-size: 0.9rem; }
        .link-secondary:hover { text-decoration: underline; }
    </style>
</head>
<body>
<div class="container">
    <h1>✔ Booking Confirmed!</h1>
    <p class="order-id">Order ID: #${param.id}</p>

    <div class="details-box">
        <h3>Booking Details</h3>
        <div class="details-row">
            <span class="label">Item:</span>
            <span class="value">${param.desc}</span>
        </div>
        <div class="details-row">
            <span class="label">Total Price:</span>
            <span class="value">$${param.price}</span>
        </div>
        <div class="details-row">
            <span class="label">Status:</span>
            <span class="value" style="color: #00a698;">Confirmed</span>
        </div>
    </div>

    <a href="${pageContext.request.contextPath}/profile" class="btn">View My Trips</a>
    <a href="${pageContext.request.contextPath}/" class="link-secondary">Back to Home</a>
</div>
</body>
</html>