<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %> <%-- 需要fmt标签库来解析日期以便比较 --%>

<html>
<head>
    <title>Flight Search Results</title>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; margin: 2rem; background-color: #f9f9f9; }
        h1, h2, h3 { color: #333; }
        .container { max-width: 900px; margin: 0 auto; background: #fff; padding: 2rem; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        .flight-card {
            display: flex;
            flex-direction: column; /* For mobile-first, cards stack */
            border: 1px solid #ddd;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            overflow: hidden;
            background-color: #fff;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }
        @media (min-width: 768px) { /* For larger screens, use row layout */
            .flight-card {
                flex-direction: row;
                justify-content: space-between;
            }
        }

        .flight-segment {
            padding: 1rem 1.5rem;
            display: flex;
            align-items: center;
            gap: 1.5rem; /* Space between segments */
            flex-grow: 1; /* Allow segments to grow */
        }
        .flight-segment.outbound { border-bottom: 1px dashed #eee; } /* Separator for outbound/inbound */
        @media (min-width: 768px) {
            .flight-segment.outbound { border-right: 1px dashed #eee; border-bottom: none; }
        }

        .flight-info {
            display: flex;
            flex-direction: column;
            flex-grow: 1;
        }
        .flight-info .time { font-size: 1.5rem; font-weight: bold; color: #333; }
        .flight-info .airport { color: #666; font-size: 0.9rem; }
        .flight-details { text-align: center; }
        .flight-details .duration { font-size: 0.9rem; color: #555; margin-bottom: 0.3rem; }
        .flight-details .stop { font-size: 0.8rem; color: #007bff; font-weight: 500; }
        .flight-details .arrow { font-size: 1.5rem; color: #888; }
        .flight-meta { font-size: 0.8rem; color: #777; margin-top: 0.5rem; }
        .airline-logo { width: 30px; height: 30px; object-fit: contain; margin-right: 1rem; }
        .price-action {
            background-color: #f8f8f8;
            padding: 1.5rem;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            min-width: 150px;
            flex-shrink: 0; /* Prevent from shrinking */
        }
        .price-action .price { font-size: 1.8rem; font-weight: bold; color: #007bff; margin-bottom: 0.5rem; }
        .btn-select {
            padding: 0.75rem 1.5rem;
            background-color: #28a745;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            font-size: 1rem;
            font-weight: bold;
            transition: background-color 0.2s ease;
        }
        .btn-select:hover { background-color: #218838; }

        .no-results { color: #555; font-style: italic; text-align: center; padding: 2rem; }
        .back-link { margin-top: 2rem; display: inline-block; text-decoration: none; color: #007bff; }
        .back-link:hover { text-decoration: underline; }
        .info-bar { background-color: #e9ecef; padding: 0.8rem 1.5rem; margin-bottom: 1.5rem; border-radius: 5px; color: #555; }
    </style>
</head>
<body>
<div class="container">
    <h2>Flight Search Results</h2>

    <%-- 显示搜索信息 --%>
    <div class="info-bar">
        Searching for: <strong>${origin}</strong> to <strong>${destination}</strong>
        on <strong>${departDate}</strong>
        <c:if test="${isRoundTripSearch}">
            and returning on <strong>${returnDate}</strong>
        </c:if>
        <c:if test="${param.directOnly eq 'true'}"> (Direct Flights Only)</c:if>
    </div>

    <%-- 显示可能的搜索错误 --%>
    <c:if test="${not empty searchError}">
        <p style="color: red; text-align: center;">${searchError}</p>
    </c:if>

    <%--
      核心逻辑：
      如果只是单程搜索，则直接显示去程航班。
      如果是往返搜索，则组合去程和返程航班。
    --%>

    <c:choose>
        <%-- 情况 1: 单程搜索 (只显示去程航班) --%>
        <c:when test="${not isRoundTripSearch}">
            <c:if test="${empty outboundFlights}">
                <p class="no-results">No one-way flights found matching your criteria.</p>
            </c:if>
            <c:forEach var="outboundFlight" items="${outboundFlights}">
                <div class="flight-card">
                    <div class="flight-segment">
                            <%-- 模拟航司Logo --%>
                        <img src="https://via.placeholder.com/30x30.png?text=${fn:substring(outboundFlight.airline, 0, 2)}" alt="${outboundFlight.airline}" class="airline-logo">
                        <div class="flight-info">
                            <span class="time">${fn:substring(fn:replace(outboundFlight.departureTime.toString(), 'T', ' '), 11, 16)}</span> <%-- 仅时间 --%>
                            <span class="airport">${outboundFlight.origin}</span>
                        </div>
                        <div class="flight-details">
                            <span class="duration">---</span> <%-- 总时长，目前未计算 --%>
                            <span class="stop">${outboundFlight.direct ? 'Direct' : '1 Stop'}</span> <%-- 简化处理 --%>
                        </div>
                        <div class="flight-info">
                            <span class="time">${fn:substring(fn:replace(outboundFlight.arrivalTime.toString(), 'T', ' '), 11, 16)}</span>
                            <span class="airport">${outboundFlight.destination}</span>
                        </div>
                    </div>
                    <div class="price-action">
                        <span class="price">$<fmt:formatNumber value="${outboundFlight.price}" type="currency" currencySymbol="" maxFractionDigits="2" minFractionDigits="2"/></span>
                        <a href="${pageContext.request.contextPath}/book?type=flight&id=${outboundFlight.id}" class="btn-select">Select →</a>
                    </div>
                </div>
            </c:forEach>
        </c:when>

        <%-- 情况 2: 往返搜索 (组合去程和返程航班) --%>
        <c:when test="${isRoundTripSearch}">
            <c:set var="foundCombinations" value="${false}"/>
            <c:if test="${not empty outboundFlights and not empty inboundFlights}">
                <c:forEach var="outboundFlight" items="${outboundFlights}">
                    <c:forEach var="inboundFlight" items="${inboundFlights}">
                        <%--
                          这里是往返组合的核心条件：
                          1. 去程目的地 == 返程出发地
                          2. 去程出发地 == 返程目的地
                          3. 返程航班的出发日期与用户输入的返程日期匹配 (通过LocalDateTime的日期部分比较)
                          （注意：JSTL fn:contains 不适合日期比较，我们将直接依赖EJB查询的日期匹配，或者可以进一步使用Joda-Time等库在JSP中进行更精确的日期比较，但在此简化）
                        --%>
                        <c:set var="isMatchingReturnFlight" value="${true}"/>
                        <%-- 检查日期部分是否匹配用户输入的返程日期 --%>
                        <c:if test="${fn:substring(fn:replace(inboundFlight.departureTime.toString(), 'T', ' '), 0, 10) ne returnDate}">
                            <c:set var="isMatchingReturnFlight" value="${false}"/>
                        </c:if>

                        <c:if test="${outboundFlight.destination eq inboundFlight.origin and
                                        outboundFlight.origin eq inboundFlight.destination and
                                        isMatchingReturnFlight}">

                            <c:set var="totalPrice" value="${outboundFlight.price + inboundFlight.price}"/>
                            <c:set var="foundCombinations" value="${true}"/>

                            <div class="flight-card">
                                <div class="flight-segment outbound">
                                    <img src="https://via.placeholder.com/30x30.png?text=${fn:substring(outboundFlight.airline, 0, 2)}" alt="${outboundFlight.airline}" class="airline-logo">
                                    <div class="flight-info">
                                        <span class="time">${fn:substring(fn:replace(outboundFlight.departureTime.toString(), 'T', ' '), 11, 16)}</span>
                                        <span class="airport">${outboundFlight.origin}</span>
                                    </div>
                                    <div class="flight-details">
                                        <span class="duration">
                                            <%-- 这里可以计算并显示去程持续时间 --%>
                                            ---
                                        </span>
                                        <span class="stop">${outboundFlight.direct ? 'Direct' : '1 Stop'}</span>
                                        <span class="flight-meta">${outboundFlight.airline} ${outboundFlight.flightNumber}</span>
                                    </div>
                                    <div class="flight-info">
                                        <span class="time">${fn:substring(fn:replace(outboundFlight.arrivalTime.toString(), 'T', ' '), 11, 16)}</span>
                                        <span class="airport">${outboundFlight.destination}</span>
                                    </div>
                                </div>

                                <div class="flight-segment">
                                    <img src="https://via.placeholder.com/30x30.png?text=${fn:substring(inboundFlight.airline, 0, 2)}" alt="${inboundFlight.airline}" class="airline-logo">
                                    <div class="flight-info">
                                        <span class="time">${fn:substring(fn:replace(inboundFlight.departureTime.toString(), 'T', ' '), 11, 16)}</span>
                                        <span class="airport">${inboundFlight.origin}</span>
                                    </div>
                                    <div class="flight-details">
                                        <span class="duration">
                                            <%-- 这里可以计算并显示返程持续时间 --%>
                                            ---
                                        </span>
                                        <span class="stop">${inboundFlight.direct ? 'Direct' : '1 Stop'}</span>
                                        <span class="flight-meta">${inboundFlight.airline} ${inboundFlight.flightNumber}</span>
                                    </div>
                                    <div class="flight-info">
                                        <span class="time">${fn:substring(fn:replace(inboundFlight.arrivalTime.toString(), 'T', ' '), 11, 16)}</span>
                                        <span class="airport">${inboundFlight.destination}</span>
                                    </div>
                                </div>

                                <div class="price-action">
                                    <span class="price">$<fmt:formatNumber value="${totalPrice}" type="currency" currencySymbol="" maxFractionDigits="2" minFractionDigits="2"/></span>
                                        <%-- 注意：这里的预订链接仍是针对单个航班ID的。实现往返预订需要将两个航班ID都传递给BookingServlet --%>
                                    <a href="${pageContext.request.contextPath}/book?type=flight&outboundId=${outboundFlight.id}&inboundId=${inboundFlight.id}" class="btn-select">Select →</a>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>
                </c:forEach>
            </c:if>
            <c:if test="${not foundCombinations}">
                <p class="no-results">No round-trip flight combinations found matching your criteria.</p>
            </c:if>
        </c:when>

        <%-- 如果既不是单程也不是往返搜索 (理论上不会发生) --%>
        <c:otherwise>
            <p class="no-results">Invalid search request.</p>
        </c:otherwise>
    </c:choose>

    <a href="index.jsp" class="back-link">← Back to Search</a>
</div>
</body>
</html>