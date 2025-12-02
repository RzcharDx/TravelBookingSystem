<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Car Rental Results</title>
    <style>
        /* --- 基础样式 --- */
        :root {
            --primary-blue: #0770e3;
            --dark-blue: #02122c;
            --bg-color: #f1f2f8;
            --text-color: #111236;
            --white: #ffffff;
            --success-green: #00a698;
            --text-grey: #68697f;
        }
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; background-color: var(--bg-color); color: var(--text-color); margin: 0; }

        /* --- 顶部搜索摘要 --- */
        .results-header { background-color: var(--dark-blue); padding: 1rem 2rem; color: white; display: flex; align-items: center; gap: 2rem; }
        .logo-small { font-weight: 800; font-size: 1.5rem; text-decoration: none; color: white; margin-right: auto; }
        .search-summary { background: rgba(255,255,255,0.1); padding: 0.5rem 1rem; border-radius: 4px; font-size: 0.9rem; display: flex; gap: 1rem; align-items: center; }
        .summary-item { font-weight: 600; }
        .separator { opacity: 0.5; }

        /* --- 主容器 --- */
        .container { max-width: 1200px; margin: 2rem auto; padding: 0 1rem; display: flex; gap: 1.5rem; }

        /* --- 侧边栏筛选 --- */
        .filters-sidebar { width: 280px; flex-shrink: 0; display: none; }
        @media (min-width: 900px) { .filters-sidebar { display: block; } }

        .filter-box {
            background: #fff;
            border-radius: 8px;
            margin-bottom: 1rem;
            box-shadow: 0 1px 4px rgba(0,0,0,0.05);
            overflow: hidden;
        }

        /* 可点击的标题样式 */
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

        /* 箭头图标样式 */
        .toggle-icon { font-size: 0.8rem; color: #666; transition: transform 0.3s ease; }

        /* 折叠状态下的箭头旋转 */
        .filter-box.collapsed .toggle-icon { transform: rotate(-90deg); }

        /* 筛选内容容器 */
        .filter-content {
            padding: 0 1.5rem 1.5rem 1.5rem;
            transition: max-height 0.3s ease-out, opacity 0.3s ease-out;
            max-height: 500px;
            opacity: 1;
            overflow: hidden;
        }

        /* 折叠状态下的内容隐藏 */
        .filter-box.collapsed .filter-content { max-height: 0; padding-bottom: 0; opacity: 0; }

        .checkbox-row { display: flex; align-items: center; margin-bottom: 0.6rem; font-size: 0.9rem; color: var(--text-color); cursor: pointer; }
        .checkbox-row input { margin-right: 0.6rem; accent-color: var(--primary-blue); width: 16px; height: 16px; }

        /* --- 结果列表 --- */
        .results-list { flex: 1; min-width: 0; }
        .results-count { margin-bottom: 1rem; font-size: 1.1rem; font-weight: 700; color: #444; }

        /* --- 租车卡片 --- */
        .car-card {
            background: var(--white);
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            margin-bottom: 1.5rem;
            padding: 1.5rem;
            display: flex;
            flex-direction: column;
            transition: transform 0.2s, box-shadow 0.2s;
            border: 1px solid transparent;
            animation: fadeIn 0.5s ease-out forwards;
            opacity: 0;
        }
        .car-card:hover { transform: translateY(-2px); box-shadow: 0 8px 16px rgba(0,0,0,0.1); border-color: #ddd; }

        @media (min-width: 768px) {
            .car-card { flex-direction: row; gap: 2rem; }
        }

        /* 左侧：图片 */
        .car-image-section {
            flex: 0 0 200px;
            display: flex; flex-direction: column; align-items: center; justify-content: center;
        }
        .car-image { width: 100%; max-width: 180px; height: auto; object-fit: contain; margin-bottom: 1rem; }
        .placeholder-car { font-size: 4rem; color: #ccc; }

        /* 中间：详情 */
        .car-details { flex: 1; display: flex; flex-direction: column; justify-content: space-between; }
        .car-header { margin-bottom: 1rem; }
        .car-category { font-size: 0.8rem; text-transform: uppercase; color: var(--text-grey); font-weight: 600; letter-spacing: 0.5px; margin-bottom: 0.2rem; }
        .car-title { font-size: 1.4rem; font-weight: 700; margin: 0; color: var(--text-color); }
        .car-subtitle { font-size: 0.9rem; color: var(--text-grey); }

        .car-features { display: flex; gap: 1.5rem; margin-bottom: 1rem; color: #555; font-size: 0.9rem; flex-wrap: wrap; }
        .feature-item { display: flex; align-items: center; gap: 0.4rem; }
        .icon { font-size: 1.1rem; color: #888; }

        .supplier-info { display: flex; align-items: center; gap: 0.8rem; margin-top: auto; }
        .supplier-logo { font-weight: 700; color: var(--dark-blue); }
        .rating-badge { background-color: var(--dark-blue); color: white; padding: 2px 6px; border-radius: 4px; font-size: 0.8rem; font-weight: bold; }

        /* 右侧：价格 */
        .car-price-section {
            flex: 0 0 180px;
            border-left: 1px solid #eee;
            padding-left: 2rem;
            display: flex; flex-direction: column; justify-content: flex-end; align-items: flex-end; text-align: right;
        }
        .price-label { font-size: 0.8rem; color: var(--text-grey); }
        .total-price { font-size: 1.8rem; font-weight: 800; color: var(--text-color); line-height: 1.2; }
        .price-per-day { font-size: 0.9rem; color: var(--text-grey); margin-bottom: 1rem; }

        .btn-select {
            background-color: var(--success-green);
            color: white;
            text-decoration: none;
            padding: 0.8rem 1.5rem;
            border-radius: 6px;
            font-weight: 700;
            font-size: 1.1rem;
            transition: background-color 0.2s;
            display: inline-block;
            white-space: nowrap;
        }
        .btn-select:hover { background-color: #008f82; }

        .badge-free-cancellation { color: var(--success-green); font-size: 0.85rem; font-weight: 500; display: flex; align-items: center; gap: 0.3rem; margin-bottom: 0.5rem; }
        .no-results { text-align: center; padding: 3rem; color: var(--text-grey); background: white; border-radius: 8px; }
        .back-link { margin-top: 1rem; display: inline-block; color: var(--primary-blue); text-decoration: none; }

        /* 动画 */
        .car-card:nth-child(1) { animation-delay: 0.1s; }
        .car-card:nth-child(2) { animation-delay: 0.2s; }
        .car-card:nth-child(3) { animation-delay: 0.3s; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body>

<%-- 顶部栏 --%>
<div class="results-header">
    <a href="<c:url value='/'/>" class="logo-small">skyscanner</a>
    <div class="search-summary">
        <span class="summary-item">${fn:escapeXml(param.pickupLocation)}</span>
        <span class="separator">→</span>
        <span class="summary-item">
                <c:out value="${param.dropoffLocation}" default="${param.pickupLocation}" />
            </span>
        <span class="separator">|</span>
        <span class="summary-item">${param.pickupDate}</span>
        <span class="separator">-</span>
        <span class="summary-item">${param.dropoffDate}</span>
    </div>
</div>

<div class="container">

    <%-- 左侧筛选栏 --%>
    <aside class="filters-sidebar">

        <%-- 1. 车辆类型筛选 (模拟数据) --%>
        <div class="filter-box">
            <div class="filter-title" onclick="toggleFilter(this)">
                Car specs
                <span class="toggle-icon">▼</span>
            </div>
            <div class="filter-content">
                <label class="checkbox-row">
                    <input type="checkbox" class="filter-spec" value="aircon" onchange="applyCarFilters()"> Air conditioning
                </label>
                <label class="checkbox-row">
                    <input type="checkbox" class="filter-spec" value="auto" onchange="applyCarFilters()"> Automatic Transmission
                </label>
                <label class="checkbox-row">
                    <input type="checkbox" class="filter-spec" value="4doors" onchange="applyCarFilters()"> 4+ Doors
                </label>
            </div>
        </div>

        <%-- 2. 供应商筛选 --%>
        <div class="filter-box">
            <div class="filter-title" onclick="toggleFilter(this)">
                Car Hire Company
                <span class="toggle-icon">▼</span>
            </div>
            <div class="filter-content">
                <label class="checkbox-row">
                    <input type="checkbox" class="filter-company" value="Hertz" onchange="applyCarFilters()"> Hertz
                </label>
                <label class="checkbox-row">
                    <input type="checkbox" class="filter-company" value="Avis" onchange="applyCarFilters()"> Avis
                </label>
                <label class="checkbox-row">
                    <input type="checkbox" class="filter-company" value="Budget" onchange="applyCarFilters()"> Budget
                </label>
                <label class="checkbox-row">
                    <input type="checkbox" class="filter-company" value="Europcar" onchange="applyCarFilters()"> Europcar
                </label>
                <label class="checkbox-row">
                    <input type="checkbox" class="filter-company" value="Enterprise" onchange="applyCarFilters()"> Enterprise
                </label>
            </div>
        </div>

        <%-- 3. 价格筛选 --%>
        <div class="filter-box">
            <div class="filter-title" onclick="toggleFilter(this)">
                Price per day
                <span class="toggle-icon">▼</span>
            </div>
            <div class="filter-content">
                <label class="checkbox-row">
                    <input type="checkbox" class="filter-price" value="low" onchange="applyCarFilters()"> Less than $60
                </label>
                <label class="checkbox-row">
                    <input type="checkbox" class="filter-price" value="medium" onchange="applyCarFilters()"> $60 - $100
                </label>
                <label class="checkbox-row">
                    <input type="checkbox" class="filter-price" value="high" onchange="applyCarFilters()"> $100+
                </label>
            </div>
        </div>
    </aside>

    <%-- 结果列表 --%>
    <main class="results-list">

        <c:if test="${not empty searchError}">
            <div style="background: #ffd2d2; color: #d8000c; padding: 1rem; border-radius: 4px; margin-bottom: 1.5rem;">
                    ${searchError}
            </div>
        </c:if>

        <div class="results-count">
            <span id="result-count">${fn:length(cars)}</span> cars found
        </div>

        <div id="car-results-container">
            <c:choose>
                <c:when test="${empty cars}">
                    <div class="no-results">
                        <p>No cars found matching your criteria.</p>
                        <a href="<c:url value='/'/>" class="back-link">Modify Search</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="car" items="${cars}">
                        <%--
                           [关键] 添加 data-* 属性用于 JS 筛选
                           注意：由于数据库中缺少 details 字段，我们这里添加了一些模拟的 data-specs
                           以便演示筛选功能 (实际项目中应从数据库读取)
                        --%>
                        <div class="car-card"
                             data-price="${car.pricePerDay}"
                             data-company="${car.company}"
                             data-specs="aircon auto 4doors"> <%-- 假设所有车都有这些配置用于演示 --%>

                            <div class="car-image-section">
                                <div class="placeholder-car">🚗</div>
                            </div>

                            <div class="car-details">
                                <div class="car-header">
                                    <div class="car-category">Compact / Economy</div>
                                    <h3 class="car-title">${fn:escapeXml(car.model)}</h3>
                                    <div class="car-subtitle">or similar</div>
                                </div>

                                <div class="car-features">
                                    <div class="feature-item" title="Passengers"><span class="icon">👤</span> 4</div>
                                    <div class="feature-item" title="Doors"><span class="icon">🚪</span> 4</div>
                                    <div class="feature-item" title="Transmission"><span class="icon">⚙️</span> Auto</div>
                                    <div class="feature-item" title="Air Conditioning"><span class="icon">❄️</span> A/C</div>
                                </div>

                                <div class="supplier-info">
                                    <span class="supplier-logo">${fn:escapeXml(car.company)}</span>
                                    <div class="rating-badge">8.5</div>
                                    <span style="font-size: 0.8rem; color: #666;">Very Good</span>
                                </div>
                            </div>

                            <div class="car-price-section">
                                <div class="badge-free-cancellation"><span>✓</span> Free cancellation</div>
                                <span class="price-label">Total price (approx)</span>
                                <span class="total-price">
                                        <fmt:setLocale value="en_US"/>
                                        <fmt:formatNumber value="${car.pricePerDay * 3}" type="currency" maxFractionDigits="0"/>
                                    </span>
                                <span class="price-per-day">
                                        <fmt:formatNumber value="${car.pricePerDay}" type="currency" maxFractionDigits="0"/> / day
                                    </span>
                                <a href="${pageContext.request.contextPath}/book?type=car&id=${car.id}" class="btn-select">Select</a>
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
    function applyCarFilters() {
        // 获取选中的筛选条件
        const selectedSpecs = Array.from(document.querySelectorAll('.filter-spec:checked')).map(cb => cb.value);
        const selectedCompanies = Array.from(document.querySelectorAll('.filter-company:checked')).map(cb => cb.value);
        const selectedPrices = Array.from(document.querySelectorAll('.filter-price:checked')).map(cb => cb.value);

        const cards = document.querySelectorAll('.car-card');
        let visibleCount = 0;

        cards.forEach(card => {
            let isVisible = true;

            // A. 规格筛选 (AND 逻辑)
            if (selectedSpecs.length > 0) {
                const specs = card.getAttribute('data-specs');
                const hasAllSpecs = selectedSpecs.every(spec => specs.includes(spec));
                if (!hasAllSpecs) isVisible = false;
            }

            // B. 供应商筛选 (OR 逻辑)
            if (isVisible && selectedCompanies.length > 0) {
                const company = card.getAttribute('data-company');
                // 简单的包含检查 (如果公司名称包含在选中的列表中)
                // 注意：实际应用中可能需要更精确的匹配
                let companyMatch = selectedCompanies.some(c => company.includes(c));
                if (!companyMatch) isVisible = false;
            }

            // C. 价格筛选 (OR 逻辑)
            if (isVisible && selectedPrices.length > 0) {
                const price = parseFloat(card.getAttribute('data-price'));
                let priceMatch = false;
                if (selectedPrices.includes('low') && price < 60) priceMatch = true;
                if (selectedPrices.includes('medium') && price >= 60 && price <= 100) priceMatch = true;
                if (selectedPrices.includes('high') && price > 100) priceMatch = true;

                if (!priceMatch) isVisible = false;
            }

            // 显示/隐藏
            card.style.display = isVisible ? 'flex' : 'none';
            if (isVisible) visibleCount++;
        });

        // 更新计数
        const countSpan = document.getElementById('result-count');
        if(countSpan) countSpan.textContent = visibleCount;
    }
</script>

</body>
</html>