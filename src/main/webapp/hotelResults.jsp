<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Hotel Results - GoTour Style</title>
    <style>
        /* --- 基础变量 --- */
        :root {
            --primary-blue: #0770e3;
            --dark-blue: #02122c;
            --bg-color: #f1f2f8;
            --text-color: #111236;
            --white: #ffffff;
            --success-green: #00a698;
            --text-grey: #68697f;
            --star-color: #feb54e;
        }

        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; background-color: var(--bg-color); color: var(--text-color); margin: 0; }

        /* --- 顶部栏 --- */
        .results-header { background-color: var(--dark-blue); padding: 1rem 2rem; color: white; display: flex; align-items: center; gap: 2rem; }
        .logo-small { font-weight: 800; font-size: 1.5rem; text-decoration: none; color: white; margin-right: auto; }
        .search-summary { background: rgba(255,255,255,0.1); padding: 0.5rem 1rem; border-radius: 4px; font-size: 0.9rem; display: flex; gap: 1rem; align-items: center; }
        .separator { opacity: 0.5; }

        /* --- 主容器 --- */
        .container { max-width: 1200px; margin: 2rem auto; padding: 0 1rem; display: flex; gap: 1.5rem; }

        /* --- 侧边栏 --- */
        .filters-sidebar { width: 280px; flex-shrink: 0; display: none; }
        @media (min-width: 900px) { .filters-sidebar { display: block; } }

        .filter-box {
            background: #fff;
            border-radius: 8px;
            margin-bottom: 1rem;
            box-shadow: 0 1px 4px rgba(0,0,0,0.05);
            overflow: hidden;
        }

        /* [新增] 可点击的标题样式 */
        .filter-title {
            font-weight: 700;
            font-size: 0.95rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            cursor: pointer;
            padding: 1.5rem;
            user-select: none;
        }

        /* [新增] 箭头图标样式 */
        .toggle-icon {
            font-size: 0.8rem;
            color: #666;
            transition: transform 0.3s ease;
        }

        /* [新增] 折叠状态下的箭头旋转 */
        .filter-box.collapsed .toggle-icon {
            transform: rotate(-90deg);
        }

        /* [新增] 筛选内容容器 */
        .filter-content {
            padding: 0 1.5rem 1.5rem 1.5rem;
            transition: max-height 0.3s ease-out, opacity 0.3s ease-out;
            max-height: 500px;
            opacity: 1;
            overflow: hidden;
        }

        /* [新增] 折叠状态下的内容隐藏 */
        .filter-box.collapsed .filter-content {
            max-height: 0;
            padding-bottom: 0;
            opacity: 0;
        }

        .checkbox-row { display: flex; align-items: center; margin-bottom: 0.6rem; font-size: 0.9rem; color: var(--text-color); cursor: pointer; }
        .checkbox-row input { margin-right: 0.6rem; accent-color: var(--primary-blue); width: 16px; height: 16px; }

        /* --- 结果列表 --- */
        .results-list { flex: 1; min-width: 0; }
        .results-header-text { margin-bottom: 1rem; font-size: 1.1rem; font-weight: 700; color: var(--text-color); }

        /* --- 酒店卡片 --- */
        .hotel-card {
            background: var(--white);
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            margin-bottom: 1.5rem;
            display: flex;
            flex-direction: column;
            overflow: hidden;
            transition: transform 0.2s, box-shadow 0.2s;
            border: 1px solid transparent;
            animation: fadeIn 0.5s ease-out forwards;
            opacity: 0;
        }
        .hotel-card:hover { transform: translateY(-2px); box-shadow: 0 8px 16px rgba(0,0,0,0.1); border-color: #ddd; }

        @media (min-width: 700px) {
            .hotel-card { flex-direction: row; height: 240px; }
        }

        .hotel-image-container { position: relative; width: 100%; height: 200px; background-color: #eee; flex-shrink: 0; }
        @media (min-width: 700px) { .hotel-image-container { width: 280px; height: 100%; } }
        .hotel-image { width: 100%; height: 100%; object-fit: cover; }
        .placeholder-image { width: 100%; height: 100%; display: flex; align-items: center; justify-content: center; background-color: #e0e0e0; color: #999; font-size: 3rem; }
        .heart-icon { position: absolute; top: 10px; right: 10px; background: rgba(255,255,255,0.9); border-radius: 50%; padding: 6px; cursor: pointer; font-size: 1.1rem; color: #555; transition: color 0.2s; }
        .heart-icon:hover { color: #e91e63; }

        .hotel-content { flex: 1; padding: 1.2rem; display: flex; justify-content: space-between; gap: 1rem; }
        .info-section { flex: 1; display: flex; flex-direction: column; justify-content: space-between; }
        .hotel-name-row { margin-bottom: 0.3rem; }
        .hotel-name { font-size: 1.2rem; font-weight: 700; color: var(--text-color); margin: 0; line-height: 1.3; display: inline; }
        .hotel-stars { color: var(--star-color); font-size: 0.9rem; margin-left: 0.5rem; }
        .location-row { font-size: 0.85rem; color: var(--text-grey); margin-bottom: 0.8rem; display: flex; align-items: center; gap: 4px; }
        .distance-text { color: var(--text-color); font-weight: 500; }
        .features-list { border-left: 2px solid #eee; padding-left: 0.8rem; margin-top: 0.5rem; }
        .feature-item { font-size: 0.8rem; color: var(--success-green); font-weight: 600; margin-bottom: 4px; display: flex; align-items: center; gap: 5px; }
        .feature-item.neutral { color: var(--text-color); font-weight: 400; }
        .feature-check { font-size: 0.9rem; }

        .price-section { text-align: right; display: flex; flex-direction: column; justify-content: space-between; align-items: flex-end; min-width: 140px; }
        .rating-box { display: flex; align-items: flex-start; gap: 0.8rem; text-align: right; }
        .rating-text div:first-child { font-weight: 700; font-size: 0.95rem; color: var(--text-color); }
        .rating-text div:last-child { font-size: 0.75rem; color: var(--text-grey); }
        .rating-badge { background-color: var(--primary-blue); color: white; font-weight: 700; padding: 6px; border-radius: 6px 6px 6px 0; font-size: 1rem; min-width: 32px; text-align: center; }
        .price-box { margin-top: auto; }
        .price-label { font-size: 0.75rem; color: var(--text-grey); margin-bottom: 2px; display: block; }
        .price-value { font-size: 1.6rem; font-weight: 800; color: var(--text-color); line-height: 1; }
        .price-sub { font-size: 0.75rem; color: var(--text-grey); margin-top: 2px; display: block; }
        .btn-view-deal { background-color: var(--success-green); color: white; text-decoration: none; padding: 0.7rem 1.2rem; border-radius: 6px; font-weight: 700; font-size: 0.95rem; display: inline-flex; align-items: center; gap: 0.4rem; margin-top: 0.8rem; transition: background-color 0.2s; white-space: nowrap; }
        .btn-view-deal:hover { background-color: #008f82; }

        .hotel-card:nth-child(1) { animation-delay: 0.1s; }
        .hotel-card:nth-child(2) { animation-delay: 0.2s; }
        .hotel-card:nth-child(3) { animation-delay: 0.3s; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }

        .no-results { text-align: center; padding: 3rem; background: white; border-radius: 8px; color: var(--text-grey); }
        .back-link { display: inline-block; margin-top: 1rem; color: var(--primary-blue); text-decoration: none; font-weight: 600; }
    </style>
</head>
<body>

<%-- 顶部摘要 --%>
<div class="results-header">
    <a href="<c:url value='/'/>" class="logo-small">GoTour</a>
    <div class="search-summary">
        <span class="summary-item">${fn:escapeXml(searchLocation)}</span>
        <span class="separator">|</span>
        <span class="summary-item">
                <c:choose>
                    <c:when test="${not empty searchCheckin}">${fn:escapeXml(searchCheckin)} - ${fn:escapeXml(searchCheckout)}</c:when>
                    <c:otherwise>Dates not selected</c:otherwise>
                </c:choose>
            </span>
        <span class="separator">|</span>
        <span class="summary-item">${searchGuests} Guests</span>
    </div>
</div>

<div class="container">

    <%-- 左侧筛选栏 --%>
    <aside class="filters-sidebar">

        <%-- 1. 设施筛选 --%>
        <div class="filter-box">
            <div class="filter-title" onclick="toggleFilter(this)">
                Popular filters
                <span class="toggle-icon">▼</span>
            </div>
            <div class="filter-content">
                <label class="checkbox-row">
                    <input type="checkbox" class="filter-feature" value="breakfast" onchange="applyHotelFilters()"> Breakfast included
                </label>
                <label class="checkbox-row">
                    <input type="checkbox" class="filter-feature" value="freeCancellation" onchange="applyHotelFilters()"> Free cancellation
                </label>
                <label class="checkbox-row">
                    <input type="checkbox" class="filter-feature" value="noPrepayment" onchange="applyHotelFilters()"> No prepayment
                </label>
            </div>
        </div>

        <%-- 2. 价格筛选 --%>
        <div class="filter-box">
            <div class="filter-title" onclick="toggleFilter(this)">
                Price per night
                <span class="toggle-icon">▼</span>
            </div>
            <div class="filter-content">
                <label class="checkbox-row">
                    <input type="checkbox" class="filter-price" value="low" onchange="applyHotelFilters()"> Less than $150
                </label>
                <label class="checkbox-row">
                    <input type="checkbox" class="filter-price" value="medium" onchange="applyHotelFilters()"> $150 - $300
                </label>
                <label class="checkbox-row">
                    <input type="checkbox" class="filter-price" value="high" onchange="applyHotelFilters()"> $300+
                </label>
            </div>
        </div>

        <%-- 3. 评分筛选 --%>
        <div class="filter-box">
            <div class="filter-title" onclick="toggleFilter(this)">
                Guest rating
                <span class="toggle-icon">▼</span>
            </div>
            <div class="filter-content">
                <label class="checkbox-row">
                    <input type="checkbox" class="filter-rating" value="9" onchange="applyHotelFilters()"> Excellent (9+)
                </label>
                <label class="checkbox-row">
                    <input type="checkbox" class="filter-rating" value="8" onchange="applyHotelFilters()"> Very Good (8+)
                </label>
                <label class="checkbox-row">
                    <input type="checkbox" class="filter-rating" value="7" onchange="applyHotelFilters()"> Good (7+)
                </label>
            </div>
        </div>
    </aside>

    <%-- 结果列表 --%>
    <main class="results-list">

        <c:if test="${not empty searchError}">
            <div style="background: #fff0f0; color: #d32f2f; padding: 1rem; border-radius: 4px; margin-bottom: 1.5rem; border: 1px solid #ffcdd2;">
                ⚠️ ${searchError}
            </div>
        </c:if>

        <div class="results-header-text">
            <span id="result-count">${fn:length(hotels)}</span> properties found
        </div>

        <div id="hotel-results-container">
            <c:choose>
                <c:when test="${empty hotels}">
                    <div class="no-results">
                        <h3>No hotels found</h3>
                        <p>Try adjusting your search filters or changing the location.</p>
                        <a href="<c:url value='/'/>" class="back-link">Modify Search</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="hotel" items="${hotels}">
                        <%--
                          [关键] 添加 data-* 属性用于 JS 筛选
                          注意：我们将设施布尔值转换为字符串标记
                        --%>
                        <c:set var="featureTags" value=""/>
                        <c:if test="${hotel.breakfastIncluded}"><c:set var="featureTags" value="${featureTags} breakfast"/></c:if>
                        <c:if test="${hotel.freeCancellation}"><c:set var="featureTags" value="${featureTags} freeCancellation"/></c:if>
                        <c:if test="${hotel.noPrepayment}"><c:set var="featureTags" value="${featureTags} noPrepayment"/></c:if>

                        <div class="hotel-card"
                             data-price="${hotel.pricePerNight}"
                             data-rating="${hotel.rating}"
                             data-features="${featureTags}">

                            <div class="hotel-image-container">
                                <div class="heart-icon">♡</div>
                                <c:choose>
                                    <c:when test="${not empty hotel.imageUrl}">
                                        <img src="${fn:escapeXml(hotel.imageUrl)}" alt="${fn:escapeXml(hotel.name)}" class="hotel-image">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="placeholder-image">🏨</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="hotel-content">
                                <div class="info-section">
                                    <div>
                                        <div class="hotel-name-row">
                                            <h3 class="hotel-name">${fn:escapeXml(hotel.name)}</h3>
                                            <span class="hotel-stars"><c:forEach begin="1" end="${hotel.starRating}">★</c:forEach></span>
                                        </div>
                                        <div class="location-row">
                                            <span>${fn:escapeXml(hotel.location)}</span>
                                            <c:if test="${not empty hotel.distanceText}">
                                                <span>•</span>
                                                <span class="distance-text">${fn:escapeXml(hotel.distanceText)}</span>
                                            </c:if>
                                        </div>
                                    </div>

                                    <div class="features-list">
                                        <div class="feature-item neutral">Standard Room • ${hotel.maxGuestsPerRoom} Guests</div>
                                        <c:if test="${hotel.freeCancellation}">
                                            <div class="feature-item"><span class="feature-check">✔</span> Free cancellation</div>
                                        </c:if>
                                        <c:if test="${hotel.breakfastIncluded}">
                                            <div class="feature-item"><span class="feature-check">✔</span> Breakfast included</div>
                                        </c:if>
                                        <c:if test="${hotel.noPrepayment}">
                                            <div class="feature-item"><span class="feature-check">✔</span> No prepayment needed</div>
                                        </c:if>
                                    </div>
                                </div>

                                <div class="price-section">
                                    <div class="rating-box">
                                        <div class="rating-text">
                                            <div>
                                                <c:choose>
                                                    <c:when test="${hotel.rating >= 9.0}">Wonderful</c:when>
                                                    <c:when test="${hotel.rating >= 8.0}">Excellent</c:when>
                                                    <c:when test="${hotel.rating >= 7.0}">Very Good</c:when>
                                                    <c:otherwise>Good</c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div>${hotel.reviewCount} reviews</div>
                                        </div>
                                        <div class="rating-badge">${hotel.rating}</div>
                                    </div>

                                    <div class="price-box">
                                        <span class="price-label">1 night, ${searchGuests} adults</span>
                                        <span class="price-value">$<fmt:formatNumber value="${hotel.pricePerNight}" type="currency" currencySymbol="" maxFractionDigits="0"/></span>
                                        <span class="price-sub">+ taxes & charges</span>
                                        <a href="${pageContext.request.contextPath}/book?type=hotel&id=${hotel.id}" class="btn-view-deal">View Deal <span>→</span></a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </main>
</div>

<script>
    // 1. 侧边栏折叠功能
    function toggleFilter(header) {
        const box = header.parentElement;
        if (box.classList.contains('collapsed')) {
            box.classList.remove('collapsed');
        } else {
            box.classList.add('collapsed');
        }
    }

    // 2. 前端筛选逻辑
    function applyHotelFilters() {
        // 获取所有选中的筛选条件
        const selectedFeatures = Array.from(document.querySelectorAll('.filter-feature:checked')).map(cb => cb.value);
        const selectedPrices = Array.from(document.querySelectorAll('.filter-price:checked')).map(cb => cb.value);
        const selectedRatings = Array.from(document.querySelectorAll('.filter-rating:checked')).map(cb => parseFloat(cb.value));

        const cards = document.querySelectorAll('.hotel-card');
        let visibleCount = 0;

        cards.forEach(card => {
            let isVisible = true;

            // A. 检查设施 (必须满足所有选中的设施 - AND 逻辑)
            if (selectedFeatures.length > 0) {
                const hotelFeatures = card.getAttribute('data-features'); // 例如 " breakfast freeCancellation"
                const hasAllFeatures = selectedFeatures.every(feature => hotelFeatures.includes(feature));
                if (!hasAllFeatures) isVisible = false;
            }

            // B. 检查价格 (满足任一选中的范围 - OR 逻辑)
            if (isVisible && selectedPrices.length > 0) {
                const price = parseFloat(card.getAttribute('data-price'));
                let priceMatch = false;
                if (selectedPrices.includes('low') && price < 150) priceMatch = true;
                if (selectedPrices.includes('medium') && price >= 150 && price <= 300) priceMatch = true;
                if (selectedPrices.includes('high') && price > 300) priceMatch = true;

                if (!priceMatch) isVisible = false;
            }

            // C. 检查评分 (满足任一选中的范围 - OR 逻辑，通常是 >= 关系)
            if (isVisible && selectedRatings.length > 0) {
                const rating = parseFloat(card.getAttribute('data-rating'));
                // 只要评分高于任意一个选中的最低分即可 (例如选中 8+ 和 9+，则 8.5 的酒店应该显示)
                // 取选中条件中的最小值作为门槛
                const minRating = Math.min(...selectedRatings);
                if (rating < minRating) isVisible = false;
            }

            // 应用显示/隐藏
            card.style.display = isVisible ? 'flex' : 'none';
            if (isVisible) visibleCount++;
        });

        // 更新结果数量文字
        const countSpan = document.getElementById('result-count');
        if(countSpan) countSpan.textContent = visibleCount;
    }
</script>
</body>
</html>