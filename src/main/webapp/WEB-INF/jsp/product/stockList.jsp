<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ include file="/WEB-INF/jsp/common/header.jsp" %>
<%@ include file="/WEB-INF/jsp/common/sidebar.jsp" %>

<style>
    .page-header { display:flex; align-items:center; justify-content:space-between; margin-bottom:16px; }
    .page-title  { font-size:18px; font-weight:700; color:var(--text); }
    .page-sub    { font-size:12px; color:var(--muted); margin-top:2px; }
    .summary-row { display:grid; grid-template-columns:repeat(3,1fr); gap:10px; margin-bottom:12px; }
    .sum-card { background:var(--surface); border:1px solid var(--border); padding:12px 16px; }
    .sum-card.warn { border-color:#FECACA; background:#FFF5F5; }
    .sum-label { font-size:11px; color:var(--muted); margin-bottom:4px; }
    .sum-card.warn .sum-label { color:#E11D48; }
    .sum-value { font-size:20px; font-weight:700; color:var(--text); }
    .sum-card.warn .sum-value { color:#E11D48; }
    .sum-unit  { font-size:11px; color:var(--muted); margin-top:1px; }
    .search-bar  { background:var(--surface); border:1px solid var(--border); padding:12px 16px; margin-bottom:12px; display:flex; gap:8px; align-items:center; flex-wrap:wrap; }
    .search-bar input, .search-bar select { height:32px; padding:0 10px; border:1px solid var(--border); font-size:12px; font-family:inherit; outline:none; background:var(--bg); }
    .search-bar input { width:180px; } .search-bar select { width:130px; }
    .btn { height:32px; padding:0 14px; font-size:12px; font-family:inherit; font-weight:500; cursor:pointer; border:none; display:inline-flex; align-items:center; gap:5px; text-decoration:none; transition:opacity 0.15s; }
    .btn-primary { background:var(--blue); color:white; } .btn-primary:hover { opacity:0.85; }
    .btn-outline { background:var(--surface); color:var(--text); border:1px solid var(--border); } .btn-outline:hover { background:var(--bg); }
    .table-wrap { background:var(--surface); border:1px solid var(--border); overflow:hidden; }
    .table-head { display:flex; align-items:center; justify-content:space-between; padding:10px 16px; border-bottom:1px solid var(--border); }
    .table-head span { font-size:13px; font-weight:600; }
    .cnt-badge { background:var(--bg); border:1px solid var(--border); border-radius:20px; padding:1px 9px; font-size:11px; color:var(--muted); }
    table { width:100%; border-collapse:collapse; }
    thead th { background:#F8FAFC; font-size:11px; font-weight:600; color:var(--muted); text-align:left; padding:9px 14px; border-bottom:1px solid var(--border); white-space:nowrap; }
    tbody tr { border-bottom:1px solid #F1F5F9; transition:background 0.1s; }
    tbody tr.low-stock { background:#FFF5F5; }
    tbody tr:last-child { border-bottom:none; }
    tbody tr:hover { background:#F8FAFF; }
    tbody tr.low-stock:hover { background:#FEE2E2; }
    tbody td { padding:10px 14px; font-size:12px; color:var(--text); }
    .stock-bar-wrap { display:flex; align-items:center; gap:8px; }
    .stock-bar { flex:1; height:6px; background:#E5E7EB; border-radius:3px; overflow:hidden; min-width:80px; }
    .stock-bar-inner { height:100%; border-radius:3px; }
    .bar-safe { background:#10B981; } .bar-low { background:#EF4444; } .bar-warn { background:#F59E0B; }
    .badge { display:inline-block; padding:2px 8px; border-radius:20px; font-size:11px; font-weight:600; }
    .badge-safe   { background:#ECFDF5; color:#059669; }
    .badge-warn   { background:#FFFBEB; color:#D97706; }
    .badge-low    { background:#FFF1F2; color:#E11D48; }
    .badge-defect { background:#F3F4F6; color:#6B7280; }
    tbody tr.defect-row { background:#FAFAFA; }
    tbody tr.defect-row:hover { background:#F3F4F6; }
    tbody tr.defect-row td { color:#9CA3AF; }
    .btn-edit { background:#EFF6FF; color:#2563EB; border:none; padding:3px 9px; font-size:11px; font-family:inherit; cursor:pointer; font-weight:500; }
    .btn-edit:hover { background:#DBEAFE; }
    .modal-bg { display:none; position:fixed; inset:0; background:rgba(0,0,0,0.4); z-index:500; align-items:center; justify-content:center; }
    .modal-bg.open { display:flex; }
    .modal { background:var(--surface); width:380px; padding:24px; box-shadow:0 8px 32px rgba(0,0,0,0.18); }
    .modal-title { font-size:15px; font-weight:700; margin-bottom:18px; }
    .form-row { margin-bottom:12px; }
    .form-row label { display:block; font-size:11px; font-weight:600; color:var(--muted); margin-bottom:4px; }
    .form-row input, .form-row select { width:100%; height:34px; padding:0 10px; border:1px solid var(--border); font-size:12px; font-family:inherit; outline:none; background:var(--bg); }
    .modal-footer { display:flex; justify-content:flex-end; gap:8px; margin-top:20px; }
    .curr-info { background:#F0F6FF; border:1px solid #BFDBFE; padding:8px 12px; font-size:12px; margin-bottom:12px; color:var(--blue); }
</style>

<main id="content">
    <div class="page-header">
        <div>
            <div class="page-title">재고 현황</div>
            <div class="page-sub">영업/재고 &gt; 재고 현황</div>
        </div>
    </div>

    <div class="summary-row">
        <div class="sum-card">
            <div class="sum-label">전체 품목</div>
            <div class="sum-value">${totalCount}</div>
            <div class="sum-unit">개 품목</div>
        </div>
        <div class="sum-card ${lowStockCount > 0 ? 'warn' : ''}">
            <div class="sum-label">⚠ 발주기준점 미달</div>
            <div class="sum-value">${lowStockCount}</div>
            <div class="sum-unit">개 품목 즉시 발주 필요</div>
        </div>
        <div class="sum-card">
            <div class="sum-label">정상 재고</div>
            <div class="sum-value">${totalCount - lowStockCount}</div>
            <div class="sum-unit">개 품목</div>
        </div>
    </div>

    <form method="get" action="${pageContext.request.contextPath}/stock/list.do">
        <div class="search-bar">
            <select name="searchCategory">
                <option value="">전체 카테고리</option>
                <option value="식품"   ${searchVO.searchCategory eq '식품'   ? 'selected' : ''}>식품</option>
                <option value="전자"   ${searchVO.searchCategory eq '전자'   ? 'selected' : ''}>전자</option>
                <option value="소모품" ${searchVO.searchCategory eq '소모품' ? 'selected' : ''}>소모품</option>
                <option value="원자재" ${searchVO.searchCategory eq '원자재' ? 'selected' : ''}>원자재</option>
                <option value="기타"   ${searchVO.searchCategory eq '기타'   ? 'selected' : ''}>기타</option>
            </select>
            <input type="text" name="searchKeyword" value="${searchVO.searchKeyword}" placeholder="상품명 / 코드 검색">
            <label style="display:flex; align-items:center; gap:5px; font-size:12px; cursor:pointer; white-space:nowrap;">
                <input type="checkbox" name="includeDefect" value="Y"
                       ${searchVO.includeDefect eq 'Y' ? 'checked' : ''}
                       style="width:auto; height:auto;">
                불량창고 포함
            </label>
            <button type="submit" class="btn btn-primary">검색</button>
            <a href="${pageContext.request.contextPath}/stock/list.do" class="btn btn-outline">초기화</a>
        </div>
    </form>

    <div class="table-wrap">
        <div class="table-head">
            <span>재고 목록 <span style="font-size:11px; color:var(--muted); font-weight:400;">(발주기준점 미달 항목 상단 표시)</span></span>
            <span class="cnt-badge">${totalCount}건</span>
        </div>
        <table>
            <thead>
                <tr>
                    <th>상품코드</th><th>상품명</th><th>카테고리</th><th>단위</th><th>창고</th>
                    <th style="text-align:right">현재고</th>
                    <th style="text-align:right">예약수량</th>
                    <th style="text-align:right">발주기준점</th>
                    <th style="min-width:140px">재고상태</th>
                    <th>수량조정</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty stockList}">
                        <tr><td colspan="10" style="text-align:center; padding:30px; color:var(--muted);">재고 데이터가 없습니다.</td></tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="p" items="${stockList}">
                            <c:set var="isLow"    value="${p.qtyOnHand le p.reorderPoint}"/>
                            <c:set var="isDefect" value="${p.warehouseType eq 'DEFECT'}"/>
                            <c:set var="ratio"    value="${p.reorderPoint > 0 ? (p.qtyOnHand * 100 / (p.reorderPoint * 2)) : 100}"/>
                            <c:if test="${ratio > 100}"><c:set var="ratio" value="100"/></c:if>
                            <tr class="${isDefect ? 'defect-row' : (isLow ? 'low-stock' : '')}">
                                <td><code style="font-size:11px; background:#F1F5F9; padding:2px 5px;">${p.productCode}</code></td>
                                <td><strong>${p.productName}</strong></td>
                                <td>${p.category}</td>
                                <td>${p.unit}</td>
                                <td style="color:var(--muted)">
                                    ${empty p.warehouseName ? '-' : p.warehouseName}
                                    <c:if test="${isDefect}">
                                        <span class="badge badge-defect" style="margin-left:4px;">불량</span>
                                    </c:if>
                                </td>
                                <td style="text-align:right; font-weight:700; ${isDefect ? 'color:#9CA3AF;' : (isLow ? 'color:#E11D48;' : 'color:#059669;')}">
                                    <fmt:formatNumber value="${p.qtyOnHand}" pattern="#,##0.###"/>
                                </td>
                                <td style="text-align:right; color:var(--muted)">
                                    <fmt:formatNumber value="${p.qtyReserved}" pattern="#,##0.###"/>
                                </td>
                                <td style="text-align:right; color:var(--muted)">
                                    <fmt:formatNumber value="${p.reorderPoint}" pattern="#,##0.###"/>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${isDefect}">
                                            <span class="badge badge-defect">불량창고</span>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="stock-bar-wrap">
                                                <div class="stock-bar">
                                                    <div class="stock-bar-inner ${isLow ? 'bar-low' : (ratio < 60 ? 'bar-warn' : 'bar-safe')}"
                                                         style="width:${ratio}%"></div>
                                                </div>
                                                <span class="badge ${isLow ? 'badge-low' : (ratio < 60 ? 'badge-warn' : 'badge-safe')}">
                                                    ${isLow ? '⚠ 발주' : (ratio < 60 ? '주의' : '정상')}
                                                </span>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:if test="${p.warehouseId > 0 and not isDefect}">
                                        <button class="btn-edit"
                                            onclick="openStockModal(${p.productId},${p.warehouseId},'${p.productName}',${p.qtyOnHand})">
                                            수량 조정
                                        </button>
                                    </c:if>
                                    <c:if test="${p.warehouseId == 0 or empty p.warehouseId}">
                                        <span style="font-size:11px; color:var(--muted)">창고미배정</span>
                                    </c:if>
                                    <c:if test="${isDefect}">
                                        <span style="font-size:11px; color:#9CA3AF">조정불가</span>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</main>

<!-- 재고 조정 모달 -->
<div class="modal-bg" id="stockModal">
    <div class="modal">
        <div class="modal-title">재고 수량 조정</div>
        <form method="post" action="${pageContext.request.contextPath}/stock/update.do">
            <input type="hidden" name="productId"   id="st_pid">
            <input type="hidden" name="warehouseId" id="st_wid">
            <div class="curr-info" id="st_info"></div>
            <div class="form-row"><label>조정 방식</label>
                <select id="st_mode" onchange="calcNew()">
                    <option value="set">직접 입력</option>
                    <option value="add">입고 (+추가)</option>
                    <option value="sub">출고 (-차감)</option>
                </select>
            </div>
            <div class="form-row"><label>수량</label>
                <input type="number" id="st_qty" name="qtyOnHand" min="0" step="0.001" value="0" oninput="calcNew()">
            </div>
            <div style="background:#F8FAFC; border:1px solid var(--border); padding:10px 14px; font-size:12px;">
                변경 후 재고: <strong id="st_result" style="color:var(--blue)">-</strong>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" onclick="document.getElementById('stockModal').classList.remove('open')">취소</button>
                <button type="submit" class="btn btn-primary" onclick="return applyStock()">적용</button>
            </div>
        </form>
    </div>
</div>

<script>
var currQty = 0;
function openStockModal(pid, wid, name, qty) {
    currQty = qty;
    document.getElementById('st_pid').value  = pid;
    document.getElementById('st_wid').value  = wid;
    document.getElementById('st_info').textContent = name + ' · 현재고: ' + qty;
    document.getElementById('st_qty').value  = qty;
    document.getElementById('st_mode').value = 'set';
    calcNew();
    document.getElementById('stockModal').classList.add('open');
}
function calcNew() {
    var mode = document.getElementById('st_mode').value;
    var qty  = parseFloat(document.getElementById('st_qty').value) || 0;
    var result = mode==='set' ? qty : mode==='add' ? currQty+qty : currQty-qty;
    document.getElementById('st_result').textContent = result;
    return result;
}
function applyStock() {
    var mode = document.getElementById('st_mode').value;
    var qty  = parseFloat(document.getElementById('st_qty').value) || 0;
    var newQty = mode==='set' ? qty : mode==='add' ? currQty+qty : currQty-qty;
    if (newQty < 0) { alert('재고는 0 미만이 될 수 없습니다.'); return false; }
    document.getElementById('st_qty').value = newQty;
    return true;
}
document.getElementById('stockModal').addEventListener('click', function(e){ if(e.target===this) this.classList.remove('open'); });
</script>

</div><%-- layout 닫기 --%>
</body>
</html>
