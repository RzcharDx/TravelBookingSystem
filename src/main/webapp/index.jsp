<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GoTour Style Travel - Cheap Flights, Hotels & Cars</title>
    <style>
        /* --- 核心变量 --- */
        :root {
            --primary-blue: #0770e3;
            --dark-blue: #02122c;
            --bg-color: #f1f2f8;
            --text-color: #111236;
            --white: #ffffff;
            --hover-blue: #055cb8;
            --footer-text: #b2b2b2;
            --container-width: 1100px;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; background-color: var(--bg-color); color: var(--text-color); display: flex; flex-direction: column; min-height: 100vh; }

        /* --- 导航栏 --- */
        nav {
            background-color: var(--dark-blue);
            padding: 0 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            height: 80px;
            position: relative;
            z-index: 100;
        }
        .logo { font-size: 1.8rem; font-weight: 800; color: var(--white); text-decoration: none; letter-spacing: -0.5px; }
        .user-links { display: flex; align-items: center; gap: 1.5rem; }
        .user-links span { color: #e0e0e0; font-weight: 500; }
        .user-links a { color: var(--white); text-decoration: none; font-weight: 600; font-size: 0.95rem; transition: opacity 0.2s; }
        .user-links a:hover { opacity: 0.8; }
        .btn-login { border: 1px solid rgba(255,255,255,0.5); padding: 0.5rem 1.2rem; border-radius: 4px; }
        .btn-login:hover { border-color: var(--white); background: rgba(255,255,255,0.1); }

        /* --- Hero 区域 --- */
        .hero-section {
            background-color: var(--dark-blue);
            background-image: linear-gradient(rgba(2, 18, 44, 0.6), rgba(2, 18, 44, 0.8)), url('https://images.unsplash.com/photo-1436491865332-7a61a109cc05?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80');
            background-size: cover;
            background-position: center;
            padding: 4rem 1rem 8rem 1rem;
            text-align: center;
            position: relative;
        }
        .hero-title { color: var(--white); font-size: 2.5rem; margin-bottom: 2rem; text-shadow: 0 2px 4px rgba(0,0,0,0.3); animation: fadeInUp 0.8s ease-out; }

        /* --- [修改] 搜索小部件卡片 --- */
        .search-widget {
            max-width: var(--container-width); /* 加宽到 1200px */
            width: 95%; /* 确保在小屏幕上有边距 */
            margin: -4rem auto 3rem auto;
            background: var(--white);
            border-radius: 8px;
            box-shadow: 0 12px 24px rgba(0,0,0,0.15);
            position: relative;
            z-index: 10;
            animation: slideUp 0.6s ease-out forwards;
            opacity: 0;
            transform: translateY(20px);
            min-height: 320px;
        }

        /* --- Tabs --- */
        .tabs { display: flex; background-color: var(--white); border-bottom: 1px solid #e0e0e0; border-top-left-radius: 8px; border-top-right-radius: 8px; }
        .tab-button {
            flex: 1;
            padding: 1.2rem;
            background: none;
            border: none;
            font-size: 1rem;
            font-weight: 600;
            color: #555;
            cursor: pointer;
            transition: all 0.2s;
            display: flex; justify-content: center; align-items: center; gap: 0.5rem;
        }
        .tab-button:hover { background-color: #f9f9f9; color: var(--primary-blue); }
        .tab-button.active { color: var(--primary-blue); border-bottom: 3px solid var(--primary-blue); }

        /* --- 搜索表单 --- */
        .tab-content { display: none; padding: 2rem; animation: fadeIn 0.4s ease-in-out; }
        .tab-content.active { display: block; }

        .trip-type-selector { margin-bottom: 1.5rem; }
        .trip-type-select {
            padding: 0.5rem 2rem 0.5rem 0.5rem; font-size: 1rem; font-weight: 600; color: var(--text-color);
            border: 1px solid transparent; border-radius: 4px; background-color: transparent; cursor: pointer;
            appearance: none; -webkit-appearance: none;
            background-image: url("data:image/svg+xml;charset=US-ASCII,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22292.4%22%20height%3D%22292.4%22%3E%3Cpath%20fill%3D%22%23007CB2%22%20d%3D%22M287%2069.4a17.6%2017.6%200%200%200-13-5.4H18.4c-5%200-9.3%201.8-12.9%205.4A17.6%2017.6%200%200%200%200%2082.2c0%205%201.8%209.3%205.4%2012.9l128%20127.9c3.6%203.6%207.8%205.4%2012.8%205.4s9.2-1.8%2012.8-5.4L287%2095c3.5-3.5%205.4-7.8%205.4-12.8%200-5-1.9-9.2-5.5-12.8z%22%2F%3E%3C%2Fsvg%3E");
            background-repeat: no-repeat; background-position: right 0.7rem top 50%; background-size: 0.65rem auto;
        }
        .trip-type-select:hover { background-color: #f1f2f8; border-color: #ccc; }

        .search-form .form-row { display: flex; gap: 1rem; margin-bottom: 1.5rem; align-items: flex-end; }
        /* [修改] 给表单组设置最小宽度，防止被压缩 */
        .form-group { flex: 1; display: flex; flex-direction: column; min-width: 140px; }
        .form-group label { font-size: 0.85rem; font-weight: 700; color: #444; margin-bottom: 0.5rem; }
        .search-form input { width: 100%; padding: 0.8rem 1rem; font-size: 1rem; border: 1px solid #ccc; border-radius: 4px; }
        .search-form input:disabled { background-color: #e9ecef; color: #adb5bd; cursor: not-allowed; }
        .btn-search { background-color: var(--primary-blue); color: white; border: none; padding: 0.9rem 2rem; font-size: 1.2rem; font-weight: 700; border-radius: 4px; cursor: pointer; height: 50px; white-space: nowrap; }
        .btn-search:hover { background-color: var(--hover-blue); }

        .options { margin-top: 1rem; font-size: 0.95rem; color: #444; }
        .options label { display: inline-flex; align-items: center; gap: 0.5rem; cursor: pointer; user-select: none; }
        .options input[type="checkbox"] { width: 1.1rem; height: 1.1rem; margin: 0; accent-color: var(--primary-blue); }

        /* --- [修改] 推荐内容板块 --- */
        .recommendations-container {
            max-width: var(--container-width); /* 1200px */
            width: 95%;
            margin: 0 auto 2rem auto;
            padding: 0; /* 移除 padding，保持与搜索框对齐 */
            flex: 1;
        }
        .rec-content { display: none; animation: fadeIn 0.5s ease-in-out; }
        .rec-content.active { display: block; }

        .rec-header { margin-bottom: 1.5rem; }
        .rec-header h2 { font-size: 1.8rem; color: var(--text-color); margin-bottom: 0.5rem; }
        .rec-header p { color: #666; font-size: 1rem; }

        .rec-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); /* 稍微加宽卡片 */
            gap: 1.5rem;
        }

        .rec-card {
            background: var(--white);
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            transition: transform 0.2s, box-shadow 0.2s;
            cursor: pointer;
            text-decoration: none;
            color: inherit;
            display: flex;
            flex-direction: column;
        }
        .rec-card:hover { transform: translateY(-4px); box-shadow: 0 8px 16px rgba(0,0,0,0.1); }

        .rec-image {
            height: 180px; /* 增加图片高度 */
            width: 100%;
            background-color: #eee;
            position: relative;
        }
        .rec-image img { width: 100%; height: 100%; object-fit: cover; }

        .rec-details { padding: 1.2rem; flex-grow: 1; display: flex; flex-direction: column; justify-content: space-between; }
        .rec-title { font-weight: 700; font-size: 1.1rem; margin-bottom: 0.3rem; display: block; }
        .rec-subtitle { font-size: 0.9rem; color: #666; }

        /* --- [修改] 特性描述板块 (Features) --- */
        .features-section {
            max-width: var(--container-width); /* 1200px */
            width: 95%;
            margin: 2rem auto 6rem auto;
            padding: 0;
            display: grid;
            grid-template-columns: repeat(3, 1fr); /* 强制 3 列布局 */
            gap: 2rem;
            animation: fadeIn 0.8s ease-out;
        }
        .feature-card {
            padding: 1.5rem;
            display: flex;
            flex-direction: column;
            align-items: flex-start;
            /* 可选：给特性卡片加背景使其更突出 */
            /* background: #fff; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.03); */
        }
        .feature-icon { font-size: 2rem; margin-bottom: 1rem; }
        .feature-card h3 { font-size: 1.1rem; color: var(--text-color); margin-bottom: 0.5rem; font-weight: 700; }
        .feature-card p { color: #666; font-size: 0.95rem; line-height: 1.5; margin: 0; }

        /* --- 页脚 (Footer) --- */
        footer {
            background-color: var(--dark-blue);
            color: var(--white);
            padding: 4rem 2rem 2rem;
            margin-top: auto;
        }
        .footer-content {
            max-width: var(--container-width); /* 1200px */
            width: 95%;
            margin: 0 auto;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 3rem;
            padding: 0; /* 移除 padding */
        }
        .footer-column h4 { font-size: 1.1rem; margin-bottom: 1.2rem; font-weight: 700; }
        .footer-column a { display: block; color: var(--footer-text); text-decoration: none; margin-bottom: 0.8rem; font-size: 0.9rem; transition: color 0.2s; }
        .footer-column a:hover { color: var(--white); text-decoration: underline; }
        .footer-bottom {
            max-width: var(--container-width);
            width: 95%;
            margin: 3rem auto 0;
            border-top: 1px solid rgba(255,255,255,0.1);
            padding-top: 1.5rem;
            text-align: left;
            color: var(--footer-text);
            font-size: 0.85rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
        }
        .footer-logo { font-weight: 800; font-size: 1.2rem; color: var(--white); text-decoration: none; }

        @keyframes fadeInUp { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        @keyframes slideUp { from { opacity: 0; transform: translateY(40px); } to { opacity: 1; transform: translateY(0); } }
        @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }

        @media (max-width: 768px) {
            .search-form .form-row { flex-direction: column; gap: 1rem; }
            .btn-search { width: 100%; }
            .hero-title { font-size: 1.8rem; }
            .tabs { overflow-x: auto; }
            .features-section { grid-template-columns: 1fr; } /* 移动端变为单列 */
        }
    </style>
</head>
<body>
<nav>
    <a href="<c:url value='/'/>" class="logo">GoTour</a>
    <div class="user-links">
        <c:choose>
            <c:when test="${not empty sessionScope.loggedInUser}">
                <span>Hi, ${fn:escapeXml(sessionScope.loggedInUser.username)}</span>
                <a href="<c:url value='/profile'/>">Trips</a>
                <c:if test="${sessionScope.loggedInUser.role == 'ADMIN'}">
                    <a href="<c:url value='/admin/flights'/>">Admin</a>
                </c:if>
                <a href="<c:url value='/logout'/>">Log out</a>
            </c:when>
            <c:otherwise>
                <a href="<c:url value='/login'/>" class="btn-login">Log in</a>
                <a href="<c:url value='/register'/>">Sign up</a>
            </c:otherwise>
        </c:choose>
    </div>
</nav>

<div class="hero-section">
    <h1 class="hero-title">Where to next?</h1>
</div>

<%-- 搜索卡片 --%>
<div class="search-widget">
    <div class="tabs">
        <button class="tab-button active" onclick="openTab(event, 'flights')"><span>✈️</span> Flights</button>
        <button class="tab-button" onclick="openTab(event, 'hotels')"><span>🏨</span> Hotels</button>
        <button class="tab-button" onclick="openTab(event, 'cars')"><span>🚗</span> Car Rental</button>
    </div>

    <%-- Flights Tab --%>
    <div id="flights" class="tab-content active">
        <form action="<c:url value='/searchFlights'/>" method="GET" class="search-form">
            <div class="trip-type-selector">
                <select id="flightTripType" class="trip-type-select" onchange="toggleFlightReturnDate()">
                    <option value="roundtrip">Roundtrip</option>
                    <option value="oneway">One-way</option>
                </select>
            </div>
            <div class="form-row">
                <div class="form-group" style="flex: 2;"><label>From</label><input type="text" name="origin" required placeholder="Country, city or airport"></div>
                <div class="form-group" style="flex: 2;"><label>To</label><input type="text" name="destination" required placeholder="Country, city or airport"></div>
            </div>
            <div class="form-row">
                <div class="form-group"><label>Depart</label><input type="date" name="departDate" required></div>
                <div class="form-group"><label>Return</label><input type="date" id="returnDateInput" name="returnDate"></div>
                <div class="form-group"><label>Travellers</label><input type="number" name="travelers" min="1" value="1"></div>
                <button type="submit" class="btn-search">Search flights</button>
            </div>
            <div class="options"><label><input type="checkbox" name="directOnly" value="true"> Direct flights only</label></div>
        </form>
    </div>

    <%-- Hotels Tab --%>
    <div id="hotels" class="tab-content">
        <form action="<c:url value='/searchHotels'/>" method="GET" class="search-form">
            <div class="form-row"><div class="form-group" style="flex-grow: 2;"><label>Destination</label><input type="text" name="location" required placeholder="City, hotel or landmark"></div></div>
            <div class="form-row">
                <div class="form-group"><label>Check-in</label><input type="date" name="checkin"></div>
                <div class="form-group"><label>Check-out</label><input type="date" name="checkout"></div>
                <div class="form-group"><label>Guests</label><input type="number" name="guests" min="1" value="2"></div>
                <button type="submit" class="btn-search">Search hotels</button>
            </div>
        </form>
    </div>

    <%-- Cars Tab --%>
    <div id="cars" class="tab-content">
        <form action="<c:url value='/searchCars'/>" method="GET" class="search-form">
            <div class="options" style="margin-bottom: 1.5rem; margin-top: 0;">
                <label><input type="checkbox" id="sameLocation" name="sameLocation" checked onchange="toggleDropoffLocation()"> Return to same location</label>
            </div>
            <div class="form-row">
                <div class="form-group" style="flex: 2;"><label>Pick-up location</label><input type="text" name="pickupLocation" required placeholder="City, airport or station"></div>
                <div class="form-group" id="dropoffLocationGroup" style="display: none; flex: 2;"><label>Drop-off location</label><input type="text" name="dropoffLocation" id="dropoffLocationInput" placeholder="City, airport or station"></div>
            </div>
            <div class="form-row">
                <div class="form-group"><label>Pick-up Date</label><input type="date" name="pickupDate" required></div>
                <div class="form-group" style="max-width: 100px;"><label>Time</label><input type="time" name="pickupTime" value="10:00"></div>
                <div class="form-group"><label>Drop-off Date</label><input type="date" name="dropoffDate" required></div>
                <div class="form-group" style="max-width: 100px;"><label>Time</label><input type="time" name="dropoffTime" value="10:00"></div>
            </div>
            <div class="form-row">
                <div class="form-group"><label>Driver's age</label><div style="display: flex; align-items: center;"><input type="number" name="driverAge" min="18" value="30" style="width: 80px; margin-right: 0.5rem;"><span style="font-size: 0.9rem; color: #666;">(30-65)</span></div></div>
                <button type="submit" class="btn-search">Search cars</button>
            </div>
        </form>
    </div>
</div>

<%-- === 1. 推荐内容板块 (移动到上面) === --%>
<div class="recommendations-container">
    <%-- 航班推荐 --%>
    <div id="rec-flights" class="rec-content active">
        <div class="rec-header">
            <h2>Popular right now</h2>
            <p>Other travellers are loving these destinations. Search flights for your next trip.</p>
        </div>
        <div class="rec-grid">
            <a href="<c:url value='/searchFlights?origin=London&destination=Tokyo'/>" class="rec-card">
                <div class="rec-image"><img src="https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?auto=format&fit=crop&w=400&q=80" alt="Tokyo"></div>
                <div class="rec-details"><span class="rec-title">Tokyo, Japan</span><span class="rec-subtitle">Flights from $980</span></div>
            </a>
            <a href="<c:url value='/searchFlights?origin=London&destination=New York'/>" class="rec-card">
                <div class="rec-image"><img src="https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D" alt="New York"></div>
                <div class="rec-details"><span class="rec-title">New York, USA</span><span class="rec-subtitle">Flights from $650</span></div>
            </a>
            <a href="<c:url value='/searchFlights?origin=London&destination=Paris'/>" class="rec-card">
                <div class="rec-image"><img src="https://images.unsplash.com/photo-1502602898657-3e91760cbb34?auto=format&fit=crop&w=400&q=80" alt="Paris"></div>
                <div class="rec-details"><span class="rec-title">Paris, France</span><span class="rec-subtitle">Flights from $85</span></div>
            </a>
        </div>
    </div>
    <%-- 酒店推荐 --%>
    <div id="rec-hotels" class="rec-content">
        <div class="rec-header">
            <h2>Find your perfect stay</h2>
            <p>From cozy cottages to luxury hotels, find the best accommodation deals.</p>
        </div>
        <div class="rec-grid">
            <a href="<c:url value='/searchHotels?location=London'/>" class="rec-card">
                <div class="rec-image"><img src="https://images.unsplash.com/photo-1513635269975-59663e0ac1ad?auto=format&fit=crop&w=400&q=80" alt="London"></div>
                <div class="rec-details"><span class="rec-title">Hotels in London</span><span class="rec-subtitle">Avg. $150/night</span></div>
            </a>
            <a href="<c:url value='/searchHotels?location=Paris'/>" class="rec-card">
                <div class="rec-image"><img src="https://images.unsplash.com/photo-1499856871940-a09d4d7794c6?auto=format&fit=crop&w=400&q=80" alt="Paris"></div>
                <div class="rec-details"><span class="rec-title">Hotels in Paris</span><span class="rec-subtitle">Avg. $190/night</span></div>
            </a>
        </div>
    </div>
    <%-- 租车推荐 --%>
    <div id="rec-cars" class="rec-content">
        <div class="rec-header">
            <h2>Popular car hire destinations</h2>
            <p>Hit the road and explore at your own pace.</p>
        </div>
        <div class="rec-grid">
            <a href="<c:url value='/searchCars?pickupLocation=London'/>" class="rec-card">
                <div class="rec-image"><img src="https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?auto=format&fit=crop&w=400&q=80" alt="London"></div>
                <div class="rec-details"><span class="rec-title">Car hire in London</span><span class="rec-subtitle">From $45/day</span></div>
            </a>
            <a href="<c:url value='/searchCars?pickupLocation=Los Angeles'/>" class="rec-card">
                <div class="rec-image"><img src="https://images.unsplash.com/photo-1568605117036-5fe5e7bab0b7?auto=format&fit=crop&w=400&q=80" alt="Los Angeles"></div>
                <div class="rec-details"><span class="rec-title">Car hire in Los Angeles</span><span class="rec-subtitle">From $60/day</span></div>
            </a>
        </div>
    </div>
</div>

<%-- === 2. 特性描述板块 (移动到下面) === --%>
<div class="features-section">
    <div class="feature-card">
        <div class="feature-icon">📅</div>
        <h3>Flexible tickets</h3>
        <p>Change of plans? No problem. See flexible ticket options for your peace of mind.</p>
    </div>
    <div class="feature-card">
        <div class="feature-icon">💰</div>
        <h3>No hidden fees</h3>
        <p>What you see is what you pay. No nasty surprises at checkout.</p>
    </div>
    <div class="feature-card">
        <div class="feature-icon">🌍</div>
        <h3>Explore everywhere</h3>
        <p>Search "Everywhere" to find the best prices for your next global adventure.</p>
    </div>
</div>

<%-- 页脚 Footer --%>
<footer>
    <div class="footer-content">
        <div class="footer-column">
            <h4>Explore</h4>
            <a href="#">Cities</a>
            <a href="#">Airports</a>
            <a href="#">Countries</a>
            <a href="#">Hotels</a>
            <a href="#">Car hire</a>
        </div>
        <div class="footer-column">
            <h4>Partners</h4>
            <a href="#">Work with us</a>
            <a href="#">Advertising</a>
            <a href="#">Travel Insight</a>
            <a href="#">Affiliates</a>
        </div>
        <div class="footer-column">
            <h4>Company</h4>
            <a href="#">About us</a>
            <a href="#">Why GoTour?</a>
            <a href="#">Media</a>
            <a href="#">Our people</a>
            <a href="#">Accessibility</a>
            <a href="#">Sustainability</a>
            <a href="#">Brand story</a>
            <a href="#">Company Details</a>
            <a href="#">Jobs</a>
        </div>
        <div class="footer-column">
            <h4>Help</h4>
            <a href="#">Help Centre</a>
            <a href="#">Privacy settings</a>
            <a href="#">Security</a>
            <a href="#">Terms of Service</a>
        </div>
    </div>
    <div class="footer-bottom">
        <a href="#" class="footer-logo">GoTour</a>
        <span>&copy; TravelBooking Ltd 2025</span>
    </div>
</footer>

<script>
    function openTab(evt, tabName) {
        var i, tabcontent, tablinks, recContent;
        tabcontent = document.getElementsByClassName("tab-content");
        for (i = 0; i < tabcontent.length; i++) {
            tabcontent[i].style.display = "none";
            tabcontent[i].classList.remove("active");
        }
        tablinks = document.getElementsByClassName("tab-button");
        for (i = 0; i < tablinks.length; i++) {
            tablinks[i].className = tablinks[i].className.replace(" active", "");
        }
        document.getElementById(tabName).style.display = "block";
        void document.getElementById(tabName).offsetWidth;
        document.getElementById(tabName).classList.add("active");
        evt.currentTarget.className += " active";

        // 切换推荐内容
        recContent = document.getElementsByClassName("rec-content");
        for (i = 0; i < recContent.length; i++) {
            recContent[i].style.display = "none";
            recContent[i].classList.remove("active");
        }
        var recId = "rec-" + tabName;
        var activeRec = document.getElementById(recId);
        if (activeRec) {
            activeRec.style.display = "block";
            void activeRec.offsetWidth;
            activeRec.classList.add("active");
        }
    }

    function toggleFlightReturnDate() {
        var tripType = document.getElementById("flightTripType").value;
        var returnDateInput = document.getElementById("returnDateInput");
        if (tripType === "oneway") {
            returnDateInput.disabled = true;
            returnDateInput.value = "";
            returnDateInput.required = false;
        } else {
            returnDateInput.disabled = false;
        }
    }

    function toggleDropoffLocation() {
        var sameLocCheckbox = document.getElementById("sameLocation");
        var dropoffGroup = document.getElementById("dropoffLocationGroup");
        var dropoffInput = document.getElementById("dropoffLocationInput");
        if (sameLocCheckbox.checked) {
            dropoffGroup.style.display = "none";
            dropoffInput.required = false;
            dropoffInput.value = "";
        } else {
            dropoffGroup.style.display = "flex";
            dropoffInput.required = true;
        }
    }

    document.addEventListener('DOMContentLoaded', function() {
        toggleFlightReturnDate();
        toggleDropoffLocation();
    });
</script>
</body>
</html>