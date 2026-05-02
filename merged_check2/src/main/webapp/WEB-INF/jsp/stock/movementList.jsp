<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ include file="/WEB-INF/jsp/common/header.jsp" %>
<%@ include file="/WEB-INF/jsp/common/sidebar.jsp" %>

<style>
    .page-header { display:flex;align-items:center;justify-content:space-between;margin-bottom:20px; }
    .page-title  { font-size:20px;font-weight:700;color:var(--text);letter-spacing:-.4px; }
    .page-sub    { font-size:13px;color:var(--muted);margin-top:3px; }

    .search-card { background:var(--surface);border:1px solid var(--border);border-radius:12px;
                   padding:16px 20px;margin-bottom:16px;display:flex;gap:10px;align-items:center;flex-wrap:wrap; }
    .search-card input,.search-card select { height:36px;padding:0 12px;border:1px solid var(--border);
        border-radius:8px;font-size:13px;font-family:inherit;color:var(--text);outline:none;
        background:var(--bg);transition:border-color .2s; }
    .search-card input:focus,.search-card select:focus { border-color:var(--accent); }
    .search-card input[type=text]  { width:180px; }
    .search-card input[type=date]  { width:140px; }
    .search-card select { width:140px; }

    .btn { height:36px;padding:0 16px;border-radius:8px;font-size:13px;font-family:inherit;
           font-weight:500;cursor:pointer;border:none;display:inline-flex;align-items:center;
           gap:6px;text-decoration:none;transition:opacity .15s,transform .1s; }
    .btn:active { transform:scale(.97); }
    .btn-primary { background:var(--accent);color:white; }
    .btn-primary:hover { opacity:.88; }
    .btn-outline { background:var(--surface);color:var(--text);border:1px solid var(--border); }
    .btn-outline:hover { background:var(--bg); }
    .btn-success { background:#059669;color:white; }
    .btn-success:hover { opacity:.88; }

    .table-card { background:var(--surface);border:1px solid var(--border);border-radius:12px;
                  overflow:hidden;box-shadow:0 2px 8px rgba(0,0,0,.05); }
    .table-card-head { display:flex;align-items:center;justify-content:space-between;
                       padding:14px 20px;border-bottom:1px solid var(--border); }
    .table-card-head span { font-size:14px;font-weight:600;color:var(--text); }
    .total-badge { background:var(--bg);border:1px solid var(--border);border-radius:20px;
                   padding:2px 10px;font-size:12px;color:var(--muted); }

    table { width:100%;border-collapse:collapse; }
    thead th { background:#F8FAFC;font-size:12px;font-weight:600;color:var(--muted);
               text-align:left;padding:10px 16px;border-bottom:1px solid var(--border);white-space:nowrap; }
    tbody tr { border-bottom:1px solid #F1F5F9;transition:background .1s; }
    tbody tr:last-child { border-bottom:none; }
    tbody tr:hover { background:#F8FAFF; }
    tbody td { padding:11px 16px;font-size:13px;color:var(--text); }
    .num { text-align:right; }

    .type-badge { display:inline-block;padding:3px 9px;border-radius:20px;font-size:11px;font-weight:600; }
    .type-INBOUND  { background:#EFF6FF;color:#2563EB; }
    .type-OUTBOUND { background:#FFF1F2;color:#E11D48; }
    .type-TRANSFER { background:#F5F3FF;color:#7C3AED; }
    .type-ADJUST   { background:#FFF7ED;color:#EA580C; }
    .type-RETURN   { background:#ECFDF5;color:#059669; }

    .qty-in  { color:#2563EB;font-weight:600; }
    .qty-out { color:#E11D48;font-weight:600; }

    .empty-row td { text-align:center;padding:48px;color:var(--muted);font-size:14px; }
</style>

<main id="content">
    <div class="page-header">
        <div>
            <div class="page-title">입출고 이력</div>
            <div class="page-sub">재고 변동 이력을 조회합니다.</div>
        </div>
        <div style="display:flex;gap:8px">
            <a href="${pageContext.request.contextPath}/stock/list.do" class="btn btn-outline">재고 현황</a>
            <a href="${pageContext.request.contextPath}/stock/movementForm.do" class="btn btn-success">+ 입출고 등록</a>
        </div>
    </div>

    <form action="${pageContext.request.contextPath}/stock/movement.do" method="get">
    <div class="search-card">
        <select name="movementType">
            <option value="">전체 유형</option>
            <option value="INBOUND"  <c:if test="${searchVO.movementType == 'INBOUND'}">selected</c:if>>입고</option>
            <option value="OUTBOUND" <c:if test="${searchVO.movementType == 'OUTBOUND'}">selected</c:if>>출고</option>
            <option value="TRANSFER" <c:if test="${searchVO.movementType == 'TRANSFER'}">selected</c:if>>창고이동</option>
            <option value="ADJUST"   <c:if test="${searchVO.movementType == 'ADJUST'}">selected</c:if>>조정</option>
            <option value="RETURN"   <c:if test="${searchVO.movementType == 'RETURN'}">selected</c:if>>반품</option>
        </select>
        <select name="warehouseId">
            <option value="">전체 창고</option>
            <c:forEach items="${warehouseList}" var="w">
                <option value="${w.warehouseId}" <c:if test="${searchVO.warehouseId == w.warehouseId}">selected</c:if>>
                    ${w.warehouseName}
                </option>
            </c:forEach>
        </select>
        <input type="text" name="keyword" value="${searchVO.keyword}" placeholder="상품명 또는 코드">
        <input type="date" name="fromDate" value="${searchVO.fromDate}">
        <span style="color:var(--muted);font-size:13px">~</span>
        <input type="date" name="toDate" value="${searchVO.toDate}">
        <button type="submit" class="btn btn-primary">검색</button>
        <a href="${pageContext.request.contextPath}/stock/movement.do" class="btn btn-outline">초기화</a>
    </div>
    </form>

    <div class="table-card">
        <div class="table-card-head">
            <span>입출고 이력</span>
            <span class="total-badge">총 <strong>${empty movementList ? '0' : movementList.size()}</strong>건</span>
        </div>
        <table>
            <thead>
                <tr>
                    <th>처리일시</th>
                    <th>유형</th>
                    <th>상품코드</th>
                    <th>상품명</th>
                    <th>창고</th>
                    <th>수량</th>
                    <th>단가</th>
                    <th>처리자</th>
                    <th>비고</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty movementList}">
                        <tr class="empty-row"><td colspan="9">입출고 이력이 없습니다.</td></tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${movementList}" var="mv">
                        <tr>
                            <td>${mv.createdAt}</td>
                            <td>
                                <span class="type-badge type-${mv.movementType}">
                                    <c:choose>
                                        <c:when test="${mv.movementType == 'INBOUND'}">입고</c:when>
                                        <c:when test="${mv.movementType == 'OUTBOUND'}">출고</c:when>
                                        <c:when test="${mv.movementType == 'TRANSFER'}">창고이동</c:when>
                                        <c:when test="${mv.movementType == 'ADJUST'}">조정</c:when>
                                        <c:when test="${mv.movementType == 'RETURN'}">반품</c:when>
                                        <c:otherwise>${mv.movementType}</c:otherwise>
                                    </c:choose>
                                </span>
                            </td>
                            <td><strong>${mv.productCode}</strong></td>
                            <td>${mv.productName}</td>
                            <td>${mv.warehouseName}</td>
                            <td class="num">
                                <c:choose>
                                    <c:when test="${mv.movementType == 'OUTBOUND'}">
                                        <span class="qty-out">-<fmt:formatNumber value="${mv.qty}" pattern="#,##0.###"/></span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="qty-in">+<fmt:formatNumber value="${mv.qty}" pattern="#,##0.###"/></span>
                                    </c:otherwise>
                                </c:choose>
                                ${mv.unit}
                            </td>
                            <td class="num">
                                <c:if test="${mv.unitCost != null and mv.unitCost > 0}">
                                    <fmt:formatNumber value="${mv.unitCost}" pattern="#,##0"/>원
                                </c:if>
                            </td>
                            <td>${mv.createdByName}</td>
                            <td style="color:var(--muted)">${mv.remarks}</td>
                        </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</main>

</div>
</body>
</html>
