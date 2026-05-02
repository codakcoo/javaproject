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
    .search-card input  { width:200px; }
    .search-card select { width:160px; }

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

    .warn-low  { background:#FFF7ED;color:#EA580C;display:inline-block;padding:3px 9px;
                 border-radius:20px;font-size:11px;font-weight:600; }
    .warn-ok   { background:#ECFDF5;color:#059669;display:inline-block;padding:3px 9px;
                 border-radius:20px;font-size:11px;font-weight:600; }
    .qty-zero  { color:#94A3B8; }

    .empty-row td { text-align:center;padding:48px;color:var(--muted);font-size:14px; }
</style>

<main id="content">
    <div class="page-header">
        <div>
            <div class="page-title">재고 현황</div>
            <div class="page-sub">상품별·창고별 실시간 재고 수량을 조회합니다.</div>
        </div>
        <a href="${pageContext.request.contextPath}/stock/movementForm.do" class="btn btn-success">
            + 입출고 등록
        </a>
    </div>

    <form action="${pageContext.request.contextPath}/stock/list.do" method="get">
    <div class="search-card">
        <select name="warehouseId">
            <option value="">전체 창고</option>
            <c:forEach items="${warehouseList}" var="w">
                <option value="${w.warehouseId}" <c:if test="${searchVO.warehouseId == w.warehouseId}">selected</c:if>>
                    ${w.warehouseName}
                </option>
            </c:forEach>
        </select>
        <input type="text" name="keyword" value="${searchVO.keyword}" placeholder="상품명 또는 코드 검색">
        <button type="submit" class="btn btn-primary">검색</button>
        <a href="${pageContext.request.contextPath}/stock/list.do" class="btn btn-outline">초기화</a>
        <a href="${pageContext.request.contextPath}/stock/movement.do" class="btn btn-outline" style="margin-left:auto">입출고 이력 보기</a>
    </div>
    </form>

    <div class="table-card">
        <div class="table-card-head">
            <span>재고 현황</span>
            <span class="total-badge">총 <strong>${empty inventoryList ? '0' : inventoryList.size()}</strong>건</span>
        </div>
        <table>
            <thead>
                <tr>
                    <th>상품코드</th>
                    <th>상품명</th>
                    <th>창고</th>
                    <th>단위</th>
                    <th>보유수량</th>
                    <th>예약수량</th>
                    <th>출고가능</th>
                    <th>발주기준점</th>
                    <th>상태</th>
                    <th>최종변경</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty inventoryList}">
                        <tr class="empty-row"><td colspan="10">재고 데이터가 없습니다.</td></tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${inventoryList}" var="inv">
                        <tr>
                            <td><strong>${inv.productCode}</strong></td>
                            <td>${inv.productName}</td>
                            <td>${inv.warehouseName}</td>
                            <td>${inv.unit}</td>
                            <td class="num"><fmt:formatNumber value="${inv.qtyOnHand}" pattern="#,##0.###"/></td>
                            <td class="num <c:if test="${inv.qtyReserved == 0}">qty-zero</c:if>">
                                <fmt:formatNumber value="${inv.qtyReserved}" pattern="#,##0.###"/>
                            </td>
                            <td class="num"><fmt:formatNumber value="${inv.qtyAvailable}" pattern="#,##0.###"/></td>
                            <td class="num"><fmt:formatNumber value="${inv.reorderPoint}" pattern="#,##0.###"/></td>
                            <td>
                                <c:choose>
                                    <c:when test="${inv.qtyOnHand <= inv.reorderPoint}">
                                        <span class="warn-low">발주필요</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="warn-ok">정상</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>${inv.lastUpdated}</td>
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
