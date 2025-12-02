<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>


<!DOCTYPE html>
<html lang="en">
<head>
    <title>My Profile - Travel Booking</title>
    <style>
        /* ... (保持之前的 CSS 样式不变，为了节省篇幅这里省略头部 CSS，请保留您之前的样式) ... */
        /* 请务必保留之前的 CSS，只添加或修改以下部分： */
        :root {
            --primary-blue: #0770e3; --dark-blue: #02122c; --bg-color: #f1f2f8; --text-color: #111236; --white: #ffffff; --border-color: #ddd; --success-green: #00a698;
        }
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; background-color: var(--bg-color); color: var(--text-color); margin: 0; }
        nav { background-color: var(--dark-blue); padding: 1rem 2rem; display: flex; justify-content: space-between; align-items: center; height: 80px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .logo { font-size: 1.8rem; font-weight: 800; color: var(--white); text-decoration: none; letter-spacing: -0.5px; }
        .nav-links a { color: var(--white); text-decoration: none; font-weight: 600; margin-left: 1.5rem; font-size: 0.95rem; }
        .main-container { max-width: 1100px; margin: 2rem auto; padding: 0 1rem; display: flex; gap: 2rem; }
        .sidebar { flex: 0 0 250px; display: none; }
        @media (min-width: 768px) { .sidebar { display: block; } }
        .sidebar-menu { background: var(--white); border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); padding: 1rem 0; list-style: none; }
        .sidebar-menu li a { display: block; padding: 0.8rem 1.5rem; color: var(--text-color); text-decoration: none; font-weight: 500; border-left: 3px solid transparent; transition: background 0.2s; }
        .sidebar-menu li a:hover { background-color: #f9f9f9; }
        .sidebar-menu li a.active { background-color: #f0f7ff; color: var(--primary-blue); border-left-color: var(--primary-blue); font-weight: 700; }
        .content-area { flex: 1; }
        .profile-header { background: var(--white); border-radius: 8px; padding: 2rem; box-shadow: 0 2px 8px rgba(0,0,0,0.05); margin-bottom: 2rem; display: flex; align-items: center; gap: 1.5rem; }
        .avatar-placeholder { width: 80px; height: 80px; background-color: #e1f0ff; color: var(--primary-blue); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 2.5rem; font-weight: bold; }
        .user-details h1 { margin: 0 0 0.5rem 0; font-size: 1.8rem; }
        .user-details p { margin: 0; color: #666; }
        .role-badge { display: inline-block; background-color: #eee; padding: 0.2rem 0.6rem; border-radius: 4px; font-size: 0.8rem; font-weight: 600; color: #555; margin-top: 0.5rem; }
        .section-title { font-size: 1.5rem; font-weight: 700; margin-bottom: 1rem; color: var(--text-color); }

        /* --- 预订列表样式更新 --- */
        .booking-list { display: flex; flex-direction: column; gap: 1rem; }
        .booking-card { background: var(--white); border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); padding: 1.5rem; border: 1px solid transparent; transition: transform 0.2s, box-shadow 0.2s; display: flex; justify-content: space-between; align-items: center; }
        .booking-card:hover { transform: translateY(-2px); box-shadow: 0 6px 12px rgba(0,0,0,0.1); border-color: #ddd; }
        .booking-info { display: flex; flex-direction: column; gap: 0.5rem; flex: 1; }
        .booking-id { font-size: 0.85rem; color: #888; text-transform: uppercase; letter-spacing: 0.5px; }
        .booking-date { font-size: 0.9rem; color: #666; }

        /* 描述字段样式 */
        .booking-desc { color: var(--text-color); font-size: 1.1rem; font-weight: 600; margin-top: 0.2rem; }

        .booking-status-area { text-align: right; display: flex; flex-direction: column; gap: 0.5rem; align-items: flex-end; min-width: 120px; }
        .status-tag { padding: 0.3rem 0.8rem; border-radius: 20px; font-size: 0.8rem; font-weight: 700; display: inline-block; }

        /* 状态颜色 */
        .status-confirmed { color: var(--success-green); background-color: #e6fcf5; }
        .status-cancelled { color: #d32f2f; background-color: #ffebee; }

        .total-price { font-size: 1.3rem; font-weight: 800; color: var(--text-color); }

        /* 取消按钮 */
        .btn-cancel {
            background-color: #fff; color: #d32f2f; border: 1px solid #d32f2f;
            padding: 0.4rem 0.8rem; border-radius: 4px; font-size: 0.85rem; cursor: pointer; transition: all 0.2s;
            margin-top: 0.5rem;
        }
        .btn-cancel:hover { background-color: #d32f2f; color: #fff; }

        .no-bookings { text-align: center; padding: 4rem 2rem; background: var(--white); border-radius: 8px; color: #666; }
        .btn-start-search { display: inline-block; margin-top: 1rem; padding: 0.8rem 1.5rem; background-color: var(--primary-blue); color: white; text-decoration: none; border-radius: 4px; font-weight: 700; }
    </style>
</head>
<body>
<nav>
    <a href="<c:url value='/'/>" class="logo">GoTour</a>
    <div class="nav-links">
        <a href="<c:url value='/'/>">Home</a>
        <a href="<c:url value='/logout'/>">Log out</a>
    </div>
</nav>

<div class="main-container">
    <aside class="sidebar">
        <ul class="sidebar-menu">
            <li><a href="#" class="active">Trips</a></li>
            <li><a href="#">Account details</a></li>
            <li><a href="#">Preferences</a></li>
            <c:if test="${sessionScope.loggedInUser.role == 'ADMIN'}">
                <li><a href="<c:url value='/admin/flights'/>" style="color: var(--primary-blue);">Admin Dashboard</a></li>
            </c:if>
        </ul>
    </aside>

    <main class="content-area">
        <div class="profile-header">
            <div class="avatar-placeholder">
                ${fn:substring(sessionScope.loggedInUser.username, 0, 1).toUpperCase()}
            </div>
            <div class="user-details">
                <h1>Hi, ${fn:escapeXml(sessionScope.loggedInUser.username)}</h1>
                <span class="role-badge">${sessionScope.loggedInUser.role} ACCOUNT</span>
            </div>
        </div>

        <h2 class="section-title">Your Trips</h2>

        <c:choose>
            <c:when test="${empty bookings}">
                <div class="no-bookings">
                    <h3>No upcoming trips</h3>
                    <p>Time to start planning your next adventure!</p>
                    <a href="<c:url value='/'/>" class="btn-start-search">Search Flights</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="booking-list">
                    <c:forEach var="booking" items="${bookings}">
                        <div class="booking-card">
                            <div class="booking-info">
                                <span class="booking-id">Order #${booking.id}</span>
                                    <%-- 显示新的描述字段 --%>
                                <div class="booking-desc">
                                    <c:out value="${booking.description}" default="Travel Booking" />
                                </div>
                                <div class="booking-date">
                                    Booked on <fmt:parseDate value="${ fn:replace(booking.bookingDate.toString(), 'T', ' ') }" pattern="yyyy-MM-dd HH:mm" var="parsedDate" type="both" />
                                    <fmt:formatDate value="${parsedDate}" pattern="MMM dd, yyyy" />
                                </div>
                            </div>
                            <div class="booking-status-area">
                                    <%-- 动态状态标签 --%>
                                <c:choose>
                                    <c:when test="${booking.status == 'CANCELLED'}">
                                        <span class="status-tag status-cancelled">Cancelled</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-tag status-confirmed">Confirmed</span>
                                    </c:otherwise>
                                </c:choose>

                                <span class="total-price">
                                        <fmt:formatNumber value="${booking.totalPrice}" type="currency" currencySymbol="$" />
                                    </span>

                                    <%-- 取消按钮 (仅当状态为 CONFIRMED 时显示) --%>
                                <c:if test="${booking.status != 'CANCELLED'}">
                                    <form action="<c:url value='/cancelBooking'/>" method="POST" style="margin:0;">
                                        <input type="hidden" name="bookingId" value="${booking.id}">
                                        <button type="submit" class="btn-cancel" onclick="return confirm('Are you sure you want to cancel this booking?')">Cancel booking</button>
                                    </form>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </main>
</div>
</body>
</html>