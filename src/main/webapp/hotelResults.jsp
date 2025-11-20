<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>=

<html>
<head>
    <title>Hotel Search Results for ${fn:escapeXml(searchLocation)}</title> <%-- 使用 fn:escapeXml 防止 XSS --%>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; margin: 2rem; background-color: #f9f9f9; }
        h1, h2, h3 { color: #333; }
        .container { max-width: 900px; margin: 0 auto; }
        .info-bar { background-color: #e9ecef; padding: 0.8rem 1.5rem; margin-bottom: 1.5rem; border-radius: 5px; color: #555; }
        .hotel-card {
            display: flex;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-bottom: 1.5rem;
            overflow: hidden;
        }
        .hotel-image {
            flex-shrink: 0; /* 防止图片被压缩 */
            width: 200px; /* 固定图片宽度 */
            background-color: #eee; /* 占位符颜色 */
            display: flex;
            align-items: center;
            justify-content: center;
            color: #aaa;
            font-size: 1.5rem;
            /* 如果有图片URL: background: url('${hotel.imageUrl}') center center / cover no-repeat; */
        }
        .hotel-image img { /* 如果使用 <img> 标签 */
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .hotel-content {
            flex-grow: 1; /* 内容区占据剩余空间 */
            padding: 1rem 1.5rem;
            display: flex;
            flex-direction: column;
            justify-content: space-between; /* 推开名称/地点和评分/按钮 */
        }
        .hotel-details h3 { margin: 0 0 0.5rem 0; color: #007bff; }
        .hotel-details .location { color: #666; font-size: 0.9rem; margin-bottom: 1rem; }
        .hotel-actions {
            display: flex;
            justify-content: space-between; /* 评分和价格/按钮分开 */
            align-items: flex-end; /* 底部对齐 */
            margin-top: 1rem;
        }
        .hotel-rating {
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        .hotel-rating .score {
            background-color: #003b95;
            color: white;
            padding: 0.3rem 0.6rem;
            border-radius: 4px;
            font-weight: bold;
            font-size: 1.1rem;
            margin-bottom: 0.3rem;
        }
        .hotel-rating .reviews { font-size: 0.8rem; color: #666; }
        .hotel-price-book {
            text-align: right;
        }
        .hotel-price-book .price { display: block; font-size: 1.6rem; font-weight: bold; color: #333; margin-bottom: 0.5rem; }
        .btn-view {
            padding: 0.75rem 1.5rem;
            background-color: #28a745;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            font-size: 1rem;
            font-weight: bold;
            transition: background-color 0.2s ease;
            display: inline-block; /* 允许设置 padding */
        }
        .btn-view:hover { background-color: #218838; }
        .no-results { text-align: center; padding: 2rem; background: #fff; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        .back-link { margin-top: 1.5rem; display: inline-block; text-decoration: none; color: #007bff; }
        .back-link:hover { text-decoration: underline; }
    </style>
</head>
<body>
<div class="container">
    <h2>Hotel Results for ${fn:escapeXml(searchLocation)}</h2>

    <%-- 显示搜索信息 --%>
    <div class="info-bar">
        Searching for hotels in <strong>${fn:escapeXml(searchLocation)}</strong>
        <c:if test="${not empty searchCheckin}"> from <strong>${fn:escapeXml(searchCheckin)}</strong></c:if>
        <c:if test="${not empty searchCheckout}"> to <strong>${fn:escapeXml(searchCheckout)}</strong></c:if>
        for <strong>${searchGuests}</strong> guest(s).
    </div>

    <%-- 显示可能的搜索错误 --%>
    <c:if test="${not empty searchError}">
        <p style="color: red; text-align: center;">${searchError}</p>
    </c:if>

    <%-- 检查是否有结果 --%>
    <c:choose>
        <c:when test="${empty hotels}">
            <p class="no-results">Sorry, no hotels found matching your criteria.</p>
        </c:when>
        <c:otherwise>
            <%-- 循环遍历酒店列表并显示卡片 --%>
            <c:forEach var="hotel" items="${hotels}">
                <div class="hotel-card">
                    <div class="hotel-image">
                            <%-- 占位符图片 --%>
                        🏨
                            <%-- 如果您在 Hotel.java 添加了 imageUrl 字段:
                            <img src="${fn:escapeXml(hotel.imageUrl)}" alt="${fn:escapeXml(hotel.name)}">
                            --%>
                    </div>
                    <div class="hotel-content">
                        <div class="hotel-details">
                            <h3>${fn:escapeXml(hotel.name)}</h3>
                            <p class="location">${fn:escapeXml(hotel.location)}</p>
                                <%-- 可以添加更多描述或设施 --%>
                        </div>
                        <div class="hotel-actions">
                            <div class="hotel-rating">
                                    <%-- 评分占位符 --%>
                                <span class="score">8.5</span>
                                <span class="reviews">Excellent</span>
                            </div>
                            <div class="hotel-price-book">
                                    <span class="price">
                                        $<fmt:formatNumber value="${hotel.pricePerNight}" type="currency" currencySymbol="" maxFractionDigits="2" minFractionDigits="2"/>
                                        <span style="font-size: 0.8rem; color: #666;">/ night</span>
                                    </span>
                                <a href="${pageContext.request.contextPath}/book?type=hotel&id=${hotel.id}" class="btn-view">
                                    View Deal →
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>

    <a href="index.jsp" class="back-link">← Back to Search</a>
</div>
</body>
</html>