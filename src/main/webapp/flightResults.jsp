<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%-- 关键修复：使用正确的 Jakarta EE Functions URI --%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Flight Results</title>
    <style>
        /* --- 基础样式 --- */
        :root {
            --primary-blue: #0770e3;
            --dark-blue: #02122c;
            --bg-color: #f1f2f8;
            --text-color: #111236;
            --white: #ffffff;
            --hover-blue: #055cb8;
            --border-color: #ddd;
        }
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; background-color: var(--bg-color); color: var(--text-color); margin: 0; }

        /* --- 顶部搜索栏 --- */
        .results-header { background-color: var(--dark-blue); padding: 1rem 2rem; color: white; display: flex; align-items: center; gap: 2rem; }
        .logo-small { font-weight: 800; font-size: 1.5rem; text-decoration: none; color: white; margin-right: auto; }
        .search-summary { background: rgba(255,255,255,0.1); padding: 0.5rem 1rem; border-radius: 4px; font-size: 0.9rem; display: flex; gap: 1rem; }

        /* --- 主布局 (双栏) --- */
        .main-container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 1rem;
            display: flex;
            gap: 2rem;
            align-items: flex-start;
        }

        /* --- 左侧筛选栏 --- */
        .filters-sidebar {
            width: 280px;
            flex-shrink: 0;
            display: none; /* 移动端默认隐藏 */
        }
        @media (min-width: 900px) { .filters-sidebar { display: block; } }

        .filter-group {
            background: var(--white);
            padding: 0 1.5rem;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            margin-bottom: 1rem;
            overflow: hidden;
        }

        .filter-title {
            font-weight: 700;
            font-size: 0.95rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            cursor: pointer;
            padding: 1.5rem 0;
            user-select: none;
        }

        .toggle-icon {
            font-size: 0.8rem;
            color: #666;
            transition: transform 0.3s ease;
        }

        .filter-group.collapsed .toggle-icon {
            transform: rotate(-90deg);
        }

        .filter-content {
            padding-bottom: 1.5rem;
            transition: max-height 0.3s ease-out, opacity 0.3s ease-out;
            max-height: 500px;
            opacity: 1;
            overflow: hidden;
        }

        .filter-group.collapsed .filter-content {
            max-height: 0;
            padding-bottom: 0;
            opacity: 0;
        }

        .filter-option { display: flex; align-items: center; margin-bottom: 0.8rem; font-size: 0.9rem; cursor: pointer; }
        .filter-option input { margin-right: 0.8rem; accent-color: var(--primary-blue); width: 16px; height: 16px; }
        .filter-count { margin-left: auto; color: #666; font-size: 0.8rem; }

        /* --- 右侧结果区 --- */
        .results-section { flex: 1; min-width: 0; }

        /* --- 排序选项卡 --- */
        .sort-tabs { display: flex; background: var(--white); border-radius: 8px; overflow: hidden; box-shadow: 0 1px 3px rgba(0,0,0,0.1); margin-bottom: 1.5rem; }
        .sort-tab { flex: 1; padding: 1rem; text-align: left; cursor: pointer; border-right: 1px solid #eee; transition: background 0.2s; position: relative; }
        .sort-tab:last-child { border-right: none; }
        .sort-tab:hover { background-color: #f9f9f9; }
        .sort-tab.active { background-color: #f0f7ff; }
        .sort-tab.active::after { content: ''; position: absolute; bottom: 0; left: 0; width: 100%; height: 3px; background-color: var(--primary-blue); }
        .sort-label { font-weight: 600; font-size: 0.95rem; color: var(--text-color); display: block; }
        .sort-info { font-size: 0.8rem; color: #666; margin-top: 4px; display: block; }
        .price-diff { color: #00a698; font-weight: 500; }

        /* --- 航班卡片 --- */
        .flight-card { background: var(--white); border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); margin-bottom: 1rem; padding: 1.5rem; display: flex; flex-direction: column; transition: transform 0.2s, box-shadow 0.2s; }
        .flight-card:hover { transform: translateY(-2px); box-shadow: 0 8px 16px rgba(0,0,0,0.1); }
        @media (min-width: 768px) { .flight-card { flex-direction: row; justify-content: space-between; align-items: center; } }
        .flight-info-group { flex: 1; padding-right: 2rem; }
        .leg { display: flex; align-items: center; gap: 2rem; margin-bottom: 1rem; }
        .leg:last-child { margin-bottom: 0; }
        .airline-logo { width: 40px; font-weight: bold; color: #555; font-size: 0.8rem; }
        .route-time { display: flex; flex-direction: column; min-width: 80px; }
        .time { font-size: 1.1rem; font-weight: 700; color: var(--text-color); }
        .airport { font-size: 0.85rem; color: #666; }
        .route-duration { flex: 1; text-align: center; padding: 0 1rem; position: relative; }
        .duration-text { font-size: 0.8rem; color: #666; margin-bottom: 4px; display: block; }
        .route-line { height: 2px; background: #ddd; position: relative; width: 100%; }
        .route-line::after { content: '✈'; position: absolute; right: 0; top: -7px; color: #ccc; font-size: 0.8rem; }
        .stop-info { font-size: 0.8rem; color: #d93025; margin-top: 4px; display: block; }
        .stop-info.direct { color: #00a698; }
        .price-action { min-width: 160px; text-align: right; padding-left: 2rem; border-left: 1px solid #eee; display: flex; flex-direction: column; justify-content: center; align-items: flex-end; }
        .deals-text { font-size: 0.75rem; color: #666; margin-bottom: 0.5rem; }
        .price-tag { font-size: 1.6rem; font-weight: 800; color: var(--text-color); line-height: 1; margin-bottom: 0.5rem; }
        .btn-select { background-color: var(--primary-blue); color: white; text-decoration: none; padding: 0.7rem 1.5rem; border-radius: 5px; font-weight: 700; font-size: 1rem; display: inline-block; transition: background 0.2s; }
        .btn-select:hover { background-color: var(--hover-blue); }
        .no-results { text-align: center; padding: 4rem; color: #666; }
        .back-link { display: inline-block; margin-top: 2rem; color: var(--primary-blue); text-decoration: none; }
    </style>
</head>
<body>

<div class="results-header">
    <a href="<c:url value='/'/>" class="logo-small">GoTour</a>
    <div class="search-summary">
        <span class="summary-item">${origin} ➝ ${destination}</span>
        <span>|</span>
        <span class="summary-item">${departDate}</span>
        <c:if test="${isRoundTripSearch}"><span>- ${returnDate}</span></c:if>
        <span>|</span>
        <span>1 Traveller</span>
    </div>
</div>

<div class="main-container">

    <%-- 左侧筛选栏 --%>
    <aside class="filters-sidebar">

        <div class="filter-group">
            <div class="filter-title" onclick="toggleFilter(this)">
                Stops
                <span class="toggle-icon">▼</span>
            </div>
            <div class="filter-content">
                <label class="filter-option">
                    <input type="checkbox" class="filter-stops" value="direct" checked onchange="applyFilters()"> Direct only
                </label>
                <label class="filter-option">
                    <input type="checkbox" class="filter-stops" value="1stop" checked onchange="applyFilters()"> 1 Stop
                </label>
            </div>
        </div>

        <div class="filter-group">
            <div class="filter-title" onclick="toggleFilter(this)">
                Airlines
                <span class="toggle-icon">▼</span>
            </div>
            <div class="filter-content">
                <c:forEach var="airlineName" items="${airlineList}">
                    <label class="filter-option">
                        <input type="checkbox" class="filter-airline" value="${fn:escapeXml(airlineName)}" checked onchange="applyFilters()">
                            ${fn:escapeXml(airlineName)}
                    </label>
                </c:forEach>

                <c:if test="${empty airlineList}">
                    <p style="font-size:0.8rem; color:#999;">No airlines found.</p>
                </c:if>
            </div>
        </div>

        <div class="filter-group">
            <div class="filter-title" onclick="toggleFilter(this)">
                Departure times
                <span class="toggle-icon">▼</span>
            </div>
            <div class="filter-content">
                <label class="filter-option"><input type="checkbox" checked> Morning (06:00 - 12:00)</label>
                <label class="filter-option"><input type="checkbox" checked> Afternoon (12:00 - 18:00)</label>
                <label class="filter-option"><input type="checkbox" checked> Evening (18:00 - 23:59)</label>
            </div>
        </div>

    </aside>

    <%-- 右侧主要内容 --%>
    <div class="results-section">

        <div class="sort-tabs">
            <div class="sort-tab active" onclick="sortResults('best', this)">
                <span class="sort-label">Best</span><span class="sort-info">Value for money</span>
            </div>
            <div class="sort-tab" onclick="sortResults('cheapest', this)">
                <span class="sort-label">Cheapest</span><span class="sort-info price-diff">From lowest price</span>
            </div>
            <div class="sort-tab" onclick="sortResults('fastest', this)">
                <span class="sort-label">Fastest</span><span class="sort-info">Shortest time</span>
            </div>
        </div>

        <div id="results-container">
            <c:if test="${not empty searchError}">
                <div style="padding: 1rem; background: #ffebee; color: #c62828; border-radius: 4px; margin-bottom: 1rem;">${searchError}</div>
            </c:if>

            <c:choose>
                <%-- 单程搜索 --%>
                <c:when test="${not isRoundTripSearch}">
                    <c:forEach var="flight" items="${outboundFlights}">
                        <div class="flight-card"
                             data-price="${flight.price}"
                             data-stops="${flight.direct ? 'direct' : '1stop'}"
                             data-departure="${flight.departureTime}"
                             data-arrival="${flight.arrivalTime}"
                             data-airline="${flight.airline}">

                            <div class="flight-info-group">
                                <div class="leg">
                                    <div class="airline-logo">${fn:substring(flight.airline, 0, 2)}</div>
                                    <div class="route-time">
                                        <span class="time">${fn:substring(fn:replace(flight.departureTime.toString(), 'T', ' '), 11, 16)}</span>
                                        <span class="airport">${flight.origin}</span>
                                    </div>
                                    <div class="route-duration">
                                        <span class="duration-text js-duration">Calculating...</span>
                                        <div class="route-line"></div>
                                        <span class="stop-info ${flight.direct ? 'direct' : ''}">${flight.direct ? 'Direct' : '1 Stop'}</span>
                                    </div>
                                    <div class="route-time">
                                        <span class="time">${fn:substring(fn:replace(flight.arrivalTime.toString(), 'T', ' '), 11, 16)}</span>
                                        <span class="airport">${flight.destination}</span>
                                    </div>
                                </div>
                            </div>
                            <div class="price-action">
                                <span class="deals-text">1 deal</span>
                                <span class="price-tag">$<fmt:formatNumber value="${flight.price}" type="currency" currencySymbol="" maxFractionDigits="0"/></span>
                                <a href="${pageContext.request.contextPath}/book?type=flight&id=${flight.id}" class="btn-select">Select</a>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>

                <%-- 往返搜索 --%>
                <c:when test="${isRoundTripSearch}">
                    <c:if test="${not empty outboundFlights and not empty inboundFlights}">
                        <c:forEach var="outbound" items="${outboundFlights}">
                            <c:forEach var="inbound" items="${inboundFlights}">
                                <c:if test="${fn:substring(fn:replace(inbound.departureTime.toString(), 'T', ' '), 0, 10) eq returnDate}">

                                    <div class="flight-card"
                                         data-price="${outbound.price + inbound.price}"
                                         data-stops="${outbound.direct and inbound.direct ? 'direct' : '1stop'}"
                                         data-departure="${outbound.departureTime}"
                                         data-arrival="${outbound.arrivalTime}"
                                         data-airline="${outbound.airline}">

                                        <div class="flight-info-group">
                                            <div class="leg">
                                                <div class="airline-logo">${fn:substring(outbound.airline, 0, 2)}</div>
                                                <div class="route-time"><span class="time">${fn:substring(fn:replace(outbound.departureTime.toString(), 'T', ' '), 11, 16)}</span><span class="airport">${outbound.origin}</span></div>
                                                <div class="route-duration"><span class="duration-text js-duration" data-start="${outbound.departureTime}" data-end="${outbound.arrivalTime}">--</span><div class="route-line"></div><span class="stop-info ${outbound.direct ? 'direct' : ''}">${outbound.direct ? 'Direct' : '1 Stop'}</span></div>
                                                <div class="route-time"><span class="time">${fn:substring(fn:replace(outbound.arrivalTime.toString(), 'T', ' '), 11, 16)}</span><span class="airport">${outbound.destination}</span></div>
                                            </div>
                                            <div class="leg">
                                                <div class="airline-logo">${fn:substring(inbound.airline, 0, 2)}</div>
                                                <div class="route-time"><span class="time">${fn:substring(fn:replace(inbound.departureTime.toString(), 'T', ' '), 11, 16)}</span><span class="airport">${inbound.origin}</span></div>
                                                <div class="route-duration"><span class="duration-text js-duration" data-start="${inbound.departureTime}" data-end="${inbound.arrivalTime}">--</span><div class="route-line"></div><span class="stop-info ${inbound.direct ? 'direct' : ''}">${inbound.direct ? 'Direct' : '1 Stop'}</span></div>
                                                <div class="route-time"><span class="time">${fn:substring(fn:replace(inbound.arrivalTime.toString(), 'T', ' '), 11, 16)}</span><span class="airport">${inbound.destination}</span></div>
                                            </div>
                                        </div>
                                        <div class="price-action">
                                            <span class="price-tag">$<fmt:formatNumber value="${outbound.price + inbound.price}" type="currency" currencySymbol="" maxFractionDigits="0"/></span>
                                            <a href="${pageContext.request.contextPath}/book?type=flight&outboundId=${outbound.id}&inboundId=${inbound.id}" class="btn-select">Select</a>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </c:forEach>
                    </c:if>
                </c:when>
            </c:choose>

            <c:if test="${empty outboundFlights}">
                <p class="no-results">No flights found. <a href="<c:url value='/'/>" class="back-link">Try different dates</a></p>
            </c:if>

        </div>
    </div>
</div>

<script>
    function toggleFilter(header) {
        const group = header.parentElement;
        if (group.classList.contains('collapsed')) {
            group.classList.remove('collapsed');
        } else {
            group.classList.add('collapsed');
        }
    }

    function calculateDurations() {
        const cards = document.querySelectorAll('.flight-card');
        cards.forEach(card => {
            // 处理往返
            const internalDurations = card.querySelectorAll('.js-duration');
            if (internalDurations.length > 0) {
                internalDurations.forEach(span => {
                    const s = span.getAttribute('data-start');
                    const e = span.getAttribute('data-end');
                    if(s && e) span.textContent = getDurationString(s, e);
                });
            }

            // 处理单程
            const depStr = card.getAttribute('data-departure');
            const arrStr = card.getAttribute('data-arrival');
            if (internalDurations.length === 1 && depStr && arrStr) {
                internalDurations[0].textContent = getDurationString(depStr, arrStr);
                const diff = new Date(arrStr) - new Date(depStr);
                card.setAttribute('data-duration-ms', diff);
            }
        });
    }

    function getDurationString(startStr, endStr) {
        const start = new Date(startStr);
        const end = new Date(endStr);
        if (isNaN(start.getTime()) || isNaN(end.getTime())) return "--";
        const diffMs = end - start;
        if (diffMs < 0) return "Error";
        const totalMinutes = Math.floor(diffMs / 60000);
        const hours = Math.floor(totalMinutes / 60);
        const mins = totalMinutes % 60;
        return hours + "h " + mins + "m";
    }

    function sortResults(criteria, tabElement) {
        document.querySelectorAll('.sort-tab').forEach(t => t.classList.remove('active'));
        tabElement.classList.add('active');
        const container = document.getElementById('results-container');
        const cards = Array.from(container.querySelectorAll('.flight-card'));

        cards.sort((a, b) => {
            if (criteria === 'cheapest') {
                return parseFloat(a.getAttribute('data-price')) - parseFloat(b.getAttribute('data-price'));
            } else if (criteria === 'fastest') {
                const durA = a.getAttribute('data-duration-ms') || 0;
                const durB = b.getAttribute('data-duration-ms') || 0;
                return durA - durB;
            } else {
                return parseFloat(a.getAttribute('data-price')) - parseFloat(b.getAttribute('data-price'));
            }
        });
        cards.forEach(card => container.appendChild(card));
    }

    function applyFilters() {
        const directChecked = document.querySelector('input[value="direct"]').checked;
        const oneStopChecked = document.querySelector('input[value="1stop"]').checked;

        const airlineCheckboxes = document.querySelectorAll('.filter-airline:checked');
        const selectedAirlines = Array.from(airlineCheckboxes).map(cb => cb.value);

        const cards = document.querySelectorAll('.flight-card');

        cards.forEach(card => {
            const stops = card.getAttribute('data-stops');
            const airline = card.getAttribute('data-airline');

            let stopsMatch = false;
            if (stops === 'direct' && directChecked) stopsMatch = true;
            if (stops === '1stop' && oneStopChecked) stopsMatch = true;

            let airlineMatch = false;
            if (selectedAirlines.length === 0 || selectedAirlines.includes(airline)) {
                airlineMatch = true;
            }

            card.style.display = (stopsMatch && airlineMatch) ? 'flex' : 'none';
        });
    }

    document.addEventListener('DOMContentLoaded', () => {
        calculateDurations();
    });
</script>
</body>
</html>