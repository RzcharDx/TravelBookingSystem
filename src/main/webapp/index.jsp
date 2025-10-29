<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<html>
<head>
    <title>Search Flights, Hotels & Cars - Travel Booking</title>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; margin: 0; padding: 0; background-color: #f4f7f6; color: #333; }
        .container { max-width: 900px; margin: 2rem auto; background-color: #ffffff; padding: 0; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); overflow: hidden; }
        nav { background-color: #003b95; padding: 1rem 2rem; display: flex; justify-content: space-between; align-items: center; }
        nav .logo { color: white; font-size: 1.5rem; font-weight: bold; text-decoration: none; }
        nav .user-links a { margin-left: 1rem; text-decoration: none; color: white; font-weight: 500; }
        nav .user-links a:hover { text-decoration: underline; }
        nav .user-links span { color: #e0e0e0; margin-right: 1rem;}
        .tabs { display: flex; background-color: #003b95; padding-left: 2rem; }
        .tab-button { background-color: #003b95; color: white; border: none; padding: 1rem 1.5rem; cursor: pointer; font-size: 1rem; border-bottom: 3px solid transparent; }
        .tab-button.active { background-color: #ffffff; color: #003b95; border-bottom: 3px solid #007bff; border-top-left-radius: 4px; border-top-right-radius: 4px; }
        .tab-content { display: none; padding: 2rem; border-top: 1px solid #ddd; }
        .tab-content.active { display: block; }
        h1 { text-align: center; color: #003b95; margin: 2rem 0; padding: 0 2rem;} /* Added padding */
        h2 { color: #333; margin-top: 0; margin-bottom: 1.5rem;}
        .search-form .form-row { display: flex; gap: 1rem; margin-bottom: 1rem; flex-wrap: wrap; }
        .search-form .form-group { flex: 1; min-width: 150px; }
        .search-form label { display: block; margin-bottom: 0.5rem; font-weight: 600; font-size: 0.9rem; }
        .search-form input[type="text"],
        .search-form input[type="date"],
        .search-form input[type="number"],
        .search-form input[type="time"],
        .search-form select { width: 100%; box-sizing: border-box; padding: 0.75rem; border-radius: 4px; border: 1px solid #ccc; font-size: 1rem; }
        .search-form .btn { padding: 1rem; border: none; border-radius: 4px; background-color: #007bff; color: white; font-size: 1.1rem; cursor: pointer; min-width: 120px; flex-grow: 0; align-self: flex-end; }
        .search-form .btn:hover { background-color: #0056b3; }
        .options { margin-top: 1rem; font-size: 0.9rem; }
        .options label { margin-right: 1.5rem; display: inline-flex; align-items: center; } /* Improved alignment */
        .options input[type="checkbox"] { margin-right: 0.5rem; }
    </style>
</head>
<body>
<div class="container">
    <%-- 1. 顶部导航 --%>
    <nav>
        <a href="<c:url value='/'/>" class="logo">TravelBooking</a>
        <div class="user-links">
            <c:choose>
                <c:when test="${not empty sessionScope.loggedInUser}">
                    <span>Hi, ${fn:escapeXml(sessionScope.loggedInUser.username)}!</span> <%-- Added fn:escapeXml for security --%>
                    <a href="<c:url value='/profile'/>">Profile</a>
                    <c:if test="${sessionScope.loggedInUser.role == 'ADMIN'}">
                        <a href="<c:url value='/admin/flights'/>">Admin</a>
                    </c:if>
                    <a href="<c:url value='/logout'/>">Logout</a>
                </c:when>
                <c:otherwise>
                    <a href="<c:url value='/login'/>">Login</a>
                    <a href="<c:url value='/register'/>">Register</a>
                </c:otherwise>
            </c:choose>
        </div>
    </nav>

    <h1>Book Your Next Trip</h1>

    <%-- 2. Tab 按钮 --%>
    <div class="tabs">
        <button class="tab-button active" onclick="openTab(event, 'flights')">✈️ Flights</button>
        <button class="tab-button" onclick="openTab(event, 'hotels')">🏨 Hotels</button>
        <button class="tab-button" onclick="openTab(event, 'cars')">🚗 Car Rental</button>
    </div>

    <%-- 3. Tab 内容 --%>
    <div id="flights" class="tab-content active">
        <h2>Search for Flights</h2>
        <form action="<c:url value='/searchFlights'/>" method="GET" class="search-form">
            <div class="form-row">
                <div class="form-group">
                    <label for="origin">From</label>
                    <input type="text" id="origin" name="origin" required placeholder="City or airport">
                </div>
                <div class="form-group">
                    <label for="destination">To</label>
                    <input type="text" id="destination" name="destination" required placeholder="City or airport">
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label for="departDate">Depart</label>
                    <input type="date" id="departDate" name="departDate">
                </div>
                <div class="form-group">
                    <label for="returnDate">Return</label>
                    <input type="date" id="returnDate" name="returnDate" placeholder="Leave blank for one-way">
                </div>
                <div class="form-group">
                    <label for="travelers">Travelers</label>
                    <input type="number" id="travelers" name="travelers" min="1" value="1">
                </div>
                <button type="submit" class="btn">Search</button>
            </div>
            <div class="options">
                <label><input type="checkbox" name="directOnly" value="true"> Direct flights only</label>
            </div>
        </form>
    </div>

    <div id="hotels" class="tab-content">
        <h2>Search for Hotels</h2>
        <form action="<c:url value='/searchHotels'/>" method="GET" class="search-form">
            <div class="form-row">
                <div class="form-group" style="flex-grow: 2;">
                    <label for="location">Destination</label>
                    <input type="text" id="location" name="location" required placeholder="City, address or landmark">
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label for="checkin">Check-in</label>
                    <input type="date" id="checkin" name="checkin">
                </div>
                <div class="form-group">
                    <label for="checkout">Check-out</label>
                    <input type="date" id="checkout" name="checkout">
                </div>
                <div class="form-group">
                    <label for="guests">Guests</label>
                    <input type="number" id="guests" name="guests" min="1" value="2">
                </div>
                <button type="submit" class="btn">Search</button>
            </div>
        </form>
    </div>

    <div id="cars" class="tab-content">
        <h2>Search for Car Rentals</h2>
        <form action="<c:url value='/searchCars'/>" method="GET" class="search-form">
            <div class="form-row">
                <div class="form-group" style="flex-grow: 2;">
                    <label for="pickupLocation">Pick-up location</label>
                    <input type="text" id="pickupLocation" name="pickupLocation" required placeholder="City, airport or address">
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label for="pickupDate">Pick-up Date</label>
                    <input type="date" id="pickupDate" name="pickupDate">
                </div>
                <div class="form-group">
                    <label for="pickupTime">Time</label>
                    <input type="time" id="pickupTime" name="pickupTime" value="10:00">
                </div>
                <div class="form-group">
                    <label for="dropoffDate">Drop-off Date</label>
                    <input type="date" id="dropoffDate" name="dropoffDate">
                </div>
                <div class="form-group">
                    <label for="dropoffTime">Time</label>
                    <input type="time" id="dropoffTime" name="dropoffTime" value="10:00">
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label for="driverAge">Driver's Age</label>
                    <input type="number" id="driverAge" name="driverAge" min="18" max="99" value="30">
                </div>
                <button type="submit" class="btn">Search</button>
            </div>
        </form>
    </div>
</div>

<script>
    // JavaScript for Tab Switching
    function openTab(evt, tabName) {
        var i, tabcontent, tablinks;
        tabcontent = document.getElementsByClassName("tab-content");
        for (i = 0; i < tabcontent.length; i++) {
            tabcontent[i].style.display = "none";
        }
        tablinks = document.getElementsByClassName("tab-button");
        for (i = 0; i < tablinks.length; i++) {
            tablinks[i].className = tablinks[i].className.replace(" active", "");
        }
        document.getElementById(tabName).style.display = "block";
        evt.currentTarget.className += " active";
    }
    // Optional: Activate the first tab on page load
    // document.addEventListener('DOMContentLoaded', (event) => {
    //     document.querySelector('.tab-button').click(); // Activate first tab
    // });
</script>
</body>
</html>